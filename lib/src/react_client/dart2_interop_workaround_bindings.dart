@JS()
library react_client.src.dart2_interop_workaround_bindings;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/typedefs.dart';

@JS()
abstract class ReactDOM {
  external static Element? findDOMNode(ReactNode object);
  external static ReactNode render(ReactNode component, Element element);
  external static bool unmountComponentAtNode(Element element);
  external static ReactPortal createPortal(ReactNode children, Element container);
}
