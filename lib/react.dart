// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A Dart library for building user interfaces.
 */
library react;

abstract class Component {
  Map props;

  dynamic ref;
  dynamic getDOMNode;
  dynamic _jsRedraw;

  /**
   * Bind the value of input to [state[key]].
   */
  bind(key) => [state[key], (value) => setState({key: value})];

  initComponentInternal(props, _jsRedraw, [ref = null, getDOMNode = null]) {
    this._jsRedraw = _jsRedraw;
    this.ref = ref;
    this.getDOMNode = getDOMNode;
    _initProps(props);
  }

  _initProps(props) {
    this.props = {}
      ..addAll(getDefaultProps())
      ..addAll(props);
  }

  initStateInternal() {
    this.state = new Map.from(getInitialState());
    /** Call transferComponent to get state also to _prevState */
    transferComponentState();
  }

  Map state = {};

  /**
   * private _nextState and _prevState are usefull for methods shouldComponentUpdate,
   * componentWillUpdate and componentDidUpdate.
   *
   * Use of theese private variables is implemented in react_client or react_server
   */
  Map _prevState = null;
  Map _nextState = null;
  /**
   * nextState and prevState are just getters for previous private variables _prevState
   * and _nextState
   *
   * if _nextState is null, then next state will be same as actual state,
   * so return state as nextState
   */
  Map get prevState => _prevState;
  Map get nextState => _nextState == null ? state : _nextState;

  /**
   * Transfers component _nextState to state and state to _prevState.
   * This is only way how to set _prevState.
   */
  void transferComponentState() {
    _prevState = state;
    if (_nextState != null) {
      state = _nextState;
    }
    _nextState = new Map.from(state);
  }

  void redraw() {
    setState({});
  }

  /**
   * set _nextState to state updated by newState
   * and call React original setState method with no parameter
   */
  void setState(Map newState) {
    if (newState != null) {
      _nextState.addAll(newState);
    }

    _jsRedraw();
  }

  /**
   * set _nextState to newState
   * and call React original setState method with no parameter
   */
  void replaceState(Map newState) {
    Map nextState = newState == null ? {} : new Map.from(newState);
    _nextState = nextState;
    _jsRedraw();
  }

  void componentWillMount() {}

  void componentDidMount(/*DOMElement */ rootNode) {}

  void componentWillReceiveProps(newProps) {}

  bool shouldComponentUpdate(nextProps, nextState) => true;

  void componentWillUpdate(nextProps, nextState) {}

  void componentDidUpdate(prevProps, prevState, /*DOMElement */ rootNode) {}
  
  void componentWillUnmount() {}

  Map getInitialState() => {};

  Map getDefaultProps() => {};

  dynamic render();

}

/** Synthetic event */

class SyntheticEvent {

  final bool bubbles;
  final bool cancelable;
  final /*DOMEventTarget*/ currentTarget;
  bool _defaultPrevented;
  dynamic _preventDefault;
  final dynamic stopPropagation;
  bool get defaultPrevented => _defaultPrevented;
  final num eventPhase;
  final bool isTrusted;
  final /*DOMEvent*/ nativeEvent;
  void preventDefault() {
    _defaultPrevented = true;
    _preventDefault();
  }
  final /*DOMEventTarget*/ target;
  final num timeStamp;
  final String type;

  SyntheticEvent(
      this.bubbles,
      this.cancelable,
      this.currentTarget,
      this._defaultPrevented,
      this._preventDefault,
      this.stopPropagation,
      this.eventPhase,
      this.isTrusted,
      this.nativeEvent,
      this.target,
      this.timeStamp,
      this.type){}
}

class SyntheticClipboardEvent extends SyntheticEvent {

  final clipboardData;

  SyntheticClipboardEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.clipboardData) : super( bubbles, cancelable, currentTarget, _defaultPrevented,
          _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
          timeStamp, type){}

}

class SyntheticKeyboardEvent extends SyntheticEvent {

  final bool altKey;
  final String char;
  final bool ctrlKey;
  final String locale;
  final num location;
  final String key;
  final bool metaKey;
  final bool repeat;
  final bool shiftKey;
  final num keyCode;
  final num charCode;

  SyntheticKeyboardEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.altKey, this.char, this.charCode, this.ctrlKey,
      this.locale, this.location, this.key, this.keyCode, this.metaKey,
      this.repeat, this.shiftKey) :
        super( bubbles, cancelable, currentTarget, _defaultPrevented,
          _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
          timeStamp, type){}

}

