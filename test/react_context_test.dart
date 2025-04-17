@TestOn('browser')
@JS()
library react_test_utils_test;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;

import 'shared_type_tester.dart';
import 'util.dart';

main() {
  void testTypeValue(dynamic typeToTest) {
    var contextTypeRef;
    var consumerRef;
    render(ContextProviderWrapper({
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
    ]));
    expect(contextTypeRef.context, same(typeToTest));
    expect(consumerRef.latestValue, same(typeToTest));
  }

  group('New Context API (Component2 only)', () {
    group('sets and retrieves values correctly:', () {
      sharedTypeTests(testTypeValue);
    });

    group('calculateChangeBits argument does not throw when used (has no effect in React 18)', () {
      _ContextProviderWrapper? providerRef;
      _ContextConsumerWrapper? consumerEvenRef;
      _ContextConsumerWrapper? consumerOddRef;

      setUp(() {
        render(ContextProviderWrapper({
          'contextToUse': TestCalculateChangedBitsContext,
          'mode': 'increment',
          'ref': (ref) {
            providerRef = ref as _ContextProviderWrapper?;
          }
        }, [
          ContextConsumerWrapper({
            'key': 'EvenContextConsumer',
            'contextToUse': TestCalculateChangedBitsContext,
            'unstable_observedBits': 1 << 2,
            'ref': (ref) {
              consumerEvenRef = ref as _ContextConsumerWrapper?;
            }
          }),
          ContextConsumerWrapper({
            'key': 'OddContextConsumer',
            'contextToUse': TestCalculateChangedBitsContext,
            'unstable_observedBits': 1 << 3,
            'ref': (ref) {
              consumerOddRef = ref as _ContextConsumerWrapper?;
            }
          })
        ]));
      });

      test('on first render', () {
        expect(consumerEvenRef!.latestValue, 1);
        expect(consumerOddRef!.latestValue, 1);
      });

      test('on value updates', () {
        // Test common behavior between React 17 (calculateChangedBits working)
        // and React 18 (it having no effect).
        providerRef!.increment();
        expect(consumerEvenRef!.latestValue, 2);
        providerRef!.increment();
        expect(consumerOddRef!.latestValue, 3);
        providerRef!.increment();
        expect(consumerEvenRef!.latestValue, 4);
      });
    });
  });
}

int calculateChangedBits(currentValue, nextValue) {
  var result = 0;
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

// ignore: deprecated_member_use_from_same_package
var TestCalculateChangedBitsContext = react.createContext(1, calculateChangedBits);

var TestContext = react.createContext();

final ContextProviderWrapper = react.registerComponent2(() => _ContextProviderWrapper());

class _ContextProviderWrapper extends react.Component2 {
  @override
  get initialState {
    return {'counter': 1};
  }

  increment() {
    setState({'counter': state['counter'] + 1});
  }

  @override
  render() {
    return react.div({}, [
      (props['contextToUse'] as react.Context)
          .Provider({'value': props['mode'] == 'increment' ? state['counter'] : props['value']}, props['children'])
    ]);
  }
}

final ContextConsumerWrapper = react.registerComponent2(() => _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 {
  dynamic latestValue;
  @override
  render() {
    return (props['contextToUse'] as react.Context).Consumer({'unstable_observedBits': props['unstable_observedBits']},
        (value) {
      latestValue = value;
      return react.div({}, '$value');
    });
  }
}

final ContextTypeComponent = react.registerComponent2(() => _ContextTypeComponent());

class _ContextTypeComponent extends react.Component2 {
  @override
  var contextType = TestContext;

  @override
  render() {
    return react.div({}, '$context');
  }
}
