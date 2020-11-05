// ignore_for_file: deprecated_member_use_from_same_package

import '../../react.dart';

SyntheticEvent getEmptySyntheticEvent() => _SyntheticEventHelper.getEmptyEvent();
SyntheticClipboardEvent getEmptyClipboardEvent() => _SyntheticEventHelper.getEmptyClipboardEvent();
SyntheticKeyboardEvent getEmptyKeyboardEvent() => _SyntheticEventHelper.getEmptyKeyboardEvent();
SyntheticCompositionEvent getEmptyCompositionEvent() => _SyntheticEventHelper.getEmptyCompositionEvent();
SyntheticFocusEvent getEmptyFocusEvent() => _SyntheticEventHelper.getEmptyFocusEvent();
SyntheticFormEvent getEmptyFormEvent() => _SyntheticEventHelper.getEmptyFormEvent();
SyntheticMouseEvent getEmptyMouseEvent() => _SyntheticEventHelper.getEmptyMouseEvent();
SyntheticPointerEvent getEmptyPointerEvent() => _SyntheticEventHelper.getEmptyPointerEvent();
SyntheticTouchEvent getEmptyTouchEvent() => _SyntheticEventHelper.getEmptyTouchEvent();
SyntheticAnimationEvent getEmptyAnimationEvent() => _SyntheticEventHelper.getEmptyAnimationEvent();
SyntheticUIEvent getEmptyUIEvent() => _SyntheticEventHelper.getEmptyUIEvent();
SyntheticWheelEvent getEmptyWheelEvent() => _SyntheticEventHelper.getEmptyWheelEvent();

