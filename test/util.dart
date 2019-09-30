@JS()
library react.test.util;

import 'dart:js_util' show getProperty;

import 'package:js/js.dart';

@JS('Object.keys')
external List _objectKeys(obj);

Map getProps(elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(_objectKeys(props), value: (key) => getProperty(props, key));
}
