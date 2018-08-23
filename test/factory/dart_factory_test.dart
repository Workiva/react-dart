@TestOn('browser')
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';

import '../util.dart';
import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactDartComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS class', () {
      expect(Foo.type, equals(Foo.reactClass));
    });

    group('- common factory behavior -', () {
      group('Component -', () {
        commonFactoryTests(Foo);
      });

      group('Component2 -', () {
        commonFactoryTests(Foo2);
      });

      group('utils', () { // todo move somewhere else
        test('isDartComponent2', () {
          expect(isDartComponent2(react.div({})), isFalse);
          expect(isDartComponent2(Foo({})), isFalse);
          expect(isDartComponent2(Foo2({})), isTrue);
        });

        test('isDartComponent1', () {
          expect(isDartComponent1(react.div({})), isFalse);
          expect(isDartComponent1(Foo({})), isTrue);
          expect(isDartComponent1(Foo2({})), isFalse);
        });

        test('isDartComponent', () {
          expect(isDartComponent(react.div({})), isFalse);
          expect(isDartComponent(Foo({})), isTrue);
          expect(isDartComponent(Foo2({})), isTrue);
        });
      });
    });
  });
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
