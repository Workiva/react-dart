// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

/// A Dart library for building UI using ReactJS.
library react;

import 'package:meta/meta.dart';
import 'package:react/react_client/bridge.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/src/prop_validator.dart';
import 'package:react/src/typedefs.dart';
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/context.dart';
import 'package:react/src/react_client/component_registration.dart' as registration_utils;
import 'package:react/src/react_client/private_utils.dart' show validateJsApi, validateJsApiThenReturn;

export 'package:react/src/context.dart';
export 'package:react/src/prop_validator.dart';
export 'package:react/src/react_client/event_helpers.dart';
export 'package:react/react_client/react_interop.dart' show forwardRef2, createRef, memo, memo2;
export 'package:react/src/react_client/synthetic_event_wrappers.dart' hide NonNativeDataTransfer;
export 'package:react/src/react_client/synthetic_data_transfer.dart' show SyntheticDataTransfer;
export 'package:react/src/react_client/event_helpers.dart';

/// A React component declared using a function that takes in [props] and returns rendered output.
///
/// See <https://reactjs.org/docs/components-and-props.html#function-and-class-components>.
///
/// [props] is typed as [JsBackedMap] so that dart2js can optimize props accesses.
typedef DartFunctionComponent = dynamic Function(JsBackedMap props);

/// The callback to a React forwardRef component. See [forwardRef2] for more details.
///
/// [props] is typed as [JsBackedMap] so that dart2js can optimize props accesses.
///
/// In the current JS implementation, the ref argument to [React.forwardRef] is usually a JsRef object no matter the input ref type,
/// but according to React the ref argument can be any ref type: https://github.com/facebook/flow/blob/master@%7B2020-09-08%7D/lib/react.js#L305
/// and not just a ref object, so we type [ref] as dynamic here.
typedef DartForwardRefFunctionComponent = dynamic Function(JsBackedMap props, dynamic ref);

typedef ComponentFactory<T extends Component> = T Function();

typedef ComponentRegistrar = ReactComponentFactoryProxy Function(ComponentFactory componentFactory,
    [Iterable<String> skipMethods]);

typedef ComponentRegistrar2 = ReactDartComponentFactoryProxy2 Function(
  ComponentFactory<Component2> componentFactory, {
  Iterable<String> skipMethods,
  Component2BridgeFactory? bridgeFactory,
});

typedef FunctionComponentRegistrar = ReactDartFunctionComponentFactoryProxy
    Function(DartFunctionComponent componentFactory, {String? displayName});

/// Fragment component that allows the wrapping of children without the necessity of using
/// an element that adds an additional layer to the DOM (div, span, etc).
///
/// See: <https://reactjs.org/docs/fragments.html>
var Fragment = ReactJsComponentFactoryProxy(React.Fragment);

/// [Suspense] lets you display a fallback UI until its children have finished loading.
///
/// Like [Fragment], [Suspense] does not render any visible UI.
/// It lets you specify a loading indicator in case some components in
/// the tree below it are not yet ready to render.
/// [Suspense] currently works with:
/// - Components that use React.lazy
///   - (dynamic imports, not currently implemented in dart)
///
/// Example Usage:
/// ```
/// render() {
///   return react.div({}, [
///     Header({}),
///     react.Suspense({'fallback': LoadingIndicator({})}, [
///       LazyBodyComponent({}),
///       NotALazyComponent({})
///     ]),
///     Footer({}),
///   ]);
/// }
/// ```
///
/// In the above example, [Suspense] will display the `LoadingIndicator` until
/// `LazyBodyComponent` is loaded. It will not display for `Header` or `Footer`.
///
/// However, any "lazy" descendant components in `LazyBodyComponent` and
/// `NotALazyComponent` will trigger the closest ancestor [Suspense].
///
/// See: <https://react.dev/reference/react/Suspense>
var Suspense = ReactJsComponentFactoryProxy(React.Suspense);

/// StrictMode is a tool for highlighting potential problems in an application.
///
/// StrictMode does not render any visible UI. It activates additional checks and warnings for its descendants.
///
/// See: <https://reactjs.org/docs/strict-mode.html>
var StrictMode = ReactJsComponentFactoryProxy(React.StrictMode);

// -------------------------------------------------------------------------------------------------------------------
// [1] While these fields are always initialized upon mount immediately after the class is instantiated,
//     since they're not passed into a Dart constructor, they can't be initialized during instantiation,
//     forcing us to make them either `late` or nullable.
//
//     Since we want them to be non-nullable, we'll opt for `late`.
//
//     These fields only haven't been initialized:
//      - for mounting component instances:
//         - in component class constructors (which we don't encourage)
//         - in component class field initializers (except for lazy `late` ones)
//      - in "static" lifecycle methods like `getDerivedStateFromProps` and `defaultProps`
//
//     So, this shouldn't pose a problem for consumers.
// -------------------------------------------------------------------------------------------------------------------

/// Top-level ReactJS [Component class](https://reactjs.org/docs/react-component.html)
/// which provides the [ReactJS Component API](https://reactjs.org/docs/react-component.html#reference)
///
/// __Deprecated. The Component base class only supports unsafe lifecycle methods,
/// which React JS will remove support for in a future major version.
/// Migrate components to [Component2], which only supports safe lifecycle methods.__
@Deprecated(
    'The Component base class only supports unsafe lifecycle methods, which React JS will remove support for in a future major version.'
    ' Migrate components to Component2, which only supports safe lifecycle methods.')
abstract class Component {
  Map? _context;

  /// A private field that backs [props], which is exposed via getter/setter so
  /// it can be overridden in strong mode.
  ///
  /// Necessary since the `@virtual` annotation within the meta package
  /// [doesn't work for overriding fields](https://github.com/dart-lang/sdk/issues/27452).
  ///
  /// TODO: Switch back to a plain field once this issue is fixed.
  late Map _props; // [1]

  /// A private field that backs [state], which is exposed via getter/setter so
  /// it can be overridden in strong mode.
  ///
  /// Necessary since the `@virtual` annotation within the meta package
  /// [doesn't work for overriding fields](https://github.com/dart-lang/sdk/issues/27452).
  ///
  /// TODO: Switch back to a plain field once this issue is fixed.
  Map _state = {};

  /// A private field that backs [ref], which is exposed via getter/setter so
  /// it can be overridden in strong mode.
  ///
  /// Necessary since the `@virtual` annotation within the meta package
  /// [doesn't work for overriding fields](https://github.com/dart-lang/sdk/issues/27452).
  ///
  /// TODO: Switch back to a plain field once this issue is fixed.
  late RefMethod _ref; // [1]

  /// The React context map of this component, passed down from its ancestors' [getChildContext] value.
  ///
  /// Only keys declared in this component's [contextKeys] will be present.
  ///
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  @experimental
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  dynamic get context => _context;

  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  @experimental
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  set context(dynamic value) => _context = value as Map;

  /// ReactJS [Component] props.
  ///
  /// Related: [state]
  // ignore: unnecessary_getters_setters
  Map get props => _props;
  set props(Map value) => _props = value;

  /// ReactJS [Component] state.
  ///
  /// Related: [props]
  // ignore: unnecessary_getters_setters
  Map get state => _state;
  set state(Map value) => _state = value;

  /// __DEPRECATED.__
  ///
  /// Support for String `ref`s will be removed in a future major release when `Component` is removed.
  ///
  /// Instead, use [createRef] or a [ref callback](https://react.dev/reference/react-dom/components/common#ref-callback).
  @Deprecated(
      'Only supported in the deprecated Component, and not Component2. Use createRef or a ref callback instead.')
  RefMethod get ref => _ref;

  /// __DEPRECATED.__
  ///
  /// Support for String `ref`s will be removed in a future major release when `Component` is removed.
  ///
  /// Instead, use [createRef] or a [ref callback](https://react.dev/reference/react-dom/components/common#ref-callback).
  @Deprecated(
      'Only supported in the deprecated Component, and not Component2. Use createRef or a ref callback instead.')
  set ref(RefMethod value) => _ref = value;

  late void Function() _jsRedraw; // [1]

  late dynamic _jsThis; // [1]

  final List<SetStateCallback> _setStateCallbacks = [];

  final List<StateUpdaterCallback> _transactionalSetStateCallbacks = [];

  /// The List of callbacks to be called after the component has been updated from a call to [setState].
  List get setStateCallbacks => _setStateCallbacks;

  /// The List of transactional `setState` callbacks to be called before the component updates.
  List get transactionalSetStateCallbacks => _transactionalSetStateCallbacks;

  /// The JavaScript [`ReactComponent`](https://reactjs.org/docs/react-api.html#reactdom.render)
  /// instance of this `Component` returned by [render].
  dynamic get jsThis => _jsThis;

  /// Allows the [ReactJS `displayName` property](https://reactjs.org/docs/react-component.html#displayname)
  /// to be set for debugging purposes.
  // This return type is nullable since Component2's override will return null in certain cases.
  String? get displayName => runtimeType.toString();

  static dynamic _defaultRef(String _) => null;

  initComponentInternal(Map props, void Function() _jsRedraw, [RefMethod? ref, dynamic _jsThis, Map? context]) {
    this._jsRedraw = _jsRedraw;
    this.ref = ref ?? _defaultRef;
    this._jsThis = _jsThis;
    _initContext(context);
    _initProps(props);
  }

