// Adapted from https://github.com/dart-lang/sdk/blob/e995cb5f7cd67d39c1ee4bdbe95c8241db36725f/tests/lib/js/js_util/jsify_test.dart
//
// Copyright 2012, the Dart project authors.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google LLC nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@JS()
@TestOn('browser')
library react.js_interop_helpers_test;

import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/src/js_interop_util.dart';
import 'package:test/test.dart';

@JS()
external bool checkMap(Object m, String key, Object value);

@JS()
class Foo {
  external Foo(num a);

  external num get a;

  external num bar();
}

@JS()
external dynamic createArray();

main() {
  group('jsifyAndAllowInterop', () {
    test('converts a List', () {
      final list = [1, 2, 3, 4, 5, 6, 7, 8];
      final array = jsifyAndAllowInterop(list);
      expect(array is List, isTrue);
      expect(identical(array, list), isFalse);
      expect(array.length, equals(list.length));
      for (var i = 0; i < list.length; i++) {
        expect(array[i], equals(list[i]));
      }
    });

    test('converts an Iterable', () {
      final set = new Set.from([1, 2, 3, 4, 5, 6, 7, 8]);
      final array = jsifyAndAllowInterop(set);
      expect(array is List, isTrue);
      expect(array.length, equals(set.length));
      for (var i = 0; i < array.length; i++) {
        expect(set.contains(array[i]), isTrue);
      }
    });

    test('converts a Map', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      final jsMap = jsifyAndAllowInterop(map);
      expect(jsMap is List, isFalse);
      expect(jsMap is Map, isFalse);
      for (final key in map.keys) {
        expect(checkMap(jsMap, key, map[key]), isTrue);
      }
    });

    test('converts nested Functions', () {
      function() {}
      final converted = jsifyAndAllowInterop({'function': function});
      expect(getProperty(converted, 'function'), same(allowInterop(function)));
    });

    test('deep converts a complex object', () {
      final object = {
        'a': [
          1,
          [2, 3]
        ],
        'b': {'c': 3, 'd': Foo(42)},
        'e': null
      } as dynamic;
      final jsObject = jsifyAndAllowInterop(object);
      expect(getProperty(jsObject, 'a')[0], equals(object['a'][0]));
      expect(getProperty(jsObject, 'a')[1][0], equals(object['a'][1][0]));
      expect(getProperty(jsObject, 'a')[1][1], equals(object['a'][1][1]));

      final b = getProperty(jsObject, 'b');
      expect(getProperty(b, 'c'), equals(object['b']['c']));
      final d = getProperty(b, 'd');
      expect(d, equals(object['b']['d']));
      expect(getProperty(d, 'a'), equals(42));
      expect(callMethod(d, 'bar', []), equals(42));

      expect(getProperty(jsObject, 'e'), isNull);
    });

    test('throws if object is not a Map or Iterable', () {
      expect(() => jsifyAndAllowInterop('a'), throwsArgumentError);
    });

    test('does not result in unwanted properties (e.g., \$identityHash) being added to converted JS objects', () {
      final nestedJsObject = jsifyAndAllowInterop({'foo': 'bar'});
      const expectedProperties = ['foo'];
      expect(objectKeys(nestedJsObject), expectedProperties, reason: 'test setup check');

      // We want to include a JS object in jsifyAndAllowInterop
      final jsObject = jsifyAndAllowInterop({
        'nestedJsObject': nestedJsObject,
      });
      final convertedNestedJsObject = getProperty(jsObject, 'nestedJsObject');
      expect(convertedNestedJsObject, same(nestedJsObject), reason: 'JS object should have just gotten passed through');
      expect(objectKeys(convertedNestedJsObject), expectedProperties,
          reason: 'JS object should not have any additional properties');
    });

    group('works as expected when the map contains frozen objects:', () {
      test('anonymous object', () {
        final frozenAnonymousObject = jsify({'foo': 'bar'});
        expect(_getPrototypeOf(frozenAnonymousObject), _objectPrototype,
            reason: 'test setup check; should not extend from another JS type');

        _freeze(frozenAnonymousObject);
        expect(_isFrozen(frozenAnonymousObject), isTrue, reason: 'test setup check; should have frozen');

        dynamic jsObject;
        expect(() {
          jsObject = jsifyAndAllowInterop({
            'frozenObject': frozenAnonymousObject,
          });
        }, returnsNormally, reason: 'should not throw when it encounters a frozen object');
        final convertedNestedFrozenObject = getProperty(jsObject, 'frozenObject');
        expect(convertedNestedFrozenObject, same(frozenAnonymousObject),
            reason: 'JS object should have just gotten passed through');
      });

      test('non-anonymous object', () {
        final frozenNonAnynymousObject = Foo(21);
        expect(_getPrototypeOf(frozenNonAnynymousObject), isNot(_objectPrototype),
            reason: 'test setup check; should extend from another JS type');

        _freeze(frozenNonAnynymousObject);
        expect(_isFrozen(frozenNonAnynymousObject), isTrue, reason: 'test setup check; should have frozen');

        dynamic jsObject;
        expect(() {
          jsObject = jsifyAndAllowInterop({
            'frozenObject': frozenNonAnynymousObject,
          });
        }, returnsNormally, reason: 'should not throw when it encounters a frozen object');
        final convertedNestedFrozenObject = getProperty(jsObject, 'frozenObject');
        expect(convertedNestedFrozenObject, same(frozenNonAnynymousObject),
            reason: 'JS object should have just gotten passed through');
      });

      test('array object constructed in JS', () {
        // Create this on the JS side so that we're not starting out with Dart's list implementation
        // and potentially any wrapper classes.
        final frozenArray = createArray();
        expect(_getPrototypeOf(frozenArray), _arrayPrototype, reason: 'test setup check; should be an array');

        _freeze(frozenArray);
        expect(_isFrozen(frozenArray), isTrue, reason: 'test setup check; should have frozen');

        dynamic jsObject;
        expect(() {
          jsObject = jsifyAndAllowInterop({
            'frozenArray': frozenArray,
          });
        }, returnsNormally, reason: 'should not throw when it encounters a frozen object');
        final convertedNestedFrozenObject = getProperty(jsObject, 'frozenArray');
        // Note that we don't expect it to be `same(frozenArray)` since the array passes the `is Iterable` check,
        // and thus gets processed in _convertDataTree.
        expect(convertedNestedFrozenObject, equals(frozenArray),
            reason: 'JS object should have been converted properly passed through');
      });
    });
  });
}

@JS('Object.prototype')
external dynamic get _objectPrototype;

@JS('Array.prototype')
external dynamic get _arrayPrototype;

@JS('Object.freeze')
external void _freeze(Object object);

@JS('Object.isFrozen')
external bool _isFrozen(Object object);

@JS('Object.getPrototypeOf')
external dynamic _getPrototypeOf(Object object);
