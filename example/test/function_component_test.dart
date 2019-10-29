import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

import 'react_test_components.dart';

void main() {
  setClientConfiguration();
  var inputValue = 'World';
  // TODO: replace this with hooks/useState when they are added.
  render() {
    react_dom.render(
        react.Fragment({}, [
          react.input(
            {
              'defaultValue': inputValue,
              'onChange': (event) {
                inputValue = event.currentTarget.value;
                render();
              }
            },
          ),
          react.br({}),
          helloGregFunctionComponent({'key': 'greg'}),
          react.br({}),
          helloGregFunctionComponent({'key': 'not greg'}, inputValue)
        ]),
        querySelector('#content'));
  }

  render();
}
