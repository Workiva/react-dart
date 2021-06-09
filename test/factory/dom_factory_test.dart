// @dart=2.7
// ^ Do not remove until migrated to null safety. More info at https://wiki.atl.workiva.net/pages/viewpage.action?pageId=189370832
@TestOn('browser')
library react.dom_factory_test;

import 'dart:html';

import 'package:test/test.dart';

import 'package:react/react.dart' as react;

import 'common_factory_tests.dart';

main() {
  group('ReactDomComponentFactoryProxy', () {
    group('- common factory behavior -', () {
      commonFactoryTests(react.div);
    });

    group('- dom event handler wrapping -', () {
      domEventHandlerWrappingTests(react.div);
    });

    group('- refs -', () {
      refTests<SpanElement>(react.span, verifyRefValue: (ref) {
        expect(ref, TypeMatcher<SpanElement>());
      });
    });

    test('has a type corresponding to the DOM tagName', () {
      expect(react.div.type, 'div');
      expect(react.span.type, 'span');
    });
  });
}
