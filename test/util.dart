@JS()
library react.test.util;

import 'package:js/js.dart';
import 'dart:js_util';

@JS('Object.keys')
external List _objectKeys(obj);

Map getProps(elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(_objectKeys(props), value: (key) => getProperty(props, key));
}
