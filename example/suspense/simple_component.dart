import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;

var SimpleComponent = react.registerFunctionComponent(SimpleFunctionComponent,
    displayName: 'simple');

SimpleFunctionComponent(Map props) {
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
    react.button({
      'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
      'key': 'ust2'
    }, [
      '+'
    ]),
    react.br({'key': 'ust3'}),
    react.p({'key': 'ust4'}, ['${count.value} is ${evenOdd.value}']),
  ]);
}
