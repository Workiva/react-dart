@TestOn('browser')
@JS()
library react.chain_refs_test;

import 'package:js/js.dart';
import 'package:react/react_client.dart';
import 'package:react/src/react_client/chain_refs.dart';
import 'package:test/test.dart';

import '../util.dart';

main() {
  group('Ref chaining utils:', () {
    testRef(_) {}

    group('chainRefs', () {
      // Chaining and arg validation is tested via chainRefList.

      group('skips chaining and passes through arguments when', () {
        test('both arguments are null', () {
          expect(chainRefs(null, null), isNull);
        });

        test('the first argument is null', () {
          expect(chainRefs(null, testRef), same(testRef));
        });

        test('the second argument is null', () {
          expect(chainRefs(testRef, null), same(testRef));
        });
      });
    });

    group('chainRefList', () {
      // Chaining is tested functionally in refTests with each component type and each ref type.

      group('skips chaining and passes through arguments when', () {
        test('the list is empty', () {
          expect(chainRefList([]), isNull);
        });

        test('there is a single element in the list', () {
          expect(chainRefList([testRef]), same(testRef));
        });

        test('the list has only null values', () {
          expect(chainRefList([null, null]), isNull);
        });

        test('there is a single non-null element in the list', () {
          expect(chainRefList([null, testRef]), same(testRef));
        });
      });

      group('raises an assertion when inputs are invalid:', () {
        test('strings', () {
          expect(() => chainRefList([testRef, 'bad ref']),
              throwsA(isA<AssertionError>().havingMessage('String refs cannot be chained')));
        });

        test('unsupported function types', () {
          expect(() => chainRefList([testRef, () {}]),
              throwsA(isA<AssertionError>().havingMessage('callback refs must take a single argument')));
        });

        test('other objects', () {
          expect(() => chainRefList([testRef, Object()]),
              throwsA(isA<AssertionError>().havingMessage(contains('Invalid ref type'))));
        });

        // test JS interop objects since type-checking anonymous interop objects
        test('non-createRef anonymous JS interop objects', () {
          expect(() => chainRefList([testRef, JsTypeAnonymous()]),
              throwsA(isA<AssertionError>().havingMessage(contains('Invalid ref type'))));
        });

        // test JS interop objects since type-checking anonymous interop objects
        test('non-createRef JS interop objects', () {
          expect(() => chainRefList([testRef, JsType()]),
              throwsA(isA<AssertionError>().havingMessage(contains('Invalid ref type'))));
        });

        test('callback refs with non-nullable arguments', () {
          expect(() => chainRefList([testRef, nonNullableCallbackRef]), throwsNonNullableCallbackRefAssertionError);
        });
      }, tags: 'no-dart2js');

      test('does not raise an assertion for valid input refs', () {
        final testCases = RefTestCaseCollection<Object>().createAllCases();
        expect(() => chainRefList(testCases.map((r) => r.ref).toList()), returnsNormally);
      });
    });
  });
}

@JS()
@anonymous
class JsTypeAnonymous {
  external factory JsTypeAnonymous();
}

@JS()
class JsType {
  external JsType();
}

extension<T extends AssertionError> on TypeMatcher<T> {
  TypeMatcher<T> havingMessage(dynamic matcher) => having((e) => e.message, 'message', matcher);
}
