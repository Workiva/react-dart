library react_client.component_factory;

import 'dart:js';
import 'dart:js_util';

import 'package:js/js.dart';

import 'package:react/react.dart';
import 'package:react/react_client.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/src/js_interop_util.dart';
import 'package:react/src/react_client/factory_util.dart';

// ignore: deprecated_member_use_from_same_package
export 'package:react/src/react_client/factory_util.dart' show generateJsProps;

/// Prepares [children] to be passed to the ReactJS [React.createElement] and
/// the Dart [Component2].
///
/// Currently only involves converting a top-level non-[List] [Iterable] to
/// a non-growable [List], but this may be updated in the future to support
/// advanced nesting and other kinds of children.
ReactNode listifyChildren(ReactNode children) {
  if (React.isValidElement(children)) {
    // Short-circuit if we're dealing with a ReactElement to avoid the dart2js
    // interceptor lookup involved in Dart type-checking.
    return children;
  } else if (children is Iterable && children is! List) {
    return children.toList(growable: false);
  } else {
    return children;
  }
}

/// Returns the props for a [ReactElement] or composite [ReactComponent] [instance],
/// shallow-converted to a Dart Map for convenience.
///
/// If `style` is specified in props, then it too is shallow-converted and included
/// in the returned Map.
Map unconvertJsProps(/* ReactElement|ReactComponent */ instance) {
  final props = Map.from(JsBackedMap.backedBy(instance.props as JsMap));

  // Catch if a Dart component has been passed in. Component (version 1) can be identified by having the "internal"
  // prop. Component2, however, does not have that but can be detected by checking whether or not the style prop is a
  // Map. Because non-Dart components will have a JS Object, it can be assumed that if the style prop is a Map then
  // it is a Dart Component.
  // ignore: deprecated_member_use_from_same_package
  if (props['internal'] is ReactDartComponentInternal || (props['style'] != null && props['style'] is Map)) {
    throw ArgumentError('A Dart Component cannot be passed into unconvertJsProps.');
  }

  // Convert the nested style map so it can be read by Dart code.
  final style = props['style'];
  if (style != null) {
    props['style'] = Map<String, dynamic>.from(JsBackedMap.backedBy(style as JsMap));
  }

  return props;
}

/// Shared component factory proxy [build] method for components that utilize [JsBackedMap]s.
mixin JsBackedMapComponentFactoryMixin on ReactComponentFactoryProxy {
  @override
  ReactElement build(Map props, [List<ReactNode> childrenArgs = const []]) {
    final children = generateChildren(childrenArgs, shouldAlwaysBeList: true);
    final convertedProps = generateExtendedJsProps(props);
    return React.createElement(type, convertedProps, children);
  }

  static JsMap generateExtendedJsProps(Map props) => generateJsProps(props, wrapWithJsify: false);
}

@Deprecated('Only used with the deprecated Component base class and not Component2,'
    ' which uses ReactDartComponentFactoryProxy2. Will be removed along with Component.')
class ReactDartComponentFactoryProxy<TComponent extends Component> extends ReactComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The cached Dart default props retrieved from [reactClass] that are passed
  /// into [generateExtendedJsProps] upon [ReactElement] creation.
  final Map defaultProps;

  ReactDartComponentFactoryProxy(this.reactClass) : defaultProps = reactClass.dartDefaultProps!;

  @override
  ReactClass get type => reactClass;

  @override
  ReactElement build(Map props, [List<ReactNode> childrenArgs = const []]) {
    var children = convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    return React.createElement(type, generateExtendedJsProps(props, children, defaultProps: defaultProps), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the `react` library internals.
  static InteropProps generateExtendedJsProps(Map props, ReactNode children, {Map? defaultProps}) {
    if (children == null) {
      children = [];
    } else if (children is! Iterable) {
      children = [children];
    }

    // 1. Merge in defaults (if they were specified)
    // 2. Add specified props and children.
    // 3. Remove "reserved" props that should not be visible to the rendered component.

    // [1]
    final extendedProps = (defaultProps != null ? Map.from(defaultProps) : {})
      // [2]
      ..addAll(props)
      ..['children'] = children
      // [3]
      ..remove('key')
      ..remove('ref');

    final internal = ReactDartComponentInternal(extendedProps);

    final interopProps = InteropProps(internal: internal);

    // Don't pass a key into InteropProps if one isn't defined, so that the value will
    // be `undefined` in the JS, which is ignored by React, whereas `null` isn't.
    if (props.containsKey('key')) {
      interopProps.key = props['key'];
    }

    if (props.containsKey('ref')) {
      final ref = props['ref'];

      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      //
      // Use CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
      // would fail the `is CallbackRef<dynamic>` check.
      // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
      // ignore: prefer_void_to_null
      if (ref is Function(Never)) {
        assert(!isRefArgumentDefinitelyNonNullable(ref), nonNullableCallbackRefArgMessage);
        interopProps.ref = allowInterop((dynamic instance) {
          // Call as dynamic to perform dynamic dispatch, since we can't cast to CallbackRef<dynamic>,
          // and since calling with non-null values will fail at runtime due to the CallbackRef<Null> typing.
          if (instance is ReactComponent && instance.dartComponent != null) {
            return (ref as dynamic)(instance.dartComponent);
          }

          return (ref as dynamic)(instance);
        });
      } else if (ref is Ref) {
        interopProps.ref = ref.jsRef;
      } else {
        interopProps.ref = ref;
      }
    }

    return interopProps;
  }
}

/// Creates ReactJS [Component2] instances for Dart components.
///
/// > Related: [registerComponent2]
class ReactDartComponentFactoryProxy2<TComponent extends Component2> extends ReactComponentFactoryProxy
    with
        JsBackedMapComponentFactoryMixin
    implements
        // ignore: deprecated_member_use_from_same_package
        ReactDartComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  @override
  final ReactClass reactClass;

  @override
  final Map defaultProps;

  ReactDartComponentFactoryProxy2(this.reactClass)
      // While .defaultProps will be non-null on all Dart components created via registerComponent2,
      // there are some valid usages of ReactDartComponentFactoryProxy2 (such as within over_react's connect)
      // where we're dealing with other components, so we can't assume this is non-null
      : defaultProps = JsBackedMap.fromJs(reactClass.defaultProps ?? JsMap());

  @override
  ReactClass get type => reactClass;

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the `react` library internals.
  static JsMap generateExtendedJsProps(Map props) => generateJsProps(props, wrapWithJsify: false);
}

