library react_client.event_helpers;

import 'dart:html';

import 'package:react/react.dart';
import 'package:react/react_client/js_interop_helpers.dart';

/// Helper util that wraps a native [KeyboardEvent] in a [SyntheticKeyboardEvent].
///
/// Used where a native [KeyboardEvent] is given and a [SyntheticKeyboardEvent] is needed.
SyntheticKeyboardEvent wrapNativeKeyboardEvent(KeyboardEvent nativeEvent) {
  return jsifyAndAllowInterop({
    // SyntheticEvent fields
    'bubbles': nativeEvent.bubbles,
    'cancelable': nativeEvent.cancelable,
    'currentTarget': nativeEvent.currentTarget,
    'defaultPrevented': nativeEvent.defaultPrevented,
    'eventPhase': nativeEvent.eventPhase,
    'isTrusted': nativeEvent.isTrusted,
    'nativeEvent': nativeEvent,
    'target': nativeEvent.target,
    'timeStamp': nativeEvent.timeStamp,
    'type': nativeEvent.type,
    // SyntheticEvent methods
    'stopPropagation': nativeEvent.stopPropagation,
    'preventDefault': nativeEvent.preventDefault,
    'persist': () {},
    'isPersistent': () => true,
    // SyntheticKeyboardEvent fields
    'altKey': nativeEvent.altKey,
    'char': nativeEvent.charCode == null ? null : String.fromCharCode(nativeEvent.charCode),
    'ctrlKey': nativeEvent.ctrlKey,
    'locale': null,
    'location': nativeEvent.location,
    'key': nativeEvent.key,
    'metaKey': nativeEvent.metaKey,
    'repeat': nativeEvent.repeat,
    'shiftKey': nativeEvent.shiftKey,
    'keyCode': nativeEvent.keyCode,
    'charCode': nativeEvent.charCode,
  }) as SyntheticKeyboardEvent;
}

/// Helper util that wraps a native [MouseEvent] in a [SyntheticMouseEvent].
///
/// Used where a native [MouseEvent] is given and a [SyntheticMouseEvent] is needed.
SyntheticMouseEvent wrapNativeMouseEvent(MouseEvent nativeEvent) {
  return jsifyAndAllowInterop({
    // SyntheticEvent fields
    'bubbles': nativeEvent.bubbles,
    'cancelable': nativeEvent.cancelable,
    'currentTarget': nativeEvent.currentTarget,
    'defaultPrevented': nativeEvent.defaultPrevented,
    'eventPhase': nativeEvent.eventPhase,
    'isTrusted': nativeEvent.isTrusted,
    'nativeEvent': nativeEvent,
    'target': nativeEvent.target,
    'timeStamp': nativeEvent.timeStamp,
    'type': nativeEvent.type,
    // SyntheticEvent methods
    'stopPropagation': nativeEvent.stopPropagation,
    'preventDefault': nativeEvent.preventDefault,
    'persist': () {},
    'isPersistent': () => true,
    // SyntheticMouseEvent fields
    'altKey': nativeEvent.altKey,
    'button': nativeEvent.button,
    'buttons': nativeEvent.buttons,
    'clientX': nativeEvent.client.x,
    'clientY': nativeEvent.client.y,
    'ctrlKey': nativeEvent.ctrlKey,
    'dataTransfer': nativeEvent.dataTransfer,
    'metaKey': nativeEvent.metaKey,
    'pageX': nativeEvent.page.x,
    'pageY': nativeEvent.page.y,
    'relatedTarget': nativeEvent.relatedTarget,
    'screenX': nativeEvent.screen.x,
    'screenY': nativeEvent.screen.y,
    'shiftKey': nativeEvent.shiftKey,
  }) as SyntheticMouseEvent;
}

