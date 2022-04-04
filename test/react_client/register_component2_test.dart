@TestOn('browser')
import 'package:react/react.dart' as react;
import 'package:test/test.dart';

import 'util.dart';

main() {
  group('registerComponent2', () {
    test('throws with specific error when defaultProps throws', () {
      expect(() => react.registerComponent2(() => ThrowsInDefaultPropsComponent2()), throwsStateError);
      expect(() {
        try {
          react.registerComponent2(() => ThrowsInDefaultPropsComponent2());
        } catch (_) {}
      }, prints(contains('Error when registering Component2 when getting defaultProps')));
    });

    test('throws with specific error when propTypes throws', () {
      expect(() => react.registerComponent2(() => ThrowsInPropTypesComponent2()), throwsStateError);
      expect(() {
        try {
          react.registerComponent2(() => ThrowsInPropTypesComponent2());
        } catch (_) {}
      }, prints(contains('Error when registering Component2 when getting propTypes')));
    }, tags: 'no-dart2js');

    test('throws with generic error when something else throws', () {
      expect(() => react.registerComponent2(() => throw StateError('bad component')), throwsStateError);
      expect(() {
        try {
          react.registerComponent2(() => throw StateError('bad component'));
        } catch (_) {}
      }, prints(contains('Error when registering Component2:')));
    });
  });
}
