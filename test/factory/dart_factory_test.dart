@TestOn('browser')
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart' as rtu;

import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactDartComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS class', () {
      expect(Foo.type, equals(Foo.reactClass));
    });

    group('- common factory behavior -', () {
      commonFactoryTests(Foo);
    });

    // TODO remove and transfer over to ref tests once 5.1.0-wip releases
    group('has functional callback refs when they are typed as', () {
      test('`dynamic Function(dynamic)`', () {
        _Foo fooRef;
        callbackRef(ref) {
          fooRef = ref;
        }

        expect(() => rtu.renderIntoDocument(Foo({'ref': callbackRef})), returnsNormally,
            reason: 'React should not have a problem with the ref we pass it, and calling it should not throw');
        expect(fooRef, const isInstanceOf<_Foo>(),
            reason: 'should be the correct type, not be a NativeJavaScrriptObject/etc.');
      });

      test('`dynamic Function(ComponentClass)`', () {
        _Foo fooRef;
        callbackRef(_Foo ref) {
          fooRef = ref;
        }

        expect(() => rtu.renderIntoDocument(Foo({'ref': callbackRef})), returnsNormally,
            reason: 'React should not have a problem with the ref we pass it, and calling it should not throw');
        expect(fooRef, const isInstanceOf<_Foo>(),
            reason: 'should be the correct type, not be a NativeJavaScrriptObject/etc.');
      });
    });
  });
}

final Foo = react.registerComponent(() => new _Foo()) as ReactDartComponentFactoryProxy;

class _Foo extends react.Component {
  @override
  render() => react.div({});
}
