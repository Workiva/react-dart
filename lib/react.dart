// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A Dart library for building UI using ReactJS.
library react;

import 'package:meta/meta.dart';
import 'package:react/src/typedefs.dart';
import 'package:react/react_client.dart';

typedef T ComponentFactory<T extends Component>();
typedef ReactComponentFactoryProxy ComponentRegistrar(ComponentFactory componentFactory,
    [Iterable<String> skipMethods]);

/// Top-level ReactJS [Component class](https://facebook.github.io/react/docs/react-component.html)
/// which provides the [ReactJS Component API](https://facebook.github.io/react/docs/react-component.html#reference)
///
/// __Deprecated. Use [Component2] instead.__
@Deprecated('6.0.0')
abstract class Component {
  Map _context;

  /// A private field that backs [props], which is exposed via getter/setter so
  /// it can be overridden in strong mode.
  ///
  /// Necessary since the `@virtual` annotation within the meta package
  /// [doesn't work for overriding fields](https://github.com/dart-lang/sdk/issues/27452).
  ///
  /// TODO: Switch back to a plain field once this issue is fixed.
  Map _props;

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
  Ref _ref;

  /// The React context map of this component, passed down from its ancestors' [getChildContext] value.
  ///
  /// Only keys declared in this component's [contextKeys] will be present.
  ///
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > It is strongly recommended that you migrate to [Component2] and use [Component2.context] instead.
  @experimental
  dynamic get context => _context;

  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > It is strongly recommended that you migrate to [Component2] and use [Component2.context] instead.
  @experimental
  set context(dynamic value) => _context = value;

  /// ReactJS [Component] props.
  ///
  /// Related: [state]
  Map get props => _props;
  set props(Map value) => _props = value;

  /// ReactJS [Component] state.
  ///
  /// Related: [props]
  Map get state => _state;
  set state(Map value) => _state = value;

  /// __DEPRECATED.__
  ///
  /// Support for String `ref`s will be removed in the `6.0.0` release when `Component` is removed.
  ///
  /// There are new and improved ways to use / set refs within [Component2].
  /// Until then, use a callback ref instead.
  ///
  /// TODO: Add better description of how to utilize [Component2] refs.
  @Deprecated('6.0.0')
  Ref get ref => _ref;

  /// __DEPRECATED.__
  ///
  /// Support for String `ref`s will be removed in the `6.0.0` release when `Component` is removed.
  ///
  /// There are new and improved ways to use / set refs within [Component2].
  /// Until then, use a callback ref instead.
  ///
  /// TODO: Add better description of how to utilize [Component2] refs.
  @Deprecated('6.0.0')
  set ref(Ref value) => _ref = value;

  dynamic _jsRedraw;

  dynamic _jsThis;

  List<SetStateCallback> _setStateCallbacks = [];

  List<StateUpdaterCallback> _transactionalSetStateCallbacks = [];

  /// The List of callbacks to be called after the component has been updated from a call to [setState].
  List get setStateCallbacks => _setStateCallbacks;

  /// The List of transactional `setState` callbacks to be called before the component updates.
  List get transactionalSetStateCallbacks => _transactionalSetStateCallbacks;

  /// The JavaScript [`ReactComponent`](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render)
  /// instance of this `Component` returned by [render].
  dynamic get jsThis => _jsThis;

  /// Allows the [ReactJS `displayName` property](https://facebook.github.io/react/docs/react-component.html#displayname)
  /// to be set for debugging purposes.
  String get displayName => runtimeType.toString();

  /// Bind the value of input to [state[key]].
  ///
  /// __DEPRECATED.__
  ///
  /// This will be removed in the `6.0.0` release when `Component` is removed.
  ///
  /// There is currently no planned support for it within [Component2]
  /// since there was never a ReactJS analogue for this API.
  @Deprecated('6.0.0')
  bind(key) => [
        state[key],
        (value) => setState({key: value})
      ];

  initComponentInternal(props, _jsRedraw, [Ref ref, _jsThis, context]) {
    this._jsRedraw = _jsRedraw;
    this.ref = ref;
    this._jsThis = _jsThis;
    _initContext(context);
    _initProps(props);
  }

  /// Initializes context
  _initContext(context) {
    this.context = new Map.from(context ?? const {});
    this.nextContext = new Map.from(this.context ?? const {});
  }

  _initProps(props) {
    this.props = new Map.from(props);
    this.nextProps = this.props;
  }

  initStateInternal() {
    this.state = new Map.from(getInitialState());

    // Call `transferComponentState` to get state also to `_prevState`
    transferComponentState();
  }

  /// Private reference to the value of [context] for the upcoming render cycle.
  ///
  /// Useful for ReactJS lifecycle methods [shouldComponentUpdateWithContext].
  dynamic nextContext;

  /// Private reference to the value of [state] for the upcoming render cycle.
  ///
  /// Useful for ReactJS lifecycle methods [shouldComponentUpdate], [componentWillUpdate] and [componentDidUpdate].
  Map _nextState;

  /// Reference to the value of [context] from the previous render cycle, used internally for proxying
  /// the ReactJS lifecycle method.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  Map prevContext;

  /// Reference to the value of [state] from the previous render cycle, used internally for proxying
  /// the ReactJS lifecycle method and [componentDidUpdate].
  ///
  /// Not available after [componentDidUpdate] is called.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  Map prevState;

  /// Public getter for [_nextState].
  ///
  /// If `null`, then [_nextState] is equal to [state] - which is the value that will be returned.
  Map get nextState => _nextState == null ? state : _nextState;

  /// Reference to the value of [props] for the upcoming render cycle.
  ///
  /// Used internally for proxying ReactJS lifecycle methods [shouldComponentUpdate], [componentWillReceiveProps], and
  /// [componentWillUpdate] as well as the context-specific variants.
  ///
  /// __DO NOT set__ from anywhere outside react-dart lifecycle internals.
  Map nextProps;

  /// Transfers `Component` [_nextState] to [state], and [state] to [prevState].
  ///
  /// > __DEPRECATED.__
  /// >
  /// > This was never designed for public consumption, and there will be no replacement implementation in `Component2`.
  /// >
  /// > Will be removed in `6.0.0` along with `Component`.
  @Deprecated('6.0.0')
  void transferComponentState() {
    prevState = state;
    if (_nextState != null) {
      state = _nextState;
    }
    _nextState = new Map.from(state);
  }

