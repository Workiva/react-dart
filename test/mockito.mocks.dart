// Mocks generated by Mockito 5.4.2 from annotations
// in react/test/mockito.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:html' as _i2;
import 'dart:math' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:react/src/react_client/synthetic_event_wrappers.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeElement_0 extends _i1.SmartFake implements _i2.Element {
  _FakeElement_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePoint_1<T extends num> extends _i1.SmartFake
    implements _i3.Point<T> {
  _FakePoint_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDataTransfer_2 extends _i1.SmartFake implements _i2.DataTransfer {
  _FakeDataTransfer_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [KeyboardEvent].
///
/// See the documentation for Mockito's code generation for more information.
class MockKeyboardEvent extends _i1.Mock implements _i2.KeyboardEvent {
  @override
  int get keyCode => (super.noSuchMethod(
        Invocation.getter(#keyCode),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  int get charCode => (super.noSuchMethod(
        Invocation.getter(#charCode),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  bool get altKey => (super.noSuchMethod(
        Invocation.getter(#altKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get ctrlKey => (super.noSuchMethod(
        Invocation.getter(#ctrlKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  int get location => (super.noSuchMethod(
        Invocation.getter(#location),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  bool get metaKey => (super.noSuchMethod(
        Invocation.getter(#metaKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get shiftKey => (super.noSuchMethod(
        Invocation.getter(#shiftKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.Element get matchingTarget => (super.noSuchMethod(
        Invocation.getter(#matchingTarget),
        returnValue: _FakeElement_0(
          this,
          Invocation.getter(#matchingTarget),
        ),
        returnValueForMissingStub: _FakeElement_0(
          this,
          Invocation.getter(#matchingTarget),
        ),
      ) as _i2.Element);

  @override
  List<_i2.EventTarget> get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: <_i2.EventTarget>[],
        returnValueForMissingStub: <_i2.EventTarget>[],
      ) as List<_i2.EventTarget>);

  @override
  bool get defaultPrevented => (super.noSuchMethod(
        Invocation.getter(#defaultPrevented),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  int get eventPhase => (super.noSuchMethod(
        Invocation.getter(#eventPhase),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  String get type => (super.noSuchMethod(
        Invocation.getter(#type),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  bool getModifierState(String? keyArg) => (super.noSuchMethod(
        Invocation.method(
          #getModifierState,
          [keyArg],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  List<_i2.EventTarget> composedPath() => (super.noSuchMethod(
        Invocation.method(
          #composedPath,
          [],
        ),
        returnValue: <_i2.EventTarget>[],
        returnValueForMissingStub: <_i2.EventTarget>[],
      ) as List<_i2.EventTarget>);

  @override
  void preventDefault() => super.noSuchMethod(
        Invocation.method(
          #preventDefault,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void stopImmediatePropagation() => super.noSuchMethod(
        Invocation.method(
          #stopImmediatePropagation,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void stopPropagation() => super.noSuchMethod(
        Invocation.method(
          #stopPropagation,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [DataTransfer].
///
/// See the documentation for Mockito's code generation for more information.
class MockDataTransfer extends _i1.Mock implements _i2.DataTransfer {
  @override
  set dropEffect(String? value) => super.noSuchMethod(
        Invocation.setter(
          #dropEffect,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set effectAllowed(String? value) => super.noSuchMethod(
        Invocation.setter(
          #effectAllowed,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearData([String? format]) => super.noSuchMethod(
        Invocation.method(
          #clearData,
          [format],
        ),
        returnValueForMissingStub: null,
      );

  @override
  String getData(String? format) => (super.noSuchMethod(
        Invocation.method(
          #getData,
          [format],
        ),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  void setData(
    String? format,
    String? data,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setData,
          [
            format,
            data,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setDragImage(
    _i2.Element? image,
    int? x,
    int? y,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setDragImage,
          [
            image,
            x,
            y,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [MouseEvent].
///
/// See the documentation for Mockito's code generation for more information.
class MockMouseEvent extends _i1.Mock implements _i2.MouseEvent {
  @override
  bool get altKey => (super.noSuchMethod(
        Invocation.getter(#altKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  int get button => (super.noSuchMethod(
        Invocation.getter(#button),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  bool get ctrlKey => (super.noSuchMethod(
        Invocation.getter(#ctrlKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get metaKey => (super.noSuchMethod(
        Invocation.getter(#metaKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get shiftKey => (super.noSuchMethod(
        Invocation.getter(#shiftKey),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i3.Point<num> get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#client),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#client),
        ),
      ) as _i3.Point<num>);

  @override
  _i3.Point<num> get movement => (super.noSuchMethod(
        Invocation.getter(#movement),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#movement),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#movement),
        ),
      ) as _i3.Point<num>);

  @override
  _i3.Point<num> get offset => (super.noSuchMethod(
        Invocation.getter(#offset),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#offset),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#offset),
        ),
      ) as _i3.Point<num>);

  @override
  _i3.Point<num> get screen => (super.noSuchMethod(
        Invocation.getter(#screen),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#screen),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#screen),
        ),
      ) as _i3.Point<num>);

  @override
  _i3.Point<num> get layer => (super.noSuchMethod(
        Invocation.getter(#layer),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#layer),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#layer),
        ),
      ) as _i3.Point<num>);

  @override
  _i3.Point<num> get page => (super.noSuchMethod(
        Invocation.getter(#page),
        returnValue: _FakePoint_1<num>(
          this,
          Invocation.getter(#page),
        ),
        returnValueForMissingStub: _FakePoint_1<num>(
          this,
          Invocation.getter(#page),
        ),
      ) as _i3.Point<num>);

  @override
  _i2.DataTransfer get dataTransfer => (super.noSuchMethod(
        Invocation.getter(#dataTransfer),
        returnValue: _FakeDataTransfer_2(
          this,
          Invocation.getter(#dataTransfer),
        ),
        returnValueForMissingStub: _FakeDataTransfer_2(
          this,
          Invocation.getter(#dataTransfer),
        ),
      ) as _i2.DataTransfer);

  @override
  _i2.Element get matchingTarget => (super.noSuchMethod(
        Invocation.getter(#matchingTarget),
        returnValue: _FakeElement_0(
          this,
          Invocation.getter(#matchingTarget),
        ),
        returnValueForMissingStub: _FakeElement_0(
          this,
          Invocation.getter(#matchingTarget),
        ),
      ) as _i2.Element);

  @override
  List<_i2.EventTarget> get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: <_i2.EventTarget>[],
        returnValueForMissingStub: <_i2.EventTarget>[],
      ) as List<_i2.EventTarget>);

  @override
  bool get defaultPrevented => (super.noSuchMethod(
        Invocation.getter(#defaultPrevented),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  int get eventPhase => (super.noSuchMethod(
        Invocation.getter(#eventPhase),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  String get type => (super.noSuchMethod(
        Invocation.getter(#type),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  bool getModifierState(String? keyArg) => (super.noSuchMethod(
        Invocation.method(
          #getModifierState,
          [keyArg],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  List<_i2.EventTarget> composedPath() => (super.noSuchMethod(
        Invocation.method(
          #composedPath,
          [],
        ),
        returnValue: <_i2.EventTarget>[],
        returnValueForMissingStub: <_i2.EventTarget>[],
      ) as List<_i2.EventTarget>);

  @override
  void preventDefault() => super.noSuchMethod(
        Invocation.method(
          #preventDefault,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void stopImmediatePropagation() => super.noSuchMethod(
        Invocation.method(
          #stopImmediatePropagation,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void stopPropagation() => super.noSuchMethod(
        Invocation.method(
          #stopPropagation,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SyntheticEvent].
///
/// See the documentation for Mockito's code generation for more information.
class MockSyntheticEvent extends _i1.Mock implements _i4.SyntheticEvent {
  @override
  bool get bubbles => (super.noSuchMethod(
        Invocation.getter(#bubbles),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get cancelable => (super.noSuchMethod(
        Invocation.getter(#cancelable),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get defaultPrevented => (super.noSuchMethod(
        Invocation.getter(#defaultPrevented),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  num get eventPhase => (super.noSuchMethod(
        Invocation.getter(#eventPhase),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as num);

  @override
  bool get isTrusted => (super.noSuchMethod(
        Invocation.getter(#isTrusted),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  num get timeStamp => (super.noSuchMethod(
        Invocation.getter(#timeStamp),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as num);

  @override
  String get type => (super.noSuchMethod(
        Invocation.getter(#type),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  void preventDefault() => super.noSuchMethod(
        Invocation.method(
          #preventDefault,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
