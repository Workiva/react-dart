// ignore_for_file: deprecated_member_use_from_same_package
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
        expect(() => markChildValidated(newObject()), returnsNormally);
      });
    });

    group('createReactDartComponentClass', () {
      test('is function that does not throw when called', () {
        expect(() => createReactDartComponentClass(null, null), returnsNormally);
      });
    });

    group('createReactDartComponentClass2', () {
      test('is function that does not throw when called', () {
        expect(() => createReactDartComponentClass2(null, null, JsComponentConfig2(skipMethods: [])), returnsNormally);
      });
    });
  });
}
