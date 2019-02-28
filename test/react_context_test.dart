@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html';

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart'
    show React, ReactClass, ReactComponent;
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/react_client/event_prop_key_to_event_factory.dart';

main() {
  setClientConfiguration();

  testContextValue(dynamic testValue){
    var mountNode = new DivElement();
    var contextTypeRef;
    var consumerRef;
    react_dom.render(ContextProviderWrapper({'contextValue': testValue},[
      ContextTypeComponent({'ref':(ref){contextTypeRef = ref;}}),
      ContextConsumerComponent({'ref':(ref){consumerRef = ref;}})
    ]), mountNode);
    Element contextTypeNode = react_dom.findDOMNode(contextTypeRef);
    Element consumerNode = react_dom.findDOMNode(consumerRef);
    expect(contextTypeNode.firstChild.text, testValue.toString());
    expect(consumerNode.firstChild.text, testValue.toString());
  }
  group('Context', () {
    group('work with a value of type: ', () {
      test('String', () {
        testContextValue('test');
      });
      test('int', () {
        testContextValue(1);
      });
      test('Map', () {
        testContextValue({'key1':'value1','key2': 'value2'});
      });

      test('bool', () {
        testContextValue(true);
      });
    });
  });
}



var TestContext = createContext();

ReactDartComponentFactoryProxy ContextProviderWrapper =
    react.registerComponent(() => new _ContextProviderWrapper());

class _ContextProviderWrapper extends react.Component {
  render() {
    return react.div({},[TestContext.Provider({'value': props['contextValue']}, props['children'])]);
  }
}

ReactDartComponentFactoryProxy ContextTypeComponent =
    react.registerComponent(() => new _ContextTypeComponent());

class _ContextTypeComponent extends react.Component {
  var contextType = TestContext;

  render() {
    return react.div({}, '${this.context}');
  }
}

ReactDartComponentFactoryProxy ContextConsumerComponent =
    react.registerComponent(() => new _ContextConsumerComponent());

class _ContextConsumerComponent extends react.Component {
  render() {
    return TestContext.Consumer({}, (value) {
      return react.div({}, '$value');
    });
  }
}