  /// Force a call to [render] by calling [setState], which effectively "redraws" the `Component`.
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// > __DEPRECATED.__
  /// >
  /// > There is no implementation of this within [Component2]. Use [Component2.forceUpdate] when migrating.
  @Deprecated('6.0.0')
  void redraw([callback()]) {
    setState({}, callback);
  }

  /// Triggers a rerender with new state obtained by shallow-merging [newState] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// Also allows [newState] to be used as a transactional `setState` callback.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#setstate>
  ///
  /// > __DEPRECATED.__
  /// >
  /// > Note that when migrating to [Component2], [Component2.setState] will only accept a `Map` for [newState].
  /// > Transactional `setState` calls will have to be changed to utilize [Component2.setStateWithUpdater].
  @Deprecated('6.0.0')
  void setState(covariant dynamic newState, [callback()]) {
    if (newState is Map) {
      _nextState.addAll(newState);
    } else if (newState is StateUpdaterCallback) {
      _transactionalSetStateCallbacks.add(newState);
    } else if (newState != null) {
      throw new ArgumentError(
          'setState expects its first parameter to either be a Map or a `TransactionalSetStateCallback`.');
    } else {
      // newState is null, so short-circuit to match the ReactJS 16 behavior of not re-rendering the component if newState is null.
      return;
    }

    if (callback != null) _setStateCallbacks.add(callback);

    _jsRedraw();
  }

  /// Set [_nextState] to provided [newState] value and force a re-render.
  ///
  /// Optionally accepts a callback that gets called after the component updates.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#setstate>
  ///
  /// > __DEPRECATED.__
  /// >
  /// > Use [setState] instead.
  @Deprecated('6.0.0')
  void replaceState(Map newState, [callback()]) {
    Map nextState = newState == null ? {} : new Map.from(newState);
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
  /// See: <https://facebook.github.io/react/docs/react-component.html#mounting-componentwillmount>
  void componentWillMount() {}

  /// ReactJS lifecycle method that is invoked once, only on the client _(not on the server)_, immediately after the
  /// initial rendering occurs.
  ///
  /// At this point in the lifecycle, you can access any [ref]s to the children of [rootNode].
  ///
  /// The [componentDidMount] method of child `Component`s is invoked _before_ that of parent `Component`.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#mounting-componentdidmount>
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
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-componentwillreceiveprops>
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This will be removed once 6.0.0 releases, switching to [Component2.getDerivedStateFromProps] is the path forward
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillReceiveProps(Map newProps) {}

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillReceivePropsWithContext(Map newProps, Map nextContext) {}

  /// ReactJS lifecycle method that is invoked before rendering when [nextProps] or [nextState] are being received.
  ///
  /// Use this as an opportunity to return `false` when you're certain that the transition to the new props and state
  /// will not require a component update.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-shouldcomponentupdate>
  bool shouldComponentUpdate(Map nextProps, Map nextState) => true;

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  bool shouldComponentUpdateWithContext(Map nextProps, Map nextState, Map nextContext) => null;

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
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-componentwillupdate>
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > Due to the release of getSnapshotBeforeUpdate in ReactJS 16,
  /// > componentWillUpdate is no longer the method used to check the state
  /// > and props before a re-render. Both the Component class and
  /// > componentWillUpdate will be removed in the react.dart 6.0.0 release.
  /// > Use Component2 and Component2.getSnapshotBeforeUpdate instead.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillUpdate(Map nextProps, Map nextState) {}

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillUpdateWithContext(Map nextProps, Map nextState, Map nextContext) {}

  /// ReactJS lifecycle method that is invoked immediately after the `Component`'s updates are flushed to the DOM.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to operate on the [rootNode] (DOM) when the `Component` has been updated as a result
  /// of the values of [prevProps] / [prevState].
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-componentdidupdate>
  void componentDidUpdate(Map prevProps, Map prevState) {}

  /// ReactJS lifecycle method that is invoked immediately before a `Component` is unmounted from the DOM.
  ///
  /// Perform any necessary cleanup in this method, such as invalidating timers or cleaning up any DOM [Element]s that
  /// were created in [componentDidMount].
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#unmounting-componentwillunmount>
  void componentWillUnmount() {}

  /// Returns a Map of context to be passed to descendant components.
  ///
  /// Only keys present in [childContextKeys] will be used; all others will be ignored.
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  Map<String, dynamic> getChildContext() => const {};

  /// The keys this component uses in its child context map (returned by [getChildContext]).
  ///
  /// __This method is called only once, upon component registration.__
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  Iterable<String> get childContextKeys => const [];

  /// The keys of context used by this component.
  ///
  /// __This method is called only once, upon component registration.__
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that is exposed via the [Component2] class.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  Iterable<String> get contextKeys => const [];

  /// Invoked once before the `Component` is mounted. The return value will be used as the initial value of [state].
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#getinitialstate>
  Map getInitialState() => {};

  /// Invoked once and cached when [reactComponentClass] is called. Values in the mapping will be set on [props]
  /// if that prop is not specified by the parent component.
  ///
  /// This method is invoked before any instances are created and thus cannot rely on [props]. In addition, be aware
  /// that any complex objects returned by `getDefaultProps` will be shared across instances, not copied.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#getdefaultprops>
  Map getDefaultProps() => {};

  /// __Required.__
  ///
  /// When called, it should examine [props] and [state] and return a single child [Element]. This child [Element] can
  /// be either a virtual representation of a native DOM component (such as [DivElement]) or another composite
  /// `Component` that you've defined yourself.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#render>
  dynamic render();
}

abstract class Component2Adapter {
  void setState(Map newState, SetStateCallback callback);
  void setStateWithUpdater(StateUpdaterCallback stateUpdater, SetStateCallback callback);
  void forceUpdate(SetStateCallback callback);
}

/// Top-level ReactJS [Component class](https://facebook.github.io/react/docs/react-component.html)
/// which provides the [ReactJS Component API](https://facebook.github.io/react/docs/react-component.html#reference)
abstract class Component2 implements Component {
  // TODO make private using expando?
  Component2Adapter adapter;

  /// Accessed once and cached when instance is created. The [contextType] property on a class can be assigned
  /// a [ReactDartContext] object created by [React.createContext]. This lets you consume the nearest current value of
  /// that Context using [context].
  ReactDartContext contextType;

  /// The context value from the [contextType] assigned to this component.
  /// The value is passed down from the provider of the same [contextType].
  /// You can reference [context] in any of the lifecycle methods including the render function.
  ///
  /// If you need multiple context values, consider using multiple consumers instead.
  /// Read more: https://reactjs.org/docs/context.html#consuming-multiple-contexts
  ///
  /// This only has a value when [contextType] is set.
  @override
  dynamic context;

