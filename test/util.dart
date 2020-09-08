// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: invalid_use_of_protected_member
@JS()
library react.test.util;

import 'dart:js_util' show getProperty;

import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/src/js_interop_util.dart';
import 'package:test/test.dart';

Map getProps(dynamic elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(objectKeys(props), value: (key) => getProperty(props, key));
}

bool isDartComponent1(ReactElement element) =>
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component;

bool isDartComponent2(ReactElement element) =>
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component2;

bool isDartComponent(ReactElement element) => ReactDartComponentVersion.fromType(element.type) != null;

T getDartComponent<T extends react.Component>(ReactComponent dartComponent) {
  return dartComponent.dartComponent as T;
}

Map getDartComponentProps(ReactComponent dartComponent) {
  return getDartComponent(dartComponent).props;
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

bool assertsEnabled() {
  bool assertsEnabled = false;
  assert(assertsEnabled = true);
  return assertsEnabled;
}

/// A test case that can be used for consuming a specific kind of ref and verifying
/// it was updated properly when rendered.
class RefTestCase {
  final dynamic ref;
  final Function(dynamic actualValue) verifyRefWasUpdated;

  RefTestCase._({@required this.ref, @required this.verifyRefWasUpdated});

  static RefTestCase untypedCallbackRefCase() {
    final calls = [];
    return RefTestCase._(
      ref: (value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)]),
    );
  }

  static RefTestCase typedCallbackRefCase<T>() {
    final calls = [];
    return RefTestCase._(
      ref: (T value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)]),
    );
  }

  static RefTestCase refObjectCase<T>() {
    final ref = createRef<T>();
    return RefTestCase._(
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue)),
    );
  }

  static RefTestCase jsRefObjectCase() {
    final ref = React.createRef();
    return RefTestCase._(
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue)),
    );
  }

  /// Test cases for each of the valid, chainable ref types:
  ///
  /// 1. callback ref with untyped argument
  /// 2. callback ref with typed argument
  /// 3. createRef (Dart wrapper)
  /// 4. createRef (JS object)
  static List<RefTestCase> allChainable<T>() => [
        untypedCallbackRefCase(),
        typedCallbackRefCase<T>(),
        refObjectCase<T>(),
        jsRefObjectCase(),
      ];
}
