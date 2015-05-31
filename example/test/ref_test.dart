import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";


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
  showInputValue(_) {
    var input = react.findDOMNode(ref('inputRef')) as InputElement;
    print(input.value);
  }
  showChildValue(_) {
    print(ref("childRef").somevalue);
  }
  incrementChildValue(_) {
    ref("childRef").incrementValue();
  }
  render() =>
    react.div({},[
      react.input({"ref": "inputRef"}),
      react.button({"onClick": showInputValue}, "print input element value"),
      ChildComponent({"ref": "childRef"}),
      react.button({"onClick": showChildValue}, "Show child value"),
      react.button({"onClick": incrementChildValue}, "Show child value"),

    ]);
}

var mountedNode = querySelector('#content');
void main() {
  setClientConfiguration();
  var component = ParrentComponent({});
  react.render(component, mountedNode);
}