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

class _HelloGreeter extends react.Component {

  getInitialState() => {"name": "World"};

  render() {
    return react.div({}, [
        react.input({'value': bind('name')}),
        helloComponent({'name': state['name']})
    ]);
  }
}

var helloGreeter = react.registerComponent(() => new _HelloGreeter());

class _CheckBoxComponent extends react.Component {
  getInitialState() => {"checked": false};

  change(e){
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

  bool shouldComponentUpdate(nextProps, nextState) => nextState['secondsElapsed'] % 2 == 1;


  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }

  render() {
    return react.span(
        { 'onClick': (event, domid) => window.alert("Hello World!") },
//        { 'onClick': (event, [domid = null]) => window.alert("Hello World!") },
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
                                            helloGreeter({}, []),
                                            listComponent({}, []),
                                            //clockComponent({}, []),
                                            checkBoxComponent({}, [])
                                          ]
    ), querySelector('#content'));
}