import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:js";
import "dart:html";
import "dart:async";

class _HelloComponent extends react.Component {

  _HelloComponent(props, jsThis) : super(props, jsThis);

  void componentWillReceiveProps(nextProps){
    if(nextProps["name"].length > 20) {
      window.alert("Too long Hello!");
    }
  }

  render() {
    return react.span({}, ["Hello ${props['name']}!"]);
  }
}

var helloComponent = react.registerComponent((props, jsThis) => new _HelloComponent(props, jsThis));

class _HelloGreater extends react.Component {

  _HelloGreater(props, jsThis) : super(props, jsThis);

  getInitialState() => {"name": "World"};


  render() {
    onChange(react.SyntheticEvent event) {
      setState({'name': event.target.value});
    }
    return react.div({}, [
        react.input({'defaultValue': state['name'], 'onChange': onChange}),
        helloComponent({'name': state['name']})
    ]);
  }
}

var helloGreater = react.registerComponent((props, jsThis) => new _HelloGreater(props, jsThis));

class _ClockComponent extends react.Component {

  Timer timer;

  _ClockComponent(props, jsThis) : super(props, jsThis);

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

  bool shouldComponentUpdate(nextProps, nextState) => nextState['secondsElapsed'] % 2 == 1;


  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }

  render() {
    return react.span(
        { 'onClick': (event, domId) => window.alert("Hello World!") },
        [ "Seconds elapsed: ", "${state['secondsElapsed']}"]
    );
  }
}

var clockComponent = react.registerComponent((props, jsThis) => new _ClockComponent(props, jsThis));

class _ListComponent extends react.Component {

  _ListComponent(props, jsThis): super(props, jsThis);

  dynamic getInitialState() {
    return {"items": new List.from([0, 1, 2, 3])};
  }

  void componentWillUpdate(nextProps, nextState){
    if(nextState["items"].length > state["items"].length)
      window.alert("Adding " + nextState["items"].last.toString());
  }

  void componentDidUpdate(prevProps, prevState, rootNode){
    if(prevState["items"].length > state["items"].length)
      window.alert("Removed " + prevState["items"].first.toString());
  }

  int iterator = 3;

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(++iterator);
    setState({"items": items});
  }

  JsObject render() {
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

var listComponent = react.registerComponent((props, jsThis) => new _ListComponent(props, jsThis));

class _MainComponent extends react.Component {

  _MainComponent(props, jsThis) : super(props, jsThis);
  render() {
    return react.div({}, [
        helloGreater({}, []),
        listComponent({}, [])
    ]);

  }
}

var mainComponent = react.registerComponent((props, jsThis) => new _MainComponent(props, jsThis));

void main() {
  setClientConfiguration();
  react.renderComponent(mainComponent({"name": "peter"}), querySelector('#content'));
}