import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

import 'react_test_components.dart';

void main() {
  setClientConfiguration();

  react_dom.render(
    react.div({},[
      react.h1({},['React Legacy Context API']),
      legacyContextComponent({}, [
        legacyContextConsumerComponent({
          'key': 'consumerComponent'
        }, [
          grandchildLegacyContextConsumerComponent({'key': 'legacyConsumerGrandchildComponent'})
        ]),
      ]),
      react.h1({},['React New Context API']),
      react.h6({},['Check out react dev tools of the ContextTypeConsumerComponent!']),
      newContextProviderComponent({
        'key': 'newProviderComponent'
      }, [
        newContextConsumerComponent({
          'key': 'newConsumerComponent'
        }, [
          newContextTypeConsumerComponentComponent({'key': 'newContextTypeConsumerComponent'})
        ]),
      ])
    ]),
  querySelector('#content'));
}
