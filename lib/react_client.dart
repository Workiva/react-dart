// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react_client;

import "dart:async";
import "dart:collection";
import "dart:html";
import 'dart:js';
import 'dart:js_util';

import "package:js/js.dart";
import 'package:meta/meta.dart';

import "package:react/react.dart";
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/react_proxies.dart';
import "package:react/react_dom.dart";
import 'package:react/react_client/bridge.dart';
import 'package:react/src/context.dart';
import 'package:react/react_client/js_backed_map.dart';
import "package:react/src/react_client/synthetic_event_wrappers.dart" as events;
import 'package:react/src/react_client/utils.dart';
import 'package:react/src/typedefs.dart';

export 'package:react/react.dart' show ReactComponentFactoryProxy, ComponentFactory;
export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory, inReactDevMode, Ref;
export 'package:react/react_client/react_proxies.dart' show ReactDomComponentFactoryProxy, ReactJsComponentFactoryProxy, ReactDartComponentFactoryProxy, ReactDartComponentFactoryProxy2, ReactJsContextComponentFactoryProxy, ReactDartFunctionComponentFactoryProxy;

/// The function signature for ReactJS Function Components.
///
/// - [props] will always be supplied as the first argument
/// - [legacyContext] has been deprecated and should not be used but remains for backward compatibility and is necessary
/// to match Dart's generated call signature based on the number of args React provides.
typedef JsFunctionComponent = dynamic Function(JsMap props, [JsMap legacyContext]);

/// The zone in which React will call component lifecycle methods.
///
/// This can be used to sync a test's zone and React's component zone, ensuring that component prop callbacks and
/// lifecycle method output all occurs within the same zone as the test.
///
/// __Example:__
///
///     test('zone test', () {
///       componentZone = Zone.current;
///
///       // ... test your component
///     }
@visibleForTesting
Zone componentZone = Zone.root;


/// Creates and returns a new `ReactDartFunctionComponentFactoryProxy` from the provided [dartFunctionComponent]
/// which produces a new `JsFunctionComponent`.
ReactDartFunctionComponentFactoryProxy _registerFunctionComponent(DartFunctionComponent dartFunctionComponent,
        {String displayName}) =>
    ReactDartFunctionComponentFactoryProxy(dartFunctionComponent, displayName: displayName);


/// Shared component factory proxy [build] method for components that utilize [JsBackedMap]s.
mixin JsBackedMapComponentFactoryMixin on ReactComponentFactoryProxy {
  @override
  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = generateChildren(childrenArgs, shouldAlwaysBeList: true);
    var convertedProps = generateExtendedJsProps(props);
    return React.createElement(type, convertedProps, children);
  }

  static JsMap generateExtendedJsProps(Map props) =>
      generateJsProps(props, convertEventHandlers: false, wrapWithJsify: false);
}



/// Util used with [_registerComponent2] to ensure no imporant lifecycle
/// events are skipped. This includes [shouldComponentUpdate],
/// [componentDidUpdate], and [render] because they utilize
/// [_updatePropsAndStateWithJs].
///
/// Returns the list of lifecycle events to skip, having removed the
/// important ones. If an important lifecycle event was set for skipping, a
/// warning is issued.
List<String> _filterSkipMethods(List<String> methods) {
  List<String> finalList = List.from(methods);
  bool shouldWarn = false;

  if (finalList.contains('shouldComponentUpdate')) {
    finalList.remove('shouldComponentUpdate');
    shouldWarn = true;
  }

  if (finalList.contains('componentDidUpdate')) {
    finalList.remove('componentDidUpdate');
    shouldWarn = true;
  }

  if (finalList.contains('render')) {
    finalList.remove('render');
    shouldWarn = true;
  }

  if (shouldWarn) {
    window.console.warn("WARNING: Crucial lifecycle methods passed into "
        "skipMethods. shouldComponentUpdate, componentDidUpdate, and render "
        "cannot be skipped and will still be added to the new component. Please "
        "remove them from skipMethods.");
  }

  return finalList;
}





@Deprecated('6.0.0')
InteropContextValue _jsifyContext(Map<String, dynamic> context) {
  var interopContext = new InteropContextValue();
  context.forEach((key, value) {
    // ignore: argument_type_not_assignable
    setProperty(interopContext, key, new ReactDartContextInternal(value));
  });

  return interopContext;
}

