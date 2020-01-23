@JS()
library react_client.private_utils;

import 'dart:js_util';

import 'package:js/js.dart';
import 'js_backed_map.dart';

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, JsMap descriptor);

String getJsFunctionName(Function object) => getProperty(object, 'name') ?? getProperty(object, '\$static_name');
