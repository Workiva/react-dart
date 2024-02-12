// @dart=2.9
@TestOn('browser')
library react.test.unsound_null_safety_test;

import 'package:react/src/react_client/factory_util.dart';
import 'package:test/test.dart';

import 'non_null_safe_refs.dart' as non_null_safe_refs;
import 'null_safe_refs.dart' as null_safe_refs;
import 'sound_null_safety_detection.dart';

main() {
  // Since our callback ref non-nullable argument detection relies on runtime type-checking behavior
  // that's different in null safety (`is Function(Null)`, we want to ensure we know how it behaves
  // both in sound and unsound null safety runtime environments.
  //
  // So, this test file simulates that setup.
  group('nullable callback detection, when compiled with unsound null safety:', () {
    setUpAll(() {
      expect(hasUnsoundNullSafety, isTrue, reason: 'these tests should be running under unsound null safety');
    });

    group('isRefArgumentDefinitelyNonNullable:', () {
      group('when refs are declared in null-safe code,', () {
        test('returns false, even for non-nullable refs', () {
          expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.nonNullableElementRef), isFalse);
        });

        test('returns false for nullable refs', () {
          expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.nullableElementRef), isFalse);
          expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.dynamicRef), isFalse);
        });
      });

      group('when refs are declared in non-null-safe code,', () {
        test('returns false', () {
          expect(isRefArgumentDefinitelyNonNullable(non_null_safe_refs.elementRef), isFalse);
          expect(isRefArgumentDefinitelyNonNullable(non_null_safe_refs.dynamicRef), isFalse);
        });
      });
    });
  });
}
