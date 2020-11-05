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
SyntheticEvent buildSyntheticEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildEvent(baseEvent, properties);
SyntheticClipboardEvent buildClipboardEvent({SyntheticClipboardEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildClipboardEvent(baseEvent, properties);
SyntheticKeyboardEvent buildKeyboardEvent({SyntheticKeyboardEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildKeyboardEvent(baseEvent, properties);
SyntheticCompositionEvent buildCompositionEvent({SyntheticCompositionEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildCompositionEvent(baseEvent, properties);
SyntheticFocusEvent buildFocusEvent({SyntheticFocusEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildFocusEvent(baseEvent, properties);
SyntheticFormEvent buildFormEvent({SyntheticFormEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildFormEvent(baseEvent, properties);
SyntheticMouseEvent buildMouseEvent({SyntheticMouseEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildMouseEvent(baseEvent, properties);
SyntheticPointerEvent buildPointerEvent({SyntheticPointerEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildPointerEvent(baseEvent, properties);
SyntheticTouchEvent buildTouchEvent({SyntheticTouchEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildTouchEvent(baseEvent, properties);
SyntheticAnimationEvent buildAnimationEvent({SyntheticAnimationEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildAnimationEvent(baseEvent, properties);
SyntheticUIEvent buildUIEvent({SyntheticUIEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildUIEvent(baseEvent, properties);
SyntheticWheelEvent buildWheelEvent({SyntheticWheelEvent baseEvent, Map<String, dynamic> properties}) => _SyntheticEventHelper.buildWheelEvent(baseEvent, properties);

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

  static SyntheticEvent buildEvent(SyntheticEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
    );
  }

  static SyntheticClipboardEvent buildClipboardEvent(SyntheticClipboardEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticClipboardEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['clipboardData'] ?? event?.clipboardData,
    );
  }

  static SyntheticKeyboardEvent buildKeyboardEvent(SyntheticKeyboardEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticKeyboardEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['altKey'] ?? event?.altKey,
      eventProperties['char'] ?? event?.char,
      eventProperties['ctrlKey'] ?? event?.ctrlKey,
      eventProperties['locale'] ?? event?.locale,
      eventProperties['location'] ?? event?.location,
      eventProperties['key'] ?? event?.key,
      eventProperties['metaKey'] ?? event?.metaKey,
      eventProperties['repeat'] ?? event?.repeat,
      eventProperties['shiftKey'] ?? event?.shiftKey,
      eventProperties['keyCode'] ?? event?.keyCode,
      eventProperties['charCode'] ?? event?.charCode,
    );
  }

  static SyntheticCompositionEvent buildCompositionEvent(SyntheticCompositionEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticCompositionEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['data'] ?? event?.data,
    );
  }

  static SyntheticFocusEvent buildFocusEvent(SyntheticFocusEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticFocusEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['relatedTarget'] ?? event?.relatedTarget,
    );
  }

  static SyntheticFormEvent buildFormEvent(SyntheticFormEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticFormEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
    );
  }

  static SyntheticMouseEvent buildMouseEvent(SyntheticMouseEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticMouseEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['altKey'] ?? event?.altKey,
      eventProperties['button'] ?? event?.button,
      eventProperties['buttons'] ?? event?.buttons,
      eventProperties['clientX'] ?? event?.clientX,
      eventProperties['clientY'] ?? event?.clientY,
      eventProperties['ctrlKey'] ?? event?.ctrlKey,
      eventProperties['dataTransfer'] ?? event?.dataTransfer,
      eventProperties['metaKey'] ?? event?.metaKey,
      eventProperties['pageX'] ?? event?.pageX,
      eventProperties['pageY'] ?? event?.pageY,
      eventProperties['relatedTarget'] ?? event?.relatedTarget,
      eventProperties['screenX'] ?? event?.screenX,
      eventProperties['screenY'] ?? event?.screenY,
      eventProperties['shiftKey'] ?? event?.shiftKey,
    );
  }

  static SyntheticPointerEvent buildPointerEvent(SyntheticPointerEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticPointerEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['pointerId'] ?? event?.pointerId,
      eventProperties['width'] ?? event?.width,
      eventProperties['height'] ?? event?.height,
      eventProperties['pressure'] ?? event?.pressure,
      eventProperties['tangentialPressure'] ?? event?.tangentialPressure,
      eventProperties['tiltX'] ?? event?.tiltX,
      eventProperties['tiltY'] ?? event?.tiltY,
      eventProperties['twist'] ?? event?.twist,
      eventProperties['pointerType'] ?? event?.pointerType,
      eventProperties['isPrimary'] ?? event?.isPrimary,
    );
  }

  static SyntheticTouchEvent buildTouchEvent(SyntheticTouchEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticTouchEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['altKey'] ?? event?.altKey,
      eventProperties['changedTouches'] ?? event?.changedTouches,
      eventProperties['ctrlKey'] ?? event?.ctrlKey,
      eventProperties['metaKey'] ?? event?.metaKey,
      eventProperties['shiftKey'] ?? event?.shiftKey,
      eventProperties['targetTouches'] ?? event?.targetTouches,
      eventProperties['touches'] ?? event?.touches,
    );
  }

  static SyntheticTransitionEvent buildTransitionEvent(SyntheticTransitionEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticTransitionEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['propertyName'] ?? event?.propertyName,
      eventProperties['elapsedTime'] ?? event?.elapsedTime,
      eventProperties['pseudoElement'] ?? event?.pseudoElement,
    );
  }

  static SyntheticAnimationEvent buildAnimationEvent(SyntheticAnimationEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticAnimationEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['animationName'] ?? event?.animationName,
      eventProperties['elapsedTime'] ?? event?.elapsedTime,
      eventProperties['pseudoElement'] ?? event?.pseudoElement,
    );
  }

  static SyntheticUIEvent buildUIEvent(SyntheticUIEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticUIEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['detail'] ?? event?.detail,
      eventProperties['view'] ?? event?.view,
    );
  }

  static SyntheticWheelEvent buildWheelEvent(SyntheticWheelEvent event, Map<String, dynamic> eventProperties) {
    return SyntheticWheelEvent(
      eventProperties['bubbles'] ?? event?.bubbles,
      eventProperties['cancelable'] ?? event?.cancelable,
      eventProperties['currentTarget'] ?? event?.currentTarget,
      eventProperties['defaultPrevented'] ?? event?.defaultPrevented,
      eventProperties['preventDefault'] ?? event?.preventDefault,
      eventProperties['stopPropagation'] ?? event?.stopPropagation,
      eventProperties['eventPhase'] ?? event?.eventPhase,
      eventProperties['isTrusted'] ?? event?.isTrusted,
      eventProperties['nativeEvent'] ?? event?.nativeEvent,
      eventProperties['target'] ?? event?.target,
      eventProperties['timeStamp'] ?? event?.timeStamp,
      eventProperties['type'] ?? event?.type,
      eventProperties['deltaX'] ?? event?.deltaX,
      eventProperties['deltaMode'] ?? event?.deltaMode,
      eventProperties['deltaY'] ?? event?.deltaY,
      eventProperties['deltaZ'] ?? event?.deltaZ,
    );
  }
}

// A temporary measure that will be removed when Duck typing is added
// in the React 17 release branch.
extension <T> on T {
  S tryCast<S extends T>() => this is S ? this : null;
}
