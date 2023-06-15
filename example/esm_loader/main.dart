import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';

void main() async {
  await reactModuleLoader.initJsModuleFromAsyncImport();

  final content = react.span({}, 'This was rendered with react-dart loaded from Dart as an ESM module 🎉');
  react_dom.render(content, querySelector('#main'));
}
