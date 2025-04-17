@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import '../shared_tests.dart';

main() {
  verifyJsFileLoaded('react.js');
  verifyJsFileLoaded('react_dom.js');

  group('React 17 JS files (dev build):', () {
    sharedConsoleFilteringTests();

    sharedJsFunctionTests();

    sharedErrorBoundaryComponentNameTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isTrue);
    });
  });
}
