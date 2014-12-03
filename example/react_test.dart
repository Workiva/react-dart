import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";

import "react_test_components.dart";

void main() {
  setClientConfiguration();
  react.render(mainComponent({}, [
                                            helloGreeter({}, []),
                                            listComponent({}, []),
                                            //clockComponent({"name": 'my-clock'}, []),
                                            checkBoxComponent({}, [])
                                          ]
    ), querySelector('#content'));
}