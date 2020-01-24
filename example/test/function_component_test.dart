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

final MemoTestDemoWrapper = react.registerComponent(() => _MemoTestDemoWrapper());

class _MemoTestDemoWrapper extends react.Component2 {
  @override
  get initialState => {'localCount': 0, 'someKeyThatMemoShouldIgnore': 0};

  @override
  render() {
    return react.div(
      {'key': 'mtdw'},
      MemoTest({
        'localCount': this.state['localCount'],
        'someKeyThatMemoShouldIgnore': this.state['someKeyThatMemoShouldIgnore'],
      }),
      react.button({
        'type': 'button',
        'className': 'btn btn-primary',
        'style': {'marginRight': '10px'},
        'onClick': (_) {
          this.setState({'localCount': this.state['localCount'] + 1});
        },
      }, 'Update MemoTest props.localCount value (${this.state['localCount']})'),
      react.button({
        'type': 'button',
        'className': 'btn btn-primary',
        'onClick': (_) {
          this.setState({'someKeyThatMemoShouldIgnore': this.state['someKeyThatMemoShouldIgnore'] + 1});
        },
      }, 'Update prop value that MemoTest will ignore (${this.state['someKeyThatMemoShouldIgnore']})'),
    );
  }
}

final MemoTest = react.memo((Map props) {
  final context = useContext(TestNewContext);
  return react.div(
    {},
    react.p(
      {},
      'useContext counter value: ',
      react.strong({}, context['renderCount']),
    ),
    react.p(
      {},
      'props.localCount value: ',
      react.strong({}, props['localCount']),
    ),
    react.p(
      {},
      'props.someKeyThatMemoShouldIgnore value: ',
      react.strong({}, props['someKeyThatMemoShouldIgnore']),
      ' (should never update)',
    ),
  );
}, areEqual: (prevProps, nextProps) {
  return prevProps['localCount'] == nextProps['localCount'];
}, displayName: 'MemoTest');

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

int fibonacci(int n) {
  if (n <= 1) {
    return 1;
  }
  return fibonacci(n - 1) + fibonacci(n - 2);
}

final useMemoTestFunctionComponent = react.registerFunctionComponent(UseMemoTestComponent, displayName: 'useMemoTest');

UseMemoTestComponent(Map props) {
  final reRender = useState(0);
  final count = useState(35);

  final fib = useMemo(
    () {
      print('calculating fibonacci...');
      return fibonacci(count.value);
    },

    /// This dependency prevents [fib] from being re-calculated every time the component re-renders.
    [count.value],
  );

  return react.Fragment({}, [
    react.div({'key': 'div'}, ['Fibonacci of ${count.value} is $fib']),
    react.button({'key': 'button1', 'onClick': (_) => count.setWithUpdater((prev) => prev + 1)}, ['+']),
    react.button({'key': 'button2', 'onClick': (_) => reRender.setWithUpdater((prev) => prev + 1)}, ['re-render']),
  ]);
}

final useMemoTestFunctionComponent2 =
    react.registerFunctionComponent(UseMemoTestComponent2, displayName: 'useMemoTest2');

UseMemoTestComponent2(Map props) {
  final reRender = useState(0);
  final count = useState(35);

  print('calculating fibonacci...');
  final fib = fibonacci(count.value);

  return react.Fragment({}, [
    react.div({'key': 'div'}, ['Fibonacci of ${count.value} is ${fib}']),
    react.button({'key': 'button1', 'onClick': (_) => count.setWithUpdater((prev) => prev + 1)}, ['+']),
    react.button({'key': 'button2', 'onClick': (_) => reRender.setWithUpdater((prev) => prev + 1)}, ['re-render']),
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
          react.h2({'key': 'memoTestLabel'}, ['memo Test']),
          newContextProviderComponent(
            {
              'key': 'memoContextProvider',
            },
            MemoTestDemoWrapper({}),
          ),
          react.h2({'key': 'useMemoTestLabel'}, ['useMemo Hook Test']),
          react.h6({'key': 'h61'}, ['With useMemo:']),
          useMemoTestFunctionComponent({
            'key': 'useMemoTest',
          }, []),
          react.br({'key': 'br4'}),
          react.br({'key': 'br5'}),
          react.h6({'key': 'h62'}, ['Without useMemo (notice calculation done on every render):']),
          useMemoTestFunctionComponent2({
            'key': 'useMemoTest2',
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