/// If the consumer specifies a callback like `onChange` on one of our custom form components that are not *actually*
/// form elements - we still need a valid [SyntheticFormEvent] to pass as the expected parameter to that callback.
///
/// This helper method generates a "fake" [SyntheticFormEvent], with nothing but the `target` set to [element],
/// `type` set to [type] and `timeStamp` set to the current time. All other arguments are `noop`, `false` or `null`.
SyntheticFormEvent fakeSyntheticFormEvent(Element element, String type) {
  return jsifyAndAllowInterop({
    // SyntheticEvent fields
    'bubbles': false,
    'cancelable': false,
    'currentTarget': element,
    'defaultPrevented': false,
    'eventPhase': Event.AT_TARGET,
    'isTrusted': false,
    'nativeEvent': null,
    'target': element,
    'timeStamp': DateTime.now().millisecondsSinceEpoch,
    'type': type,
    // SyntheticEvent methods
    'stopPropagation': () {},
    'preventDefault': () {},
    'persist': () {},
    'isPersistent': () => true,
  }) as SyntheticFormEvent;

/// Returns a newly constructed [SyntheticEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticEvent createSyntheticEvent({
  SyntheticEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
}) {
  return SyntheticEvent(
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
  );
}

/// Returns a newly constructed [SyntheticClipboardEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticClipboardEvent createSyntheticClipboardEvent({
  SyntheticClipboardEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  dynamic clipboardData,
}) {
  return SyntheticClipboardEvent(
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    clipboardData ?? baseEvent?.clipboardData,
  );
}

/// Returns a newly constructed [SyntheticKeyboardEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticKeyboardEvent createSyntheticKeyboardEvent({
  SyntheticKeyboardEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey ?? false,
    char ?? baseEvent?.char,
    charCode ?? baseEvent?.charCode,
    ctrlKey ?? baseEvent?.ctrlKey ?? false,
    locale ?? baseEvent?.locale,
    location ?? baseEvent?.location,
    key ?? baseEvent?.key,
    keyCode ?? baseEvent?.keyCode,
    metaKey ?? baseEvent?.metaKey ?? false,
    repeat ?? baseEvent?.repeat,
    shiftKey ?? baseEvent?.shiftKey ?? false,
  );
}

/// Returns a newly constructed [SyntheticCompositionEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticCompositionEvent createSyntheticCompositionEvent({
  SyntheticCompositionEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  String data,
}) {
  return SyntheticCompositionEvent(
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    data ?? baseEvent?.data,
  );
}

/// Returns a newly constructed [SyntheticFocusEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticFocusEvent createSyntheticFocusEvent({
  SyntheticFocusEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
  /*DOMEventTarget*/ dynamic relatedTarget,
}) {
  return SyntheticFocusEvent(
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    relatedTarget ?? baseEvent?.relatedTarget,
  );
}

/// Returns a newly constructed [SyntheticFormEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticFormEvent createSyntheticFormEvent({
  SyntheticFormEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
  num eventPhase,
  bool isTrusted,
  dynamic nativeEvent,
  dynamic target,
  num timeStamp,
  String type,
}) {
  return SyntheticFormEvent(
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
  );
}

/// Returns a newly constructed [SyntheticMouseEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticMouseEvent createSyntheticMouseEvent({
  SyntheticMouseEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey ?? false,
    button ?? baseEvent?.button,
    buttons ?? baseEvent?.buttons,
    clientX ?? baseEvent?.clientX,
    clientY ?? baseEvent?.clientY,
    ctrlKey ?? baseEvent?.ctrlKey ?? false,
    dataTransfer ?? baseEvent?.dataTransfer,
    metaKey ?? baseEvent?.metaKey ?? false,
    pageX ?? baseEvent?.pageX,
    pageY ?? baseEvent?.pageY,
    relatedTarget ?? baseEvent?.relatedTarget,
    screenX ?? baseEvent?.screenX,
    screenY ?? baseEvent?.screenY,
    shiftKey ?? baseEvent?.shiftKey ?? false,
  );
}

/// Returns a newly constructed [SyntheticPointerEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticPointerEvent createSyntheticPointerEvent({
  SyntheticPointerEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
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

