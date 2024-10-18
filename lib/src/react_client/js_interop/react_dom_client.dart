@JS()
library react_client.js_interop.react_dom_client;

import 'dart:html';

import 'package:js/js.dart';
import '../create_root.dart' show JsCreateRootOptions, ReactRoot;

@JS()
abstract class ReactDOMClient {
  external static ReactRoot createRoot(/*Element|DocumentFragment*/ Node container, [JsCreateRootOptions? options]);
}
