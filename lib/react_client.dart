// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react_client;

import "dart:async";
import "dart:collection";
import "dart:html";
import 'dart:js';
import 'dart:js_util';

import "package:js/js.dart";
import 'package:meta/meta.dart';

import "package:react/react.dart";
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/private_utils.dart';
import 'package:react/react_client/react_interop.dart';
import "package:react/react_dom.dart";
import 'package:react/react_dom_server.dart';
import 'package:react/react_client/bridge.dart';
import 'package:react/src/context.dart';
import "package:react/src/react_client/event_prop_key_to_event_factory.dart";
import 'package:react/react_client/js_backed_map.dart';
import "package:react/src/react_client/synthetic_event_wrappers.dart" as events;
import 'package:react/src/typedefs.dart';
import 'package:react/src/ddc_emulated_function_name_bug.dart' as ddc_emulated_function_name_bug;

export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory, inReactDevMode, Ref;
export 'package:react/react.dart' show ReactComponentFactoryProxy, ComponentFactory;

/// The type of `Component.ref` specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef _CallbackRef<T>(T componentOrDomNode);

/// The function signature for ReactJS Function Components.
///
/// - [props] will always be supplied as the first argument
/// - [legacyContext] has been deprecated and should not be used but remains for backward compatibility and is necessary
/// to match Dart's generated call signature based on the number of args React provides.
typedef JsFunctionComponent = dynamic Function(JsMap props, [JsMap legacyContext]);

