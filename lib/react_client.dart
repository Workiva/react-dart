// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_client;

import "package:react/react.dart";
import "dart:js";
import "dart:html";

/**
 * Type of [children] must be child or list of childs, when child is JsObject or String
 */
typedef JsObject ReactComponentFactory(Map props, [dynamic children]);
typedef Component ComponentFactory(Map props, JsObject jsThis);

_getInternal(JsObject jsThis) => jsThis['props']['__internal__'];
_getProps(JsObject jsThis) => _getInternal(jsThis)['props'];
_getComponent(JsObject jsThis) => _getInternal(jsThis)['component'];

ReactComponentFactory _registerComponent(ComponentFactory componentFactory) {
  var componentWillMount = new JsFunction.withThis((jsThis) {
    var internal = _getInternal(jsThis);

    internal['component'] = componentFactory(internal['props'], jsThis);
    internal['component'].componentWillMount();
  });

  var componentWillUnmount = new JsFunction.withThis((jsThis) {
    _getComponent(jsThis).componentWillUnmount();
  });

  var componentWillReceiveProps = new JsFunction.withThis((jsThis, newArgs, reactInternal) {
    var component = _getComponent(jsThis);
    var newProps = newArgs['__internal__']['props'];
    newArgs['__internal__']['component'] = component;
    component.componentWillReceiveProps(newProps);
    component.props = newProps;
  });

  var render = new JsFunction.withThis((jsThis) {
    return _getComponent(jsThis).render();
  });

  var reactComponent = context['React'].callMethod('createClass', [new JsObject.jsify({
    'componentWillMount': componentWillMount,
    'componentWillUnmount': componentWillUnmount,
    'componentWillReceiveProps': componentWillReceiveProps,
    'render': render
  })]); //TODO add all lifecycle methods


  return (Map props, [dynamic children]) {
    var extendedProps = new Map.from(props);

    var convertedArgs = new JsObject.jsify({});
    if (extendedProps.containsKey("key")) {
      convertedArgs["key"] =  extendedProps["key"];
    }
    convertedArgs['__internal__'] = {'props': extendedProps};
    if (children is List) {
      children = new JsObject.jsify(children);
    }
    return reactComponent.apply([convertedArgs, children]);
  };

}

ComponentFactory _reactDom(String name) {
  return (args, [children]) {
    _convertEventHandlers(args);
    if(children is List){
      children = new JsObject.jsify(children);
    }
    return context['React']['DOM'].callMethod(name, [new JsObject.jsify(args), children]);
  };
}

_convertEventHandlers(Map args) {
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
    args[key] = (JsObject e, String domId) {
      value(eventFactory(e));
    };
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
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["altKey"], e["char"], e["ctrlKey"], e["locale"], 
      e["location"], e["key"], e["metaKey"], e["repeat"], e["shiftKey"]); 
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

