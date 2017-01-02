/// Utilities for reading/modifying dynamic keys on JavaScript objects
/// and converting Dart [Map]s to JavaScript objects.
@JS()
library react_client.js_interop_helpers;

import "package:js/js.dart";
import "package:js/js_util.dart" as js_util;

@JS()
external dynamic _getProperty(jsObj, String key);

@JS()
external dynamic _setProperty(jsObj, String key, value);

typedef dynamic _GetPropertyFn(jsObj, String key);
typedef dynamic _SetPropertyFn(jsObj, String key, value);

class _MissingJsMemberError extends Error {
  final String name;
  final String message;

  _MissingJsMemberError(this.name, [this.message]);

  @override
  String toString() =>
      '_MissingJsMemberError: The JS member `$name` is missing and thus '
      'cannot be used as expected. $message';
}
/// __Deprecated: use [js_util.getProperty] instead.
///
/// Returns the property at the given [_GetPropertyFn.key] on the
/// specified JavaScript object [_GetPropertyFn.jsObj]
///
/// Necessary because `external operator[]` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
///
/// __Defined in this package's React JS files.__
@Deprecated('4.0.0')
final _GetPropertyFn getProperty = (() {
  try {
    // If this throws, then the JS function isn't available.
    _getProperty(js_util.newObject(), null);
  } catch(_) {
    throw new _MissingJsMemberError('_getProperty',
        'Be sure to include React JS files included in this package '
        '(which has this and other JS interop helper functions included) '
        'or, alternatively, define the function yourself:\n'
        '    function _getProperty(obj, key) { return obj[key]; }'
    );
  }

  return _getProperty;
})();

/// __Deprecated: use [js_util.setProperty] instead.
///
/// Sets the property at the given [_SetPropertyFn.key] to [_SetPropertyFn.value]
/// on the specified JavaScript object [_SetPropertyFn.jsObj]
///
/// Necessary because `external operator[]=` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
///
/// __Defined in this package's React JS files.__
@Deprecated('4.0.0')
final _SetPropertyFn setProperty = (() {
  try {
    // If this throws, then the JS function isn't available.
    _setProperty(js_util.newObject(), null, null);
  } catch(_) {
    throw new _MissingJsMemberError('_setProperty',
        'Be sure to include React JS files included in this package '
        '(which has this and other JS interop helper functions included) '
        'or, alternatively, define the function yourself:\n'
        '    function _setProperty(obj, key, value) { return obj[key] = value; }'
    );
  }

  return _setProperty;
})();


/// __Deprecated: use [js_util.newObject] instead.
///
/// An interop class for an anonymous JavaScript object, with no properties.
///
/// For use when dealing with dynamic properties via [getProperty]/[setProperty].
@JS()
@anonymous
@Deprecated('4.0.0')
class EmptyObject {
  external factory EmptyObject();
}

/// Returns [map] converted to a JavaScript object, similar to
/// `new JsObject.jsify` in `dart:js`.
///
/// Recursively converts nested [Map]s, and wraps [Function]s with [allowInterop].
///
/// TODO: deprecate and switch over to using [js_util.jsify]
dynamic jsify(Map map) {
  var jsMap = js_util.newObject();

  map.forEach((key, value) {
    if (value is Map) {
      value = jsify(value);
    } else if (value is Function) {
      value = allowInterop(value);
    }

    js_util.setProperty(jsMap, key, value);
  });

  return jsMap;
}
