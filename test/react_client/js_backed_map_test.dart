@TestOn('browser')
@JS()
library react.js_backed_map_test.dart;

import 'dart:async';
import 'dart:html' as html;

import 'package:js/js.dart';
import 'package:react/src/react_client/js_backed_map.dart';
import 'package:test/test.dart';
import '../shared_type_tester.dart';

main() {
  group('JsBackedMap', () {
    group('sets and retrieves values without JS interop interfering with them:', () {
      // These tests test assignments to the JS backed map when the values
      // - have a static type
      // - do not have a static type
      //
      // These tests should have direct value reads/writes (and not access via
      // helper methods) in order to:
      // - simulate any inlining that might be done in dart2js
      // - ensure there aren't any casts or type-checking wrappers in DDC that

      JsBackedMap jsBackedMap;
      JsBackedMap dynamicJsBackedMap;

      testTypeValue(testValue) {
        jsBackedMap = new JsBackedMap();
        dynamicJsBackedMap = new JsBackedMap();

        jsBackedMap['testValue'] = testValue;
        expect(jsBackedMap['testValue'], same(testValue));
        dynamicJsBackedMap['testValue'] = testValue as dynamic;
        expect(dynamicJsBackedMap['testValue'], same(testValue));
      }

      sharedTypeTests(testTypeValue);
    });
  });
}
