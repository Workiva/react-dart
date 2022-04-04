@TestOn('browser')
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'common_factory_tests.dart';

main() {
  group('ReactDartComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS class', () {
      expect(Foo.type, equals(Foo.reactClass));
    });

    group('- common factory behavior -', () {
      group('Component', () {
        group('- common factory behavior -', () {
          // ignore: invalid_use_of_protected_member
          commonFactoryTests(Foo, dartComponentVersion: ReactDartComponentVersion.component);
        });

        group('- refs -', () {
          refTests<_Foo>(
            Foo,
            verifyRefValue: (ref) {
              expect(ref, isA<_Foo>());
            },
            verifyJsRefValue: (ref) {
              expect(ref, isA<ReactComponent>().having((c) => c.dartComponent, 'dartComponent', isA<_Foo>()));
            },
          );
        });
      });

      group('Component2', () {
        group('- common factory behavior -', () {
          // ignore: invalid_use_of_protected_member
          commonFactoryTests(Foo2, dartComponentVersion: ReactDartComponentVersion.component2);
        });

        group('- refs -', () {
          refTests<_Foo2>(
            Foo2,
            verifyRefValue: (ref) {
              expect(ref, isA<_Foo2>());
            },
            verifyJsRefValue: (ref) {
              expect(ref, isA<ReactComponent>().having((c) => c.dartComponent, 'dartComponent', isA<_Foo2>()));
            },
          );
        });
      });
    });
  });
}

// ignore: deprecated_member_use_from_same_package
final Foo = react.registerComponent(() => new _Foo()) as ReactDartComponentFactoryProxy;

// ignore: deprecated_member_use_from_same_package
class _Foo extends react.Component {
  @override
  render() {
    props['onDartRender']?.call(props);
    return react.div({...props, 'ref': props['forwardedRef']});
  }
}

final Foo2 = react.registerComponent2(() => new _Foo2());

class _Foo2 extends react.Component2 {
  @override
  render() {
    props['onDartRender']?.call(props);
    return react.div({...props, 'ref': props['forwardedRef']});
  }
}
