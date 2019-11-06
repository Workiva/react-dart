// ignore_for_file: deprecated_member_use_from_same_package
@TestOn('browser')
@JS()
library hooks_test;

import 'dart:html';

import "package:js/js.dart";
import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

main() {
  setClientConfiguration();

  group('React Hooks: ', () {
    group('useState -', () {
      ReactDartFunctionComponentFactoryProxy UseStateTest;
      DivElement textRef;
      DivElement countRef;
      ButtonElement setButtonRef;
      ButtonElement setTxButtonRef;

      setUpAll(() {
        var mountNode = new DivElement();

        UseStateTest = react.registerFunctionComponent((Map props) {
          final text = useStateLazy(() {
            return 'initialValue';
          });
          final count = useState(0);

          return react.div({}, [
            react.div({
              'ref': (ref) {
                textRef = ref;
              },
            }, [
              text.value
            ]),
            react.div({
              'ref': (ref) {
                countRef = ref;
              },
            }, [
              count.value
            ]),
            react.button({
              'onClick': (_) => text.set('newValue'),
              'ref': (ref) {
                setButtonRef = ref;
              },
            }, [
              'Set'
            ]),
            react.button({
              'onClick': (_) => count.setTx((prev) => prev + 1),
              'ref': (ref) {
                setTxButtonRef = ref;
              },
            }, [
              '+'
            ]),
          ]);
        });

        react_dom.render(UseStateTest({}), mountNode);
      });

      tearDownAll(() {
        UseStateTest = null;
      });

      test('initializes state correctly', () {
        expect(countRef.text, '0');
      });

      test('Init initializes state correctly', () {
        expect(textRef.text, 'initialValue');
      });

      test('StateHook.set updates state correctly', () {
        react_test_utils.Simulate.click(setButtonRef);
        expect(textRef.text, 'newValue');
      });

      test('StateHook.setTx updates state correctly', () {
        react_test_utils.Simulate.click(setTxButtonRef);
        expect(countRef.text, '1');
      });
    });
  });
}