/// The static methods that proxy JS component lifecycle methods to Dart components.
@Deprecated('6.0.0')
final ReactDartInteropStatics _dartInteropStatics = (() {
  var zone = Zone.current;

  /// Wrapper for [Component.getInitialState].
  Component initComponent(ReactComponent jsThis, ReactDartComponentInternal internal, InteropContextValue context,
          ComponentStatics componentStatics) =>
      zone.run(() {
        void jsRedraw() {
          jsThis.setState(newObject());
        }

        RefMethod getRef = (name) {
          var ref = getProperty(jsThis.refs, name);
          if (ref == null) return null;
          if (ref is Element) return ref;

          return (ref as ReactComponent).dartComponent ?? ref;
        };

        Component component = componentStatics.componentFactory()
          ..initComponentInternal(internal.props, jsRedraw, getRef, jsThis, unjsifyContext(context))
          ..initStateInternal();

        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.
        return component;
      });

  InteropContextValue handleGetChildContext(Component component) => zone.run(() {
        return _jsifyContext(component.getChildContext());
      });

  /// Wrapper for [Component.componentWillMount].
  void handleComponentWillMount(Component component) => zone.run(() {
        component
          ..componentWillMount()
          ..transferComponentState();
      });

  /// Wrapper for [Component.componentDidMount].
  void handleComponentDidMount(Component component) => zone.run(() {
        component.componentDidMount();
      });

  Map _getNextProps(Component component, ReactDartComponentInternal nextInternal) {
    var newProps = nextInternal.props;
    return newProps != null ? new Map.from(newProps) : {};
  }

  /// 1. Update [Component.props] using the value stored to [Component.nextProps]
  ///    in `componentWillReceiveProps`.
  /// 2. Update [Component.context] using the value stored to [Component.nextContext]
  ///    in `componentWillReceivePropsWithContext`.
  /// 3. Update [Component.state] by calling [Component.transferComponentState]
  void _afterPropsChange(Component component, InteropContextValue nextContext) {
    component
      ..props = component.nextProps // [1]
      ..context = component.nextContext // [2]
      ..transferComponentState(); // [3]
  }

  void _clearPrevState(Component component) {
    component.prevState = null;
  }

  void _callSetStateCallbacks(Component component) {
    var callbacks = component.setStateCallbacks.toList();
    // Prevent concurrent modification during iteration
    component.setStateCallbacks.clear();
    callbacks.forEach((callback) {
      callback();
    });
  }

  void _callSetStateTransactionalCallbacks(Component component) {
    var nextState = component.nextState;
    var props = new UnmodifiableMapView(component.props);

    component.transactionalSetStateCallbacks.forEach((callback) {
      final stateUpdates = callback(nextState, props);
      if (stateUpdates != null) nextState.addAll(stateUpdates);
    });
    component.transactionalSetStateCallbacks.clear();
  }

  /// Wrapper for [Component.componentWillReceiveProps].
  void handleComponentWillReceiveProps(
          Component component, ReactDartComponentInternal nextInternal, InteropContextValue nextContext) =>
      zone.run(() {
        var nextProps = _getNextProps(component, nextInternal);
        var newContext = unjsifyContext(nextContext);

        component
          ..nextProps = nextProps
          ..nextContext = newContext
          ..componentWillReceiveProps(nextProps)
          ..componentWillReceivePropsWithContext(nextProps, newContext);
      });

  /// Wrapper for [Component.shouldComponentUpdate].
  bool handleShouldComponentUpdate(Component component, InteropContextValue nextContext) => zone.run(() {
        _callSetStateTransactionalCallbacks(component);

        // If shouldComponentUpdateWithContext returns a valid bool (default implementation returns null),
        // then don't bother calling `shouldComponentUpdate` and have it trump.
        bool shouldUpdate =
            component.shouldComponentUpdateWithContext(component.nextProps, component.nextState, component.nextContext);

        if (shouldUpdate == null) {
          shouldUpdate = component.shouldComponentUpdate(component.nextProps, component.nextState);
        }

        if (shouldUpdate) {
          return true;
        } else {
          // If component should not update, update props / transfer state because componentWillUpdate will not be called.
          _afterPropsChange(component, nextContext);
          _callSetStateCallbacks(component);
          // Clear out prevState after it's done being used so it's not retained
          _clearPrevState(component);
          return false;
        }
      });

  /// Wrapper for [Component.componentWillUpdate].
  void handleComponentWillUpdate(Component component, InteropContextValue nextContext) => zone.run(() {
        /// Call `componentWillUpdate` and the context variant
        component
          ..componentWillUpdate(component.nextProps, component.nextState)
          ..componentWillUpdateWithContext(component.nextProps, component.nextState, component.nextContext);

        _afterPropsChange(component, nextContext);
      });

  /// Wrapper for [Component.componentDidUpdate].
  ///
  /// Uses [prevState] which was transferred from [Component.nextState] in [componentWillUpdate].
  void handleComponentDidUpdate(Component component, ReactDartComponentInternal prevInternal) => zone.run(() {
        var prevInternalProps = prevInternal.props;

        /// Call `componentDidUpdate` and the context variant
        component.componentDidUpdate(prevInternalProps, component.prevState);

        _callSetStateCallbacks(component);
        // Clear out prevState after it's done being used so it's not retained
        _clearPrevState(component);
      });

  /// Wrapper for [Component.componentWillUnmount].
  void handleComponentWillUnmount(Component component) => zone.run(() {
        component.componentWillUnmount();
        // Clear these callbacks in case they retain anything;
        // they definitely won't be called after this point.
        component.setStateCallbacks.clear();
        component.transactionalSetStateCallbacks.clear();
      });

  /// Wrapper for [Component.render].
  dynamic handleRender(Component component) => zone.run(() {
        return component.render();
      });

  return new ReactDartInteropStatics(
      initComponent: allowInterop(initComponent),
      handleGetChildContext: allowInterop(handleGetChildContext),
      handleComponentWillMount: allowInterop(handleComponentWillMount),
      handleComponentDidMount: allowInterop(handleComponentDidMount),
      handleComponentWillReceiveProps: allowInterop(handleComponentWillReceiveProps),
      handleShouldComponentUpdate: allowInterop(handleShouldComponentUpdate),
      handleComponentWillUpdate: allowInterop(handleComponentWillUpdate),
      handleComponentDidUpdate: allowInterop(handleComponentDidUpdate),
      handleComponentWillUnmount: allowInterop(handleComponentWillUnmount),
      handleRender: allowInterop(handleRender));
})();