  /// Initializes context
  _initContext(Map? context) {
    /// [context]'s and [nextContext]'ss typings were loosened from Map to dynamic to support the new context API in [Component2]
    /// which extends from [Component]. Only "legacy" context APIs are supported in [Component] - which means
    /// it will still be expected to be a Map.
    this.context = {...?context};
    nextContext = {...?context};
  }

  _initProps(Map props) {
    this.props = Map.from(props);
    nextProps = this.props;
  }

  initStateInternal() {
    state = Map.from(getInitialState());

    // Call `transferComponentState` to get state also to `_prevState`
    transferComponentState();
  }

  /// Private reference to the value of [context] for the upcoming render cycle.
  ///
  /// Useful for ReactJS lifecycle methods [shouldComponentUpdateWithContext] and [componentWillUpdateWithContext].
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  Map? nextContext;

  /// Private reference to the value of [state] for the upcoming render cycle.
  ///
  /// Useful for ReactJS lifecycle methods [shouldComponentUpdate], [componentWillUpdate] and [componentDidUpdate].
  Map? _nextState;

  /// Reference to the value of [context] from the previous render cycle, used internally for proxying
  /// the ReactJS lifecycle method.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  Map? prevContext;

  /// Reference to the value of [state] from the previous render cycle, used internally for proxying
  /// the ReactJS lifecycle method and [componentDidUpdate].
  ///
  /// Not available after [componentDidUpdate] is called.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  Map? prevState;

  /// Public getter for [_nextState].
  ///
  /// If `null`, then [_nextState] is equal to [state] - which is the value that will be returned.
  Map get nextState => _nextState ?? state;

  /// Reference to the value of [props] for the upcoming render cycle.
  ///
  /// Used internally for proxying ReactJS lifecycle methods [shouldComponentUpdate], [componentWillReceiveProps], and
  /// [componentWillUpdate] as well as the context-specific variants.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  Map? nextProps;

  /// Transfers `Component` [_nextState] to [state], and [state] to [prevState].
  ///
  /// > __DEPRECATED.__
  /// >
  /// > This was never designed for public consumption, and there will be no replacement implementation in `Component2`.
  /// >
  /// > Will be removed when `Component` is removed in a future major release.
  void transferComponentState() {
    prevState = state;
    if (_nextState != null) {
      state = _nextState!;
    }
    _nextState = Map.from(state);
  }

  /// Force a call to [render] by calling [setState], which effectively "redraws" the `Component`.
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  void redraw([Function()? callback]) {
    setState({}, callback);
  }

  /// Triggers a rerender with new state obtained by shallow-merging [newState] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// Also allows [newState] to be used as a transactional `setState` callback.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  void setState(covariant dynamic newState, [Function()? callback]) {
    if (newState is Map) {
      _nextState!.addAll(newState);
    } else if (newState is StateUpdaterCallback) {
      _transactionalSetStateCallbacks.add(newState);
    } else if (newState != null) {
      throw ArgumentError(
          'setState expects its first parameter to either be a Map or a `TransactionalSetStateCallback`.');
    }

    if (callback != null) _setStateCallbacks.add(callback);

    _jsRedraw();
  }

  /// Set [_nextState] to provided [newState] value and force a re-render.
  ///
  /// Optionally accepts a callback that gets called after the component updates.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  @Deprecated('Use setState instead.')
  void replaceState(Map? newState, [Function()? callback]) {
    final nextState = newState == null ? {} : Map.from(newState);
    _nextState = nextState;
    if (callback != null) _setStateCallbacks.add(callback);

    _jsRedraw();
  }

  /// ReactJS lifecycle method that is invoked once, both on the client and server, immediately before the initial
  /// rendering occurs.
  ///
  /// If you call [setState] within this method, [render] will see the updated state and will be executed only once
  /// despite the [state] value change.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#mounting-componentwillmount>
  void componentWillMount() {}

  /// ReactJS lifecycle method that is invoked once, only on the client _(not on the server)_, immediately after the
  /// initial rendering occurs.
  ///
  /// At this point in the lifecycle, you can access any [ref]s to the children of the root node.
  ///
  /// The [componentDidMount] method of child `Component`s is invoked _before_ that of parent `Component`.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#mounting-componentdidmount>
  void componentDidMount() {}

  /// ReactJS lifecycle method that is invoked when a `Component` is receiving [newProps].
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to react to a prop transition before [render] is called by updating the [state] using
  /// [setState]. The old props can be accessed via [props].
  ///
  /// Calling [setState] within this function will not trigger an additional [render].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#updating-componentwillreceiveprops>
  /// > __UNSUPPORTED IN COMPONENT2__
  /// >
  /// > This will be completely removed alongside the Component class;
  /// > switching to [Component2.getDerivedStateFromProps] is the path forward.
  void componentWillReceiveProps(Map newProps) {}

  /// > __UNSUPPORTED IN COMPONENT2__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  void componentWillReceivePropsWithContext(Map newProps, dynamic nextContext) {}

  /// ReactJS lifecycle method that is invoked before rendering when [nextProps] or [nextState] are being received.
  ///
  /// Use this as an opportunity to return `false` when you're certain that the transition to the new props and state
  /// will not require a component update.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#updating-shouldcomponentupdate>
  bool shouldComponentUpdate(Map nextProps, Map nextState) => true;

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  // ignore: avoid_returning_null
  bool? shouldComponentUpdateWithContext(Map nextProps, Map nextState, Map? nextContext) => null;

  /// ReactJS lifecycle method that is invoked immediately before rendering when [nextProps] or [nextState] are being
  /// received.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to perform preparation before an update occurs.
  ///
  /// __Note__: Choose either this method or [componentWillUpdateWithContext]. They are both called at the same time so
  /// using both provides no added benefit.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#updating-componentwillupdate>
  ///
  /// > __UNSUPPORTED IN COMPONENT2__
  /// >
  /// > Due to the release of getSnapshotBeforeUpdate in ReactJS 16,
  /// > componentWillUpdate is no longer the method used to check the state
  /// > and props before a re-render. Both the Component class and
  /// > componentWillUpdate will be removed alongside Component.
  /// > Use Component2 and Component2.getSnapshotBeforeUpdate instead.
  /// >
  /// > This will be completely removed alongside the Component class.
  void componentWillUpdate(Map nextProps, Map nextState) {}

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  void componentWillUpdateWithContext(Map nextProps, Map nextState, Map? nextContext) {}

  /// ReactJS lifecycle method that is invoked immediately after the `Component`'s updates are flushed to the DOM.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to operate on the root node (DOM) when the `Component` has been updated as a result
  /// of the values of [prevProps] / [prevState].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#updating-componentdidupdate>
  void componentDidUpdate(Map prevProps, Map prevState) {}

  /// ReactJS lifecycle method that is invoked immediately before a `Component` is unmounted from the DOM.
  ///
  /// Perform any necessary cleanup in this method, such as invalidating timers or cleaning up any DOM `Element`s that
  /// were created in [componentDidMount].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#unmounting-componentwillunmount>
  void componentWillUnmount() {}

  /// Returns a Map of context to be passed to descendant components.
  ///
  /// Only keys present in [childContextKeys] will be used; all others will be ignored.
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  Map<String, dynamic> getChildContext() => const {};

  /// The keys this component uses in its child context map (returned by [getChildContext]).
  ///
  /// __This method is called only once, upon component registration.__
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  Iterable<String> get childContextKeys => const [];

  /// The keys of context used by this component.
  ///
  /// __This method is called only once, upon component registration.__
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16.
  /// >
  /// > This will be completely removed alongside the Component class.
  @Deprecated('This legacy, unstable context API is only supported in the deprecated Component, and not Component2.'
      ' Instead, use Component2.context, Context.Consumer, or useContext.')
  Iterable<String> get contextKeys => const [];

  /// Invoked once before the `Component` is mounted. The return value will be used as the initial value of [state].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#getinitialstate>
  Map getInitialState() => {};

  /// Invoked once and cached when [registerComponent] is called. Values in the mapping will be set on [props]
  /// if that prop is not specified by the parent component.
  ///
  /// This method is invoked before any instances are created and thus cannot rely on [props]. In addition, be aware
  /// that any complex objects returned by `getDefaultProps` will be shared across instances, not copied.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#getdefaultprops>
  Map getDefaultProps() => {};

  /// __Required.__
  ///
  /// When called, it should examine [props] and [state] and return a single child `Element`. This child `Element` can
  /// be either a virtual representation of a native DOM component (such as `DivElement`) or another composite
  /// `Component` that you've defined yourself.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#render>
  dynamic render();
}

/// Top-level ReactJS [Component class](https://reactjs.org/docs/react-component.html)
/// which provides the [ReactJS Component API](https://reactjs.org/docs/react-component.html#reference).
///
/// Differences from the deprecated [Component]:
///
/// 1. "JS-backed maps" - uses the JS React component's props / state objects maps under the hood
///    instead of copying them into Dart Maps. Benefits:
///     - Improved performance
///     - Props/state key-value pairs are visible to React, and show up in the Dev Tools
///     - Easier to maintain the JS-Dart interop and add new features
///     - Easier to interop with JS libraries like react-redux
///
/// 2. Supports the new lifecycle methods introduced in React 16
///    (See method doc comments for more info)
///     - [getDerivedStateFromProps]
///     - [getSnapshotBeforeUpdate]
///     - [componentDidCatch]
///     - [getDerivedStateFromError]
///
/// 3. Drops support for "unsafe" lifecycle methods deprecated in React 16
///    (See method doc comments for migration instructions)
///     - [componentWillMount]
///     - [componentWillReceiveProps]
///     - [componentWillUpdate]
///
/// 4. Supports React 16 [context]
abstract class Component2 implements Component {
  /// Accessed once and cached when instance is created. The [contextType] property on a class can be assigned
  /// a [ReactContext] object created by [React.createContext]. This lets you consume the nearest current value of
  /// that Context using [context].
  ///
  /// __Example__:
  ///
  ///     var MyContext = createContext('test');
  ///
  ///     class MyClass extends react.Component2 {
  ///       @override
  ///       final contextType = MyContext;
  ///
  ///       render() {
  ///         return react.span({}, [
  ///           '${this.context}', // Outputs: 'test'
  ///         ]);
  ///       }
  ///     }
  ///
  /// See: <https://reactjs.org/docs/context.html#classcontexttype>
  Context? get contextType => null;

