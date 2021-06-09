// @dart=2.7
// ^ Do not remove until migrated to null safety. More info at https://wiki.atl.workiva.net/pages/viewpage.action?pageId=189370832
@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react_with_addons.js');
  verifyJsFileLoaded('react_dom.js');

  group('React JS files (dev w/ addons build):', () {
    sharedConsoleWarnTests(expectDeduplicateSyntheticEventWarnings: true);

    sharedJsFunctionTests();

    test('inReactDevMode', () {
      expect(inReactDevMode, isTrue);
    });
  });
}