SyntheticEvent buildSyntheticEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildEvent(baseEvent, newEventProperties);
SyntheticClipboardEvent buildClipboardEvent({SyntheticClipboardEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildClipboardEvent(baseEvent, newEventProperties);
SyntheticKeyboardEvent buildKeyboardEvent({SyntheticKeyboardEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildKeyboardEvent(baseEvent, newEventProperties);
SyntheticCompositionEvent buildCompositionEvent({SyntheticCompositionEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildCompositionEvent(baseEvent, newEventProperties);
SyntheticFocusEvent buildFocusEvent({SyntheticFocusEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildFocusEvent(baseEvent, newEventProperties);
SyntheticFormEvent buildFormEvent({SyntheticFormEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildFormEvent(baseEvent, newEventProperties);
SyntheticMouseEvent buildMouseEvent({SyntheticMouseEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildMouseEvent(baseEvent, newEventProperties);
SyntheticPointerEvent buildPointerEvent({SyntheticPointerEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildPointerEvent(baseEvent, newEventProperties);
SyntheticTouchEvent buildTouchEvent({SyntheticTouchEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildTouchEvent(baseEvent, newEventProperties);
SyntheticAnimationEvent buildAnimationEvent({SyntheticAnimationEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildAnimationEvent(baseEvent, newEventProperties);
SyntheticUIEvent buildUIEvent({SyntheticUIEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildUIEvent(baseEvent, newEventProperties);
SyntheticWheelEvent buildWheelEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> newEventProperties}) => _SyntheticEventHelper.buildWheelEvent(baseEvent, newEventProperties);

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

class _SyntheticEventHelper {
  static SyntheticEvent getEmptyEvent() => SyntheticEvent(null, null, null, null, () {}, () {}, null, null, null, null, 0, 'empty event');
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

  static SyntheticEvent buildEvent(SyntheticEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
    );
  }

  static SyntheticClipboardEvent buildClipboardEvent(SyntheticClipboardEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticClipboardEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['clipboardData'] ?? event?.clipboardData,
    );
  }

  static SyntheticKeyboardEvent buildKeyboardEvent(SyntheticKeyboardEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticKeyboardEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['altKey'] ?? event?.altKey,
      newEventFields['char'] ?? event?.char,
      newEventFields['ctrlKey'] ?? event?.ctrlKey,
      newEventFields['locale'] ?? event?.locale,
      newEventFields['location'] ?? event?.location,
      newEventFields['key'] ?? event?.key,
      newEventFields['metaKey'] ?? event?.metaKey,
      newEventFields['repeat'] ?? event?.repeat,
      newEventFields['shiftKey'] ?? event?.shiftKey,
      newEventFields['keyCode'] ?? event?.keyCode,
      newEventFields['charCode'] ?? event?.charCode,
    );
  }

  static SyntheticCompositionEvent buildCompositionEvent(SyntheticCompositionEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticCompositionEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['data'] ?? event?.data,
    );
  }

  static SyntheticFocusEvent buildFocusEvent(SyntheticFocusEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticFocusEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['relatedTarget'] ?? event?.relatedTarget,
    );
  }

  static SyntheticFormEvent buildFormEvent(SyntheticFormEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticFormEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
    );
  }

  static SyntheticMouseEvent buildMouseEvent(SyntheticMouseEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticMouseEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['altKey'] ?? event?.altKey,
      newEventFields['button'] ?? event?.button,
      newEventFields['buttons'] ?? event?.buttons,
      newEventFields['clientX'] ?? event?.clientX,
      newEventFields['clientY'] ?? event?.clientY,
      newEventFields['ctrlKey'] ?? event?.ctrlKey,
      newEventFields['dataTransfer'] ?? event?.dataTransfer,
      newEventFields['metaKey'] ?? event?.metaKey,
      newEventFields['pageX'] ?? event?.pageX,
      newEventFields['pageY'] ?? event?.pageY,
      newEventFields['relatedTarget'] ?? event?.relatedTarget,
      newEventFields['screenX'] ?? event?.screenX,
      newEventFields['screenY'] ?? event?.screenY,
      newEventFields['shiftKey'] ?? event?.shiftKey,
    );
  }

  static SyntheticPointerEvent buildPointerEvent(SyntheticPointerEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticPointerEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['pointerId'] ?? event?.pointerId,
      newEventFields['width'] ?? event?.width,
      newEventFields['height'] ?? event?.height,
      newEventFields['pressure'] ?? event?.pressure,
      newEventFields['tangentialPressure'] ?? event?.tangentialPressure,
      newEventFields['tiltX'] ?? event?.tiltX,
      newEventFields['tiltY'] ?? event?.tiltY,
      newEventFields['twist'] ?? event?.twist,
      newEventFields['pointerType'] ?? event?.pointerType,
      newEventFields['isPrimary'] ?? event?.isPrimary,
    );
  }

  static SyntheticTouchEvent buildTouchEvent(SyntheticTouchEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticTouchEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['altKey'] ?? event?.altKey,
      newEventFields['changedTouches'] ?? event?.changedTouches,
      newEventFields['ctrlKey'] ?? event?.ctrlKey,
      newEventFields['metaKey'] ?? event?.metaKey,
      newEventFields['shiftKey'] ?? event?.shiftKey,
      newEventFields['targetTouches'] ?? event?.targetTouches,
      newEventFields['touches'] ?? event?.touches,
    );
  }

  static SyntheticTransitionEvent buildTransitionEvent(SyntheticTransitionEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticTransitionEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['propertyName'] ?? event?.propertyName,
      newEventFields['elapsedTime'] ?? event?.elapsedTime,
      newEventFields['pseudoElement'] ?? event?.pseudoElement,
    );
  }

  static SyntheticAnimationEvent buildAnimationEvent(SyntheticAnimationEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticAnimationEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['animationName'] ?? event?.animationName,
      newEventFields['elapsedTime'] ?? event?.elapsedTime,
      newEventFields['pseudoElement'] ?? event?.pseudoElement,
    );
  }

  static SyntheticUIEvent buildUIEvent(SyntheticUIEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticUIEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['detail'] ?? event?.detail,
      newEventFields['view'] ?? event?.view,
    );
  }

  static SyntheticWheelEvent buildWheelEvent(SyntheticWheelEvent event, Map<String, dynamic> newEventFields) {
    return SyntheticWheelEvent(
      newEventFields['bubbles'] ?? event?.bubbles,
      newEventFields['cancelable'] ?? event?.cancelable,
      newEventFields['currentTarget'] ?? event?.currentTarget,
      newEventFields['defaultPrevented'] ?? event?.defaultPrevented,
      newEventFields['preventDefault'] ?? event?.preventDefault,
      newEventFields['stopPropagation'] ?? event?.stopPropagation,
      newEventFields['eventPhase'] ?? event?.eventPhase,
      newEventFields['isTrusted'] ?? event?.isTrusted,
      newEventFields['nativeEvent'] ?? event?.nativeEvent,
      newEventFields['target'] ?? event?.target,
      newEventFields['timeStamp'] ?? event?.timeStamp,
      newEventFields['type'] ?? event?.type,
      newEventFields['deltaX'] ?? event?.deltaX,
      newEventFields['deltaMode'] ?? event?.deltaMode,
      newEventFields['deltaY'] ?? event?.deltaY,
      newEventFields['deltaZ'] ?? event?.deltaZ,
    );
  }
}

// A temporary measure that will be removed when Duck typing is added
// in the React 17 release branch.
extension <T> on T {
  S tryCast<S extends T>() => this is S ? this : null;
}