  /// Invoked once and cached when [registerComponent] is called. Values in the mapping will be set on [props]
  /// if that prop is not specified by the parent component.
  ///
  /// This method is invoked before any instances are created and thus cannot rely on [props]. In addition, be aware
  /// that any complex objects returned by `defaultProps` will be shared across instances, not copied.
  ///
  /// __Example__:
  ///
  ///     // ES6 component
  ///     Component.defaultProps = {
  ///       count: 0
  ///     };
  ///
  ///     // Dart component
  ///     @override
  ///     get defaultProps => {'count': 0};
  ///
  /// See: <https://reactjs.org/docs/react-without-es6.html#declaring-default-props>
  /// See: <https://reactjs.org/docs/react-component.html#defaultprops>
  Map get defaultProps => const {};

  /// Invoked once before the `Component` is mounted. The return value will be used as the initial value of [state].
  ///
  /// __Example__:
  ///
  ///     // ES6 component
  ///     constructor() {
  ///       this.state = {count: 0};
  ///     }
  ///
  ///     // Dart component
  ///     @override
  ///     get initialState => {'count': 0};
  ///
  /// See: <https://reactjs.org/docs/react-without-es6.html#setting-the-initial-state>
  /// See: <https://reactjs.org/docs/react-component.html#constructor>
  Map get initialState => const {};

  /// The context value from the [contextType] assigned to this component.
  /// The value is passed down from the provider of the same [contextType].
  /// You can reference [context] in any of the lifecycle methods including the render function.
  ///
  /// If you need multiple context values, consider using multiple consumers instead.
  /// Read more: https://reactjs.org/docs/context.html#consuming-multiple-contexts
  ///
  /// This only has a value when [contextType] is set.
  ///
  /// __Example__:
  ///
  ///     var MyContext = createContext('test');
  ///
  ///     class MyClass extends react.Component2 {
  ///       @override
  ///       final contextType = MyContext;
  ///
  ///       render() {
  ///         return react.span({}, [
  ///           '${this.context}', // Outputs: 'test'
  ///         ]);
  ///       }
  ///     }
  ///
  /// See: <https://reactjs.org/docs/context.html#classcontexttype>
  @override
  dynamic context;

  @override
  late Map props; // [1]

  @override
  late Map state; // [1]

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  get _jsThis => throw _unsupportedError('_jsThis');
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  set _jsThis(_) => throw _unsupportedError('_jsThis');

  /// The JavaScript [`ReactComponent`](https://reactjs.org/docs/react-api.html#reactdom.render)
  /// instance of this `Component` returned by [render].
  @override
  late ReactComponent jsThis; // [1]

  /// Allows the [ReactJS `displayName` property](https://reactjs.org/docs/react-component.html#displayname)
  /// to be set for debugging purposes.
  ///
  /// In DDC, this will be the class name, but in dart2js it will be null unless
  /// overridden, since using runtimeType can lead to larger dart2js output.
  ///
  /// This will result in the dart2js name being `ReactDartComponent2` (the
  /// name of the proxying JS component defined in _dart_helpers.js).
  @override
  String? get displayName {
    String? value;
    assert(() {
      value = runtimeType.toString();
      return true;
    }());
    return value;
  }

  Component2Bridge get _bridge => Component2Bridge.forComponent(this)!;

  /// Triggers a rerender with new state obtained by shallow-merging [newState] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// To use a transactional `setState` callback, check out [setStateWithUpdater].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  @override
  void setState(Map? newState, [SetStateCallback? callback]) {
    _bridge.setState(this, newState, callback);
  }

