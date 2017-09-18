@TestOn('browser')
library react_test_utils_test;

import 'package:test/test.dart';

import 'package:react/react_client.dart';

main() {
  group('unconvertJsEventHandler', () {
    test('returns null when the input is null', () {
      var result;
      expect(() {
        result = unconvertJsEventHandler(null);
      }, returnsNormally);

      expect(result, isNull);
    });
  });
}
