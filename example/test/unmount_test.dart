import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

var simpleComponent = react.registerComponent(() => new SimpleComponent());
class SimpleComponent extends react.Component {
  componentWillMount() => print("mount");
  
  componentWillUnmount() => print("unmount");
  
  render() =>
    react.div({}, [
      "Simple component",
    ]);
}


void main() {
  print("What");
  setClientConfiguration();
  var mountedNode = querySelector('#content');
  
  querySelector('#mount').onClick.listen(
    (_) => react.render(simpleComponent({}), mountedNode));
    
                    
  querySelector('#unmount').onClick.listen(
      (_) => react.unmountComponentAtNode(mountedNode));
}