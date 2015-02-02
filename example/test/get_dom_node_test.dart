import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

var simpleComponent = react.registerComponent(() => new SimpleComponent());
class SimpleComponent extends react.Component {
  componentWillMount() => print("mount");
  
  componentWillUnmount() => print("unmount");
  
  componentDidMount(root) {
    print("getDomNode is same as mounted element ${root == getDOMNode()}");
  }
  
  var counter = 0;
  
  render() =>
    react.div({}, [
      react.span({}, counter),
      react.button({"onClick": (_) => (getDOMNode() as HtmlElement).children.first.text = (++counter).toString()},"Increase counter"),
    ]);
}

var mountedNode = querySelector('#content');

void main() {
  setClientConfiguration();
  react.render(simpleComponent({}), mountedNode);
}