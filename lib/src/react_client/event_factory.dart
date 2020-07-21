import 'dart:html';

import 'package:react/react.dart';
import 'package:react/src/react_client/synthetic_event_wrappers.dart' as events;

/// A mapping from converted/wrapped JS handler functions (the result of [_convertEventHandlers])
/// to the original Dart functions (the input of [_convertEventHandlers]).
final Expando<Function> originalEventHandlers = new Expando();

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(events.SyntheticEvent e) {
  return new SyntheticEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(events.SyntheticClipboardEvent e) {
  return new SyntheticClipboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.clipboardData);
}

/// Wrapper for [SyntheticCompositionEvent].
SyntheticCompositionEvent syntheticCompositionEventFactory(events.SyntheticCompositionEvent e) {
  return SyntheticCompositionEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.data);
}

/// Wrapper for [SyntheticKeyboardEvent].
SyntheticKeyboardEvent syntheticKeyboardEventFactory(events.SyntheticKeyboardEvent e) {
  return new SyntheticKeyboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.altKey,
      e.char,
      e.charCode,
      e.ctrlKey,
      e.locale,
      e.location,
      e.key,
      e.keyCode,
      e.metaKey,
      e.repeat,
      e.shiftKey);
}

/// Wrapper for [SyntheticFocusEvent].
SyntheticFocusEvent syntheticFocusEventFactory(events.SyntheticFocusEvent e) {
  return new SyntheticFocusEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.relatedTarget);
}

/// Wrapper for [SyntheticFormEvent].
SyntheticFormEvent syntheticFormEventFactory(events.SyntheticFormEvent e) {
  return new SyntheticFormEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticDataTransfer].
///
/// [dt] is typed as Object instead of [dynamic] to avoid dynamic calls in the method body,
/// ensuring the code is statically sound.
SyntheticDataTransfer syntheticDataTransferFactory(Object dt) {
  if (dt == null) return null;

  List rawFiles;
  List rawTypes;

  String effectAllowed;
  String dropEffect;

  // Handle `dt` being either a native DOM DataTransfer object or a JS object that looks like it (events.NonNativeDataTransfer).
  // Casting a JS object to DataTransfer fails intermittently in dart2js, and vice-versa fails intermittently in either DDC or dart2js.
  // TODO figure out when NonNativeDataTransfer is used.
  //
  // Some logic here is duplicated to ensure statically-sound access of same-named members.
  if (dt is DataTransfer) {
    rawFiles = dt.files;
    rawTypes = dt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = dt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = dt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  } else {
    // Assume it's a NonNativeDataTransfer otherwise.
    // Perform a cast inside `else` instead of an `else if (dt is ...)` since is-checks for
    // anonymous JS objects have undefined behavior.
    final castedDt = dt as events.NonNativeDataTransfer;

    rawFiles = castedDt.files;
    rawTypes = castedDt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = castedDt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = castedDt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  }

  // Copy these lists and ensure they're typed properly.
  // todo use .cast() in Dart 2
  final files = <File>[];
  final types = <String>[];
  rawFiles?.forEach(files.add);
  rawTypes?.forEach(types.add);

  return new SyntheticDataTransfer(dropEffect, effectAllowed, files, types);
}

/// Wrapper for [SyntheticPointerEvent].
SyntheticPointerEvent syntheticPointerEventFactory(events.SyntheticPointerEvent e) {
  return new SyntheticPointerEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.pointerId,
    e.width,
    e.height,
    e.pressure,
    e.tangentialPressure,
    e.tiltX,
    e.tiltY,
    e.twist,
    e.pointerType,
    e.isPrimary,
  );
}

/// Wrapper for [SyntheticMouseEvent].
SyntheticMouseEvent syntheticMouseEventFactory(events.SyntheticMouseEvent e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e.dataTransfer);
  return new SyntheticMouseEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.button,
    e.buttons,
    e.clientX,
    e.clientY,
    e.ctrlKey,
    dt,
    e.metaKey,
    e.pageX,
    e.pageY,
    e.relatedTarget,
    e.screenX,
    e.screenY,
    e.shiftKey,
  );
}

/// Wrapper for [SyntheticTouchEvent].
SyntheticTouchEvent syntheticTouchEventFactory(events.SyntheticTouchEvent e) {
  return new SyntheticTouchEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.changedTouches,
    e.ctrlKey,
    e.metaKey,
    e.shiftKey,
    e.targetTouches,
    e.touches,
  );
}

/// Wrapper for [SyntheticTransitionEvent].
SyntheticTransitionEvent syntheticTransitionEventFactory(events.SyntheticTransitionEvent e) {
  return new SyntheticTransitionEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.propertyName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticAnimationEvent].
SyntheticAnimationEvent syntheticAnimationEventFactory(events.SyntheticAnimationEvent e) {
  return new SyntheticAnimationEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.animationName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticUIEvent].
SyntheticUIEvent syntheticUIEventFactory(events.SyntheticUIEvent e) {
  return new SyntheticUIEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.detail,
    e.view,
  );
}

/// Wrapper for [SyntheticWheelEvent].
SyntheticWheelEvent syntheticWheelEventFactory(events.SyntheticWheelEvent e) {
  return new SyntheticWheelEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.deltaX,
    e.deltaMode,
    e.deltaY,
    e.deltaZ,
  );
}
