import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

import "react_test_components.dart";

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