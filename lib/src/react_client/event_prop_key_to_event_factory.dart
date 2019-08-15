import 'package:react/src/react_client/synthetic_event/synthetic_event.dart';

/// A mapping from event prop keys to their respective event factories.
///
/// Used in [_convertEventHandlers] for efficient event handler conversion.
final Map<String, Function> eventPropKeyToEventFactory = (() {
  var _eventPropKeyToEventFactory = <String, Function>{
    // SyntheticClipboardEvent
    'onCopy': syntheticClipboardEventV2Factory,
    'onCut': syntheticClipboardEventV2Factory,
    'onPaste': syntheticClipboardEventV2Factory,

    // SyntheticKeyboardEvent
    'onKeyDown': syntheticKeyboardEventV2Factory,
    'onKeyPress': syntheticKeyboardEventV2Factory,
    'onKeyUp': syntheticKeyboardEventV2Factory,

    // SyntheticFocusEvent
    'onFocus': syntheticFocusEventV2Factory,
    'onBlur': syntheticFocusEventV2Factory,

    // SyntheticFormEvent
    'onChange': syntheticFormEventV2Factory,
    'onInput': syntheticFormEventV2Factory,
    'onSubmit': syntheticFormEventV2Factory,
    'onReset': syntheticFormEventV2Factory,

    // SyntheticMouseEvent
    'onClick': syntheticMouseEventV2Factory,
    'onContextMenu': syntheticMouseEventV2Factory,
    'onDoubleClick': syntheticMouseEventV2Factory,
    'onDrag': syntheticMouseEventV2Factory,
    'onDragEnd': syntheticMouseEventV2Factory,
    'onDragEnter': syntheticMouseEventV2Factory,
    'onDragExit': syntheticMouseEventV2Factory,
    'onDragLeave': syntheticMouseEventV2Factory,
    'onDragOver': syntheticMouseEventV2Factory,
    'onDragStart': syntheticMouseEventV2Factory,
    'onDrop': syntheticMouseEventV2Factory,
    'onMouseDown': syntheticMouseEventV2Factory,
    'onMouseEnter': syntheticMouseEventV2Factory,
    'onMouseLeave': syntheticMouseEventV2Factory,
    'onMouseMove': syntheticMouseEventV2Factory,
    'onMouseOut': syntheticMouseEventV2Factory,
    'onMouseOver': syntheticMouseEventV2Factory,
    'onMouseUp': syntheticMouseEventV2Factory,

    // SyntheticPointerEvent
    'onGotPointerCapture': syntheticPointerEventV2Factory,
    'onLostPointerCapture': syntheticPointerEventV2Factory,
    'onPointerCancel': syntheticPointerEventV2Factory,
    'onPointerDown': syntheticPointerEventV2Factory,
    'onPointerEnter': syntheticPointerEventV2Factory,
    'onPointerLeave': syntheticPointerEventV2Factory,
    'onPointerMove': syntheticPointerEventV2Factory,
    'onPointerOver': syntheticPointerEventV2Factory,
    'onPointerOut': syntheticPointerEventV2Factory,
    'onPointerUp': syntheticPointerEventV2Factory,

    // SyntheticTouchEvent
    'onTouchCancel': syntheticTouchEventV2Factory,
    'onTouchEnd': syntheticTouchEventV2Factory,
    'onTouchMove': syntheticTouchEventV2Factory,
    'onTouchStart': syntheticTouchEventV2Factory,

    // SyntheticTransitionEvent
    'onTransitionEnd': syntheticTransitionEventV2Factory,

    // SyntheticAnimationEvent
    'onAnimationEnd': syntheticAnimationEventV2Factory,
    'onAnimationIteration': syntheticAnimationEventV2Factory,
    'onAnimationStart': syntheticAnimationEventV2Factory,

    // SyntheticUIEvent
    'onScroll': syntheticUIEventV2Factory,

    // SyntheticWheelEvent
    'onWheel': syntheticWheelEventV2Factory,
  };

  // Add support for capturing variants; e.g., onClick/onClickCapture
  for (var key in _eventPropKeyToEventFactory.keys.toList()) {
    _eventPropKeyToEventFactory[key + 'Capture'] = _eventPropKeyToEventFactory[key];
  }

  return _eventPropKeyToEventFactory;
})();
