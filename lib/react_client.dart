// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_client;

import "package:react/react.dart";
import "dart:js";
import "dart:html";
import "dart:async";

var _React = context['React'];
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

/**
 * Type of [children] must be child or list of childs, when child is JsObject or String
 */
typedef JsObject ReactComponentFactory(Map props, [dynamic children]);
typedef Component ComponentFactory();

class ReactComponentFactoryProxy implements Function {
  final ReactComponentFactory _call;
  final JsFunction reactComponentFactory;
  ReactComponentFactoryProxy(this.reactComponentFactory, this._call);

  JsObject call(Map props, [dynamic children]) {
    return this._call(props, children);
  }
}

/** TODO Think about using Expandos */
_getInternal(JsObject jsThis) => jsThis[PROPS][INTERNAL];
_getProps(JsObject jsThis) => _getInternal(jsThis)[PROPS];
_getComponent(JsObject jsThis) => _getInternal(jsThis)[COMPONENT];
_getInternalProps(JsObject jsProps) => jsProps[INTERNAL][PROPS];

ReactComponentFactory _registerComponent(ComponentFactory componentFactory, [Iterable<String> skipMethods = const []]) {

  var zone = Zone.current;

  /**
   * wrapper for getDefaultProps.
   * Get internal, create component and place it to internal.
   *
   * Next get default props by component method and merge component.props into it
   * to update it with passed props from parent.
   *
   * @return jsProsp with internal with component.props and component
   */
  var getDefaultProps = new JsFunction.withThis((jsThis) => zone.run(() {
    return newJsObjectEmpty();
  }));

  /**
   * get initial state from component.getInitialState, put them to state.
   *
   * @return empty JsObject as default state for javascript react component
   */
  var getInitialState = new JsFunction.withThis((jsThis) => zone.run(() {

    var internal = _getInternal(jsThis);
    var redraw = () {
      if (internal[IS_MOUNTED]) {
        jsThis.callMethod('setState', [emptyJsMap]);
      }
    };

    var getRef = (name) {
      var ref = jsThis['refs'][name] as JsObject;
      if (ref == null) return null;
      if (ref[PROPS][INTERNAL] != null) return ref[PROPS][INTERNAL][COMPONENT];
      else return ref;
    };

    var getDOMNode = () {
      return _React.callMethod('findDOMNode', [jsThis]);
    };

    Component component = componentFactory()
        ..initComponentInternal(internal[PROPS], redraw, getRef, getDOMNode);

    internal[COMPONENT] = component;
    internal[IS_MOUNTED] = false;
    internal[PROPS] = component.props;

    _getComponent(jsThis).initStateInternal();
    return newJsObjectEmpty();
  }));

  /**
   * only wrap componentWillMount
   */
  var componentWillMount = new JsFunction.withThis((jsThis) => zone.run(() {
    _getInternal(jsThis)[IS_MOUNTED] = true;
    _getComponent(jsThis)
        ..componentWillMount()
        ..transferComponentState();
  }));

  /**
   * only wrap componentDidMount
   */
  var componentDidMount = new JsFunction.withThis((JsObject jsThis) => zone.run(() {
    //you need to get dom node by calling findDOMNode
    var rootNode = _React.callMethod('findDOMNode', [jsThis]);
    _getComponent(jsThis).componentDidMount(rootNode);
  }));

  _getNextProps(Component component, newArgs) {
    var newProps = _getInternalProps(newArgs);
    return {}
      ..addAll(component.getDefaultProps())
      ..addAll(newProps != null ? newProps : {});
  }

  _afterPropsChange(Component component, newArgs) {
    /** add component to newArgs to keep component in internal */
    newArgs[INTERNAL][COMPONENT] = component;

    /** update component.props */
    component.props = _getNextProps(component, newArgs);

    /** update component.state */
    component.transferComponentState();
  }

  /**
   * Wrap componentWillReceiveProps
   */
  var componentWillReceiveProps =
      new JsFunction.withThis((jsThis, newArgs, [reactInternal]) => zone.run(() {
    var component = _getComponent(jsThis);
    component.componentWillReceiveProps(_getNextProps(component, newArgs));
  }));

  /**
   * count nextProps from jsNextProps, get result from component,
   * and if shoudln't update, update props and transfer state.
   */
  var shouldComponentUpdate =
      new JsFunction.withThis((jsThis, newArgs, nextState, nextContext) => zone.run(() {
    Component component  = _getComponent(jsThis);
    /** use component.nextState where are stored nextState */
    if (component.shouldComponentUpdate(_getNextProps(component, newArgs),
                                        component.nextState)) {
      return true;
    } else {
      /**
       * if component shouldnt update, update props and tranfer state,
       * becasue willUpdate will not be called and so it will not do it.
       */
      _afterPropsChange(component, newArgs);
      return false;
    }
  }));

  /**
   * wrap component.componentWillUpdate and after that update props and transfer state
   */
  var componentWillUpdate =
      new JsFunction.withThis((jsThis, newArgs, nextState, [reactInternal]) => zone.run(() {
    Component component  = _getComponent(jsThis);
    component.componentWillUpdate(_getNextProps(component, newArgs),
                                  component.nextState);
    _afterPropsChange(component, newArgs);
  }));

  /**
   * wrap componentDidUpdate and use component.prevState which was trasnfered from state in componentWillUpdate.
   */
  var componentDidUpdate =
      new JsFunction.withThis((JsObject jsThis, prevProps, prevState, prevContext) => zone.run(() {
    var prevInternalProps = _getInternalProps(prevProps);
    //you don't get root node as parameter but need to get it directly
    var rootNode = _React.callMethod('findDOMNode', [jsThis]);
    Component component = _getComponent(jsThis);
    component.componentDidUpdate(prevInternalProps, component.prevState, rootNode);
  }));

  /**
   * only wrap componentWillUnmount
   */
  var componentWillUnmount =
      new JsFunction.withThis((jsThis, [reactInternal]) => zone.run(() {
    _getInternal(jsThis)[IS_MOUNTED] = false;
    _getComponent(jsThis).componentWillUnmount();
  }));

  /**
   * only wrap render
   */
  var render = new JsFunction.withThis((jsThis) => zone.run(() {
    return _getComponent(jsThis).render();
  }));

  var skipableMethods = ['componentDidMount', 'componentWillReceiveProps',
                         'shouldComponentUpdate', 'componentDidUpdate',
                         'componentWillUnmount'];

  removeUnusedMethods(Map originalMap, Iterable removeMethods) {
    removeMethods.where((m) => skipableMethods.contains(m)).forEach((m) => originalMap.remove(m));
    return originalMap;
  }

  /**
   * create reactComponent with wrapped functions
   */
  JsFunction reactComponentFactory = _React.callMethod('createFactory', [
    _React.callMethod('createClass', [newJsMap(
      removeUnusedMethods({
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
    )])
  ]);

  var call = (Map props, [dynamic children]) {
    if (children == null) {
      children = [];
    } else if (children is! Iterable) {
      children = [children];
    }
    var extendedProps = new Map.from(props);
    extendedProps['children'] = children;

    var convertedArgs = newJsObjectEmpty();

    /**
     * add key to args which will be passed to javascript react component
     */
    if (extendedProps.containsKey('key')) {
      convertedArgs['key'] = extendedProps['key'];
    }

    if (extendedProps.containsKey('ref')) {
      convertedArgs['ref'] = extendedProps['ref'];
    }

    /**
     * put props to internal part of args
     */
    convertedArgs[INTERNAL] = {PROPS: extendedProps};

    return reactComponentFactory.apply([convertedArgs, new JsArray.from(children)]);
  };

  /**
   * return ReactComponentFactory which produce react component with set props and children[s]
   */
  return new ReactComponentFactoryProxy(reactComponentFactory, call);
}


/**
 * create dart-react registered component for html tag.
 */
_reactDom(String name) {
  var call = (Map props, [dynamic children]) {
    _convertBoundValues(props);
    _convertEventHandlers(props);
    if (props.containsKey('style')) {
      props['style'] = new JsObject.jsify(props['style']);
    }
    if (children is Iterable) {
      children = new JsArray.from(children);
    }
    return _React['createElement'].apply([name, newJsMap(props), children]);
  };

  return new ReactComponentFactoryProxy(_React['DOM'][name], call);
}

/**
 * Recognize if type of input (or other element) is checkbox by it's props.
 */
_isCheckbox(props) {
  return props['type'] == 'checkbox';
}

/**
 * get value from DOM element.
 *
 * If element is checkbox, return bool, else return value of "value" attribute
 */
_getValueFromDom(domElem) {
  var props = domElem.attributes;
  if (_isCheckbox(props)) {
    return domElem.checked;
  } else {
    return domElem.value;
  }
}

/**
 * set value to props based on type of input.
 *
 * Specialy, it recognized chceckbox.
 */
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

/**
 * convert bound values to pure value
 * and packed onchanged function
 */
_convertBoundValues(Map args) {
  var boundValue = args['value'];
  if (args['value'] is List) {
    _setValueToProps(args, boundValue[0]);
    args['value'] = boundValue[0];
    var onChange = args["onChange"];
    /**
     * put new function into onChange event hanlder.
     *
     * If there was something listening for taht event,
     * trigger it and return it's return value.
     */
    args['onChange'] = (e) {
      boundValue[1](_getValueFromDom(e.target));
      if(onChange != null)
        return onChange(e);
    };
  }
}


/**
 * Convert event pack event handler into wrapper
 * and pass it only dart object of event
 * converted from JsObject of event.
 */
_convertEventHandlers(Map args) {
  var zone = Zone.current;
  args.forEach((key, value) {
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
    } else return;
    args[key] = (JsObject e, [String domId]) => zone.run(() {
      value(eventFactory(e));
    });
  });
}

SyntheticEvent syntheticEventFactory(JsObject e) {
  return new SyntheticEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"]);
}

SyntheticEvent syntheticClipboardEventFactory(JsObject e) {
  return new SyntheticClipboardEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["clipboardData"]);
}

