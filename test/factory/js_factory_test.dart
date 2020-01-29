@JS()
@TestOn('browser')
library js_factory_test;

import 'dart:html';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_test_utils.dart';

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

    group('- refs -', () {
      refTests<ReactComponent>(JsFoo, verifyRefValue: (ref) {
        expect(isCompositeComponentWithTypeV2(ref, JsFoo), isTrue);
      });
    });

    test('has a type corresponding to the backing JS class', () {
      expect(JsFoo.type, equals(_JsFoo));
    });
  });

  group('forwardRefToJs', () {
    test('forwards the ref / arbitrary props as expected', () {
      final JsFooFunction = forwardRefToJs(_JsFooFunction);
      final testRef = createRef<Element>();
      renderIntoDocument(JsFooFunction({'ref': testRef, 'id': 'foo'}));
      expect(testRef.current.id, 'foo');
    });

    test('forwards children as expected', () {
      final JsFooFunction = forwardRefToJs(_JsFooFunction);
      final testRef = createRef<Element>();
      renderIntoDocument(JsFooFunction({'ref': testRef}, 'oh hai'));
      expect(testRef.current.text, 'oh hai');
    });

    test('does not convert JS SyntheticEvents to Dart SyntheticEvents', () {
      final JsFooFunction = forwardRefToJs(_JsFooFunction);
      dynamic _jsEvent;
      final testRef = createRef<Element>();
      renderIntoDocument(JsFooFunction({
        'ref': testRef,
        'onClick': (jsEvent) {
          _jsEvent = jsEvent;
        }
      }));
      Simulate.click(testRef.current);
      expect(_jsEvent, isNot(isA<react.SyntheticMouseEvent>()));
    });

    test('converts custom prop refs to Ref.jsRef when key is provided to the `additionalRefPropKeys` argument', () {
      final JsFooFunction = forwardRefToJs(_JsFooFunction, additionalRefPropKeys: ['innerRef']);
      final testRef = createRef<Element>();
      final testInnerRef = createRef<Element>();
      renderIntoDocument(JsFooFunction({
        'ref': testRef,
        'innerRef': testInnerRef,
      }, 'oh hai'));
      expect(testInnerRef.current?.text, 'oh hai');
    });
  });
}

@JS()
external ReactClass get _JsFoo;
final JsFoo = new ReactJsComponentFactoryProxy(_JsFoo);

@JS()
external ReactClass get _JsFooFunction;
