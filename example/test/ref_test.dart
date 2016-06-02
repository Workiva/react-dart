import "dart:html";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;
import "package:react/react_client.dart";

var ChildComponent = react.registerComponent(() => new _ChildComponent());
class _ChildComponent extends react.Component {
  int somevalue = 10;
  incrementValue() {
    somevalue++;
    redraw();
  }
  render() =>
    react.span({}, "Child element with value ${somevalue}");
}

var ParrentComponent = react.registerComponent(() => new _ParrentComponent());
class _ParrentComponent extends react.Component {
  // String refs
  showInputValue(_) {
    var input = react_dom.findDOMNode(ref('inputRef')) as InputElement;
    print(input.value);
  }
  showChildValue(_) {
    print(ref("childRef").somevalue);
  }
  incrementChildValue(_) {
    ref("childRef").incrementValue();
  }

  // Callback refs
  InputElement _inputCallbackRef;
  _ChildComponent _childCallbackRef;
  showInputCallbackRefValue(_) {
    var input = react_dom.findDOMNode(_inputCallbackRef);
    print(input.value);
  }
  showChildCallbackRefValue(_) {
    print(_childCallbackRef.somevalue);
  }
  incrementChildCallbackRefValue(_) {
    _childCallbackRef.incrementValue();
  }

  render() =>
    react.div({},[
      react.h1({}, "String refs"),
      react.h4({}, "<input>"),
      react.input({"ref": "inputRef"}),
      react.button({"onClick": showInputValue}, "Print input element value"),
      react.h4({}, "ChildComponent"),
      ChildComponent({"ref": "childRef"}),
      react.button({"onClick": showChildValue}, "Print child value"),
      react.button({"onClick": incrementChildValue}, "Increment child value"),

      react.h1({}, "Callback refs"),
      react.h4({}, "<input>"),
      react.input({"ref": (instance) => _inputCallbackRef = instance}),
      react.button({"onClick": showInputCallbackRefValue}, "Print input element value"),
      react.h4({}, "ChildComponent"),
      ChildComponent({"ref": (instance) => _childCallbackRef = instance}),
      react.button({"onClick": showChildCallbackRefValue}, "Print child value"),
      react.button({"onClick": incrementChildCallbackRefValue}, "Increment child value"),
    ]);
}

var mountedNode = querySelector('#content');
void main() {
  setClientConfiguration();
  var component = ParrentComponent({});
  react_dom.render(component, mountedNode);
}
