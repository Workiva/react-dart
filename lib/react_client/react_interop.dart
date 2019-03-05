/// JS interop classes for main React JS APIs and react-dart internals.
///
/// For use in `react_client.dart` and by advanced react-dart users.
@JS()
library react_client.react_interop;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart' show ComponentFactory;
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/src/react_client/js_backed_map.dart';
import 'package:react/src/react_client/dart2_interop_workaround_bindings.dart';

typedef ReactElement ReactJsComponentFactory(props, children);

// ----------------------------------------------------------------------------
//   Top-level API
// ----------------------------------------------------------------------------

@JS()
abstract class React {
  external static String get version;
  external static ReactClass createClass(ReactClassConfig reactClassConfig);
  external static ReactJsComponentFactory createFactory(type);

  external static ReactElement createElement(dynamic type, props,
      [dynamic children]);

  external static bool isValidElement(dynamic object);
}

abstract class ReactDom {
  static Element findDOMNode(object) => ReactDOM.findDOMNode(object);
  static ReactComponent render(ReactElement component, Element element) =>
      ReactDOM.render(component, element);
  static bool unmountComponentAtNode(Element element) =>
      ReactDOM.unmountComponentAtNode(element);
}

@JS('ReactDOMServer')
abstract class ReactDomServer {
  external static String renderToString(ReactElement component);
  external static String renderToStaticMarkup(ReactElement component);
}

// ----------------------------------------------------------------------------
//   Types and data structures
// ----------------------------------------------------------------------------

/// A React class specification returned by [React.createClass].
///
/// To be used as the value of [ReactElement.type], which is set upon initialization
/// by a component factory or by [React.createElement].
///
/// See: <http://facebook.github.io/react/docs/top-level-api.html#react.createclass>
@JS()
@anonymous
class ReactClass {
  external JsMap get defaultProps;
  external set defaultProps(JsMap value);

  /// The `displayName` string is used in debugging messages.
  ///
  /// See: <http://facebook.github.io/react/docs/component-specs.html#displayname>
  external String get displayName;
  external set displayName(String value);

  /// The cached, unmodifiable copy of [Component.getDefaultProps] computed in
  /// [registerComponent].
  ///
  /// For use in [ReactDartComponentFactoryProxy] when creating new [ReactElement]s,
  /// or for external use involving inspection of Dart prop defaults.
  @Deprecated('6.0.0')
  external Map get dartDefaultProps;
  @Deprecated('6.0.0')
  external set dartDefaultProps(Map value);

  external String get dartComponentVersion;
  external set dartComponentVersion(String value);
}

/// A JS interop class used as an argument to [React.createClass].
///
/// See: <http://facebook.github.io/react/docs/top-level-api.html#react.createclass>.
@JS()
@anonymous
class ReactClassConfig {
  external factory ReactClassConfig(
      {String displayName,
      List mixins,
      Function componentWillMount,
      Function componentDidMount,
      Function componentWillReceiveProps,
      Function shouldComponentUpdate,
      Function componentWillUpdate,
      Function componentDidUpdate,
      Function componentWillUnmount,
      Function getDefaultProps,
      Function getInitialState,
      Function render});

  /// The `displayName` string is used in debugging messages.
  ///
  /// See: <http://facebook.github.io/react/docs/component-specs.html#displayname>
  external String get displayName;
  external set displayName(String value);
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

/// A virtual instance of a React component that is returned by component
/// factories and `Component.render` methods, and passed into [react.render].
///
/// See <http://facebook.github.io/react/docs/glossary.html#react-elements>
/// and <http://facebook.github.io/react/docs/glossary.html#react-components>.
@JS()
@anonymous
class ReactElement {
  external ReactElementStore get _store; // ignore: unused_element

  /// The type of this element.
  ///
  /// For DOM components, this will be a [String] tagName (e.g., `'div'`, `'a'`).
  ///
  /// For composite components (react-dart or pure JS), this will be a [ReactClass].
  external dynamic get type;

  /// The props this element was created with.
  external InteropProps get props;

  /// This element's `key`, which is used to uniquely identify it among its siblings.
  ///
  /// Not needed when children are passed variadically.
  ///
  /// See: <http://facebook.github.io/react/docs/reconciliation.html#keys>.
  external String get key;

