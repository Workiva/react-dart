import 'dart:html';

import 'package:react/react.dart';
import 'package:react/react_client/bridge.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/component_factory.dart';

import 'package:react/src/react_client/dart_interop_statics.dart';

/// Util used with `registerComponent2` to ensure no important lifecycle
/// events are skipped. This includes `shouldComponentUpdate`,
/// `componentDidUpdate`, and `render` because they utilize
/// `_updatePropsAndStateWithJs`.
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

/// Creates and returns a new [ReactDartComponentFactoryProxy] from the provided [componentFactory]
/// which produces a new JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass).
@Deprecated('6.0.0')
ReactDartComponentFactoryProxy registerComponent(
  ComponentFactory componentFactory, [
  Iterable<String> skipMethods = const ['getDerivedStateFromError', 'componentDidCatch'],
]) {
  var componentInstance = componentFactory();

  if (componentInstance is Component2) {
    return registerComponent2(componentFactory, skipMethods: skipMethods);
  }

  var componentStatics = new ComponentStatics(componentFactory);

  var jsConfig = new JsComponentConfig(
    childContextKeys: componentInstance.childContextKeys,
    contextKeys: componentInstance.contextKeys,
  );

  /// Create the JS [`ReactClass` component class](https://facebook.github.io/react/docs/top-level-api.html#react.createclass)
  /// with custom JS lifecycle methods.
  var reactComponentClass = createReactDartComponentClass(dartInteropStatics, componentStatics, jsConfig)
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
ReactDartComponentFactoryProxy2 registerComponent2(
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
      createReactDartComponentClass2(ReactDartInteropStatics2.staticsForJs, componentStatics, jsConfig2)
        ..displayName = componentInstance.displayName;
  // ignore: invalid_use_of_protected_member
  reactComponentClass.dartComponentVersion = ReactDartComponentVersion.component2;

  return new ReactDartComponentFactoryProxy2(reactComponentClass);
}

/// Creates and returns a new `ReactDartFunctionComponentFactoryProxy` from the provided [dartFunctionComponent]
/// which produces a new `JsFunctionComponent`.
ReactDartFunctionComponentFactoryProxy registerFunctionComponent(DartFunctionComponent dartFunctionComponent,
        {String displayName}) =>
    ReactDartFunctionComponentFactoryProxy(dartFunctionComponent, displayName: displayName);
