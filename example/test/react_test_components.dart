import "dart:async";
import 'dart:math';

import "package:react/react.dart" as react;
import 'package:react/react_client.dart';
import "package:react/react_dom.dart" as react_dom;

class _HelloComponent extends react.Component {
  void componentWillReceiveProps(nextProps) {
    if (nextProps["name"].length > 20) {
      print("Too long Hello!");
    }
  }

  render() {
    return react.span({}, ["Hello ${props['name']}!"]);
  }
}

var helloComponent = react.registerComponent(() => new _HelloComponent());

class _HelloGreeter extends react.Component {
  var myInput;
  getInitialState() => {"name": "World"};

  onInputChange(e) {
    var input = react_dom.findDOMNode(myInput);
    print(input.borderEdge);
  }

  render() {
    return react.div({}, [
      react.input({
        'key': 'input',
        'className': 'form-control',
        'ref': (ref) => myInput = ref,
        'value': bind('name'),
        'onChange': onInputChange,
      }),
      helloComponent({'key': 'hello', 'name': state['name']})
    ]);
  }
}

var helloGreeter = react.registerComponent(() => new _HelloGreeter());

class _CheckBoxComponent extends react.Component {
  getInitialState() => {"checked": false};

  change(e) {
    this.setState({'checked': e.target.checked});
  }

  render() {
    return react.div({
      'className': 'form-check'
    }, [
      react.input({
        'id': 'doTheDishes',
        'key': 'input',
        'className': 'form-check-input',
        'type': 'checkbox',
        'value': bind('checked'),
      }),
      react.label({
        'htmlFor': 'doTheDishes',
        'key': 'label',
        'className': 'form-check-label ' + (this.state['checked'] ? 'striked' : 'not-striked')
      }, 'do the dishes'),
    ]);
  }
}

var checkBoxComponent = react.registerComponent(() => new _CheckBoxComponent());

class _ClockComponent extends react.Component {
  Timer timer;

  getInitialState() => {'secondsElapsed': 0};

  Map getDefaultProps() => {'refreshRate': 1000};

  void componentWillMount() {
    timer = new Timer.periodic(new Duration(milliseconds: this.props["refreshRate"]), this.tick);
  }

  void componentWillUnmount() {
    timer.cancel();
  }

  void componentDidMount() {
    var rootNode = react_dom.findDOMNode(this);
    rootNode.style.backgroundColor = "#FFAAAA";
  }

  bool shouldComponentUpdate(nextProps, nextState) {
    //print("Next state: $nextState, props: $nextProps");
    //print("Old state: $state, props: $props");
    return nextState['secondsElapsed'] % 2 == 1;
  }

  void componentWillReceiveProps(nextProps) {
    print("Received props: $nextProps");
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }

  render() {
    return react.span({'onClick': (event) => print("Hello World!")},
//        { 'onClick': (event, [domid = null]) => print("Hello World!") },
        ["Seconds elapsed: ", "${state['secondsElapsed']}"]);
  }
}

var clockComponent = react.registerComponent(() => new _ClockComponent());

class _ListComponent extends react.Component {
  Map getInitialState() {
    return {
      "items": new List.from([0, 1, 2, 3])
    };
  }

  void componentWillUpdate(nextProps, nextState) {
    if (nextState["items"].length > state["items"].length) {
      print("Adding " + nextState["items"].last.toString());
    }
  }

  void componentDidUpdate(prevProps, prevState) {
    if (prevState["items"].length > state["items"].length) {
      print("Removed " + prevState["items"].first.toString());
    }
  }

  int iterator = 3;

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(++iterator);
    setState({"items": items});
  }

  dynamic render() {
    List<dynamic> items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": item}, "$item"));
    }

    return react.div({}, [
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': addItem,
      }, 'addItem'),
      react.ul({'key': 'list'}, items),
    ]);
  }
}

var listComponent = react.registerComponent(() => new _ListComponent());

class _MainComponent extends react.Component {
  render() {
    return react.div({}, props['children']);
  }
}

var mainComponent = react.registerComponent(() => new _MainComponent());

/////
// REACT OLD CONTEXT COMPONENTS
/////
class _LegacyContextComponent extends react.Component {
  @override
  Iterable<String> get childContextKeys => const ['foo', 'bar', 'renderCount'];

