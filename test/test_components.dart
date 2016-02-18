import 'package:react/react.dart';
import 'package:react/react_client.dart' show ReactComponentFactory;


/// Base component for event handling classes used in test cases.
class EventComponent extends Component {
  getInitialState() => {'text': ''};
  onEvent(SyntheticEvent e) => setState({'text': '${e.type} ${e.timeStamp}'});
  render() => div(
      {
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
      },
      state['text']
  );
}
ReactComponentFactory eventComponent = registerComponent(() =>
    new EventComponent());

class SampleComponent extends Component {
  render() => div(props, [
      h1({}, 'A header'),
      div({'className': 'div1'}, 'First div'),
      div({}, 'Second div'),
      span({'className': 'span1'})
  ]);
}

ReactComponentFactory sampleComponent = registerComponent(() =>
    new SampleComponent());

class WrapperComponent extends Component {
  render() => div(props, props['children']);
}

ReactComponentFactory wrapperComponent = registerComponent(() =>
    new WrapperComponent());
