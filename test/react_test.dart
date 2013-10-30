import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:js";
import "dart:html";
import "dart:async";

class MyComponent extends react.Component {
  MyComponent(props, jsThis) : super(props, jsThis) {
    setState({'secondsElapsed': 0});
  }

  void componentWillMount() {
    new Timer.periodic(new Duration(milliseconds: 1000), this.tick);
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }
  JsObject render() {
    return react.span({'onClick': (event, domId) => window.alert("Hello World!")}, "Seconds elapsed: ${state['secondsElapsed']}");
  }
}

var myComponent = react.registerComponent((props, jsThis) => new MyComponent(props, jsThis));

void main() {
  setClientConfiguration();
  react.renderComponent(myComponent({}, {}), querySelector('#content'));
}