// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_client;

import 'dart:js';
import 'dart:html';
import 'dart:async';

import 'package:react/react.dart';
import 'package:react/react_dom.dart';
import 'package:react/react_dom_server.dart';

var _React = context['React'];
var _ReactDom = context['ReactDOM'];
var _ReactDomServer = context['ReactDOMServer'];
var _Object = context['Object'];

const PROPS = 'props';
const INTERNAL = '__internal__';
const COMPONENT = 'component';
const IS_MOUNTED = 'isMounted';
const REFS = 'refs';

newJsObjectEmpty() {
  return new JsObject(_Object);
}

final emptyJsMap = newJsObjectEmpty();
newJsMap(Map map) {
  var JsMap = newJsObjectEmpty();
  for (var key in map.keys) {
    if(map[key] is Map) {
      JsMap[key] = newJsMap(map[key]);
    } else {
      JsMap[key] = map[key];
    }
  }
  return JsMap;
}

/// Type of [children] must be child or list of children, when child is [JsObject] or [String]
typedef JsObject ReactComponentFactory(Map props, [dynamic children]);
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
  JsObject call(Map props, [dynamic children]);

  /// Used to implement a variadic version of [call], in which children may be specified as additional arguments.
  dynamic noSuchMethod(Invocation invocation);
}

/// Creates ReactJS [Component] instances for Dart components.
class ReactDartComponentFactoryProxy extends ReactComponentFactoryProxy {
  final JsFunction reactClass;
  final JsFunction reactComponentFactory;

  ReactDartComponentFactoryProxy(JsFunction reactClass) :
      this.reactClass = reactClass,
      this.reactComponentFactory = _React.callMethod('createFactory', [reactClass]);

  JsFunction get type => reactClass;

  JsObject call(Map props, [dynamic children]) {
    // Convert Iterable children to JsArrays so that the JS can read them.
    // Use JsArrays instead of Lists, because automatic List conversion results in
    // react-id values being cluttered with ".$o:0:0:$_jsObject:" in dart2js-transpiled Dart.
    if (children is Iterable) {
      children = new JsArray.from(children);
    }

    List reactParams = [
      generateExtendedJsProps(props, children),
      children
    ];

    return reactComponentFactory.apply(reactParams);
  }

  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #call && invocation.isMethod) {
      Map props = invocation.positionalArguments[0];
      List children = invocation.positionalArguments.sublist(1);

      List reactParams = [generateExtendedJsProps(props, children)];
      reactParams.addAll(children);

      return reactComponentFactory.apply(reactParams);
    }

    return super.noSuchMethod(invocation);
  }

  /// Returns a [JsObject] version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static JsObject generateExtendedJsProps(Map props, dynamic children) {
    if (children == null) {
      children = [];
    } else if (children is! Iterable) {
      children = [children];
    }

    Map extendedProps = new Map.from(props);
    extendedProps['children'] = children;

    JsObject jsProps = newJsObjectEmpty();

    // Transfer over `key` if specified so ReactJS knows about it.
    if (extendedProps.containsKey('key')) {
      jsProps['key'] = extendedProps['key'];
    }

    // Transfer over `ref` if specified so ReactJS knows about it.
    if (extendedProps.containsKey('ref')) {
      var ref = extendedProps['ref'];

      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the JsObject instance.
      if (ref is _CallbackRef) {
        jsProps['ref'] = (JsObject instance) => ref(instance == null ? null : _getComponent(instance));
      } else {
        jsProps['ref'] = ref;
      }
    }

    // Put Dart props inside the `__internal__` object.
    jsProps[INTERNAL] = {PROPS: extendedProps};

    return jsProps;
  }
}

// TODO Think about using Expandos
_getInternal(JsObject jsThis) => jsThis[PROPS][INTERNAL];
_getProps(JsObject jsThis) => _getInternal(jsThis)[PROPS];
_getComponent(JsObject jsThis) => _getInternal(jsThis)[COMPONENT];
_getInternalProps(JsObject jsProps) => jsProps[INTERNAL][PROPS];


