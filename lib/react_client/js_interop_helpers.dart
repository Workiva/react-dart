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

/// __Deprecated:__ Use [js_util.getProperty] instead.
///
/// Returns the property at the given [_GetPropertyFn.key] on the
/// specified JavaScript object [_GetPropertyFn.jsObj]
///
/// Necessary because `external operator[]` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
///
/// __Defined in this package's React JS files.__
@Deprecated('5.0.0')
final _GetPropertyFn getProperty = (() {
  try {
    // If this throws, then the JS function isn't available.
    _getProperty(new EmptyObject(), null);
  } catch (_) {
    throw new _MissingJsMemberError(
        '_getProperty',
        'Be sure to include React JS files included in this package '
        '(which has this and other JS interop helper functions included) '
        'or, alternatively, define the function yourself:\n'
        '    function _getProperty(obj, key) { return obj[key]; }');
  }

  return _getProperty;
})();

/// __Deprecated:__ Use [js_util.setProperty] instead.
///
/// Sets the property at the given [_SetPropertyFn.key] to [_SetPropertyFn.value]
/// on the specified JavaScript object [_SetPropertyFn.jsObj]
///
/// Necessary because `external operator[]=` isn't allowed on JS interop classes
/// (see: https://github.com/dart-lang/sdk/issues/25053).
///
/// __Defined in this package's React JS files.__
@Deprecated('5.0.0')
final _SetPropertyFn setProperty = (() {
  try {
    // If this throws, then the JS function isn't available.
    _setProperty(new EmptyObject(), null, null);
  } catch (_) {
    throw new _MissingJsMemberError(
        '_setProperty',
        'Be sure to include React JS files included in this package '
        '(which has this and other JS interop helper functions included) '
        'or, alternatively, define the function yourself:\n'
        '    function _setProperty(obj, key, value) { return obj[key] = value; }');
  }

  return _setProperty;
})();

/// __Deprecated:__ Use [js_util.newObject] instead.
///
/// An interop class for an anonymous JavaScript object, with no properties.
///
/// For use when dealing with dynamic properties via [getProperty]/[setProperty].
@JS()
@anonymous
@Deprecated('5.0.0')
class EmptyObject {
  external factory EmptyObject();
}

/// __Deprecated:__ Use [js_util.jsify]/[jsifyAndAllowInterop] based on your
/// needs.
///
/// Returns [map] converted to a JavaScript object, similar to
/// `new JsObject.jsify` in `dart:js`.
///
/// Recursively converts nested [Map]s, and wraps [Function]s with [allowInterop].
@Deprecated('5.0.0')
EmptyObject jsify(Map map) {
  var jsMap = new EmptyObject();

  map.forEach((key, value) {
    var jsValue;
    if (value is Map) {
      jsValue = jsify(value);
    } else if (value is Function) {
      jsValue = allowInterop(value);
    } else {
      jsValue = value;
    }

    setProperty(jsMap, key, jsValue);
  });

  return jsMap;
}

// The following code is adapted from `package:js` in the dart-lang/sdk repo:
// https://github.com/dart-lang/sdk/blob/2.2.0/sdk/lib/js_util/dart2js/js_util_dart2js.dart#L27
//
// Copyright 2012, the Dart project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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

/// The same as [jsify], except [Function]s are converted with [allowInterop].
///
/// ---
///
/// *From [jsify]'s docs:*
///
/// WARNING: performance of this method is much worse than other util
/// methods in this library. Only use this method as a last resort.
///
/// Recursively converts a JSON-like collection of Dart objects to a
/// collection of JavaScript objects and returns a [JsObject] proxy to it.
///
/// [object] must be a [Map] or [Iterable], the contents of which are also
/// converted. Maps and Iterables are copied to a new JavaScript object.
/// Primitives and other transferable values are directly converted to their
/// JavaScript type, and all other objects are proxied.
dynamic jsifyAndAllowInterop(object) {
  if (object is! Map && object is! Iterable) {
    throw new ArgumentError.value(object, 'object', 'must be a Map or Iterable');
  }
  return _convertDataTree(object);
}

_convertDataTree(data) {
  final _convertedObjects = new Map.identity();

  _convert(o) {
    if (_convertedObjects.containsKey(o)) {
      return _convertedObjects[o];
    }
    if (o is Map) {
      final convertedMap = js_util.newObject();
      _convertedObjects[o] = convertedMap;
      for (var key in o.keys) {
        setProperty(convertedMap, key, _convert(o[key]));
      }
      return convertedMap;
    } else if (o is Iterable) {
      final convertedList = [];
      _convertedObjects[o] = convertedList;
      convertedList.addAll(o.map(_convert));
      return convertedList;
    } else if (o is Function) {
      final convertedFunction = allowInterop(o);
      _convertedObjects[o] = convertedFunction;
      return convertedFunction;
    } else {
      return o;
    }
  }

  return _convert(data);
}
