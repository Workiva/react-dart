import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var hookTestFunctionComponent = react.registerFunctionComponent(HookTestComponent, displayName: 'useStateTest');

HookTestComponent(Map props) {
  final count = useState(1);
  final evenOdd = useState('even');

  useEffectConditional(() {
    if(count.value % 2 == 0) {
      print('count changed to ' + count.value.toString());
      evenOdd.set('even');
    } else {
      print('count changed to ' + count.value.toString());
      evenOdd.set('odd');
    }
    return () {
      print('count is changing...');
    };
  }, [count.value]);

  return react.div({}, [
    react.button({'onClick': (_) => count.set(1)}, ['Reset']),
    react.button({'onClick': (_) => count.setTx((prev) => prev + 1)}, ['+']),
    react.br({}),
    react.p({}, [count.value.toString() + ' is ' + evenOdd.value.toString()]),
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Test']),
          hookTestFunctionComponent({'key': 'useStateTest'}, []),
        ]),
        querySelector('#content'));
  }

  render();
}
