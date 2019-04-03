@TestOn('browser')
@JS()
library react.js_backed_map_test.dart;

import 'package:js/js.dart';
import 'package:react/src/react_client/js_backed_map.dart';
import 'package:test/test.dart';

import '../shared_type_tester.dart';

main() {
  group('JsBackedMap', () {
    group('sets and retrieves values without JS interop interfering with them:', () {
      void testTypeValue(dynamic testValue) {
        final jsBackedMap = new JsBackedMap();
        jsBackedMap['testValue'] = testValue;
        expect(jsBackedMap['testValue'], same(testValue));
      }

      sharedTypeTests(testTypeValue);
    });
  });
}
