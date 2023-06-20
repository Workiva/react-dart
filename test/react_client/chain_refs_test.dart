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
      // Chaining is tested functionally in refTests with each component type.

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
              throwsA(isA<AssertionError>()));
        });

        test('unsupported function types', () {
          expect(() => chainRefList([testRef, () {}]),
              throwsA(isA<AssertionError>()));
        });

        test('other objects', () {
          expect(() => chainRefList([testRef, Object()]),
              throwsA(isA<AssertionError>()));
        });

        // test JS interop objects since type-checking anonymous interop objects
        test('non-createRef anonymous JS interop objects', () {
          expect(() => chainRefList([testRef, JsTypeAnonymous()]),
              throwsA(isA<AssertionError>()));
        });

        // test JS interop objects since type-checking anonymous interop objects
        test('non-createRef JS interop objects', () {
          expect(() => chainRefList([testRef, JsType()]),
              throwsA(isA<AssertionError>()));
        });
      }, tags: 'no-dart2js');

      test('does not raise an assertion for valid input refs', () {
        final testCases = RefTestCaseCollection<Object>().createAllCases();
        expect(() => chainRefList(testCases.map((r) => r.ref).toList()),
            returnsNormally);
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
