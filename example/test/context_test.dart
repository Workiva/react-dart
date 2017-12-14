import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

import 'react_test_components.dart';

void main() {
  setClientConfiguration();

  react_dom.render(contextComponent({},
    contextConsumerComponent({}),
  ), querySelector('#content'));

  react_dom.render(contextComponent({},
    contextConsumerComponent({}),
  ), querySelector('#content'));

  react_dom.render(contextComponent({},
    contextConsumerComponent({}, grandchildContextConsumerComponent({})),
  ), querySelector('#content'));
}
