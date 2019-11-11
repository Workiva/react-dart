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
      ReactDartFunctionComponentFactoryProxy UseEffectTest;
      ButtonElement countButtonRef;
      ButtonElement countDownButtonRef;
      DivElement countRef;
      DivElement countDownRef;
      int useEffectCallCount = 0;
      int useEffectCleanupCallCount = 0;
      int useEffectWithDepsCallCount = 0;
      int useEffectCleanupWithDepsCallCount = 0;
      int useEffectWithDepsCallCount2 = 0;
      int useEffectCleanupWithDepsCallCount2 = 0;
      int useEffectWithEmptyDepsCallCount = 0;
      int useEffectCleanupWithEmptyDepsCallCount = 0;
      DivElement mountNode;

      setUpAll(() async {
        mountNode = new DivElement();

        UseEffectTest = react.registerFunctionComponent((Map props) {
          final count = useState(0);
          final countDown = useState(0);

          useEffect(() {
            useEffectCallCount++;
            print('123');
            return () {
              useEffectCleanupCallCount++;
            };
          });

          useEffect(() {
            useEffectWithDepsCallCount++;
            return () {
              useEffectCleanupWithDepsCallCount++;
            };
          }, [count.value]);

          useEffect(() {
            useEffectWithDepsCallCount2++;
            return () {
              useEffectCleanupWithDepsCallCount2++;
            };
          }, [countDown.value]);

          useEffect(() {
            useEffectWithEmptyDepsCallCount++;
            return () {
              useEffectCleanupWithEmptyDepsCallCount++;
            };
          }, []);

          print('abc');

          return react.div({}, [
            react.div({
              'ref': (ref) {
                countRef = ref;
              },
            }, [
              count.value
            ]),
            react.button({
              'onClick': (_) {
                count.set(count.value + 1);
              },
              'ref': (ref) {
                countButtonRef = ref;
              },
            }, [
              '+'
            ]),
            countDown.value,
            react.button({
              'onClick': (_) {
                countDown.set(countDown.value - 1);
              },
            }, [
              '-'
            ]),
          ]);
        });

        react_dom.render(UseEffectTest({}), mountNode);

        await pumpEventQueue();
      });

      test('side effect is called after the first render', () {
        expect(countRef.text, '0');
        expect(useEffectCallCount, 1);
        expect(useEffectCleanupCallCount, 0, reason: 'component has not been unmounted or re-rendered');
      });

      test('side effect with dependencies is called after the first render', () {
        expect(useEffectWithDepsCallCount, 1);
        expect(useEffectCleanupWithDepsCallCount, 0, reason: 'component has not been unmounted or re-rendered');

        expect(useEffectWithDepsCallCount2, 1);
        expect(useEffectCleanupWithDepsCallCount2, 0, reason: 'component has not been unmounted or re-rendered');
      });

      test('side effect with empty dependency list is called after the first render', () {
        expect(useEffectWithEmptyDepsCallCount, 1);
        expect(useEffectCleanupWithEmptyDepsCallCount, 0, reason: 'component has not been unmounted or re-rendered');
      });

      group('after state change,', () {
        setUpAll(() async {
          react_test_utils.Simulate.click(countButtonRef);

          await pumpEventQueue();
        });

        test('cleanup is run and side effect is called again with no dependency list', () {
          expect(countRef.text, '1');

          expect(useEffectCallCount, 2, reason: 'component is rendered for the second time');
          expect(useEffectCleanupCallCount, 1, reason: 'component was re-rendered');
        });

        test('cleanup is run and side effect is called again if state is in dependency list', () {
          expect(useEffectWithDepsCallCount, 2, reason: 'count.value changed and component was rendered for the second time');
          expect(useEffectCleanupWithDepsCallCount, 1, reason: 'count.value changed and component was re-rendered');

          expect(useEffectWithDepsCallCount2, 1, reason: 'countDown.value did not change');
          expect(useEffectCleanupWithDepsCallCount2, 0, reason: 'countDown.value did not change');
        });

        test('side effect is not called with empty dependencies', () {
          expect(useEffectWithEmptyDepsCallCount, 1, reason: 'the dependency list is empty so side effects only run once');
          expect(useEffectCleanupWithEmptyDepsCallCount, 0, reason: 'component has not been unmounted or re-rendered');
        });
      });
    });
  });
}
