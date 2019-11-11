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

    group('useEffect', () {
      ReactDartFunctionComponentFactoryProxy UseStateTest;
      DivElement textRef;
      DivElement countRef;
      ButtonElement setButtonRef;
      ButtonElement setTxButtonRef;
      int countCalls;
      int countCleanupCalls;
      int countCallsWithDeps1;
      int countCleanupCallsWithDeps1;
      int countCallsWithDeps2;
      int countCleanupCallsWithDeps2;
      int countCallsWithEmptyDeps;
      int countCleanupCallsWithEmptyDeps;

      setUpAll(() {
        var mountNode = new DivElement();
        countCalls = 0;
        countCleanupCalls = 0;
        countCallsWithDeps1 = 0;
        countCleanupCallsWithDeps1 = 0;
        countCallsWithDeps2 = 0;
        countCleanupCallsWithDeps2 = 0;
        countCallsWithEmptyDeps = 0;
        countCleanupCallsWithEmptyDeps = 0;
        var UseStateTest = react.registerFunctionComponent((Map props) {
          final count = useState(0);
          final countDown = useState(0);

          useEffect(() {
            print('useEffect');
            countCalls++;
            return () {
              countCleanupCalls++;
            };
          });

          useEffect(() {
            countCallsWithDeps1++;
            return () {
              countCleanupCallsWithDeps1++;
            };
          }, [count.value]);

          useEffect(() {
            countCallsWithDeps2++;
            return () {
              countCleanupCallsWithDeps2++;
            };
          }, [countDown.value]);

          useEffect(() {
            countCallsWithEmptyDeps++;
            return () {
              countCleanupCallsWithEmptyDeps++;
            };
          }, []);

          return react.div({}, [
            count.value,
            react.button({
              'onClick': (_) {
                count.set(count.value + 1);
                print('useEffect calls: ' + countCalls.toString());
                print('useEffect cleanup calls: ' + countCleanupCalls.toString());
              },
              'ref': (ref) {
                setButtonRef = ref;
              },
            }, [
              '+'
            ]),
            countDown.value,
            react.button({
              'onClick': (_) {
                countDown.set(countDown.value - 1);
                print('useEffect calls: ' + countCalls.toString());
                print('useEffect cleanup calls: ' + countCleanupCalls.toString());
              },
              'ref': (ref) {
                setTxButtonRef = ref;
              },
            }, [
              '-'
            ]),
          ]);
        });

        react_dom.render(UseStateTest({}), mountNode);
      });

      tearDownAll(() {
        UseStateTest = null;
        countCalls = 0;
        countCleanupCalls = 0;
        countCallsWithDeps1 = 0;
        countCleanupCallsWithDeps1 = 0;
        countCallsWithDeps2 = 0;
        countCleanupCallsWithDeps2 = 0;
        countCallsWithEmptyDeps = 0;
        countCleanupCallsWithEmptyDeps = 0;
      });

      test('side effect is called after the first render', () {
        expect(countCalls, 1);
        expect(countCleanupCalls, 0, reason: 'component has only been rendered once');
      });

      test('side effect with dependencies is called after the first render', () {
        expect(countCallsWithDeps1, 1);
        expect(countCleanupCallsWithDeps1, 0);

        expect(countCallsWithDeps2, 1);
        expect(countCleanupCallsWithDeps2, 0);
      });

      test('side effect with empty dependency list is called after the first render', () {
        expect(countCallsWithEmptyDeps, 1);
        expect(countCleanupCallsWithEmptyDeps, 0);
      });
    });
  });
}
