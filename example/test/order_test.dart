// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:html';

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;

class _Item extends react.Component {
  componentWillReceiveProps(newProps) {
    print("Old props: $props");
    print("New props: $newProps");
  }

  shouldComponentUpdate(nextProps, nextState) {
    return false;
  }

  render() {
    return react.li({}, [props['text']]);
  }
}

var item = react.registerComponent(() => new _Item());

class _List extends react.Component2 {
  var items = ['item1', 'item2', 'item3'];

  remove() {
    items.removeAt(0);
    setState({});
  }

  render() {
    return react.ul({'onClick': (e) => remove()}, items.map((text) => item({'text': text, 'key': text})));
  }
}

var list = react.registerComponent2(() => _List());

void main() {
  final root = react_dom.createRoot(querySelector('#content'));
  root.render(list({}));
}
