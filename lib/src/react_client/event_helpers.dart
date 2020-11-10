// ignore_for_file: deprecated_member_use_from_same_package
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
}

Map<String, dynamic> _wrapBaseEventPropertiesInMap({
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
  return {
    'bubbles': bubbles ?? baseEvent?.bubbles ?? false,
    'cancelable': cancelable ?? baseEvent?.cancelable ?? true,
    'currentTarget': currentTarget ?? baseEvent?.currentTarget,
    'defaultPrevented': defaultPrevented ?? baseEvent?.defaultPrevented ?? false,
    'preventDefault': preventDefault ?? baseEvent?.preventDefault ?? () {},
    'stopPropagation': stopPropagation ?? baseEvent?.stopPropagation ?? () {},
    'eventPhase': eventPhase ?? baseEvent?.eventPhase,
    'isTrusted': isTrusted ?? baseEvent?.isTrusted ?? false,
    'nativeEvent': nativeEvent ?? baseEvent?.nativeEvent,
    'target': target ?? baseEvent?.target,
    'timeStamp': timeStamp ?? baseEvent?.timeStamp ?? 0,
    'type': type ?? baseEvent?.type ?? 'empty event',
  };
}

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
  return jsifyAndAllowInterop(_wrapBaseEventPropertiesInMap(
    baseEvent: baseEvent,
    bubbles: bubbles,
    cancelable: cancelable,
    currentTarget: currentTarget,
    defaultPrevented: defaultPrevented,
    preventDefault: preventDefault,
    stopPropagation: stopPropagation,
    eventPhase: eventPhase,
    isTrusted: isTrusted,
    nativeEvent: nativeEvent,
    target: target,
    timeStamp: timeStamp,
    type: type,
  )) as SyntheticEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'clipboardData': clipboardData ?? baseEvent?.clipboardData,
  }) as SyntheticClipboardEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'altKey': altKey ?? baseEvent?.altKey ?? false,
    'char': char ?? baseEvent?.char,
    'charCode': charCode ?? baseEvent?.charCode,
    'ctrlKey': ctrlKey ?? baseEvent?.ctrlKey ?? false,
    'locale': locale ?? baseEvent?.locale,
    'location': location ?? baseEvent?.location,
    'key': key ?? baseEvent?.key,
    'keyCode': keyCode ?? baseEvent?.keyCode,
    'metaKey': metaKey ?? baseEvent?.metaKey ?? false,
    'repeat': repeat ?? baseEvent?.repeat,
    'shiftKey': shiftKey ?? baseEvent?.shiftKey ?? false,
  }) as SyntheticKeyboardEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'data': data ?? baseEvent?.data,
  }) as SyntheticCompositionEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'relatedTarget': relatedTarget ?? baseEvent?.relatedTarget,
  }) as SyntheticFocusEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
  }) as SyntheticFormEvent;
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
  NonNativeDataTransfer dataTransfer,
  bool metaKey,
  num pageX,
  num pageY,
  /*DOMEventTarget*/ dynamic relatedTarget,
  num screenX,
  num screenY,
  bool shiftKey,
}) {
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'altKey': altKey ?? baseEvent?.altKey ?? false,
    'button': button ?? baseEvent?.button,
    'buttons': buttons ?? baseEvent?.buttons,
    'clientX': clientX ?? baseEvent?.clientX,
    'clientY': clientY ?? baseEvent?.clientY,
    'ctrlKey': ctrlKey ?? baseEvent?.ctrlKey ?? false,
    'dataTransfer': dataTransfer ?? baseEvent?.dataTransfer,
    'metaKey': metaKey ?? baseEvent?.metaKey ?? false,
    'pageX': pageX ?? baseEvent?.pageX,
    'pageY': pageY ?? baseEvent?.pageY,
    'relatedTarget': relatedTarget ?? baseEvent?.relatedTarget,
    'screenX': screenX ?? baseEvent?.screenX,
    'screenY': screenY ?? baseEvent?.screenY,
    'shiftKey': shiftKey ?? baseEvent?.shiftKey ?? false,
  }) as SyntheticMouseEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'pointerId': pointerId ?? baseEvent?.pointerId,
    'width': width ?? baseEvent?.width,
    'height': height ?? baseEvent?.height,
    'pressure': pressure ?? baseEvent?.pressure,
    'tangentialPressure': tangentialPressure ?? baseEvent?.tangentialPressure,
    'tiltX': tiltX ?? baseEvent?.tiltX,
    'tiltY': tiltY ?? baseEvent?.tiltY,
    'twist': twist ?? baseEvent?.twist,
    'pointerType': pointerType ?? baseEvent?.pointerType,
    'isPrimary': isPrimary ?? baseEvent?.isPrimary,
  }) as SyntheticPointerEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'altKey': altKey ?? baseEvent?.altKey ?? false,
    'changedTouches': changedTouches ?? baseEvent?.changedTouches,
    'ctrlKey': ctrlKey ?? baseEvent?.ctrlKey ?? false,
    'metaKey': metaKey ?? baseEvent?.metaKey ?? false,
    'shiftKey': shiftKey ?? baseEvent?.shiftKey ?? false,
    'targetTouches': targetTouches ?? baseEvent?.targetTouches,
    'touches': touches ?? baseEvent?.touches,
  }) as SyntheticTouchEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'propertyName': propertyName ?? baseEvent?.propertyName,
    'elapsedTime': elapsedTime ?? baseEvent?.elapsedTime,
    'pseudoElement': pseudoElement ?? baseEvent?.pseudoElement,
  }) as SyntheticTransitionEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'animationName': animationName ?? baseEvent?.animationName,
    'elapsedTime': elapsedTime ?? baseEvent?.elapsedTime,
    'pseudoElement': pseudoElement ?? baseEvent?.pseudoElement,
  }) as SyntheticAnimationEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'detail': detail ?? baseEvent?.detail,
    'view': view ?? baseEvent?.view,
  }) as SyntheticUIEvent;
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
  return jsifyAndAllowInterop({
    ..._wrapBaseEventPropertiesInMap(
      baseEvent: baseEvent,
      bubbles: bubbles,
      cancelable: cancelable,
      currentTarget: currentTarget,
      defaultPrevented: defaultPrevented,
      preventDefault: preventDefault,
      stopPropagation: stopPropagation,
      eventPhase: eventPhase,
      isTrusted: isTrusted,
      nativeEvent: nativeEvent,
      target: target,
      timeStamp: timeStamp,
      type: type,
    ),
    'deltaX': deltaX ?? baseEvent?.deltaX,
    'deltaMode': deltaMode ?? baseEvent?.deltaMode,
    'deltaY': deltaY ?? baseEvent?.deltaY,
    'deltaZ': deltaZ ?? baseEvent?.deltaZ,
  }) as SyntheticWheelEvent;
}

