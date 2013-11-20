import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:js";
import "dart:html";
import "dart:async";

class _HelloComponent extends react.Component {

  void componentWillReceiveProps(nextProps){
    if(nextProps["name"].length > 20) {
      window.alert("Too long Hello!");
    }
  }

  render() {
    return react.span({}, ["Hello ${props['name']}!"]);
  }
}

var helloComponent = react.registerComponent(() => new _HelloComponent());

class _HelloGreater extends react.Component {

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

var helloGreater = react.registerComponent(() => new _HelloGreater());

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

var clockComponent = react.registerComponent(() => new _ClockComponent());

class _ListComponent extends react.Component {

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

var listComponent = react.registerComponent(() => new _ListComponent());

class _MainComponent extends react.Component {

  render() {
    return react.div({}, props['children']);
  }
}

var mainComponent = react.registerComponent(() => new _MainComponent());

void main() {
  setClientConfiguration();
  react.renderComponent(mainComponent({}, [
                                            helloGreater({}, []),
                                            listComponent({}, [])
                                          ]
    ), querySelector('#content'));
}