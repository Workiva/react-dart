/// JS interop classes for React synthetic events.
///
/// For use in `react_client.dart` and by advanced react-dart users.
@JS()
library react_client.synthetic_event_wrappers;

import 'dart:html';
import 'package:js/js.dart';

@JS()
class SyntheticEvent {
  /// [SyntheticEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticEvent` instead.
  external factory SyntheticEvent._();

  external bool get bubbles;
  external bool get cancelable;
  external get currentTarget;
  external bool get defaultPrevented;
  external num get eventPhase;
  external bool get isTrusted;
  external get nativeEvent;
  external get target;
  external num get timeStamp;
  external String get type;

  external void stopPropagation();
  external void preventDefault();

  external void persist();

  external bool isPersistent();
}

@JS()
class SyntheticClipboardEvent extends SyntheticEvent {
  /// [SyntheticClipboardEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticClipboardEvent` instead.
  external factory SyntheticClipboardEvent._();

  external get clipboardData;
}

@JS()
class SyntheticKeyboardEvent extends SyntheticEvent {
  /// [SyntheticKeyboardEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticKeyboardEvent` instead.
  external factory SyntheticKeyboardEvent._();

  external bool get altKey;
  external String get char;
  external bool get ctrlKey;
  external String get locale;
  external num get location;
  external String get key;
  external bool get metaKey;
  external bool get repeat;
  external bool get shiftKey;
  external num get keyCode;
  external num get charCode;
}

@JS()
class SyntheticCompositionEvent extends SyntheticEvent {
  /// [SyntheticCompositionEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticCompositionEvent` instead.
  external factory SyntheticCompositionEvent._();

  external String get data;
}

@JS()
class SyntheticFocusEvent extends SyntheticEvent {
  /// [SyntheticFocusEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticFocusEvent` instead.
  external factory SyntheticFocusEvent._();

  external EventTarget get relatedTarget;
}

@JS()
class SyntheticFormEvent extends SyntheticEvent {
  /// [SyntheticFormEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticFormEvent` instead.
  external factory SyntheticFormEvent._();
}

/// A JS object that looks like a [DataTransfer] but isn't one.
@JS()
class NonNativeDataTransfer {
  external String get dropEffect;
  external String get effectAllowed;
  external List<File> get files;
  external List<String> get types;
}

@JS()
class SyntheticMouseEvent extends SyntheticEvent {
  /// [SyntheticMouseEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticMouseEvent` instead.
  external factory SyntheticMouseEvent._();

  external bool get altKey;
  external num get button;
  external num get buttons;
  external num get clientX;
  external num get clientY;
  external bool get ctrlKey;
  external NonNativeDataTransfer get dataTransfer;
  external bool get metaKey;
  external num get pageX;
  external num get pageY;
  external EventTarget get relatedTarget;
  external num get screenX;
  external num get screenY;
  external bool get shiftKey;
}

@JS()
class SyntheticPointerEvent extends SyntheticEvent {
  /// [SyntheticPointerEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticPointerEvent` instead.
  external factory SyntheticPointerEvent._();

  external num get pointerId;
  external num get width;
  external num get height;
  external num get pressure;
  external num get tangentialPressure;
  external num get tiltX;
  external num get tiltY;
  external num get twist;
  external String get pointerType;
  external bool get isPrimary;
}

@JS()
class SyntheticTouchEvent extends SyntheticEvent {
  /// [SyntheticTouchEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticTouchEvent` instead.
  external factory SyntheticTouchEvent._();

  external bool get altKey;
  external TouchList get changedTouches;
  external bool get ctrlKey;
  external bool get metaKey;
  external bool get shiftKey;
  external TouchList get targetTouches;
  external TouchList get touches;
}

@JS()
class SyntheticTransitionEvent extends SyntheticEvent {
  /// [SyntheticTransitionEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticTransitionEvent` instead.
  external factory SyntheticTransitionEvent._();

  external String get propertyName;
  external num get elapsedTime;
  external String get pseudoElement;
}

@JS()
class SyntheticAnimationEvent extends SyntheticEvent {
  /// [SyntheticAnimationEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticAnimationEvent` instead.
  external factory SyntheticAnimationEvent._();

  external String get animationName;
  external num get elapsedTime;
  external String get pseudoElement;
}

@JS()
class SyntheticUIEvent extends SyntheticEvent {
  /// [SyntheticUIEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticUIEvent` instead.
  external factory SyntheticUIEvent._();

  external num get detail;
  external get view;
}

@JS()
class SyntheticWheelEvent extends SyntheticEvent {
  /// [SyntheticWheelEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticWheelEvent` instead.
  external factory SyntheticWheelEvent._();

  external num get deltaX;
  external num get deltaMode;
  external num get deltaY;
  external num get deltaZ;
}
