@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html' as html;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;

import 'shared_type_tester.dart';

main() {
  setClientConfiguration();

  void testTypeValue(dynamic typeToTest) {
    var mountNode = new html.DivElement();
    var contextTypeRef;
    var consumerRef;
    react_dom.render(
        ContextProviderWrapper({
          'contextToUse': TestContext,
          'value': typeToTest,
        }, [
          ContextTypeComponent({
            'ref': (ref) {
              contextTypeRef = ref;
            }
          }),
          ContextConsumerWrapper({
            'contextToUse': TestContext,
            'ref': (ref) {
              consumerRef = ref;
            }
          })
        ]),
        mountNode);
    expect(contextTypeRef.context, same(typeToTest));
    expect(consumerRef.latestValue, same(typeToTest));
  }

  group('New Context API (Component2 only)', () {
    group('sets and retrieves values correctly:', () {
      sharedTypeTests(testTypeValue);
    });

    group('calculateChangeBits argument functions correctly', () {
      var mountNode = new html.DivElement();
      _ContextProviderWrapper providerRef;
      _ContextConsumerWrapper consumerEvenRef;
      _ContextConsumerWrapper consumerOddRef;

      setUp(() {
        react_dom.render(
            ContextProviderWrapper({
              'contextToUse': TestCalculateChangedBitsContext,
              'mode': 'increment',
              'ref': (ref) {
                providerRef = ref;
              }
            }, [
              ContextConsumerWrapper({
                'key': 'EvenContextConsumer',
                'contextToUse': TestCalculateChangedBitsContext,
                'unstable_observedBits': 1 << 2,
                'ref': (ref) {
                  consumerEvenRef = ref;
                }
              }),
              ContextConsumerWrapper({
                'key': 'OddContextConsumer',
                'contextToUse': TestCalculateChangedBitsContext,
                'unstable_observedBits': 1 << 3,
                'ref': (ref) {
                  consumerOddRef = ref;
                }
              })
            ]),
            mountNode);
      });

      test('on first render', () {
        expect(consumerEvenRef.latestValue, 1);
        expect(consumerOddRef.latestValue, 1);
      });

      test('on value updates', () {
        providerRef.increment();
        expect(consumerEvenRef.latestValue, 2);
        expect(consumerOddRef.latestValue, 1);
        providerRef.increment();
        expect(consumerEvenRef.latestValue, 2);
        expect(consumerOddRef.latestValue, 3);
        providerRef.increment();
        expect(consumerEvenRef.latestValue, 4);
        expect(consumerOddRef.latestValue, 3);
      });
    });
  });
}

int calculateChangedBits(currentValue, nextValue) {
  int result = 0;
  if (nextValue % 2 == 0) {
    // Bit for even values
    result |= 1 << 2;
  }
  if (nextValue % 3 == 0) {
    // Bit for odd values
    result |= 1 << 3;
  }
  return result;
}

var TestCalculateChangedBitsContext = react.createContext(1, calculateChangedBits);

var TestContext = react.createContext();

ReactDartComponentFactoryProxy2 ContextProviderWrapper = react.registerComponent(() => new _ContextProviderWrapper());

class _ContextProviderWrapper extends react.Component2 {
  get initialState {
    return {'counter': 1};
  }

  increment() {
    this.setState({'counter': state['counter'] + 1});
  }

  render() {
    return react.div({}, [
      props['contextToUse']
          .Provider({'value': props['mode'] == 'increment' ? state['counter'] : props['value']}, props['children'])
    ]);
  }
}

ReactDartComponentFactoryProxy2 ContextConsumerWrapper = react.registerComponent(() => new _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 {
  dynamic latestValue;
  render() {
    return props['contextToUse'].Consumer({'unstable_observedBits': props['unstable_observedBits']}, (value) {
      latestValue = value;
      return react.div({}, '$value');
    });
  }
}

ReactDartComponentFactoryProxy2 ContextTypeComponent = react.registerComponent(() => new _ContextTypeComponent());

class _ContextTypeComponent extends react.Component2 {
  var contextType = TestContext;

  render() {
    return react.div({}, '${this.context}');
  }
}
