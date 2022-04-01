@TestOn('browser')
import 'dart:html' as html;

import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

import 'shared_type_tester.dart';

final _act = react_dom.ReactTestUtils.act;

main() {
  react_dom.ReactRoot root;

  void testTypeValue(dynamic typeToTest) {
    var contextTypeRef;
    var consumerRef;
    _act(() => root.render(ContextProviderWrapper({
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
        ])));
    expect(contextTypeRef.context, same(typeToTest));
    expect(consumerRef.latestValue, same(typeToTest));
  }

  group('New Context API (Component2 only)', () {
    setUp(() {
      root = react_dom.createRoot(html.DivElement());
    });

    tearDown(() {
      root.unmount();
    });

    group('sets and retrieves values correctly:', () {
      sharedTypeTests(testTypeValue);
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

final ContextProviderWrapper = react.registerComponent2(() => new _ContextProviderWrapper());

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

final ContextConsumerWrapper = react.registerComponent2(() => new _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 {
  dynamic latestValue;
  render() {
    return props['contextToUse'].Consumer({'unstable_observedBits': props['unstable_observedBits']}, (value) {
      latestValue = value;
      return react.div({}, '$value');
    });
  }
}

final ContextTypeComponent = react.registerComponent2(() => new _ContextTypeComponent());

class _ContextTypeComponent extends react.Component2 {
  var contextType = TestContext;

  render() {
    return react.div({}, '${this.context}');
  }
}
