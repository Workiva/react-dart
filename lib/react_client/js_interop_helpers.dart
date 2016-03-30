/// Utilities for reading/modifying dynamic keys on JavaScript objects
/// and converting Dart [Map]s to JavaScript objects.
library react_client.js_interop_helpers;

import "package:js/js.dart";

@JS('eval')
external dynamic _eval(String source);

@JS()
external dynamic _getProperty(jsObj, String key);

@JS()
external dynamic _setProperty(jsObj, String key, value);

typedef dynamic _GetPropertyFn(jsObj, String key);
typedef dynamic _SetPropertyFn(jsObj, String key, value);

/// Returns the property at the given [_GetPropertyFn.key] on the
/// specified JavaScript object [_GetPropertyFn.jsObj]
///
/// Necessary because `external operator[]` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
final _GetPropertyFn getProperty = (() {
  _eval(r'''
    function _getProperty(obj, key) {
      return obj[key];
    }
  ''');

  return _getProperty;
})();

/// Sets the property at the given [_SetPropertyFn.key] to [_SetPropertyFn.value]
/// on the specified JavaScript object [_SetPropertyFn.jsObj]
///
/// Necessary because `external operator[]=` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
final _SetPropertyFn setProperty = (() {
  _eval(r'''
    function _setProperty(obj, key, value) {
      return obj[key] = value;
    }
  ''');

  return _setProperty;
})();


/// A interop class for an anonymous JavaScript object, with no properties.
///
/// For use when dealing with dynamic properties via [getProperty]/[setProperty].
@JS()
@anonymous
class EmptyObject {
  external factory EmptyObject();
}

/// Returns [map] converted to a JavaScript object, similar to
/// `new JsObject.jsify` in `dart:js`.
///
/// Recursively converts nested [Map]s, and wraps [Function]s with [allowInterop].
EmptyObject jsify(Map map) {
  var jsMap = new EmptyObject();

  map.forEach((key, value) {
    if (value is Map) {
      value = jsify(value);
    } else if (value is Function) {
      value = allowInterop(value);
    }

    setProperty(jsMap, key, value);
  });

  return jsMap;
}
