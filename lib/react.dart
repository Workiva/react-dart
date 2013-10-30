// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A Dart library for building user interfaces.
 */
library react;

import "dart:js";
import "dart:html";


abstract class Component {
  Map props;
  final _jsThis;
  Map state = {};

  Component(this.props, this._jsThis);

  void setState(Map newState) {
    state.addAll(newState);
    _jsThis.callMethod('setState', [null]);
  }

  void replaceState(Map newState) {
    state = new Map.from(newState);
    _jsThis.callMethod('setState', [null]);
  }
  void componentWillReceiveProps(newProps) {

  }

  void componentWillMount() {

  }
  JsObject render();

}

typedef JsObject ReactComponentFactory(Map args, Map props, [List<JsObject> children]);
typedef Component ComponentFactory(Map props, JsObject jsThis);

_getInternal(JsObject jsThis) => jsThis['props']['__internal__'];
_getProps(JsObject jsThis) => _getInternal(jsThis)['props'];
_getComponent(JsObject jsThis) => _getInternal(jsThis)['component'];

ReactComponentFactory registerComponent(componentFactory) {
  var componentWillMount = new JsFunction.withThis((jsThis) {
    var internal = _getInternal(jsThis);

    internal['component'] = componentFactory(internal['props'], jsThis);
    internal['component'].componentWillMount();
  });

  var componentWillUnmount = new JsFunction.withThis((jsThis) {
    var component = _getComponent(jsThis);
  });

  var componentWillReceiveProps = new JsFunction.withThis((jsThis, newArgs) {
    var component = _getComponent(jsThis);
    var newProps = newArgs['__internal__']['props'];
    component.componentWillReceiveProps(newProps);
    component.props = newProps;
  });

  var render = new JsFunction.withThis((jsThis) {
    return _getComponent(jsThis).render();
  });

  var reactComponent = context['React'].callMethod('createClass', [new JsObject.jsify({
    'componentWillMount': componentWillMount,
    'componentWillReceiveProps': componentWillReceiveProps,
    'render': render
  })]); //TODO add all lifecycle methods


  return (args, props, [children]) {
    var extendedProps = new Map.from(props)
        ..addAll(args);

    var convertedArgs = new JsObject.jsify(args);
    convertedArgs['__internal__'] = {'props': extendedProps};
    return reactComponent.apply([convertedArgs, children]);
  };

}

JsObject div(args, [children]) {
  return context['React']['DOM'].callMethod('div', [new JsObject.jsify(args), children]);
}

void renderComponent(JsObject component, HtmlElement element) {
  context['React'].callMethod('renderComponent', [component, element]);
}