extension SyntheticEventTypeHelpers on SyntheticEvent {
  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticClipboardEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticClipboardEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - clipboardData
  bool get isClipboardEvent {
    final typedThis = this as SyntheticClipboardEvent;
    if (typedThis.clipboardData != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticKeyboardEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticKeyboardEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - char
  /// - charCode
  /// - key
  /// - keyCode
  /// - locale
  /// - location
  /// - repeat
  ///
  /// The following fields __are not__ considered in type detection:
  /// - altKey
  /// - ctrlKey
  /// - metaKey
  /// - shiftKey
  bool get isKeyboardEvent {
    final typedThis = this as SyntheticKeyboardEvent;

    if (typedThis.char != null) return true;
    if (typedThis.locale != null) return true;
    if (typedThis.location != null) return true;
    if (typedThis.key != null) return true;
    if (typedThis.repeat != null) return true;
    if (typedThis.keyCode != null) return true;
    if (typedThis.charCode != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticCompositionEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticCompositionEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - data
  bool get isCompositionEvent {
    final typedThis = this as SyntheticCompositionEvent;

    if (typedThis.data != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticFocusEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticFocusEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - relatedTarget
  bool get isFocusEvent {
    final typedThis = this as SyntheticFocusEvent;
    if (typedThis.relatedTarget != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticFormEvent].
  ///
  /// __NOTE:__ This getter is here for completeness, but because the interface for form events
  /// is the same as that of a [SyntheticEvent] (the base for all other synthetic event types),
  /// via Duck Typing every [SyntheticEvent] is considered a [SyntheticFormEvent].
  bool get isFormEvent => true;

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticMouseEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticMouseEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - button
  /// - buttons
  /// - clientX
  /// - clientY
  /// - dataTransfer
  /// - pageX
  /// - pageY
  /// - screenX
  /// - screenY
  ///
  /// The following fields __are not__ considered in type detection:
  /// - altKey
  /// - ctrlKey
  /// - metaKey
  /// - relatedTarget
  /// - shiftKey
  bool get isMouseEvent {
    final typedThis = this as SyntheticMouseEvent;

    if (typedThis.button != null) return true;
    if (typedThis.buttons != null) return true;
    if (typedThis.clientX != null) return true;
    if (typedThis.clientY != null) return true;
    if (typedThis.dataTransfer != null) return true;
    if (typedThis.pageX != null) return true;
    if (typedThis.pageY != null) return true;
    if (typedThis.screenX != null) return true;
    if (typedThis.screenY != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticPointerEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticPointerEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - pointerId
  /// - width
  /// - height
  /// - pressure
  /// - tangentialPressure
  /// - tiltX
  /// - tiltY
  /// - twist
  /// - pointerType
  /// - isPrimary
  bool get isPointerEvent {
    final typedThis = this as SyntheticPointerEvent;

    if (typedThis.pointerId != null) return true;
    if (typedThis.width != null) return true;
    if (typedThis.height != null) return true;
    if (typedThis.pressure != null) return true;
    if (typedThis.tangentialPressure != null) return true;
    if (typedThis.tiltX != null) return true;
    if (typedThis.tiltY != null) return true;
    if (typedThis.twist != null) return true;
    if (typedThis.pointerType != null) return true;
    if (typedThis.isPrimary != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticTouchEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticTouchEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - changedTouches
  /// - targetTouches
  /// - touches
  ///
  /// The following fields __are not__ considered in type detection:
  /// - altKey
  /// - ctrlKey
  /// - metaKey
  /// - shiftKey
  bool get isTouchEvent {
    final typedThis = this as SyntheticTouchEvent;

    if (typedThis.changedTouches != null) return true;
    if (typedThis.targetTouches != null) return true;
    if (typedThis.touches != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticTransitionEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticTransitionEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - propertyName
  ///
  /// The following fields __are not__ considered in type detection:
  /// - elapsedTime
  /// - pseudoElement
  bool get isTransitionEvent {
    final typedThis = this as SyntheticTransitionEvent;

    if (typedThis.propertyName != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticAnimationEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticAnimationEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - animationName
  ///
  /// The following fields __are not__ considered in type detection:
  /// - elapsedTime
  /// - pseudoElement
  bool get isAnimationEvent {
    final typedThis = this as SyntheticAnimationEvent;

    if (typedThis.animationName != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticUIEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticUIEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - detail
  /// - view
  bool get isUiEvent {
    final typedThis = this as SyntheticUIEvent;

    if (typedThis.detail != null) return true;
    if (typedThis.view != null) return true;

    return false;
  }

  /// Uses Duck Typing to attempt to detect if the event instance is a [SyntheticWheelEvent].
  ///
  /// __NOTE:__ A field unique to this class must be non-null in order for this to return true, even
  /// if the event instance was instantiated as a [SyntheticWheelEvent]. For this class, this means
  /// that one of the following fields must be non-null:
  /// - deltaX
  /// - deltaMode
  /// - deltaY
  /// - deltaZ
  bool get isWheelEvent {
    final typedThis = this as SyntheticWheelEvent;

    if (typedThis.deltaX != null) return true;
    if (typedThis.deltaMode != null) return true;
    if (typedThis.deltaY != null) return true;
    if (typedThis.deltaZ != null) return true;

    return false;
  }
}
