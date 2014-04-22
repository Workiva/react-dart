import "package:react/react.dart" as react;
import "dart:async";
import 'dart:html';


class _HelloComponent extends react.Component {

  void componentWillReceiveProps(nextProps) {
    if(nextProps["name"].length > 20) {
      print("Too long Hello!");
    }
  }

  render() {
    return react.span({}, ["Hello ${props['name']}!"]);
  }
}

var helloComponent = react.registerComponent(() => new _HelloComponent());

class _HelloGreeter extends react.Component {

  getInitialState() => {"name": "World"};

  onInputChange(e) {
    var input = ref('myInput') as InputElement;
    print(input.borderEdge);
  }

  render() {
    return react.div({}, [
        react.input({'ref': 'myInput', 'value': bind('name'), 'onChange': onInputChange}),
        helloComponent({'name': state['name']})
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
    return react.div({}, [
        react.label({'className': this.state["checked"] ? 'striked' : 'not-striked'}, 'do the dishes'),
        react.input({'type': 'checkbox', 'value': bind('checked')}, [])
    ]);
  }
}

var checkBoxComponent = react.registerComponent(() => new _CheckBoxComponent());

class _ClockComponent extends react.Component {

  Timer timer;

  getInitialState() => {'secondsElapsed': 0};

  dynamic getDefaultProps() => {'refreshRate': 1000};


  void componentWillMount() {
    timer = new Timer.periodic(
        new Duration(milliseconds: this.props["refreshRate"]),
        this.tick
      );
  }

  void componentWillUnmount() {
    timer.cancel();
  }

  void componentDidMount(HtmlElement rootNode) {
      rootNode.style.backgroundColor = "#FFAAAA";
  }

  bool shouldComponentUpdate(nextProps, nextState) {
    print("Next state: $nextState, props: $nextProps");
    print("Old state: $state, props: $props");
    return nextState['secondsElapsed'] % 2 == 1;
  }

  void componentWillReceiveProps(nextProps) {
    print("Received props: $nextProps");
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }

  render() {
    return react.span(
        { 'onClick': (event, domid) => print("Hello World!") },
//        { 'onClick': (event, [domid = null]) => print("Hello World!") },
        [ "Seconds elapsed: ", "${state['secondsElapsed']}"]
    );
  }
}

var clockComponent = react.registerComponent(() => new _ClockComponent());

class _ListComponent extends react.Component {

  dynamic getInitialState() {
    return {"items": new List.from([0, 1, 2, 3])};
  }

  void componentWillUpdate(nextProps, nextState) {
    if(nextState["items"].length > state["items"].length)
      print("Adding " + nextState["items"].last.toString());
  }

  void componentDidUpdate(prevProps, prevState, rootNode) {
    if(prevState["items"].length > state["items"].length)
      print("Removed " + prevState["items"].first.toString());
  }

  int iterator = 3;

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(++iterator);
    setState({"items": items});
  }

  dynamic render() {
    var items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": item}, "$item"));
    }

    return react.div({}, [
        react.button({"onClick": addItem}, "addItem"),
        react.ul({}, items),
    ]);
  }
}

var listComponent = react.registerComponent(() => new _ListComponent());

class _MainComponent extends react.Component {

  render() {
    return react.div({'ref': 'myDiv'}, props['children']);
  }
}

var mainComponent = react.registerComponent(() => new _MainComponent());