  /// Triggers a rerender with new state obtained by shallow-merging
  /// the return value of [updater] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  void setStateWithUpdater(StateUpdaterCallback updater, [SetStateCallback? callback]) {
    _bridge.setStateWithUpdater(this, updater, callback);
  }

  /// Causes [render] to be called, skipping [shouldComponentUpdate].
  ///
  /// > See: <https://reactjs.org/docs/react-component.html#forceupdate>
  void forceUpdate([SetStateCallback? callback]) {
    _bridge.forceUpdate(this, callback);
  }

  /// ReactJS lifecycle method that is invoked once, only on the client _(not on the server)_, immediately after the
  /// initial rendering occurs.
  ///
  /// At this point in the lifecycle, you can access any [ref]s to the children of the root node.
  ///
  /// The [componentDidMount] method of child `Component`s is invoked _before_ that of parent `Component`.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#mounting-componentdidmount>
  @override
  void componentDidMount() {}

  /// ReactJS lifecycle method that is invoked before rendering when new props ([nextProps]) are received.
  ///
  /// It should return a new `Map` that will be merged into the existing component [state],
  /// or `null` to do nothing.
  ///
  /// __Important Caveats:__
  ///
  /// * __Unlike [componentWillReceiveProps], this method is called before first mount, and re-renders.__
  ///
  /// * __[prevState] will be `null`__ when this lifecycle method is called before first mount.
  ///   If you need to make use of [prevState], be sure to make your logic null-aware to avoid runtime exceptions.
  ///
  /// * __This method is effectively `static`__ _(since it is static in the JS layer)_,
  ///   so using instance members like [props], [state] or `ref` __will not work.__
  ///
  ///   This is different than the [componentWillReceiveProps] method that it effectively replaces.
  ///
  ///   If your logic requires access to instance members - consider using [getSnapshotBeforeUpdate] instead.
  ///
  /// __Example__:
  ///
  ///     @override
  ///     getDerivedStateFromProps(Map nextProps, Map prevState) {
  ///       if (prevState['someMirroredValue'] != nextProps['someValue']) {
  ///         return {
  ///           someMirroredValue: nextProps.someValue
  ///         };
  ///       }
  ///       return null;
  ///     }
  ///
  /// > Deriving state from props should be used with caution since it can lead to more verbose implementations
  ///   that are less approachable by others.
  /// >
  /// > [Consider recommended alternative solutions first!](https://reactjs.org/blog/2018/06/07/you-probably-dont-need-derived-state.html#preferred-solutions)
  ///
  /// See: <https://reactjs.org/docs/react-component.html#static-getderivedstatefromprops>
  Map? getDerivedStateFromProps(Map nextProps, Map prevState) => null;

  /// ReactJS lifecycle method that is invoked before rendering when [nextProps] and/or [nextState] are being received.
  ///
  /// Use this as an opportunity to return `false` when you're certain that the transition to the new props and state
  /// will not require a component update.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#shouldcomponentupdate>
  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState) => true;

  /// ReactJS lifecycle method that is invoked immediately after re-rendering
  /// when new props and/or state values are committed.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to perform preparation before an update occurs.
  ///
  /// __Example__:
  ///
  ///     @override
  ///     getSnapshotBeforeUpdate(Map prevProps, Map prevState) {
  ///       // Previous props / state can be analyzed and compared to this.props or
  ///       // this.state, allowing the opportunity perform decision logic.
  ///       // Are we adding new items to the list?
  ///       // Capture the scroll position so we can adjust scroll later.
  ///
  ///       if (prevProps.list.length < props.list.length) {
  ///         // The return value from getSnapshotBeforeUpdate is passed into
  ///         // componentDidUpdate's third parameter (which is new to React 16).
  ///
  ///         final list = _listRef;
  ///         return list.scrollHeight - list.scrollTop;
  ///       }
  ///
  ///       return null;
  ///     }
  ///
  ///     @override
  ///     componentDidUpdate(Map prevProps, Map prevState, dynamic snapshot) {
  ///       // If we have a snapshot value, we've just added new items.
  ///       // Adjust scroll so these new items don't push the old ones out of view.
  ///       //
  ///       // (snapshot here is the value returned from getSnapshotBeforeUpdate)
  ///       if (snapshot !== null) {
  ///         final list = _listRef;
  ///         list.scrollTop = list.scrollHeight - snapshot;
  ///       }
  ///     }
  ///
  /// See: <https://reactjs.org/docs/react-component.html#getsnapshotbeforeupdate>
  dynamic getSnapshotBeforeUpdate(Map prevProps, Map prevState) {}

  /// ReactJS lifecycle method that is invoked immediately after the `Component`'s updates are flushed to the DOM.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to operate on the root node (DOM) when the `Component` has been updated as a result
  /// of the values of [prevProps] / [prevState].
  ///
  /// __Note__: React 16 added a third parameter to `componentDidUpdate`, which
  /// is a custom value returned from [getSnapshotBeforeUpdate]. If a
  /// value is not returned from [getSnapshotBeforeUpdate], the [snapshot]
  /// parameter in `componentDidUpdate` will be null.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#componentdidupdate>
  @override
  void componentDidUpdate(Map prevProps, Map prevState, [dynamic snapshot]) {}

  /// ReactJS lifecycle method that is invoked immediately before a `Component` is unmounted from the DOM.
  ///
  /// Perform any necessary cleanup in this method, such as invalidating timers or cleaning up any DOM `Element`s that
  /// were created in [componentDidMount].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#componentwillunmount>
  @override
  void componentWillUnmount() {}

  /// ReactJS lifecycle method that is invoked after an [error] is thrown by a descendant.
  ///
  /// Use this method primarily for logging errors, but because it takes
  /// place after the commit phase side-effects are permitted.
  ///
  /// __Note__: This method, along with [getDerivedStateFromError] will only
  /// be called if `skipMethods` in [registerComponent2] is overridden with
  /// a list that includes the names of these methods. Otherwise, in order to prevent every
  /// component from being an "error boundary", [componentDidCatch] and
  /// [getDerivedStateFromError] will be ignored.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#componentdidcatch>
  void componentDidCatch(dynamic error, ReactErrorInfo info) {}

  /// ReactJS lifecycle method that is invoked after an [error] is thrown by a descendant.
  ///
  /// Use this method to capture the [error] and update component [state] accordingly by
  /// returning a new `Map` value that will be merged into the current [state].
  ///
  /// __This method is effectively `static`__ _(since it is static in the JS layer)_,
  /// so using instance members like [props], [state] or `ref` __will not work.__
  ///
  /// __Note__: This method, along with [componentDidCatch] will only
  /// be called if `skipMethods` in [registerComponent2] is overridden with
  /// a list that includes the names of these methods. Otherwise, in order to prevent every
  /// component from being an error boundary, [componentDidCatch] and
  /// [getDerivedStateFromError] will be ignored.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#static-getderivedstatefromerror>
  Map? getDerivedStateFromError(dynamic error) => null;

  /// Allows usage of PropValidator functions to check the validity of a prop within the props passed to it.
  ///
  /// The second argument (`info`) contains metadata about the prop specified by the key.
  /// `propName`, `componentName`, `location` and `propFullName` are available.
  ///
  /// When an invalid value is provided for a prop, a warning will be shown in the JavaScript console.
  ///
  /// For performance reasons, propTypes is only checked in development mode.
  ///
  /// Simple Example:
  ///
  /// ```
  /// @override
  /// get propTypes => {
  ///   'name': (Map props, info) {
  ///     if (props['name'].length > 20) {
  ///       return ArgumentError('(${props['name']}) is too long. 'name' has a max length of 20 characters.');
  ///     }
  ///   },
  /// };
  /// ```
  ///
  /// Example of 2 props being dependent:
  ///
  /// ```
  /// @override
  /// get propTypes => {
  ///   'someProp': (Map props, info) {
  ///     if (props[info.propName] == true && props['anotherProp'] == null) {
  ///       return ArgumentError('If (${props[info.propName]}) is true. You must have a value for "anotherProp".');
  ///     }
  ///   },
  ///   'anotherProp': (Map props, info) {
  ///     if (props[info.propName] != null && props['someProp'] != true) {
  ///       return ArgumentError('You must set "someProp" to true to use $[info.propName].');
  ///     }
  ///   },
  /// };
  /// ```
  ///
  /// See: <https://reactjs.org/docs/typechecking-with-proptypes.html#proptypes>
  Map<String, PropValidator<Never>> get propTypes => {};

  /// Examines [props] and [state] and returns one of the following types:
  ///
  /// * [ReactElement] (renders a single DOM `Element`)
  /// * [Fragment] (renders multiple elements)
  /// * [ReactPortal] (renders children into a different DOM subtree)
  /// * `String` / `num` (renders text nodes in the DOM)
  /// * `bool` / `null` (renders nothing)
  ///
  /// This method is __required__ for class components.
  ///
  /// The function should be _pure_, meaning that it should not modify component [state],
  /// it returns the same result each time it is invoked, and it does not directly interact
  /// with browser / DOM apis.
  ///
  /// If you need to interact with the browser / DOM apis, perform your work in [componentDidMount]
  /// or the other lifecycle methods instead. Keeping `render` pure makes components easier to think about.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#render>
  @override
  dynamic render();

  // ******************************************************************************************************************
  //
  // Deprecated members
  //
  // ******************************************************************************************************************

  /// Deprecated. Will be removed when [Component] is removed in a future major release.
  ///
  /// Replace calls to this method with either:
  ///
  /// - [forceUpdate] (preferred) - forces rerender and bypasses [shouldComponentUpdate]
  /// - `setState({})` - same behavior as this method: causes rerender but goes through [shouldComponentUpdate]
  ///
  /// See: <https://reactjs.org/docs/react-component.html#forceupdate>
  @override
  @Deprecated('Use forceUpdate or setState({}) instead. Will be removed when Component is removed.')
  void redraw([SetStateCallback? callback]) {
    setState({}, callback);
  }

  // ******************************************************************************************************************
  //
  // Deprecated and unsupported lifecycle methods
  //
  //   These should all throw and be annotated with @mustCallSuper so that any consumer overrides don't silently fail.
  //
  // ******************************************************************************************************************

  UnsupportedError _unsupportedLifecycleError(String memberName) =>
      UnsupportedError('Component2 drops support for the lifecycle method $memberName.'
          ' See doc comment on Component2.$memberName for migration instructions.');

  /// Invoked once before the `Component` is mounted. The return value will be used as the initial value of [state].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#getinitialstate>
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > Use the [initialState] getter instead.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map getInitialState() => throw _unsupportedLifecycleError('getInitialState');

  /// Invoked once and cached when [registerComponent] is called. Values in the mapping will be set on [props]
  /// if that prop is not specified by the parent component.
  ///
  /// This method is invoked before any instances are created and thus cannot rely on [props]. In addition, be aware
  /// that any complex objects returned by `getDefaultProps` will be shared across instances, not copied.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#getdefaultprops>
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > Use the [defaultProps] getter instead.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map getDefaultProps() => throw _unsupportedLifecycleError('getDefaultProps');

  /// ReactJS lifecycle method that is invoked once immediately before the initial rendering occurs.
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > Use [componentDidMount] instead
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void componentWillMount() => throw _unsupportedLifecycleError('componentWillMount');

  /// ReactJS lifecycle method that is invoked when a `Component` is receiving new props ([nextProps]).
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This will be removed along with [Component] in a future major release
  /// >
  /// > Depending on your use-case, you should use [getDerivedStateFromProps] or [getSnapshotBeforeUpdate] instead.
  /// > _(See the examples below if you're not sure which one to use)_
  ///
  /// __If you used `componentWillReceiveProps` to update instance [state], use [getDerivedStateFromProps]__
  ///
  ///     // Before
  ///     @override
  ///     componentWillReceiveProps(Map nextProps) {
  ///       if (nextProps['someValueUsedToDeriveState'] != props['someValueUsedToDeriveState']) {
  ///         setState({'someDerivedState': nextProps['someValueUsedToDeriveState']});
  ///       }
  ///     }
  ///
  ///     // After
  ///     @override
  ///     getDerivedStateFromProps(Map nextProps, Map prevState) {
  ///       // NOTE: Accessing `props` is not allowed here. Change the comparison to utilize `prevState` instead.
  ///       if (nextProps['someValueUsedToDeriveState'] != prevState['someDerivedState']) {
  ///         // Return a new Map instead of calling `setState` directly.
  ///         return {'someDerivedState': nextProps['someValueUsedToDeriveState']};
  ///       }
  ///       return null;
  ///     }
  ///
  ///
  /// __If you did not use `componentWillReceiveProps` to update instance [state], use [getSnapshotBeforeUpdate]__
  ///
  ///     // Before
  ///     @override
  ///     componentWillReceiveProps(Map nextProps) {
  ///       if (nextProps['someValue'] > props['someValue']) {
  ///         _someInstanceField = deriveNewValueFromNewProps(nextProps['someValue']);
  ///       }
  ///     }
  ///
  ///     // After
  ///     @override
  ///     getSnapshotBeforeUpdate(Map prevProps, Map prevState) {
  ///       // NOTE: Unlike `getDerivedStateFromProps`, accessing `props` is allowed here.
  ///       // * The reference to `nextProps` from `componentWillReceiveProps` should be updated to `props` here
  ///       // * The reference to `props` from `componentWillReceiveProps` should be updated to `prevProps`.
  ///       if (props['someValue'] > prevProps['someValue']) {
  ///         _someInstanceField = deriveNewValueFromNewProps(props['someValue']);
  ///       }
  ///
  ///       // NOTE: You could also return a `snapshot` value from this method for later use in `componentDidUpdate`.
  ///     }
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void componentWillReceiveProps(Map nextProps) => throw _unsupportedLifecycleError('componentWillReceiveProps');

  /// ReactJS lifecycle method that is invoked when a `Component` is receiving
  /// new props ([nextProps]) and/or state ([nextState]).
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This will be removed along with [Component] in a future major release
  /// >
  /// > Use [getSnapshotBeforeUpdate] instead as shown in the example below.
  ///
  ///     // Before
  ///     @override
  ///     componentWillUpdate(Map nextProps, Map nextState) {
  ///       if (nextProps['someValue'] > props['someValue']) {
  ///         _someInstanceField = deriveNewValueFromNewProps(nextProps['someValue']);
  ///       }
  ///
  ///       if (nextState['someStateValue'] != state['someStateValue']) {
  ///         triggerSomeOtherActionOutsideOfThisComponent(nextState['someStateValue']);
  ///       }
  ///     }
  ///
  ///     // After
  ///     @override
  ///     getSnapshotBeforeUpdate(Map prevProps, Map prevState) {
  ///       // * The reference to `nextProps` from `componentWillUpdate` should be updated to `props` here
  ///       // * The reference to `props` from `componentWillUpdate` should be updated to `prevProps`.
  ///       if (props['someValue'] > prevProps['someValue']) {
  ///         _someInstanceField = deriveNewValueFromNewProps(props['someValue']);
  ///       }
  ///
  ///       // * The reference to `nextState` from `componentWillUpdate` should be updated to `state` here
  ///       // * The reference to `state` from `componentWillUpdate` should be updated to `prevState`.
  ///       if (state['someStateValue'] != prevState['someStateValue']) {
  ///         triggerSomeOtherActionOutsideOfThisComponent(state['someStateValue']);
  ///       }
  ///
  ///       // NOTE: You could also return a `snapshot` value from this method for later use in `componentDidUpdate`.
  ///     }
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void componentWillUpdate(Map nextProps, Map nextState) => throw _unsupportedLifecycleError('componentWillUpdate');

  /// Do not use; this is part of the legacy context API.
  ///
  /// See [createContext] for instructions on using the new context API.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map<String, dynamic> getChildContext() => throw _unsupportedLifecycleError('getChildContext');

  /// Do not use; this is part of the legacy context API.
  ///
  /// See [createContext] for instructions on using the new context API.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  bool shouldComponentUpdateWithContext(Map nextProps, Map nextState, dynamic nextContext) =>
      throw _unsupportedLifecycleError('shouldComponentUpdateWithContext');

  /// Do not use; this is part of the legacy context API.
  ///
  /// See [createContext] for instructions on using the new context API.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void componentWillUpdateWithContext(Map nextProps, Map nextState, dynamic nextContext) =>
      throw _unsupportedLifecycleError('componentWillUpdateWithContext');

  /// Do not use; this is part of the legacy context API.
  ///
  /// See [createContext] for instructions on using the new context API.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @mustCallSuper
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void componentWillReceivePropsWithContext(Map newProps, dynamic nextContext) =>
      throw _unsupportedLifecycleError('componentWillReceivePropsWithContext');

  // ******************************************************************************************************************
  // Other deprecated and unsupported members
  // ******************************************************************************************************************

  UnsupportedError _unsupportedError(String memberName) => UnsupportedError('Component2 drops support for $memberName');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void replaceState(Map? newState, [SetStateCallback? callback]) => throw _unsupportedError('replaceState');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Iterable<String> get childContextKeys => throw _unsupportedError('"Legacy" Context [childContextKeys]');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Iterable<String> get contextKeys => throw _unsupportedError('"Legacy" Context [contextKeys]');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  initComponentInternal(props, _jsRedraw, [RefMethod? ref, _jsThis, context]) =>
      throw _unsupportedError('initComponentInternal');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  initStateInternal() => throw _unsupportedError('initStateInternal');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  get nextContext => throw _unsupportedError('"Legacy" Context [nextContext]');
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  set nextContext(_) => throw _unsupportedError('"Legacy" Context [nextContext]');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  get prevContext => throw _unsupportedError('"Legacy" Context [prevContext]');
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  set prevContext(_) => throw _unsupportedError('"Legacy" Context [prevContext]');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map get prevState => throw _unsupportedError('"Legacy" Context [prevContext]');
  @override
  set prevState(_) => throw _unsupportedError('"Legacy" Context [prevContext]');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map get nextState => throw _unsupportedError('nextState');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  Map get nextProps => throw _unsupportedError('nextProps');
  @override
  set nextProps(_) => throw _unsupportedError('nextProps');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  void transferComponentState() => throw _unsupportedError('transferComponentState');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  RefMethod get ref => throw _unsupportedError('ref');
  @override
  set ref(_) => throw _unsupportedError('ref');

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in a future major release.
  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  List<SetStateCallback> get setStateCallbacks => throw _unsupportedError('setStateCallbacks');

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2. See doc comment for more info.')
  List<StateUpdaterCallback> get transactionalSetStateCallbacks =>
      throw _unsupportedError('transactionalSetStateCallbacks');

  // ******************************************************************************************************************
  // Private unsupported members (no need to throw since they're internal)
  // ******************************************************************************************************************

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  Map? _context;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late void Function() _jsRedraw;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  Map? _nextState;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late Map _props;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late RefMethod _ref;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late List<SetStateCallback> _setStateCallbacks;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late Map _state;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  late List<StateUpdaterCallback> _transactionalSetStateCallbacks;

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  _initContext(context) {}

  @override
  @Deprecated('Only supported in the deprecated Component, and not in Component2.')
  _initProps(props) {}
}

