import "dart:html";

import "package:react/react_dom.dart" as react_dom;
import "package:react/react_client.dart";

import "react_test_components.dart";

void main() {
  setClientConfiguration();
  react_dom.render(mainComponent({}, [
                                            helloGreeter({}, []),
                                            listComponent({}, []),
                                            //clockComponent({"name": 'my-clock'}, []),
                                            checkBoxComponent({}, [])
                                          ]
    ), querySelector('#content'));
}
