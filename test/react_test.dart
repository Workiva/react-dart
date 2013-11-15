import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:js";
import "dart:html";
import "dart:async";

class MyComponent extends react.Component {
  MyComponent(props, jsThis) : super(props, jsThis) {
  }
  
  dynamic getInitialState() => {'secondsElapsed': 0, 'tooLong': false};

  dynamic getDefaultProps() => {'duration': 1000};

  
  Timer timer;

  void componentWillMount() {
    timer = new Timer.periodic(new Duration(milliseconds: this.props["duration"]), this.tick);
  }
  
  void componentDidMount(HtmlElement rootNode) {
    if(state["tooLong"])
      rootNode.style.backgroundColor = "#FFAAAA";
    else
      rootNode.style.backgroundColor = "#AAFFAA";
  }
  
  /**
   * after first 10 seconds when receive props, change text to say tool logn
   */
  void componentWillReceiveProps(nextProps){
    if(nextProps["duration"] > 1000)
      setState({"tooLong": true});
  }
  
  bool shouldComponentUpdate(nextProps, nextState) => nextState['secondsElapsed'] % 2 == 1;

  void componentWillUnmount() {
    timer.cancel();
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }
  JsObject render() {
    return react.span(
        { 'onClick': (event, domId) => window.alert("Hello World!") },
        [ "Seconds elapsed: ", "${state['secondsElapsed']}", state["tooLong"] ? " too long duration" : " not too long duration" ]
    );
  }
}

var myComponent = react.registerComponent((props, jsThis) => new MyComponent(props, jsThis));

class MyOtherComponent extends react.Component {
  MyOtherComponent(props, jsThis): super(props, jsThis){
  }
  
  dynamic getInitialState(){
    return     {"items": new List.from([0, 1, 2, 3]), "state": "steteeee", "myComponent": myComponent};
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
        myComponent({}, []),
        myComponent({'duration': 10000}, []),
    ]); 
  }
}

var myOtherComponent = react.registerComponent((props, jsThis) => new MyOtherComponent(props, jsThis));

void main() {
  setClientConfiguration();
  react.renderComponent(myOtherComponent({"name": "peter"}), querySelector('#content'));
}