abstract class _ReactDartInteropStatics2 {
  static void _updatePropsAndStateWithJs(Component2 component, JsMap props, JsMap state) {
    component
      ..props = new JsBackedMap.backedBy(props)
      ..state = new JsBackedMap.backedBy(state);
  }

  static void _updateContextWithJs(Component2 component, dynamic jsContext) {
    component.context = ContextHelpers.unjsifyNewContext(jsContext);
  }

  static Component2 initComponent(ReactComponent jsThis, ComponentStatics2 componentStatics) => // dartfmt
      componentZone.run(() {
        final component = componentStatics.componentFactory();
        // Return the component so that the JS proxying component can store it,
        // avoiding an interceptor lookup.

        component
          ..jsThis = jsThis
          ..props = new JsBackedMap.backedBy(jsThis.props)
          ..context = ContextHelpers.unjsifyNewContext(jsThis.context);

        jsThis.state = jsBackingMapOrJsCopy(component.initialState);

        component.state = new JsBackedMap.backedBy(jsThis.state);

        // ignore: invalid_use_of_protected_member
        Component2Bridge.bridgeForComponent[component] = componentStatics.bridgeFactory(component);
        return component;
      });

  static void handleComponentDidMount(Component2 component) => // dartfmt
      componentZone.run(() {
        component.componentDidMount();
      });

  static bool handleShouldComponentUpdate(Component2 component, JsMap jsNextProps, JsMap jsNextState) => // dartfmt
      componentZone.run(() {
        final value = component.shouldComponentUpdate(
          new JsBackedMap.backedBy(jsNextProps),
          new JsBackedMap.backedBy(jsNextState),
        );

        if (!value) {
          _updatePropsAndStateWithJs(component, jsNextProps, jsNextState);
        }

        return value;
      });

