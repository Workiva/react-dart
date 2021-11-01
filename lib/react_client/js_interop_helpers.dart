/// Utilities for reading/modifying dynamic keys on JavaScript objects
/// and converting Dart [Map]s to JavaScript objects.
@JS()
library react_client.js_interop_helpers;

import 'dart:collection';
import "dart:js_util";

import "package:js/js.dart";

import 'js_backed_map.dart';

/// Like [identityHashCode], but uses a different hash for JS objects to work around an issue where
/// [identityHashCode] adds an unwanted `$identityHash` property on JS objects (https://github.com/dart-lang/sdk/issues/47595).
int _jsObjectFriendlyIdentityHashCode(Object object) =>
    object is JsMap ? _jsObjectHashCode(object) : identityHashCode(object);

/// A hashCode implementation for JS objects.
///
/// Even though the current implementation of returning the same hash code for all values is low-quality
/// since all JS objects will collide, it is valid since it always returns the same value for the same object.
///
/// We also don't expect many JS objects to be passed into [jsifyAndAllowInterop], so the quality of this hash code
/// is not of much concern.
int _jsObjectHashCode(JsMap jsObject) => 0;

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
  // Use _jsObjectFriendlyIdentityHashCode instead of `identityHashCode`/`Map.identity()`
  // to work around https://github.com/dart-lang/sdk/issues/47595
  final _convertedObjects = LinkedHashMap(equals: identical, hashCode: _jsObjectFriendlyIdentityHashCode);

  _convert(o) {
    if (_convertedObjects.containsKey(o)) {
      return _convertedObjects[o];
    }
    if (o is Map) {
      final convertedMap = newObject();
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

/// Keeps track of functions found when converting JS props to Dart props.
///
/// See: [forwardRef] for usage / context.
final isRawJsFunctionFromProps = Expando<bool>();
