@JS()
library react.test.util;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('Object.keys')
external List _objectKeys(obj);

Map getProps(elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(_objectKeys(props), value: (key) => getProperty(props, key));
}
