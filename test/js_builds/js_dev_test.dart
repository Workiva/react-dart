@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react.js');
  verifyJsFileLoaded('react_dom.js');

  group('React JS files (dev build):', () {
    sharedConsoleWarnTests(expectDeduplicateSyntheticEventWarnings: true);

    sharedJsFunctionTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isTrue);
    });
  });
}
