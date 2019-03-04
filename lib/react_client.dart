// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library react_client;

import "dart:async";
import "dart:collection";
import "dart:html";
import 'dart:js';

import "package:js/js.dart";
import "package:react/react.dart";
import "package:react/react_client/js_interop_helpers.dart";
import 'package:react/react_client/react_interop.dart';
import "package:react/react_dom.dart";
import "package:react/react_dom_server.dart";
import "package:react/src/react_client/event_prop_key_to_event_factory.dart";
import 'package:react/src/react_client/js_backed_map.dart';
import "package:react/src/react_client/synthetic_event_wrappers.dart" as events;
import 'package:react/src/typedefs.dart';
import 'package:react/src/ddc_emulated_function_name_bug.dart'
    as ddc_emulated_function_name_bug;

export 'package:react/react_client/react_interop.dart'
    show ReactElement, ReactJsComponentFactory, inReactDevMode;
export 'package:react/react.dart'
    show ReactComponentFactoryProxy, ComponentFactory;

final EmptyObject emptyJsMap = new EmptyObject();

/// __Deprecated. Will be removed in the `5.0.0` release.__ Use [ReactComponentFactoryProxy] instead.
///
/// __You should discontinue use of this, and all typedefs for the return value of [registerComponent].__
///
///     // Don't do this
///     ReactComponentFactory customComponent = registerComponent(() => new CustomComponent());
///
///     // Do this.
///     var customComponent = registerComponent(() => new CustomComponent());
///
/// > Type of [children] must be child or list of children, when child is [ReactElement] or [String]
@Deprecated('5.0.0')
typedef ReactElement ReactComponentFactory(Map props, [dynamic children]);

/// The type of [Component.ref] specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef _CallbackRef(componentOrDomNode);

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

/// Creates ReactJS [Component] instances for Dart components.
class ReactDartComponentFactoryProxy<TComponent extends Component>
    extends ReactComponentFactoryProxy {
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

    return reactComponentFactory(
        generateExtendedJsProps(props, children, defaultProps: defaultProps),
        children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static InteropProps generateExtendedJsProps(Map props, dynamic children,
      {Map defaultProps}) {
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
      if (ref is _CallbackRef) {
        interopProps.ref = allowInterop(
            (ReactComponent instance) => ref(instance?.dartComponent));
      } else {
        interopProps.ref = ref;
      }
    }

    return interopProps;
  }
}

