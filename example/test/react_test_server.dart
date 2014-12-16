import "package:react/react.dart" as react;
import "package:react/react_server.dart";

import "react_test_components.dart";

void main() {
  setServerConfiguration();
  print(react.renderToString(mainComponent({}, [
                                           helloGreeter({}, []),
                                           listComponent({}, []),
                                           //clockComponent({}, []),
                                           checkBoxComponent({}, [])
                                           ]
  )));
}