import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

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

  componentDidMount(root) {
    customAssert("ref to span return span ", (react.findDOMNode(ref("refToSpan")) as SpanElement).text == "Test");
    customAssert("getDomNode is same as mounted element", root == getDOMNode());
    customAssert("findDOMNode work on this", root == react.findDOMNode(this));
    customAssert("random ref resolute to null", react.findDOMNode(ref("someRandomRef")) == null);
  }

  var counter = 0;

  render() =>
    react.div({}, [
      react.span({"ref": "refToSpan"}, "Test"),
      react.span({}, counter),
      react.button({"onClick": (_) => (getDOMNode() as HtmlElement).children.first.text = (++counter).toString()},"Increase counter"),
      react.br({}),
      ChildComponent({"ref": "refToElement"}),
      react.button({"onClick": (_) => window.alert((this.ref('test') as _ChildComponent).counter.toString())}, "Show value of child element"),
    ]);
}

var mountedNode = querySelector('#content');

void main() {
  setClientConfiguration();
  var component = simpleComponent({});
  react.render(component, mountedNode);
}