// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A Dart library for building UI using ReactJS.
library react;

import 'package:meta/meta.dart';
import 'package:react/react_client.dart';
import 'package:react/src/typedefs.dart';

typedef Component ComponentFactory();
typedef ReactComponentFactoryProxy ComponentRegistrar(ComponentFactory componentFactory,
    [Iterable<String> skipMethods]);

/// Top-level ReactJS [Component class](https://facebook.github.io/react/docs/react-component.html)
/// which provides the [ReactJS Component API](https://facebook.github.io/react/docs/react-component.html#reference)
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
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
  /// >
  /// > It is strongly recommended that you do not use this, and instead wait for `Component2.context`.
  @experimental
  dynamic get context => _context;

  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
  /// >
  /// > It is strongly recommended that you do not use this, and instead wait for `Component2.context`.
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
  /// There will be new and improved ways to use / set refs in the `5.0.0` release via APIs exposed in `Component2`.
  /// Until then, use a callback ref instead.
  @Deprecated('6.0.0')
  Ref get ref => _ref;

  /// __DEPRECATED.__
  ///
  /// Support for String `ref`s will be removed in the `6.0.0` release when `Component` is removed.
  ///
  /// There will be new and improved ways to use / set refs in the `5.0.0` release via APIs exposed in `Component2`.
  /// Until then, use a callback ref instead.
  @Deprecated('6.0.0')
  set ref(Ref value) => _ref = value;

  dynamic _jsRedraw;

  dynamic _jsThis;

  List<SetStateCallback> _setStateCallbacks = [];

  List<TransactionalSetStateCallback> _transactionalSetStateCallbacks = [];

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

  /// > Bind the value of input to [state[key]].
  ///
  /// __DEPRECATED.__
  ///
  /// This is being removed since it was a non-standard component API that
  /// only exists in react-dart, and not React JS in the Dart implementation.
  @Deprecated('5.0.0')
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
    this.nextContext = this.context;
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
  /// Useful for ReactJS lifecycle methods [shouldComponentUpdateWithContext] and [componentWillUpdateWithContext].
  ///
  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  Map nextContext;

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
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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
  /// [A.k.a "forceUpdate"](https://facebook.github.io/react/docs/react-component.html#forceupdate)
  ///
  /// TODO: Deprecate in 5.0.0-wip (use `Component2.forceUpdate` instead)
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
  void setState(dynamic newState, [callback()]) {
    if (newState is Map) {
      _nextState.addAll(newState);
    } else if (newState is TransactionalSetStateCallback) {
      _transactionalSetStateCallbacks.add(newState);
    } else if (newState != null) {
      throw new ArgumentError(
          'setState expects its first parameter to either be a Map or a `TransactionalSetStateCallback`.');
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
  void componentWillReceiveProps(Map newProps) {}

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
  /// >
  /// > This will be completely removed when the JS side of it is slated for removal (ReactJS 17 / react.dart 6.0.0)
  @Deprecated('6.0.0')
  void componentWillReceivePropsWithContext(Map newProps, nextContext) {}

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
  /// > being received.
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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
  void componentWillUpdate(Map nextProps, Map nextState) {}

  /// > __DEPRECATED - DO NOT USE__
  /// >
  /// > This API was never stable in any version of ReactJS, and was replaced with a new, incompatible context API
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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
  /// > in ReactJS 16 that will be exposed in version `5.0.0` of the `react` Dart package via a
  /// > new version of `Component` called `Component2`.
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

  void Function() _preventDefault;

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
  final void Function() stopPropagation;

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

  SyntheticClipboardEvent(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation,
      eventPhase, isTrusted, nativeEvent, target, timeStamp, type, this.clipboardData)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
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
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
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
      this.shiftKey)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticFocusEvent extends SyntheticEvent {
  final /*DOMEventTarget*/ relatedTarget;

  SyntheticFocusEvent(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation,
      eventPhase, isTrusted, nativeEvent, target, timeStamp, type, this.relatedTarget)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticFormEvent extends SyntheticEvent {
  SyntheticFormEvent(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation,
      eventPhase, isTrusted, nativeEvent, target, timeStamp, type)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
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
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
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
      this.shiftKey)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
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
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
      this.altKey,
      this.changedTouches,
      this.ctrlKey,
      this.metaKey,
      this.shiftKey,
      this.targetTouches,
      this.touches)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticTransitionEvent extends SyntheticEvent {
  final String propertyName;
  final num elapsedTime;
  final String pseudoElement;

  SyntheticTransitionEvent(
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
      this.propertyName,
      this.elapsedTime,
      this.pseudoElement)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticAnimationEvent extends SyntheticEvent {
  final String animationName;
  final num elapsedTime;
  final String pseudoElement;

  SyntheticAnimationEvent(
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
      this.animationName,
      this.elapsedTime,
      this.pseudoElement)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticUIEvent extends SyntheticEvent {
  final num detail;
  final /*DOMAbstractView*/ view;

  SyntheticUIEvent(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
      isTrusted, nativeEvent, target, timeStamp, type, this.detail, this.view)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

class SyntheticWheelEvent extends SyntheticEvent {
  final num deltaX;
  final num deltaMode;
  final num deltaY;
  final num deltaZ;

  SyntheticWheelEvent(
      bubbles,
      cancelable,
      currentTarget,
      _defaultPrevented,
      _preventDefault,
      stopPropagation,
      eventPhase,
      isTrusted,
      nativeEvent,
      target,
      timeStamp,
      type,
      this.deltaX,
      this.deltaMode,
      this.deltaY,
      this.deltaZ)
      : super(bubbles, cancelable, currentTarget, _defaultPrevented, _preventDefault, stopPropagation, eventPhase,
            isTrusted, nativeEvent, target, timeStamp, type) {}
}

/// Registers [componentFactory] on both client and server.
ComponentRegistrar registerComponent =
    (/*ComponentFactory*/ componentFactory, [/*Iterable<String>*/ skipMethods]) {
  throw new Exception('setClientConfiguration must be called before registerComponent.');
};

final a = new ReactDomComponentFactoryProxy('a');
final abbr = new ReactDomComponentFactoryProxy('abbr');
final address = new ReactDomComponentFactoryProxy('address');
final area = new ReactDomComponentFactoryProxy('area');
final article = new ReactDomComponentFactoryProxy('article');
final aside = new ReactDomComponentFactoryProxy('aside');
final audio = new ReactDomComponentFactoryProxy('audio');
final b = new ReactDomComponentFactoryProxy('b');
final base = new ReactDomComponentFactoryProxy('base');
final bdi = new ReactDomComponentFactoryProxy('bdi');
final bdo = new ReactDomComponentFactoryProxy('bdo');
final big = new ReactDomComponentFactoryProxy('big');
final blockquote = new ReactDomComponentFactoryProxy('blockquote');
final body = new ReactDomComponentFactoryProxy('body');
final br = new ReactDomComponentFactoryProxy('br');
final button = new ReactDomComponentFactoryProxy('button');
final canvas = new ReactDomComponentFactoryProxy('canvas');
final caption = new ReactDomComponentFactoryProxy('caption');
final cite = new ReactDomComponentFactoryProxy('cite');
final code = new ReactDomComponentFactoryProxy('code');
final col = new ReactDomComponentFactoryProxy('col');
final colgroup = new ReactDomComponentFactoryProxy('colgroup');
final data = new ReactDomComponentFactoryProxy('data');
final datalist = new ReactDomComponentFactoryProxy('datalist');
final dd = new ReactDomComponentFactoryProxy('dd');
final del = new ReactDomComponentFactoryProxy('del');
final details = new ReactDomComponentFactoryProxy('details');
final dfn = new ReactDomComponentFactoryProxy('dfn');
final dialog = new ReactDomComponentFactoryProxy('dialog');
final div = new ReactDomComponentFactoryProxy('div');
final dl = new ReactDomComponentFactoryProxy('dl');
final dt = new ReactDomComponentFactoryProxy('dt');
final em = new ReactDomComponentFactoryProxy('em');
final embed = new ReactDomComponentFactoryProxy('embed');
final fieldset = new ReactDomComponentFactoryProxy('fieldset');
final figcaption = new ReactDomComponentFactoryProxy('figcaption');
final figure = new ReactDomComponentFactoryProxy('figure');
final footer = new ReactDomComponentFactoryProxy('footer');
final form = new ReactDomComponentFactoryProxy('form');
final h1 = new ReactDomComponentFactoryProxy('h1');
final h2 = new ReactDomComponentFactoryProxy('h2');
final h3 = new ReactDomComponentFactoryProxy('h3');
final h4 = new ReactDomComponentFactoryProxy('h4');
final h5 = new ReactDomComponentFactoryProxy('h5');
final h6 = new ReactDomComponentFactoryProxy('h6');
final head = new ReactDomComponentFactoryProxy('head');
final header = new ReactDomComponentFactoryProxy('header');
final hr = new ReactDomComponentFactoryProxy('hr');
final html = new ReactDomComponentFactoryProxy('html');
final i = new ReactDomComponentFactoryProxy('i');
final iframe = new ReactDomComponentFactoryProxy('iframe');
final img = new ReactDomComponentFactoryProxy('img');
final input = new ReactDomComponentFactoryProxy('input');
final ins = new ReactDomComponentFactoryProxy('ins');
final kbd = new ReactDomComponentFactoryProxy('kbd');
final keygen = new ReactDomComponentFactoryProxy('keygen');
final label = new ReactDomComponentFactoryProxy('label');
final legend = new ReactDomComponentFactoryProxy('legend');
final li = new ReactDomComponentFactoryProxy('li');
final link = new ReactDomComponentFactoryProxy('link');
final main = new ReactDomComponentFactoryProxy('main');
final map = new ReactDomComponentFactoryProxy('map');
final mark = new ReactDomComponentFactoryProxy('mark');
final menu = new ReactDomComponentFactoryProxy('menu');
final menuitem = new ReactDomComponentFactoryProxy('menuitem');
final meta = new ReactDomComponentFactoryProxy('meta');
final meter = new ReactDomComponentFactoryProxy('meter');
final nav = new ReactDomComponentFactoryProxy('nav');
final noscript = new ReactDomComponentFactoryProxy('noscript');
final object = new ReactDomComponentFactoryProxy('object');
final ol = new ReactDomComponentFactoryProxy('ol');
final optgroup = new ReactDomComponentFactoryProxy('optgroup');
final option = new ReactDomComponentFactoryProxy('option');
final output = new ReactDomComponentFactoryProxy('output');
final p = new ReactDomComponentFactoryProxy('p');
final param = new ReactDomComponentFactoryProxy('param');
final picture = new ReactDomComponentFactoryProxy('picture');
final pre = new ReactDomComponentFactoryProxy('pre');
final progress = new ReactDomComponentFactoryProxy('progress');
final q = new ReactDomComponentFactoryProxy('q');
final rp = new ReactDomComponentFactoryProxy('rp');
final rt = new ReactDomComponentFactoryProxy('rt');
final ruby = new ReactDomComponentFactoryProxy('ruby');
final s = new ReactDomComponentFactoryProxy('s');
final samp = new ReactDomComponentFactoryProxy('samp');
final script = new ReactDomComponentFactoryProxy('script');
final section = new ReactDomComponentFactoryProxy('section');
final select = new ReactDomComponentFactoryProxy('select');
final small = new ReactDomComponentFactoryProxy('small');
final source = new ReactDomComponentFactoryProxy('source');
final span = new ReactDomComponentFactoryProxy('span');
final strong = new ReactDomComponentFactoryProxy('strong');
final style = new ReactDomComponentFactoryProxy('style');
final sub = new ReactDomComponentFactoryProxy('sub');
final summary = new ReactDomComponentFactoryProxy('summary');
final sup = new ReactDomComponentFactoryProxy('sup');
final table = new ReactDomComponentFactoryProxy('table');
final tbody = new ReactDomComponentFactoryProxy('tbody');
final td = new ReactDomComponentFactoryProxy('td');
final textarea = new ReactDomComponentFactoryProxy('textarea');
final tfoot = new ReactDomComponentFactoryProxy('tfoot');
final th = new ReactDomComponentFactoryProxy('th');
final thead = new ReactDomComponentFactoryProxy('thead');
final time = new ReactDomComponentFactoryProxy('time');
final title = new ReactDomComponentFactoryProxy('title');
final tr = new ReactDomComponentFactoryProxy('tr');
final track = new ReactDomComponentFactoryProxy('track');
final u = new ReactDomComponentFactoryProxy('u');
final ul = new ReactDomComponentFactoryProxy('ul');
final variable = new ReactDomComponentFactoryProxy('var');
final video = new ReactDomComponentFactoryProxy('video');
final wbr = new ReactDomComponentFactoryProxy('wbr');

// SVG Elements
final altGlyph = new ReactDomComponentFactoryProxy('altGlyph');
final altGlyphDef = new ReactDomComponentFactoryProxy('altGlyphDef');
final altGlyphItem = new ReactDomComponentFactoryProxy('altGlyphItem');
final animate = new ReactDomComponentFactoryProxy('animate');
final animateColor = new ReactDomComponentFactoryProxy('animateColor');
final animateMotion = new ReactDomComponentFactoryProxy('animateMotion');
final animateTransform = new ReactDomComponentFactoryProxy('animateTransform');
final circle = new ReactDomComponentFactoryProxy('circle');
final clipPath = new ReactDomComponentFactoryProxy('clipPath');
final colorProfile = new ReactDomComponentFactoryProxy('color-profile');
final cursor = new ReactDomComponentFactoryProxy('cursor');
final defs = new ReactDomComponentFactoryProxy('defs');
final desc = new ReactDomComponentFactoryProxy('desc');
final discard = new ReactDomComponentFactoryProxy('discard');
final ellipse = new ReactDomComponentFactoryProxy('ellipse');
final feBlend = new ReactDomComponentFactoryProxy('feBlend');
final feColorMatrix = new ReactDomComponentFactoryProxy('feColorMatrix');
final feComponentTransfer = new ReactDomComponentFactoryProxy('feComponentTransfer');
final feComposite = new ReactDomComponentFactoryProxy('feComposite');
final feConvolveMatrix = new ReactDomComponentFactoryProxy('feConvolveMatrix');
final feDiffuseLighting = new ReactDomComponentFactoryProxy('feDiffuseLighting');
final feDisplacementMap = new ReactDomComponentFactoryProxy('feDisplacementMap');
final feDistantLight = new ReactDomComponentFactoryProxy('feDistantLight');
final feDropShadow = new ReactDomComponentFactoryProxy('feDropShadow');
final feFlood = new ReactDomComponentFactoryProxy('feFlood');
final feFuncA = new ReactDomComponentFactoryProxy('feFuncA');
final feFuncB = new ReactDomComponentFactoryProxy('feFuncB');
final feFuncG = new ReactDomComponentFactoryProxy('feFuncG');
final feFuncR = new ReactDomComponentFactoryProxy('feFuncR');
final feGaussianBlur = new ReactDomComponentFactoryProxy('feGaussianBlur');
final feImage = new ReactDomComponentFactoryProxy('feImage');
final feMerge = new ReactDomComponentFactoryProxy('feMerge');
final feMergeNode = new ReactDomComponentFactoryProxy('feMergeNode');
final feMorphology = new ReactDomComponentFactoryProxy('feMorphology');
final feOffset = new ReactDomComponentFactoryProxy('feOffset');
final fePointLight = new ReactDomComponentFactoryProxy('fePointLight');
final feSpecularLighting = new ReactDomComponentFactoryProxy('feSpecularLighting');
final feSpotLight = new ReactDomComponentFactoryProxy('feSpotLight');
final feTile = new ReactDomComponentFactoryProxy('feTile');
final feTurbulence = new ReactDomComponentFactoryProxy('feTurbulence');
final filter = new ReactDomComponentFactoryProxy('filter');
final font = new ReactDomComponentFactoryProxy('font');
final fontFace = new ReactDomComponentFactoryProxy('font-face');
final fontFaceFormat = new ReactDomComponentFactoryProxy('font-face-format');
final fontFaceName = new ReactDomComponentFactoryProxy('font-face-name');
final fontFaceSrc = new ReactDomComponentFactoryProxy('font-face-src');
final fontFaceUri = new ReactDomComponentFactoryProxy('font-face-uri');
final foreignObject = new ReactDomComponentFactoryProxy('foreignObject');
final g = new ReactDomComponentFactoryProxy('g');
final glyph = new ReactDomComponentFactoryProxy('glyph');
final glyphRef = new ReactDomComponentFactoryProxy('glyphRef');
final hatch = new ReactDomComponentFactoryProxy('hatch');
final hatchpath = new ReactDomComponentFactoryProxy('hatchpath');
final hkern = new ReactDomComponentFactoryProxy('hkern');
final image = new ReactDomComponentFactoryProxy('image');
final line = new ReactDomComponentFactoryProxy('line');
final linearGradient = new ReactDomComponentFactoryProxy('linearGradient');
final marker = new ReactDomComponentFactoryProxy('marker');
final mask = new ReactDomComponentFactoryProxy('mask');
final mesh = new ReactDomComponentFactoryProxy('mesh');
final meshgradient = new ReactDomComponentFactoryProxy('meshgradient');
final meshpatch = new ReactDomComponentFactoryProxy('meshpatch');
final meshrow = new ReactDomComponentFactoryProxy('meshrow');
final metadata = new ReactDomComponentFactoryProxy('metadata');
final missingGlyph = new ReactDomComponentFactoryProxy('missing-glyph');
final mpath = new ReactDomComponentFactoryProxy('mpath');
final path = new ReactDomComponentFactoryProxy('path');
final pattern = new ReactDomComponentFactoryProxy('pattern');
final polygon = new ReactDomComponentFactoryProxy('polygon');
final polyline = new ReactDomComponentFactoryProxy('polyline');
final radialGradient = new ReactDomComponentFactoryProxy('radialGradient');
final rect = new ReactDomComponentFactoryProxy('rect');
final svgSet = new ReactDomComponentFactoryProxy('set');
final solidcolor = new ReactDomComponentFactoryProxy('solidcolor');
final stop = new ReactDomComponentFactoryProxy('stop');
final svg = new ReactDomComponentFactoryProxy('svg');
final svgSwitch = new ReactDomComponentFactoryProxy('switch');
final symbol = new ReactDomComponentFactoryProxy('symbol');
final text = new ReactDomComponentFactoryProxy('text');
final textPath = new ReactDomComponentFactoryProxy('textPath');
final tref = new ReactDomComponentFactoryProxy('tref');
final tspan = new ReactDomComponentFactoryProxy('tspan');
final unknown = new ReactDomComponentFactoryProxy('unknown');
final use = new ReactDomComponentFactoryProxy('use');
final view = new ReactDomComponentFactoryProxy('view');
final vkern = new ReactDomComponentFactoryProxy('vkern');

/// Set configuration based on functions provided as arguments.
///
/// The arguments are assigned to global variables, and React DOM `Component`s are created by calling
/// [_createDOMComponents] with [domCreator].
setReactConfiguration(_, ComponentRegistrar customRegisterComponent) {
  registerComponent = customRegisterComponent;
}
