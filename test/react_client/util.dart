@JS()
library react.test.react_client.util;

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart' show React;
import 'package:react/react_client/js_interop_helpers.dart';

@JS('Object.freeze')
external void objectFreeze(JsMap object);

@JS()
external Function compositeComponent();

/// A factory for a JS composite component, for use in testing.
final Function testJsComponentFactory = (() {
  final type = compositeComponent();
  return ([props = const {}, children]) {
    return React.createElement(type, jsifyAndAllowInterop(props), listifyChildren(children));
  };
})();

// ignore: deprecated_member_use_from_same_package
class ThrowsInDefaultPropsComponent extends react.Component {
  @override
  Map getDefaultProps() => throw StateError('bad default props');

  @override
  render() {
    return null;
  }
}

class ThrowsInDefaultPropsComponent2 extends react.Component2 {
  get defaultProps => throw StateError('bad default props');

  @override
  render() {
    return null;
  }
}

class ThrowsInPropTypesComponent2 extends react.Component2 {
  get propTypes => throw StateError('bad prop types');

  @override
  render() {
    return null;
  }
}

class DartComponent2Component extends react.Component2 {
  @override
  render() {
    return null;
  }
}

final DartComponent2 = react.registerComponent2(() => new DartComponent2Component());

// ignore: deprecated_member_use_from_same_package
class DartComponentComponent extends react.Component {
  @override
  render() {
    return null;
  }
}

// ignore: deprecated_member_use_from_same_package
ReactDartComponentFactoryProxy DartComponent = react.registerComponent(() => new DartComponentComponent());
