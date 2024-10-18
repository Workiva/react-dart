@TestOn('browser')
@JS()
library react.js_backed_map_test.dart;

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import '../shared_type_tester.dart';

main() {
  group('JsBackedMap', () {
    group('sets and retrieves values without JS interop interfering with them:', () {
      void testTypeValue(dynamic testValue) {
        final jsBackedMap = JsBackedMap();
        jsBackedMap['testValue'] = testValue;
        expect(jsBackedMap['testValue'], same(testValue));
      }

      sharedTypeTests(testTypeValue);

      group('works as expected with different key types, coercing non-string keys to JS strings:', () {
        const testValue = 'testValue';

        void sharedTest(dynamic key, String expectedKeyString) {
          final jsBackedMap = JsBackedMap();
          jsBackedMap[key] = testValue;
          expect(jsBackedMap.keys, [expectedKeyString]);
          expect(jsBackedMap[key], testValue);
          expect(jsBackedMap[expectedKeyString], testValue);
          // We want to explicitly test containsKey implementation instead of using the `contains` matcher,
          // which may or may not call that method under the hood.
          expect(jsBackedMap.containsKey(key), isTrue);
          expect(jsBackedMap.containsKey(expectedKeyString), isTrue);
          jsBackedMap.remove(key);
          expect(jsBackedMap, isEmpty);
        }

        test('string', () => sharedTest('testKey', 'testKey'));

        test('null', () => sharedTest(null, 'null'));

        test('numbers', () => sharedTest(123, '123'));

        test('booleans', () => sharedTest(true, 'true'));

        test('other objects', () => sharedTest(TestObject(), TestObject().toString()));
      });
    });

    // Tests related to our workaround for https://github.com/dart-lang/sdk/issues/36116.
    group(
        'map lookup returns null instead of undefined, so that the value does not interfere with Dart function calls:',
        () {
      test('test setup check: getNullishValueType works as expected', () {
        expect(getNullishValueType(jsUndefined), 'undefined');
        expect(getNullishValueType(jsNull), 'null');
      });

      test('returns null and not undefined', () {
        final jsBackedMap = JsBackedMap();
        final value = jsBackedMap['missingKey'];
        // We can't use `identical(value, jsUndefined)` (or the `same` matcher which uses `identical`)
        // since it's special-cased to return true when passed two nullish (null or undefined) values.
        // Instead, we'll use a custom JS interop function to classify the value
        expect(getNullishValueType(value), 'null');
      });

      test('test setup check: triggersDdcOptionalArgumentBug works as expected to reproduce and detect the bug', () {
        expect(triggersDdcOptionalArgumentBug(jsUndefined), isTrue,
            reason: 'if this expectation fails in newer Dart SDKs, then this bug may have been fixed.');
        expect(triggersDdcOptionalArgumentBug(null), isFalse);
        // Since this bug only affects DDC, this test will fail in dart2js.
      }, tags: 'no-dart2js');

      // We only need to run this test in DDC since the bug does not effect dart2js, but it doesn't hurt to also
      // validate behavior in dart2js, and could catch new, similar dart2js bugs.
      test('regression test: returned value does not trigger argument issues', () {
        final jsBackedMap = JsBackedMap();
        final value = jsBackedMap['missingKey'];
        expect(triggersDdcOptionalArgumentBug(value), isFalse);
      });
    });

    group('constructor', () {
      test('(default) creates an instance backed by a new JS object', () {
        final jsBackedMap = JsBackedMap();
        expect(jsBackedMap.jsObject, isNotNull);
        expect(jsBackedMap.jsObject, isNot(JsBackedMap().jsObject));
      });

      test('.backedBy creates a new instance backed by a given JS map', () {
        final jsMap = jsify({'foo': 1}) as JsMap;
        final jsBackedMap = JsBackedMap.backedBy(jsMap);
        expect(jsBackedMap, containsPair('foo', 1));

        setProperty(jsMap, 'baz', 2);
        expect(jsBackedMap, containsPair('baz', 2), reason: 'should be backed by the given JS map');
      });

      test('.from creates a new instance with all key-value pairs from another map', () {
        final otherMap = {'foo': 1};
        final jsBackedMap = JsBackedMap.from(otherMap);
        expect(jsBackedMap, otherMap);

        otherMap['bar'] = 2;
        expect(jsBackedMap, hasLength(1), reason: 'should not be backed by the other map');
      });

      test('.fromJs creates a new instance with all key-value pairs from another JS map', () {
        final otherJsMap = jsify({'foo': 1}) as JsMap;
        final jsBackedMap = JsBackedMap.fromJs(otherJsMap);
        expect(jsBackedMap, containsPair('foo', 1));
        expect(jsBackedMap.jsObject, isNot(otherJsMap));

        setProperty(otherJsMap, 'baz', 2);
        expect(jsBackedMap, hasLength(1), reason: 'should not be backed by the other map');
      });
    });

    test('addAllFromJs adds all properties from another JS object', () {
      final jsMap = JsBackedMap.from({
        'foo': 1,
        'bar': 2,
      })
        ..addAllFromJs(jsify({
          'foo': 'overwritten',
          'baz': 3,
        }) as JsMap);
      expect(jsMap, {
        'foo': 'overwritten',
        'bar': 2,
        'baz': 3,
      });
    });

    test('is equal to other instances backed by the same JS object', () {
      final jsObjectA = JsMap();
      final jsObjectB = JsMap();

      final backedByA1 = JsBackedMap.backedBy(jsObjectA);
      final backedByA2 = JsBackedMap.backedBy(jsObjectA);
      final backedByB = JsBackedMap.backedBy(jsObjectB);

      // Don't use equals/isNot matchers since they perform deep map equality,
      // which we don't want here.
      expect(backedByA1 == backedByA2, isTrue);
      expect(backedByA1 == backedByB, isFalse);
    });

    group('has a valid hashCode that does not throw, when backed by', () {
      test('normal JS objects', () {
        final jsBackedMap = JsBackedMap();
        expect(() => jsBackedMap.hashCode, returnsNormally);
      });

      test('frozen JS objects', () {
        final jsBackedMap = JsBackedMap();
        _objectFreeze(jsBackedMap.jsObject);
        try {
          // This throws only in strict-mode JS, meaning it throws in DDC and not in dart2js.
          jsBackedMap['foo'] = 'bar';
        } catch (_) {}
        expect(jsBackedMap, isEmpty, reason: 'test setup check; object should be frozen');

        // DDC throws when attempting to access `.hashCode` on frozen objects:
        // https://github.com/dart-lang/sdk/issues/36354
        expect(() => jsBackedMap.hashCode, returnsNormally);
      });
    });

    group('other map methods overridden or needed by MapBase', () {
      late JsBackedMap testMap;

      setUp(() {
        testMap = JsBackedMap.from({
          'foo': 1,
          'bar': 2,
        });
      });

      test('keys', () {
        expect(testMap.keys, unorderedEquals(['foo', 'bar']));
      });

      test('values', () {
        expect(testMap.values, unorderedEquals([1, 2]));
      });

      group('addAll', () {
        test('', () {
          testMap.addAll({
            'foo': 'overwritten',
            'baz': 3,
          });
          expect(testMap, {
            'foo': 'overwritten',
            'bar': 2,
            'baz': 3,
          });
        });

        test('with a JSBackedMap (special case)', () {
          testMap.addAll(JsBackedMap.from({
            'foo': 'overwritten',
            'baz': 3,
          }));
          expect(testMap, {'foo': 'overwritten', 'bar': 2, 'baz': 3});
        });
      });

      test('clear', () {
        testMap.clear();
        expect(testMap, isEmpty);
      });

      group('containsKey:', () {
        test('for key in map', () {
          expect(testMap.containsKey('bar'), isTrue);
        });

        test('for key not in map', () {
          expect(testMap.containsKey('not in the map'), isFalse);
        });
      });

      group('remove:', () {
        test('for key in map', () {
          final value = testMap.remove('bar');
          expect(testMap, {'foo': 1});
          expect(value, 2);
        });

        test('for key not in map', () {
          final value = testMap.remove('not in the map');
          expect(testMap, {'foo': 1, 'bar': 2});
          expect(value, isNull);
        });
      });
    });
  });
}

class TestObject {}

@JS()
external String getNullishValueType(dynamic value);

class _Default {
  const _Default();
}

const _default = _Default();

bool _defaultArgumentSpecifiedUsed([x = _default]) => x == _default;

bool triggersDdcOptionalArgumentBug(dynamic value) {
  // We'd expect this call to always return false,
  // but it returns true in DDC if `value` is `undefined`.
  // https://github.com/dart-lang/sdk/issues/36116
  return _defaultArgumentSpecifiedUsed(value);
}

@JS('Object.freeze')
external void _objectFreeze(JsMap object);