/// Creates ReactJS [ReactElement] instances for `JSContext` components.
///
/// Adds special jsifying and unjsifying of the `value` prop.
class ReactJsContextComponentFactoryProxy extends ReactJsComponentFactoryProxy {
  /// The JS class used by this factory.
  @override
  final ReactClass type;
  final bool isConsumer;
  final bool isProvider;
  @override
  final bool shouldConvertDomProps;

  ReactJsContextComponentFactoryProxy(
    ReactClass jsClass, {
    this.shouldConvertDomProps = true,
    this.isConsumer = false,
    this.isProvider = false,
  })  : type = jsClass,
        super(jsClass, shouldConvertDomProps: shouldConvertDomProps);

  @override
  ReactElement build(Map props, [List<ReactNode> childrenArgs = const []]) {
    var children = generateChildren(childrenArgs);

    if (isConsumer) {
      if (children is Function) {
        final contextCallback = children;
        children = allowInterop((args) {
          return contextCallback(ContextHelpers.unjsifyNewContext(args));
        });
      }
    }

    return React.createElement(type, generateExtendedJsProps(props), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the `react` library internals.
  JsMap generateExtendedJsProps(Map props) {
    final propsForJs = JsBackedMap.from(props);

    if (isProvider) {
      propsForJs['value'] = ContextHelpers.jsifyNewContext(propsForJs['value']);
    }

    return propsForJs.jsObject;
  }
}

/// Creates ReactJS [ReactElement] instances for components defined in the JS.
class ReactJsComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The JS class used by this factory.
  @override
  final ReactClass type;

  /// Whether to automatically prepare props relating to bound values and event handlers
  /// via [ReactDomComponentFactoryProxy.convertProps] for consumption by React JS DOM components.
  ///
  /// Useful when the JS component forwards DOM props to its rendered DOM components.
  ///
  /// Disable for more custom handling of these props.
  final bool shouldConvertDomProps;

  /// Whether the props.children should always be treated as a list or not.
  /// Default: `false`
  final bool alwaysReturnChildrenAsList;

  final List<String> _additionalRefPropKeys;

  ReactJsComponentFactoryProxy(
    ReactClass jsClass, {
    this.shouldConvertDomProps = true,
    this.alwaysReturnChildrenAsList = false,
    List<String> additionalRefPropKeys = const [],
  })  : type = jsClass,
        _additionalRefPropKeys = additionalRefPropKeys {
    ArgumentError.checkNotNull(jsClass, 'jsClass');
  }

  @override
  ReactElement build(Map props, [List<ReactNode> childrenArgs = const []]) {
    final children = generateChildren(childrenArgs, shouldAlwaysBeList: alwaysReturnChildrenAsList);
    final convertedProps =
        generateJsProps(props, convertCallbackRefValue: false, additionalRefPropKeys: _additionalRefPropKeys);
    return React.createElement(type, convertedProps, children);
  }
}

/// Creates ReactJS [ReactElement] instances for DOM components.
class ReactDomComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The name of the proxied DOM component.
  ///
  /// E.g. `'div'`, `'a'`, `'h1'`
  final String name;

  ReactDomComponentFactoryProxy(this.name);

  @override
  String get type => name;

  @override
  ReactElement build(Map props, [List<ReactNode> childrenArgs = const []]) {
    final children = generateChildren(childrenArgs);
    final convertedProps = generateJsProps(props, convertCallbackRefValue: false, wrapWithJsify: true);
    return React.createElement(type, convertedProps, children);
  }

