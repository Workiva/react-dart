/// JS interop classes for main React JS APIs and react-dart internals.
///
/// For use in `react_client.dart` and by advanced react-dart users.
@JS()
library react_client.react_interop;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart';
import 'package:react/react_client.dart' show ComponentFactory;
import 'package:react/src/react_client/js_backed_map.dart';
import 'package:react/src/react_client/dart2_interop_workaround_bindings.dart';

typedef ReactElement ReactJsComponentFactory(props, children);

// ----------------------------------------------------------------------------
//   Top-level API
// ----------------------------------------------------------------------------

@JS()
abstract class React {
  external static String get version;
  external static ReactContext createContext([
    dynamic defaultValue,
    int Function(dynamic currentValue, dynamic nextValue) calculateChangedBits,
  ]);
  @Deprecated('6.0.0')
  external static ReactClass createClass(ReactClassConfig reactClassConfig);
  external static ReactJsComponentFactory createFactory(type);

  external static ReactElement createElement(dynamic type, props, [dynamic children]);

  external static bool isValidElement(dynamic object);
}

abstract class ReactDom {
  static Element findDOMNode(object) => ReactDOM.findDOMNode(object);
  static ReactComponent render(ReactElement component, Element element) => ReactDOM.render(component, element);
  static bool unmountComponentAtNode(Element element) => ReactDOM.unmountComponentAtNode(element);
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
///
/// > __DEPRECATED.__
/// >
/// > Will be removed alongside [React.createClass] in the `6.0.0` release.
@Deprecated('6.0.0')
@JS()
@anonymous
class ReactClassConfig {
  external factory ReactClassConfig({
    String displayName,
    List mixins,
    Function componentWillMount,
    Function componentDidMount,
    Function componentWillReceiveProps,
    Function shouldComponentUpdate,
    Function componentWillUpdate,
    Function componentDidUpdate,
    Function componentWillUnmount,
    Function getChildContext,
    Map<String, dynamic> childContextTypes,
    Function getDefaultProps,
    Function getInitialState,
    Function render,
  });

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
  // TODO: Cast as Component2 in 6.0.0
  external Component get dartComponent;
  external InteropProps get props;
  external dynamic get context;
  external JsMap get state;
  external get refs;
  external void setState(state, [callback]);
  external void forceUpdate([callback]);
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
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
/// > in ReactJS 16 that is exposed via the [Component2] class.
/// >
/// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
@Deprecated('6.0.0')
@JS()
@anonymous
class InteropContextValue {
  external factory InteropContextValue();
}

/// A JavaScript interop class representing the return value of `createContext`.
///
/// Used for accessing Dart [Context.Provider] & [Context.Consumer] components.
///
/// __For internal/advanced use only.__
@JS()
@anonymous
class ReactContext {
  external ReactClass get Provider;
  external ReactClass get Consumer;
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
class InteropProps implements JsMap {
  /// __Deprecated.__
  ///
  /// This has been deprecated along with `Component` since its
  /// replacement - `Component2` utilizes JS Maps for props,
  /// making `internal` obsolete.
  ///
  /// Will be removed alongside `Component` in the `6.0.0` release.
  @Deprecated('6.0.0')
  external ReactDartComponentInternal get internal;
  external dynamic get key;
  external dynamic get ref;

  external set key(dynamic value);
  external set ref(dynamic value);

