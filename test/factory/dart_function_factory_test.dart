@TestOn('browser')
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
          // ignore: invalid_use_of_protected_member
          dartComponentVersion: ReactDartComponentVersion.component2,
        );
      });

      group('displayName', () {
        test('gets automatically populated when not provided', () {
          expect(FunctionFoo.displayName, '_FunctionFoo');

          expect(_getJsFunctionName(FunctionFoo.reactFunction), '_FunctionFoo');

          expect(FunctionFoo.displayName, _getJsFunctionName(FunctionFoo.reactFunction));
        });

        test('is populated by the provided argument', () {
          expect(NamedFunctionFoo.displayName, 'Bar');

          expect(_getJsFunctionName(NamedFunctionFoo.reactFunction), 'Bar');

          expect(NamedFunctionFoo.displayName, _getJsFunctionName(NamedFunctionFoo.reactFunction));
        });
      });
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