SyntheticEvent syntheticKeyboardEventFactory(JsObject e) {
  return new SyntheticKeyboardEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"],
      e["nativeEvent"], e["target"], e["timeStamp"], e["type"], e["altKey"],
      e["char"], e["charCode"], e["ctrlKey"], e["locale"], e["location"],
      e["key"], e["keyCode"], e["metaKey"], e["repeat"], e["shiftKey"]);
}

SyntheticEvent syntheticFocusEventFactory(JsObject e) {
  return new SyntheticFocusEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["relatedTarget"]);
}

SyntheticEvent syntheticFormEventFactory(JsObject e) {
  return new SyntheticFormEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"]);
}

SyntheticDataTransfer syntheticDataTransferFactory(JsObject dt) {
  if (dt == null) return null;
  List<File> files = [];
  if (dt["files"] != null) {
    for (int i = 0; i < dt["files"]["length"]; i++) {
      files.add(dt["files"][i]);
    }
  }
  List<String> types = [];
  if (dt["types"] != null) {
    for (int i = 0; i < dt["types"]["length"]; i++) {
      types.add(dt["types"][i]);
    }
  }
  var effectAllowed;
  try {
    // Works around a bug in IE where dragging from outside the browser fails.
    // Trying to access this property throws the error "Unexpected call to method or property access.".
    effectAllowed = dt["effectAllowed"];
  } catch (exception) {
    effectAllowed = "uninitialized";
  }
  return new SyntheticDataTransfer(dt["dropEffect"], effectAllowed, files, types);
}

