@TestOn('browser')
library react.forward_ref_test;

// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:js_util';

import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'factory/common_factory_tests.dart';

main() {
  group('forwardRef2', () {
    group('- common factory behavior -', () {
      final ForwardRef2Test = react.forwardRef2((props, ref) {
        props['onDartRender']?.call(props);
        props['onDartRenderWithRef']?.call(props, ref);
        return react.div({...props, 'ref': ref});
      });

      commonFactoryTests(
        ForwardRef2Test,
        // ignore: invalid_use_of_protected_member
        dartComponentVersion: ReactDartComponentVersion.component2,
      );
    });

    // Ref behavior is tested functionally for all factory types in commonFactoryTests

    group('sets name on the rendered component as expected', () {
      test('unless the displayName argument is not passed to forwardRef2', () {
        final ForwardRefTestComponent = forwardRef2((props, ref) {});
        expect(getProperty(getProperty(ForwardRefTestComponent.type as Object, 'render'), 'name'), anyOf('', isNull));
      });

      test('when displayName argument is passed to forwardRef2', () {
        const name = 'ForwardRefTestComponent';
        final ForwardRefTestComponent = forwardRef2((props, ref) {}, displayName: name);
        expect(getProperty(getProperty(ForwardRefTestComponent.type as Object, 'render'), 'name'), name);
      });
    });
  });
}
