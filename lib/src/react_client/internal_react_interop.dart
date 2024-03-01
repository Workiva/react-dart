/// Internal react-dart JS interop bindings and utilities.
@JS()
library react.src.react_client.internal_react_interop;

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react.dart' show Component, Component2, ComponentFactory;
import 'package:react/react_client/bridge.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart'
    show React, ReactClass, ReactComponent, ReactDartComponentInternal;
import 'package:react/src/typedefs.dart';

/// A JavaScript interop class representing a value in a React JS `context` object.
///
/// Used for storing/accessing Dart [ReactDartContextInternal] objects in `context`
/// in a way that's opaque to the JS, and avoids the need to use dart2js interceptors.
///
/// __For internal/advanced use only.__
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
/// > in ReactJS 16.
/// >
/// > This will be completely removed alongside the Component class.
@internal
@JS()
@anonymous
class InteropContextValue {
  external factory InteropContextValue();
}

/// Internal react-dart information used to proxy React JS lifecycle to Dart
/// [Component] instances.
///
/// __For internal/advanced use only.__
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
/// > in ReactJS 16.
/// >
/// > This will be completely removed alongside the Component class.
@internal
class ReactDartContextInternal {
  final dynamic value;

  ReactDartContextInternal(this.value);
}

/// Marks [child] as validated, as if it were passed into [React.createElement]
/// as a variadic child.
///
/// Offloaded to the JS to avoid dart2js interceptor lookup.
@JS('_markChildValidated')
@internal
external void markChildValidated(child);

/// Mark each child in [children] as validated so that React doesn't emit key warnings.
///
/// ___Only for use with variadic children.___
@internal
void markChildrenValidated(List<dynamic> children) {
  for (final child in children) {
    // Use `isValidElement` since `is ReactElement` doesn't behave as expected.
    if (React.isValidElement(child)) {
      markChildValidated(child);
    }
  }
}

/// Returns a new JS [ReactClass] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
@JS('_createReactDartComponentClass')
@internal
external ReactClass createReactDartComponentClass(
    ReactDartInteropStatics dartInteropStatics, ComponentStatics componentStatics,
    [JsComponentConfig? jsConfig]);

/// Returns a new JS [ReactClass] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
///
/// See `_ReactDartInteropStatics2.staticsForJs`]` for an example implementation.
@JS('_createReactDartComponentClass2')
@internal
external ReactClass createReactDartComponentClass2(JsMap dartInteropStatics, ComponentStatics2 componentStatics,
    [JsComponentConfig2? jsConfig]);

/// An object that stores static methods used by all Dart components.
@JS()
@anonymous
@internal
class ReactDartInteropStatics {
  external factory ReactDartInteropStatics({
    Component Function(
      ReactComponent jsThis,
      ReactDartComponentInternal internal,
      InteropContextValue context,
      ComponentStatics componentStatics,
    )
        initComponent,
    InteropContextValue Function(Component component) handleGetChildContext,
    void Function(Component component) handleComponentWillMount,
    void Function(Component component) handleComponentDidMount,
    void Function(
      Component component,
      ReactDartComponentInternal nextInternal,
      InteropContextValue nextContext,
    )
        handleComponentWillReceiveProps,
    bool Function(Component component, InteropContextValue nextContext) handleShouldComponentUpdate,
    void Function(Component component, InteropContextValue nextContext) handleComponentWillUpdate,
    void Function(Component component, ReactDartComponentInternal prevInternal) handleComponentDidUpdate,
    void Function(Component component) handleComponentWillUnmount,
    ReactNode Function(Component component) handleRender,
  });
}

/// An object that stores static methods and information for a specific component class.
///
/// This object is made accessible to a component's JS ReactClass config, which
/// passes it to certain methods in [ReactDartInteropStatics].
///
/// See [ReactDartInteropStatics], [createReactDartComponentClass].
@internal
class ComponentStatics {
  final ComponentFactory<Component> componentFactory;
  ComponentStatics(this.componentFactory);
}

/// An object that stores static methods and information for a specific component class.
///
/// This object is made accessible to a component's JS ReactClass config, which
/// passes it to certain methods in `ReactDartInteropStatics2`.
///
/// See `ReactDartInteropStatics2`, [createReactDartComponentClass2].
@internal
class ComponentStatics2 {
  final ComponentFactory<Component2> componentFactory;
  final Component2 instanceForStaticMethods;
  final Component2BridgeFactory bridgeFactory;

  ComponentStatics2({
    required this.componentFactory,
    required this.instanceForStaticMethods,
    required this.bridgeFactory,
  });
}

/// Additional configuration passed to [createReactDartComponentClass]
/// that needs to be directly accessible by that JS code.
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > The `context` API that this supports was never stable in any version of ReactJS,
/// > and was replaced with a new, incompatible context API in ReactJS 16 that is exposed
/// > via the [Component2] class and is supported by [JsComponentConfig2].
/// >
/// > This will be completely removed alongside the Component class.
@internal
@JS()
@anonymous
class JsComponentConfig {
  external factory JsComponentConfig({
    Iterable<String>? childContextKeys,
    Iterable<String>? contextKeys,
  });
}

/// Additional configuration passed to [createReactDartComponentClass2]
/// that needs to be directly accessible by that JS code.
@internal
@JS()
@anonymous
class JsComponentConfig2 {
  external factory JsComponentConfig2({
    required List<String> skipMethods,
    dynamic contextType,
    JsMap defaultProps,
    JsMap propTypes,
  });
}
