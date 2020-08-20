@TestOn('browser')
library react.forward_ref_test;

import 'dart:html';
import 'dart:js_util';

import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_test_utils.dart' as rtu;
import 'package:test/test.dart';

import 'factory/common_factory_tests.dart';

main() {
  group('forwardRef2', () {
    group('- common factory behavior -', () {
      commonFactoryTests(
        ForwardRef2Test,
        // ignore: invalid_use_of_protected_member
        dartComponentVersion: ReactDartComponentVersion.component2,
      );
    });

    // Ref behavior is tested functionally for all factory types in commonFactoryTests

    group('ref forwarding functional testing (to a div) -', () {
      refTests<DivElement>(ForwardRef2Test, verifyRefValue: (ref) {
        expect(ref, TypeMatcher<DivElement>());
      });
    });

    group('sets displayName on the rendered component as expected', () {
      test('unless the displayName argument is not passed to forwardRef2', () {
        var ForwardRefTestComponent = forwardRef2((props, ref) {});
        expect(getProperty(getProperty(ForwardRefTestComponent.type, 'render'), 'name'), anyOf('', isNull));
      });

      test('when displayName argument is passed to forwardRef2', () {
        const name = 'ForwardRefTestComponent';
        var ForwardRefTestComponent = forwardRef2((props, ref) {}, displayName: name);
        expect(getProperty(getProperty(ForwardRefTestComponent.type, 'render'), 'name'), name);
      });
    });
  });
}


// ignore: deprecated_member_use_from_same_package
final ForwardRefTest = react.forwardRef((props, ref) {
  props['onDartRender']?.call(props);
  return react.div({...props, 'ref': ref});
});

final ForwardRef2Test = react.forwardRef2((props, ref) {
  props['onDartRender']?.call(props);
  props['onDartRenderWithRef']?.call(props, ref);
  return react.div({...props, 'ref': ref});
});
