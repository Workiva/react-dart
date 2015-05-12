import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

var secondElement = react.registerComponent(() => new SecondComponent());
class SecondComponent extends react.Component {

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

    print("getDomNode is same as mounted element ${root == getDOMNode()}");
    print(ref("some random"));
    print(ref("test"));
    print(react.findDOMNode(ref("test")) == ref("test").getDOMNode());
    print(ref("someRandomRef"));
    print(react.findDOMNode(ref("someRandomRef")));

  }

  var counter = 0;

  render() =>
    react.div({}, [
      react.span({"ref": "someRandomRef"}, "Test"),
      react.span({}, counter),
      react.button({"onClick": (_) => (getDOMNode() as HtmlElement).children.first.text = (++counter).toString()},"Increase counter"),
      react.br({}),
      secondElement({"ref": "test"}),
      react.button({"onClick": (_) => window.alert((this.ref('test') as SecondComponent).counter.toString())}, "Show value"),
    ]);
}

var mountedNode = querySelector('#content');

void main() {
  setClientConfiguration();
  var component = simpleComponent({});
  react.render(component, mountedNode);
}