  /// This element's `ref`, which can be used to access the associated
  /// [Component]/[ReactComponent]/[Element] after it has been rendered.
  ///
  /// See: <http://facebook.github.io/react/docs/more-about-refs.html>.
  external dynamic get ref;
}

/// The JavaScript component instance, which backs each react-dart [Component].
///
/// See: <http://facebook.github.io/react/docs/glossary.html#react-components>
@JS()
@anonymous
class ReactComponent {
  external Component get dartComponent;
  external InteropProps get props;
  external InteropProps get state;
  external get refs;
  external void setState(state, [callback]);
  external void forceUpdate([callback]);

  external bool isMounted();
}

// ----------------------------------------------------------------------------
//   Interop internals
// ----------------------------------------------------------------------------

/// A JavaScript interop class representing a value in a React JS `context` object.
///
/// Used for storing/accessing Dart [ReactDartContextInternal] objects in `context`
/// in a way that's opaque to the JS, and avoids the need to use dart2js interceptors.
///
/// __For internal/advanced use only.__
@JS()
@anonymous
class InteropContextValue {
  external factory InteropContextValue();
}

/// A JavaScript interop class representing a React JS `props` object.
///
/// Used for storing/accessing [ReactDartComponentInternal] objects in
/// react-dart [ReactElement]s and [ReactComponent]s, as well as for preparing
/// reserved props (`key` and `ref`) for consumption by ReactJS.
///
/// __For internal/advanced use only.__
@JS()
@anonymous
class InteropProps {
  @Deprecated('3.0.0')
  external ReactDartComponentInternal get internal;
  external dynamic get key;
  external dynamic get ref;

  external set key(dynamic value);
  external set ref(dynamic value);

  @Deprecated('3.0.0')
  external factory InteropProps({
    ReactDartComponentInternal internal,
    String key,
    dynamic ref,
  });
}

/// Internal react-dart information used to proxy React JS lifecycle to Dart
/// [Component] instances.
///
/// __For internal/advanced use only.__
class ReactDartComponentInternal {
  /// For a `ReactElement`, this is the initial props with defaults merged.
  ///
  /// For a `ReactComponent`, this is the props the component was last rendered with,
  /// and is used within props-related lifecycle internals.
  Map props;
}

/// Internal react-dart information used to proxy React JS lifecycle to Dart
/// [Component] instances.
///
/// __For internal/advanced use only.__
class ReactDartContextInternal {
  final dynamic value;

