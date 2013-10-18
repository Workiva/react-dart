// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A Dart library for building user interfaces.
 */
library react;

import "package:js/js.dart" as js;
//import "dart:js" as js;
import "dart:html";
export "package:js/js.dart" show Proxy;

var _lastId = 0;
var _componentStore = {};

num _addToStore(dynamic object) {
  var id = _lastId++;
  _componentStore[id] = object;
  return id;
}


abstract class Component {
  Map props;
  final _jsThis;
  Map state = {};

  num _stateVersion = 0;

  Component(this.props, this._jsThis);

  void setState(Map newState) {
    state.addAll(newState);
    _jsThis.setState(js.map({"__version__": _stateVersion++}));
  }

  void replaceState(Map newState) {
    state = new Map.from(newState);
    _jsThis.setState(js.map({"__version__": _stateVersion++}));
  }
  void componentWillReceiveProps(newProps) {

  }

  void componentWillMount() {

  }
  js.Proxy render();

}

typedef js.Proxy ReactComponentFactory(Map args, Map props, [List<js.Proxy> children]);
typedef Component ComponentFactory(Map props, js.Proxy jsThis);



js.Proxy _convertArgs(Map args) {
  var newArgs = {};
  args.forEach((k, v) {
    var value = v;
    if (v is Function) {
      value = new js.Callback.many(v); // TODO Fix this memory leak
    }
    newArgs[k] = value;
  });
  return js.map(newArgs);
}

ReactComponentFactory registerComponent(componentFactory) {
  var componentWillMount = new js.Callback.many((jsThis) {
    var id = jsThis.props['__id__'];
    var props = _componentStore[id];
    var component = componentFactory(props, jsThis);
    _componentStore[id] = component;
    component.componentWillMount();
    js.retain(jsThis);
  }, withThis: true);

  var componentWillUnmount = new js.Callback.many((jsThis) {
    var component = _componentStore[jsThis.props['__id__']];
  });

  var componentWillReceiveProps = new js.Callback.many((jsThis, newArgs) {
    var component = _componentStore[jsThis.props['__id__']];
    var newProps = _componentStore[newArgs['__id__']];
    component.componentWillReceiveProps(newProps);
    component.props = newProps;
  }, withThis: true);

  var render = new js.Callback.many((jsThis) {
    return _componentStore[jsThis.props['__id__']].render();
  }, withThis: true);

  var reactComponent = js.context.React.createClass(js.map({
    'componentWillMount': componentWillMount,
    'componentWillReceiveProps': componentWillReceiveProps,
    'render': render
  })); //TODO add all lifecycle methods

  js.retain(reactComponent);

  return (args, props, [children]) {
    var extendedProps = new Map.from(props)
        ..addAll(args);

    var convertedArgs = _convertArgs(args);
    convertedArgs['__id__'] = _addToStore(extendedProps);
    return reactComponent(convertedArgs, children);
  };

}

js.Proxy div(args, [children]) {
  return js.context.React.DOM.div(_convertArgs(args), children);
}

void renderComponent(js.Proxy component, Element element) {
  js.context.React.renderComponent(component, element);
}