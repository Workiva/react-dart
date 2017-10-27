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
import "package:react/src/react_client/synthetic_event_wrappers.dart" as events;
import 'package:react/src/typedefs.dart';
import 'package:react/src/ddc_emulated_function_name_bug.dart' as ddc_emulated_function_name_bug;

export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory;

final EmptyObject emptyJsMap = new EmptyObject();

/// Type of [children] must be child or list of children, when child is [ReactElement] or [String]
typedef ReactElement ReactComponentFactory(Map props, [dynamic children]);
typedef Component ComponentFactory();

/// The type of [Component.ref] specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef _CallbackRef(componentOrDomNode);

/// Creates ReactJS [ReactElement] instances.
abstract class ReactComponentFactoryProxy implements Function {
  /// The type of component created by this factory.
  get type;

  /// Returns a new rendered component instance with the specified [props] and [children].
  ///
  /// Necessary to work around DDC `dart.dcall` issues in <https://github.com/dart-lang/sdk/issues/29904>,
  /// since invoking the function directly doesn't work.
  ReactElement build(Map props, [List childrenArgs]);

  /// Returns a new rendered component instance with the specified [props] and [children].
  ///
  /// We need a concrete implementation of this, as opposed to it just being handled by [noSuchMethod],
  /// in order to work around DDC issue <https://github.com/dart-lang/sdk/issues/29917>.
  ReactElement call(Map props, [dynamic children]) => build(props, [children]);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #call && invocation.isMethod) {
      Map props = invocation.positionalArguments[0];
      List children = invocation.positionalArguments.sublist(1);

      return build(props, children);
    }

    return super.noSuchMethod(invocation);
  }
}

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
class ReactDartComponentFactoryProxy<TComponent extends Component> extends ReactComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final ReactJsComponentFactory reactComponentFactory;

  /// The cached Dart default props retrieved from [reactClass] that are passed
  /// into [generateExtendedJsProps] upon [ReactElement] creation.
  final Map defaultProps;

  ReactDartComponentFactoryProxy(ReactClass reactClass) :
      this.reactClass = reactClass,
      this.reactComponentFactory = React.createFactory(reactClass),
      this.defaultProps = reactClass.dartDefaultProps;

  ReactClass get type => reactClass;

  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = _convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    return reactComponentFactory(
      generateExtendedJsProps(props, children, defaultProps: defaultProps),
      children
    );
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

    var internal = new ReactDartComponentInternal()
      ..props = extendedProps;

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
        interopProps.ref = allowInterop((ReactComponent instance) => ref(instance?.dartComponent));
      } else {
        interopProps.ref = ref;
      }
    }

    return interopProps;
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
    return internal.value;
  });
}

