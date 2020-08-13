// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: invalid_use_of_protected_member
@TestOn('browser')
library react.dart_function_factory_test;

import 'package:js/js_util.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'common_factory_tests.dart';

main() {
  group('ReactDartFunctionComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS Function', () {
      expect(FunctionFoo.type, equals(FunctionFoo.reactFunction));
    });

    group('Function Component -', () {
      group('- common factory behavior -', () {
        commonFactoryTests(
          FunctionFoo,
          dartComponentVersion: ReactDartComponentVersion.component2,
        );
      });

      group('displayName', () {
        test('gets automatically populated when not provided', () {
          expect(FunctionFoo.displayName, '_FunctionFoo');

          expect(_getJsFunctionName(FunctionFoo.reactFunction), '_FunctionFoo');

          expect(FunctionFoo.displayName, _getJsFunctionName(FunctionFoo.reactFunction));
        }, tags: ['fails-on-241']);

        test('is populated by the provided argument', () {
          expect(NamedFunctionFoo.displayName, 'Bar');

          expect(_getJsFunctionName(NamedFunctionFoo.reactFunction), 'Bar');

          expect(NamedFunctionFoo.displayName, _getJsFunctionName(NamedFunctionFoo.reactFunction));
        });
      });
    });
  });

  group('forwardRef', () {
    group('- common factory behavior -', () {
      commonFactoryTests(
        ForwardRefTest,
        dartComponentVersion: ReactDartComponentVersion.component2,
        skipPropValuesTest: true,
      );
    });
  });

  group('forwardRef2', () {
    group('- common factory behavior -', () {
      commonFactoryTests(
        ForwardRef2Test,
        dartComponentVersion: ReactDartComponentVersion.component2,
      );
    });
  });

  group('memo', () {
    group('- common factory behavior -', () {
      commonFactoryTests(
        MemoTest,
        dartComponentVersion: ReactDartComponentVersion.component2,
        skipPropValuesTest: true,
      );
    });
  });

  group('memo2', () {
    group('- common factory behavior -', () {
      commonFactoryTests(
        Memo2Test,
        dartComponentVersion: ReactDartComponentVersion.component2,
      );
    });
  });
}

String _getJsFunctionName(Function object) => getProperty(object, 'name') ?? getProperty(object, '\$static_name');

final NamedFunctionFoo = react.registerFunctionComponent(_FunctionFoo, displayName: 'Bar');

final FunctionFoo = react.registerFunctionComponent(_FunctionFoo);

_FunctionFoo(Map props) {
  props['onDartRender']?.call(props);
  return react.div({});
}

final ForwardRefTest = react.forwardRef((props, ref) {
  props['onDartRender']?.call(props);
  return react.div({...props, 'ref': ref});
});

final ForwardRef2Test = react.forwardRef2((props, ref) {
  props['onDartRender']?.call(props);
  return react.div({...props, 'ref': ref});
});

final MemoTest = react.memo(react.registerFunctionComponent((props) {
  props['onDartRender']?.call(props);
  return react.div({...props});
}));

final Memo2Test = react.memo2(react.registerFunctionComponent((props) {
  props['onDartRender']?.call(props);
  return react.div({...props});
}));
