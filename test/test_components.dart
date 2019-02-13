import 'package:react/react.dart';

/// Base component for event handling classes used in test cases.
class EventComponent extends Component {
  getInitialState() => {'text': ''};
  onEvent(SyntheticEvent e) => setState({'text': '${e.type} ${e.timeStamp}'});
  render() => div({
        'onBlur': onEvent,
        'onChange': onEvent,
        'onClick': onEvent,
        'onCopy': onEvent,
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
        'onInput': onEvent,
        'onKeyDown': onEvent,
        'onKeyPress': onEvent,
        'onKeyUp': onEvent,
        'onMouseDown': onEvent,
        'onMouseMove': onEvent,
        'onMouseOut': onEvent,
        'onMouseOver': onEvent,
        'onMouseUp': onEvent,
        'onPaste': onEvent,
        'onScroll': onEvent,
        'onSubmit': onEvent,
        'onTextInput': onEvent,
        'onTouchCancel': onEvent,
        'onTouchEnd': onEvent,
        'onTouchMove': onEvent,
        'onTouchStart': onEvent,
        'onWheel': onEvent
      }, state['text']);
}

class SampleComponent extends Component {
  render() => div(props, [
        h1({}, 'A header'),
        div({'className': 'div1'}, 'First div'),
        div({}, 'Second div'),
        span({'className': 'span1'})
      ]);
}

class WrapperComponent extends Component {
  render() => div(props, props['children']);
}

final eventComponent = registerComponent(() => new EventComponent());

final sampleComponent = registerComponent(() => new SampleComponent());

final wrapperComponent = registerComponent(() => new WrapperComponent());
