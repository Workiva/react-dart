// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: invalid_use_of_protected_member
@JS()
library react.test.util;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/src/react_client/factory_util.dart';
import 'package:test/test.dart';

Map getProps(dynamic elementOrComponent) {
  InteropProps props;
  if (React.isValidElement(elementOrComponent)) {
    props = (elementOrComponent as ReactElement).props;
  } else {
    props = (elementOrComponent as ReactComponent).props;
  }
  return JsBackedMap.backedBy(props);
}

bool isDartComponent1(ReactElement element) =>
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component;

bool isDartComponent2(ReactElement element) =>
    ReactDartComponentVersion.fromType(element.type) == ReactDartComponentVersion.component2;

bool isDartComponent(ReactElement element) => ReactDartComponentVersion.fromType(element.type) != null;

T getDartComponent<T extends react.Component>(dynamic dartComponent) {
  return (dartComponent as ReactComponent).dartComponent! as T;
}

Map getDartComponentProps(dynamic dartComponent) {
  return getDartComponent(dartComponent).props;
}

Map getDartElementProps(ReactElement dartElement) {
  return isDartComponent2(dartElement) ? JsBackedMap.fromJs(dartElement.props) : dartElement.props.internal.props;
}

ReactComponent render(ReactElement reactElement) {
  return rtu.renderIntoDocument(reactElement) as ReactComponent;
}

// Same as the public API but with tightened types to help fix implicit casts
Element? findDomNode(dynamic component) => react_dom.findDOMNode(component) as Element?;

/// Returns a new [Map.unmodifiable] with all argument maps merged in.
Map unmodifiableMap([Map? map1, Map? map2, Map? map3, Map? map4]) {
  final merged = {};
  if (map1 != null) merged.addAll(map1);
  if (map2 != null) merged.addAll(map2);
  if (map3 != null) merged.addAll(map3);
  if (map4 != null) merged.addAll(map4);
  return Map.unmodifiable(merged);
}

bool assertsEnabled() {
  var assertsEnabled = false;
  assert(assertsEnabled = true);
  return assertsEnabled;
}

/// A test case that can be used for consuming a specific kind of ref and verifying
/// it was updated properly when rendered.
///
/// Test cases should not be reused within a test or across multiple tests, to avoid
/// the [ref] from being used by multiple components and its value being polluted.
class RefTestCase {
  /// The ref to be passed into a component.
  final dynamic ref;

  /// Verifies (usually via `expect`) that the ref was updated exactly once with the provided `actualValue`.
  final Function(dynamic actualValue) verifyRefWasUpdated;

  /// Returns the current value of the ref.
  final dynamic Function() getCurrent;

  final RefTestCaseMeta meta;

  RefTestCase({
    required this.ref,
    required this.verifyRefWasUpdated,
    required this.getCurrent,
    required this.meta,
  });
}

/// A collection of methods that create [RefTestCase]s, combined into a class so that they can easily share a
/// generic parameter [T] (the type of the Dart ref value).
class RefTestCaseCollection<T extends Object> {
  final bool includeJsCallbackRefCase;

  RefTestCaseCollection({this.includeJsCallbackRefCase = true}) {
    if (T == dynamic) {
      throw ArgumentError('Generic parameter T must be specified');
    }
  }

  static const untypedCallbackRefCaseName = 'untyped callback ref';

