import 'dart:js_util' show getProperty;

import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/js_interop_util.dart';
import 'package:test/test.dart';

Map getProps(dynamic elementOrComponent) {
  var props = elementOrComponent.props;

  return new Map.fromIterable(objectKeys(props), value: (key) => getProperty(props, key));
}

bool isDartComponent1(ReactElement element) =>
    // ignore: invalid_use_of_protected_member
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component;

bool isDartComponent2(ReactElement element) =>
    // ignore: invalid_use_of_protected_member
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component2;

// ignore: invalid_use_of_protected_member
bool isDartComponent(ReactElement element) => ReactDartComponentVersion.fromType(element.type) != null;

// ignore: deprecated_member_use_from_same_package
T getDartComponent<T extends react.Component>(ReactComponent dartComponent) {
  return dartComponent.dartComponent as T;
}

Map getDartComponentProps(ReactComponent dartComponent) {
  return getDartComponent(dartComponent).props;
}

Map getDartElementProps(ReactElement dartElement) {
  // ignore: deprecated_member_use_from_same_package
  return isDartComponent2(dartElement) ? new JsBackedMap.fromJs(dartElement.props) : dartElement.props.internal.props;
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
///
/// Test cases should not be reused within a test or across multiple tests, to avoid
/// the [ref] from being used by multiple components and its value being polluted.
class RefTestCase {
  /// The name of the test case.
  final String name;

  /// The ref to be passed into a component.
  final dynamic ref;

  /// Verifies (usually via `expect`) that the ref was updated exactly once with [actualValue].
  final Function(dynamic actualValue) verifyRefWasUpdated;

  /// Returns the current value of the ref.
  final dynamic Function() getCurrent;

  /// Whether the ref is a non-Dart object, such as a ref originating from outside of Dart code
  /// or a JS-converted Dart ref.
  final bool isJs;

  RefTestCase({
    @required this.name,
    @required this.ref,
    @required this.verifyRefWasUpdated,
    @required this.getCurrent,
    this.isJs = false,
  });
}

/// A collection of methods that create [RefTestCase]s, combined into a class so that they can easily share a
/// generic parameter [T] (the type of the Dart ref value).
class RefTestCaseCollection<T> {
  final bool includeJsCallbackRefCase;

  RefTestCaseCollection({this.includeJsCallbackRefCase = true}) {
    if (T == dynamic) {
      throw ArgumentError('Generic parameter T must be specified');
    }
  }

  RefTestCase createUntypedCallbackRefCase() {
    const name = 'untyped callback ref';
    final calls = [];
    return RefTestCase(
      name: name,
      ref: (value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
    );
  }

  RefTestCase createTypedCallbackRefCase() {
    const name = 'typed callback ref';
    final calls = [];
    return RefTestCase(
      name: name,
      ref: (T value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
    );
  }

  RefTestCase createRefObjectCase<T>() {
    const name = 'ref object';
    final ref = createRef<T>();
    return RefTestCase(
      name: name,
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue), reason: _reasonMessage(name)),
      getCurrent: () => ref.current,
    );
  }

  RefTestCase createJsCallbackRefCase() {
    const name = 'JS callback ref';
    final calls = [];
    return RefTestCase(
      name: name,
      ref: allowInterop((value) => calls.add(value)),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
      isJs: true,
    );
  }

  RefTestCase createJsRefObjectCase() {
    const name = 'JS ref object';
    final ref = React.createRef();
    return RefTestCase(
      name: name,
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue), reason: _reasonMessage(name)),
      getCurrent: () => ref.current,
      isJs: true,
    );
  }

  static String _reasonMessage(String name) => '$name should have been updated';

  /// Creates test cases for all of the valid, chainable ref types:
  ///
  /// 1. callback ref with untyped argument
  /// 2. callback ref with typed argument
  /// 3. createRef (Dart wrapper)
  /// 4. createRef (JS object)
  List<RefTestCase> createAllCases() => [
        createUntypedCallbackRefCase(),
        createTypedCallbackRefCase(),
        createRefObjectCase(),
        if (includeJsCallbackRefCase) createJsCallbackRefCase(),
        createJsRefObjectCase(),
      ];

  RefTestCase createCaseByName<T>(String name) => createAllCases().singleWhere((c) => c.name == name);

  List<String> get allTestCaseNames => createAllCases().map((c) => c.name).toList();
}
