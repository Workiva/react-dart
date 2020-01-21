import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var hookTestFunctionComponent = react.registerFunctionComponent(HookTestComponent, displayName: 'useStateTest');

HookTestComponent(Map props) {
  final count = useState(1);
  final evenOdd = useState('even');

  useEffect(() {
    if (count.value % 2 == 0) {
      print('count changed to ' + count.value.toString());
      evenOdd.set('even');
    } else {
      print('count changed to ' + count.value.toString());
      evenOdd.set('odd');
    }
    return () {
      print('count is changing... do some cleanup if you need to');
    };

    /// This dependency prevents the effect from running every time [evenOdd.value] changes.
  }, [count.value]);

  return react.div({}, [
    react.button({'onClick': (_) => count.set(1), 'key': 'ust1'}, ['Reset']),
    react.button({'onClick': (_) => count.setWithUpdater((prev) => prev + 1), 'key': 'ust2'}, ['+']),
    react.br({'key': 'ust3'}),
    react.p({'key': 'ust4'}, ['${count.value} is ${evenOdd.value}']),
  ]);
}

var useReducerTestFunctionComponent =
    react.registerFunctionComponent(UseReducerTestComponent, displayName: 'useReducerTest');

Map initializeCount(int initialValue) {
  return {'count': initialValue};
}

Map reducer(Map state, Map action) {
  switch (action['type']) {
    case 'increment':
      return {...state, 'count': state['count'] + 1};
    case 'decrement':
      return {...state, 'count': state['count'] - 1};
    case 'reset':
      return initializeCount(action['payload']);
    default:
      return state;
  }
}

UseReducerTestComponent(Map props) {
  final ReducerHook<Map, Map, int> state = useReducerLazy(reducer, props['initialCount'], initializeCount);

  return react.Fragment({}, [
    state.state['count'],
    react.button({
      'key': 'urt1',
      'onClick': (_) => state.dispatch({'type': 'increment'})
    }, [
      '+'
    ]),
    react.button({
      'key': 'urt2',
      'onClick': (_) => state.dispatch({'type': 'decrement'})
    }, [
      '-'
    ]),
    react.button({
      'key': 'urt3',
      'onClick': (_) => state.dispatch({
            'type': 'reset',
            'payload': props['initialCount'],
          })
    }, [
      'reset'
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
    react.div({'key': 'ucbt1'}, ['Delta is ${delta.value}']),
    react.div({'key': 'ucbt2'}, ['Count is ${count.value}']),
    react.button({'onClick': increment, 'key': 'ucbt3'}, ['Increment count']),
    react.button({'onClick': incrementDelta, 'key': 'ucbt4'}, ['Increment delta']),
  ]);
}

var useContextTestFunctionComponent =
    react.registerFunctionComponent(UseContextTestComponent, displayName: 'useContextTest');

UseContextTestComponent(Map props) {
  final context = useContext(TestNewContext);
  return react.div({
    'key': 'uct1'
  }, [
    react.div({'key': 'uct2'}, ['useContext counter value is ${context['renderCount']}']),
  ]);
}

int calculateChangedBits(currentValue, nextValue) {
  int result = 1 << 1;
  if (nextValue['renderCount'] % 2 == 0) {
    result |= 1 << 2;
  }
  return result;
}

var TestNewContext = react.createContext<Map>({'renderCount': 0}, calculateChangedBits);

var newContextProviderComponent = react.registerComponent(() => _NewContextProviderComponent());

class _NewContextProviderComponent extends react.Component2 {
  get initialState => {'renderCount': 0, 'complexMap': false};

  render() {
    final provideMap = {'renderCount': this.state['renderCount']};

    return react.div({
      'key': 'ulasda',
      'style': {
        'marginTop': 20,
      }
    }, [
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': _onButtonClick,
      }, 'Redraw'),
      react.br({'key': 'break1'}),
      'TestContext.Provider props.value: ${provideMap}',
      react.br({'key': 'break2'}),
      react.br({'key': 'break3'}),
      TestNewContext.Provider(
        {'key': 'tcp', 'value': provideMap},
        props['children'],
      ),
    ]);
  }

  _onButtonClick(event) {
    this.setState({'renderCount': this.state['renderCount'] + 1, 'complexMap': false});
  }
}

var useRefTestFunctionComponent = react.registerFunctionComponent(UseRefTestComponent, displayName: 'useRefTest');

UseRefTestComponent(Map props) {
  final inputValue = useState('');

  final inputRef = useRef<InputElement>();
  final prevInputValueRef = useRef<String>();

  useEffect(() {
    prevInputValueRef.current = inputValue.value;
  });

  return react.Fragment({}, [
    react.p({'key': 'urtKey1'}, ['Current Input: ${inputValue.value}, Previous Input: ${prevInputValueRef.current}']),
    react.input({'key': 'urtKey2', 'ref': inputRef}),
    react.button({'key': 'urtKey3', 'onClick': (_) => inputValue.set(inputRef.current.value)}, ['Update']),
  ]);
}

