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
SyntheticEvent buildSyntheticEvent({SyntheticEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
  );
}

SyntheticClipboardEvent buildClipboardEvent({SyntheticClipboardEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticClipboardEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['clipboardData'] ?? baseEvent?.clipboardData,
  );
}

SyntheticKeyboardEvent buildKeyboardEvent({SyntheticKeyboardEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticKeyboardEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['altKey'] ?? baseEvent?.altKey,
    properties['char'] ?? baseEvent?.char,
    properties['ctrlKey'] ?? baseEvent?.ctrlKey,
    properties['locale'] ?? baseEvent?.locale,
    properties['location'] ?? baseEvent?.location,
    properties['key'] ?? baseEvent?.key,
    properties['metaKey'] ?? baseEvent?.metaKey,
    properties['repeat'] ?? baseEvent?.repeat,
    properties['shiftKey'] ?? baseEvent?.shiftKey,
    properties['keyCode'] ?? baseEvent?.keyCode,
    properties['charCode'] ?? baseEvent?.charCode,
  );
}

SyntheticCompositionEvent buildCompositionEvent({SyntheticCompositionEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticCompositionEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['data'] ?? baseEvent?.data,
  );
}

SyntheticFocusEvent buildFocusEvent({SyntheticFocusEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticFocusEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['relatedTarget'] ?? baseEvent?.relatedTarget,
  );
}

SyntheticFormEvent buildFormEvent({SyntheticFormEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticFormEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
  );
}

SyntheticMouseEvent buildMouseEvent({SyntheticMouseEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticMouseEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['altKey'] ?? baseEvent?.altKey,
    properties['button'] ?? baseEvent?.button,
    properties['buttons'] ?? baseEvent?.buttons,
    properties['clientX'] ?? baseEvent?.clientX,
    properties['clientY'] ?? baseEvent?.clientY,
    properties['ctrlKey'] ?? baseEvent?.ctrlKey,
    properties['dataTransfer'] ?? baseEvent?.dataTransfer,
    properties['metaKey'] ?? baseEvent?.metaKey,
    properties['pageX'] ?? baseEvent?.pageX,
    properties['pageY'] ?? baseEvent?.pageY,
    properties['relatedTarget'] ?? baseEvent?.relatedTarget,
    properties['screenX'] ?? baseEvent?.screenX,
    properties['screenY'] ?? baseEvent?.screenY,
    properties['shiftKey'] ?? baseEvent?.shiftKey,
  );
}

SyntheticPointerEvent buildPointerEvent({SyntheticPointerEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticPointerEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['pointerId'] ?? baseEvent?.pointerId,
    properties['width'] ?? baseEvent?.width,
    properties['height'] ?? baseEvent?.height,
    properties['pressure'] ?? baseEvent?.pressure,
    properties['tangentialPressure'] ?? baseEvent?.tangentialPressure,
    properties['tiltX'] ?? baseEvent?.tiltX,
    properties['tiltY'] ?? baseEvent?.tiltY,
    properties['twist'] ?? baseEvent?.twist,
    properties['pointerType'] ?? baseEvent?.pointerType,
    properties['isPrimary'] ?? baseEvent?.isPrimary,
  );
}

SyntheticTouchEvent buildTouchEvent({SyntheticTouchEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticTouchEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['altKey'] ?? baseEvent?.altKey,
    properties['changedTouches'] ?? baseEvent?.changedTouches,
    properties['ctrlKey'] ?? baseEvent?.ctrlKey,
    properties['metaKey'] ?? baseEvent?.metaKey,
    properties['shiftKey'] ?? baseEvent?.shiftKey,
    properties['targetTouches'] ?? baseEvent?.targetTouches,
    properties['touches'] ?? baseEvent?.touches,
  );
}

SyntheticTransitionEvent buildTransitionEvent({SyntheticTransitionEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticTransitionEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['propertyName'] ?? baseEvent?.propertyName,
    properties['elapsedTime'] ?? baseEvent?.elapsedTime,
    properties['pseudoElement'] ?? baseEvent?.pseudoElement,
  );
}

SyntheticAnimationEvent buildAnimationEvent({SyntheticAnimationEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticAnimationEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['animationName'] ?? baseEvent?.animationName,
    properties['elapsedTime'] ?? baseEvent?.elapsedTime,
    properties['pseudoElement'] ?? baseEvent?.pseudoElement,
  );
}

SyntheticUIEvent buildUIEvent({SyntheticUIEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticUIEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['detail'] ?? baseEvent?.detail,
    properties['view'] ?? baseEvent?.view,
  );
}

SyntheticWheelEvent buildWheelEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> properties = const {}}) {
  return SyntheticWheelEvent(
    properties['bubbles'] ?? baseEvent?.bubbles,
    properties['cancelable'] ?? baseEvent?.cancelable,
    properties['currentTarget'] ?? baseEvent?.currentTarget,
    properties['defaultPrevented'] ?? baseEvent?.defaultPrevented,
    properties['preventDefault'] ?? baseEvent?.preventDefault ?? () {},
    properties['stopPropagation'] ?? baseEvent?.stopPropagation ?? () {},
    properties['eventPhase'] ?? baseEvent?.eventPhase,
    properties['isTrusted'] ?? baseEvent?.isTrusted,
    properties['nativeEvent'] ?? baseEvent?.nativeEvent,
    properties['target'] ?? baseEvent?.target,
    properties['timeStamp'] ?? baseEvent?.timeStamp ?? 0,
    properties['type'] ?? baseEvent?.type ?? 'empty event',
    properties['deltaX'] ?? baseEvent?.deltaX,
    properties['deltaMode'] ?? baseEvent?.deltaMode,
    properties['deltaY'] ?? baseEvent?.deltaY,
    properties['deltaZ'] ?? baseEvent?.deltaZ,
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