class SyntheticFocusEvent extends SyntheticEvent {

  final /*DOMEventTarget*/ relatedTarget;

  SyntheticFocusEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.relatedTarget) :
        super( bubbles, cancelable, currentTarget, _defaultPrevented,
            _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
            timeStamp, type){}

}

class SyntheticFormEvent extends SyntheticEvent {

  SyntheticFormEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type) : super( bubbles, cancelable, currentTarget, _defaultPrevented,
          _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
          timeStamp, type){}

}

class SyntheticDataTransfer {
  final String dropEffect;
  final String effectAllowed;
  final List/*<File>*/ files;
  final List<String> types;

  SyntheticDataTransfer(this.dropEffect, this.effectAllowed, this.files, this.types);
}

class SyntheticMouseEvent extends SyntheticEvent {

  final bool altKey;
  final num button;
  final num buttons;
  final num clientX;
  final num clientY;
  final bool ctrlKey;
  final SyntheticDataTransfer dataTransfer;
  final bool metaKey;
  final num pageX;
  final num pageY;
  final /*DOMEventTarget*/relatedTarget;
  final num screenX;
  final num screenY;
  final bool shiftKey;

  SyntheticMouseEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.altKey, this.button, this.buttons, this.clientX, this.clientY,
      this.ctrlKey, this.dataTransfer, this.metaKey, this.pageX, this.pageY, this.relatedTarget,
      this.screenX, this.screenY, this.shiftKey) :
        super( bubbles, cancelable, currentTarget, _defaultPrevented,
            _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
            timeStamp, type){}

}

class SyntheticTouchEvent extends SyntheticEvent {

  final bool altKey;
  final /*DOMTouchList*/ changedTouches;
  final bool ctrlKey;
  final bool metaKey;
  final bool shiftKey;
  final /*DOMTouchList*/ targetTouches;
  final /*DOMTouchList*/ touches;

  SyntheticTouchEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.altKey, this.changedTouches, this.ctrlKey, this.metaKey,
      this.shiftKey, this.targetTouches, this.touches) :
        super( bubbles, cancelable, currentTarget, _defaultPrevented,
            _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
            timeStamp, type){}

}

class SyntheticUIEvent extends SyntheticEvent {

  final num detail;
  final /*DOMAbstractView*/ view;

  SyntheticUIEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.detail, this.view) : super( bubbles, cancelable, currentTarget, _defaultPrevented,
          _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
          timeStamp, type){}

}

class SyntheticWheelEvent extends SyntheticEvent {

  final num deltaX;
  final num deltaMode;
  final num deltaY;
  final num deltaZ;

  SyntheticWheelEvent(bubbles, cancelable, currentTarget, _defaultPrevented,
      _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
      timeStamp, type, this.deltaX, this.deltaMode, this.deltaY, this.deltaZ) : super( bubbles, cancelable, currentTarget, _defaultPrevented,
          _preventDefault, stopPropagation, eventPhase, isTrusted, nativeEvent, target,
          timeStamp, type){}


}

/**
 * client side rendering
 */
var render;

/**
 * server side rendering
 */
var renderToString;


/**
 * bool unmountComponentAtNode(HTMLElement);
 * 
 * client side derendering - reverse operation to render
 * 
 */
var unmountComponentAtNode;

/**
 * register component method to register component on both, client-side and server-side.
 */
var registerComponent;

/** Basic DOM elements
 * <var> is renamed to <variable> because var is reserved word in Dart.
 */
var a, abbr, address, area, article, aside, audio, b, base, bdi, bdo, big, blockquote, body, br,
button, canvas, caption, cite, code, col, colgroup, data, datalist, dd, del, details, dfn, dialog,
div, dl, dt, em, embed, fieldset, figcaption, figure, footer, form, h1, h2, h3, h4, h5, h6,
head, header, hr, html, i, iframe, img, input, ins, kbd, keygen, label, legend, li, link, main,
map, mark, menu, menuitem, meta, meter, nav, noscript, object, ol, optgroup, option, output,
p, param, picture, pre, progress, q, rp, rt, ruby, s, samp, script, section, select, small, source,
span, strong, style, sub, summary, sup, table, tbody, td, textarea, tfoot, th, thead, time,
title, tr, track, u, ul, variable, video, wbr;

