@TestOn('browser')
library react.test.unsound_null_safety_test;

import 'package:react/src/react_client/factory_util.dart';
import 'package:test/test.dart';

import 'null_safe_refs.dart' as null_safe_refs;
import 'sound_null_safety_detection.dart';

main() {
  // This test ths the counterpart to nullable_callback_detection_unsound_test.dart,
  // to verify expected behavior under sound null safety.
  // See that file for more info.
  group('nullable callback detection, when compiled with sound null safety:', () {
    setUpAll(() {
      expect(hasUnsoundNullSafety, isFalse, reason: 'these tests should be running under sound null safety');
    });

    group('isRefArgumentDefinitelyNonNullable', () {
      test('returns true for non-nullable refs', () {
        expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.nonNullableElementRef), isTrue);
      });

      test('returns false for nullable refs', () {
        expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.nullableElementRef), isFalse);
        expect(isRefArgumentDefinitelyNonNullable(null_safe_refs.dynamicRef), isFalse);
      });
    });
  });
}
