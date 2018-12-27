import "package:react/react_server.dart";
import "package:react/react_dom_server.dart" as react_dom_server;

import "react_test_components.dart";

void main() {
  setServerConfiguration();
  print(react_dom_server.renderToString(mainComponent({}, [
    helloGreeter({}, []),
    listComponent({}, []),
    //clockComponent({}, []),
    checkBoxComponent({}, [])
  ])));
}
