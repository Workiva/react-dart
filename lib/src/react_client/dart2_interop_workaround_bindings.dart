@JS()
library react_client.src.dart2_interop_workaround_bindings;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';

@JS()
abstract class ReactDOM {
  @Deprecated('Deprecated in ReactJS v18.')
  external static Element findDOMNode(object);
  @Deprecated(
      'Deprecated in ReactJS v18. Use createRoot instead. See: https://github.com/reactwg/react-18/discussions/5')
  external static ReactComponent render(ReactElement component, Element element);
  @Deprecated(
      'Deprecated in ReactJS v18. Call root.unmount() after assigning root to the return value of createRoot().')
  external static bool unmountComponentAtNode(Element element);
  external static ReactPortal createPortal(dynamic children, Element container);
}
