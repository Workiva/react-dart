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
      ButtonElement setWithUpdaterButtonRef;

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
              'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
              'ref': (ref) {
                setWithUpdaterButtonRef = ref;
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

      test('Lazy initializes state correctly', () {
        expect(textRef.text, 'initialValue');
      });

      test('StateHook.set updates state correctly', () {
        react_test_utils.Simulate.click(setButtonRef);
        expect(textRef.text, 'newValue');
      });

      test('StateHook.setWithUpdater updates state correctly', () {
        react_test_utils.Simulate.click(setWithUpdaterButtonRef);
        expect(countRef.text, '1');
      });
    });

    group('useReducer -', () {
      ReactDartFunctionComponentFactoryProxy UseReducerTest;
      DivElement textRef;
      DivElement countRef;
      ButtonElement addButtonRef;
      ButtonElement subtractButtonRef;
      ButtonElement textButtonRef;

      Map reducer(Map state, Map action) {
        switch (action['type']) {
          case 'increment':
            return {'count': state['count'] + 1};
          case 'decrement':
            return {'count': state['count'] - 1};
          case 'changeText':
            return {'text': action['newText']};
          default:
            return state;
        }
      }

      setUpAll(() {
        var mountNode = new DivElement();

        UseReducerTest = react.registerFunctionComponent((Map props) {
          final state = useReducer(reducer, {'text': 'initialValue', 'count': 0,});

          return react.div({}, [
            react.div({
              'ref': (ref) {
                textRef = ref;
              },
            }, [
              state.state['text']
            ]),
            react.div({
              'ref': (ref) {
                countRef = ref;
              },
            }, [
              state.state['count']
            ]),
            react.button({
              'onClick': (_) => state.dispatch({'type': 'changeText', 'newText': 'newValue'}),
              'ref': (ref) {
                textButtonRef = ref;
              },
            }, [
              'Set'
            ]),
            react.button({
              'onClick': (_) => state.dispatch({'type': 'increment'}),
              'ref': (ref) {
                addButtonRef = ref;
              },
            }, [
              '+'
            ]),
            react.button({
              'onClick': (_) => state.dispatch({'type': 'decrement'}),
              'ref': (ref) {
                subtractButtonRef = ref;
              },
            }, [
              '-'
            ]),
          ]);
        });

        react_dom.render(UseReducerTest({}), mountNode);
      });

      tearDownAll(() {
        UseReducerTest = null;
      });

      test('initializes state correctly', () {
        expect(countRef.text, '0');
        expect(textRef.text, 'initialValue');
      });

      test('StateHook.set updates state correctly', () {
        react_test_utils.Simulate.click(textButtonRef);
        expect(textRef.text, 'newValue');
      });

      test('StateHook.setWithUpdater updates state correctly', () {
        react_test_utils.Simulate.click(addButtonRef);
        expect(countRef.text, 'a');
      });

      test('StateHook.setWithUpdater updates state correctly', () {
        react_test_utils.Simulate.click(subtractButtonRef);
        expect(countRef.text, 'a');
      });
    });
  });
}
