// ignore_for_file: deprecated_member_use_from_same_package

import '../../react.dart';

/// Returns an empty [SyntheticEvent] with all fields set to `null`.
///
/// This utility can be useful when a test just needs access to an event object,
/// but no fields need to be set.
SyntheticEvent getEmptySyntheticEvent() => createSyntheticEvent();
SyntheticClipboardEvent getEmptyClipboardEvent() => createSyntheticClipboardEvent();
SyntheticKeyboardEvent getEmptyKeyboardEvent() => createSyntheticKeyboardEvent();
SyntheticCompositionEvent getEmptyCompositionEvent() => createSyntheticCompositionEvent();
SyntheticFocusEvent getEmptyFocusEvent() => createSyntheticFocusEvent();
SyntheticFormEvent getEmptyFormEvent() => createSyntheticFormEvent();
SyntheticMouseEvent getEmptyMouseEvent() => createSyntheticMouseEvent();
SyntheticPointerEvent getEmptyPointerEvent() => createSyntheticPointerEvent();
SyntheticTouchEvent getEmptyTouchEvent() => createSyntheticTouchEvent();
SyntheticAnimationEvent getEmptyAnimationEvent() => createSyntheticAnimationEvent();
SyntheticUIEvent getEmptyUIEvent() => createSyntheticUIEvent();
SyntheticWheelEvent getEmptyWheelEvent() => createSyntheticWheelEvent();

/// Returns a newly constructed [SyntheticEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using [properties], this method will merge previously existing [baseEvent]s with the [properties] provided.
/// [properties] takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticEvent createSyntheticEvent({
  SyntheticEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
}) {
  return SyntheticEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
  );
}

SyntheticClipboardEvent createSyntheticClipboardEvent({
  SyntheticClipboardEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  dynamic clipboardData,
}) {
  return SyntheticClipboardEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    clipboardData ?? baseEvent?.clipboardData,
  );
}

SyntheticKeyboardEvent createSyntheticKeyboardEvent({
  SyntheticKeyboardEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  bool altKey,
  String char,
  bool ctrlKey,
  String locale,
  num location,
  String key,
  bool metaKey,
  bool repeat,
  bool shiftKey,
  num keyCode,
  num charCode,
}) {
  return SyntheticKeyboardEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey,
    char ?? baseEvent?.char,
    charCode ?? baseEvent?.charCode,
    ctrlKey ?? baseEvent?.ctrlKey,
    locale ?? baseEvent?.locale,
    location ?? baseEvent?.location,
    key ?? baseEvent?.key,
    keyCode ?? baseEvent?.keyCode,
    metaKey ?? baseEvent?.metaKey,
    repeat ?? baseEvent?.repeat,
    shiftKey ?? baseEvent?.shiftKey,
  );
}

SyntheticCompositionEvent createSyntheticCompositionEvent({
  SyntheticCompositionEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  String data,
}) {
  return SyntheticCompositionEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    data ?? baseEvent?.data,
  );
}

SyntheticFocusEvent createSyntheticFocusEvent({
  SyntheticFocusEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  /*DOMEventTarget*/ dynamic relatedTarget,
}) {
  return SyntheticFocusEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    relatedTarget ?? baseEvent?.relatedTarget,
  );
}

SyntheticFormEvent createSyntheticFormEvent({
  SyntheticFormEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
}) {
  return SyntheticFormEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
  );
}

SyntheticMouseEvent createSyntheticMouseEvent({
  SyntheticMouseEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  bool altKey,
  num button,
  num buttons,
  num clientX,
  num clientY,
  bool ctrlKey,
  SyntheticDataTransfer dataTransfer,
  bool metaKey,
  num pageX,
  num pageY,
  /*DOMEventTarget*/ dynamic relatedTarget,
  num screenX,
  num screenY,
  bool shiftKey,
}) {
  return SyntheticMouseEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey,
    button ?? baseEvent?.button,
    buttons ?? baseEvent?.buttons,
    clientX ?? baseEvent?.clientX,
    clientY ?? baseEvent?.clientY,
    ctrlKey ?? baseEvent?.ctrlKey,
    dataTransfer ?? baseEvent?.dataTransfer,
    metaKey ?? baseEvent?.metaKey,
    pageX ?? baseEvent?.pageX,
    pageY ?? baseEvent?.pageY,
    relatedTarget ?? baseEvent?.relatedTarget,
    screenX ?? baseEvent?.screenX,
    screenY ?? baseEvent?.screenY,
    shiftKey ?? baseEvent?.shiftKey,
  );
}

