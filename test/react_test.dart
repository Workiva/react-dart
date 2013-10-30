import "package:react/react.dart" as react;
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
    return react.div({}, "Seconds elapsed: ${state['secondsElapsed']}");
  }
}

var myComponent = react.registerComponent((props, jsThis) => new MyComponent(props, jsThis));

void main() {
  react.renderComponent(myComponent({}, {}), querySelector('#content'));
}