  @override
  Map<String, dynamic> getChildContext() => {
        'foo': {'object': 'with value'},
        'bar': true,
        'renderCount': this.state['renderCount']
      };

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      react.button({'key': 'button', 'className': 'btn btn-primary', 'onClick': _onButtonClick}, 'Redraw'),
      react.br({'key': 'break1'}),
      'LegacyContextComponent.getChildContext(): ',
      getChildContext().toString(),
      react.br({'key': 'break2'}),
      react.br({'key': 'break3'}),
      props['children'],
    ]);
  }

  _onButtonClick(event) {
    this.setState({'renderCount': (this.state['renderCount'] ?? 0) + 1});
  }
}

var legacyContextComponent = react.registerComponent(() => new _LegacyContextComponent());

class _LegacyContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['foo'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'LegacyContextConsumerComponent.context: ',
      context.toString(),
      react.br({'key': 'break1'}),
      react.br({'key': 'break2'}),
      props['children'],
    ]);
  }
}

var legacyContextConsumerComponent = react.registerComponent(() => new _LegacyContextConsumerComponent());

class _GrandchildLegacyContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['renderCount'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'LegacyGrandchildContextConsumerComponent.context: ',
      context.toString(),
    ]);
  }
}

var grandchildLegacyContextConsumerComponent =
    react.registerComponent(() => new _GrandchildLegacyContextConsumerComponent());

////
// REACT NEW CONTEXT COMPONENTS
////
class _NewContextRefComponent extends react.Component2 {
  render() {
    return react.div({}, props['children']);
  }

  test() {
    print('test');
  }
}

var newContextRefComponent = react.registerComponent(() => new _NewContextRefComponent());

int calculateChangedBits(currentValue, nextValue) {
  int result = 1 << 1;
  if (nextValue['renderCount'] % 2 == 0) {
    result |= 1 << 2;
  }
  return result;
}

var TestNewContext = createContext({'renderCount': 0}, calculateChangedBits);

class _NewContextProviderComponent extends react.Component2 {
  _NewContextRefComponent componentRef;

  getInitialState() => {'renderCount': 0, 'complexMap': false};

  printMe() {
    print('printMe!');
  }

  render() {
    Map provideMap = {'renderCount': this.state['renderCount']};

    Map complexValues = {
      'callback': printMe,
      'dartComponent': newContextRefComponent,
      'map': {
        'bool': true,
        'anotherDartComponent': newContextRefComponent,
      },
      'componentRef': componentRef,
    };

    if (state['complexMap']) {
      provideMap.addAll(complexValues);
    }

    Map newContextRefComponentProps = {
      'key': 'ref2',
      'ref': (ref) {
        componentRef = ref;
      }
    };

    return react.ul({
      'key': 'ulasda',
    }, [
      newContextRefComponent(newContextRefComponentProps, []),
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': _onButtonClick,
      }, 'Redraw'),
      react.button({
        'type': 'button',
        'key': 'button_complex',
        'className': 'btn btn-primary',
        'onClick': _onComplexClick,
      }, 'Redraw With Complex Value'),
      react.br({'key': 'break1'}),
      'TestContext.Provider props.value: ${provideMap}',
      react.br({'key': 'break2'}),
      react.br({'key': 'break3'}),
      TestNewContext.Provider(
        {'key': 'tcp', 'value': provideMap},
        props['children'],
      ),
    ]);
  }

  _onComplexClick(event) {
    this.setState({'complexMap': true, 'renderCount': this.state['renderCount'] + 1});
  }

  _onButtonClick(event) {
    this.setState({'renderCount': this.state['renderCount'] + 1, 'complexMap': false});
  }
}

var newContextProviderComponent = react.registerComponent(() => new _NewContextProviderComponent());

class _NewContextConsumerComponent extends react.Component2 {
  render() {
    return TestNewContext.Consumer({'unstable_observedBits': props['unstable_observedBits']}, (value) {
      return react.ul({
        'key': 'ul1'
      }, [
        'TestContext.Consumer: value = ${value}',
        react.br({'key': 'break12'}),
        react.br({'key': 'break22'}),
        props['children'],
      ]);
    });
  }
}

var newContextConsumerComponent = react.registerComponent(() => new _NewContextConsumerComponent());

class _NewContextConsumerObservedBitsComponent extends react.Component2 {
  render() {
    return TestNewContext.Consumer({'unstable_observedBits': props['unstable_observedBits']}, (value) {
      return react.ul({
        'key': 'ul2'
      }, [
        'TestContext.Consumer (with unstable_observedBits set to trigger when `renderCount % 2 == 0`): value = ${value}',
        react.br({'key': 'break13'}),
        react.br({'key': 'break23'}),
        props['children'],
      ]);
    });
  }
}