/// Mixin that enforces consistent typing of the `snapshot` parameter
/// returned by [Component2.getSnapshotBeforeUpdate]
/// and passed into [Component2.componentDidUpdate].
///
/// __EXAMPLE__:
///
///     class _ParentComponent extends react.Component2
///         with react.TypedSnapshot<bool> {
///
///       // Note that the return value is specified as an bool, matching the mixin
///       // type.
///       bool getShapshotBeforeUpdate(prevProps, prevState) {
///         if (prevProps["foo"]) {
///           return true;
///         }
///         return null;
///       }
///
///       // Note that the snapshot parameter is consistently typed with the return
///       // value of getSnapshotBeforeUpdate.
///       void componentDidUpdate(prevProps, prevState, [bool snapshot]) {
///         if (snapshot == true) {
///           // Do something
///         }
///       }
///
///       /* Include other standard component logic */
///
///     }
///
/// This mixin should only be used with `Component2` or `UiComponent2`. This is not
/// enforced via the `on` keyword because of an issue with the Dart SDK.
///
/// See: <https://github.com/dart-lang/sdk/issues/38098>
mixin TypedSnapshot<TSnapshot> {
  TSnapshot getSnapshotBeforeUpdate(Map prevProps, Map prevState);

  void componentDidUpdate(Map prevProps, Map prevState, [covariant TSnapshot snapshot]);
}

/// Creates a ReactJS virtual DOM instance ([ReactElement] on the client).
abstract class ReactComponentFactoryProxy {
  /// The type of component created by this factory.
  get type;

  /// Returns a new rendered component instance with the specified [props] and [childrenArgs].
  ///
  /// Necessary to work around DDC `dart.dcall` issues in <https://github.com/dart-lang/sdk/issues/29904>,
  /// since invoking the function directly doesn't work.
  ReactElement build(Map props, [List childrenArgs]);

  /// Returns a new rendered component instance with the specified [props] and `children` ([c1], [c2], et. al.).
  ///
  /// > The additional children arguments (c2, c3, et. al.) are a workaround for <https://github.com/dart-lang/sdk/issues/16030>.
  ReactElement call(Map props,
      [c1 = _notSpecified,
      c2 = _notSpecified,
      c3 = _notSpecified,
      c4 = _notSpecified,
      c5 = _notSpecified,
      c6 = _notSpecified,
      c7 = _notSpecified,
      c8 = _notSpecified,
      c9 = _notSpecified,
      c10 = _notSpecified,
      c11 = _notSpecified,
      c12 = _notSpecified,
      c13 = _notSpecified,
      c14 = _notSpecified,
      c15 = _notSpecified,
      c16 = _notSpecified,
      c17 = _notSpecified,
      c18 = _notSpecified,
      c19 = _notSpecified,
      c20 = _notSpecified,
      c21 = _notSpecified,
      c22 = _notSpecified,
      c23 = _notSpecified,
      c24 = _notSpecified,
      c25 = _notSpecified,
      c26 = _notSpecified,
      c27 = _notSpecified,
      c28 = _notSpecified,
      c29 = _notSpecified,
      c30 = _notSpecified,
      c31 = _notSpecified,
      c32 = _notSpecified,
      c33 = _notSpecified,
      c34 = _notSpecified,
      c35 = _notSpecified,
      c36 = _notSpecified,
      c37 = _notSpecified,
      c38 = _notSpecified,
      c39 = _notSpecified,
      c40 = _notSpecified]) {
    List childArguments;
    // Use `identical` since it compiles down to `===` in dart2js instead of calling equality helper functions,
    // and we don't want to allow any object overriding `operator==` to claim it's equal to `_notSpecified`.
    if (identical(c1, _notSpecified)) {
      // Use a const list so that empty children prop values are always identical
      // in the JS props, resulting in JS libraries (e.g., react-redux) and Dart code alike
      // not marking props as having changed as a result of rerendering the ReactElement with a new list.
      childArguments = const [];
    } else if (identical(c2, _notSpecified)) {
      childArguments = [c1];
    } else if (identical(c3, _notSpecified)) {
      childArguments = [c1, c2];
    } else if (identical(c4, _notSpecified)) {
      childArguments = [c1, c2, c3];
    } else if (identical(c5, _notSpecified)) {
      childArguments = [c1, c2, c3, c4];
    } else if (identical(c6, _notSpecified)) {
      childArguments = [c1, c2, c3, c4, c5];
    } else if (identical(c7, _notSpecified)) {
      childArguments = [c1, c2, c3, c4, c5, c6];
    } else {
      childArguments = [
        c1,
        c2,
        c3,
        c4,
        c5,
        c6,
        c7,
        c8,
        c9,
        c10,
        c11,
        c12,
        c13,
        c14,
        c15,
        c16,
        c17,
        c18,
        c19,
        c20,
        c21,
        c22,
        c23,
        c24,
        c25,
        c26,
        c27,
        c28,
        c29,
        c30,
        c31,
        c32,
        c33,
        c34,
        c35,
        c36,
        c37,
        c38,
        c39,
        c40
      ].takeWhile((child) => !identical(child, _notSpecified)).toList();
    }

    return build(props, childArguments);
  }
}

