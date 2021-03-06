@JS()
library js_interop_util;

import 'dart:js_util';

import 'package:js/js.dart';

@JS('Object.keys')
external List<Object?> objectKeys(Object object);

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, PropertyDescriptor descriptor);

@JS()
@anonymous
class PropertyDescriptor {
  external factory PropertyDescriptor({dynamic value});
}

String? getJsFunctionName(Function object) =>
    (getProperty(object, 'name') ?? getProperty(object, '\$static_name')) as String?;
