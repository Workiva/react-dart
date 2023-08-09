// ignore_for_file: deprecated_member_use_from_same_package
import "dart:html";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;

var simpleComponent = react.registerComponent(() => SimpleComponent());

class SimpleComponent extends react.Component {
  componentWillMount() => print("mount");

  componentWillUnmount() => print("unmount");

  render() => react.div({}, [
        "Simple component",
      ]);
}

void main() {
  print("What");
  var mountedNode = querySelector('#content');

  querySelector('#mount').onClick.listen((_) => react_dom.render(simpleComponent({}), mountedNode));

  querySelector('#unmount').onClick.listen((_) => react_dom.unmountComponentAtNode(mountedNode));
}
