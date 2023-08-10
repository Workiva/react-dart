import 'package:react/react.dart';

/// Base component for event handling classes used in test cases.
class EventComponent extends Component2 {
  get initialState => {'text': ''};
  onEvent(SyntheticEvent e) => setState({'text': '${e.type} ${e.timeStamp}'});
  render() => div({
        'onAnimationEnd': onEvent,
        'onAnimationIteration': onEvent,
        'onAnimationStart': onEvent,
        'onBlur': onEvent,
        'onChange': onEvent,
        'onClick': onEvent,
        'onCopy': onEvent,
        'onCompositionEnd': onEvent,
        'onCompositionStart': onEvent,
        'onCompositionUpdate': onEvent,
        'onContextMenu': onEvent,
        'onCut': onEvent,
        'onDoubleClick': onEvent,
        'onDrag': onEvent,
        'onDragEnd': onEvent,
        'onDragEnter': onEvent,
        'onDragExit': onEvent,
        'onDragLeave': onEvent,
        'onDragOver': onEvent,
        'onDragStart': onEvent,
        'onDrop': onEvent,
        'onFocus': onEvent,
        'onGotPointerCapture': onEvent,
        'onInput': onEvent,
        'onKeyDown': onEvent,
        'onKeyPress': onEvent,
        'onKeyUp': onEvent,
        'onLostPointerCapture': onEvent,
        'onMouseDown': onEvent,
        'onMouseMove': onEvent,
        'onMouseOut': onEvent,
        'onMouseOver': onEvent,
        'onMouseUp': onEvent,
        'onPaste': onEvent,
        'onPointerCancel': onEvent,
        'onPointerDown': onEvent,
        'onPointerEnter': onEvent,
        'onPointerLeave': onEvent,
        'onPointerMove': onEvent,
        'onPointerOver': onEvent,
        'onPointerOut': onEvent,
        'onPointerUp': onEvent,
        'onScroll': onEvent,
        'onSubmit': onEvent,
        'onTextInput': onEvent,
        'onTouchCancel': onEvent,
        'onTouchEnd': onEvent,
        'onTouchMove': onEvent,
        'onTouchStart': onEvent,
        'onTransitionEnd': onEvent,
        'onWheel': onEvent
      }, state['text']);
}

class SampleComponent extends Component2 {
  render() => div(props, [
        h1({}, 'A header'),
        div({'className': 'div1'}, 'First div'),
        div({}, 'Second div'),
        span({'className': 'span1'})
      ]);
}

class WrapperComponent extends Component2 {
  render() => div(props, props['children']);
}

final eventComponent = registerComponent2(() => new EventComponent());

final sampleComponent = registerComponent2(() => new SampleComponent());

final wrapperComponent = registerComponent2(() => new WrapperComponent());