const _notSpecified = NotSpecified();

class NotSpecified {
  const NotSpecified();
}

/// Registers a component factory on both client and server.
@Deprecated('Use registerComponent2 after migrating your components from Component to Component2.')
/*ComponentRegistrar*/ Function registerComponent = validateJsApiThenReturn(() => registration_utils.registerComponent);

/// Registers a component factory on both client and server.
ComponentRegistrar2 registerComponent2 = validateJsApiThenReturn(() => registration_utils.registerComponent2);

/// Registers a function component on the client.
///
/// Example:
/// ```
/// var myFunctionComponent = registerFunctionComponent((props) {
///   return ['I am a function component', ...props.children];
/// });
/// ```
///
/// Example with display name:
/// ```
/// var myFunctionComponent = registerFunctionComponent((props) {
///   return ['I am a function component', ...props.children];
/// }, displayName: 'myFunctionComponent');
/// ```
/// or with an inferred name from the Dart function
/// ```
/// myDartFunctionComponent(Map props) {
///   return ['I am a function component', ...props.children];
/// }
/// var myFunctionComponent = registerFunctionComponent(myDartFunctionComponent);
/// ```
FunctionComponentRegistrar registerFunctionComponent =
    validateJsApiThenReturn(() => registration_utils.registerFunctionComponent);

ReactDomComponentFactoryProxy _createDomFactory(String tagName) {
  validateJsApi();
  return ReactDomComponentFactoryProxy(tagName);
}

/// The HTML `<a>` `AnchorElement`.
ReactDomComponentFactoryProxy a = _createDomFactory('a');

/// The HTML `<abbr>` `Element`.
ReactDomComponentFactoryProxy abbr = _createDomFactory('abbr');

/// The HTML `<address>` `Element`.
ReactDomComponentFactoryProxy address = _createDomFactory('address');

/// The HTML `<area>` `AreaElement`.
ReactDomComponentFactoryProxy area = _createDomFactory('area');

/// The HTML `<article>` `Element`.
ReactDomComponentFactoryProxy article = _createDomFactory('article');

/// The HTML `<aside>` `Element`.
ReactDomComponentFactoryProxy aside = _createDomFactory('aside');

/// The HTML `<audio>` `AudioElement`.
ReactDomComponentFactoryProxy audio = _createDomFactory('audio');

/// The HTML `<b>` `Element`.
ReactDomComponentFactoryProxy b = _createDomFactory('b');

/// The HTML `<base>` `BaseElement`.
ReactDomComponentFactoryProxy base = _createDomFactory('base');

/// The HTML `<bdi>` `Element`.
ReactDomComponentFactoryProxy bdi = _createDomFactory('bdi');

/// The HTML `<bdo>` `Element`.
ReactDomComponentFactoryProxy bdo = _createDomFactory('bdo');

/// The HTML `<big>` `Element`.
ReactDomComponentFactoryProxy big = _createDomFactory('big');

/// The HTML `<blockquote>` `Element`.
ReactDomComponentFactoryProxy blockquote = _createDomFactory('blockquote');

/// The HTML `<body>` `BodyElement`.
ReactDomComponentFactoryProxy body = _createDomFactory('body');

/// The HTML `<br>` `BRElement`.
ReactDomComponentFactoryProxy br = _createDomFactory('br');

/// The HTML `<button>` `ButtonElement`.
ReactDomComponentFactoryProxy button = _createDomFactory('button');

/// The HTML `<canvas>` `CanvasElement`.
ReactDomComponentFactoryProxy canvas = _createDomFactory('canvas');

/// The HTML `<caption>` `Element`.
ReactDomComponentFactoryProxy caption = _createDomFactory('caption');

/// The HTML `<cite>` `Element`.
ReactDomComponentFactoryProxy cite = _createDomFactory('cite');

/// The HTML `<code>` `Element`.
ReactDomComponentFactoryProxy code = _createDomFactory('code');

/// The HTML `<col>` `Element`.
ReactDomComponentFactoryProxy col = _createDomFactory('col');

/// The HTML `<colgroup>` `Element`.
ReactDomComponentFactoryProxy colgroup = _createDomFactory('colgroup');

/// The HTML `<data>` `Element`.
ReactDomComponentFactoryProxy data = _createDomFactory('data');

/// The HTML `<datalist>` `DataListElement`.
ReactDomComponentFactoryProxy datalist = _createDomFactory('datalist');

/// The HTML `<dd>` `Element`.
ReactDomComponentFactoryProxy dd = _createDomFactory('dd');

/// The HTML `<del>` `Element`.
ReactDomComponentFactoryProxy del = _createDomFactory('del');

/// The HTML `<details>` `DetailsElement`.
ReactDomComponentFactoryProxy details = _createDomFactory('details');

/// The HTML `<dfn>` `Element`.
ReactDomComponentFactoryProxy dfn = _createDomFactory('dfn');

/// The HTML `<dialog>` `DialogElement`.
ReactDomComponentFactoryProxy dialog = _createDomFactory('dialog');

/// The HTML `<div>` `DivElement`.
ReactDomComponentFactoryProxy div = _createDomFactory('div');

/// The HTML `<dl>` `DListElement`.
ReactDomComponentFactoryProxy dl = _createDomFactory('dl');

/// The HTML `<dt>` `Element`.
ReactDomComponentFactoryProxy dt = _createDomFactory('dt');

/// The HTML `<em>` `Element`.
ReactDomComponentFactoryProxy em = _createDomFactory('em');

/// The HTML `<embed>` `EmbedElement`.
ReactDomComponentFactoryProxy embed = _createDomFactory('embed');

/// The HTML `<fieldset>` `FieldSetElement`.
ReactDomComponentFactoryProxy fieldset = _createDomFactory('fieldset');

/// The HTML `<figcaption>` `Element`.
ReactDomComponentFactoryProxy figcaption = _createDomFactory('figcaption');

/// The HTML `<figure>` `Element`.
ReactDomComponentFactoryProxy figure = _createDomFactory('figure');

/// The HTML `<footer>` `Element`.
ReactDomComponentFactoryProxy footer = _createDomFactory('footer');

/// The HTML `<form>` `FormElement`.
ReactDomComponentFactoryProxy form = _createDomFactory('form');

/// The HTML `<h1>` `HeadingElement`.
ReactDomComponentFactoryProxy h1 = _createDomFactory('h1');

/// The HTML `<h2>` `HeadingElement`.
ReactDomComponentFactoryProxy h2 = _createDomFactory('h2');

/// The HTML `<h3>` `HeadingElement`.
ReactDomComponentFactoryProxy h3 = _createDomFactory('h3');

/// The HTML `<h4>` `HeadingElement`.
ReactDomComponentFactoryProxy h4 = _createDomFactory('h4');

/// The HTML `<h5>` `HeadingElement`.
ReactDomComponentFactoryProxy h5 = _createDomFactory('h5');

/// The HTML `<h6>` `HeadingElement`.
ReactDomComponentFactoryProxy h6 = _createDomFactory('h6');

/// The HTML `<head>` `HeadElement`.
ReactDomComponentFactoryProxy head = _createDomFactory('head');

/// The HTML `<header>` `Element`.
ReactDomComponentFactoryProxy header = _createDomFactory('header');

/// The HTML `<hr>` `HRElement`.
ReactDomComponentFactoryProxy hr = _createDomFactory('hr');

/// The HTML `<html>` `HtmlHtmlElement`.
ReactDomComponentFactoryProxy html = _createDomFactory('html');

/// The HTML `<i>` `Element`.
ReactDomComponentFactoryProxy i = _createDomFactory('i');

/// The HTML `<iframe>` `IFrameElement`.
ReactDomComponentFactoryProxy iframe = _createDomFactory('iframe');

/// The HTML `<img>` `ImageElement`.
ReactDomComponentFactoryProxy img = _createDomFactory('img');

/// The HTML `<input>` `InputElement`.
ReactDomComponentFactoryProxy input = _createDomFactory('input');

/// The HTML `<ins>` `Element`.
ReactDomComponentFactoryProxy ins = _createDomFactory('ins');

/// The HTML `<kbd>` `Element`.
ReactDomComponentFactoryProxy kbd = _createDomFactory('kbd');

/// The HTML `<keygen>` `KeygenElement`.
ReactDomComponentFactoryProxy keygen = _createDomFactory('keygen');

/// The HTML `<label>` `LabelElement`.
ReactDomComponentFactoryProxy label = _createDomFactory('label');

/// The HTML `<legend>` `LegendElement`.
ReactDomComponentFactoryProxy legend = _createDomFactory('legend');

/// The HTML `<li>` `LIElement`.
ReactDomComponentFactoryProxy li = _createDomFactory('li');

/// The HTML `<link>` `LinkElement`.
ReactDomComponentFactoryProxy link = _createDomFactory('link');

/// The HTML `<main>` `Element`.
ReactDomComponentFactoryProxy htmlMain = _createDomFactory('main');

