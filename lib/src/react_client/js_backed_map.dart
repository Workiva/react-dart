@JS()
library js_map;

import 'dart:collection';
import 'dart:core';

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;

class JsBackedMap<V> extends MapBase<String, V> implements Map<String, V> {
  final _JsObject jsObject;

  JsBackedMap() : jsObject = js_util.newObject() as _JsObject; // todo do we need this cast?

  JsBackedMap.backedBy(this.jsObject);

  factory JsBackedMap.from(Map other) => new JsBackedMap()..addAll(other);

  // these checks moved to asserts for better inlining...
  // todo see if we can keep toString() behavior of keys without asserts without breaking map behavior? probably not
  bool _isValidKey(Object key) => key == null || key is String;

  // ----------------------------------
  // Core overrides
  // ----------------------------------

  @override
  V operator [](Object key) {
//    if (!_isValidKey(key)) return null;
//    assert(_isValidKey(key));

    return js_util.getProperty(jsObject, key);
  }

  @override
  void operator []=(String key, V value) {
    js_util.setProperty(jsObject, key, value);
  }

  // todo this cast seems to work in Dart 1 without much overhead in dart2js, but may break in DDC/Dartium and may also break reified types
  @override
  Iterable<String> get keys => _Object.keys(jsObject) as List<String>;

  @override
  V remove(Object key) {
//    assert(_isValidKey(key));
//    if (!_isValidKey(key)) return null;
    final value = this[key];
    _Reflect.deleteProperty(jsObject, value);
    return value;
  }


  @override
  void clear() {
    for (var key in keys) {
      _Reflect.deleteProperty(jsObject, key);
    }
  }

  // ----------------------------------
  // Optimized overrides
  // ----------------------------------

  @override
  void addAll(Map<String, V> other) {
    // Don't check against JsBackedMap<V> since it's less optimized in dart2js,
    // and we can assume that any JsBackedMap that is also a Map<String, V>
    // is also a JsBackedMap<V>. TODO validate in Dart 2 and create dart-lang/sdk bug for this
    if (other is JsBackedMap) {
      // This cast is necessary due to type inference not working
      // properly without the generic parameter, and has no
      // overhead in dart2js
      _Object.assign(jsObject, (other as JsBackedMap).jsObject);
    } else {
      super.addAll(other);
    }
  }

  @override
  bool containsKey(Object key) {
//    if (!_isValidKey(key)) return false;
//    assert(_isValidKey(key));
    return js_util.hasProperty(jsObject, key);
  }

  // todo this cast seems to work in Dart 1 without much overhead in dart2js, but may break in DDC/Dartium and may also break reified types
  @override
  Iterable<V> get values => _Object.values(jsObject) as List<V>;

// TODO not sure if overriding makes sense; check to see which is more optimal for smaller maps
//  @override
//  bool containsValue(Object value) => values.contains(value);

// overridden for to avoid cast in case the implementation of keys changes
//  @override
//  int get length => _Object.keys(jsObject).length;

}

@JS()
@anonymous
class _JsObject {}

@JS('Object')
abstract class _Object {
  // FIXME needs polyfill for IE
  external static void assign(_JsObject to, _JsObject from);
  external static List<dynamic> keys(_JsObject object);
  external static List<dynamic> values(_JsObject object);
}

@JS('Reflect')
abstract class _Reflect {
  // FIXME needs polyfill for IE
  external static bool deleteProperty(_JsObject target, dynamic propertyKey);
}

