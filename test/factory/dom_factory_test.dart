@TestOn('browser')
library react.dom_factory_test;

import 'dart:html';

import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;

import 'common_factory_tests.dart';

// Public APIs with tightened types to help fix implicit casts
final div = react.div as ReactDomComponentFactoryProxy;
final span = react.span as ReactDomComponentFactoryProxy;

main() {
  group('ReactDomComponentFactoryProxy', () {
    group('- common factory behavior -', () {
      commonFactoryTests(div);
    });

    group('- dom event handler wrapping -', () {
      domEventHandlerWrappingTests(div);
    });

    group('- refs -', () {
      refTests<SpanElement>(span, verifyRefValue: (ref) {
        expect(ref, TypeMatcher<SpanElement>());
      });
    });

    test('has a type corresponding to the DOM tagName', () {
      expect(div.type, 'div');
      expect(span.type, 'span');
    });
  });
}
