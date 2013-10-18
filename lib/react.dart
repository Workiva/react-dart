// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A Dart library for building user interfaces.
 */
library react;

//import "package:js/js.dart" as js;
import "dart:js" as js;
import "dart:html";

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
    _jsThis.callMethod('setState', [js.jsify({"__version__": _stateVersion++})]);
  }

  void replaceState(Map newState) {
    state = new Map.from(newState);
    _jsThis.callMethod('setState', [js.jsify({"__version__": _stateVersion++})]);
  }
  void componentWillReceiveProps(newProps) {

  }

  void componentWillMount() {

  }
  js.JsObject render();

}

typedef js.JsObject ReactComponentFactory(Map args, Map props, [List<js.JsObject> children]);
typedef Component ComponentFactory(Map props, js.JsObject jsThis);


ReactComponentFactory registerComponent(componentFactory) {
  var componentWillMount = new js.Callback.withThis((jsThis) {
    var id = jsThis['props']['__id__'];
    var props = _componentStore[id];
    var component = componentFactory(props, jsThis);
    _componentStore[id] = component;
    component.componentWillMount();
  });

  var componentWillUnmount = new js.Callback.withThis((jsThis) {
    var component = _componentStore[jsThis['props']['__id__']];
  });

  var componentWillReceiveProps = new js.Callback.withThis((jsThis, newArgs) {
    var component = _componentStore[jsThis['props']['__id__']];
    var newProps = _componentStore[newArgs['__id__']];
    component.componentWillReceiveProps(newProps);
    component.props = newProps;
  });

  var render = new js.Callback.withThis((jsThis) {
    return _componentStore[jsThis['props']['__id__']].render();
  });

  var reactComponent = js.context['React'].callMethod('createClass', [js.jsify({
    'componentWillMount': componentWillMount,
    'componentWillReceiveProps': componentWillReceiveProps,
    'render': render
  })]); //TODO add all lifecycle methods


  return (args, props, [children]) {
    var extendedProps = new Map.from(props)
        ..addAll(args);

    var convertedArgs = js.jsify(args);
    convertedArgs['__id__'] = _addToStore(extendedProps);
    return reactComponent.apply(null, [convertedArgs, children]);
  };

}

js.JsObject div(args, [children]) {
  return js.context['React']['DOM'].callMethod('div', [js.jsify(args), children]);
}

void renderComponent(js.JsObject component, js.JsObject element) {
  js.context['React'].callMethod('renderComponent', [component, element]);
}