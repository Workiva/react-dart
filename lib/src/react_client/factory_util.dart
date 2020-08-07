@JS()
library react_client_factory_utils;

import 'dart:js';

import 'package:js/js.dart';

import 'package:react/react.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/src/react_client/event_factory.dart';
import 'package:react/src/react_client/synthetic_event_wrappers.dart' as events;
import 'package:react/src/typedefs.dart';

import 'event_prop_key_to_event_factory.dart';

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
      // Don't attempt to convert functions that have already been converted, or functions
      // that were passed in as JS props.
      final handlerHasAlreadyBeenConverted = unconvertJsEventHandler(value) != null;
      if (!handlerHasAlreadyBeenConverted && !(isRawJsFunctionFromProps[value] ?? false)) {
        // Apply allowInterop here so that the function we store in [_originalEventHandlers]
        // is the same one we'll retrieve from the JS props.
        var reactDartConvertedEventHandler = allowInterop((e, [_, __]) {
          // To support Dart code calling converted handlers,
          // check for Dart events and pass them through directly.
          // Otherwise, convert the JS events like normal.
          if (e is SyntheticEvent) {
            value(e);
          } else {
            value(eventFactory(e as events.SyntheticEvent));
          }
        });

        args[propKey] = reactDartConvertedEventHandler;
        originalEventHandlers[reactDartConvertedEventHandler] = value;
      }
    }
  });
}

void convertRefValue(Map args) {
  var ref = args['ref'];
  if (ref is Ref) {
    args['ref'] = ref.jsRef;
  }
}

void convertRefValue2(
  Map args, {
  bool convertCallbackRefValue = true,
  List<String> additionalRefPropKeys = const [],
}) {
  final refKeys = ['ref', ...additionalRefPropKeys];

  for (final refKey in refKeys) {
    var ref = args[refKey];
    if (ref is Ref) {
      args[refKey] = ref.jsRef;
      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      //
      // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
      // would fail the `is _CallbackRef<dynamic>` check.
      // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
    } else if (ref is CallbackRef<Null> && convertCallbackRefValue) {
      args[refKey] = allowInterop((dynamic instance) {
        // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
        // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
        if (instance is ReactComponent && instance.dartComponent != null) {
          return (ref as dynamic)(instance.dartComponent);
        }

        return (ref as dynamic)(instance);
      });
    }
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
      final singleChild = listifyChildren(childrenArgs.single);
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
    children = shouldAlwaysBeList ? childrenArgs.map(listifyChildren).toList() : childrenArgs;
    markChildrenValidated(children);
  }

  return children;
}

typedef void JsPropSanitizer(JsBackedMap props);

/// Converts [props] into a [JsMap] that can be utilized with `React.createElement()`.
JsMap generateJsProps(Map props,
    {bool shouldConvertEventHandlers = true,
    bool convertRefValue = true,
    bool convertCallbackRefValue = true,
    List<String> additionalRefPropKeys = const [],
    bool wrapWithJsify = true,
    JsPropSanitizer sanitize}) {
  final propsForJs = JsBackedMap.from(props);

  if (shouldConvertEventHandlers) convertEventHandlers(propsForJs);
  if (convertRefValue) {
    convertRefValue2(propsForJs,
        convertCallbackRefValue: convertCallbackRefValue, additionalRefPropKeys: additionalRefPropKeys);
  }

  if (sanitize != null) {
    sanitize(propsForJs);
  }

  return wrapWithJsify ? jsifyAndAllowInterop(propsForJs) : propsForJs.jsObject;
}