SyntheticPointerEvent createSyntheticPointerEvent({
  SyntheticPointerEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  num pointerId,
  num width,
  num height,
  num pressure,
  num tangentialPressure,
  num tiltX,
  num tiltY,
  num twist,
  String pointerType,
  bool isPrimary,
}) {
  return SyntheticPointerEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    pointerId ?? baseEvent?.pointerId,
    width ?? baseEvent?.width,
    height ?? baseEvent?.height,
    pressure ?? baseEvent?.pressure,
    tangentialPressure ?? baseEvent?.tangentialPressure,
    tiltX ?? baseEvent?.tiltX,
    tiltY ?? baseEvent?.tiltY,
    twist ?? baseEvent?.twist,
    pointerType ?? baseEvent?.pointerType,
    isPrimary ?? baseEvent?.isPrimary,
  );
}

SyntheticTouchEvent createSyntheticTouchEvent({
  SyntheticTouchEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  bool altKey,
  /*DOMTouchList*/ dynamic changedTouches,
  bool ctrlKey,
  bool metaKey,
  bool shiftKey,
  /*DOMTouchList*/ dynamic targetTouches,
  /*DOMTouchList*/ dynamic touches,
}) {
  return SyntheticTouchEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey,
    changedTouches ?? baseEvent?.changedTouches,
    ctrlKey ?? baseEvent?.ctrlKey,
    metaKey ?? baseEvent?.metaKey,
    shiftKey ?? baseEvent?.shiftKey,
    targetTouches ?? baseEvent?.targetTouches,
    touches ?? baseEvent?.touches,
  );
}

SyntheticTransitionEvent createSyntheticTransitionEvent({
  SyntheticTransitionEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  String propertyName,
  num elapsedTime,
  String pseudoElement,
}) {
  return SyntheticTransitionEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    propertyName ?? baseEvent?.propertyName,
    elapsedTime ?? baseEvent?.elapsedTime,
    pseudoElement ?? baseEvent?.pseudoElement,
  );
}

SyntheticAnimationEvent createSyntheticAnimationEvent({
  SyntheticAnimationEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  String animationName,
  num elapsedTime,
  String pseudoElement,
}) {
  return SyntheticAnimationEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    animationName ?? baseEvent?.animationName,
    elapsedTime ?? baseEvent?.elapsedTime,
    pseudoElement ?? baseEvent?.pseudoElement,
  );
}

SyntheticUIEvent createSyntheticUIEvent({
  SyntheticUIEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  num detail,
  /*DOMAbstractView*/ dynamic view,
}) {
  return SyntheticUIEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    detail ?? baseEvent?.detail,
    view ?? baseEvent?.view,
  );
}

SyntheticWheelEvent createSyntheticWheelEvent({
  SyntheticWheelEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  dynamic preventDefault,
  dynamic stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  num deltaX,
  num deltaMode,
  num deltaY,
  num deltaZ,
}) {
  return SyntheticWheelEvent(
    bubbles ?? baseEvent?.bubbles ?? true,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? true,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    deltaX ?? baseEvent?.deltaX,
    deltaMode ?? baseEvent?.deltaMode,
    deltaY ?? baseEvent?.deltaY,
    deltaZ ?? baseEvent?.deltaZ,
  );
}

extension SyntheticEventTypeHelpers on SyntheticEvent {
  bool get isClipboardEvent => this is SyntheticClipboardEvent;
  bool get isKeyboardEvent => this is SyntheticKeyboardEvent;
  bool get isCompositionEvent => this is SyntheticCompositionEvent;
  bool get isFocusEvent => this is SyntheticFocusEvent;
  bool get isFormEvent => this is SyntheticFormEvent;
  bool get isMouseEvent => this is SyntheticMouseEvent;
  bool get isPointerEvent => this is SyntheticPointerEvent;
  bool get isTouchEvent => this is SyntheticTouchEvent;
  bool get isTransitionEvent => this is SyntheticTransitionEvent;
  bool get isAnimationEvent => this is SyntheticAnimationEvent;
  bool get isUiEvent => this is SyntheticUIEvent;
  bool get isWheelEvent => this is SyntheticWheelEvent;
}