  @override
  Map props;

  @override
  Map state;

  @override
  dynamic _jsThis;

  /// The JavaScript [`ReactComponent`](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render)
  /// instance of this `Component` returned by [render].
  dynamic jsThis;

  /// Allows the [ReactJS `displayName` property](https://facebook.github.io/react/docs/react-component.html#displayname)
  /// to be set for debugging purposes.
  ///
  /// In DDC, this will be the class name, but in dart2js it will be null unless
  /// overridden, since using runtimeType can lead to larger dart2js output.
  ///
  /// This will result in the dart2js name being `ReactDartComponent2` (the
  /// name of the proxying JS component defined in _dart_helpers.js).
  String get displayName {
    var value;
    assert(() {
      value = runtimeType.toString();
      return true;
    }());
    return value;
  }

  /// Triggers a rerender with new state obtained by shallow-merging [newState] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// To use a transactional `setState` callback, check out [setStateWithUpdater].
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  void setState(Map newState, [SetStateCallback callback]) {
    adapter.setState(newState, callback);
  }

  /// Triggers a rerender with new state obtained by shallow-merging
  /// the return value of [updater] into the current [state].
  ///
  /// Optionally accepts a [callback] that gets called after the component updates.
  ///
  /// See: <https://reactjs.org/docs/react-component.html#setstate>
  void setStateWithUpdater(StateUpdaterCallback updater, [SetStateCallback callback]) {
    adapter.setStateWithUpdater(updater, callback);
  }

  void forceUpdate([SetStateCallback callback]) {
    adapter.forceUpdate(callback);
  }

  /// ReactJS lifecycle method that is invoked once, both on the client and server, immediately before the initial
  /// rendering occurs.
  ///
  /// If you call [setState] within this method, [render] will see the updated state and will be executed only once
  /// despite the [state] value change.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#mounting-componentwillmount>
  void componentWillMount() {}

  /// ReactJS lifecycle method that is invoked once, only on the client _(not on the server)_, immediately after the
  /// initial rendering occurs.
  ///
  /// At this point in the lifecycle, you can access any [ref]s to the children of [rootNode].
  ///
  /// The [componentDidMount] method of child `Component`s is invoked _before_ that of parent `Component`.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#mounting-componentdidmount>
  void componentDidMount() {}

  /// ReactJS lifecycle method that is invoked when a `Component` is receiving [newProps].
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to react to a prop transition before [render] is called by updating the [state] using
  /// [setState]. The old props can be accessed via [props].
  ///
  /// Calling [setState] within this function will not trigger an additional [render].
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This will be removed once 6.0.0 releases, switching to [Component2.getDerivedStateFromProps] is the path forward
  /// > 
  /// > React 16 has deprecated [componentWillReceiveProps] in favor of [getDerivedStateFromProps]
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @mustCallSuper
  @Deprecated('6.0.0')
  void componentWillReceiveProps(Map newProps) {}

  /// ReactJS lifecycle method that is invoked before rendering on the intial mount and on subsequent updates
  /// It should return an object to update the state, or null to update nothing (this is different from componentWillRecieveProps).
  ///
  /// [prevState] will be null when this lifcecyle method is called before first mount.
  /// 
  /// This method is also static, so features like [this] or [ref] cannot be used in this method
  ///
  /// See: <https://reactjs.org/docs/react-component.html#static-getderivedstatefromprops>
  /// 
  /// __Example__:
  /// 
  ///    getDerivedStateFromProps(nextProps, prevState) {
  ///      if (prevState.someMirroredValue != nextProps.someValue) {
  ///       return {
  ///         derivedData: computeDerivedState(nextProps),
  ///         someMirroredValue: nextProps.someValue
  ///       };
  ///      }
  ///      return null;
  ///    }
  /// 
  Map getDerivedStateFromProps(Map nextProps, Map prevState) {}

  /// ReactJS lifecycle method that is invoked before rendering when [nextProps], [nextState], or [nextContext] are
  /// being received.
  ///
  /// Use this as an opportunity to return `false` when you're certain that the transition to the new props and state
  /// will not require a component update.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-shouldcomponentupdate>
  bool shouldComponentUpdate(Map nextProps, Map nextState, [dynamic nextContext]) => true;

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
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-componentwillupdate>
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > Due to the release of getSnapshotBeforeUpdate in ReactJS 16,
  /// > componentWillUpdate is no longer the method used to check the state
  /// > and props before a re-render. Additionally, because of the presence
  /// > of getSnapshotBeforeUpdate, componentWillUpdate will be ignored. Use
  /// > getSnapshotBeforeUpdate instead.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillUpdate(Map nextProps, Map nextState) {}

  /// ReactJS lifecycle method that is invoked immediately after rendering
  /// before [nextProps] and [nextState] are committed to the DOM.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to perform preparation before an update occurs.
  ///
  /// __Example__:
  ///
  ///     getSnapshotBeforeUpdate(prevProps, prevState) {
  ///
  ///       // Previous props / state can be analyzed and compared to this.props or
  ///       // this.state, allowing the opportunity perform decision logic.
  ///       // Are we adding new items to the list?
  ///       // Capture the scroll position so we can adjust scroll later.
  ///
  ///       if (prevProps.list.length < props.list.length) {
  ///
  ///         // The return value from getSnapshotBeforeUpdate is passed into
  ///         // componentDidUpdate's third parameter (which is new to React 16).
  ///
  ///         final list = _listRef;
  ///         return list.scrollHeight - list.scrollTop;
  ///       }
  ///       return null;
  ///     }
  ///
  ///     componentDidUpdate(prevProps, prevState, snapshot) {
  ///       // If we have a snapshot value, we've just added new items.
  ///       // Adjust scroll so these new items don't push the old ones out of
  ///       // view.
  ///       // (snapshot here is the value returned from getSnapshotBeforeUpdate)
  ///       if (snapshot !== null) {
  ///         final list = _listRef;
  ///         list.scrollTop = list.scrollHeight - snapshot;
  ///       }
  ///     }
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#getsnapshotbeforeupdate>
  dynamic getSnapshotBeforeUpdate(Map prevProps, Map prevState) {}

  /// ReactJS lifecycle method that is invoked immediately after the `Component`'s updates are flushed to the DOM.
  ///
  /// This method is not called for the initial [render].
  ///
  /// Use this as an opportunity to operate on the [rootNode] (DOM) when the `Component` has been updated as a result
  /// of the values of [prevProps] / [prevState].
  ///
  /// __Note__: React 16 added a third parameter to componentDidUpdate, which
  /// is a custom value returned in [getSnapshotBeforeUpdate]. If a specified
  /// value is not returned in getSnapshotBeforeUpdate, the [snapshot]
  /// parameter in componentDidUpdate will be null.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#updating-componentdidupdate>
  void componentDidUpdate(Map prevProps, Map prevState, [dynamic snapshot]) {}

