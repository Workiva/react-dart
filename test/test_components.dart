import 'package:react/react.dart';
import 'package:react/react_client.dart' show ReactComponentFactory, ReactComponentFactoryProxy; // ignore: deprecated_member_use

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

// ignore: deprecated_member_use
ReactComponentFactory eventComponent = registerComponent(() => new EventComponent()) as ReactComponentFactory;

class SampleComponent extends Component {
  render() => div(props, [
      h1({}, 'A header'),
      div({'className': 'div1'}, 'First div'),
      div({}, 'Second div'),
      span({'className': 'span1'})
  ]);
}

// ignore: deprecated_member_use
ReactComponentFactory sampleComponent = registerComponent(() => new SampleComponent()) as ReactComponentFactory;

class WrapperComponent extends Component {
  render() => div(props, props['children']);
}

// ignore: deprecated_member_use
ReactComponentFactory wrapperComponent = registerComponent(() => new WrapperComponent()) as ReactComponentFactory;

final eventComponentV2 = registerComponent(() =>
    new EventComponent()) as ReactComponentFactoryProxy;

final sampleComponentV2 = registerComponent(() =>
    new SampleComponent()) as ReactComponentFactoryProxy;

final wrapperComponentV2 = registerComponent(() =>
    new WrapperComponent()) as ReactComponentFactoryProxy;
