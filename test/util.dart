@JS()
library react.test.util;

import 'package:js/js.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/react.dart' as react;
import 'package:react/src/react_client/js_backed_map.dart';

@JS('Object.keys')
external List _objectKeys(obj);

Map getProps(elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(_objectKeys(props),
      value: (key) => getProperty(props, key));
}

bool isDartComponent1(ReactElement element) {
  return element.props.internal != null;
}

bool isDartComponent2(ReactElement element) {
  return element.type is! String &&
      (element.type as ReactClass).isDartClass == true;
}

bool isDartComponent(ReactElement element) {
  return isDartComponent1(element) || isDartComponent2(element);
}

react.Component getDartComponent(ReactComponent dartComponent) {
  return dartComponent.dartComponent;
}

Map getDartComponentProps(ReactComponent dartComponent) {
  return getDartComponent(dartComponent).props;
}

Map getDartElementProps(ReactElement dartElement) {
  return isDartComponent2(dartElement)
      ? new JsBackedMap.fromJs(
          dartElement.props as JsMap) // FIXME need to normalize event handlers?
      : dartElement.props.internal.props;
}
