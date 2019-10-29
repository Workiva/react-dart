import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

import 'react_test_components.dart';

void main() {
  setClientConfiguration();

  react_dom.render(
      react.Fragment({}, [
        helloGregFunctionComponent({'key': 'greg'}),
        react.br({}),
        helloGregFunctionComponent({'key': 'not greg'}, 'World')
      ]),
      querySelector('#content'));
}