/** SVG elements */
var circle, defs, ellipse, g, line, linearGradient, mask, path, pattern, polygon, polyline,
radialGradient, rect, stop, svg, text, tspan;


/**
 * Create DOM components by creator passed
 */
_createDOMComponents(creator){
  a = creator('a');
  abbr = creator('abbr');
  address = creator('address');
  area = creator('area');
  article = creator('article');
  aside = creator('aside');
  audio = creator('audio');
  b = creator('b');
  base = creator('base');
  bdi = creator('bdi');
  bdo = creator('bdo');
  big = creator('big');
  blockquote = creator('blockquote');
  body = creator('body');
  br = creator('br');
  button = creator('button');
  canvas = creator('canvas');
  caption = creator('caption');
  cite = creator('cite');
  code = creator('code');
  col = creator('col');
  colgroup = creator('colgroup');
  data = creator('data');
  datalist = creator('datalist');
  dd = creator('dd');
  del = creator('del');
  details = creator('details');
  dfn = creator('dfn');
  dialog = creator('dialog');
  div = creator('div');
  dl = creator('dl');
  dt = creator('dt');
  em = creator('em');
  embed = creator('embed');
  fieldset = creator('fieldset');
  figcaption = creator('figcaption');
  figure = creator('figure');
  footer = creator('footer');
  form = creator('form');
  h1 = creator('h1');
  h2 = creator('h2');
  h3 = creator('h3');
  h4 = creator('h4');
  h5 = creator('h5');
  h6 = creator('h6');
  head = creator('head');
  header = creator('header');
  hr = creator('hr');
  html = creator('html');
  i = creator('i');
  iframe = creator('iframe');
  img = creator('img');
  input = creator('input');
  ins = creator('ins');
  kbd = creator('kbd');
  keygen = creator('keygen');
  label = creator('label');
  legend = creator('legend');
  li = creator('li');
  link = creator('link');
  main = creator('main');
  map = creator('map');
  mark = creator('mark');
  menu = creator('menu');
  menuitem = creator('menuitem');
  meta = creator('meta');
  meter = creator('meter');
  nav = creator('nav');
  noscript = creator('noscript');
  object = creator('object');
  ol = creator('ol');
  optgroup = creator('optgroup');
  option = creator('option');
  output = creator('output');
  p = creator('p');
  param = creator('param');
  picture = creator('picture');
  pre = creator('pre');
  progress = creator('progress');
  q = creator('q');
  rp = creator('rp');
  rt = creator('rt');
  ruby = creator('ruby');
  s = creator('s');
  samp = creator('samp');
  script = creator('script');
  section = creator('section');
  select = creator('select');
  small = creator('small');
  source = creator('source');
  span = creator('span');
  strong = creator('strong');
  style = creator('style');
  sub = creator('sub');
  summary = creator('summary');
  sup = creator('sup');
  table = creator('table');
  tbody = creator('tbody');
  td = creator('td');
  textarea = creator('textarea');
  tfoot = creator('tfoot');
  th = creator('th');
  thead = creator('thead');
  time = creator('time');
  title = creator('title');
  tr = creator('tr');
  track = creator('track');
  u = creator('u');
  ul = creator('ul');
  variable = creator('var');
  video = creator('video');
  wbr = creator('wbr');

  // SVG Elements
  circle = creator('circle');
  g = creator('g');
  defs = creator('defs');
  ellipse = creator('ellipse');
  line = creator('line');
  linearGradient = creator('linearGradient');
  mask = creator('mask');
  path = creator('path');
  pattern = creator('pattern');
  polygon = creator('polygon');
  polyline = creator('polyline');
  radialGradient = creator('radialGradient');
  rect = creator('rect');
  svg = creator('svg');
  stop = creator('stop');
  text = creator('text');
  tspan = creator('tspan');
}

/**
 * set configuration based on passed functions.
 *
 * It pass arguments to global variables and run DOM components creation by dom Creator.
 */
setReactConfiguration(domCreator, customRegisterComponent, customRender, customRenderToString, customUnmountComponentAtNode){
  registerComponent = customRegisterComponent;
  render = customRender;
  renderToString = customRenderToString;
  unmountComponentAtNode = customUnmountComponentAtNode;
  // HTML Elements
  _createDOMComponents(domCreator);
}

