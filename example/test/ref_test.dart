import "dart:html";

import "package:react/react.dart" as react;
import 'package:react/react.dart';
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

var InputComponentForm = forwardRef((props, ref) {
  return react.form({
    'key': 'inputForm',
    'className': 'form-inline'
  }, [
    react.input({
      'key': 'create-input',
      'className': 'form-control',
      'ref': ref,
    }),
    '\u00a0',
    react.button({
      'type': 'button',
      'key': 'create-show-input',
      'className': 'btn btn-primary',
      'onClick': props['showInputForwardRefValue'],
    }, 'Print input element value'),
  ]);
});

var ChildComponentForm = forwardRef((props, ref) {
  return Fragment({}, [
    react.h4({'key': 'create-child-h4'}, "ChildComponent"),
    react.form({
      'key': 'childComponentForm',
      'className': 'form-inline'
    }, [
      ChildComponent({
        'key': 'create-child',
        "ref": ref,
      }),
      '\u00a0',
      react.button({
        'type': 'button',
        'key': 'create-show-button',
        'className': 'btn btn-primary',
        'onClick': props['showChildForwardRefValue'],
      }, 'Print child value'),
      '\u00a0',
      react.button({
        'type': 'button',
        'key': 'create-increment-button',
        'className': 'btn btn-primary',
        'onClick': props['incrementChildForwardRefValue'],
      }, 'Increment child value'),
    ])
  ]);
});

var ParentComponent = react.registerComponent(() => new _ParentComponent());

class _ParentComponent extends react.Component {
  // String refs
  showInputValue(_) {
    var input = react_dom.findDOMNode(ref('inputRef')) as InputElement;
    print(input.value);
  }

  showChildValue(_) {
    print(ref("childRef").somevalue);
  }

  incrementChildValue(_) {
    ref("childRef").incrementValue();
  }

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

  // Create refs
  var _inputCreateRef = createRef<InputElement>();
  var _childCreateRef = createRef<_ChildComponent>();

  showInputCreateRefValue(_) {
    var input = react_dom.findDOMNode(_inputCreateRef.current);
    print(input.value);
  }

  showChildCreateRefValue(_) {
    print(_childCreateRef.current.somevalue);
  }

  incrementChildCreateRefValue(_) {
    _childCreateRef.current.incrementValue();
  }

  render() {
    var stringRefs = react.div({
      'key': 'string-refs'
    }, [
      react.h2({'key': 'string-h2'}, "String refs"),
      react.h4({'key': 'string-h4'}, "<input>"),
      react.form({
        'key': 'stringRefInputForm',
        'className': 'form-inline',
      }, [
        react.input({
          'key': 'string-input',
          'className': 'form-control',
          'ref': 'inputRef',
        }),
        '\u00a0',
        react.button({
          'type': 'button',
          'key': 'string-show-input',
          'className': 'btn btn-primary',
          'onClick': showInputValue,
        }, 'Print input element value'),
      ]),
      react.h4({'key': 'string-h4-child'}, "ChildComponent"),
      react.form({
        'key': 'stringRefChildComponentForm',
        'className': 'form-inline',
      }, [
        ChildComponent({
          'key': 'string-child',
          "ref": "childRef",
        }),
        '\u00a0',
        react.button({
          'type': 'button',
          'key': 'string-show-button',
          'className': 'btn btn-primary',
          'onClick': showChildValue,
        }, 'Print child value'),
        '\u00a0',
        react.button({
          'type': 'button',
          'key': 'string-increment-button',
          'className': 'btn btn-primary',
          'onClick': incrementChildValue,
        }, 'Increment child value'),
      ]),
    ]);

    var callbackRefs = react.div({
      'key': 'callback-refs'
    }, [
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
          "ref": (instance) => _childCallbackRef = instance,
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

    var forwardRefs = react.div({
      'key': 'forward-refs'
    }, [
      react.h2({'key': 'h2-forward'}, "Create / Forward refs"),
      react.h4({'key': 'h4-forward-input'}, "<input>"),
      InputComponentForm({
        'ref': _inputCreateRef,
        'showInputForwardRefValue': showInputCreateRefValue,
        'key': 'input-component-form',
      }),
      ChildComponentForm({
        'ref': _childCreateRef,
        'showChildForwardRefValue': showChildCreateRefValue,
        'incrementChildForwardRefValue': incrementChildCreateRefValue,
        'key': 'child-component-form',
      }),
    ]);

    return Fragment({}, [
      react.h1({'key': 'h1'}, 'Refs'),
      stringRefs,
      callbackRefs,
      forwardRefs,
    ]);
  }
}

var mountedNode = querySelector('#content');
void main() {
  setClientConfiguration();
  var component = ParentComponent({});
  react_dom.render(component, mountedNode);
}