/// The HTML `<map>` `MapElement`.
ReactDomComponentFactoryProxy map = _createDomFactory('map');

/// The HTML `<mark>` `Element`.
ReactDomComponentFactoryProxy mark = _createDomFactory('mark');

/// The HTML `<menu>` `MenuElement`.
ReactDomComponentFactoryProxy menu = _createDomFactory('menu');

/// The HTML `<menuitem>` `MenuItemElement`.
ReactDomComponentFactoryProxy menuitem = _createDomFactory('menuitem');

/// The HTML `<meta>` `MetaElement`.
ReactDomComponentFactoryProxy meta = _createDomFactory('meta');

/// The HTML `<meter>` `MeterElement`.
ReactDomComponentFactoryProxy meter = _createDomFactory('meter');

/// The HTML `<nav>` `Element`.
ReactDomComponentFactoryProxy nav = _createDomFactory('nav');

/// The HTML `<noscript>` `Element`.
ReactDomComponentFactoryProxy noscript = _createDomFactory('noscript');

/// The HTML `<object>` `ObjectElement`.
ReactDomComponentFactoryProxy object = _createDomFactory('object');

/// The HTML `<ol>` `OListElement`.
ReactDomComponentFactoryProxy ol = _createDomFactory('ol');

/// The HTML `<optgroup>` `OptGroupElement`.
ReactDomComponentFactoryProxy optgroup = _createDomFactory('optgroup');

/// The HTML `<option>` `OptionElement`.
ReactDomComponentFactoryProxy option = _createDomFactory('option');

/// The HTML `<output>` `OutputElement`.
ReactDomComponentFactoryProxy output = _createDomFactory('output');

/// The HTML `<p>` `ParagraphElement`.
ReactDomComponentFactoryProxy p = _createDomFactory('p');

/// The HTML `<param>` `ParamElement`.
ReactDomComponentFactoryProxy param = _createDomFactory('param');

/// The HTML `<picture>` `PictureElement`.
ReactDomComponentFactoryProxy picture = _createDomFactory('picture');

/// The HTML `<pre>` `PreElement`.
ReactDomComponentFactoryProxy pre = _createDomFactory('pre');

/// The HTML `<progress>` `ProgressElement`.
ReactDomComponentFactoryProxy progress = _createDomFactory('progress');

/// The HTML `<q>` `QuoteElement`.
ReactDomComponentFactoryProxy q = _createDomFactory('q');

/// The HTML `<rp>` `Element`.
ReactDomComponentFactoryProxy rp = _createDomFactory('rp');

/// The HTML `<rt>` `Element`.
ReactDomComponentFactoryProxy rt = _createDomFactory('rt');

/// The HTML `<ruby>` `Element`.
ReactDomComponentFactoryProxy ruby = _createDomFactory('ruby');

/// The HTML `<s>` `Element`.
ReactDomComponentFactoryProxy s = _createDomFactory('s');

/// The HTML `<samp>` `Element`.
ReactDomComponentFactoryProxy samp = _createDomFactory('samp');

/// The HTML `<script>` `ScriptElement`.
ReactDomComponentFactoryProxy script = _createDomFactory('script');

/// The HTML `<section>` `Element`.
ReactDomComponentFactoryProxy section = _createDomFactory('section');

/// The HTML `<select>` `SelectElement`.
ReactDomComponentFactoryProxy select = _createDomFactory('select');

/// The HTML `<small>` `Element`.
ReactDomComponentFactoryProxy small = _createDomFactory('small');

/// The HTML `<source>` `SourceElement`.
ReactDomComponentFactoryProxy source = _createDomFactory('source');

/// The HTML `<span>` `SpanElement`.
ReactDomComponentFactoryProxy span = _createDomFactory('span');

/// The HTML `<strong>` `Element`.
ReactDomComponentFactoryProxy strong = _createDomFactory('strong');

/// The HTML `<style>` `StyleElement`.
ReactDomComponentFactoryProxy style = _createDomFactory('style');

/// The HTML `<sub>` `Element`.
ReactDomComponentFactoryProxy sub = _createDomFactory('sub');

/// The HTML `<summary>` `Element`.
ReactDomComponentFactoryProxy summary = _createDomFactory('summary');

/// The HTML `<sup>` `Element`.
ReactDomComponentFactoryProxy sup = _createDomFactory('sup');

/// The HTML `<table>` `TableElement`.
ReactDomComponentFactoryProxy table = _createDomFactory('table');

/// The HTML `<tbody>` `TableSectionElement`.
ReactDomComponentFactoryProxy tbody = _createDomFactory('tbody');

/// The HTML `<td>` `TableCellElement`.
ReactDomComponentFactoryProxy td = _createDomFactory('td');

/// The HTML `<textarea>` `TextAreaElement`.
ReactDomComponentFactoryProxy textarea = _createDomFactory('textarea');

/// The HTML `<tfoot>` `TableSectionElement`.
ReactDomComponentFactoryProxy tfoot = _createDomFactory('tfoot');

/// The HTML `<th>` `TableCellElement`.
ReactDomComponentFactoryProxy th = _createDomFactory('th');

/// The HTML `<thead>` `TableSectionElement`.
ReactDomComponentFactoryProxy thead = _createDomFactory('thead');

/// The HTML `<time>` `TimeInputElement`.
ReactDomComponentFactoryProxy time = _createDomFactory('time');

/// The HTML `<title>` `TitleElement`.
ReactDomComponentFactoryProxy title = _createDomFactory('title');

/// The HTML `<tr>` `TableRowElement`.
ReactDomComponentFactoryProxy tr = _createDomFactory('tr');

/// The HTML `<track>` `TrackElement`.
ReactDomComponentFactoryProxy track = _createDomFactory('track');

/// The HTML `<u>` `Element`.
ReactDomComponentFactoryProxy u = _createDomFactory('u');

/// The HTML `<ul>` `UListElement`.
ReactDomComponentFactoryProxy ul = _createDomFactory('ul');

/// The HTML `<var>` `Element`.
///
/// _Named variable because `var` is a reserved word in Dart._
ReactDomComponentFactoryProxy variable = _createDomFactory('var');

/// The HTML `<video>` `VideoElement`.
ReactDomComponentFactoryProxy video = _createDomFactory('video');

/// The HTML `<wbr>` `Element`.
ReactDomComponentFactoryProxy wbr = _createDomFactory('wbr');

/// The SVG `<altGlyph>` `AltGlyphElement`.
ReactDomComponentFactoryProxy altGlyph = _createDomFactory('altGlyph');

/// The SVG `<altGlyphDef>` `AltGlyphDefElement`.
ReactDomComponentFactoryProxy altGlyphDef = _createDomFactory('altGlyphDef');

/// The SVG `<altGlyphItem>` `AltGlyphItemElement`.
ReactDomComponentFactoryProxy altGlyphItem = _createDomFactory('altGlyphItem');

/// The SVG `<animate>` `AnimateElement`.
ReactDomComponentFactoryProxy animate = _createDomFactory('animate');

/// The SVG `<animateColor>` `AnimateColorElement`.
ReactDomComponentFactoryProxy animateColor = _createDomFactory('animateColor');

/// The SVG `<animateMotion>` `AnimateMotionElement`.
ReactDomComponentFactoryProxy animateMotion = _createDomFactory('animateMotion');

/// The SVG `<animateTransform>` `AnimateTransformElement`.
ReactDomComponentFactoryProxy animateTransform = _createDomFactory('animateTransform');

/// The SVG `<circle>` `CircleElement`.
ReactDomComponentFactoryProxy circle = _createDomFactory('circle');

/// The SVG `<clipPath>` `ClipPathElement`.
ReactDomComponentFactoryProxy clipPath = _createDomFactory('clipPath');

/// The SVG `<color-profile>` `ColorProfileElement`.
ReactDomComponentFactoryProxy colorProfile = _createDomFactory('color-profile');

/// The SVG `<cursor>` `CursorElement`.
ReactDomComponentFactoryProxy cursor = _createDomFactory('cursor');

/// The SVG `<defs>` `DefsElement`.
ReactDomComponentFactoryProxy defs = _createDomFactory('defs');

/// The SVG `<desc>` `DescElement`.
ReactDomComponentFactoryProxy desc = _createDomFactory('desc');

/// The SVG `<discard>` `DiscardElement`.
ReactDomComponentFactoryProxy discard = _createDomFactory('discard');

/// The SVG `<ellipse>` `EllipseElement`.
ReactDomComponentFactoryProxy ellipse = _createDomFactory('ellipse');

/// The SVG `<feBlend>` `FeBlendElement`.
ReactDomComponentFactoryProxy feBlend = _createDomFactory('feBlend');

/// The SVG `<feColorMatrix>` `FeColorMatrixElement`.
ReactDomComponentFactoryProxy feColorMatrix = _createDomFactory('feColorMatrix');

/// The SVG `<feComponentTransfer>` `FeComponentTransferElement`.
ReactDomComponentFactoryProxy feComponentTransfer = _createDomFactory('feComponentTransfer');

/// The SVG `<feComposite>` `FeCompositeElement`.
ReactDomComponentFactoryProxy feComposite = _createDomFactory('feComposite');

/// The SVG `<feConvolveMatrix>` `FeConvolveMatrixElement`.
ReactDomComponentFactoryProxy feConvolveMatrix = _createDomFactory('feConvolveMatrix');

/// The SVG `<feDiffuseLighting>` `FeDiffuseLightingElement`.
ReactDomComponentFactoryProxy feDiffuseLighting = _createDomFactory('feDiffuseLighting');

