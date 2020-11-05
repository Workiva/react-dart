// ignore_for_file: deprecated_member_use_from_same_package

import '../../react.dart';

/// Returns an empty [SyntheticEvent] with all fields set to `null`.
///
/// This utility can be useful when a test just needs access to an event object,
/// but no fields need to be set.
SyntheticEvent getEmptySyntheticEvent() => buildSyntheticEvent();
SyntheticClipboardEvent getEmptyClipboardEvent() => buildClipboardEvent();
SyntheticKeyboardEvent getEmptyKeyboardEvent() => buildKeyboardEvent();
SyntheticCompositionEvent getEmptyCompositionEvent() => buildCompositionEvent();
SyntheticFocusEvent getEmptyFocusEvent() => buildFocusEvent();
SyntheticFormEvent getEmptyFormEvent() => buildFormEvent();
SyntheticMouseEvent getEmptyMouseEvent() => buildMouseEvent();
SyntheticPointerEvent getEmptyPointerEvent() => buildPointerEvent();
SyntheticTouchEvent getEmptyTouchEvent() => buildTouchEvent();
SyntheticAnimationEvent getEmptyAnimationEvent() => buildAnimationEvent();
SyntheticUIEvent getEmptyUIEvent() => buildUIEvent();
SyntheticWheelEvent getEmptyWheelEvent() => buildWheelEvent();

/// Returns a newly constructed [SyntheticEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using [properties], this method will merge previously existing [baseEvent]s with the [properties] provided.
/// [properties] takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticEvent buildSyntheticEvent({SyntheticEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
  );
}

SyntheticClipboardEvent buildClipboardEvent({SyntheticClipboardEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticClipboardEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['clipboardData'] ?? baseEvent.clipboardData,
  );
}

SyntheticKeyboardEvent buildKeyboardEvent({SyntheticKeyboardEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticKeyboardEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['altKey'] ?? baseEvent.altKey,
    eventProperties['char'] ?? baseEvent.char,
    eventProperties['ctrlKey'] ?? baseEvent.ctrlKey,
    eventProperties['locale'] ?? baseEvent.locale,
    eventProperties['location'] ?? baseEvent.location,
    eventProperties['key'] ?? baseEvent.key,
    eventProperties['metaKey'] ?? baseEvent.metaKey,
    eventProperties['repeat'] ?? baseEvent.repeat,
    eventProperties['shiftKey'] ?? baseEvent.shiftKey,
    eventProperties['keyCode'] ?? baseEvent.keyCode,
    eventProperties['charCode'] ?? baseEvent.charCode,
  );
}

SyntheticCompositionEvent buildCompositionEvent({SyntheticCompositionEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticCompositionEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['data'] ?? baseEvent.data,
  );
}

SyntheticFocusEvent buildFocusEvent({SyntheticFocusEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticFocusEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['relatedTarget'] ?? baseEvent.relatedTarget,
  );
}

SyntheticFormEvent buildFormEvent({SyntheticFormEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticFormEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
  );
}

SyntheticMouseEvent buildMouseEvent({SyntheticMouseEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticMouseEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['altKey'] ?? baseEvent.altKey,
    eventProperties['button'] ?? baseEvent.button,
    eventProperties['buttons'] ?? baseEvent.buttons,
    eventProperties['clientX'] ?? baseEvent.clientX,
    eventProperties['clientY'] ?? baseEvent.clientY,
    eventProperties['ctrlKey'] ?? baseEvent.ctrlKey,
    eventProperties['dataTransfer'] ?? baseEvent.dataTransfer,
    eventProperties['metaKey'] ?? baseEvent.metaKey,
    eventProperties['pageX'] ?? baseEvent.pageX,
    eventProperties['pageY'] ?? baseEvent.pageY,
    eventProperties['relatedTarget'] ?? baseEvent.relatedTarget,
    eventProperties['screenX'] ?? baseEvent.screenX,
    eventProperties['screenY'] ?? baseEvent.screenY,
    eventProperties['shiftKey'] ?? baseEvent.shiftKey,
  );
}

