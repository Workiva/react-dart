@TestOn('browser')
library react.merge_refs_test;

import 'package:react/src/react_client/merge_refs.dart';
import 'package:test/test.dart';

main() {
  group('Ref merging utils:', () {
    testRef(_) {}

    group('mergeRefs', () {
      // Actual chaining is tested in refTests so it can be tested functionally with each component type.

      group('skips chaining and passes through arguments when', () {
        test('both arguments are null', () {
          expect(mergeRefs(null, null), isNull);
        });

        test('the first argument is null', () {
          expect(mergeRefs(null, testRef), same(testRef));
        });

        test('the second argument is null', () {
          expect(mergeRefs(testRef, null), same(testRef));
        });
      });

      // Arg validation is covered by `mergeRefList` tests
    });

    group('mergeRefList', () {
      // Actual chaining is tested in refTests so it can be tested functionally with each component type.

      group('skips chaining and passes through arguments when', () {
        test('the list is empty', () {
          expect(mergeRefList([]), isNull);
        });

        test('there is a single element in the list', () {
          expect(mergeRefList([testRef]), same(testRef));
        });

        test('the list has only null values', () {
          expect(mergeRefList([null, null]), isNull);
        });

        test('there is a single non-null element in the list', () {
          expect(mergeRefList([null, testRef]), same(testRef));
        });
      });

      group('asserts that inputs arg are not', () {
        test('strings', () {
          expect(() => mergeRefList([testRef, 'bad ref']), throwsA(isA<AssertionError>()));
        });

        test('unsupported function types', () {
          expect(() => mergeRefList([testRef, () {}]), throwsA(isA<AssertionError>()));
        });
      });
    });
  });
}