var newContextConsumerObservedBitsComponent =
    react.registerComponent(() => new _NewContextConsumerObservedBitsComponent());

class _NewContextTypeConsumerComponent extends react.Component2 {
  @override
  final contextType = TestNewContext;

  render() {
    this.context['componentRef']?.test();
    return react.ul({
      'key': 'ul3'
    }, [
      'Using Component.contextType: this.context = ${this.context}',
    ]);
  }
}

class _Component2TestComponent extends react.Component2 with react.TypedSnapshot<String> {
  Map getInitialState() {
    return {
      "items": new List.from([0, 1, 2, 3])
    };
  }

  String getSnapshotBeforeUpdate(nextProps, prevState) {
    if (prevState["items"].length > state["items"].length) {
      return "removed " + prevState["items"].last.toString();
    } else {
      return "added " + state["items"].last.toString();
    }
  }

  void componentDidUpdate(prevProps, prevState, [String snapshot]) {
    if (snapshot != null) {
      print('Updated DOM and ' + snapshot);
      return null;
    }
    print("No Snapshot");
  }

  void removeItem(event) {
    List items = new List.from(state["items"]);
    items.removeAt(items.length - 1);
    setState({"items": items});
  }

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(items.length);
    setState({"items": items});
  }

  dynamic render() {
    List<dynamic> items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": "c2" + item.toString()}, "$item"));
    }

    return react.div({}, [
      react.button({
        'type': 'button',
        'key': 'c2-r-button',
        'className': 'btn btn-primary',
        'onClick': removeItem,
      }, 'Remove Item'),
      react.button({
        'type': 'button',
        'key': 'c2-a-button',
        'className': 'btn btn-primary',
        'onClick': addItem,
      }, 'Add Item'),
      react.ul({'key': 'c2-list'}, items),
    ]);
  }
}

var newContextTypeConsumerComponentComponent = react.registerComponent(() => new _NewContextTypeConsumerComponent());
var component2TestComponent = react.registerComponent(() => new _Component2TestComponent());

class _ErrorComponent extends react.Component2 {
  void componentDidMount() {
    if (!props["errored"]) {
      throw new _CustomException("It broke!", 2);
    }
  }

  dynamic render() {
    return react.div(
        {'key': 'eb-d1-e'},
        "Oh no, I'm an error! Check your "
        "console.");
  }
}

var ErrorComponent = react.registerComponent(() => new _ErrorComponent());

class _CustomException implements Exception {
  int code;
  String message;
  String randomMessage;

  _CustomException(this.message, this.code) {
    switch (code) {
      case 1:
        randomMessage = "The code is a 1";
        break;
      case 2:
        randomMessage = "The Code is a 2";
        break;
      default:
        randomMessage = "Default Error Code";
    }
  }
}

class _Component2ErrorTestComponent extends react.Component2 {
  Map getInitialState() {
    return {
      "clicked": false,
      "errored": false,
      "error": null,
    };
  }

  void componentDidCatch(error, info) {
    setState({
      "error": "We can capture the error, store it in state and "
          "display it here."
    });
  }

  Map getDerivedStateFromError(error) {
    return {"errored": true};
  }

  void error(event) {
    setState({"clicked": true});
  }

  void clearError(event) {
    setState({"clicked": false, "error": null, "errored": false});
  }

  dynamic render() {
    dynamic errorMessage = state["error"] ?? "No error yet";

    return react.div({
      "key": "e-cont"
    }, [
      react.h3({"key": "e-header"}, "Error Boundary Test"),
      state["clicked"] ? ErrorComponent({'key': 'ec-1', 'errored': state['errored']}) : null,
      errorMessage != null ? react.div({'key': 'ec-m-1'}, '$errorMessage') : null,
      !state["errored"]
          ? react.button({
              'type': 'button',
              'key': 'c3-r-button',
              'className': 'btn btn-primary',
              'onClick': error,
            }, 'Trigger Error')
          : null,
      state["errored"]
          ? react.button({
              'type': 'button',
              'key': 'c3-c-button',
              'className': 'btn btn-primary',
              'onClick': clearError,
            }, 'Clear Error')
          : null,
      react.hr({"key": "e-hr"}),
    ]);
  }
}

var component2ErrorTestComponent = react.registerComponent(() => new _Component2ErrorTestComponent(), ['render']);
