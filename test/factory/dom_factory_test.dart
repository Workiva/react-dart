@TestOn('browser')
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';

import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactDomComponentFactoryProxy', () {
    test('has a type corresponding to the DOM tagName', () {
      expect((react.div as ReactDomComponentFactoryProxy).type, 'div');
      expect((react.span as ReactDomComponentFactoryProxy).type, 'span');
    });

    group('- common factory behavior -', () {
      commonFactoryTests(react.div);
    });
  });
}