/// Returns a newly constructed [SyntheticTouchEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticTouchEvent createSyntheticTouchEvent({
  SyntheticTouchEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    altKey ?? baseEvent?.altKey ?? false,
    changedTouches ?? baseEvent?.changedTouches,
    ctrlKey ?? baseEvent?.ctrlKey ?? false,
    metaKey ?? baseEvent?.metaKey ?? false,
    shiftKey ?? baseEvent?.shiftKey ?? false,
    targetTouches ?? baseEvent?.targetTouches,
    touches ?? baseEvent?.touches,
  );
}

/// Returns a newly constructed [SyntheticTransitionEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticTransitionEvent createSyntheticTransitionEvent({
  SyntheticTransitionEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    propertyName ?? baseEvent?.propertyName,
    elapsedTime ?? baseEvent?.elapsedTime,
    pseudoElement ?? baseEvent?.pseudoElement,
  );
}

/// Returns a newly constructed [SyntheticAnimationEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticAnimationEvent createSyntheticAnimationEvent({
  SyntheticAnimationEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    animationName ?? baseEvent?.animationName,
    elapsedTime ?? baseEvent?.elapsedTime,
    pseudoElement ?? baseEvent?.pseudoElement,
  );
}

/// Returns a newly constructed [SyntheticUIEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticUIEvent createSyntheticUIEvent({
  SyntheticUIEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
    nativeEvent ?? baseEvent?.nativeEvent,
    target ?? baseEvent?.target,
    timeStamp ?? baseEvent?.timeStamp ?? 0,
    type ?? baseEvent?.type ?? 'empty event',
    detail ?? baseEvent?.detail,
    view ?? baseEvent?.view,
  );
}

/// Returns a newly constructed [SyntheticWheelEvent] instance.
///
/// In addition to creating empty instances (by invoking without any parameters) or completely custom instances
/// by using the named parameters, this function will merge previously existing [baseEvent]s with the named parameters provided.
/// The named parameters takes precedence, and therefore can be used to override specific fields on the [baseEvent].
SyntheticWheelEvent createSyntheticWheelEvent({
  SyntheticWheelEvent baseEvent,
  bool bubbles,
  bool cancelable,
  dynamic currentTarget,
  bool defaultPrevented,
  void Function() preventDefault,
  void Function() stopPropagation,
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
    bubbles ?? baseEvent?.bubbles ?? false,
    cancelable ?? baseEvent?.cancelable ?? true,
    currentTarget ?? baseEvent?.currentTarget,
    defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    preventDefault ?? baseEvent?.preventDefault ?? () {},
    stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    eventPhase ?? baseEvent?.eventPhase,
    isTrusted ?? baseEvent?.isTrusted ?? false,
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
  /// Returns whether this is a [SyntheticClipboardEvent].
  bool get isClipboardEvent => this is SyntheticClipboardEvent;

  /// Returns whether this is a [SyntheticKeyboardEvent].
  bool get isKeyboardEvent => this is SyntheticKeyboardEvent;

  /// Returns whether this is a [SyntheticCompositionEvent].
  bool get isCompositionEvent => this is SyntheticCompositionEvent;

  /// Returns whether this is a [SyntheticFocusEvent].
  bool get isFocusEvent => this is SyntheticFocusEvent;

  /// Returns whether this is a [SyntheticFormEvent].
  bool get isFormEvent => this is SyntheticFormEvent;

  /// Returns whether this is a [SyntheticMouseEvent].
  bool get isMouseEvent => this is SyntheticMouseEvent;

  /// Returns whether this is a [SyntheticPointerEvent].
  bool get isPointerEvent => this is SyntheticPointerEvent;

  /// Returns whether this is a [SyntheticTouchEvent].
  bool get isTouchEvent => this is SyntheticTouchEvent;

  /// Returns whether this is a [SyntheticTransitionEvent].
  bool get isTransitionEvent => this is SyntheticTransitionEvent;

  /// Returns whether this is a [SyntheticAnimationEvent].
  bool get isAnimationEvent => this is SyntheticAnimationEvent;

  /// Returns whether this is a [SyntheticUIEvent].
  bool get isUiEvent => this is SyntheticUIEvent;

  /// Returns whether this is a [SyntheticWheelEvent].
  bool get isWheelEvent => this is SyntheticWheelEvent;
}
