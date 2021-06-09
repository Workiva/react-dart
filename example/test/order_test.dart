// @dart=2.7
// ^ Do not remove until migrated to null safety. More info at https://wiki.atl.workiva.net/pages/viewpage.action?pageId=189370832
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

class _List extends react.Component {
  var items = ['item1', 'item2', 'item3'];

  remove() {
    items.removeAt(0);
    redraw();
  }

  render() {
    return react.ul({'onClick': (e) => remove()}, items.map((text) => item({'text': text, 'key': text})));
  }
}

var list = react.registerComponent(() => new _List());

void main() {
  react_dom.render(list({}), querySelector('#content'));
}
