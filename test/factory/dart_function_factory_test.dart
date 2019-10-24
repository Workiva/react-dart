// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: invalid_use_of_protected_member
@TestOn('browser')
import 'dart:js';

import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import '../util.dart';
import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactDartFunctionComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS Function', () {
      expect(FunctionFoo.type, equals(FunctionFoo.reactFunction));
    });

    group('- common factory behavior -', () {
      group('Function Component -', () {
        group('- common factory behavior -', () {
          commonFactoryTests(FunctionFoo, isFunctionComponent: true);
        });
      });

      group('utils', () {
        test('ReactDartComponentVersion.fromType', () {
          expect(ReactDartComponentVersion.fromType(react.div({}).type), isNull);
          expect(ReactDartComponentVersion.fromType(JsFoo({}).type), isNull);
          expect(ReactDartComponentVersion.fromType(FunctionFoo({}).type), ReactDartComponentVersion.component2);
          expect(ReactDartComponentVersion.fromType(Foo({}).type), ReactDartComponentVersion.component);
          expect(ReactDartComponentVersion.fromType(Foo2({}).type), ReactDartComponentVersion.component2);
        });
      });

      group('test utils', () {
        // todo move somewhere else
        test('isDartComponent2', () {
          expect(isDartComponent2(react.div({})), isFalse);
          expect(isDartComponent2(JsFoo({})), isFalse);
          expect(isDartComponent2(FunctionFoo({})), isTrue);
          expect(isDartComponent2(Foo({})), isFalse);
          expect(isDartComponent2(Foo2({})), isTrue);
        });

        test('isDartComponent1', () {
          expect(isDartComponent1(react.div({})), isFalse);
          expect(isDartComponent1(JsFoo({})), isFalse);
          expect(isDartComponent1(FunctionFoo({})), isFalse);
          expect(isDartComponent1(Foo({})), isTrue);
          expect(isDartComponent1(Foo2({})), isFalse);
        });

        test('isDartComponent', () {
          expect(isDartComponent(react.div({})), isFalse);
          expect(isDartComponent(JsFoo({})), isFalse);
          expect(isDartComponent(FunctionFoo({})), isTrue);
          expect(isDartComponent(Foo({})), isTrue);
          expect(isDartComponent(Foo2({})), isTrue);
        });
      });
    });
  });
}

final FunctionFoo = react.registerFunctionComponent(_FunctionFoo);

_FunctionFoo(Map props) {
  return react.div({});
}

final Foo = react.registerComponent(() => new _Foo()) as ReactDartComponentFactoryProxy;

class _Foo extends react.Component {
  @override
  render() => react.div({});
}

final Foo2 = react.registerComponent(() => new _Foo2()) as ReactDartComponentFactoryProxy2;

class _Foo2 extends react.Component2 {
  @override
  render() => react.div({});
}

final JsFoo = ReactJsComponentFactoryProxy(React.createClass(ReactClassConfig(
  displayName: 'JsFoo',
  render: allowInterop(() => react.div({})),
)));
