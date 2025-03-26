@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import '../shared_tests.dart';

main() {
  verifyJsFileLoaded('react.min.js');

  group('React 18 JS files (prod build):', () {
    sharedConsoleFilteringTests();

    sharedJsFunctionTests();

    sharedErrorBoundaryComponentNameTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isFalse);
    });
  });
}
