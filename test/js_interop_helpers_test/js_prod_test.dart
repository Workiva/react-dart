@TestOn('browser')
import 'package:test/test.dart';

import 'shared_tests.dart';

main() {
  verifyJsFileLoaded('react_prod.js');
  verifyJsFileLoaded('react_dom_prod.js');

  group('React JS files (prod build):', () {
    sharedJsFunctionTests();
  });
}
