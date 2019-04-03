@JS()
@TestOn('browser')
library js_factory_test;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactJsComponentFactoryProxy', () {
    group('- common factory behavior -', () {
      commonFactoryTests(JsFoo);
    });

    group('- dom event handler wrapping -', () {
      domEventHandlerWrappingTests(JsFoo);
    });

    test('has a type corresponding to the backing JS class', () {
      expect(JsFoo.type, equals(_JsFoo));
    });
  });
}

@JS()
external ReactClass get _JsFoo;
final JsFoo = new ReactJsComponentFactoryProxy(_JsFoo);