/// The static methods that proxy JS component lifecycle methods to Dart components.
final ReactDartInteropStatics _dartInteropStatics = (() {
  var zone = Zone.current;

  /// Wrapper for [Component.getInitialState].
  Component initComponent(ReactComponent jsThis, ReactDartComponentInternal internal, InteropContextValue context, ComponentStatics componentStatics) => zone.run(() {
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
  /// 2. Update [Component.state] by calling [Component.transferComponentState]
  /// 3. Update [Component.context] with the latest
  void _afterPropsChange(Component component, InteropContextValue nextContext) {
    component.props = component.nextProps; // [1]
    component.transferComponentState();    // [2]
    // [3]
    component.context = _unjsifyContext(nextContext);
  }

  void _clearPrevState(Component component) {
    component.prevState = null;
  }

  void _callSetStateCallbacks(Component component) {
    component.setStateCallbacks.forEach((callback()) { callback(); });
    component.setStateCallbacks.clear();
  }

  void _callSetStateTransactionalCallbacks(Component component) {
    var nextState = component.nextState;
    var props = new UnmodifiableMapView(component.props);

    component.transactionalSetStateCallbacks.forEach((callback) { nextState.addAll(callback(nextState, props)); });
    component.transactionalSetStateCallbacks.clear();
  }

  /// Wrapper for [Component.componentWillReceiveProps].
  void handleComponentWillReceiveProps(Component component, ReactDartComponentInternal nextInternal, InteropContextValue nextContext) => zone.run(() {
    var nextProps = _getNextProps(component, nextInternal);
    component
      ..nextProps = nextProps
      ..componentWillReceiveProps(nextProps);
  });

  /// Wrapper for [Component.shouldComponentUpdate].
  bool handleShouldComponentUpdate(Component component, InteropContextValue nextContext) => zone.run(() {
    _callSetStateTransactionalCallbacks(component);

    if (component.shouldComponentUpdate(component.nextProps, component.nextState)) {
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
    component.componentWillUpdate(component.nextProps, component.nextState);
    _afterPropsChange(component, nextContext);
  });

  /// Wrapper for [Component.componentDidUpdate].
  ///
  /// Uses [prevState] which was transferred from [Component.nextState] in [componentWillUpdate].
  void handleComponentDidUpdate(Component component, ReactDartComponentInternal prevInternal) => zone.run(() {
    var prevInternalProps = prevInternal.props;
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
      handleRender: allowInterop(handleRender)
  );
})();

/// Returns a new [ReactComponentFactory] which produces a new JS
/// [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactDartComponentFactoryProxy _registerComponent(ComponentFactory componentFactory, [Iterable<String> skipMethods = const []]) {
  var componentInstance = componentFactory();
  var componentStatics = new ComponentStatics(componentFactory);

  var jsConfig = new JsComponentConfig(
    childContextKeys: componentInstance.childContextKeys,
    contextKeys: componentInstance.contextKeys,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass = React.createClass(
      createReactDartComponentClassConfig(_dartInteropStatics, componentStatics, jsConfig)
        ..displayName = componentInstance.displayName
  );

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final Map defaultProps = new Map.unmodifiable(componentInstance.getDefaultProps());
  reactComponentClass.dartDefaultProps = defaultProps;

  return new ReactDartComponentFactoryProxy(reactComponentClass);
}

/// Creates ReactJS [ReactElement] instances for DOM components.
class ReactDomComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The name of the proxied DOM component.
  ///
  /// E.g. `'div'`, `'a'`, `'h1'`
  final String name;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final Function factory;

  ReactDomComponentFactoryProxy(name) :
    this.name = name,
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

    convertProps(props);

    return factory(jsify(props), children);
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
    if(val) {
      props['checked'] = true;
    } else {
      if(props.containsKey('checked')) {
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
    var eventFactory = _eventPropKeyToEventFactory[propKey];
    if (eventFactory != null && value != null) {
      // Apply allowInterop here so that the function we store in [_originalEventHandlers]
      // is the same one we'll retrieve from the JS props.
      var reactDartConvertedEventHandler = allowInterop((events.SyntheticEvent e, [_, __]) => zone.run(() {
        value(eventFactory(e));
      }));

      args[propKey] = reactDartConvertedEventHandler;
      _originalEventHandlers[reactDartConvertedEventHandler] = value;
    }
  });
}

/// A mapping from event prop keys to their respective event factories.
///
/// Used in [_convertEventHandlers] for efficient event handler conversion.
final Map<String, Function> _eventPropKeyToEventFactory = (() {
  var eventPropKeyToEventFactory = <String, Function>{
    // SyntheticClipboardEvent
    'onCopy': syntheticClipboardEventFactory,
    'onCut': syntheticClipboardEventFactory,
    'onPaste': syntheticClipboardEventFactory,

    // SyntheticKeyboardEvent
    'onKeyDown': syntheticKeyboardEventFactory,
    'onKeyPress': syntheticKeyboardEventFactory,
    'onKeyUp': syntheticKeyboardEventFactory,

    // SyntheticFocusEvent
    'onFocus': syntheticFocusEventFactory,
    'onBlur': syntheticFocusEventFactory,

    // SyntheticFormEvent
    'onChange': syntheticFormEventFactory,
    'onInput': syntheticFormEventFactory,
    'onSubmit': syntheticFormEventFactory,
    'onReset': syntheticFormEventFactory,

    // SyntheticMouseEvent
    'onClick': syntheticMouseEventFactory,
    'onContextMenu': syntheticMouseEventFactory,
    'onDoubleClick': syntheticMouseEventFactory,
    'onDrag': syntheticMouseEventFactory,
    'onDragEnd': syntheticMouseEventFactory,
    'onDragEnter': syntheticMouseEventFactory,
    'onDragExit': syntheticMouseEventFactory,
    'onDragLeave': syntheticMouseEventFactory,
    'onDragOver': syntheticMouseEventFactory,
    'onDragStart': syntheticMouseEventFactory,
    'onDrop': syntheticMouseEventFactory,
    'onMouseDown': syntheticMouseEventFactory,
    'onMouseEnter': syntheticMouseEventFactory,
    'onMouseLeave': syntheticMouseEventFactory,
    'onMouseMove': syntheticMouseEventFactory,
    'onMouseOut': syntheticMouseEventFactory,
    'onMouseOver': syntheticMouseEventFactory,
    'onMouseUp': syntheticMouseEventFactory,

    // SyntheticTouchEvent
    'onTouchCancel': syntheticTouchEventFactory,
    'onTouchEnd': syntheticTouchEventFactory,
    'onTouchMove': syntheticTouchEventFactory,
    'onTouchStart': syntheticTouchEventFactory,

    // SyntheticUIEvent
    'onScroll': syntheticUIEventFactory,

    // SyntheticWheelEvent
    'onWheel': syntheticWheelEventFactory,
  };

  // Add support for capturing variants; e.g., onClick/onClickCapture
  for (var key in eventPropKeyToEventFactory.keys.toList()) {
    eventPropKeyToEventFactory[key + 'Capture'] = eventPropKeyToEventFactory[key];
  }

  return eventPropKeyToEventFactory;
})();

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(events.SyntheticEvent e) {
  return new SyntheticEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(events.SyntheticClipboardEvent e) {
  return new SyntheticClipboardEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.clipboardData);
}

/// Wrapper for [SyntheticKeyboardEvent].
SyntheticKeyboardEvent syntheticKeyboardEventFactory(events.SyntheticKeyboardEvent e) {
  return new SyntheticKeyboardEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted,
      e.nativeEvent, e.target, e.timeStamp, e.type, e.altKey,
      e.char, e.charCode, e.ctrlKey, e.locale, e.location,
      e.key, e.keyCode, e.metaKey, e.repeat, e.shiftKey);
}

/// Wrapper for [SyntheticFocusEvent].
SyntheticFocusEvent syntheticFocusEventFactory(events.SyntheticFocusEvent e) {
  return new SyntheticFocusEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.relatedTarget);
}

/// Wrapper for [SyntheticFormEvent].
SyntheticFormEvent syntheticFormEventFactory(events.SyntheticFormEvent e) {
  return new SyntheticFormEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticDataTransfer].
SyntheticDataTransfer syntheticDataTransferFactory(events.SyntheticDataTransfer dt) {
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

/// Wrapper for [SyntheticMouseEvent].
SyntheticMouseEvent syntheticMouseEventFactory(events.SyntheticMouseEvent e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e.dataTransfer);
  return new SyntheticMouseEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.altKey, e.button, e.buttons, e.clientX, e.clientY,
      e.ctrlKey, dt, e.metaKey, e.pageX, e.pageY, e.relatedTarget, e.screenX,
      e.screenY, e.shiftKey);
}

