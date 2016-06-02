import "dart:html";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;
import "package:react/react_client.dart";

customAssert(text, condition) {
  if (condition)
    print("${text} passed");
  else
    throw(text);
}

var ChildComponent = react.registerComponent(() => new _ChildComponent());
class _ChildComponent extends react.Component {

  var counter = 0;

  render() =>
    react.div({}, [
      "Test element",
      counter.toString(),
      react.button({"onClick": (_) { counter++;redraw();} }, "Increase counter")
    ]);
}

var simpleComponent = react.registerComponent(() => new SimpleComponent());
class SimpleComponent extends react.Component {
  componentWillMount() => print("mount");

  componentWillUnmount() => print("unmount");

  componentDidMount() {
    customAssert("ref to span return span ", (react_dom.findDOMNode(ref("refToSpan")) as SpanElement).text == "Test");
    customAssert("findDOMNode works on this", react_dom.findDOMNode(this) != null);
    customAssert("random ref resolves to null", react_dom.findDOMNode(ref("someRandomRef")) == null);
  }

  var counter = 0;

  render() =>
    react.div({}, [
      react.span({"ref": "refToSpan"}, "Test"),
      react.span({}, counter),
      react.button({"onClick": (_) => (react_dom.findDOMNode(this) as HtmlElement).children.first.text = (++counter).toString()},"Increase counter"),
      react.br({}),
      ChildComponent({"ref": "refToElement"}),
      react.button({"onClick": (_) => window.alert((this.ref('refToElement') as _ChildComponent).counter.toString())}, "Show value of child element"),
    ]);
}

var mountedNode = querySelector('#content');

void main() {
  setClientConfiguration();
  var component = simpleComponent({});
  react_dom.render(component, mountedNode);
}