  /// __Deprecated.__
  ///
  /// This has been deprecated along with `Component` since its
  /// replacement - `Component2` utilizes JS Maps for props,
  /// making `InteropProps` obsolete.
  ///
  /// Will be removed alongside `Component` in the `6.0.0` release.
  @Deprecated('6.0.0')
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
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
/// > in ReactJS 16 that is exposed via the [Component2] class.
/// >
/// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
@Deprecated('6.0.0')
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

/// Returns a new JS [ReactClass] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
///
/// > __DEPRECATED.__
/// >
/// > Will be removed in `6.0.0` alongside [Component].
@JS('_createReactDartComponentClass')
@Deprecated('6.0.0')
external ReactClass createReactDartComponentClass(
    ReactDartInteropStatics dartInteropStatics, ComponentStatics componentStatics,
    [JsComponentConfig jsConfig]);

/// Returns a new JS [ReactClass] for a component that uses
/// [dartInteropStatics] and [componentStatics] internally to proxy between
/// the JS and Dart component instances.
@JS('_createReactDartComponentClass2')
external ReactClass createReactDartComponentClass2(
    ReactDartInteropStatics2 dartInteropStatics, ComponentStatics2 componentStatics,
    [JsComponentConfig2 jsConfig, List<String> skipMethods]);

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
    Component Function(
      ReactComponent jsThis,
      ReactDartComponentInternal internal,
      InteropContextValue context,
      ComponentStatics componentStatics,
    )
        initComponent,
    InteropContextValue Function(Component component) handleGetChildContext,
    void Function(Component component) handleComponentWillMount,
    void Function(Component component) handleComponentDidMount,
    void Function(
      Component component,
      ReactDartComponentInternal nextInternal,
      InteropContextValue nextContext,
    )
        handleComponentWillReceiveProps,
    bool Function(Component component, InteropContextValue nextContext) handleShouldComponentUpdate,
    void Function(Component component, InteropContextValue nextContext) handleComponentWillUpdate,
    void Function(Component component, ReactDartComponentInternal prevInternal) handleComponentDidUpdate,
    void Function(Component component) handleComponentWillUnmount,
    dynamic Function(Component component) handleRender,
  });
}

/// An object that stores static methods used by all Dart components.
@JS()
@anonymous
class ReactDartInteropStatics2 implements ReactDartInteropStatics {
  external factory ReactDartInteropStatics2({
    Component2 Function(ReactComponent jsThis, ComponentStatics2 componentStatics) initComponent,
    // TODO: Should this have a return signature of `Map`?
    dynamic Function(Component2 component) handleGetInitialState,
    void Function(Component2 component, ReactComponent jsThis) handleComponentWillMount,
    void Function(Component2 component) handleComponentDidMount,
    // TODO: Should this be removed when we update Component2.componentWillReceiveProps to throw an UnsupportedError? (CPLAT-4765)
    void Function(
      Component2 component,
      JsMap jsNextProps,
    )
        handleComponentWillReceiveProps,
    bool Function(
      Component2 component,
      JsMap jsNextProps,
      JsMap jsNextState,
      dynamic jsNextContext,
    )
        handleShouldComponentUpdate,
    // TODO: Should this be removed when we update Component2.componentWillUpdate to throw an UnsupportedError? (CPLAT-4766)
    void Function(
      Component2 component,
      JsMap jsPrevProps,
      JsMap jsPrevState,
    )
        handleGetSnapshotBeforeUpdate,
    void Function(
      Component2 component,
      ReactComponent jsThis,
      JsMap jsPrevProps,
      JsMap jsPrevState,
      dynamic snapshot,
    )
        handleComponentDidUpdate,
    void Function(Component2 component) handleComponentWillUnmount,
    void Function(Component2 component, dynamic error, dynamic info) handleComponentDidCatch,
    JsMap Function(ComponentStatics2 componentInstance, dynamic error) handleGetDerivedStateFromError,
    dynamic Function(Component2 component, JsMap jsProps, JsMap jsState, dynamic jsContext) handleRender,
  });
}

/// An object that stores static methods and information for a specific component class.
///
/// This object is made accessible to a component's JS ReactClass config, which
/// passes it to certain methods in [ReactDartInteropStatics].
///
/// See [ReactDartInteropStatics], [createReactDartComponentClass].
class ComponentStatics<T extends Component> {
  final ComponentFactory<T> componentFactory;
  ComponentStatics(this.componentFactory);
}

/// An object that stores static methods and information for a specific component class.
///
/// This object is made accessible to a component's JS ReactClass config, which
/// passes it to certain methods in [ReactDartInteropStatics2].
///
/// [ComponentStatics2] exists in addition to [ComponentStatics] because
/// [Component2] brings new static lifecycle methods that are exposted via
/// `componentInstace`. Because [Component] does not need an instance to pull
/// static lifecycle methods from, it made sense to create [ComponentStatics2].
///
/// See [ReactDartInteropStatics2], [createReactDartComponentClass2].
class ComponentStatics2 {
  final ComponentFactory<Component2> componentFactory;
  final Component2 instanceForStaticMethods;
  ComponentStatics2(this.componentFactory, {this.instanceForStaticMethods});
}

/// Additional configuration passed to [createReactDartComponentClass]
/// that needs to be directly accessible by that JS code.
///
/// > __DEPRECATED - DO NOT USE__
/// >
/// > The `context` API that this supports was never stable in any version of ReactJS,
/// > and was replaced with a new, incompatible context API in ReactJS 16 that is exposed
/// > via the [Component2] class and is supported by [JsComponentConfig2].
/// >
/// > This will be completely removed when the JS side of `context` it is slated for
/// > removal (ReactJS 17 / react.dart 6.0.0)
@Deprecated('6.0.0')
@JS()
@anonymous
class JsComponentConfig {
  external factory JsComponentConfig({
    Iterable<String> childContextKeys,
    Iterable<String> contextKeys,
  });
}

/// Additional configuration passed to [createReactDartComponentClass2]
/// that needs to be directly accessible by that JS code.
@JS()
@anonymous
class JsComponentConfig2 {
  external factory JsComponentConfig2({
    dynamic contextType,
    JsMap defaultProps,
  });
}
