@JS()
library react_client_factory_utils;

import 'dart:js';

import 'package:js/js.dart';

import 'package:react/react.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';

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

/// A mapping from converted/wrapped JS handler functions (the result of [_convertEventHandlers])
/// to the original Dart functions (the input of [_convertEventHandlers]).
final Expando<Function> originalEventHandler = new Expando();

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
        originalEventHandler[reactDartConvertedEventHandler] = value;
      }
    }
  });
}

/// Returns the original Dart handler function that, within [convertEventHandlers],
/// was converted/wrapped into the function [jsConvertedEventHandler] to be passed to the JS.
///
/// Returns `null` if [jsConvertedEventHandler] is `null`.
///
/// Returns `null` if [jsConvertedEventHandler] does not represent such a function
///
/// Useful for chaining event handlers on DOM or JS composite [ReactElement]s.
Function unconvertJsEventHandler(Function jsConvertedEventHandler) {
  if (jsConvertedEventHandler == null) return null;

  return originalEventHandler[jsConvertedEventHandler];
}

/// A mapping from converted/wrapped JS handler functions (the result of [convertRefValue])
/// to the original Dart functions (the input of [convertRefValue]).
final Expando<Function> _originalCallbackRef = new Expando();

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
      final convertedRef = allowInterop((dynamic instance) {
        // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
        // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
        if (instance is ReactComponent && instance.dartComponent != null) {
          return (ref as dynamic)(instance.dartComponent);
        }

        return (ref as dynamic)(instance);
      });

      args[refKey] = convertedRef;
      _originalCallbackRef[convertedRef] = ref;
    }
  }
}

/// Returns the original Dart function that, within [convertRefValue2],
/// was converted/wrapped into the function [jsConvertedCallbackRef] to be passed to the JS.
///
/// Returns `null` if [jsConvertedCallbackRef] is `null`.
///
/// Returns `null` if [jsConvertedCallbackRef] does not represent such a function
Function _unconvertJsCallbackRef(Function jsConvertedCallbackRef) {
  if (jsConvertedCallbackRef == null) return null;

  return _originalCallbackRef[jsConvertedCallbackRef];
}

/// Returns the original Dart ref (or a wrapper equivalent to it) for a [ref] that has
/// potentially been converted via [convertRefValue]/[convertRefValue2].
///
/// Returns `null` if [ref] is `null`.
///
/// Returns `null` if [ref] is not a ref that has been converted (e.g., a Dart ref). See [toDartRef].
dynamic unconvertDartRef(dynamic ref) {
  if (ref is Function) {
    return _unconvertJsCallbackRef(ref);
  }

  // This is really more a null-check and a check for type promotion, since
  // since `is JsRef` will return true for most JS objects.
  // However, in this case, it's pretty safe to assume the object is a JS ref
  // if it failed the above checks.
  if (ref is! Ref && ref is JsRef) {
    return Ref.fromJs(ref);
  }

  return null;
}

/// A convenience method that converts [ref] for use in Dart code if it's a converted ref from JS code,
/// and passes through [ref] otherwise.
///
/// Returns the original Dart ref (or a wrapper equivalent to it) for a [ref] that has
/// potentially been converted via [convertRefValue]/[convertRefValue2].
///
/// Returns `null` if [ref] is `null`.
///
/// In all other cases, [ref] is assumed to be a Dart ref and is passed through;
dynamic toDartRef(dynamic ref) {
  if (ref == null) return null;

  return unconvertDartRef(ref) ?? ref;
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

/// Converts [props] into a [JsMap] that can be utilized with `React.createElement()`.
JsMap generateJsProps(Map props,
    {bool shouldConvertEventHandlers = true,
    bool convertRefValue = true,
    bool convertCallbackRefValue = true,
    List<String> additionalRefPropKeys = const [],
    bool wrapWithJsify = true}) {
  final propsForJs = JsBackedMap.from(props);

  if (shouldConvertEventHandlers) convertEventHandlers(propsForJs);
  if (convertRefValue) {
    convertRefValue2(propsForJs,
        convertCallbackRefValue: convertCallbackRefValue, additionalRefPropKeys: additionalRefPropKeys);
  }

  return wrapWithJsify ? jsifyAndAllowInterop(propsForJs) : propsForJs.jsObject;
}
