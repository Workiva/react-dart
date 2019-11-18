import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var useReducerTestFunctionComponent = react.registerFunctionComponent(UseReducerTestComponent, displayName: 'useReducerTest');

Map initializeCount(int initialValue) {
  return {'count': initialValue};
}

Map reducer(Map state, Map action) {
  switch (action['type']) {
    case 'increment':
      return {'count': state['count'] + 1};
    case 'decrement':
      return {'count': state['count'] - 1};
    case 'reset':
      return initializeCount(action['payload']);
    default:
      return state;
  }
}

UseReducerTestComponent(Map props) {
  final state = useReducerLazy(reducer, props['initialCount'], initializeCount);

  return react.Fragment({}, [
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
    react.button({
      'onClick': (_) => state.dispatch({
        'type': 'reset',
        'payload': props['initialCount'],
      })
    }, [
      'reset'
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
          useReducerTestFunctionComponent({
            'key': 'useStateTest',
            'initialCount': 10,
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
