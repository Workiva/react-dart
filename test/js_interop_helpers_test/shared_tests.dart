@JS()
library js_function_test;

import 'dart:html';

import 'package:js/js.dart';
import 'package:js/js_util.dart' show newObject;
// TODO: remove in 5.0.0
import 'package:react/react_client/js_interop_helpers.dart';
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
    // TODO: remove in 5.0.0
    group('getProperty', () {
      test('is function that does not throw upon initialization', () {
        // ignore: deprecated_member_use
        expect(() => getProperty, const isInstanceOf<Function>());
      });

      test('gets the specified property on an object', () {
        var jsObj = new TestJsObject(foo: 'bar');
        expect(jsObj.foo, equals('bar'), reason: 'test setup sanity-check');

        // ignore: deprecated_member_use
        expect(getProperty(jsObj, 'foo'), equals('bar'));
      });
    });

    // TODO: remove in 5.0.0
    group('setProperty', () {
      test('is function that does not throw upon initialization', () {
        // ignore: deprecated_member_use
        expect(() => getProperty, const isInstanceOf<Function>());
      });

      test('sets the specified property on an object', () {
        var jsObj = new TestJsObject();
        expect(jsObj.foo, isNull, reason: 'test setup sanity-check');

        // ignore: deprecated_member_use
        expect(setProperty(jsObj, 'foo', 'bar'), equals('bar'),
            reason: 'should return the result of the assignment expression');

        expect(jsObj.foo, equals('bar'));
      });
    });

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
  });
}

@JS()
@anonymous
class TestJsObject {
  external factory TestJsObject({foo});

  external get foo;
}
