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
