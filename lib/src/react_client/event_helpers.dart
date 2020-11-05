import '../../react.dart';

enum EventType {
  SyntheticEvent,
  SyntheticClipboardEvent,
  SyntheticKeyboardEvent,
  SyntheticCompositionEvent,
  SyntheticFocusEvent,
  SyntheticFormEvent,
  SyntheticMouseEvent,
  SyntheticPointerEvent,
  SyntheticTouchEvent,
  SyntheticTransitionEvent,
  SyntheticAnimationEvent,
  SyntheticUIEvent,
  SyntheticWheelEvent,
}


SyntheticEvent getEmptyEventOfType(EventType type) {
  switch(type) {
    case EventType.SyntheticEvent:
      return SyntheticEventHelper.getEmptyEvent();
    case EventType.SyntheticClipboardEvent:
      return SyntheticEventHelper.getEmptyClipboardEvent();
    case EventType.SyntheticKeyboardEvent:
      return SyntheticEventHelper.getEmptyKeyboardEvent();
    case EventType.SyntheticCompositionEvent:
      return SyntheticEventHelper.getEmptyCompositionEvent();
    case EventType.SyntheticFocusEvent:
      return SyntheticEventHelper.getEmptyFocusEvent();
    case EventType.SyntheticFormEvent:
      return SyntheticEventHelper.getEmptyFormEvent();
    case EventType.SyntheticMouseEvent:
      return SyntheticEventHelper.getEmptyMouseEvent();
    case EventType.SyntheticPointerEvent:
      return SyntheticEventHelper.getEmptyPointerEvent();
    case EventType.SyntheticTouchEvent:
      return SyntheticEventHelper.getEmptyTouchEvent();
    case EventType.SyntheticTransitionEvent:
      return SyntheticEventHelper.getEmptyTransitionEvent();
    case EventType.SyntheticAnimationEvent:
      return SyntheticEventHelper.getEmptyAnimationEvent();
    case EventType.SyntheticUIEvent:
      return SyntheticEventHelper.getEmptyUIEvent();
    case EventType.SyntheticWheelEvent:
      return SyntheticEventHelper.getEmptyWheelEvent();
  }

  return null;
}

extension SyntheticEventTypeHelpers on SyntheticEvent {
  bool get isClipboardEvent => this.tryCast<SyntheticClipboardEvent>() != null;
  bool get isKeyboardEvent => this.tryCast<SyntheticKeyboardEvent>() != null;
  bool get isCompositionEvent => this.tryCast<SyntheticCompositionEvent>() != null;
  bool get isFocusEvent => this.tryCast<SyntheticFocusEvent>() != null;
  bool get isFormEvent => this.tryCast<SyntheticFormEvent>() != null;
  bool get isMouseEvent => this.tryCast<SyntheticMouseEvent>() != null;
  bool get isPointerEvent => this.tryCast<SyntheticPointerEvent>() != null;
  bool get isTouchEvent => this.tryCast<SyntheticTouchEvent>() != null;
  bool get isTransitionEvent => this.tryCast<SyntheticTransitionEvent>() != null;
  bool get isAnimationEvent => this.tryCast<SyntheticAnimationEvent>() != null;
  bool get isUiEvent => this.tryCast<SyntheticUIEvent>() != null;
  bool get isWheelEvent => this.tryCast<SyntheticWheelEvent>() != null;
}


class SyntheticEventHelper {
  static SyntheticEvent getEmptyEvent() => SyntheticEvent(null, null, null, null, null, () {}, null, null, null, null, 0, 'empty event');
  static SyntheticClipboardEvent getEmptyClipboardEvent() => SyntheticClipboardEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null);
  static SyntheticKeyboardEvent getEmptyKeyboardEvent() => SyntheticKeyboardEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, null, null, null, null, null, null, null, null, null, null, null, null);
  static SyntheticCompositionEvent getEmptyCompositionEvent() => SyntheticCompositionEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null);
  static SyntheticFocusEvent getEmptyFocusEvent() => SyntheticFocusEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null);
  static SyntheticFormEvent getEmptyFormEvent() => SyntheticFormEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event');
  static SyntheticMouseEvent getEmptyMouseEvent() => SyntheticMouseEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  static SyntheticPointerEvent getEmptyPointerEvent() => SyntheticPointerEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null, null, null, null, null, null, null, null);
  static SyntheticTouchEvent getEmptyTouchEvent() => SyntheticTouchEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null, null, null, null, null);
  static SyntheticTransitionEvent getEmptyTransitionEvent() => SyntheticTransitionEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null);
  static SyntheticAnimationEvent getEmptyAnimationEvent() => SyntheticAnimationEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null);
  static SyntheticUIEvent getEmptyUIEvent() => SyntheticUIEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null);
  static SyntheticWheelEvent getEmptyWheelEvent() => SyntheticWheelEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event', null, null, null, null);





}



// A temporary measure that will be removed when Duck typing is added
// in the React 17 release branch.
extension <T> on T {
  S tryCast<S extends T>() => this is S ? this : null;
}