final FancyInput = react.forwardRef((props, ref) {
  final inputRef = useRef();

  useImperativeHandle(
    ref,
    () {
      print('FancyInput: useImperativeHandle re-assigns ref.current');
      return {'focus': () => inputRef.current.focus()};
    },
    // Because the return value of createHandle never changes, it is not necessary for ref.current
    // to be re-set on each render so this dependency list is empty.
    [],
  );

  return react.input({
    'ref': inputRef,
    'value': props['value'],
    'onChange': (e) => props['update'](e.target.value),
    'placeholder': props['placeholder'],
    'style': {'borderColor': props['hasError'] ? 'crimson' : '#999'},
  });
});

final useImperativeHandleTestFunctionComponent =
    react.registerFunctionComponent(UseImperativeHandleTestComponent, displayName: 'useImperativeHandleTest');

UseImperativeHandleTestComponent(Map props) {
  final city = useState('');
  final state = useState('');
  final error = useState('');
  final message = useState('');

  Ref cityEl = useRef();
  Ref stateEl = useRef();

  validate(_) {
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(city.value)) {
      message.set('Invalid form!');
      error.set('city');
      cityEl.current['focus']();
      return;
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(state.value)) {
      message.set('Invalid form!');
      error.set('state');
      stateEl.current['focus']();
      return;
    }

    error.set('');
    message.set('Valid form!');
  }

  return react.Fragment({}, [
    FancyInput({
      'key': 'fancyInput1',
      'hasError': error.value == 'city',
      'placeholder': 'City',
      'value': city.value,
      'update': city.set,
      'ref': cityEl,
    }, []),
    FancyInput({
      'key': 'fancyInput2',
      'hasError': error.value == 'state',
      'placeholder': 'State',
      'value': state.value,
      'update': state.set,
      'ref': stateEl,
    }, []),
    react.button({'key': 'button1', 'onClick': validate}, ['Validate Form']),
    react.p({'key': 'p1'}, [message.value]),
  ]);
}

final FancyCounter = react.forwardRef((props, ref) {
  final count = useState(0);

  useImperativeHandle(
    ref,
    () {
      print('FancyCounter: useImperativeHandle re-assigns ref.current');
      return ({
        'increment': () => count.setWithUpdater((prev) => prev + props['diff']),
        'decrement': () => count.setWithUpdater((prev) => prev - props['diff']),
      });
    },
    // This dependency prevents unnecessary calls of createHandle, by only re-assigning
    // ref.current when `props['diff']` changes.
    [props['diff']],
  );

  return react.div({}, count.value);
});

final useImperativeHandleTestFunctionComponent2 =
    react.registerFunctionComponent(UseImperativeHandleTestComponent2, displayName: 'useImperativeHandleTest2');

UseImperativeHandleTestComponent2(Map props) {
  final diff = useState(1);

  Ref fancyCounterRef = useRef();

  return react.Fragment({}, [
    FancyCounter({
      'key': 'fancyCounter1',
      'diff': diff.value,
      'ref': fancyCounterRef,
    }, []),
    react.button({
      'key': 'button1',
      'onClick': (_) => fancyCounterRef.current['increment'](),
    }, [
      'Increment by ${diff.value}'
    ]),
    react.button({
      'key': 'button2',
      'onClick': (_) => fancyCounterRef.current['decrement'](),
    }, [
      'Decrement by ${diff.value}'
    ]),
    react.button({'key': 'button3', 'onClick': (_) => diff.setWithUpdater((prev) => prev + 1)}, ['+']),
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState & useEffect Hook Test']),
          hookTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
          react.br({'key': 'br1'}),
          react.h2({'key': 'useCallbackTestLabel'}, ['useCallback Hook Test']),
          useCallbackTestFunctionComponent({
            'key': 'useCallbackTest',
          }, []),
          react.br({'key': 'br2'}),
          react.h2({'key': 'useContextTestLabel'}, ['useContext Hook Test']),
          newContextProviderComponent({
            'key': 'provider',
          }, [
            useContextTestFunctionComponent({
              'key': 'useContextTest',
            }, []),
          ]),
          react.br({'key': 'br3'}),
          react.h2({'key': 'useReducerTestLabel'}, ['useReducer Hook Test']),
          useReducerTestFunctionComponent({
            'key': 'useReducerTest',
            'initialCount': 10,
          }, []),
          react.h2({'key': 'useRefTestLabel'}, ['useRef Hook Test']),
          useRefTestFunctionComponent({
            'key': 'useRefTest',
          }, []),
          react.h2({'key': 'useImperativeHandleTestLabel'}, ['useImperativeHandle Hook Test']),
          useImperativeHandleTestFunctionComponent2({
            'key': 'useImperativeHandleTest',
          }, []),
          react.br({'key': 'br4'}),
          react.br({'key': 'br5'}),
          useImperativeHandleTestFunctionComponent({
            'key': 'useImperativeHandleTest2',
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
