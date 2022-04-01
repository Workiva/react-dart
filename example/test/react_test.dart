import "dart:html";

import "package:react/react_dom.dart" as react_dom;

import "react_test_components.dart";

void main() {
  final root = react_dom.createRoot(querySelector('#content'));
  root.render(mainComponent({}, [
    helloGreeter({'key': 'hello'}, []),
    listComponent({'key': 'list'}, []),
    component2TestComponent({'key': 'c2-list'}, []),
    component2ErrorTestComponent({'key': 'error-boundary'}, []),
    //clockComponent({"name": 'my-clock'}, []),
    checkBoxComponent({'key': 'checkbox'}, [])
  ]));
}
