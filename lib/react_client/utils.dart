library react_client.utils;

import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/src/react_client/event_prop_key_to_event_factory.dart';
import 'package:react/src/react_client/event_factory.dart';

/// Prepares [children] to be passed to the ReactJS [React.createElement] and
/// the Dart [react.Component].
///
/// Currently only involves converting a top-level non-[List] [Iterable] to
/// a non-growable [List], but this may be updated in the future to support
/// advanced nesting and other kinds of children.
dynamic listifyChildren(dynamic children) {
  if (React.isValidElement(children)) {
    // Short-circuit if we're dealing with a ReactElement to avoid the dart2js
    // interceptor lookup involved in Dart type-checking.
    return children;
  } else if (children is Iterable && children is! List) {
    return children.toList(growable: false);
  } else {
    return children;
  }
}

/// Returns the original Dart handler function that, within [_convertEventHandlers],
/// was converted/wrapped into the function [jsConvertedEventHandler] to be passed to the JS.
///
/// Returns `null` if [jsConvertedEventHandler] is `null`.
///
/// Returns `null` if [jsConvertedEventHandler] does not represent such a function
///
/// Useful for chaining event handlers on DOM or JS composite [ReactElement]s.
Function unconvertJsEventHandler(Function jsConvertedEventHandler) {
  if (jsConvertedEventHandler == null) return null;

  return originalEventHandlers[jsConvertedEventHandler];
}

/// Returns the props for a [ReactElement] or composite [ReactComponent] [instance],
/// shallow-converted to a Dart Map for convenience.
///
/// If `style` is specified in props, then it too is shallow-converted and included
/// in the returned Map.
///
/// Any JS event handlers included in the props for the given [instance] will be
/// unconverted such that the original JS handlers are returned instead of their
/// Dart synthetic counterparts.
Map unconvertJsProps(/* ReactElement|ReactComponent */ instance) {
  var props = Map.from(JsBackedMap.backedBy(instance.props));

  // Catch if a Dart component has been passed in. Component (version 1) can be identified by having the "internal"
  // prop. Component2, however, does not have that but can be detected by checking whether or not the style prop is a
  // Map. Because non-Dart components will have a JS Object, it can be assumed that if the style prop is a Map then
  // it is a Dart Component.
  if (props['internal'] is ReactDartComponentInternal || (props['style'] != null && props['style'] is Map)) {
    throw new ArgumentError('A Dart Component cannot be passed into unconvertJsProps.');
  }

  eventPropKeyToEventFactory.keys.forEach((key) {
    if (props.containsKey(key)) {
      props[key] = unconvertJsEventHandler(props[key]) ?? props[key];
    }
  });

  // Convert the nested style map so it can be read by Dart code.
  var style = props['style'];
  if (style != null) {
    props['style'] = Map<String, dynamic>.from(JsBackedMap.backedBy(style));
  }

  return props;
}