SyntheticEvent syntheticMouseEventFactory(JsObject e) {
  return new SyntheticMouseEvent(e["bubbles"], e["cancelable"], e["currentTarget"],
      e["defaultPrevented"], () => e.callMethod("preventDefault", []),
      () => e.callMethod("stopPropagation", []), e["eventPhase"], e["isTrusted"], e["nativeEvent"],
      e["target"], e["timeStamp"], e["type"], e["altKey"], e["button"], e["buttons"], e["clientX"], e["clientY"], 
      e["ctrlKey"], e["metaKey"], e["pageX"], e["pageY"], e["relatedTarget"], e["screenX"], 
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

Set _syntheticMouseEvents = new Set.from(["onClick", "onDoubleClick",
    "onDrag", "onDragEnd", "onDragEnter", "onDragExit", "onDragLeave",
    "onDragOver", "onDragStart", "onDrop", "onMouseDown", "onMouseEnter",
    "onMouseLeave", "onMouseMove", "onMouseUp",]);

Set _syntheticTouchEvents = new Set.from(["onTouchCancel", "onTouchEnd",
    "onTouchMove", "onTouchStart",]);

Set _syntheticUIEvents = new Set.from(["onScroll",]);

Set _syntheticWheelEvents = new Set.from(["onWheel",]);


void _renderComponent(JsObject component, HtmlElement element) {
  context['React'].callMethod('renderComponent', [component, element]);
}

void setClientConfiguration() {
  registerComponent = _registerComponent;
  renderComponent = _renderComponent;

  // HTML Elements
  a = _reactDom('a');
  abbr = _reactDom('abbr');
  address = _reactDom('address');
  area = _reactDom('area');
  article = _reactDom('article');
  aside = _reactDom('aside');
  audio = _reactDom('audio');
  b = _reactDom('b');
  base = _reactDom('base');
  bdi = _reactDom('bdi');
  bdo = _reactDom('bdo');
  big = _reactDom('big');
  blockquote = _reactDom('blockquote');
  body = _reactDom('body');
  br = _reactDom('br');
  button = _reactDom('button');
  canvas = _reactDom('canvas');
  caption = _reactDom('caption');
  cite = _reactDom('cite');
  code = _reactDom('code');
  col = _reactDom('col');
  colgroup = _reactDom('colgroup');
  data = _reactDom('data');
  datalist = _reactDom('datalist');
  dd = _reactDom('dd');
  del = _reactDom('del');
  details = _reactDom('details');
  dfn = _reactDom('dfn');
  div = _reactDom('div');
  dl = _reactDom('dl');
  dt = _reactDom('dt');
  em = _reactDom('em');
  embed = _reactDom('embed');
  fieldset = _reactDom('fieldset');
  figcaption = _reactDom('figcaption');
  figure = _reactDom('figure');
  footer = _reactDom('footer');
  form = _reactDom('form');
  h1 = _reactDom('h1');
  h2 = _reactDom('h2');
  h3 = _reactDom('h3');
  h4 = _reactDom('h4');
  h5 = _reactDom('h5');
  h6 = _reactDom('h6');
  head = _reactDom('head');
  header = _reactDom('header');
  hr = _reactDom('hr');
  html = _reactDom('html');
  i = _reactDom('i');
  iframe = _reactDom('iframe');
  img = _reactDom('img');
  input = _reactDom('input');
  ins = _reactDom('ins');
  kbd = _reactDom('kbd');
  keygen = _reactDom('keygen');
  label = _reactDom('label');
  legend = _reactDom('legend');
  li = _reactDom('li');
  link = _reactDom('link');
  main = _reactDom('main');
  map = _reactDom('map');
  mark = _reactDom('mark');
  menu = _reactDom('menu');
  menuitem = _reactDom('menuitem');
  meta = _reactDom('meta');
  meter = _reactDom('meter');
  nav = _reactDom('nav');
  noscript = _reactDom('noscript');
  object = _reactDom('object');
  ol = _reactDom('ol');
  optgroup = _reactDom('optgroup');
  option = _reactDom('option');
  output = _reactDom('output');
  p = _reactDom('p');
  param = _reactDom('param');
  pre = _reactDom('pre');
  progress = _reactDom('progress');
  q = _reactDom('q');
  rp = _reactDom('rp');
  rt = _reactDom('rt');
  ruby = _reactDom('ruby');
  s = _reactDom('s');
  samp = _reactDom('samp');
  script = _reactDom('script');
  section = _reactDom('section');
  select = _reactDom('select');
  small = _reactDom('small');
  source = _reactDom('source');
  span = _reactDom('span');
  strong = _reactDom('strong');
  style = _reactDom('style');
  sub = _reactDom('sub');
  summary = _reactDom('summary');
  sup = _reactDom('sup');
  table = _reactDom('table');
  tbody = _reactDom('tbody');
  td = _reactDom('td');
  textarea = _reactDom('textarea');
  tfoot = _reactDom('tfoot');
  th = _reactDom('th');
  thead = _reactDom('thead');
  time = _reactDom('time');
  title = _reactDom('title');
  tr = _reactDom('tr');
  track = _reactDom('track');
  u = _reactDom('u');
  ul = _reactDom('ul');
  variable = _reactDom('var');
  video = _reactDom('video');
  wbr = _reactDom('wbr');

  // SVG Elements
  circle = _reactDom('circle');
  g = _reactDom('g');
  line = _reactDom('line');
  path = _reactDom('path');
  polyline = _reactDom('polyline');
  rect = _reactDom('rect');
  svg = _reactDom('svg');
  text = _reactDom('text');
}
