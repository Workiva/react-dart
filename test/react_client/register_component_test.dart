@TestOn('browser')
import 'package:react/react.dart' as react;
import 'package:test/test.dart';

import 'util.dart';

main() {
  group('registerComponent', () {
    test('throws with printed error', () {
      // ignore: deprecated_member_use_from_same_package
      expect(() => react.registerComponent(() => ThrowsInDefaultPropsComponent()), throwsStateError);
      expect(() {
        try {
          // ignore: deprecated_member_use_from_same_package
          react.registerComponent(() => ThrowsInDefaultPropsComponent());
        } catch (_) {}
      }, prints(contains('Error when registering Component:')));
    });
  });
}
