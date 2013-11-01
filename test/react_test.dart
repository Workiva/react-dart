import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:js";
import "dart:html";
import "dart:async";

class MyComponent extends react.Component {
  MyComponent(props, jsThis) : super(props, jsThis) {
    setState({'secondsElapsed': 0});
  }
  
  Timer timer;

  void componentWillMount() {
    timer = new Timer.periodic(new Duration(milliseconds: this.props["duration"]), this.tick);
  }

  void componentWillUnmount() {
    timer.cancel();
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }
  JsObject render() {
    return react.span(
        { 'onClick': (event, domId) => window.alert("Hello World!") },
        [ "Seconds elapsed: ", "${state['secondsElapsed']}" ]
    );
  }
}

var myComponent = react.registerComponent((props, jsThis) => new MyComponent(props, jsThis));

class MyOtherComponent extends react.Component {
  MyOtherComponent(props, jsThis): super(props, jsThis){
    setState({"items": new List.from([0, 1, 2, 3]), "state": "steteeee", "myComponent": myComponent});
  }
  
  int iterator = 3;

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(++iterator);
    setState({"items": items});
  }
  
  void removeItem(event) {
    List items = new List.from(state["items"]);
    items.removeAt(0);
    setState({"items": items});
  }
  
  JsObject render() {
    List itemLis = new List<JsObject>();
    List items = new List.from(state["items"]);
    items.forEach(
        (item) => itemLis.add(react.li({"key": item}, item.toString()))
            );
    
    
    return react.div({}, [
        react.button({"onClick": addItem }, "addItem"),
        react.button({"onClick": removeItem }, "removeItem"),
        react.ul({}, itemLis),
        react.div({}, "name is ${this.props["name"]}"),
        react.a({"href": "http://google.com", "onClick": (react.SyntheticEvent e) => e.preventDefault()}, " google "),
        react.a({"href": "http://google.com", "onClick": (react.SyntheticEvent e) => window.alert("google 2 click")}, " google2 "),
        myComponent({"duration": 1000}, [])
    ]); 
  }
}

var myOtherComponent = react.registerComponent((props, jsThis) => new MyOtherComponent(props, jsThis));

void main() {
  setClientConfiguration();
  react.renderComponent(myOtherComponent({"name": "peter"}), querySelector('#content'));
}