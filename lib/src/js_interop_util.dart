@JS()
library js_interop_util;

import 'dart:js_util';

import 'package:js/js.dart';

@JS('Object.keys')
external List<Object?> objectKeys(Object object);

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
  // ignore: avoid_types_on_closure_parameters
  return Promise(allowInterop((Function resolve, Function reject) {
    future.then((result) => resolve(result), onError: reject);
  }));
}

@JS()
abstract class Promise {
  external factory Promise(
      Function(dynamic Function(dynamic value) resolve, dynamic Function(dynamic error) reject) executor);

  external Promise then(dynamic Function(dynamic value) onFulfilled, [dynamic Function(dynamic error) onRejected]);
}
