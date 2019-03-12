import "dart:async";

import "package:react/react.dart" as react;
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

class _ContextComponent extends react.Component {
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
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': _onButtonClick,
      }, 'Redraw'),
      react.br({'key': 'break1'}),
      'ContextComponent.getChildContext(): ',
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

var contextComponent = react.registerComponent(() => new _ContextComponent());

class _ContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['foo'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'ContextConsumerComponent.context: ',
      context.toString(),
      react.br({'key': 'break1'}),
      react.br({'key': 'break2'}),
      props['children'],
    ]);
  }
}

var contextConsumerComponent = react.registerComponent(() => new _ContextConsumerComponent());

class _GrandchildContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['renderCount'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'GrandchildContextConsumerComponent.context: ',
      context.toString(),
    ]);
  }
}

var grandchildContextConsumerComponent = react.registerComponent(() => new _GrandchildContextConsumerComponent());
