// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.lifecycle_test.function_component;

import "package:js/js.dart";
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'util.dart';

ReactDartFunctionComponentFactoryProxy PropsTest = react.registerFunctionComponent(_PropsTest);

_PropsTest(Map props) {
  return [props['testProp'], props['children']];
}
