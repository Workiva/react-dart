@TestOn('browser')
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react_with_addons.js');
  verifyJsFileLoaded('react_dom.js');

  group('React JS files (dev w/ addons build):', sharedJsFunctionTests);

  test('inReactDevMode (dev build):', () {
    expect(inReactDevMode, isTrue);
  });
}