/// The SVG `<feDisplacementMap>` `FeDisplacementMapElement`.
ReactDomComponentFactoryProxy feDisplacementMap = _createDomFactory('feDisplacementMap');

/// The SVG `<feDistantLight>` `FeDistantLightElement`.
ReactDomComponentFactoryProxy feDistantLight = _createDomFactory('feDistantLight');

/// The SVG `<feDropShadow>` `FeDropShadowElement`.
ReactDomComponentFactoryProxy feDropShadow = _createDomFactory('feDropShadow');

/// The SVG `<feFlood>` `FeFloodElement`.
ReactDomComponentFactoryProxy feFlood = _createDomFactory('feFlood');

/// The SVG `<feFuncA>` `FeFuncAElement`.
ReactDomComponentFactoryProxy feFuncA = _createDomFactory('feFuncA');

/// The SVG `<feFuncB>` `FeFuncBElement`.
ReactDomComponentFactoryProxy feFuncB = _createDomFactory('feFuncB');

/// The SVG `<feFuncG>` `FeFuncGElement`.
ReactDomComponentFactoryProxy feFuncG = _createDomFactory('feFuncG');

/// The SVG `<feFuncR>` `FeFuncRElement`.
ReactDomComponentFactoryProxy feFuncR = _createDomFactory('feFuncR');

/// The SVG `<feGaussianBlur>` `FeGaussianBlurElement`.
ReactDomComponentFactoryProxy feGaussianBlur = _createDomFactory('feGaussianBlur');

/// The SVG `<feImage>` `FeImageElement`.
ReactDomComponentFactoryProxy feImage = _createDomFactory('feImage');

/// The SVG `<feMerge>` `FeMergeElement`.
ReactDomComponentFactoryProxy feMerge = _createDomFactory('feMerge');

/// The SVG `<feMergeNode>` `FeMergeNodeElement`.
ReactDomComponentFactoryProxy feMergeNode = _createDomFactory('feMergeNode');

/// The SVG `<feMorphology>` `FeMorphologyElement`.
ReactDomComponentFactoryProxy feMorphology = _createDomFactory('feMorphology');

/// The SVG `<feOffset>` `FeOffsetElement`.
ReactDomComponentFactoryProxy feOffset = _createDomFactory('feOffset');

/// The SVG `<fePointLight>` `FePointLightElement`.
ReactDomComponentFactoryProxy fePointLight = _createDomFactory('fePointLight');

/// The SVG `<feSpecularLighting>` `FeSpecularLightingElement`.
ReactDomComponentFactoryProxy feSpecularLighting = _createDomFactory('feSpecularLighting');

/// The SVG `<feSpotLight>` `FeSpotLightElement`.
ReactDomComponentFactoryProxy feSpotLight = _createDomFactory('feSpotLight');

/// The SVG `<feTile>` `FeTileElement`.
ReactDomComponentFactoryProxy feTile = _createDomFactory('feTile');

/// The SVG `<feTurbulence>` `FeTurbulenceElement`.
ReactDomComponentFactoryProxy feTurbulence = _createDomFactory('feTurbulence');

/// The SVG `<filter>` `FilterElement`.
ReactDomComponentFactoryProxy filter = _createDomFactory('filter');

/// The SVG `<font>` `FontElement`.
ReactDomComponentFactoryProxy font = _createDomFactory('font');

/// The SVG `<font-face>` `FontFaceElement`.
ReactDomComponentFactoryProxy fontFace = _createDomFactory('font-face');

/// The SVG `<font-face-format>` `FontFaceFormatElement`.
ReactDomComponentFactoryProxy fontFaceFormat = _createDomFactory('font-face-format');

/// The SVG `<font-face-name>` `FontFaceNameElement`.
ReactDomComponentFactoryProxy fontFaceName = _createDomFactory('font-face-name');

/// The SVG `<font-face-src>` `FontFaceSrcElement`.
ReactDomComponentFactoryProxy fontFaceSrc = _createDomFactory('font-face-src');

/// The SVG `<font-face-uri>` `FontFaceUriElement`.
ReactDomComponentFactoryProxy fontFaceUri = _createDomFactory('font-face-uri');

/// The SVG `<foreignObject>` `ForeignObjectElement`.
ReactDomComponentFactoryProxy foreignObject = _createDomFactory('foreignObject');

/// The SVG `<g>` `GElement`.
ReactDomComponentFactoryProxy g = _createDomFactory('g');

/// The SVG `<glyph>` `GlyphElement`.
ReactDomComponentFactoryProxy glyph = _createDomFactory('glyph');

/// The SVG `<glyphRef>` `GlyphRefElement`.
ReactDomComponentFactoryProxy glyphRef = _createDomFactory('glyphRef');

/// The SVG `<hatch>` `HatchElement`.
ReactDomComponentFactoryProxy hatch = _createDomFactory('hatch');

/// The SVG `<hatchpath>` `HatchpathElement`.
ReactDomComponentFactoryProxy hatchpath = _createDomFactory('hatchpath');

/// The SVG `<hkern>` `HkernElement`.
ReactDomComponentFactoryProxy hkern = _createDomFactory('hkern');

/// The SVG `<image>` `ImageElement`.
ReactDomComponentFactoryProxy image = _createDomFactory('image');

/// The SVG `<line>` `LineElement`.
ReactDomComponentFactoryProxy line = _createDomFactory('line');

/// The SVG `<linearGradient>` `LinearGradientElement`.
ReactDomComponentFactoryProxy linearGradient = _createDomFactory('linearGradient');

/// The SVG `<marker>` `MarkerElement`.
ReactDomComponentFactoryProxy marker = _createDomFactory('marker');

/// The SVG `<mask>` `MaskElement`.
ReactDomComponentFactoryProxy mask = _createDomFactory('mask');

/// The SVG `<mesh>` `MeshElement`.
ReactDomComponentFactoryProxy mesh = _createDomFactory('mesh');

/// The SVG `<meshgradient>` `MeshgradientElement`.
ReactDomComponentFactoryProxy meshgradient = _createDomFactory('meshgradient');

/// The SVG `<meshpatch>` `MeshpatchElement`.
ReactDomComponentFactoryProxy meshpatch = _createDomFactory('meshpatch');

/// The SVG `<meshrow>` `MeshrowElement`.
ReactDomComponentFactoryProxy meshrow = _createDomFactory('meshrow');

/// The SVG `<metadata>` `MetadataElement`.
ReactDomComponentFactoryProxy metadata = _createDomFactory('metadata');

/// The SVG `<missing-glyph>` `MissingGlyphElement`.
ReactDomComponentFactoryProxy missingGlyph = _createDomFactory('missing-glyph');

/// The SVG `<mpath>` `MpathElement`.
ReactDomComponentFactoryProxy mpath = _createDomFactory('mpath');

/// The SVG `<path>` `PathElement`.
ReactDomComponentFactoryProxy path = _createDomFactory('path');

/// The SVG `<pattern>` `PatternElement`.
ReactDomComponentFactoryProxy pattern = _createDomFactory('pattern');

/// The SVG `<polygon>` `PolygonElement`.
ReactDomComponentFactoryProxy polygon = _createDomFactory('polygon');

/// The SVG `<polyline>` `PolylineElement`.
ReactDomComponentFactoryProxy polyline = _createDomFactory('polyline');

/// The SVG `<radialGradient>` `RadialGradientElement`.
ReactDomComponentFactoryProxy radialGradient = _createDomFactory('radialGradient');

/// The SVG `<rect>` `RectElement`.
ReactDomComponentFactoryProxy rect = _createDomFactory('rect');

/// The SVG `<set>` `SetElement`.
ReactDomComponentFactoryProxy svgSet = _createDomFactory('set');

/// The SVG `<solidcolor>` `SolidcolorElement`.
ReactDomComponentFactoryProxy solidcolor = _createDomFactory('solidcolor');

/// The SVG `<stop>` `StopElement`.
ReactDomComponentFactoryProxy stop = _createDomFactory('stop');

/// The SVG `<svg>` `SvgSvgElement`.
ReactDomComponentFactoryProxy svg = _createDomFactory('svg');

/// The SVG `<switch>` `SwitchElement`.
ReactDomComponentFactoryProxy svgSwitch = _createDomFactory('switch');

/// The SVG `<symbol>` `SymbolElement`.
ReactDomComponentFactoryProxy symbol = _createDomFactory('symbol');

/// The SVG `<text>` `TextElement`.
ReactDomComponentFactoryProxy text = _createDomFactory('text');

/// The SVG `<textPath>` `TextPathElement`.
ReactDomComponentFactoryProxy textPath = _createDomFactory('textPath');

/// The SVG `<tref>` `TrefElement`.
ReactDomComponentFactoryProxy tref = _createDomFactory('tref');

/// The SVG `<tspan>` `TSpanElement`.
ReactDomComponentFactoryProxy tspan = _createDomFactory('tspan');

/// The SVG `<unknown>` `UnknownElement`.
ReactDomComponentFactoryProxy unknown = _createDomFactory('unknown');

/// The SVG `<use>` `UseElement`.
ReactDomComponentFactoryProxy use = _createDomFactory('use');

/// The SVG `<view>` `ViewElement`.
ReactDomComponentFactoryProxy view = _createDomFactory('view');

/// The SVG `<vkern>` `VkernElement`.
ReactDomComponentFactoryProxy vkern = _createDomFactory('vkern');
