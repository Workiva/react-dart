@JS()
library react_client_utils;

import 'dart:html';
import 'dart:js';

import 'dart:js_util';

import 'package:js/js.dart';

import 'package:react/react.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/utils.dart' as react_client_utils;

import 'package:react/src/react_client/event_factory.dart';
import 'package:react/src/react_client/synthetic_event_wrappers.dart' as events;
import 'package:react/src/typedefs.dart';

import 'event_prop_key_to_event_factory.dart';

@JS('Object.keys')
external List<String> _objectKeys(Object object);

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, JsMap descriptor);

/// A flag used to cache whether React is accessible.
///
/// This is used when setting environment variables to ensure they can be set properly.
bool _isJsApiValid = false;

/// Converts a list of variadic children arguments to children that should be passed to ReactJS.
///
/// Returns:
///
/// - `null` if there are no args
/// - the single child if only one was specified
/// - otherwise, the same list of args, will all top-level children validated
dynamic convertArgsToChildren(List childrenArgs) {
  if (childrenArgs.isEmpty) {
    return null;
  } else if (childrenArgs.length == 1) {
    return childrenArgs.single;
  } else {
    markChildrenValidated(childrenArgs);
    return childrenArgs;
  }
}

/// Convert packed event handler into wrapper and pass it only the Dart [SyntheticEvent] object converted from the
/// [events.SyntheticEvent] event.
convertEventHandlers(Map args) {
  args.forEach((propKey, value) {
    var eventFactory = eventPropKeyToEventFactory[propKey];
    if (eventFactory != null && value != null) {
      // Apply allowInterop here so that the function we store in `originalEventHandlers`
      // is the same one we'll retrieve from the JS props.
      var reactDartConvertedEventHandler = allowInterop((events.SyntheticEvent e, [_, __]) {
        value(eventFactory(e));
      });

      args[propKey] = reactDartConvertedEventHandler;
      originalEventHandlers[reactDartConvertedEventHandler] = value;
    }
  });
}

void convertRefValue(Map args) {
  var ref = args['ref'];
  if (ref is Ref) {
    args['ref'] = ref.jsRef;
  }
}

void convertRefValue2(Map args, {bool convertCallbackRefValue = true}) {
  var ref = args['ref'];

  if (ref is Ref) {
    args['ref'] = ref.jsRef;
    // If the ref is a callback, pass ReactJS a function that will call it
    // with the Dart Component instance, not the ReactComponent instance.
    //
    // Use CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
    // would fail the `is CallbackRef<dynamic>` check.
    // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
  } else if (ref is CallbackRef<Null> && convertCallbackRefValue) {
    args['ref'] = allowInterop((dynamic instance) {
      // Call as dynamic to perform dynamic dispatch, since we can't cast to CallbackRef<dynamic>,
      // and since calling with non-null values will fail at runtime due to the CallbackRef<Null> typing.
      if (instance is ReactComponent && instance.dartComponent != null) return (ref as dynamic)(instance.dartComponent);
      return (ref as dynamic)(instance);
    });
  }
}

/// Util used with `registerComponent2` to ensure no important lifecycle
/// events are skipped. This includes `shouldComponentUpdate`,
/// `componentDidUpdate`, and `render` because they utilize
/// `_updatePropsAndStateWithJs`.
///
/// Returns the list of lifecycle events to skip, having removed the
/// important ones. If an important lifecycle event was set for skipping, a
/// warning is issued.
List<String> filterSkipMethods(List<String> methods) {
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

/// Converts a list of variadic children arguments to children that should be passed to ReactJS.
///
/// Returns:
///
/// - `null` if there are no args and [shouldAlwaysBeList] is false
/// - `[]` if there are no args and [shouldAlwaysBeList] is true
/// - the single child if only one was specified
/// - otherwise, the same list of args, will all top-level children validated
dynamic generateChildren(List childrenArgs, {bool shouldAlwaysBeList = false}) {
  var children;

  if (childrenArgs.isEmpty) {
    if (!shouldAlwaysBeList) return null;
    children = childrenArgs;
  } else if (childrenArgs.length == 1) {
    if (shouldAlwaysBeList) {
      final singleChild = react_client_utils.listifyChildren(childrenArgs.single);
      if (singleChild is List) {
        children = singleChild;
      }
    } else {
      children = childrenArgs.single;
    }
  }

  if (children is Iterable && children is! List) {
    children = children.toList(growable: false);
  }

  if (children == null) {
    children = shouldAlwaysBeList ? childrenArgs.map(react_client_utils.listifyChildren).toList() : childrenArgs;
    markChildrenValidated(children);
  }

  return children;
}

/// Converts [props] into a [JsMap] that can be utilized with `React.createElement()`.
JsMap generateJsProps(Map props,
    {bool shouldConvertEventHandlers = true,
    bool convertRefValue = true,
    bool convertCallbackRefValue = true,
    bool wrapWithJsify = true}) {
  final propsForJs = JsBackedMap.from(props);

  if (shouldConvertEventHandlers) convertEventHandlers(propsForJs);
  if (convertRefValue) convertRefValue2(propsForJs, convertCallbackRefValue: convertCallbackRefValue);

  return wrapWithJsify ? jsifyAndAllowInterop(propsForJs) : propsForJs.jsObject;
}

@Deprecated('6.0.0')
InteropContextValue jsifyContext(Map<String, dynamic> context) {
  var interopContext = new InteropContextValue();
  context.forEach((key, value) {
    // ignore: argument_type_not_assignable
    setProperty(interopContext, key, new ReactDartContextInternal(value));
  });

  return interopContext;
}

/// A wrapper around [validateJsApi] that will return the result of a callback if React is present.
T validateJsApiThenReturn<T>(T Function() computeReturn) {
  validateJsApi();
  return computeReturn();
}

@Deprecated('6.0.0')
Map<String, dynamic> unjsifyContext(InteropContextValue interopContext) {
  // TODO consider using `contextKeys` for this if perf of objectKeys is bad.
  return new Map.fromIterable(_objectKeys(interopContext), value: (key) {
    // ignore: argument_type_not_assignable
    ReactDartContextInternal internal = getProperty(interopContext, key);
    return internal?.value;
  });
}

/// A function that verifies React can can be accessed.
///
/// If it does not throw, React can be used.
void validateJsApi() {
  if (_isJsApiValid) return;

  try {
    // Attempt to invoke JS interop methods, which will throw if the
    // corresponding JS functions are not available.
    React.isValidElement(null);
    ReactDom.findDOMNode(null);
    createReactDartComponentClass(null, null, null);
    _isJsApiValid = true;
  } on NoSuchMethodError catch (_) {
    throw new Exception('react.js and react_dom.js must be loaded.');
  } catch (_) {
    throw new Exception('Loaded react.js must include react-dart JS interop helpers.');
  }
}
