// ignore_for_file: deprecated_member_use_from_same_package
import "dart:html";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;

var SimpleComponent = react.registerComponent2(() => _SimpleComponent());

class _SimpleComponent extends react.Component2 {
  componentDidMount() => print("mount");

  componentWillUnmount() => print("unmount");

  render() => react.div({}, [
        "Simple component",
      ]);
}

void main() {
  var root = react_dom.createRoot(querySelector('#content'));

  querySelector('#mount').onClick.listen((_) => root.render(SimpleComponent({})));

  querySelector('#unmount').onClick.listen((_) {
    root.unmount();
    root = react_dom.createRoot(querySelector('#content'));
  });
}