  RefTestCase createUntypedCallbackRefCase() {
    const name = untypedCallbackRefCaseName;
    final calls = [];
    return RefTestCase(
      // Use a lambda instead of a tearoff since we want to explicitly verify
      // a function with a certain argument type.
      // ignore: unnecessary_lambdas
      ref: (value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
      meta: RefTestCaseMeta(name, RefKind.callback, isJs: false, isStronglyTyped: false),
    );
  }

  static const typedCallbackRefCaseName = 'typed callback ref';

  RefTestCase createTypedCallbackRefCase() {
    const name = typedCallbackRefCaseName;
    final calls = [];
    return RefTestCase(
      // Use a lambda instead of a tearoff since we want to explicitly verify
      // a function with a certain argument type.
      // ignore: unnecessary_lambdas, avoid_types_on_closure_parameters
      ref: (T? value) => calls.add(value),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
      meta: RefTestCaseMeta(name, RefKind.callback, isJs: false, isStronglyTyped: true),
    );
  }

  static const untypedRefObjectCaseName = 'untyped ref object';

  RefTestCase createUntypedRefObjectCase() {
    const name = untypedRefObjectCaseName;
    final ref = createRef();
    return RefTestCase(
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue), reason: _reasonMessage(name)),
      getCurrent: () => ref.current,
      meta: RefTestCaseMeta(name, RefKind.object, isJs: false, isStronglyTyped: false),
    );
  }

  static const refObjectCaseName = 'ref object';

  RefTestCase createRefObjectCase() {
    const name = refObjectCaseName;
    final ref = createRef<T>();
    return RefTestCase(
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue), reason: _reasonMessage(name)),
      getCurrent: () => ref.current,
      meta: RefTestCaseMeta(name, RefKind.object, isJs: false, isStronglyTyped: true),
    );
  }

  static const jsCallbackRefCaseName = 'JS callback ref';

  RefTestCase createJsCallbackRefCase() {
    const name = jsCallbackRefCaseName;
    final calls = [];
    return RefTestCase(
      // Use a lambda instead of a tearoff since we want to explicitly verify
      // a function with a certain argument type.
      // ignore: unnecessary_lambdas
      ref: allowInterop((value) => calls.add(value)),
      verifyRefWasUpdated: (actualValue) => expect(calls, [same(actualValue)], reason: _reasonMessage(name)),
      getCurrent: () => calls.single,
      meta: RefTestCaseMeta(name, RefKind.callback, isJs: true, isStronglyTyped: false),
    );
  }

  static const jsRefObjectCaseName = 'JS ref object';

  RefTestCase createJsRefObjectCase() {
    const name = jsRefObjectCaseName;
    final ref = React.createRef();
    return RefTestCase(
      ref: ref,
      verifyRefWasUpdated: (actualValue) => expect(ref.current, same(actualValue), reason: _reasonMessage(name)),
      getCurrent: () => ref.current,
      meta: RefTestCaseMeta(name, RefKind.object, isJs: true, isStronglyTyped: false),
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
        createUntypedRefObjectCase(),
        createRefObjectCase(),
        if (includeJsCallbackRefCase) createJsCallbackRefCase(),
        createJsRefObjectCase(),
      ];

  RefTestCase createCaseByName(String name) => createAllCases().singleWhere((c) => c.meta.name == name);

  RefTestCaseMeta testCaseMetaByName(String name) => createCaseByName(name).meta;

  List<String> get allTestCaseNames => allTestCaseMetas.map((m) => m.name).toList();

  List<RefTestCaseMeta> get allTestCaseMetas => createAllCases().map((c) => c.meta).toList();
}

class RefTestCaseMeta {
  final String name;

  final RefKind kind;

  /// Whether the ref is a non-Dart object, such as a ref originating from outside of Dart code
  /// or a JS-converted Dart ref.
  final bool isJs;

  final bool isStronglyTyped;

  const RefTestCaseMeta(this.name, this.kind, {this.isJs = false, this.isStronglyTyped = false});

  @override
  String toString() => '$name ($kind, isJs: $isJs, isStronglyTyped: $isStronglyTyped)';
}

enum RefKind {
  object,
  callback,
}

extension RefKindBooleans on RefKind {
  bool get isObject => this == RefKind.object;

  bool get isCallback => this == RefKind.callback;
}

final throwsNonNullableCallbackRefAssertionError = throwsA(
    isA<AssertionError>().having((e) => e.message, 'message', allOf(contains(nonNullableCallbackRefArgMessage))));

void nonNullableCallbackRef(Object ref) {}