  /// Performs special handling of certain props for consumption by ReactJS DOM components.
  static void convertProps(Map props) {
    convertRefValue(props);
  }
}

/// Creates ReactJS [Function Component] from Dart Function.
class ReactDartFunctionComponentFactoryProxy extends ReactComponentFactoryProxy with JsBackedMapComponentFactoryMixin {
  /// The name of this function.
  final String? displayName;

  /// The React JS component definition of this Function Component.
  final JsFunctionComponent reactFunction;

  ReactDartFunctionComponentFactoryProxy(DartFunctionComponent dartFunctionComponent, {String? displayName})
      : displayName = displayName ?? getJsFunctionName(dartFunctionComponent),
        reactFunction = _wrapFunctionComponent(dartFunctionComponent,
            displayName: displayName ?? getJsFunctionName(dartFunctionComponent));

  @override
  JsFunctionComponent get type => reactFunction;
}

/// A wrapper for a Dart component that's been wrapped by a JS component/HOC (e.g., [React.memo], [React.forwardRef]).
class ReactDartWrappedComponentFactoryProxy extends ReactComponentFactoryProxy with JsBackedMapComponentFactoryMixin {
  /// The React JS component definition of this Function Component.
  @override
  final ReactClass type;

  ReactDartWrappedComponentFactoryProxy(this.type);

  ReactDartWrappedComponentFactoryProxy.forwardRef(DartForwardRefFunctionComponent dartFunctionComponent,
      {String? displayName})
      : type = _wrapForwardRefFunctionComponent(dartFunctionComponent,
            displayName: displayName ?? getJsFunctionName(dartFunctionComponent));
}

/// Creates a function component from the given [dartFunctionComponent] that can be used with React.
///
/// [displayName] Sets the component name for debugging purposes.
///
/// In DDC, this will be the [DartFunctionComponent] name, but in dart2js it will be null unless
/// overridden, since using runtimeType can lead to larger dart2js output.
JsFunctionComponent _wrapFunctionComponent(DartFunctionComponent dartFunctionComponent, {String? displayName}) {
  // dart2js uses null and undefined interchangeably, meaning returning `null` from dart
  // may show up in js as `undefined`, ReactJS doesnt like that and expects a js `null` to be returned,
  // and throws if it gets `undefined`. `jsNull` is an interop variable that holds a JS `null` value
  // to force `null` as the return value if user returns a Dart `null`.
  // See: https://github.com/dart-lang/sdk/issues/27485
  jsFunctionComponent(JsMap jsProps, [JsMap? _legacyContext]) =>
      // ignore: invalid_use_of_visible_for_testing_member
      componentZone.run(() => dartFunctionComponent(JsBackedMap.backedBy(jsProps)) ?? jsNull);
  // ignore: omit_local_variable_types
  final JsFunctionComponent interopFunction = allowInterop(jsFunctionComponent);
  if (displayName != null) {
    // This is a work-around to display the correct name in the React DevTools and error boundary component stacks.
    defineProperty(interopFunction, 'name', JsPropertyDescriptor(value: displayName));
  }
  // ignore: invalid_use_of_protected_member
  setProperty(interopFunction, 'dartComponentVersion', ReactDartComponentVersion.component2);
  return interopFunction;
}

/// Creates a function component from the given [dartFunctionComponent] that can be used with React.
///
/// [displayName] Sets the component name for debugging purposes.
///
/// In DDC, this will be the [DartFunctionComponent] name, but in dart2js it will be null unless
/// overridden, since using runtimeType can lead to larger dart2js output.
ReactClass _wrapForwardRefFunctionComponent(DartForwardRefFunctionComponent dartFunctionComponent,
    {String? displayName}) {
  // dart2js uses null and undefined interchangeably, meaning returning `null` from dart
  // may show up in js as `undefined`, ReactJS doesnt like that and expects a js `null` to be returned,
  // and throws if it gets `undefined`. `jsNull` is an interop variable that holds a JS `null` value
  // to force `null` as the return value if user returns a Dart `null`.
  // See: https://github.com/dart-lang/sdk/issues/27485
  jsFunctionComponent(JsMap props, dynamic ref) =>
      // ignore: invalid_use_of_visible_for_testing_member
      componentZone.run(() => dartFunctionComponent(JsBackedMap.backedBy(props), ref) ?? jsNull);

  final interopFunction = allowInterop(jsFunctionComponent);
  if (displayName != null) {
    // This is a work-around to display the correct name in the React DevTools and error boundary component stacks.
    defineProperty(interopFunction, 'name', JsPropertyDescriptor(value: displayName));
  }
  final jsForwardRefFunction = React.forwardRef(interopFunction);
  // ignore: invalid_use_of_protected_member
  setProperty(jsForwardRefFunction, 'dartComponentVersion', ReactDartComponentVersion.component2);
  return jsForwardRefFunction;
}