  static JsMap handleGetDerivedStateFromProps(
          ComponentStatics2 componentStatics, JsMap jsNextProps, JsMap jsPrevState) => // dartfmt
      componentZone.run(() {
        var derivedState = componentStatics.instanceForStaticMethods
            .getDerivedStateFromProps(new JsBackedMap.backedBy(jsNextProps), new JsBackedMap.backedBy(jsPrevState));
        if (derivedState != null) {
          return jsBackingMapOrJsCopy(derivedState);
        }
        return null;
      });

  static dynamic handleGetSnapshotBeforeUpdate(Component2 component, JsMap jsPrevProps, JsMap jsPrevState) => // dartfmt
      componentZone.run(() {
        final snapshotValue = component.getSnapshotBeforeUpdate(
          new JsBackedMap.backedBy(jsPrevProps),
          new JsBackedMap.backedBy(jsPrevState),
        );

        return snapshotValue;
      });

  static void handleComponentDidUpdate(
          Component2 component, ReactComponent jsThis, JsMap jsPrevProps, JsMap jsPrevState,
          [dynamic snapshot]) => // dartfmt
      componentZone.run(() {
        component.componentDidUpdate(
          new JsBackedMap.backedBy(jsPrevProps),
          new JsBackedMap.backedBy(jsPrevState),
          snapshot,
        );
      });

  static void handleComponentWillUnmount(Component2 component) => // dartfmt
      componentZone.run(() {
        component.componentWillUnmount();
      });

  static void handleComponentDidCatch(Component2 component, dynamic error, ReactErrorInfo info) => // dartfmt
      componentZone.run(() {
        // Due to the error object being passed in from ReactJS it is a javascript object that does not get dartified.
        // To fix this we throw the error again from Dart to the JS side and catch it Dart side which re-dartifies it.
        try {
          throwErrorFromJS(error);
        } catch (e, stack) {
          info.dartStackTrace = stack;
          // The Dart stack track gets lost so we manually add it to the info object for reference.
          component.componentDidCatch(e, info);
        }
      });

  static JsMap handleGetDerivedStateFromError(ComponentStatics2 componentStatics, dynamic error) => // dartfmt
      componentZone.run(() {
        // Due to the error object being passed in from ReactJS it is a javascript object that does not get dartified.
        // To fix this we throw the error again from Dart to the JS side and catch it Dart side which re-dartifies it.
        try {
          throwErrorFromJS(error);
        } catch (e) {
          final result = componentStatics.instanceForStaticMethods.getDerivedStateFromError(e);
          if (result != null) return jsBackingMapOrJsCopy(result);
          return null;
        }
      });

  static dynamic handleRender(Component2 component, JsMap jsProps, JsMap jsState, dynamic jsContext) => // dartfmt
      componentZone.run(() {
        _updatePropsAndStateWithJs(component, jsProps, jsState);
        _updateContextWithJs(component, jsContext);
        return component.render();
      });

