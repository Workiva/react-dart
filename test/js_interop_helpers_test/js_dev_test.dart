@TestOn('browser')
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react.js');
  verifyJsFileLoaded('react_dom.js');

  group('React JS files (dev build):', () {
    sharedJsFunctionTests();
  });
}