  /// ReactJS lifecycle method that is invoked immediately before a `Component` is unmounted from the DOM.
  ///
  /// Perform any necessary cleanup in this method, such as invalidating timers or cleaning up any DOM [Element]s that
  /// were created in [componentDidMount].
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#unmounting-componentwillunmount>
  void componentWillUnmount() {}

  /// Invoked once before the `Component` is mounted. The return value will be used as the initial value of [state].
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#getinitialstate>
  Map getInitialState() => const {};

  /// Invoked once and cached when [reactComponentClass] is called. Values in the mapping will be set on [props]
  /// if that prop is not specified by the parent component.
  ///
  /// This method is invoked before any instances are created and thus cannot rely on [props]. In addition, be aware
  /// that any complex objects returned by `getDefaultProps` will be shared across instances, not copied.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#getdefaultprops>
  Map getDefaultProps() => const {};

  /// __Required.__
  ///
  /// When called, it should examine [props] and [state] and return a single child [Element]. This child [Element] can
  /// be either a virtual representation of a native DOM component (such as [DivElement]) or another composite
  /// `Component` that you've defined yourself.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#render>
  dynamic render();

  // Unsupported things

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  void replaceState(Map newState, [SetStateCallback callback]) => throw new UnimplementedError();

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Map<String, dynamic> getChildContext() => const {};

  /// Do not use. Use [shouldComponentUpdate] with an optional 3rd argument for context instead.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  bool shouldComponentUpdateWithContext(Map nextProps, Map nextState, dynamic nextContext) => null;

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  void componentWillUpdateWithContext(Map nextProps, Map nextState, Map nextContext) {}

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  void componentWillReceivePropsWithContext(Map newProps, nextContext) {}

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Iterable<String> get childContextKeys => const [];

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Iterable<String> get contextKeys => const [];

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  bind(key) => [
        state[key],
        (value) => setState({key: value})
      ];

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  initComponentInternal(props, _jsRedraw, [Ref ref, _jsThis, context]) {
    throw new UnimplementedError();
  }

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  initStateInternal() => throw new UnimplementedError();

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  dynamic nextContext; // todo make throwing getters/setters

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Map prevContext; // todo make throwing getters/setters

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Map prevState; // todo make throwing getters/setters

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Map get nextState => throw new UnimplementedError();

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  Map nextProps; // todo make throwing getters/setters

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  void transferComponentState() => throw new UnimplementedError();

  /// Do not use.
  ///
  /// Will be removed when [Component] is removed in the `6.0.0` release.
  @Deprecated('6.0.0')
  void redraw([SetStateCallback callback]) {
    setState({}, callback);
  }

  @override
  Map _context;

  @override
  var _jsRedraw;

  @override
  Map _nextState;

  @override
  Map _props;

  @override
  Ref _ref;

  @override
  List<SetStateCallback> _setStateCallbacks;

  @override
  Map _state;

  @override
  List<StateUpdaterCallback> _transactionalSetStateCallbacks;

  @override
  Ref ref;

  @override
  _initContext(context) {
    throw new UnimplementedError();
  }

  @override
  _initProps(props) {
    throw new UnimplementedError();
  }

  @override
  List<SetStateCallback> get setStateCallbacks => throw new UnimplementedError();

  @override
  List<StateUpdaterCallback> get transactionalSetStateCallbacks => throw new UnimplementedError();
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
mixin TypedSnapshot<TSnapshot> on Component2 {
  @override
  TSnapshot getSnapshotBeforeUpdate(Map prevProps, Map prevState);

  @override
  void componentDidUpdate(Map prevProps, Map prevState, [covariant TSnapshot snapshot]);
}

/// Creates a ReactJS virtual DOM instance (`ReactElement` on the client).
abstract class ReactComponentFactoryProxy implements Function {
  /// The type of component created by this factory.
  get type;

  /// Returns a new rendered component instance with the specified [props] and [children].
  ///
  /// Necessary to work around DDC `dart.dcall` issues in <https://github.com/dart-lang/sdk/issues/29904>,
  /// since invoking the function directly doesn't work.
  dynamic /*ReactElement*/ build(Map props, [List childrenArgs]);