/// Wrapper for [SyntheticTouchEvent].
SyntheticTouchEvent syntheticTouchEventFactory(events.SyntheticTouchEvent e) {
  return new SyntheticTouchEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.altKey, e.changedTouches, e.ctrlKey, e.metaKey,
      e.shiftKey, e.targetTouches, e.touches);
}

/// Wrapper for [SyntheticUIEvent].
SyntheticUIEvent syntheticUIEventFactory(events.SyntheticUIEvent e) {
  return new SyntheticUIEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.detail, e.view);
}

/// Wrapper for [SyntheticWheelEvent].
SyntheticWheelEvent syntheticWheelEventFactory(events.SyntheticWheelEvent e) {
  return new SyntheticWheelEvent(e.bubbles, e.cancelable, e.currentTarget,
      e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent,
      e.target, e.timeStamp, e.type, e.deltaX, e.deltaMode, e.deltaY, e.deltaZ);
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
    createReactDartComponentClassConfig(null, null);
  } on NoSuchMethodError catch (_) {
    throw new Exception('react.js and react_dom.js must be loaded.');
  } catch(_) {
    throw new Exception('Loaded react.js must include react-dart JS interop helpers.');
  }

  setReactConfiguration(_reactDom, _registerComponent);
  setReactDOMConfiguration(ReactDom.render, ReactDom.unmountComponentAtNode, _findDomNode);
  // Accessing ReactDomServer.renderToString when it's not available breaks in DDC.
  if (context['ReactDOMServer'] != null) {
    setReactDOMServerConfiguration(ReactDomServer.renderToString, ReactDomServer.renderToStaticMarkup);
  }
}