SyntheticPointerEvent buildPointerEvent({SyntheticPointerEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticPointerEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['pointerId'] ?? baseEvent.pointerId,
    eventProperties['width'] ?? baseEvent.width,
    eventProperties['height'] ?? baseEvent.height,
    eventProperties['pressure'] ?? baseEvent.pressure,
    eventProperties['tangentialPressure'] ?? baseEvent.tangentialPressure,
    eventProperties['tiltX'] ?? baseEvent.tiltX,
    eventProperties['tiltY'] ?? baseEvent.tiltY,
    eventProperties['twist'] ?? baseEvent.twist,
    eventProperties['pointerType'] ?? baseEvent.pointerType,
    eventProperties['isPrimary'] ?? baseEvent.isPrimary,
  );
}

SyntheticTouchEvent buildTouchEvent({SyntheticTouchEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticTouchEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['altKey'] ?? baseEvent.altKey,
    eventProperties['changedTouches'] ?? baseEvent.changedTouches,
    eventProperties['ctrlKey'] ?? baseEvent.ctrlKey,
    eventProperties['metaKey'] ?? baseEvent.metaKey,
    eventProperties['shiftKey'] ?? baseEvent.shiftKey,
    eventProperties['targetTouches'] ?? baseEvent.targetTouches,
    eventProperties['touches'] ?? baseEvent.touches,
  );
}

SyntheticTransitionEvent buildTransitionEvent({SyntheticTransitionEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticTransitionEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['propertyName'] ?? baseEvent.propertyName,
    eventProperties['elapsedTime'] ?? baseEvent.elapsedTime,
    eventProperties['pseudoElement'] ?? baseEvent.pseudoElement,
  );
}

SyntheticAnimationEvent buildAnimationEvent({SyntheticAnimationEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticAnimationEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['animationName'] ?? baseEvent.animationName,
    eventProperties['elapsedTime'] ?? baseEvent.elapsedTime,
    eventProperties['pseudoElement'] ?? baseEvent.pseudoElement,
  );
}

SyntheticUIEvent buildUIEvent({SyntheticUIEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticUIEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['detail'] ?? baseEvent.detail,
    eventProperties['view'] ?? baseEvent.view,
  );
}

SyntheticWheelEvent buildWheelEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> eventProperties}) {
  return SyntheticWheelEvent(
    eventProperties['bubbles'] ?? baseEvent.bubbles,
    eventProperties['cancelable'] ?? baseEvent.cancelable,
    eventProperties['currentTarget'] ?? baseEvent.currentTarget,
    eventProperties['defaultPrevented'] ?? baseEvent.defaultPrevented,
    eventProperties['preventDefault'] ?? baseEvent.preventDefault ?? () {},
    eventProperties['stopPropagation'] ?? baseEvent.stopPropagation ?? () {},
    eventProperties['eventPhase'] ?? baseEvent.eventPhase,
    eventProperties['isTrusted'] ?? baseEvent.isTrusted,
    eventProperties['nativeEvent'] ?? baseEvent.nativeEvent,
    eventProperties['target'] ?? baseEvent.target,
    eventProperties['timeStamp'] ?? baseEvent.timeStamp ?? 0,
    eventProperties['type'] ?? baseEvent.type ?? 'empty event',
    eventProperties['deltaX'] ?? baseEvent.deltaX,
    eventProperties['deltaMode'] ?? baseEvent.deltaMode,
    eventProperties['deltaY'] ?? baseEvent.deltaY,
    eventProperties['deltaZ'] ?? baseEvent.deltaZ,
  );
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

// A temporary measure that will be removed when Duck typing is added
// in the React 17 release branch.
extension <T> on T {
  S tryCast<S extends T>() => this is S ? this : null;
}
