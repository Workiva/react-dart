@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react_prod.js');
  verifyJsFileLoaded('react_dom_prod.js');

  group('React JS files (prod build):', () {
    sharedConsoleFilteringTests(expectDeduplicateSyntheticEventWarnings: false);

    sharedJsFunctionTests();

    sharedErrorBoundaryComponentNameTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isFalse);
    });
  });
}