/// Returns a new [ReactComponentFactory] which produces a new JS
/// [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactComponentFactory _registerComponent(ComponentFactory componentFactory, [Iterable<String> skipMethods = const []]) {

  var zone = Zone.current;

  /// Wrapper for [Component.getDefaultProps].
  var getDefaultProps = new JsFunction.withThis((jsThis) => zone.run(() {
    return newJsObjectEmpty();
  }));

  /// Wrapper for [Component.getInitialState].
  var getInitialState = new JsFunction.withThis((jsThis) => zone.run(() {
    var internal = _getInternal(jsThis);
    var redraw = () {
      if (internal[IS_MOUNTED]) {
        jsThis.callMethod('setState', [emptyJsMap]);
      }
    };

    var getRef = (name) {
      var ref = jsThis['refs'][name];
      if (ref == null) return null;
      if (ref is Element) return ref;

      if (ref[PROPS][INTERNAL] != null) return ref[PROPS][INTERNAL][COMPONENT];
      else return ref;
    };

    var getDOMNode = () {
      return _ReactDom.callMethod('findDOMNode', [jsThis]);
    };

    Component component = componentFactory()
        ..initComponentInternal(internal[PROPS], redraw, getRef, getDOMNode, jsThis);

    internal[COMPONENT] = component;
    internal[IS_MOUNTED] = false;
    internal[PROPS] = component.props;

    _getComponent(jsThis).initStateInternal();
    return newJsObjectEmpty();
  }));

  /// Wrapper for [Component.componentWillMount].
  var componentWillMount = new JsFunction.withThis((jsThis) => zone.run(() {
    _getInternal(jsThis)[IS_MOUNTED] = true;
    _getComponent(jsThis)
        ..componentWillMount()
        ..transferComponentState();
  }));

  /// Wrapper for [Component.componentDidMount].
  var componentDidMount = new JsFunction.withThis((JsObject jsThis) => zone.run(() {
    //you need to get dom node by calling findDOMNode
    var rootNode = _ReactDom.callMethod('findDOMNode', [jsThis]);
    _getComponent(jsThis).componentDidMount(rootNode);
  }));

  _getNextProps(Component component, newArgs) {
    var newProps = _getInternalProps(newArgs);
    return {}
      ..addAll(component.getDefaultProps())
      ..addAll(newProps != null ? newProps : {});
  }

  /// 1. Add [component] to [newArgs] to keep it in [INTERNAL]
  /// 2. Update [Component.props] using [newArgs] as second argument to [_getNextProps]
  /// 3. Update [Component.state] by calling [Component.transferComponentState]
  _afterPropsChange(Component component, newArgs) {
    // [1]
    newArgs[INTERNAL][COMPONENT] = component;

    // [2]
    component.props = _getNextProps(component, newArgs);

    // [3]
    component.transferComponentState();
  }

  /// Wrapper for [Component.componentWillReceiveProps].
  var componentWillReceiveProps = new JsFunction.withThis((jsThis, newArgs, [reactInternal]) => zone.run(() {
    Component component = _getComponent(jsThis);
    component.componentWillReceiveProps(_getNextProps(component, newArgs));
  }));

  /// Wrapper for [Component.shouldComponentUpdate].
  var shouldComponentUpdate = new JsFunction.withThis((jsThis, newArgs, nextState, nextContext) => zone.run(() {
    Component component  = _getComponent(jsThis);

    if (component.shouldComponentUpdate(_getNextProps(component, newArgs), component.nextState)) {
      return true;
    } else {
      // If component should not update, update props / transfer state because componentWillUpdate will not be called.
      _afterPropsChange(component, newArgs);
      return false;
    }
  }));

  /// Wrapper for [Component.componentWillUpdate].
  var componentWillUpdate = new JsFunction.withThis((jsThis, newArgs, nextState, [reactInternal]) => zone.run(() {
    Component component  = _getComponent(jsThis);

    component.componentWillUpdate(_getNextProps(component, newArgs), component.nextState);

    _afterPropsChange(component, newArgs);
  }));

  /// Wrapper for [Component.componentDidUpdate].
  ///
  /// Uses [prevState] which was transferred from [Component.nextState] in [componentWillUpdate].
  var componentDidUpdate = new JsFunction.withThis((JsObject jsThis, prevProps, prevState, prevContext) => zone.run(() {
    var prevInternalProps = _getInternalProps(prevProps);
    // You don't get rootNode as a parameter, so we need to get it directly
    var rootNode = _ReactDom.callMethod('findDOMNode', [jsThis]);
    Component component = _getComponent(jsThis);
    component.componentDidUpdate(prevInternalProps, component.prevState, rootNode);
  }));

  /// Wrapper for [Component.componentWillUnmount].
  var componentWillUnmount = new JsFunction.withThis((jsThis, [reactInternal]) => zone.run(() {
    _getInternal(jsThis)[IS_MOUNTED] = false;
    Component component = _getComponent(jsThis);
    component.componentWillUnmount();
  }));

  /// Wrapper for [Component.render].
  var render = new JsFunction.withThis((jsThis) => zone.run(() {
    Component component = _getComponent(jsThis);
    return component.render();
  }));

  var skippableMethods = [
    'componentDidMount',
    'componentWillReceiveProps',
    'shouldComponentUpdate',
    'componentDidUpdate',
    'componentWillUnmount',
  ];

  removeUnusedMethods(Map originalMap, Iterable removeMethods) {
    removeMethods.where((m) => skippableMethods.contains(m)).forEach((m) => originalMap.remove(m));
    return originalMap;
  }

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with wrapped functions.
  JsFunction reactComponentClass = _React.callMethod('createClass', [newJsMap(
    removeUnusedMethods({
      'displayName': componentFactory().displayName,
      'componentWillMount': componentWillMount,
      'componentDidMount': componentDidMount,
      'componentWillReceiveProps': componentWillReceiveProps,
      'shouldComponentUpdate': shouldComponentUpdate,
      'componentWillUpdate': componentWillUpdate,
      'componentDidUpdate': componentDidUpdate,
      'componentWillUnmount': componentWillUnmount,
      'getDefaultProps': getDefaultProps,
      'getInitialState': getInitialState,
      'render': render
    }, skipMethods)
  )]);

  return new ReactDartComponentFactoryProxy(reactComponentClass);
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
  JsObject call(Map props, [dynamic children]) {
    convertProps(props);

    // Convert Iterable children to JsArrays so that the JS can read them.
    // Use JsArrays instead of Lists, because automatic List conversion results in
    // react-id values being cluttered with ".$o:0:0:$_jsObject:" in dart2js-transpiled Dart.
    if (children is Iterable) {
      children = new JsArray.from(children);
    }

    List reactParams = [name, newJsMap(props), children];

    return _React.callMethod('createElement', reactParams);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #call && invocation.isMethod) {
      Map props = invocation.positionalArguments[0];
      List children = invocation.positionalArguments.sublist(1);

      convertProps(props);

      List reactParams = [name, newJsMap(props)];
      reactParams.addAll(children);

      return _React.callMethod('createElement', reactParams);
    }

    return super.noSuchMethod(invocation);
  }

  /// Prepares the bound values, event handlers, and style props for consumption by ReactJS DOM components.
  static void convertProps(Map props) {
    _convertBoundValues(props);
    _convertEventHandlers(props);

    if (props.containsKey('style')) {
      props['style'] = new JsObject.jsify(props['style']);
    }
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

/// Convert packed event handler into wrapper and pass it only the Dart [SyntheticEvent] object converted from the
/// [JsObject] event.
_convertEventHandlers(Map args) {
  var zone = Zone.current;
  args.forEach((key, value) {
    if (value == null) {
      // If the handler is null, don't attempt to wrap/call it.
      return;
    }
    var eventFactory;

    if (_syntheticClipboardEvents.contains(key)) {
      eventFactory = syntheticClipboardEventFactory;
    } else if (_syntheticKeyboardEvents.contains(key)) {
      eventFactory = syntheticKeyboardEventFactory;
    } else if (_syntheticFocusEvents.contains(key)) {
      eventFactory = syntheticFocusEventFactory;
    } else if (_syntheticFormEvents.contains(key)) {
      eventFactory = syntheticFormEventFactory;
    } else if (_syntheticMouseEvents.contains(key)) {
      eventFactory = syntheticMouseEventFactory;
    } else if (_syntheticTouchEvents.contains(key)) {
      eventFactory = syntheticTouchEventFactory;
    } else if (_syntheticUIEvents.contains(key)) {
      eventFactory = syntheticUIEventFactory;
    } else if (_syntheticWheelEvents.contains(key)) {
      eventFactory = syntheticWheelEventFactory;
    } else {
      return;
    }

    args[key] = (JsObject e, [String domId, Event event]) => zone.run(() {
      value(eventFactory(e));
    });
  });
}

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(JsObject e) {
  return new SyntheticEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type']);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(JsObject e) {
  return new SyntheticClipboardEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['clipboardData']);
}

