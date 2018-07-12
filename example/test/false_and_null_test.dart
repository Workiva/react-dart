import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

class _Component extends react.Component {
  render() {
    return props['returnValue'];
  }
}

var component = react.registerComponent(() => new _Component());

void main() {
  setClientConfiguration();

  var content = react.div({}, [
    react.p({}, 'Testing a return value of "null"...'),
    component({'returnValue': null, 'key': 0}),
    react.p({}, 'Testing a return value of "false"...'),
    component({'returnValue': false, 'key': 1}),
  ]);
  react_dom.render(content, querySelector('#content'));
}
