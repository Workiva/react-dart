@JS()
library js_interop_util;

import 'dart:js_util';

import 'package:js/js.dart';

@JS('Object.keys')
// We can't type this as List<String> due to https://github.com/dart-lang/sdk/issues/37676
external List<dynamic /*String*/ > objectKeys(Object object);

@JS()
@anonymous
class JsPropertyDescriptor {
  external factory JsPropertyDescriptor({dynamic value});
}

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, JsPropertyDescriptor descriptor);

String? getJsFunctionName(Function object) =>
    (getProperty(object, 'name') ?? getProperty(object, '\$static_name')) as String?;

/// Creates JS `Promise` which is resolved when [future] completes.
///
/// See also:
/// - [promiseToFuture]
Promise futureToPromise<T>(Future<T> future) {
  return Promise(allowInterop((resolve, reject) {
    future.then((result) => resolve(result), onError: reject);
  }));
}

@JS()
abstract class Promise {
  external factory Promise(
      Function(dynamic Function(dynamic value) resolve, dynamic Function(dynamic error) reject) executor);

  external Promise then(dynamic Function(dynamic value) onFulfilled, [dynamic Function(dynamic error) onRejected]);
}

/// Converts an arbitrary [key] into a value that can be passed into `dart:js_util` methods
/// such as [getProperty] and [setProperty], which only accept non-nullable
/// `name` arguments.
///
/// This function converts `null` to the string `'null'`, which is what JavaScript does under
/// the hood when `null` is used as an object property. Source: the ES6 spec:
/// - https://262.ecma-international.org/6.0/#sec-property-accessors-runtime-semantics-evaluation
/// - https://262.ecma-international.org/6.0/#sec-topropertykey
///
/// See also: https://github.com/dart-lang/sdk/issues/45219
Object nonNullableJsPropertyName(Object? key) => key ?? 'null';