/// Wrapper for [SyntheticKeyboardEvent].
SyntheticKeyboardEvent syntheticKeyboardEventFactory(JsObject e) {
  return new SyntheticKeyboardEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'],
      e['nativeEvent'], e['target'], e['timeStamp'], e['type'], e['altKey'],
      e['char'], e['charCode'], e['ctrlKey'], e['locale'], e['location'],
      e['key'], e['keyCode'], e['metaKey'], e['repeat'], e['shiftKey']);
}

/// Wrapper for [SyntheticFocusEvent].
SyntheticFocusEvent syntheticFocusEventFactory(JsObject e) {
  return new SyntheticFocusEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['relatedTarget']);
}

/// Wrapper for [SyntheticFormEvent].
SyntheticFormEvent syntheticFormEventFactory(JsObject e) {
  return new SyntheticFormEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type']);
}

/// Wrapper for [SyntheticDataTransfer].
SyntheticDataTransfer syntheticDataTransferFactory(JsObject dt) {
  if (dt == null) return null;
  List<File> files = [];
  if (dt['files'] != null) {
    for (int i = 0; i < dt['files']['length']; i++) {
      files.add(dt['files'][i]);
    }
  }
  List<String> types = [];
  if (dt['types'] != null) {
    for (int i = 0; i < dt['types']['length']; i++) {
      types.add(dt['types'][i]);
    }
  }
  var effectAllowed;
  try {
    // Works around a bug in IE where dragging from outside the browser fails.
    // Trying to access this property throws the error "Unexpected call to method or property access.".
    effectAllowed = dt['effectAllowed'];
  } catch (exception) {
    effectAllowed = 'uninitialized';
  }
  return new SyntheticDataTransfer(dt['dropEffect'], effectAllowed, files, types);
}

