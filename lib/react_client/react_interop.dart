/// JS interop classes for main React JS APIs and react-dart internals.
///
/// For use in `react_client.dart` and by advanced react-dart users.
library react_client.react_interop;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart' show Component;

// ----------------------------------------------------------------------------
//   Top-level API
// ----------------------------------------------------------------------------

@JS()
abstract class React {
  external static ReactClass createClass(ReactClassConfig reactClassConfig);
  external static Function createFactory(type);

  external static ReactElement createElement(dynamic type, props, [dynamic children]);

  external static bool isValidElement(dynamic object);
}

@JS('ReactDOM')
abstract class ReactDom {
  external static Element findDOMNode(object);
  external static ReactComponent render(ReactElement component, Element element);
  external static bool unmountComponentAtNode(Element element);
}

@JS('ReactDOMServer')
abstract class ReactDomServer {
  external static String renderToString(ReactElement component);
  external static String renderToStaticMarkup(ReactElement component);
}

// ----------------------------------------------------------------------------
//   Types and data structures
// ----------------------------------------------------------------------------

@JS()
@anonymous
class ReactClass {
  external String get displayName;
  external set displayName(String value);
}

@JS()
@anonymous
class ReactClassConfig {
  external factory ReactClassConfig({
    String displayName,
    Function componentWillMount,
    Function componentDidMount,
    Function componentWillReceiveProps,
    Function shouldComponentUpdate,
    Function componentWillUpdate,
    Function componentDidUpdate,
    Function componentWillUnmount,
    Function getDefaultProps,
    Function getInitialState,
    Function render
  });
}

/// Interop class for the data structure at `ReactElement._store`.
///
/// Used to validate variadic children before they get to [React.createElement].
@JS()
@anonymous
class ReactElementStore {
  external bool get validated;
  external set validated(bool value);
}


@JS()
@anonymous
class ReactElement<TComponent extends Component> {
  external ReactElementStore get _store;

  external dynamic get type;
  external InteropProps get props;
  external String get key;
  external dynamic get ref;
}

@JS()
@anonymous
class ReactComponent {
  external InteropProps get props;
  external get refs;
  external void setState(state, [callback]);
  external void forceUpdate([callback]);
  @deprecated
  external setProps(props, [callback]);

  external bool isMounted();
}

// ----------------------------------------------------------------------------
//   Interop internals
// ----------------------------------------------------------------------------

@JS()
@anonymous
class InteropProps {
  external ReactDartComponentInternal get internal;
  external dynamic get key;
  external dynamic get ref;

  external set key(dynamic value);
  external set ref(dynamic value);

  external factory InteropProps({ReactDartComponentInternal internal, String key, dynamic ref});
}

class ReactDartComponentInternal {
  Component component;
  bool isMounted;
  Map props;
}

/// Mark each child in children as validated so that React doesn't emit key warnings.
///
/// ___Only for use with variadic children.___
///
/// Needs to be in the same library as [ReactElement] since `ReactElement._store`
/// is private due to package:js restrictions.
void markChildrenValidated(List<dynamic> children) {
  children.forEach((dynamic child) {
    // Use `isValidElement` since `is ReactElement` doesn't behave as expected.
    if (React.isValidElement(child)) {
      (child as ReactElement)._store?.validated = true;
    }
  });
}
