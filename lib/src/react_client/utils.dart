@JS()
library react_client_utils;

import 'dart:js';

import 'dart:js_util';

import "package:js/js.dart";

import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/utils.dart' as react_client_utils;

@JS('Object.keys')
external List<String> _objectKeys(Object object);

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, JsMap descriptor);

/// The type of `Component.ref` specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef CallbackRef<T>(T componentOrDomNode);

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
    // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
    // would fail the `is _CallbackRef<dynamic>` check.
    // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
  } else if (ref is CallbackRef<Null> && convertCallbackRefValue) {
    args['ref'] = allowInterop((dynamic instance) {
      // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
      // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
      if (instance is ReactComponent && instance.dartComponent != null) return (ref as dynamic)(instance.dartComponent);
      return (ref as dynamic)(instance);
    });
  }
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

/// Converts [props] into a [JsMap] that can be utilized with [React.createElement()].
JsMap generateJsProps(Map props,
    {bool convertEventHandlers = true,
      bool convertRefValue = true,
      bool convertCallbackRefValue = true,
      bool wrapWithJsify = true}) {
  final propsForJs = JsBackedMap.from(props);

  if (convertEventHandlers) react_client_utils.convertEventHandlers(propsForJs);
  if (convertRefValue) convertRefValue2(propsForJs, convertCallbackRefValue: convertCallbackRefValue);

  return wrapWithJsify ? jsifyAndAllowInterop(propsForJs) : propsForJs.jsObject;
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