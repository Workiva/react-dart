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

// Necessary because `external operator[]` isn't allowed on JS interop classes https://github.com/dart-lang/sdk/issues/25053
final _GetPropertyFn getProperty = (() {
  _eval(r'''
    function _getProperty(obj, key) {
      return obj[key];
    }
  ''');

  return _getProperty;
})();

// Necessary because `external operator[]=` isn't allowed on JS interop classes https://github.com/dart-lang/sdk/issues/25053
final _SetPropertyFn setProperty = (() {
  _eval(r'''
    function _setProperty(obj, key, value) {
      return obj[key] = value;
    }
  ''');

  return _setProperty;
})();


@JS()
@anonymous
class EmptyObject {
  external factory EmptyObject();
}

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
