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
      print('count is changing...');
    };

    /// This dependency prevents the effect from running every time [evenOdd.value] changes.
  }, [count.value]);

  return react.div({}, [
    count.value,
    react.button({'onClick': (_) => count.set(0), 'key': 'ust1'}, ['Reset']),
    react.button({'onClick': (_) => count.setWithUpdater((prev) => prev + 1), 'key': 'ust2'}, ['+']),
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
    react.button({'onClick': (_) => count.set(1)}, ['Reset']),
    react.button({
      'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
    }, [
      '+'
    ]),
    react.br({}),
    react.p({}, [count.value.toString() + ' is ' + evenOdd.value.toString()]),
  ]);
}

var useRefTestFunctionComponent = react.registerFunctionComponent(UseRefTestComponent, displayName: 'useRefTest');

UseRefTestComponent(Map props) {
  final inputElement = useRef(null);

  onButtonClick(_) {
    inputElement.current.focus();
  }

  return react.Fragment({}, [
    react.input({'ref': inputElement}),
    react.button({'onClick': onButtonClick}, ['Focus the input']),
  ]);
}

var useRefTestFunctionComponent2 = react.registerFunctionComponent(UseRefTestComponent2, displayName: 'useRefTest2');

UseRefTestComponent2(Map props) {
  final count = useState(0);
  final prevCountRef = useRef();

  useEffect(() {
    prevCountRef.current = count.value;
  });

  final prevCount = prevCountRef.current;

  return react.Fragment({}, [
    react.p({}, ['Now: ${count.value}, before: ${prevCount}']),
    react.button({'onClick': (_) => count.setWithUpdater((prev) => prev + 1)}, ['+']),
  ]);
}

var useRefTestFunctionComponent3 = react.registerFunctionComponent(UseRefTestComponent3, displayName: 'useRefTest3');

UseRefTestComponent3(Map props) {
  final renderIndex = useState(1);
  final refFromUseRef = useRef();
  final refFromCreateRef = react.createRef();

  if(refFromUseRef.current == null) {
    refFromUseRef.current = renderIndex.value;
  }

  if(refFromCreateRef.current == null) {
    refFromCreateRef.current = renderIndex.value;
  }

  return react.Fragment({}, [
    react.p({}, ['Current render index: ${renderIndex.value}']),
    react.p({}, ['refFromUseRef value: ${refFromUseRef.current}']),
    react.p({}, ['refFromCreateRef value: ${refFromCreateRef.current}']),
    react.button({'onClick': (_) => renderIndex.setWithUpdater((prev) => prev + 1)}, ['re-render']),
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({
          'key': 'fctf'
        }, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState & useEffect Hook Test']),
          hookTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
          react.br({'key': 'br'}),
          react.h2({'key': 'useCallbackTestLabel'}, ['useCallback Hook Test']),
          useCallbackTestFunctionComponent({
            'key': 'useCallbackTest',
          }, []),
          newContextProviderComponent({
            'key': 'provider'
          }, [
            useContextTestFunctionComponent({
              'key': 'useContextTest',
            }, []),
          ]),
          react.h2({'key': 'useRefTestLabel'}, ['useRef Hook Test']),
          useRefTestFunctionComponent({
            'key': 'useRefTest',
          }, []),
          react.br({}),
          react.br({}),
          useRefTestFunctionComponent2({
            'key': 'useRefTest2',
          }, []),
          react.br({}),
          react.br({}),
          useRefTestFunctionComponent3({
            'key': 'useRefTest3',
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
