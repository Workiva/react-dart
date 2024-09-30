@TestOn('browser')
@JS()
library react.react_lazy_test;

import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'factory/common_factory_tests.dart';

main() {
  group('lazy', () {
    group('Dart component', () {
      final LazyTest = react.lazy(() async => react.forwardRef2((props, ref) {
            useImperativeHandle(ref, () => TestImperativeHandle());
            props['onDartRender']?.call(props);
            return react.div({...props});
          }));

      group('- common factory behavior -', () {
        commonFactoryTests(
          LazyTest,
          // ignore: invalid_use_of_protected_member
          dartComponentVersion: ReactDartComponentVersion.component2,
          renderWrapper: (child) => react.Suspense({'fallback': 'Loading...'}, child),
        );
      });

      group('- dom event handler wrapping -', () {
        domEventHandlerWrappingTests(LazyTest);
      });

      group('- refs -', () {
        refTests<TestImperativeHandle>(LazyTest, verifyRefValue: (ref) {
          expect(ref, isA<TestImperativeHandle>());
        });
      });
    });

    group('JS component', () {
      final LazyJsTest = react.lazy(() async => ReactJsComponentFactoryProxy(_JsFoo));

      group('- common factory behavior -', () {
        commonFactoryTests(
          LazyJsTest,
          // ignore: invalid_use_of_protected_member
          dartComponentVersion: ReactDartComponentVersion.component2,
          // This isn't a Dart component, but it's detected as one by tests due to the factory's dartComponentVersion
          isNonDartComponentWithDartWrapper: true,
          renderWrapper: (child) => react.Suspense({'fallback': 'Loading...'}, child),
        );
      });

      group('- dom event handler wrapping -', () {
        domEventHandlerWrappingTests(
          LazyJsTest,
          // This isn't a Dart component, but it's detected as one by tests due to the factory's dartComponentVersion
          isNonDartComponentWithDartWrapper: true,
        );
      });

      group('- refs -', () {
        refTests<ReactComponent>(LazyJsTest, verifyRefValue: (ref) {
          expect(getProperty(ref as Object, 'constructor'), same(_JsFoo));
        });
      });
    });
  });
}

class TestImperativeHandle {}

@JS()
external ReactClass get _JsFoo;
