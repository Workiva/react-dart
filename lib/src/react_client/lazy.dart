import 'dart:js';
import 'dart:js_util';

import 'package:react/react.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/js_interop_util.dart';

/// Defer loading a component's code until it is rendered for the first time.
///
/// The `lazy` function is used to create lazy components in react-dart. Lazy components are able to run asynchronous code only when they are trying to be rendered for the first time, allowing for deferred loading of the component's code.
///
/// To use the `lazy` function, you need to wrap the lazy component with a `Suspense` component. The `Suspense` component allows you to specify what should be displayed while the lazy component is loading, such as a loading spinner or a placeholder.
///
/// Example usage:
/// ```dart
/// import 'package:react/react.dart' show lazy, Suspense;
/// import './simple_component.dart' deferred as simple;
///
/// final lazyComponent = lazy(() async {
///   await simple.loadLibrary();
///   return simple.SimpleComponent;
/// });
///
/// // Wrap the lazy component with Suspense
/// final app = Suspense(
///   {
///     fallback: 'Loading...',
///   },
///   lazyComponent({}),
/// );
/// ```
///
/// Defer loading a component’s code until it is rendered for the first time.
///
/// Lazy components need to be wrapped with `Suspense` to render.
/// `Suspense` also allows you to specify what should be displayed while the lazy component is loading.
ReactComponentFactoryProxy lazy(Future<ReactComponentFactoryProxy> Function() load) {
  final hoc = React.lazy(
    allowInterop(
      () => futureToPromise(
        Future.sync(() async {
          final factory = await load();
          // By using a wrapper uiForwardRef it ensures that we have a matching factory proxy type given to react-dart's lazy,
          // a `ReactDartWrappedComponentFactoryProxy`. This is necessary to have consistent prop conversions since we don't
          // have access to the original factory proxy outside of this async block.
          final wrapper = forwardRef2((props, ref) {
            final children = props['children'];
            return factory.build(
              {...props, 'ref': ref},
              [
                if (children != null && !(children is List && children.isEmpty)) children,
              ],
            );
          }, displayName: 'LazyWrapper(${_getComponentName(factory.type) ?? 'Anonymous'})');
          return jsify({'default': wrapper.type});
        }),
      ),
    ),
  );

  // Setting this version and wrapping with ReactDartWrappedComponentFactoryProxy
  // is only okay because it matches the version and factory proxy of the wrapperFactory above.
  // ignore: invalid_use_of_protected_member
  setProperty(hoc, 'dartComponentVersion', ReactDartComponentVersion.component2);
  return ReactDartWrappedComponentFactoryProxy(hoc);
}

String? _getComponentName(Object? type) {
  if (type == null) return null;

  if (type is String) return type;

  final name = getProperty(type, 'name');
  if (name is String) return name;

  final displayName = getProperty(type, 'displayName');
  if (displayName is String) return displayName;

  return null;
}
