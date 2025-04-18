@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import '../shared_tests.dart';

main() {
  verifyJsFileLoaded('react_with_addons.js');
  verifyJsFileLoaded('react_dom.js');

  group('React JS 17 files (dev w/ addons build):', () {
    sharedConsoleFilteringTests();

    sharedJsFunctionTests();

    sharedErrorBoundaryComponentNameTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isTrue);
    });
  });
}