  ReactDartContextInternal(this.value);
}

/// Marks [child] as validated, as if it were passed into [React.createElement]
/// as a variadic child.
///
/// Offloaded to the JS to avoid dart2js interceptor lookup.
@JS('_markChildValidated')
external void markChildValidated(child);

/// Mark each child in [children] as validated so that React doesn't emit key warnings.
///
/// ___Only for use with variadic children.___
void markChildrenValidated(List<dynamic> children) {
  children.forEach((dynamic child) {
    // Use `isValidElement` since `is ReactElement` doesn't behave as expected.
    if (React.isValidElement(child)) {
      markChildValidated(child);
    }
  });
}

/// Returns a new JS [ReactClassConfig] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
@JS('_createReactDartComponentClass')
external ReactClass createReactDartComponentClass(
    ReactDartInteropStatics dartInteropStatics,
    ComponentStatics componentStatics,
    [JsComponentConfig jsConfig]);

/// Returns a new JS [ReactClassConfig] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
@JS('_createReactDartComponentClass2')
external ReactClass createReactDartComponentClass2(
  ReactDartInteropStatics2 dartInteropStatics,
  ComponentStatics<Component2> componentStatics,
);
typedef Component _InitComponent(
    ReactComponent jsThis,
    ReactDartComponentInternal internal,
    InteropContextValue context,
    ComponentStatics componentStatics);
typedef InteropContextValue _HandleGetChildContext(Component component);
typedef void _HandleComponentWillMount(Component component);
typedef void _HandleComponentDidMount(Component component);
typedef void _HandleComponentWillReceiveProps(Component component,
    ReactDartComponentInternal nextInternal, InteropContextValue nextContext);
typedef bool _HandleShouldComponentUpdate(
    Component component, InteropContextValue nextContext);
typedef void _HandleComponentWillUpdate(
    Component component, InteropContextValue nextContext);
// Ignore prevContext in componentDidUpdate, since it's not supported in React 16
typedef void _HandleComponentDidUpdate(
    Component component, ReactDartComponentInternal prevInternal);
typedef void _HandleComponentWillUnmount(Component component);
typedef dynamic _HandleRender(Component component);

typedef Component _InitComponent2(
    ReactComponent jsThis, ComponentStatics<Component2> componentStatics);
typedef dynamic _HandleGetInitialState2(Component2 component);
typedef void _HandleComponentWillMount2(
    Component2 component, ReactComponent jsThis);
typedef void _HandleComponentDidMount2(Component2 component);
typedef void _HandleComponentWillReceiveProps2(
    Component2 component, JsMap jsNextProps);
typedef bool _HandleShouldComponentUpdate2(
    Component2 component, JsMap jsNextProps, JsMap jsNextState);
typedef void _HandleComponentWillUpdate2(
    Component2 component, JsMap jsNextProps, JsMap jsNextState);
// Ignore prevContext in componentDidUpdate, since it's not supported in React 16
typedef void _HandleComponentDidUpdate2(Component2 component,
    ReactComponent jsThis, JsMap jsPrevProps, JsMap jsPrevState);
typedef void _HandleComponentWillUnmount2(Component2 component);
typedef dynamic _HandleRender2(Component2 component);

@JS('React.__isDevelopment')
external bool get _inReactDevMode;

/// Whether the "dev" build of react.js is being used.
///
/// Useful for creating conditional logic based on whether your application is being served in a production environment.
///
///     if (inReactDevMode) {
///       print('Debug info that only developers should see.');
///     }
///
/// > This value will be `true` if your HTML page includes `react.js` or `react_with_addons.js`,
///   and `false` if your HTML page includes `react_prod.js` or `react_with_react_dom_prod.js`.
bool get inReactDevMode => _inReactDevMode;

/// An object that stores static methods used by all Dart components.
///
/// __Deprecated.__ Use [ReactDartInteropStatics2] instead.
///
/// Will be removed when [Component] is removed in the `6.0.0` release.
@JS()
@anonymous

@Deprecated('6.0.0')
class ReactDartInteropStatics {
  external factory ReactDartInteropStatics({
    _InitComponent initComponent,
    _HandleGetChildContext handleGetChildContext,
    _HandleComponentWillMount handleComponentWillMount,
    _HandleComponentDidMount handleComponentDidMount,
    _HandleComponentWillReceiveProps handleComponentWillReceiveProps,
    _HandleShouldComponentUpdate handleShouldComponentUpdate,
    _HandleComponentWillUpdate handleComponentWillUpdate,
    _HandleComponentDidUpdate handleComponentDidUpdate,
    _HandleComponentWillUnmount handleComponentWillUnmount,
    _HandleRender handleRender,
  });
}

/// An object that stores static methods used by all Dart components.
@JS()
@anonymous
class ReactDartInteropStatics2 implements ReactDartInteropStatics {
  external factory ReactDartInteropStatics2({
    _InitComponent2 initComponent,
    _HandleGetInitialState2 handleGetInitialState,
    _HandleComponentWillMount2 handleComponentWillMount,
    _HandleComponentDidMount2 handleComponentDidMount,
    _HandleComponentWillReceiveProps2 handleComponentWillReceiveProps,
    _HandleShouldComponentUpdate2 handleShouldComponentUpdate,
    _HandleComponentWillUpdate2 handleComponentWillUpdate,
    _HandleComponentDidUpdate2 handleComponentDidUpdate,
    _HandleComponentWillUnmount2 handleComponentWillUnmount,
    _HandleRender2 handleRender,
  });
}

/// An object that stores static methods and information for a specific component class.
///
/// This object is made accessible to a component's JS ReactClass config, which
/// passes it to certain methods in [ReactDartInteropStatics].
///
/// See [ReactDartInteropStatics], [createReactDartComponentClass].
// TODO: Do we need a version 2 of this?
class ComponentStatics<T extends Component> {
  final ComponentFactory<T> componentFactory;

  ComponentStatics(this.componentFactory);
}

/// Additional configuration passed to [createReactDartComponentClass]
/// that needs to be directly accessible by that JS code.
@JS()
@anonymous
class JsComponentConfig {
  external factory JsComponentConfig({
    Iterable<String> childContextKeys,
    Iterable<String> contextKeys,
    EmptyObject defaultProps2,
  });
}