/// Wrapper for [SyntheticMouseEvent].
SyntheticMouseEvent syntheticMouseEventFactory(JsObject e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e['dataTransfer']);
  return new SyntheticMouseEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['altKey'], e['button'], e['buttons'], e['clientX'], e['clientY'],
      e['ctrlKey'], dt, e['metaKey'], e['pageX'], e['pageY'], e['relatedTarget'], e['screenX'],
      e['screenY'], e['shiftKey']);
}

/// Wrapper for [SyntheticTouchEvent].
SyntheticTouchEvent syntheticTouchEventFactory(JsObject e) {
  return new SyntheticTouchEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['altKey'], e['changedTouches'], e['ctrlKey'], e['metaKey'],
      e['shiftKey'], e['targetTouches'], e['touches']);
}

/// Wrapper for [SyntheticUIEvent].
SyntheticUIEvent syntheticUIEventFactory(JsObject e) {
  return new SyntheticUIEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['detail'], e['view']);
}

/// Wrapper for [SyntheticWheelEvent].
SyntheticWheelEvent syntheticWheelEventFactory(JsObject e) {
  return new SyntheticWheelEvent(e['bubbles'], e['cancelable'], e['currentTarget'],
      e['defaultPrevented'], () => e.callMethod('preventDefault', []),
      () => e.callMethod('stopPropagation', []), e['eventPhase'], e['isTrusted'], e['nativeEvent'],
      e['target'], e['timeStamp'], e['type'], e['deltaX'], e['deltaMode'], e['deltaY'], e['deltaZ']);
}

Set _syntheticClipboardEvents = new Set.from(['onCopy', 'onCut', 'onPaste',]);

Set _syntheticKeyboardEvents = new Set.from(['onKeyDown', 'onKeyPress', 'onKeyUp',]);

Set _syntheticFocusEvents = new Set.from(['onFocus', 'onBlur',]);

Set _syntheticFormEvents = new Set.from(['onChange', 'onInput', 'onSubmit', 'onReset',]);

Set _syntheticMouseEvents = new Set.from(['onClick', 'onContextMenu', 'onDoubleClick', 'onDrag', 'onDragEnd',
    'onDragEnter', 'onDragExit', 'onDragLeave', 'onDragOver', 'onDragStart', 'onDrop', 'onMouseDown', 'onMouseEnter',
    'onMouseLeave', 'onMouseMove', 'onMouseOut', 'onMouseOver', 'onMouseUp',
]);

Set _syntheticTouchEvents = new Set.from(['onTouchCancel', 'onTouchEnd', 'onTouchMove', 'onTouchStart',]);

Set _syntheticUIEvents = new Set.from(['onScroll',]);

Set _syntheticWheelEvents = new Set.from(['onWheel',]);


JsObject _render(JsObject component, Element element) {
  var renderedComponent = _ReactDom.callMethod('render', [component, element]);

  if (renderedComponent is JsObject) return renderedComponent;
  else return new JsObject.fromBrowserObject(renderedComponent);
}

String _renderToString(JsObject component) {
  return _ReactDomServer.callMethod('renderToString', [component]);
}

String _renderToStaticMarkup(JsObject component) {
  return _ReactDomServer.callMethod('renderToStaticMarkup', [component]);
}

bool _unmountComponentAtNode(HtmlElement element) {
  return _ReactDom.callMethod('unmountComponentAtNode', [element]);
}

dynamic _findDomNode(component) {
  // if it's a dart component class, the mounted dom is returned from getDOMNode
  // which has jsComponent closured inside and calls on it findDOMNode
  if (component is Component) return component.getDOMNode();
  //otherwise we have js component so pass it in findDOM node
  return _ReactDom.callMethod('findDOMNode', [component]);
}

void setClientConfiguration() {
  if (_React == null || _ReactDom == null) {
    throw new Exception('react.js and react_dom.js must be loaded.');
  }

  setReactConfiguration(_reactDom, _registerComponent, _render, _renderToString, _renderToStaticMarkup,
      _unmountComponentAtNode, _findDomNode);
  setReactDOMConfiguration(_render, _unmountComponentAtNode, _findDomNode);
  setReactDOMServerConfiguration(_renderToString, _renderToStaticMarkup);
}
