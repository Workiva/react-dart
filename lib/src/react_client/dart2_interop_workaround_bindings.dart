@JS()
library react_client.src.dart2_interop_workaround_bindings;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';

@JS()
abstract class ReactDOM {
  external static Element? findDOMNode(dynamic object);
  external static ReactComponent render(dynamic component, Element element);
  external static bool unmountComponentAtNode(Element element);
  external static ReactPortal createPortal(dynamic children, Element container);
}