/// Prepares [children] to be passed to the ReactJS [React.createElement] and
/// the Dart [react.Component].
///
/// Currently only involves converting a top-level non-[List] [Iterable] to
/// a non-growable [List], but this may be updated in the future to support
/// advanced nesting and other kinds of children.
dynamic listifyChildren(dynamic children) {
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

/// The zone in which React will call component lifecycle methods.
///
/// This can be used to sync a test's zone and React's component zone, ensuring that component prop callbacks and
/// lifecycle method output all occurs within the same zone as the test.
///
/// __Example:__
///
///     test('zone test', () {
///       componentZone = Zone.current;
///
///       // ... test your component
///     }
@visibleForTesting
Zone componentZone = Zone.root;

/// Use [ReactDartComponentFactoryProxy2] instead.
///
/// Will be removed when [Component] is removed in the `6.0.0` release.
@Deprecated('6.0.0')
class ReactDartComponentFactoryProxy<TComponent extends Component> extends ReactComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final ReactJsComponentFactory reactComponentFactory;

  /// The cached Dart default props retrieved from [reactClass] that are passed
  /// into [generateExtendedJsProps] upon [ReactElement] creation.
  final Map defaultProps;

  ReactDartComponentFactoryProxy(ReactClass reactClass)
      : this.reactClass = reactClass,
        this.reactComponentFactory = React.createFactory(reactClass),
        this.defaultProps = reactClass.dartDefaultProps;

  ReactClass get type => reactClass;

  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = _convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    return reactComponentFactory(generateExtendedJsProps(props, children, defaultProps: defaultProps), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static InteropProps generateExtendedJsProps(Map props, dynamic children, {Map defaultProps}) {
    if (children == null) {
      children = [];
    } else if (children is! Iterable) {
      children = [children];
    }

    // 1. Merge in defaults (if they were specified)
    // 2. Add specified props and children.
    // 3. Remove "reserved" props that should not be visible to the rendered component.

    // [1]
    Map extendedProps = (defaultProps != null ? new Map.from(defaultProps) : {})
      // [2]
      ..addAll(props)
      ..['children'] = children
      // [3]
      ..remove('key')
      ..remove('ref');

    var internal = new ReactDartComponentInternal()..props = extendedProps;

    var interopProps = new InteropProps(internal: internal);

    // Don't pass a key into InteropProps if one isn't defined, so that the value will
    // be `undefined` in the JS, which is ignored by React, whereas `null` isn't.
    if (props.containsKey('key')) {
      interopProps.key = props['key'];
    }

    if (props.containsKey('ref')) {
      var ref = props['ref'];

      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      //
      // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
      // would fail the `is _CallbackRef<dynamic>` check.
      // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
      if (ref is _CallbackRef<Null>) {
        interopProps.ref = allowInterop((ReactComponent instance) {
          // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
          // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
          return (ref as dynamic)(instance?.dartComponent);
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

/// Creates and returns a new `ReactDartFunctionComponentFactoryProxy` from the provided [dartFunctionComponent]
/// which produces a new `JsFunctionComponent`.
ReactDartFunctionComponentFactoryProxy _registerFunctionComponent(DartFunctionComponent dartFunctionComponent,
        {String displayName}) =>
    ReactDartFunctionComponentFactoryProxy(dartFunctionComponent, displayName: displayName);

@Deprecated('6.0.0')
Map<String, dynamic> _unjsifyContext(InteropContextValue interopContext) {
  // TODO consider using `contextKeys` for this if perf of objectKeys is bad.
  return new Map.fromIterable(_objectKeys(interopContext), value: (key) {
    // ignore: argument_type_not_assignable
    ReactDartContextInternal internal = getProperty(interopContext, key);
    return internal?.value;
  });
}

/// Shared component factory proxy [build] method for components that utilize [JsBackedMap]s.
mixin JsBackedMapComponentFactoryMixin on ReactComponentFactoryProxy {
  @override
  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = _generateChildren(childrenArgs, shouldAlwaysBeList: true);
    var convertedProps = generateExtendedJsProps(props);
    return React.createElement(type, convertedProps, children);
  }

  static JsMap generateExtendedJsProps(Map props) =>
      _generateJsProps(props, convertEventHandlers: false, wrapWithJsify: false);
}

/// Converts a list of variadic children arguments to children that should be passed to ReactJS.
///
/// Returns:
///
/// - `null` if there are no args and [shouldAlwaysBeList] is false
/// - `[]` if there are no args and [shouldAlwaysBeList] is true
/// - the single child if only one was specified
/// - otherwise, the same list of args, will all top-level children validated
dynamic _generateChildren(List childrenArgs, {bool shouldAlwaysBeList = false}) {
  var children;

  if (childrenArgs.isEmpty) {
    if (!shouldAlwaysBeList) return null;
    children = childrenArgs;
  } else if (childrenArgs.length == 1) {
    if (shouldAlwaysBeList) {
      final singleChild = listifyChildren(childrenArgs.single);
      if (singleChild is List) {
        children = singleChild;
      }
    } else {
      children = childrenArgs.single;
    }
  }

  if (children is Iterable && children is! List) {
    children = children.toList(growable: false);
  }

  if (children == null) {
    children = shouldAlwaysBeList ? childrenArgs.map(listifyChildren).toList() : childrenArgs;
    markChildrenValidated(children);
  }

  return children;
}

/// Converts [props] into a [JsMap] that can be utilized with [React.createElement()].
JsMap _generateJsProps(Map props,
    {bool convertEventHandlers = true,
    bool convertRefValue = true,
    bool convertCallbackRefValue = true,
    bool wrapWithJsify = true}) {
  final propsForJs = JsBackedMap.from(props);

  if (convertEventHandlers) _convertEventHandlers(propsForJs);
  if (convertRefValue) _convertRefValue2(propsForJs, convertCallbackRefValue: convertCallbackRefValue);

  return wrapWithJsify ? jsifyAndAllowInterop(propsForJs) : propsForJs.jsObject;
}

void _convertRefValue2(Map args, {bool convertCallbackRefValue = true}) {
  var ref = args['ref'];

  if (ref is Ref) {
    args['ref'] = ref.jsRef;
    // If the ref is a callback, pass ReactJS a function that will call it
    // with the Dart Component instance, not the ReactComponent instance.
    //
    // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
    // would fail the `is _CallbackRef<dynamic>` check.
    // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
  } else if (ref is _CallbackRef<Null> && convertCallbackRefValue) {
    args['ref'] = allowInterop((dynamic instance) {
      // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
      // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
      if (instance is ReactComponent && instance.dartComponent != null) return (ref as dynamic)(instance.dartComponent);
      return (ref as dynamic)(instance);
    });
  }
}

/// Creates ReactJS [Component2] instances for Dart components.
class ReactDartComponentFactoryProxy2<TComponent extends Component2> extends ReactComponentFactoryProxy
    with JsBackedMapComponentFactoryMixin
    implements ReactDartComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final ReactJsComponentFactory reactComponentFactory;

  final Map defaultProps;

  ReactDartComponentFactoryProxy2(ReactClass reactClass)
      : this.reactClass = reactClass,
        this.reactComponentFactory = React.createFactory(reactClass),
        this.defaultProps = new JsBackedMap.fromJs(reactClass.defaultProps);

  ReactClass get type => reactClass;

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static JsMap generateExtendedJsProps(Map props) =>
      _generateJsProps(props, convertEventHandlers: false, wrapWithJsify: false);
}

/// Converts a list of variadic children arguments to children that should be passed to ReactJS.
///
/// Returns:
///
/// - `null` if there are no args
/// - the single child if only one was specified
/// - otherwise, the same list of args, will all top-level children validated
dynamic _convertArgsToChildren(List childrenArgs) {
  if (childrenArgs.isEmpty) {
    return null;
  } else if (childrenArgs.length == 1) {
    return childrenArgs.single;
  } else {
    markChildrenValidated(childrenArgs);
    return childrenArgs;
  }
}

/// Util used with [_registerComponent2] to ensure no imporant lifecycle
/// events are skipped. This includes [shouldComponentUpdate],
/// [componentDidUpdate], and [render] because they utilize
/// [_updatePropsAndStateWithJs].
///
/// Returns the list of lifecycle events to skip, having removed the
/// important ones. If an important lifecycle event was set for skipping, a
/// warning is issued.
List<String> _filterSkipMethods(List<String> methods) {
  List<String> finalList = List.from(methods);
  bool shouldWarn = false;

  if (finalList.contains('shouldComponentUpdate')) {
    finalList.remove('shouldComponentUpdate');
    shouldWarn = true;
  }

  if (finalList.contains('componentDidUpdate')) {
    finalList.remove('componentDidUpdate');
    shouldWarn = true;
  }

  if (finalList.contains('render')) {
    finalList.remove('render');
    shouldWarn = true;
  }

  if (shouldWarn) {
    window.console.warn("WARNING: Crucial lifecycle methods passed into "
        "skipMethods. shouldComponentUpdate, componentDidUpdate, and render "
        "cannot be skipped and will still be added to the new component. Please "
        "remove them from skipMethods.");
  }

  return finalList;
}

@JS('Object.keys')
external List<String> _objectKeys(Object object);

@Deprecated('6.0.0')
InteropContextValue _jsifyContext(Map<String, dynamic> context) {
  var interopContext = new InteropContextValue();
  context.forEach((key, value) {
    // ignore: argument_type_not_assignable
    setProperty(interopContext, key, new ReactDartContextInternal(value));
  });

  return interopContext;
}

/// The static methods that proxy JS component lifecycle methods to Dart components.
@Deprecated('6.0.0')
final ReactDartInteropStatics _dartInteropStatics = (() {
  var zone = Zone.current;

  /// Wrapper for [Component.getInitialState].
  Component initComponent(ReactComponent jsThis, ReactDartComponentInternal internal, InteropContextValue context,
          ComponentStatics componentStatics) =>
      zone.run(() {
        void jsRedraw() {
          jsThis.setState(newObject());
        }

        RefMethod getRef = (name) {
          var ref = getProperty(jsThis.refs, name);
          if (ref == null) return null;
          if (ref is Element) return ref;

          return (ref as ReactComponent).dartComponent ?? ref;
        };

        Component component = componentStatics.componentFactory()
          ..initComponentInternal(internal.props, jsRedraw, getRef, jsThis, _unjsifyContext(context))
          ..initStateInternal();

        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.
        return component;
      });

  InteropContextValue handleGetChildContext(Component component) => zone.run(() {
        return _jsifyContext(component.getChildContext());
      });

  /// Wrapper for [Component.componentWillMount].
  void handleComponentWillMount(Component component) => zone.run(() {
        component
          ..componentWillMount()
          ..transferComponentState();
      });

  /// Wrapper for [Component.componentDidMount].
  void handleComponentDidMount(Component component) => zone.run(() {
        component.componentDidMount();
      });

  Map _getNextProps(Component component, ReactDartComponentInternal nextInternal) {
    var newProps = nextInternal.props;
    return newProps != null ? new Map.from(newProps) : {};
  }

  /// 1. Update [Component.props] using the value stored to [Component.nextProps]
  ///    in `componentWillReceiveProps`.
  /// 2. Update [Component.context] using the value stored to [Component.nextContext]
  ///    in `componentWillReceivePropsWithContext`.
  /// 3. Update [Component.state] by calling [Component.transferComponentState]
  void _afterPropsChange(Component component, InteropContextValue nextContext) {
    component
      ..props = component.nextProps // [1]
      ..context = component.nextContext // [2]
      ..transferComponentState(); // [3]
  }

  void _clearPrevState(Component component) {
    component.prevState = null;
  }

  void _callSetStateCallbacks(Component component) {
    var callbacks = component.setStateCallbacks.toList();
    // Prevent concurrent modification during iteration
    component.setStateCallbacks.clear();
    callbacks.forEach((callback) {
      callback();
    });
  }

  void _callSetStateTransactionalCallbacks(Component component) {
    var nextState = component.nextState;
    var props = new UnmodifiableMapView(component.props);

    component.transactionalSetStateCallbacks.forEach((callback) {
      final stateUpdates = callback(nextState, props);
      if (stateUpdates != null) nextState.addAll(stateUpdates);
    });
    component.transactionalSetStateCallbacks.clear();
  }

  /// Wrapper for [Component.componentWillReceiveProps].
  void handleComponentWillReceiveProps(
          Component component, ReactDartComponentInternal nextInternal, InteropContextValue nextContext) =>
      zone.run(() {
        var nextProps = _getNextProps(component, nextInternal);
        var newContext = _unjsifyContext(nextContext);

        component
          ..nextProps = nextProps
          ..nextContext = newContext
          ..componentWillReceiveProps(nextProps)
          ..componentWillReceivePropsWithContext(nextProps, newContext);
      });

  /// Wrapper for [Component.shouldComponentUpdate].
  bool handleShouldComponentUpdate(Component component, InteropContextValue nextContext) => zone.run(() {
        _callSetStateTransactionalCallbacks(component);

        // If shouldComponentUpdateWithContext returns a valid bool (default implementation returns null),
        // then don't bother calling `shouldComponentUpdate` and have it trump.
        bool shouldUpdate =
            component.shouldComponentUpdateWithContext(component.nextProps, component.nextState, component.nextContext);

        if (shouldUpdate == null) {
          shouldUpdate = component.shouldComponentUpdate(component.nextProps, component.nextState);
        }

        if (shouldUpdate) {
          return true;
        } else {
          // If component should not update, update props / transfer state because componentWillUpdate will not be called.
          _afterPropsChange(component, nextContext);
          _callSetStateCallbacks(component);
          // Clear out prevState after it's done being used so it's not retained
          _clearPrevState(component);
          return false;
        }
      });

  /// Wrapper for [Component.componentWillUpdate].
  void handleComponentWillUpdate(Component component, InteropContextValue nextContext) => zone.run(() {
        /// Call `componentWillUpdate` and the context variant
        component
          ..componentWillUpdate(component.nextProps, component.nextState)
          ..componentWillUpdateWithContext(component.nextProps, component.nextState, component.nextContext);

        _afterPropsChange(component, nextContext);
      });

  /// Wrapper for [Component.componentDidUpdate].
  ///
  /// Uses [prevState] which was transferred from [Component.nextState] in [componentWillUpdate].
  void handleComponentDidUpdate(Component component, ReactDartComponentInternal prevInternal) => zone.run(() {
        var prevInternalProps = prevInternal.props;

        /// Call `componentDidUpdate` and the context variant
        component.componentDidUpdate(prevInternalProps, component.prevState);

        _callSetStateCallbacks(component);
        // Clear out prevState after it's done being used so it's not retained
        _clearPrevState(component);
      });

  /// Wrapper for [Component.componentWillUnmount].
  void handleComponentWillUnmount(Component component) => zone.run(() {
        component.componentWillUnmount();
        // Clear these callbacks in case they retain anything;
        // they definitely won't be called after this point.
        component.setStateCallbacks.clear();
        component.transactionalSetStateCallbacks.clear();
      });

  /// Wrapper for [Component.render].
  dynamic handleRender(Component component) => zone.run(() {
        return component.render();
      });

  return new ReactDartInteropStatics(
      initComponent: allowInterop(initComponent),
      handleGetChildContext: allowInterop(handleGetChildContext),
      handleComponentWillMount: allowInterop(handleComponentWillMount),
      handleComponentDidMount: allowInterop(handleComponentDidMount),
      handleComponentWillReceiveProps: allowInterop(handleComponentWillReceiveProps),
      handleShouldComponentUpdate: allowInterop(handleShouldComponentUpdate),
      handleComponentWillUpdate: allowInterop(handleComponentWillUpdate),
      handleComponentDidUpdate: allowInterop(handleComponentDidUpdate),
      handleComponentWillUnmount: allowInterop(handleComponentWillUnmount),
      handleRender: allowInterop(handleRender));
})();

abstract class _ReactDartInteropStatics2 {
  static void _updatePropsAndStateWithJs(Component2 component, JsMap props, JsMap state) {
    component
      ..props = new JsBackedMap.backedBy(props)
      ..state = new JsBackedMap.backedBy(state);
  }

  static void _updateContextWithJs(Component2 component, dynamic jsContext) {
    component.context = ContextHelpers.unjsifyNewContext(jsContext);
  }

  static Component2 initComponent(ReactComponent jsThis, ComponentStatics2 componentStatics) => // dartfmt
      componentZone.run(() {
        final component = componentStatics.componentFactory();
        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.

        component
          ..jsThis = jsThis
          ..props = new JsBackedMap.backedBy(jsThis.props)
          ..context = ContextHelpers.unjsifyNewContext(jsThis.context);

        jsThis.state = jsBackingMapOrJsCopy(component.initialState);

        component.state = new JsBackedMap.backedBy(jsThis.state);

        // ignore: invalid_use_of_protected_member
        Component2Bridge.bridgeForComponent[component] = componentStatics.bridgeFactory(component);
        return component;
      });

  static void handleComponentDidMount(Component2 component) => // dartfmt
      componentZone.run(() {
        component.componentDidMount();
      });

  static bool handleShouldComponentUpdate(Component2 component, JsMap jsNextProps, JsMap jsNextState) => // dartfmt
      componentZone.run(() {
        final value = component.shouldComponentUpdate(
          new JsBackedMap.backedBy(jsNextProps),
          new JsBackedMap.backedBy(jsNextState),
        );

        if (!value) {
          _updatePropsAndStateWithJs(component, jsNextProps, jsNextState);
        }

        return value;
      });

  static JsMap handleGetDerivedStateFromProps(
          ComponentStatics2 componentStatics, JsMap jsNextProps, JsMap jsPrevState) => // dartfmt
      componentZone.run(() {
        var derivedState = componentStatics.instanceForStaticMethods
            .getDerivedStateFromProps(new JsBackedMap.backedBy(jsNextProps), new JsBackedMap.backedBy(jsPrevState));
        if (derivedState != null) {
          return jsBackingMapOrJsCopy(derivedState);
        }
        return null;
      });

  static dynamic handleGetSnapshotBeforeUpdate(Component2 component, JsMap jsPrevProps, JsMap jsPrevState) => // dartfmt
      componentZone.run(() {
        final snapshotValue = component.getSnapshotBeforeUpdate(
          new JsBackedMap.backedBy(jsPrevProps),
          new JsBackedMap.backedBy(jsPrevState),
        );

        return snapshotValue;
      });

  static void handleComponentDidUpdate(
          Component2 component, ReactComponent jsThis, JsMap jsPrevProps, JsMap jsPrevState,
          [dynamic snapshot]) => // dartfmt
      componentZone.run(() {
        component.componentDidUpdate(
          new JsBackedMap.backedBy(jsPrevProps),
          new JsBackedMap.backedBy(jsPrevState),
          snapshot,
        );
      });

  static void handleComponentWillUnmount(Component2 component) => // dartfmt
      componentZone.run(() {
        component.componentWillUnmount();
      });

  static void handleComponentDidCatch(Component2 component, dynamic error, ReactErrorInfo info) => // dartfmt
      componentZone.run(() {
        // Due to the error object being passed in from ReactJS it is a javascript object that does not get dartified.
        // To fix this we throw the error again from Dart to the JS side and catch it Dart side which re-dartifies it.
        try {
          throwErrorFromJS(error);
        } catch (e, stack) {
          info.dartStackTrace = stack;
          // The Dart stack track gets lost so we manually add it to the info object for reference.
          component.componentDidCatch(e, info);
        }
      });

  static JsMap handleGetDerivedStateFromError(ComponentStatics2 componentStatics, dynamic error) => // dartfmt
      componentZone.run(() {
        // Due to the error object being passed in from ReactJS it is a javascript object that does not get dartified.
        // To fix this we throw the error again from Dart to the JS side and catch it Dart side which re-dartifies it.
        try {
          throwErrorFromJS(error);
        } catch (e) {
          final result = componentStatics.instanceForStaticMethods.getDerivedStateFromError(e);
          if (result != null) return jsBackingMapOrJsCopy(result);
          return null;
        }
      });

  static dynamic handleRender(Component2 component, JsMap jsProps, JsMap jsState, dynamic jsContext) => // dartfmt
      componentZone.run(() {
        _updatePropsAndStateWithJs(component, jsProps, jsState);
        _updateContextWithJs(component, jsContext);
        return component.render();
      });

  static final JsMap staticsForJs = jsifyAndAllowInterop({
    'initComponent': initComponent,
    'handleComponentDidMount': handleComponentDidMount,
    'handleGetDerivedStateFromProps': handleGetDerivedStateFromProps,
    'handleShouldComponentUpdate': handleShouldComponentUpdate,
    'handleGetSnapshotBeforeUpdate': handleGetSnapshotBeforeUpdate,
    'handleComponentDidUpdate': handleComponentDidUpdate,
    'handleComponentWillUnmount': handleComponentWillUnmount,
    'handleComponentDidCatch': handleComponentDidCatch,
    'handleGetDerivedStateFromError': handleGetDerivedStateFromError,
    'handleRender': handleRender,
  });
}

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
@Deprecated('6.0.0')
ReactDartComponentFactoryProxy _registerComponent(
  ComponentFactory componentFactory, [
  Iterable<String> skipMethods = const ['getDerivedStateFromError', 'componentDidCatch'],
]) {
  var componentInstance = componentFactory();

  if (componentInstance is Component2) {
    return _registerComponent2(componentFactory, skipMethods: skipMethods);
  }

  var componentStatics = new ComponentStatics(componentFactory);

  var jsConfig = new JsComponentConfig(
    childContextKeys: componentInstance.childContextKeys,
    contextKeys: componentInstance.contextKeys,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass = createReactDartComponentClass(_dartInteropStatics, componentStatics, jsConfig)
    // ignore: invalid_use_of_protected_member
    ..dartComponentVersion = ReactDartComponentVersion.component
    ..displayName = componentFactory().displayName;

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final Map defaultProps = new Map.unmodifiable(componentInstance.getDefaultProps());
  reactComponentClass.dartDefaultProps = defaultProps;

  return new ReactDartComponentFactoryProxy(reactComponentClass);
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
  final Function factory;
  final bool shouldConvertDomProps;

  ReactJsContextComponentFactoryProxy(
    ReactClass jsClass, {
    this.shouldConvertDomProps: true,
    this.isConsumer: false,
    this.isProvider: false,
  })  : this.type = jsClass,
        this.factory = React.createFactory(jsClass),
        super(jsClass, shouldConvertDomProps: shouldConvertDomProps);

  @override
  ReactElement build(Map props, [List childrenArgs]) {
    dynamic children = _generateChildren(childrenArgs);

    if (isConsumer) {
      if (children is Function) {
        Function contextCallback = children;
        children = allowInterop((args) {
          return contextCallback(ContextHelpers.unjsifyNewContext(args));
        });
      }
    }

    return React.createElement(type, generateExtendedJsProps(props), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  JsMap generateExtendedJsProps(Map props) {
    JsBackedMap propsForJs = new JsBackedMap.from(props);

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

  /// The JS component factory used by this factory to build [ReactElement]s.
  final Function factory;

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

  ReactJsComponentFactoryProxy(ReactClass jsClass,
      {this.shouldConvertDomProps: true, this.alwaysReturnChildrenAsList: false})
      : this.type = jsClass,
        this.factory = React.createFactory(jsClass) {
    if (jsClass == null) {
      throw new ArgumentError('`jsClass` must not be null. '
          'Ensure that the JS component class you\'re referencing is available and being accessed correctly.');
    }
  }

  @override
  ReactElement build(Map props, [List childrenArgs]) {
    dynamic children = _generateChildren(childrenArgs, shouldAlwaysBeList: alwaysReturnChildrenAsList);
    JsMap convertedProps =
        _generateJsProps(props, convertEventHandlers: shouldConvertDomProps, convertCallbackRefValue: false);
    return React.createElement(type, convertedProps, children);
  }
}

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactDartComponentFactoryProxy2 _registerComponent2(
  ComponentFactory<Component2> componentFactory, {
  Iterable<String> skipMethods = const ['getDerivedStateFromError', 'componentDidCatch'],
  Component2BridgeFactory bridgeFactory,
}) {
  bridgeFactory ??= Component2BridgeImpl.bridgeFactory;

  final componentInstance = componentFactory();
  final componentStatics = new ComponentStatics2(
    componentFactory: componentFactory,
    instanceForStaticMethods: componentInstance,
    bridgeFactory: bridgeFactory,
  );
  final filteredSkipMethods = _filterSkipMethods(skipMethods);

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final JsBackedMap defaultProps = new JsBackedMap.from(componentInstance.defaultProps);

  final JsMap jsPropTypes =
      bridgeFactory(componentInstance).jsifyPropTypes(componentInstance, componentInstance.propTypes);

  var jsConfig2 = new JsComponentConfig2(
    defaultProps: defaultProps.jsObject,
    contextType: componentInstance.contextType?.jsThis,
    skipMethods: filteredSkipMethods,
    propTypes: jsPropTypes,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass =
      createReactDartComponentClass2(_ReactDartInteropStatics2.staticsForJs, componentStatics, jsConfig2)
        ..displayName = componentInstance.displayName;
  // ignore: invalid_use_of_protected_member
  reactComponentClass.dartComponentVersion = ReactDartComponentVersion.component2;

  return new ReactDartComponentFactoryProxy2(reactComponentClass);
}

/// Creates ReactJS [ReactElement] instances for DOM components.
class ReactDomComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The name of the proxied DOM component.
  ///
  /// E.g. `'div'`, `'a'`, `'h1'`
  final String name;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final Function factory;

  ReactDomComponentFactoryProxy(name)
      : this.name = name,
        this.factory = React.createFactory(name) {
    // TODO: Should we remove this once we validate that the bug is gone in Dart 2 DDC?
    if (ddc_emulated_function_name_bug.isBugPresent) {
      ddc_emulated_function_name_bug.patchName(this);
    }
  }

  @override
  String get type => name;

  @override
  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = _generateChildren(childrenArgs);
    var convertedProps = _generateJsProps(props, convertCallbackRefValue: false, wrapWithJsify: true);
    return React.createElement(type, convertedProps, children);
  }

  /// Performs special handling of certain props for consumption by ReactJS DOM components.
  static void convertProps(Map props) {
    _convertEventHandlers(props);
    _convertRefValue(props);
  }
}

/// Creates ReactJS [Function Component] from Dart Function.
class ReactDartFunctionComponentFactoryProxy extends ReactComponentFactoryProxy with JsBackedMapComponentFactoryMixin {
  /// The name of this function.
  final String displayName;

  /// The React JS component definition of this Function Component.
  final JsFunctionComponent reactFunction;

  ReactDartFunctionComponentFactoryProxy(DartFunctionComponent dartFunctionComponent, {String displayName})
      : this.displayName = displayName ?? getJsFunctionName(dartFunctionComponent),
        this.reactFunction = _wrapFunctionComponent(dartFunctionComponent,
            displayName: displayName ?? getJsFunctionName(dartFunctionComponent));

  @override
  JsFunctionComponent get type => reactFunction;

  /// Creates a function component from the given [dartFunctionComponent] that can be used with React.
  ///
  /// [displayName] Sets the component name for debugging purposes.
  ///
  /// In DDC, this will be the [DartFunctionComponent] name, but in dart2js it will be null unless
  /// overridden, since using runtimeType can lead to larger dart2js output.
  ///
  /// This will result in the dart2js name being `ReactDartComponent2` (the
  /// name of the proxying JS component defined in _dart_helpers.js).
  static JsFunctionComponent _wrapFunctionComponent(DartFunctionComponent dartFunctionComponent, {String displayName}) {
    // dart2js uses null and undefined interchangeably, meaning returning `null` from dart
    // may show up in js as `undefined`, ReactJS doesnt like that and expects a js `null` to be returned,
    // and throws if it gets `undefined`. `jsNull` is an interop variable that holds a JS `null` value
    // to force `null` as the return value if user returns a Dart `null`.
    // See: https://github.com/dart-lang/sdk/issues/27485
    jsFunctionComponent(JsMap jsProps, [JsMap _legacyContext]) =>
        dartFunctionComponent(JsBackedMap.backedBy(jsProps)) ?? jsNull;
    JsFunctionComponent interopFunction = allowInterop(jsFunctionComponent);
    if (displayName != null) {
      // This is a work-around to display the correct name in the React DevTools.
      defineProperty(interopFunction, 'name', jsify({'value': displayName}));
    }
    // ignore: invalid_use_of_protected_member
    setProperty(interopFunction, 'dartComponentVersion', ReactDartComponentVersion.component2);
    return interopFunction;
  }
}

/// Create react-dart registered component for the HTML [Element].
_reactDom(String name) {
  return new ReactDomComponentFactoryProxy(name);
}

void _convertRefValue(Map args) {
  var ref = args['ref'];
  if (ref is Ref) {
    args['ref'] = ref.jsRef;
  }
}

/// A mapping from converted/wrapped JS handler functions (the result of [_convertEventHandlers])
/// to the original Dart functions (the input of [_convertEventHandlers]).
final Expando<Function> _originalEventHandlers = new Expando();

/// Returns the props for a [ReactElement] or composite [ReactComponent] [instance],
/// shallow-converted to a Dart Map for convenience.
///
/// If `style` is specified in props, then it too is shallow-converted and included
/// in the returned Map.
///
/// Any JS event handlers included in the props for the given [instance] will be
/// unconverted such that the original JS handlers are returned instead of their
/// Dart synthetic counterparts.
Map unconvertJsProps(/* ReactElement|ReactComponent */ instance) {
  var props = Map.from(JsBackedMap.backedBy(instance.props));

  // Catch if a Dart component has been passed in. Component (version 1) can be identified by having the "internal"
  // prop. Component2, however, does not have that but can be detected by checking whether or not the style prop is a
  // Map. Because non-Dart components will have a JS Object, it can be assumed that if the style prop is a Map then
  // it is a Dart Component.
  if (props['internal'] is ReactDartComponentInternal || (props['style'] != null && props['style'] is Map)) {
    throw new ArgumentError('A Dart Component cannot be passed into unconvertJsProps.');
  }

  eventPropKeyToEventFactory.keys.forEach((key) {
    if (props.containsKey(key)) {
      props[key] = unconvertJsEventHandler(props[key]) ?? props[key];
    }
  });

  // Convert the nested style map so it can be read by Dart code.
  var style = props['style'];
  if (style != null) {
    props['style'] = Map<String, dynamic>.from(JsBackedMap.backedBy(style));
  }

  return props;
}

/// Returns the original Dart handler function that, within [_convertEventHandlers],
/// was converted/wrapped into the function [jsConvertedEventHandler] to be passed to the JS.
///
/// Returns `null` if [jsConvertedEventHandler] is `null`.
///
/// Returns `null` if [jsConvertedEventHandler] does not represent such a function
///
/// Useful for chaining event handlers on DOM or JS composite [ReactElement]s.
Function unconvertJsEventHandler(Function jsConvertedEventHandler) {
  if (jsConvertedEventHandler == null) return null;

  return _originalEventHandlers[jsConvertedEventHandler];
}

/// Convert packed event handler into wrapper and pass it only the Dart [SyntheticEvent] object converted from the
/// [events.SyntheticEvent] event.
_convertEventHandlers(Map args) {
  args.forEach((propKey, value) {
    var eventFactory = eventPropKeyToEventFactory[propKey];
    if (eventFactory != null && value != null) {
      final handlerHasAlreadyBeenConverted = unconvertJsEventHandler(value) != null;
      if (!handlerHasAlreadyBeenConverted && !(isRawJsFunctionFromProps[value] ?? false)) {
        // Apply allowInterop here so that the function we store in [_originalEventHandlers]
        // is the same one we'll retrieve from the JS props.
        var reactDartConvertedEventHandler = allowInterop((e, [_, __]) {
          // To support Dart code calling converted handlers,
          // check for Dart events and pass them through directly.
          // Otherwise, convert the JS events like normal.
          if (e is SyntheticEvent) {
            value(e);
          } else {
            value(eventFactory(e as events.SyntheticEvent));
          }
        });

        args[propKey] = reactDartConvertedEventHandler;
        _originalEventHandlers[reactDartConvertedEventHandler] = value;
      }
    }
  });
}

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(events.SyntheticEvent e) {
  return new SyntheticEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(events.SyntheticClipboardEvent e) {
  return new SyntheticClipboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.clipboardData);
}

/// Wrapper for [SyntheticKeyboardEvent].
SyntheticKeyboardEvent syntheticKeyboardEventFactory(events.SyntheticKeyboardEvent e) {
  return new SyntheticKeyboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.altKey,
      e.char,
      e.charCode,
      e.ctrlKey,
      e.locale,
      e.location,
      e.key,
      e.keyCode,
      e.metaKey,
      e.repeat,
      e.shiftKey);
}

/// Wrapper for [SyntheticFocusEvent].
SyntheticFocusEvent syntheticFocusEventFactory(events.SyntheticFocusEvent e) {
  return new SyntheticFocusEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.relatedTarget);
}

/// Wrapper for [SyntheticFormEvent].
SyntheticFormEvent syntheticFormEventFactory(events.SyntheticFormEvent e) {
  return new SyntheticFormEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticDataTransfer].
///
/// [dt] is typed as Object instead of [dynamic] to avoid dynamic calls in the method body,
/// ensuring the code is statically sound.
SyntheticDataTransfer syntheticDataTransferFactory(Object dt) {
  if (dt == null) return null;

  List rawFiles;
  List rawTypes;

  String effectAllowed;
  String dropEffect;

  // Handle `dt` being either a native DOM DataTransfer object or a JS object that looks like it (events.NonNativeDataTransfer).
  // Casting a JS object to DataTransfer fails intermittently in dart2js, and vice-versa fails intermittently in either DDC or dart2js.
  // TODO figure out when NonNativeDataTransfer is used.
  //
  // Some logic here is duplicated to ensure statically-sound access of same-named members.
  if (dt is DataTransfer) {
    rawFiles = dt.files;
    rawTypes = dt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = dt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = dt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  } else {
    // Assume it's a NonNativeDataTransfer otherwise.
    // Perform a cast inside `else` instead of an `else if (dt is ...)` since is-checks for
    // anonymous JS objects have undefined behavior.
    final castedDt = dt as events.NonNativeDataTransfer;

    rawFiles = castedDt.files;
    rawTypes = castedDt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = castedDt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = castedDt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  }

  // Copy these lists and ensure they're typed properly.
  // todo use .cast() in Dart 2
  final files = <File>[];
  final types = <String>[];
  rawFiles?.forEach(files.add);
  rawTypes?.forEach(types.add);

  return new SyntheticDataTransfer(dropEffect, effectAllowed, files, types);
}

/// Wrapper for [SyntheticPointerEvent].
SyntheticPointerEvent syntheticPointerEventFactory(events.SyntheticPointerEvent e) {
  return new SyntheticPointerEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.pointerId,
    e.width,
    e.height,
    e.pressure,
    e.tangentialPressure,
    e.tiltX,
    e.tiltY,
    e.twist,
    e.pointerType,
    e.isPrimary,
  );
}

/// Wrapper for [SyntheticMouseEvent].
SyntheticMouseEvent syntheticMouseEventFactory(events.SyntheticMouseEvent e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e.dataTransfer);
  return new SyntheticMouseEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.button,
    e.buttons,
    e.clientX,
    e.clientY,
    e.ctrlKey,
    dt,
    e.metaKey,
    e.pageX,
    e.pageY,
    e.relatedTarget,
    e.screenX,
    e.screenY,
    e.shiftKey,
  );
}

/// Wrapper for [SyntheticTouchEvent].
SyntheticTouchEvent syntheticTouchEventFactory(events.SyntheticTouchEvent e) {
  return new SyntheticTouchEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.changedTouches,
    e.ctrlKey,
    e.metaKey,
    e.shiftKey,
    e.targetTouches,
    e.touches,
  );
}

/// Wrapper for [SyntheticTransitionEvent].
SyntheticTransitionEvent syntheticTransitionEventFactory(events.SyntheticTransitionEvent e) {
  return new SyntheticTransitionEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.propertyName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticAnimationEvent].
SyntheticAnimationEvent syntheticAnimationEventFactory(events.SyntheticAnimationEvent e) {
  return new SyntheticAnimationEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.animationName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticUIEvent].
SyntheticUIEvent syntheticUIEventFactory(events.SyntheticUIEvent e) {
  return new SyntheticUIEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.detail,
    e.view,
  );
}

/// Wrapper for [SyntheticWheelEvent].
SyntheticWheelEvent syntheticWheelEventFactory(events.SyntheticWheelEvent e) {
  return new SyntheticWheelEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.deltaX,
    e.deltaMode,
    e.deltaY,
    e.deltaZ,
  );
}

dynamic _findDomNode(component) {
  return ReactDom.findDOMNode(component is Component ? component.jsThis : component);
}

void setClientConfiguration() {
  try {
    // Attempt to invoke JS interop methods, which will throw if the
    // corresponding JS functions are not available.
    React.isValidElement(null);
    ReactDom.findDOMNode(null);
    createReactDartComponentClass(null, null, null);
  } on NoSuchMethodError catch (_) {
    throw new Exception('react.js and react_dom.js must be loaded.');
  } catch (_) {
    throw new Exception('Loaded react.js must include react-dart JS interop helpers.');
  }

  setReactConfiguration(_reactDom, _registerComponent,
      customRegisterComponent2: _registerComponent2, customRegisterFunctionComponent: _registerFunctionComponent);
  setReactDOMConfiguration(ReactDom.render, ReactDom.unmountComponentAtNode, _findDomNode);
  // Accessing ReactDomServer.renderToString when it's not available breaks in DDC.
  if (context['ReactDOMServer'] != null) {
    setReactDOMServerConfiguration(ReactDomServer.renderToString, ReactDomServer.renderToStaticMarkup);
  }
}