  static final JsMap staticsForJs = jsifyAndAllowInterop({
    'initComponent': initComponent,
    'handleComponentDidMount': handleComponentDidMount,
    'handleGetDerivedStateFromProps': handleGetDerivedStateFromProps,
    'handleShouldComponentUpdate': handleShouldComponentUpdate,
    'handleGetSnapshotBeforeUpdate': handleGetSnapshotBeforeUpdate,
    'handleComponentDidUpdate': handleComponentDidUpdate,
    'handleComponentWillUnmount': handleComponentWillUnmount,
    'handleComponentDidCatch': handleComponentDidCatch,
    'handleGetDerivedStateFromError': handleGetDerivedStateFromError,
    'handleRender': handleRender,
  });
}

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
@Deprecated('6.0.0')
ReactDartComponentFactoryProxy _registerComponent(
  ComponentFactory componentFactory, [
  Iterable<String> skipMethods = const ['getDerivedStateFromError', 'componentDidCatch'],
]) {
  var componentInstance = componentFactory();

  if (componentInstance is Component2) {
    return _registerComponent2(componentFactory, skipMethods: skipMethods);
  }

  var componentStatics = new ComponentStatics(componentFactory);

  var jsConfig = new JsComponentConfig(
    childContextKeys: componentInstance.childContextKeys,
    contextKeys: componentInstance.contextKeys,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass = createReactDartComponentClass(_dartInteropStatics, componentStatics, jsConfig)
    // ignore: invalid_use_of_protected_member
    ..dartComponentVersion = ReactDartComponentVersion.component
    ..displayName = componentFactory().displayName;

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final Map defaultProps = new Map.unmodifiable(componentInstance.getDefaultProps());
  reactComponentClass.dartDefaultProps = defaultProps;

  return new ReactDartComponentFactoryProxy(reactComponentClass);
}



/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
ReactDartComponentFactoryProxy2 _registerComponent2(
  ComponentFactory<Component2> componentFactory, {
  Iterable<String> skipMethods = const ['getDerivedStateFromError', 'componentDidCatch'],
  Component2BridgeFactory bridgeFactory,
}) {
  bridgeFactory ??= Component2BridgeImpl.bridgeFactory;

  final componentInstance = componentFactory();
  final componentStatics = new ComponentStatics2(
    componentFactory: componentFactory,
    instanceForStaticMethods: componentInstance,
    bridgeFactory: bridgeFactory,
  );
  final filteredSkipMethods = _filterSkipMethods(skipMethods);

  // Cache default props and store them on the ReactClass so they can be used
  // by ReactDartComponentFactoryProxy and externally.
  final JsBackedMap defaultProps = new JsBackedMap.from(componentInstance.defaultProps);

  final JsMap jsPropTypes =
      bridgeFactory(componentInstance).jsifyPropTypes(componentInstance, componentInstance.propTypes);

  var jsConfig2 = new JsComponentConfig2(
    defaultProps: defaultProps.jsObject,
    contextType: componentInstance.contextType?.jsThis,
    skipMethods: filteredSkipMethods,
    propTypes: jsPropTypes,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass =
      createReactDartComponentClass2(_ReactDartInteropStatics2.staticsForJs, componentStatics, jsConfig2)
        ..displayName = componentInstance.displayName;
  // ignore: invalid_use_of_protected_member
  reactComponentClass.dartComponentVersion = ReactDartComponentVersion.component2;

  return new ReactDartComponentFactoryProxy2(reactComponentClass);
}

/// Wrapper for [SyntheticEvent].
SyntheticEvent syntheticEventFactory(events.SyntheticEvent e) {
  return new SyntheticEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticClipboardEvent].
SyntheticClipboardEvent syntheticClipboardEventFactory(events.SyntheticClipboardEvent e) {
  return new SyntheticClipboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.clipboardData);
}

/// Wrapper for [SyntheticKeyboardEvent].
SyntheticKeyboardEvent syntheticKeyboardEventFactory(events.SyntheticKeyboardEvent e) {
  return new SyntheticKeyboardEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.altKey,
      e.char,
      e.charCode,
      e.ctrlKey,
      e.locale,
      e.location,
      e.key,
      e.keyCode,
      e.metaKey,
      e.repeat,
      e.shiftKey);
}

/// Wrapper for [SyntheticFocusEvent].
SyntheticFocusEvent syntheticFocusEventFactory(events.SyntheticFocusEvent e) {
  return new SyntheticFocusEvent(
      e.bubbles,
      e.cancelable,
      e.currentTarget,
      e.defaultPrevented,
      () => e.preventDefault(),
      () => e.stopPropagation(),
      e.eventPhase,
      e.isTrusted,
      e.nativeEvent,
      e.target,
      e.timeStamp,
      e.type,
      e.relatedTarget);
}

/// Wrapper for [SyntheticFormEvent].
SyntheticFormEvent syntheticFormEventFactory(events.SyntheticFormEvent e) {
  return new SyntheticFormEvent(e.bubbles, e.cancelable, e.currentTarget, e.defaultPrevented, () => e.preventDefault(),
      () => e.stopPropagation(), e.eventPhase, e.isTrusted, e.nativeEvent, e.target, e.timeStamp, e.type);
}