/// Creates ReactJS [Component] instances for Dart components.
class ReactDartComponentFactoryProxy2<TComponent extends Component>
    extends ReactComponentFactoryProxy
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

  ReactElement build(Map props, [List childrenArgs = const []]) {
    // TODO if we don't pass in a list into React, we don't get a list back in Dart...

    List children;
    if (childrenArgs.isEmpty) {
      children = childrenArgs;
    } else if (childrenArgs.length == 1) {
      final singleChild = listifyChildren(childrenArgs[0]);
      if (singleChild is List) {
        children = singleChild;
      }
    }

    if (children == null) {
      // FIXME are we cool to modify this list?
      // FIXME why are there unmofiable lists here?
      children = childrenArgs.map(listifyChildren).toList();
      markChildrenValidated(children);
    }

    return reactComponentFactory(
      generateExtendedJsProps(props),
      children,
    );
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static JsMap generateExtendedJsProps(Map props) {
    final propsForJs = new JsBackedMap.from(props);

    // FIXME forwarded DOM props???

    final ref = propsForJs['ref'];
    if (ref != null) {
      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      if (ref is _CallbackRef) {
        propsForJs['ref'] = allowInterop(
            (ReactComponent instance) => ref(instance?.dartComponent));
      }
    }

    return propsForJs.jsObject;
  }
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

@JS('Object.keys')
external List<String> _objectKeys(Object object);

InteropContextValue _jsifyContext(Map<String, dynamic> context) {
  var interopContext = new InteropContextValue();
  context.forEach((key, value) {
    setProperty(interopContext, key, new ReactDartContextInternal(value));
  });

  return interopContext;
}

Map<String, dynamic> _unjsifyContext(InteropContextValue interopContext) {
  // TODO consider using `contextKeys` for this if perf of objectKeys is bad.
  return new Map.fromIterable(_objectKeys(interopContext), value: (key) {
    ReactDartContextInternal internal = getProperty(interopContext, key);
    return internal?.value;
  });
}

/// The static methods that proxy JS component lifecycle methods to Dart components.
final ReactDartInteropStatics _dartInteropStatics = (() {
  var zone = Zone.current;

  /// Wrapper for [Component.getInitialState].
  Component initComponent(
          ReactComponent jsThis,
          ReactDartComponentInternal internal,
          InteropContextValue context,
          ComponentStatics componentStatics) =>
      zone.run(() {
        void jsRedraw() {
          jsThis.setState(emptyJsMap);
        }

        Ref getRef = (name) {
          var ref = getProperty(jsThis.refs, name);
          if (ref == null) return null;
          if (ref is Element) return ref;

          return (ref as ReactComponent).dartComponent ?? ref;
        };

        Component component = componentStatics.componentFactory()
          ..initComponentInternal(internal.props, jsRedraw, getRef, jsThis,
              _unjsifyContext(context))
          ..initStateInternal();

        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.
        return component;
      });

  InteropContextValue handleGetChildContext(Component component) =>
      zone.run(() {
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

  Map _getNextProps(
      Component component, ReactDartComponentInternal nextInternal) {
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
      nextState.addAll(callback(nextState, props));
    });
    component.transactionalSetStateCallbacks.clear();
  }

  /// Wrapper for [Component.componentWillReceiveProps].
  void handleComponentWillReceiveProps(
          Component component,
          ReactDartComponentInternal nextInternal,
          InteropContextValue nextContext) =>
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
  bool handleShouldComponentUpdate(
          Component component, InteropContextValue nextContext) =>
      zone.run(() {
        _callSetStateTransactionalCallbacks(component);

        // If shouldComponentUpdateWithContext returns a valid bool (default implementation returns null),
        // then don't bother calling `shouldComponentUpdate` and have it trump.
        bool shouldUpdate = component.shouldComponentUpdateWithContext(
            component.nextProps, component.nextState, component.nextContext);

        if (shouldUpdate == null) {
          shouldUpdate = component.shouldComponentUpdate(
              component.nextProps, component.nextState);
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
  void handleComponentWillUpdate(
          Component component, InteropContextValue nextContext) =>
      zone.run(() {
        /// Call `componentWillUpdate` and the context variant
        component
          ..componentWillUpdate(component.nextProps, component.nextState)
          ..componentWillUpdateWithContext(
              component.nextProps, component.nextState, component.nextContext);

        _afterPropsChange(component, nextContext);
      });

  /// Wrapper for [Component.componentDidUpdate].
  ///
  /// Uses [prevState] which was transferred from [Component.nextState] in [componentWillUpdate].
  void handleComponentDidUpdate(
          Component component, ReactDartComponentInternal prevInternal) =>
      zone.run(() {
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
      handleComponentWillReceiveProps:
          allowInterop(handleComponentWillReceiveProps),
      handleShouldComponentUpdate: allowInterop(handleShouldComponentUpdate),
      handleComponentWillUpdate: allowInterop(handleComponentWillUpdate),
      handleComponentDidUpdate: allowInterop(handleComponentDidUpdate),
      handleComponentWillUnmount: allowInterop(handleComponentWillUnmount),
      handleRender: allowInterop(handleRender));
})();

// TODO custom adapter for over_react to avoid typedPropsFactory usages?
class JsComponent2Adapter extends Component2Adapter {
  // TODO find a way to inject this better
  final ReactComponent jsThis;

  JsComponent2Adapter({
    this.jsThis,
  });

  @override
  void forceUpdate(SetStateCallback callback) {
    if (callback == null) {
      jsThis.forceUpdate();
    } else {
      jsThis.forceUpdate(allowInterop(callback));
    }
  }

  @override
  void setState(newState, SetStateCallback callback) {
    dynamic firstArg;

    if (newState is Map) {
      firstArg = jsBackingMapOrJsCopy(newState);
    } else if (newState is TransactionalSetStateCallback) {
      firstArg = allowInterop((jsPrevState, jsProps, [_]) {
        return jsBackingMapOrJsCopy(newState(
          new JsBackedMap.backedBy(jsPrevState),
          new JsBackedMap.backedBy(jsProps),
        ));
      });
    } else if (newState != null) {
      throw new ArgumentError(
          'setState expects its first parameter to either be a Map or a `TransactionalSetStateCallback`.');
    }

    if (callback == null) {
      jsThis.setState(firstArg);
    } else {
      jsThis.setState(firstArg, allowInterop(([_]) {
        callback();
      }));
    }
  }
}

final ReactDartInteropStatics2 _dartInteropStatics2 = (() {
  final zone = Zone.current;

  /// Wrapper for [Component.getInitialState].
  Component2 initComponent(ReactComponent jsThis,
          ComponentStatics<Component2> componentStatics) =>
      zone.run(() {
        final component = componentStatics.componentFactory();
        component.adapter =
            new JsComponent2Adapter(jsThis: jsThis); // TODO displayName;
        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.

        component
          ..jsThis = jsThis
          // FIXME fix casts
          ..props = new JsBackedMap.backedBy(jsThis.props as dynamic);

        return component;
      });

  JsMap handleGetInitialState(Component2 component) => zone.run(() {
        return jsBackingMapOrJsCopy(component.getInitialState());
      });

  void handleComponentWillMount(Component2 component, ReactComponent jsThis) =>
      zone.run(() {
        component
          // FIXME fix casts
          ..state = new JsBackedMap.backedBy(jsThis.state as dynamic);

        component.componentWillMount();
      });

  void handleComponentDidMount(Component2 component) => zone.run(() {
        component.componentDidMount();
      });

  void handleComponentWillReceiveProps(
          Component2 component, JsMap jsNextProps) =>
      zone.run(() {
        component
            .componentWillReceiveProps(new JsBackedMap.backedBy(jsNextProps));
      });

  void _updatePropsAndStateWithJs(
      Component2 component, JsMap props, JsMap state) {
    component
      // FIXME fix casts
      ..props = new JsBackedMap.backedBy(props)
      ..state = new JsBackedMap.backedBy(state);
  }

  bool handleShouldComponentUpdate(
          Component2 component, JsMap jsNextProps, JsMap jsNextState) =>
      zone.run(() {
        final value = component.shouldComponentUpdate(
          new JsBackedMap.backedBy(jsNextProps),
          new JsBackedMap.backedBy(jsNextState),
        );

        if (!value) {
          _updatePropsAndStateWithJs(component, jsNextProps, jsNextState);
        }

        return value;
      });

  void handleComponentWillUpdate(
          Component2 component, JsMap jsNextProps, JsMap jsNextState) =>
      zone.run(() {
        component.componentWillUpdate(
          new JsBackedMap.backedBy(jsNextProps),
          new JsBackedMap.backedBy(jsNextState),
        );

        _updatePropsAndStateWithJs(component, jsNextProps, jsNextState);
      });

  void handleComponentDidUpdate(Component2 component, ReactComponent jsThis,
          JsMap jsPrevProps, JsMap jsPrevState) =>
      zone.run(() {
//    final prevProps = component.props; // todo do this instead of creating new wrappers?
//    final prevState = component.state; // todo do this instead of creating new wrappers?
        component.componentDidUpdate(
          new JsBackedMap.backedBy(jsPrevProps),
          new JsBackedMap.backedBy(jsPrevState),
        );
      });

  void handleComponentWillUnmount(Component2 component) => zone.run(() {
        component.componentWillUnmount();
      });

  dynamic handleRender(Component2 component) => zone.run(() {
        return component.render();
      });

  return new ReactDartInteropStatics2(
    initComponent: allowInterop(initComponent),
    handleGetInitialState: allowInterop(handleGetInitialState),
    handleComponentWillMount: allowInterop(handleComponentWillMount),
    handleComponentDidMount: allowInterop(handleComponentDidMount),
    handleComponentWillReceiveProps:
        allowInterop(handleComponentWillReceiveProps),
    handleShouldComponentUpdate: allowInterop(handleShouldComponentUpdate),
    handleComponentWillUpdate: allowInterop(handleComponentWillUpdate),
    handleComponentDidUpdate: allowInterop(handleComponentDidUpdate),
    handleComponentWillUnmount: allowInterop(handleComponentWillUnmount),
    handleRender: allowInterop(handleRender),
  );
})();

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactDartComponentFactoryProxy _registerComponent(
    ComponentFactory componentFactory,
    [Iterable<String> skipMethods = const []]) {
  var componentInstance = componentFactory();

  if (componentInstance is Component2) {
    return _registerComponent2(componentFactory, skipMethods);
  }

  var componentStatics = new ComponentStatics(componentFactory);

  var jsConfig = new JsComponentConfig(
    childContextKeys: componentInstance.childContextKeys,
    contextKeys: componentInstance.contextKeys,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass = createReactDartComponentClass(
      _dartInteropStatics, componentStatics, jsConfig)
    ..displayName = componentFactory().displayName;

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final Map defaultProps =
      new Map.unmodifiable(componentInstance.getDefaultProps());
  reactComponentClass.dartDefaultProps = defaultProps;

  return new ReactDartComponentFactoryProxy(reactComponentClass);
}

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactDartComponentFactoryProxy2 _registerComponent2(
    ComponentFactory<Component2> componentFactory,
    [Iterable<String> skipMethods = const []]) {
  final componentInstance = componentFactory();
  final componentStatics = new ComponentStatics(componentFactory);

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass =
      createReactDartComponentClass2(_dartInteropStatics2, componentStatics)
        ..displayName = componentInstance.displayName;

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final JsBackedMap defaultProps =
      new JsBackedMap.from(componentInstance.getDefaultProps());
  // TODO move this to JS
  reactComponentClass.defaultProps = defaultProps.jsObject;
  reactComponentClass.isDartClass = true;

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
    if (ddc_emulated_function_name_bug.isBugPresent) {
      ddc_emulated_function_name_bug.patchName(this);
    }
  }

  @override
  String get type => name;

  @override
  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = _convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    // We can't mutate the original since we can't be certain that the value of the
    // the converted event handler will be compatible with the Map's type parameters.
    final convertibleProps = new JsBackedMap.from(props);

    convertProps(convertibleProps);
    jsifyMapProperties(convertibleProps);

    return factory(convertibleProps.jsObject, children);
  }

  /// Prepares the bound values, event handlers, and style props for consumption by ReactJS DOM components.
  static void convertProps(Map props) {
    _convertBoundValues(props);
    _convertEventHandlers(props);
  }
}

/// Create react-dart registered component for the HTML [Element].
_reactDom(String name) {
  return new ReactDomComponentFactoryProxy(name);
}

/// Returns whether an [InputElement] is a [CheckboxInputElement] based the value of the `type` key in [props].
_isCheckbox(props) {
  return props['type'] == 'checkbox';
}

/// Get value from the provided [domElem].
///
/// If the [domElem] is a [CheckboxInputElement], return [bool], else return [String] value.
_getValueFromDom(domElem) {
  var props = domElem.attributes;

  if (_isCheckbox(props)) {
    return domElem.checked;
  } else {
    return domElem.value;
  }
}

/// Set value to props based on type of input.
///
/// _Note: Processing checkbox `checked` value is handled as a special case._
_setValueToProps(Map props, val) {
  if (_isCheckbox(props)) {
    if (val) {
      props['checked'] = true;
    } else {
      if (props.containsKey('checked')) {
        props.remove('checked');
      }
    }
  } else {
    props['value'] = val;
  }
}

/// Convert bound values to pure value and packed onChange function
_convertBoundValues(Map args) {
  var boundValue = args['value'];

  if (boundValue is List) {
    _setValueToProps(args, boundValue[0]);
    args['value'] = boundValue[0];
    var onChange = args['onChange'];

    // Put new function into onChange event handler.
    // If there was something listening for that event, trigger it and return its return value.
    args['onChange'] = (event) {
      boundValue[1](_getValueFromDom(event.target));

      if (onChange != null) {
        return onChange(event);
      }
    };
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
  var props = JsBackedMap.copyToDart(instance.props);
  eventPropKeyToEventFactory.keys.forEach((key) {
    if (props.containsKey(key)) {
      props[key] = unconvertJsEventHandler(props[key]) ?? props[key];
    }
  });

  // Convert the nested style map so it can be read by Dart code.
  var style = props['style'];
  if (style != null) {
    props['style'] = JsBackedMap.copyToDart<String, dynamic>(style);
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
  var zone = Zone.current;
  args.forEach((propKey, value) {
    var eventFactory = eventPropKeyToEventFactory[propKey];
    if (eventFactory != null && value != null) {
      // Apply allowInterop here so that the function we store in [_originalEventHandlers]
      // is the same one we'll retrieve from the JS props.
      var reactDartConvertedEventHandler =
          allowInterop((events.SyntheticEvent e, [_, __]) => zone.run(() {
                value(eventFactory(e));
              }));

      args[propKey] = reactDartConvertedEventHandler;
      _originalEventHandlers[reactDartConvertedEventHandler] = value;
    }
  });
}

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(events.SyntheticEvent e) {
  return new SyntheticEvent(
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
      e.type);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(
    events.SyntheticClipboardEvent e) {
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
SyntheticKeyboardEvent syntheticKeyboardEventFactory(
    events.SyntheticKeyboardEvent e) {
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
  return new SyntheticFormEvent(
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
      e.type);
}

/// Wrapper for [SyntheticDataTransfer].
SyntheticDataTransfer syntheticDataTransferFactory(
    events.SyntheticDataTransfer dt) {
  if (dt == null) return null;
  List<File> files = [];
  if (dt.files != null) {
    for (int i = 0; i < dt.files.length; i++) {
      files.add(dt.files[i]);
    }
  }
  List<String> types = [];
  if (dt.types != null) {
    for (int i = 0; i < dt.types.length; i++) {
      types.add(dt.types[i]);
    }
  }
  var effectAllowed;
  var dropEffect;

  try {
    // Works around a bug in IE where dragging from outside the browser fails.
    // Trying to access this property throws the error "Unexpected call to method or property access.".
    effectAllowed = dt.effectAllowed;
  } catch (exception) {
    effectAllowed = 'uninitialized';
  }

  try {
    // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
    // Trying to access this property throws the error "Unexpected call to method or property access.".
    dropEffect = dt.dropEffect;
  } catch (exception) {
    dropEffect = 'none';
  }

  return new SyntheticDataTransfer(dropEffect, effectAllowed, files, types);
}

/// Wrapper for [SyntheticPointerEvent].
SyntheticPointerEvent syntheticPointerEventFactory(
    events.SyntheticPointerEvent e) {
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
      e.shiftKey);
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
      e.touches);
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
      e.view);
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
      e.deltaZ);
}

dynamic _findDomNode(component) {
  return ReactDom.findDOMNode(
      component is Component ? component.jsThis : component);
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
    throw new Exception(
        'Loaded react.js must include react-dart JS interop helpers.');
  }

  setReactConfiguration(_reactDom, _registerComponent);
  setReactDOMConfiguration(
      ReactDom.render, ReactDom.unmountComponentAtNode, _findDomNode);
  // Accessing ReactDomServer.renderToString when it's not available breaks in DDC.
  if (context['ReactDOMServer'] != null) {
    setReactDOMServerConfiguration(
        ReactDomServer.renderToString, ReactDomServer.renderToStaticMarkup);
  }
}
