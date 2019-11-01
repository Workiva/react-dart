// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: invalid_use_of_protected_member
@TestOn('browser')

import 'package:test/test.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactDartFunctionComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS Function', () {
      expect(FunctionFoo.type, equals(FunctionFoo.reactFunction));
    });

    group('Function Component -', () {
      group('- common factory behavior -', () {
        commonFactoryTests(FunctionFoo, isFunctionComponent: true);
      });
    });
  });
}

final FunctionFoo = react.registerFunctionComponent(_FunctionFoo);

_FunctionFoo(Map props) {
  return react.div({});
}
