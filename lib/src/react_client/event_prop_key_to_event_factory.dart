import 'package:react/react_client.dart';

/// A mapping from event prop keys to their respective event factories.
///
/// Used in [_convertEventHandlers] for efficient event handler conversion.
final Map<String, Function> eventPropKeyToEventFactory = (() {
  var _eventPropKeyToEventFactory = <String, Function>{
    // SyntheticClipboardEvent
    'onCopy': syntheticClipboardEventFactory,
    'onCut': syntheticClipboardEventFactory,
    'onPaste': syntheticClipboardEventFactory,

    // SyntheticKeyboardEvent
    'onKeyDown': syntheticKeyboardEventFactory,
    'onKeyPress': syntheticKeyboardEventFactory,
    'onKeyUp': syntheticKeyboardEventFactory,

    // SyntheticFocusEvent
    'onFocus': syntheticFocusEventFactory,
    'onBlur': syntheticFocusEventFactory,

    // SyntheticFormEvent
    'onChange': syntheticFormEventFactory,
    'onInput': syntheticFormEventFactory,
    'onSubmit': syntheticFormEventFactory,
    'onReset': syntheticFormEventFactory,

    // SyntheticMouseEvent
    'onClick': syntheticMouseEventFactory,
    'onContextMenu': syntheticMouseEventFactory,
    'onDoubleClick': syntheticMouseEventFactory,
    'onDrag': syntheticMouseEventFactory,
    'onDragEnd': syntheticMouseEventFactory,
    'onDragEnter': syntheticMouseEventFactory,
    'onDragExit': syntheticMouseEventFactory,
    'onDragLeave': syntheticMouseEventFactory,
    'onDragOver': syntheticMouseEventFactory,
    'onDragStart': syntheticMouseEventFactory,
    'onDrop': syntheticMouseEventFactory,
    'onMouseDown': syntheticMouseEventFactory,
    'onMouseEnter': syntheticMouseEventFactory,
    'onMouseLeave': syntheticMouseEventFactory,
    'onMouseMove': syntheticMouseEventFactory,
    'onMouseOut': syntheticMouseEventFactory,
    'onMouseOver': syntheticMouseEventFactory,
    'onMouseUp': syntheticMouseEventFactory,

    // SyntheticTouchEvent
    'onTouchCancel': syntheticTouchEventFactory,
    'onTouchEnd': syntheticTouchEventFactory,
    'onTouchMove': syntheticTouchEventFactory,
    'onTouchStart': syntheticTouchEventFactory,

    // SyntheticUIEvent
    'onScroll': syntheticUIEventFactory,

    // SyntheticWheelEvent
    'onWheel': syntheticWheelEventFactory,
  };

  // Add support for capturing variants; e.g., onClick/onClickCapture
  for (var key in _eventPropKeyToEventFactory.keys.toList()) {
    _eventPropKeyToEventFactory[key + 'Capture'] = _eventPropKeyToEventFactory[key];
  }

  return _eventPropKeyToEventFactory;
})();
