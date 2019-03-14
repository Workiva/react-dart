@JS()
library react.js_backed_map_test.dart;

import 'dart:async';
import 'dart:html' as html;

import 'package:js/js.dart';
import 'package:react/src/react_client/js_backed_map.dart';
import 'package:test/test.dart';

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

      setUp(() {
        jsBackedMap = new JsBackedMap();
        dynamicJsBackedMap = new JsBackedMap();
      });

      test('normal Dart objects', () {
        final object = new Foo('f');
        final iterable = new Iterable.generate(2);

        jsBackedMap['object'] = object;
        jsBackedMap['iterable'] = iterable;
        expect(jsBackedMap['object'], same(object));
        expect(jsBackedMap['iterable'], same(iterable));

        dynamicJsBackedMap['object'] = object as dynamic;
        dynamicJsBackedMap['iterable'] = iterable as dynamic;
        expect(dynamicJsBackedMap['object'], same(object));
        expect(dynamicJsBackedMap['iterable'], same(iterable));
      });

      test('Dart maps (verifies that they aren\'t accidentally jsified)', () {
        final dartMap = {};

        jsBackedMap['dartMap'] = dartMap;
        dynamicJsBackedMap['dartMap'] = dartMap as dynamic;
      });

      group('primitives', () {
        test('', () {
          final stringValue = '';
          final boolValue = false;
          final nullValue = null;

          jsBackedMap['stringValue'] = stringValue;
          jsBackedMap['boolValue'] = boolValue;
          jsBackedMap['nullValue'] = nullValue;
          expect(jsBackedMap['stringValue'], same(stringValue));
          expect(jsBackedMap['boolValue'], same(boolValue));
          expect(jsBackedMap['nullValue'], same(nullValue));

          dynamicJsBackedMap['stringValue'] = stringValue as dynamic;
          dynamicJsBackedMap['boolValue'] = boolValue as dynamic;
          dynamicJsBackedMap['nullValue'] = nullValue as dynamic;
          expect(dynamicJsBackedMap['stringValue'], same(stringValue));
          expect(dynamicJsBackedMap['boolValue'], same(boolValue));
          expect(dynamicJsBackedMap['nullValue'], same(nullValue));
        });

        test('num types', () {
          final intValue = (1 as int); // ignore: unnecessary_cast
          final doubleValue = 1.1;
          final numValue = (1 as num); // ignore: unnecessary_cast

          jsBackedMap['intValue'] = intValue;
          jsBackedMap['doubleValue'] = doubleValue;
          jsBackedMap['numValue'] = numValue;
          expect(jsBackedMap['intValue'], same(intValue));
          expect(jsBackedMap['doubleValue'], same(doubleValue));
          expect(jsBackedMap['numValue'], same(numValue));

          dynamicJsBackedMap['intValue'] = intValue as dynamic;
          dynamicJsBackedMap['doubleValue'] = doubleValue as dynamic;
          dynamicJsBackedMap['numValue'] = numValue as dynamic;
          expect(dynamicJsBackedMap['intValue'], same(intValue));
          expect(dynamicJsBackedMap['doubleValue'], same(doubleValue));
          expect(dynamicJsBackedMap['numValue'], same(numValue));
        });
      });

      test('functions', () {
        _functionLocalMethod() {}
        final functionLocalMethod = _functionLocalMethod;
        final functionExpression = () {};
        final functionTearOff = new Object().toString;
        final functionAllowInterop = allowInterop(() {});

        jsBackedMap['functionLocalMethod'] = functionLocalMethod;
        jsBackedMap['functionExpression'] = functionExpression;
        jsBackedMap['functionTearOff'] = functionTearOff;
        jsBackedMap['functionAllowInterop'] = functionAllowInterop;
        expect(jsBackedMap['functionLocalMethod'], same(functionLocalMethod));
        expect(jsBackedMap['functionExpression'], same(functionExpression));
        expect(jsBackedMap['functionTearOff'], same(functionTearOff));
        expect(jsBackedMap['functionAllowInterop'], same(functionAllowInterop));

        dynamicJsBackedMap['functionLocalMethod'] = functionLocalMethod as dynamic;
        dynamicJsBackedMap['functionExpression'] = functionExpression as dynamic;
        dynamicJsBackedMap['functionTearOff'] = functionTearOff as dynamic;
        dynamicJsBackedMap['functionAllowInterop'] = functionAllowInterop as dynamic;
        expect(dynamicJsBackedMap['functionLocalMethod'], same(functionLocalMethod));
        expect(dynamicJsBackedMap['functionExpression'], same(functionExpression));
        expect(dynamicJsBackedMap['functionTearOff'], same(functionTearOff));
        expect(dynamicJsBackedMap['functionAllowInterop'], same(functionAllowInterop));
      });

      test('browser objects (which are usually auto-converted)', () {
        final element = new html.DivElement();
        final customEvent = new html.CustomEvent('foo');
        final window = html.window;

        jsBackedMap['element'] = element;
        jsBackedMap['customEvent'] = customEvent;
        jsBackedMap['window'] = window;
        expect(jsBackedMap['element'], same(element));
        expect(jsBackedMap['customEvent'], same(customEvent));
        expect(jsBackedMap['window'], same(window));

        dynamicJsBackedMap['element'] = element as dynamic;
        dynamicJsBackedMap['customEvent'] = customEvent as dynamic;
        dynamicJsBackedMap['window'] = window as dynamic;
        expect(dynamicJsBackedMap['element'], same(element));
        expect(dynamicJsBackedMap['customEvent'], same(customEvent));
        expect(dynamicJsBackedMap['window'], same(window));
      });

      test('types that are typically auto-converted', () {
        final listDynamic = [1, 'foo'];
        final listInt = <int>[1, 2, 3];

        jsBackedMap['listDynamic'] = listDynamic;
        jsBackedMap['listInt'] = listInt;
        expect(jsBackedMap['listDynamic'], same(listDynamic));
        expect(jsBackedMap['listInt'], same(listInt));

        dynamicJsBackedMap['listDynamic'] = listDynamic as dynamic;
        dynamicJsBackedMap['listInt'] = listInt as dynamic;
        expect(dynamicJsBackedMap['listDynamic'], same(listDynamic));
        expect(dynamicJsBackedMap['listInt'], same(listInt));
      });

      test('types that may eventually typically be auto-converted', () {
        final dateTime = new DateTime.utc(2018);
        final future = new Future(() {});

        jsBackedMap['dateTime'] = dateTime;
        jsBackedMap['future'] = future;
        expect(jsBackedMap['dateTime'], same(dateTime));
        expect(jsBackedMap['future'], same(future));

        dynamicJsBackedMap['dateTime'] = dateTime as dynamic;
        dynamicJsBackedMap['future'] = future as dynamic;
        expect(dynamicJsBackedMap['dateTime'], same(dateTime));
        expect(dynamicJsBackedMap['future'], same(future));
      });

      test('JS interop types', () {
        final jsAnonymous = new JsTypeAnonymous();
        final jsType = new JsType();

        jsBackedMap['jsAnonymous'] = jsAnonymous;
        jsBackedMap['jsType'] = jsType;
        expect(jsBackedMap['jsAnonymous'], same(jsAnonymous));
        expect(jsBackedMap['jsType'], same(jsType));

        dynamicJsBackedMap['jsAnonymous'] = jsAnonymous as dynamic;
        dynamicJsBackedMap['jsType'] = jsType as dynamic;
        expect(dynamicJsBackedMap['jsAnonymous'], same(jsAnonymous));
        expect(dynamicJsBackedMap['jsType'], same(jsType));
      });
    });
  });
}

class Foo {
  final foo;
  Foo(this.foo);
}

@JS()
@anonymous
class JsTypeAnonymous {
  external factory JsTypeAnonymous();
}

@JS()
class JsType {
  external JsType();
}
