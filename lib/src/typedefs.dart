library react.typedefs;


import 'package:react/react_client/js_backed_map.dart';

/// The type of `Component.ref` specified as a callback.
///
/// See: <https://reactjs.org/docs/refs-and-the-dom.html#the-ref-callback-attribute>
typedef CallbackRef<T> = Function(T? componentOrDomNode);

/// The function signature for ReactJS Function Components.
///
/// - [props] will always be supplied as the first argument
/// - [legacyContext] has been deprecated and should not be used but remains for backward compatibility and is necessary
/// to match Dart's generated call signature based on the number of args React provides.
typedef JsFunctionComponent = /*ReactNode*/ dynamic Function(JsMap props, [JsMap? legacyContext]);

typedef JsForwardRefFunctionComponent = /*ReactNode*/ dynamic Function(JsMap props, dynamic ref);

/// Typedef for `react.Component.ref`, which should return one of the following specified by the provided [ref]:
///
/// * `react.Component` if it is a Dart component.
/// * `Element` _(DOM node)_ if it is a React DOM component.
typedef RefMethod = dynamic Function(String ref);

/// Typedef for the `updater` argument of [Component2.setStateWithUpdater].
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef StateUpdaterCallback = Map? Function(Map prevState, Map props);

/// Typedef of a non-transactional [Component2.setState] callback.
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef SetStateCallback = Function();

/// A value that can be returned from a component's `render`, or used as `children`.
///
/// Possible values include:
/// * A `ReactElement` such as a DOM element created using `react.div({})`, or a user-defined component.
/// * A `ReactPortal` created by `createPortal`.
/// * A `String` or `num` (Rendered as text nodes in the DOM).
/// * Booleans or `null` (Render nothing).
/// * A list of, or a `ReactFragment` containing, any/all of the above.
///
/// See also: https://github.com/facebook/react/blob/b3003047101b4c7a643788a8faf576f7e370fb45/packages/shared/ReactTypes.js#L10
typedef ReactNode = Object?;
