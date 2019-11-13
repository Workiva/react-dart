import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var useStateTestFunctionComponent = react.registerFunctionComponent(UseStateTestComponent, displayName: 'useStateTest');

Map reducer(Map state, Map action) {
  switch (action['type']) {
    case 'increment':
      return {'count': state['count'] + 1};
    case 'decrement':
      return {'count': state['count'] - 1};
    default:
      return state;
  }
}

UseStateTestComponent(Map props) {
  final state = useReducer(reducer, {'count': 0});

  return react.div({}, [
    state.state['count'],
    react.button({
      'onClick': (_) => state.dispatch({'type': 'increment'})
    }, [
      '+'
    ]),
    react.button({
      'onClick': (_) => state.dispatch({'type': 'decrement'})
    }, [
      '-'
    ]),
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
            'enabled': true,
          }, []),
//          react.br({}),
//          react.h5({'key': 'useStateTestLabel-2'}, 'Disabled:'),
//          useStateTestFunctionComponent({
//            'key': 'useStateTest',
//            'enabled': false,
//          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