/// Wrapper for [SyntheticDataTransfer].
///
/// [dt] is typed as Object instead of [dynamic] to avoid dynamic calls in the method body,
/// ensuring the code is statically sound.
SyntheticDataTransfer syntheticDataTransferFactory(Object dt) {
  if (dt == null) return null;

  List rawFiles;
  List rawTypes;

  String effectAllowed;
  String dropEffect;

  // Handle `dt` being either a native DOM DataTransfer object or a JS object that looks like it (events.NonNativeDataTransfer).
  // Casting a JS object to DataTransfer fails intermittently in dart2js, and vice-versa fails intermittently in either DDC or dart2js.
  // TODO figure out when NonNativeDataTransfer is used.
  //
  // Some logic here is duplicated to ensure statically-sound access of same-named members.
  if (dt is DataTransfer) {
    rawFiles = dt.files;
    rawTypes = dt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = dt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = dt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  } else {
    // Assume it's a NonNativeDataTransfer otherwise.
    // Perform a cast inside `else` instead of an `else if (dt is ...)` since is-checks for
    // anonymous JS objects have undefined behavior.
    final castedDt = dt as events.NonNativeDataTransfer;

    rawFiles = castedDt.files;
    rawTypes = castedDt.types;

    try {
      // Works around a bug in IE where dragging from outside the browser fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      effectAllowed = castedDt.effectAllowed;
    } catch (_) {
      effectAllowed = 'uninitialized';
    }
    try {
      // For certain types of drag events in IE (anything but ondragenter, ondragover, and ondrop), this fails.
      // Trying to access this property throws the error "Unexpected call to method or property access.".
      dropEffect = castedDt.dropEffect;
    } catch (_) {
      dropEffect = 'none';
    }
  }

  // Copy these lists and ensure they're typed properly.
  // todo use .cast() in Dart 2
  final files = <File>[];
  final types = <String>[];
  rawFiles?.forEach(files.add);
  rawTypes?.forEach(types.add);

  return new SyntheticDataTransfer(dropEffect, effectAllowed, files, types);
}

/// Wrapper for [SyntheticPointerEvent].
SyntheticPointerEvent syntheticPointerEventFactory(events.SyntheticPointerEvent e) {
  return new SyntheticPointerEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.pointerId,
    e.width,
    e.height,
    e.pressure,
    e.tangentialPressure,
    e.tiltX,
    e.tiltY,
    e.twist,
    e.pointerType,
    e.isPrimary,
  );
}

/// Wrapper for [SyntheticMouseEvent].
SyntheticMouseEvent syntheticMouseEventFactory(events.SyntheticMouseEvent e) {
  SyntheticDataTransfer dt = syntheticDataTransferFactory(e.dataTransfer);
  return new SyntheticMouseEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.button,
    e.buttons,
    e.clientX,
    e.clientY,
    e.ctrlKey,
    dt,
    e.metaKey,
    e.pageX,
    e.pageY,
    e.relatedTarget,
    e.screenX,
    e.screenY,
    e.shiftKey,
  );
}

/// Wrapper for [SyntheticTouchEvent].
SyntheticTouchEvent syntheticTouchEventFactory(events.SyntheticTouchEvent e) {
  return new SyntheticTouchEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.altKey,
    e.changedTouches,
    e.ctrlKey,
    e.metaKey,
    e.shiftKey,
    e.targetTouches,
    e.touches,
  );
}

/// Wrapper for [SyntheticTransitionEvent].
SyntheticTransitionEvent syntheticTransitionEventFactory(events.SyntheticTransitionEvent e) {
  return new SyntheticTransitionEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.propertyName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticAnimationEvent].
SyntheticAnimationEvent syntheticAnimationEventFactory(events.SyntheticAnimationEvent e) {
  return new SyntheticAnimationEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.animationName,
    e.elapsedTime,
    e.pseudoElement,
  );
}

/// Wrapper for [SyntheticUIEvent].
SyntheticUIEvent syntheticUIEventFactory(events.SyntheticUIEvent e) {
  return new SyntheticUIEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.detail,
    e.view,
  );
}

/// Wrapper for [SyntheticWheelEvent].
SyntheticWheelEvent syntheticWheelEventFactory(events.SyntheticWheelEvent e) {
  return new SyntheticWheelEvent(
    e.bubbles,
    e.cancelable,
    e.currentTarget,
    e.defaultPrevented,
    () => e.preventDefault(),
    () => e.stopPropagation(),
    e.eventPhase,
    e.isTrusted,
    e.nativeEvent,
    e.target,
    e.timeStamp,
    e.type,
    e.deltaX,
    e.deltaMode,
    e.deltaY,
    e.deltaZ,
  );
}

/// Method used to initialize the React environment.
///
/// > __DEPRECATED.__
/// >
/// > Environment configuration is now done by default and should not be altered. This can now be removed.
/// > This will be removed in 6.0.0, along with other configuration setting functions.
@Deprecated('It is not longer required and can be removed. 6.0.0')
void setClientConfiguration() {}
