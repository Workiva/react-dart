import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

class _Component extends react.Component2 {
  @override
  render() {
    if (props['hardCodedNullReturn'] == true) {
      return null;
    }

    return props['returnValue'];
  }
}

var component = react.registerComponent2(() => _Component());

void main() {
  final root = react_dom.createRoot(querySelector('#content')!);
  final content = react.div({}, [
    react.p({}, 'Testing a dynamic return value of "null"...'),
    component({'returnValue': null, 'key': 0}),
    react.p({}, 'Testing a hard-coded return value of "null"...'),
    component({'hardCodedNullReturn': true, 'key': 1}),
    react.p({}, 'Testing a return value of "false"...'),
    component({'returnValue': false, 'key': 2}),
  ]);

  root.render(content);
}