  /// Returns a new rendered component instance with the specified [props] and `children` ([c1], [c2], et. al.).
  ///
  /// > The additional children arguments (c2, c3, et. al.) are a workaround for <https://github.com/dart-lang/sdk/issues/16030>.
  dynamic /*ReactElement*/ call(Map props,
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
      childArguments = [];
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

const _notSpecified = const NotSpecified();

class NotSpecified {
  const NotSpecified();
}

/// A cross-browser wrapper around the browser's [nativeEvent].
///
/// It has the same interface as the browser's native event, including [stopPropagation] and [preventDefault], except
/// the events work identically across all browsers.
///
/// See: <https://facebook.github.io/react/docs/events.html#syntheticevent>
class SyntheticEvent {
  /// Indicates whether the [Event] bubbles up through the DOM or not.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/bubbles>
  final bool bubbles;

  /// Indicates whether the [Event] is cancelable or not.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/cancelable>
  final bool cancelable;

  /// Identifies the current target for the event, as the [Event] traverses the DOM.
  ///
  /// It always refers to the [Element] the [Event] handler has been attached to as opposed to [target] which identifies
  /// the [Element] on which the [Event] occurred.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/currentTarget>
  final /*DOMEventTarget*/ currentTarget;

  bool _defaultPrevented;

  dynamic _preventDefault;

  /// Indicates whether or not [preventDefault] was called on the event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/defaultPrevented>
  bool get defaultPrevented => _defaultPrevented;

  /// Cancels the [Event] if it is [cancelable], without stopping further propagation of the event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault>
  void preventDefault() {
    _defaultPrevented = true;
    _preventDefault();
  }

  /// Prevents further propagation of the current event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation>
  final dynamic stopPropagation;

  /// Indicates which phase of the [Event] flow is currently being evaluated.
  ///
  /// Possible values:
  ///
  /// > [Event.CAPTURING_PHASE] (1) - The [Event] is being propagated through the [target]'s ancestor objects. This
  /// process starts with the Window, then [HtmlDocument], then the [HtmlHtmlElement], and so on through the [Element]s
  /// until the [target]'s parent is reached. Event listeners registered for capture mode when
  /// [EventTarget.addEventListener] was called are triggered during this phase.
  ///
  /// > [Event.AT_TARGET] (2) - The [Event] has arrived at the [target]. Event listeners registered for this phase are
  /// called at this time. If [bubbles] is `false`, processing the [Event] is finished after this phase is complete.
  ///
  /// > [Event.BUBBLING_PHASE] (3) - The [Event] is propagating back up through the [target]'s ancestors in reverse
  /// order, starting with the parent, and eventually reaching the containing Window. This is known as bubbling, and
  /// occurs only if [bubbles] is `true`. [Event] listeners registered for this phase are triggered during this process.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/eventPhase>
  final num eventPhase;

  /// Is `true` when the [Event] was generated by a user action, and `false` when the [Event] was created or modified
  /// by a script or dispatched via [Event.dispatchEvent].
  ///
  /// __Read Only__
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/isTrusted>
  final bool isTrusted;

  /// Native browser event that [SyntheticEvent] wraps around.
  final /*DOMEvent*/ nativeEvent;

  /// A reference to the object that dispatched the event. It is different from [currentTarget] when the [Event]
  /// handler is called when [eventPhase] is [Event.BUBBLING_PHASE] or [Event.CAPTURING_PHASE].
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/target>
  final /*DOMEventTarget*/ target;

  /// Returns the [Time] (in milliseconds) at which the [Event] was created.
  ///
  /// _Starting with Chrome 49, returns a high-resolution monotonic time instead of epoch time._
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/timeStamp>
  final num timeStamp;

  /// Returns a string containing the type of event. It is set when the [Event] is constructed and is the name commonly
  /// used to refer to the specific event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/type>
  final String type;

  SyntheticEvent(
      this.bubbles,
      this.cancelable,
      this.currentTarget,
      this._defaultPrevented,
      this._preventDefault,
      this.stopPropagation,
      this.eventPhase,
      this.isTrusted,
      this.nativeEvent,
      this.target,
      this.timeStamp,
      this.type) {}
}

class SyntheticClipboardEvent extends SyntheticEvent {
  final clipboardData;

  SyntheticClipboardEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.clipboardData,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticKeyboardEvent extends SyntheticEvent {
  final bool altKey;
  final String char;
  final bool ctrlKey;
  final String locale;
  final num location;
  final String key;
  final bool metaKey;
  final bool repeat;
  final bool shiftKey;
  final num keyCode;
  final num charCode;

  SyntheticKeyboardEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.altKey,
    this.char,
    this.charCode,
    this.ctrlKey,
    this.locale,
    this.location,
    this.key,
    this.keyCode,
    this.metaKey,
    this.repeat,
    this.shiftKey,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticFocusEvent extends SyntheticEvent {
  final /*DOMEventTarget*/ relatedTarget;

  SyntheticFocusEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.relatedTarget,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticFormEvent extends SyntheticEvent {
  SyntheticFormEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticDataTransfer {
  final String dropEffect;
  final String effectAllowed;
  final List files;
  final List<String> types;

  SyntheticDataTransfer(this.dropEffect, this.effectAllowed, this.files, this.types);
}

class SyntheticMouseEvent extends SyntheticEvent {
  final bool altKey;
  final num button;
  final num buttons;
  final num clientX;
  final num clientY;
  final bool ctrlKey;
  final SyntheticDataTransfer dataTransfer;
  final bool metaKey;
  final num pageX;
  final num pageY;
  final /*DOMEventTarget*/ relatedTarget;
  final num screenX;
  final num screenY;
  final bool shiftKey;

  SyntheticMouseEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.altKey,
    this.button,
    this.buttons,
    this.clientX,
    this.clientY,
    this.ctrlKey,
    this.dataTransfer,
    this.metaKey,
    this.pageX,
    this.pageY,
    this.relatedTarget,
    this.screenX,
    this.screenY,
    this.shiftKey,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticPointerEvent extends SyntheticEvent {
  final num pointerId;
  final num width;
  final num height;
  final num pressure;
  final num tangentialPressure;
  final num tiltX;
  final num tiltY;
  final num twist;
  final String pointerType;
  final bool isPrimary;

  SyntheticPointerEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.pointerId,
    this.width,
    this.height,
    this.pressure,
    this.tangentialPressure,
    this.tiltX,
    this.tiltY,
    this.twist,
    this.pointerType,
    this.isPrimary,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticTouchEvent extends SyntheticEvent {
  final bool altKey;
  final /*DOMTouchList*/ changedTouches;
  final bool ctrlKey;
  final bool metaKey;
  final bool shiftKey;
  final /*DOMTouchList*/ targetTouches;
  final /*DOMTouchList*/ touches;

  SyntheticTouchEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.altKey,
    this.changedTouches,
    this.ctrlKey,
    this.metaKey,
    this.shiftKey,
    this.targetTouches,
    this.touches,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticUIEvent extends SyntheticEvent {
  final num detail;
  final /*DOMAbstractView*/ view;

  SyntheticUIEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool _defaultPrevented,
    dynamic _preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.detail,
    this.view,
  ) : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticWheelEvent extends SyntheticEvent {
  final num deltaX;
  final num deltaMode;
  final num deltaY;
  final num deltaZ;

  SyntheticWheelEvent(
    bool bubbles,
    bool cancelable,
    dynamic currentTarget,
    bool defaultPrevented,
    dynamic preventDefault,
    dynamic stopPropagation,
    num eventPhase,
    bool isTrusted,
    dynamic nativeEvent,
    dynamic target,
    num timeStamp,
    String type,
    this.deltaX,
    this.deltaMode,
    this.deltaY,
    this.deltaZ,
  ) : super(bubbles, cancelable, currentTarget, defaultPrevented, preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

/// Registers [componentFactory] on both client and server.
/*ComponentRegistrar*/ Function registerComponent =
    (/*ComponentFactory*/ componentFactory, [/*Iterable<String>*/ skipMethods]) {
  throw new Exception('setClientConfiguration must be called before registerComponent.');
};

/// The HTML `<a>` [AnchorElement].
var a;

/// The HTML `<abbr>` [Element].
var abbr;

/// The HTML `<address>` [Element].
var address;

/// The HTML `<area>` [AreaElement].
var area;

/// The HTML `<article>` [Element].
var article;

/// The HTML `<aside>` [Element].
var aside;

/// The HTML `<audio>` [AudioElement].
var audio;

/// The HTML `<b>` [Element].
var b;

/// The HTML `<base>` [BaseElement].
var base;

/// The HTML `<bdi>` [Element].
var bdi;

/// The HTML `<bdo>` [Element].
var bdo;

/// The HTML `<big>` [Element].
var big;

/// The HTML `<blockquote>` [Element].
var blockquote;

/// The HTML `<body>` [BodyElement].
var body;

/// The HTML `<br>` [BRElement].
var br;

/// The HTML `<button>` [ButtonElement].
var button;

/// The HTML `<canvas>` [CanvasElement].
var canvas;

/// The HTML `<caption>` [Element].
var caption;

/// The HTML `<cite>` [Element].
var cite;

/// The HTML `<code>` [Element].
var code;

/// The HTML `<col>` [Element].
var col;

/// The HTML `<colgroup>` [Element].
var colgroup;

/// The HTML `<data>` [Element].
var data;

/// The HTML `<datalist>` [DataListElement].
var datalist;

/// The HTML `<dd>` [Element].
var dd;

/// The HTML `<del>` [Element].
var del;

/// The HTML `<details>` [DetailsElement].
var details;

/// The HTML `<dfn>` [Element].
var dfn;

/// The HTML `<dialog>` [DialogElement].
var dialog;

/// The HTML `<div>` [DivElement].
var div;

/// The HTML `<dl>` [DListElement].
var dl;

/// The HTML `<dt>` [Element].
var dt;

/// The HTML `<em>` [Element].
var em;

/// The HTML `<embed>` [EmbedElement].
var embed;

/// The HTML `<fieldset>` [FieldSetElement].
var fieldset;

/// The HTML `<figcaption>` [Element].
var figcaption;

/// The HTML `<figure>` [Element].
var figure;

/// The HTML `<footer>` [Element].
var footer;

/// The HTML `<form>` [FormElement].
var form;

/// The HTML `<h1>` [HeadingElement].
var h1;

/// The HTML `<h2>` [HeadingElement].
var h2;

/// The HTML `<h3>` [HeadingElement].
var h3;

/// The HTML `<h4>` [HeadingElement].
var h4;

/// The HTML `<h5>` [HeadingElement].
var h5;

/// The HTML `<h6>` [HeadingElement].
var h6;

/// The HTML `<head>` [HeadElement].
var head;

/// The HTML `<header>` [Element].
var header;

/// The HTML `<hr>` [HRElement].
var hr;

/// The HTML `<html>` [HtmlHtmlElement].
var html;

/// The HTML `<i>` [Element].
var i;

/// The HTML `<iframe>` [IFrameElement].
var iframe;

/// The HTML `<img>` [ImageElement].
var img;

/// The HTML `<input>` [InputElement].
var input;

/// The HTML `<ins>` [Element].
var ins;

/// The HTML `<kbd>` [Element].
var kbd;

/// The HTML `<keygen>` [KeygenElement].
var keygen;

/// The HTML `<label>` [LabelElement].
var label;

/// The HTML `<legend>` [LegendElement].
var legend;

/// The HTML `<li>` [LIElement].
var li;

/// The HTML `<link>` [LinkElement].
var link;

/// The HTML `<main>` [Element].
var main;

/// The HTML `<map>` [MapElement].
var map;

/// The HTML `<mark>` [Element].
var mark;

/// The HTML `<menu>` [MenuElement].
var menu;

/// The HTML `<menuitem>` [MenuItemElement].
var menuitem;

/// The HTML `<meta>` [MetaElement].
var meta;

/// The HTML `<meter>` [MeterElement].
var meter;

/// The HTML `<nav>` [Element].
var nav;

/// The HTML `<noscript>` [Element].
var noscript;

/// The HTML `<object>` [ObjectElement].
var object;

/// The HTML `<ol>` [OListElement].
var ol;

/// The HTML `<optgroup>` [OptGroupElement].
var optgroup;

/// The HTML `<option>` [OptionElement].
var option;

/// The HTML `<output>` [OutputElement].
var output;

/// The HTML `<p>` [ParagraphElement].
var p;

/// The HTML `<param>` [ParamElement].
var param;

/// The HTML `<picture>` [PictureElement].
var picture;

/// The HTML `<pre>` [PreElement].
var pre;

/// The HTML `<progress>` [ProgressElement].
var progress;

/// The HTML `<q>` [QuoteElement].
var q;

/// The HTML `<rp>` [Element].
var rp;

/// The HTML `<rt>` [Element].
var rt;

/// The HTML `<ruby>` [Element].
var ruby;

/// The HTML `<s>` [Element].
var s;

/// The HTML `<samp>` [Element].
var samp;

/// The HTML `<script>` [ScriptElement].
var script;

/// The HTML `<section>` [Element].
var section;

/// The HTML `<select>` [SelectElement].
var select;

/// The HTML `<small>` [Element].
var small;

/// The HTML `<source>` [SourceElement].
var source;

/// The HTML `<span>` [SpanElement].
var span;

/// The HTML `<strong>` [Element].
var strong;

/// The HTML `<style>` [StyleElement].
var style;

/// The HTML `<sub>` [Element].
var sub;

/// The HTML `<summary>` [Element].
var summary;

/// The HTML `<sup>` [Element].
var sup;

/// The HTML `<table>` [TableElement].
var table;

/// The HTML `<tbody>` [TableSectionElement].
var tbody;

/// The HTML `<td>` [TableCellElement].
var td;

/// The HTML `<textarea>` [TextAreaElement].
var textarea;

/// The HTML `<tfoot>` [TableSectionElement].
var tfoot;

/// The HTML `<th>` [TableCellElement].
var th;

/// The HTML `<thead>` [TableSectionElement].
var thead;

/// The HTML `<time>` [TimeInputElement].
var time;

/// The HTML `<title>` [TitleElement].
var title;

/// The HTML `<tr>` [TableRowElement].
var tr;

/// The HTML `<track>` [TrackElement].
var track;

/// The HTML `<u>` [Element].
var u;

/// The HTML `<ul>` [UListElement].
var ul;

/// The HTML `<var>` [Element].
///
/// _Named variable because `var` is a reserved word in Dart._
var variable;

/// The HTML `<video>` [VideoElement].
var video;

/// The HTML `<wbr>` [Element].
var wbr;

/// The SVG `<altGlyph>` [AltGlyphElement].
var altGlyph;

/// The SVG `<altGlyphDef>` [AltGlyphDefElement].
var altGlyphDef;

/// The SVG `<altGlyphItem>` [AltGlyphItemElement].
var altGlyphItem;

/// The SVG `<animate>` [AnimateElement].
var animate;

/// The SVG `<animateColor>` [AnimateColorElement].
var animateColor;

/// The SVG `<animateMotion>` [AnimateMotionElement].
var animateMotion;

/// The SVG `<animateTransform>` [AnimateTransformElement].
var animateTransform;

/// The SVG `<circle>` [CircleElement].
var circle;

/// The SVG `<clipPath>` [ClipPathElement].
var clipPath;

/// The SVG `<color-profile>` [ColorProfileElement].
var colorProfile;

/// The SVG `<cursor>` [CursorElement].
var cursor;

/// The SVG `<defs>` [DefsElement].
var defs;

/// The SVG `<desc>` [DescElement].
var desc;

/// The SVG `<discard>` [DiscardElement].
var discard;

/// The SVG `<ellipse>` [EllipseElement].
var ellipse;

/// The SVG `<feBlend>` [FeBlendElement].
var feBlend;

/// The SVG `<feColorMatrix>` [FeColorMatrixElement].
var feColorMatrix;

/// The SVG `<feComponentTransfer>` [FeComponentTransferElement].
var feComponentTransfer;

/// The SVG `<feComposite>` [FeCompositeElement].
var feComposite;

/// The SVG `<feConvolveMatrix>` [FeConvolveMatrixElement].
var feConvolveMatrix;

/// The SVG `<feDiffuseLighting>` [FeDiffuseLightingElement].
var feDiffuseLighting;

/// The SVG `<feDisplacementMap>` [FeDisplacementMapElement].
var feDisplacementMap;

/// The SVG `<feDistantLight>` [FeDistantLightElement].
var feDistantLight;

/// The SVG `<feDropShadow>` [FeDropShadowElement].
var feDropShadow;

/// The SVG `<feFlood>` [FeFloodElement].
var feFlood;

/// The SVG `<feFuncA>` [FeFuncAElement].
var feFuncA;

/// The SVG `<feFuncB>` [FeFuncBElement].
var feFuncB;

/// The SVG `<feFuncG>` [FeFuncGElement].
var feFuncG;

/// The SVG `<feFuncR>` [FeFuncRElement].
var feFuncR;

/// The SVG `<feGaussianBlur>` [FeGaussianBlurElement].
var feGaussianBlur;

/// The SVG `<feImage>` [FeImageElement].
var feImage;

/// The SVG `<feMerge>` [FeMergeElement].
var feMerge;

/// The SVG `<feMergeNode>` [FeMergeNodeElement].
var feMergeNode;

/// The SVG `<feMorphology>` [FeMorphologyElement].
var feMorphology;

/// The SVG `<feOffset>` [FeOffsetElement].
var feOffset;

/// The SVG `<fePointLight>` [FePointLightElement].
var fePointLight;

/// The SVG `<feSpecularLighting>` [FeSpecularLightingElement].
var feSpecularLighting;

/// The SVG `<feSpotLight>` [FeSpotLightElement].
var feSpotLight;

/// The SVG `<feTile>` [FeTileElement].
var feTile;

/// The SVG `<feTurbulence>` [FeTurbulenceElement].
var feTurbulence;

/// The SVG `<filter>` [FilterElement].
var filter;

/// The SVG `<font>` [FontElement].
var font;

/// The SVG `<font-face>` [FontFaceElement].
var fontFace;

/// The SVG `<font-face-format>` [FontFaceFormatElement].
var fontFaceFormat;

/// The SVG `<font-face-name>` [FontFaceNameElement].
var fontFaceName;

/// The SVG `<font-face-src>` [FontFaceSrcElement].
var fontFaceSrc;

/// The SVG `<font-face-uri>` [FontFaceUriElement].
var fontFaceUri;

/// The SVG `<foreignObject>` [ForeignObjectElement].
var foreignObject;

/// The SVG `<g>` [GElement].
var g;

/// The SVG `<glyph>` [GlyphElement].
var glyph;

/// The SVG `<glyphRef>` [GlyphRefElement].
var glyphRef;

/// The SVG `<hatch>` [HatchElement].
var hatch;

/// The SVG `<hatchpath>` [HatchpathElement].
var hatchpath;

/// The SVG `<hkern>` [HkernElement].
var hkern;

/// The SVG `<image>` [ImageElement].
var image;

/// The SVG `<line>` [LineElement].
var line;

/// The SVG `<linearGradient>` [LinearGradientElement].
var linearGradient;

/// The SVG `<marker>` [MarkerElement].
var marker;

/// The SVG `<mask>` [MaskElement].
var mask;

/// The SVG `<mesh>` [MeshElement].
var mesh;

/// The SVG `<meshgradient>` [MeshgradientElement].
var meshgradient;

/// The SVG `<meshpatch>` [MeshpatchElement].
var meshpatch;

/// The SVG `<meshrow>` [MeshrowElement].
var meshrow;

/// The SVG `<metadata>` [MetadataElement].
var metadata;

/// The SVG `<missing-glyph>` [MissingGlyphElement].
var missingGlyph;

/// The SVG `<mpath>` [MpathElement].
var mpath;

/// The SVG `<path>` [PathElement].
var path;

/// The SVG `<pattern>` [PatternElement].
var pattern;

/// The SVG `<polygon>` [PolygonElement].
var polygon;

/// The SVG `<polyline>` [PolylineElement].
var polyline;

/// The SVG `<radialGradient>` [RadialGradientElement].
var radialGradient;

/// The SVG `<rect>` [RectElement].
var rect;

/// The SVG `<set>` [SetElement].
var svgSet;

/// The SVG `<solidcolor>` [SolidcolorElement].
var solidcolor;

/// The SVG `<stop>` [StopElement].
var stop;

/// The SVG `<svg>` [SvgSvgElement].
var svg;

/// The SVG `<switch>` [SwitchElement].
var svgSwitch;

/// The SVG `<symbol>` [SymbolElement].
var symbol;

/// The SVG `<text>` [TextElement].
var text;

/// The SVG `<textPath>` [TextPathElement].
var textPath;

/// The SVG `<tref>` [TrefElement].
var tref;

/// The SVG `<tspan>` [TSpanElement].
var tspan;

/// The SVG `<unknown>` [UnknownElement].
var unknown;

/// The SVG `<use>` [UseElement].
var use;

/// The SVG `<view>` [ViewElement].
var view;

/// The SVG `<vkern>` [VkernElement].
var vkern;

/// Create React DOM `Component`s by calling the specified [creator].
_createDOMComponents(creator) {
  a = creator('a');
  abbr = creator('abbr');
  address = creator('address');
  area = creator('area');
  article = creator('article');
  aside = creator('aside');
  audio = creator('audio');
  b = creator('b');
  base = creator('base');
  bdi = creator('bdi');
  bdo = creator('bdo');
  big = creator('big');
  blockquote = creator('blockquote');
  body = creator('body');
  br = creator('br');
  button = creator('button');
  canvas = creator('canvas');
  caption = creator('caption');
  cite = creator('cite');
  code = creator('code');
  col = creator('col');
  colgroup = creator('colgroup');
  data = creator('data');
  datalist = creator('datalist');
  dd = creator('dd');
  del = creator('del');
  details = creator('details');
  dfn = creator('dfn');
  dialog = creator('dialog');
  div = creator('div');
  dl = creator('dl');
  dt = creator('dt');
  em = creator('em');
  embed = creator('embed');
  fieldset = creator('fieldset');
  figcaption = creator('figcaption');
  figure = creator('figure');
  footer = creator('footer');
  form = creator('form');
  h1 = creator('h1');
  h2 = creator('h2');
  h3 = creator('h3');
  h4 = creator('h4');
  h5 = creator('h5');
  h6 = creator('h6');
  head = creator('head');
  header = creator('header');
  hr = creator('hr');
  html = creator('html');
  i = creator('i');
  iframe = creator('iframe');
  img = creator('img');
  input = creator('input');
  ins = creator('ins');
  kbd = creator('kbd');
  keygen = creator('keygen');
  label = creator('label');
  legend = creator('legend');
  li = creator('li');
  link = creator('link');
  main = creator('main');
  map = creator('map');
  mark = creator('mark');
  menu = creator('menu');
  menuitem = creator('menuitem');
  meta = creator('meta');
  meter = creator('meter');
  nav = creator('nav');
  noscript = creator('noscript');
  object = creator('object');
  ol = creator('ol');
  optgroup = creator('optgroup');
  option = creator('option');
  output = creator('output');
  p = creator('p');
  param = creator('param');
  picture = creator('picture');
  pre = creator('pre');
  progress = creator('progress');
  q = creator('q');
  rp = creator('rp');
  rt = creator('rt');
  ruby = creator('ruby');
  s = creator('s');
  samp = creator('samp');
  script = creator('script');
  section = creator('section');
  select = creator('select');
  small = creator('small');
  source = creator('source');
  span = creator('span');
  strong = creator('strong');
  style = creator('style');
  sub = creator('sub');
  summary = creator('summary');
  sup = creator('sup');
  table = creator('table');
  tbody = creator('tbody');
  td = creator('td');
  textarea = creator('textarea');
  tfoot = creator('tfoot');
  th = creator('th');
  thead = creator('thead');
  time = creator('time');
  title = creator('title');
  tr = creator('tr');
  track = creator('track');
  u = creator('u');
  ul = creator('ul');
  variable = creator('var');
  video = creator('video');
  wbr = creator('wbr');

  // SVG Elements
  altGlyph = creator('altGlyph');
  altGlyphDef = creator('altGlyphDef');
  altGlyphItem = creator('altGlyphItem');
  animate = creator('animate');
  animateColor = creator('animateColor');
  animateMotion = creator('animateMotion');
  animateTransform = creator('animateTransform');
  circle = creator('circle');
  clipPath = creator('clipPath');
  colorProfile = creator('color-profile');
  cursor = creator('cursor');
  defs = creator('defs');
  desc = creator('desc');
  discard = creator('discard');
  ellipse = creator('ellipse');
  feBlend = creator('feBlend');
  feColorMatrix = creator('feColorMatrix');
  feComponentTransfer = creator('feComponentTransfer');
  feComposite = creator('feComposite');
  feConvolveMatrix = creator('feConvolveMatrix');
  feDiffuseLighting = creator('feDiffuseLighting');
  feDisplacementMap = creator('feDisplacementMap');
  feDistantLight = creator('feDistantLight');
  feDropShadow = creator('feDropShadow');
  feFlood = creator('feFlood');
  feFuncA = creator('feFuncA');
  feFuncB = creator('feFuncB');
  feFuncG = creator('feFuncG');
  feFuncR = creator('feFuncR');
  feGaussianBlur = creator('feGaussianBlur');
  feImage = creator('feImage');
  feMerge = creator('feMerge');
  feMergeNode = creator('feMergeNode');
  feMorphology = creator('feMorphology');
  feOffset = creator('feOffset');
  fePointLight = creator('fePointLight');
  feSpecularLighting = creator('feSpecularLighting');
  feSpotLight = creator('feSpotLight');
  feTile = creator('feTile');
  feTurbulence = creator('feTurbulence');
  filter = creator('filter');
  font = creator('font');
  fontFace = creator('font-face');
  fontFaceFormat = creator('font-face-format');
  fontFaceName = creator('font-face-name');
  fontFaceSrc = creator('font-face-src');
  fontFaceUri = creator('font-face-uri');
  foreignObject = creator('foreignObject');
  g = creator('g');
  glyph = creator('glyph');
  glyphRef = creator('glyphRef');
  hatch = creator('hatch');
  hatchpath = creator('hatchpath');
  hkern = creator('hkern');
  image = creator('image');
  line = creator('line');
  linearGradient = creator('linearGradient');
  marker = creator('marker');
  mask = creator('mask');
  mesh = creator('mesh');
  meshgradient = creator('meshgradient');
  meshpatch = creator('meshpatch');
  meshrow = creator('meshrow');
  metadata = creator('metadata');
  missingGlyph = creator('missing-glyph');
  mpath = creator('mpath');
  path = creator('path');
  pattern = creator('pattern');
  polygon = creator('polygon');
  polyline = creator('polyline');
  radialGradient = creator('radialGradient');
  rect = creator('rect');
  svgSet = creator('set');
  solidcolor = creator('solidcolor');
  stop = creator('stop');
  svg = creator('svg');
  svgSwitch = creator('switch');
  symbol = creator('symbol');
  text = creator('text');
  textPath = creator('textPath');
  tref = creator('tref');
  tspan = creator('tspan');
  unknown = creator('unknown');
  use = creator('use');
  view = creator('view');
  vkern = creator('vkern');
}

/// Set configuration based on functions provided as arguments.
///
/// The arguments are assigned to global variables, and React DOM `Component`s are created by calling
/// [_createDOMComponents] with [domCreator].
setReactConfiguration(domCreator, customRegisterComponent) {
  registerComponent = customRegisterComponent;
  // HTML Elements
  _createDOMComponents(domCreator);
}
