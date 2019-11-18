import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var useStateTestFunctionComponent = react.registerFunctionComponent(UseStateTestComponent, displayName: 'useStateTest');

UseStateTestComponent(Map props) {
  final count = useState(0);

  return react.div({}, [
    count.value,
    react.button({'onClick': (_) => count.set(0)}, ['Reset']),
    react.button({
      'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
    }, [
      '+'
    ]),
  ]);
}

var useCallbackTestFunctionComponent =
    react.registerFunctionComponent(UseCallbackTestComponent, displayName: 'useCallbackTest');

UseCallbackTestComponent(Map props) {
  final count = useState(0);
  final delta = useState(1);

  var increment = useCallback((_) {
    count.setWithUpdater((prev) => prev + delta.value);
  }, [delta.value]);

  var incrementDelta = useCallback((_) {
    delta.setWithUpdater((prev) => prev + 1);
  }, []);

  return react.div({}, [
    react.div({}, ['Delta is ${delta.value}']),
    react.div({}, ['Count is ${count.value}']),
    react.button({'onClick': increment}, ['Increment count']),
    react.button({'onClick': incrementDelta}, ['Increment delta']),
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState Hook Test']),
          useStateTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
          react.br({}),
          react.h2({'key': 'useCallbackTestLabel'}, ['useCallback Hook Test']),
          useCallbackTestFunctionComponent({
            'key': 'useCallbackTest',
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
