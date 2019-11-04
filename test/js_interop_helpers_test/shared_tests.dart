@JS()
library js_function_test;

import 'dart:html';
import 'dart:js_util' as js_util;

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

void verifyJsFileLoaded(String filename) {
  var isLoaded = document.getElementsByTagName('script').any((script) {
    return Uri.parse((script as ScriptElement).src).pathSegments.last == filename;
  });

  if (!isLoaded) throw new Exception('$filename is not loaded');
}

void sharedJsFunctionTests() {
  group('JS functions:', () {
    group('markChildValidated', () {
      test('is function that does not throw when called', () {
        expect(() => markChildValidated(js_util.newObject()), returnsNormally);
      });
    });

    group('createReactDartComponentClass', () {
      test('is function that does not throw when called', () {
        expect(() => createReactDartComponentClass(null, null), returnsNormally);
      });
    });
  });
}
