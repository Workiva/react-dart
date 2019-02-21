import "dart:html";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;
import "package:react/react_client.dart";

var ChildComponent = react.registerComponent(() => new _ChildComponent());

class _ChildComponent extends react.Component {
  int somevalue = 10;
  incrementValue() {
    somevalue++;
    redraw();
  }

  render() => react.span({}, "Child element with value ${somevalue}");
}

var ParentComponent = react.registerComponent(() => new _ParentComponent());

class _ParentComponent extends react.Component {
  // Callback refs
  InputElement _inputCallbackRef;
  _ChildComponent _childCallbackRef;

  showInputCallbackRefValue(_) {
    var input = react_dom.findDOMNode(_inputCallbackRef);
    print(input.value);
  }

  showChildCallbackRefValue(_) {
    print(_childCallbackRef.somevalue);
  }

  incrementChildCallbackRefValue(_) {
    _childCallbackRef.incrementValue();
  }

  render() => react.div({}, [
        react.h1({'key': 'h1'}, 'Refs'),
        react.h2({'key': 'h2-callback'}, "Callback refs"),
        react.h4({'key': 'h4-callback-input'}, "<input>"),
        react.form({
          'key': 'inputForm',
          'className': 'form-inline'
        }, [
          react.input({
            'key': 'callback-input',
            'className': 'form-control',
            'ref': (instance) => _inputCallbackRef = instance,
          }),
          '\u00a0',
          react.button({
            'type': 'button',
            'key': 'callback-show-input',
            'className': 'btn btn-primary',
            'onClick': showInputCallbackRefValue,
          }, 'Print input element value'),
        ]),
        react.h4({'key': 'callback-child-h4'}, "ChildComponent"),
        react.form({
          'key': 'childComponentForm',
          'className': 'form-inline'
        }, [
          ChildComponent({
            'key': 'callback-child',
            "ref": (instance) => _childCallbackRef = instance
          }),
          '\u00a0',
          react.button({
            'type': 'button',
            'key': 'callback-show-button',
            'className': 'btn btn-primary',
            'onClick': showChildCallbackRefValue,
          }, 'Print child value'),
          '\u00a0',
          react.button({
            'type': 'button',
            'key': 'callback-increment-button',
            'className': 'btn btn-primary',
            'onClick': incrementChildCallbackRefValue,
          }, 'Increment child value'),
        ]),
      ]);
}

var mountedNode = querySelector('#content');
void main() {
  setClientConfiguration();
  var component = ParentComponent({});
  react_dom.render(component, mountedNode);
}
