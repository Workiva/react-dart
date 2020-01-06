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
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState & useEffect Hook Test']),
          hookTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
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
