@TestOn('browser')
library react.chain_refs_test;

import 'package:react/src/react_client/chain_refs.dart';
import 'package:test/test.dart';

main() {
  group('Ref chaining utils:', () {
    testRef(_) {}

    group('chainRefs', () {
      // Actual chaining is tested in refTests so it can be tested functionally with each component type.

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

      // Arg validation is covered by `chainRefList` tests
    });

    group('chainRefList', () {
      // Actual chaining is tested in refTests so it can be tested functionally with each component type.

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

      group('asserts that inputs arg are not', () {
        test('strings', () {
          expect(() => chainRefList([testRef, 'bad ref']), throwsA(isA<AssertionError>()));
        });

        test('unsupported function types', () {
          expect(() => chainRefList([testRef, () {}]), throwsA(isA<AssertionError>()));
        });
      });
    });
  });
}
