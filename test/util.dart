// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.test.util;

import 'dart:js_util' show getProperty;

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/react.dart' as react;
import 'package:react/react_client/js_backed_map.dart';

@JS('Object.keys')
external List _objectKeys(obj);

Map getProps(dynamic elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(_objectKeys(props), value: (key) => getProperty(props, key));
}

bool isDartComponent1(ReactElement element) {
  return element.type is! String && (element.type as ReactClass).dartComponentVersion == '1';
}

bool isDartComponent2(ReactElement element) {
  return element.type is! String && (element.type as ReactClass).dartComponentVersion == '2';
}

bool isDartComponent(ReactElement element) {
  return element.type is! String && (element.type as ReactClass).dartComponentVersion != null;
}

T getDartComponent<T extends react.Component>(ReactComponent dartComponent) {
  return dartComponent.dartComponent as T;
}

T getDartComponent2<T extends react.Component2>(ReactComponent dartComponent) {
  return dartComponent.dartComponent as T;
}

Map getDartComponentProps(ReactComponent dartComponent) {
  return getDartComponent(dartComponent).props;
}

Map getDartComponentProps2(ReactComponent dartComponent) {
  return getDartComponent2(dartComponent).props;
}

Map getDartElementProps(ReactElement dartElement) {
  return isDartComponent2(dartElement) ? new JsBackedMap.fromJs(dartElement.props) : dartElement.props.internal.props;
}

ReactComponent render(ReactElement reactElement) {
  return rtu.renderIntoDocument(reactElement);
}

/// Returns a new [Map.unmodifiable] with all argument maps merged in.
Map unmodifiableMap([Map map1, Map map2, Map map3, Map map4]) {
  var merged = {};
  if (map1 != null) merged.addAll(map1);
  if (map2 != null) merged.addAll(map2);
  if (map3 != null) merged.addAll(map3);
  if (map4 != null) merged.addAll(map4);
  return new Map.unmodifiable(merged);
}
