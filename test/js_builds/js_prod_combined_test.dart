@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react_with_react_dom_prod.js');

  group('React JS files (prod combined build):', () {
    sharedConsoleWarnTests(expectDeduplicateSyntheticEventWarnings: false);

    sharedJsFunctionTests();

    sharedErrorBoundaryComponentNameTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isFalse);
    });
  });
}
