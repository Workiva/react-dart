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
import 'package:react/src/react_client/js_backed_map.dart';

main() {
  setClientConfiguration();

  testTypeValue(dynamic typeToTest) {
    var mountNode = new html.DivElement();
    var contextTypeRef;
    var consumerRef;
    react_dom.render(
        ContextProviderWrapper({
          'contextValue': typeToTest
        }, [
          ContextTypeComponent({
            'ref': (ref) {
              contextTypeRef = ref;
            }
          }),
          ContextConsumerComponent({
            'ref': (ref) {
              consumerRef = ref;
            }
          })
        ]),
        mountNode);
    if (typeToTest is JsMap) {
      // Context auto converts JsMaps to make consumption in dart better :)
      expect((contextTypeRef.context as Map).keys, JsBackedMap.copyToDart(typeToTest).keys);
      expect((consumerRef.latestValue as Map).keys, JsBackedMap.copyToDart(typeToTest).keys);
      expect((contextTypeRef.context as Map).values, JsBackedMap.copyToDart(typeToTest).values);
      expect((consumerRef.latestValue as Map).values, JsBackedMap.copyToDart(typeToTest).values);
    } else {
      expect(contextTypeRef.context, same(typeToTest));
      expect(consumerRef.latestValue, same(typeToTest));
    }
  }

  group('New Context API (Component2 only)', () {
    group('sets and retrieves values correctly:',
        () {
          sharedTypeTests(testTypeValue);
    });
  });
}

var TestContext = createContext();

ReactDartComponentFactoryProxy2 ContextProviderWrapper =
    react.registerComponent(() => new _ContextProviderWrapper());

class _ContextProviderWrapper extends react.Component2 {
  render() {
    return react.div({}, [
      TestContext.Provider({'value': props['contextValue']}, props['children'])
    ]);
  }
}

ReactDartComponentFactoryProxy2 ContextTypeComponent =
    react.registerComponent(() => new _ContextTypeComponent());

class _ContextTypeComponent extends react.Component2 {
  var contextType = TestContext;

  render() {
    return react.div({}, '${this.context}');
  }
}

ReactDartComponentFactoryProxy2 ContextConsumerComponent =
    react.registerComponent(() => new _ContextConsumerComponent());

class _ContextConsumerComponent extends react.Component2 {
  dynamic latestValue;
  render() {
    return TestContext.Consumer({}, (value) {
      latestValue = value;
      return react.div({}, '$value');
    });
  }
}