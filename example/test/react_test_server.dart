import "package:react/react_server.dart";
import "package:react/react_dom_server.dart" as reactDomServer;
import "react_test_components.dart";

void main() {
  setServerConfiguration();
  print(reactDomServer.renderToString(mainComponent({}, [
                                           helloGreeter({}, []),
                                           listComponent({}, []),
                                           //clockComponent({}, []),
                                           checkBoxComponent({}, [])
                                           ]
  )));
}