SyntheticEvent syntheticMouseEventFactory(JsObject e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e["dataTransfer"]);
  return new SyntheticMouseEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["altKey"], e["button"], e["buttons"], e["clientX"], e["clientY"],
      e["ctrlKey"], dt, e["metaKey"], e["pageX"], e["pageY"], e["relatedTarget"], e["screenX"],
      e["screenY"], e["shiftKey"]);
}

SyntheticEvent syntheticTouchEventFactory(JsObject e) {
  return new SyntheticTouchEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["altKey"], e["changedTouches"], e["ctrlKey"], e["metaKey"],
      e["shiftKey"], e["targetTouches"], e["touches"]);
}

SyntheticEvent syntheticUIEventFactory(JsObject e) {
  return new SyntheticUIEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["detail"], e["view"]);
}

SyntheticEvent syntheticWheelEventFactory(JsObject e) {
  return new SyntheticWheelEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["deltaX"], e["deltaMode"], e["deltaY"], e["deltaZ"]);
}

Set _syntheticClipboardEvents = new Set.from(["onCopy", "onCut", "onPaste",]);

Set _syntheticKeyboardEvents = new Set.from(["onKeyDown", "onKeyPress",
    "onKeyUp",]);

Set _syntheticFocusEvents = new Set.from(["onFocus", "onBlur",]);

Set _syntheticFormEvents = new Set.from(["onChange", "onInput", "onSubmit",
]);

Set _syntheticMouseEvents = new Set.from(["onClick", "onContextMenu",
    "onDoubleClick", "onDrag", "onDragEnd", "onDragEnter", "onDragExit",
    "onDragLeave", "onDragOver", "onDragStart", "onDrop", "onMouseDown",
    "onMouseEnter", "onMouseLeave", "onMouseMove", "onMouseOut",
    "onMouseOver", "onMouseUp",]);

Set _syntheticTouchEvents = new Set.from(["onTouchCancel", "onTouchEnd",
    "onTouchMove", "onTouchStart",]);

Set _syntheticUIEvents = new Set.from(["onScroll",]);

Set _syntheticWheelEvents = new Set.from(["onWheel",]);


void _render(JsObject component, HtmlElement element) {
  _React.callMethod('render', [component, element]);
}

bool _unmountComponentAtNode(HtmlElement element) {
  return _React.callMethod('unmountComponentAtNode', [element]);
}

dynamic _findDomNode(component) {
  // if it's a dart component class, the mounted dom is returned from getDOMNode
  // which has jsComponent closured inside and calls on it findDOMNode
  if (component is Component) return component.getDOMNode();
  //otherwise we have js component so pass it in findDOM node
  return _React.callMethod('findDOMNode', [component]);
}

void setClientConfiguration() {
  _React.callMethod('initializeTouchEvents', [true]);
  setReactConfiguration(_reactDom, _registerComponent, _render, null, _unmountComponentAtNode, _findDomNode);
}
