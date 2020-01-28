library react.typedefs;

import 'package:react/react.dart';
import 'package:react/react_client/js_backed_map.dart';

/// The type of `Component.ref` specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef CallbackRef<T>(T componentOrDomNode);

/// The function signature for ReactJS Function Components.
///
/// - [props] will always be supplied as the first argument
/// - [legacyContext] has been deprecated and should not be used but remains for backward compatibility and is necessary
/// to match Dart's generated call signature based on the number of args React provides.
typedef JsFunctionComponent = dynamic Function(JsMap props, [JsMap legacyContext]);

/// Typedef for `react.Component.ref`, which should return one of the following specified by the provided [ref]:
///
/// * `react.Component` if it is a Dart component.
/// * `Element` _(DOM node)_ if it is a React DOM component.
typedef dynamic RefMethod(String ref);

/// Typedef for the `updater` argument of [Component2.setStateWithUpdater].
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef Map StateUpdaterCallback(Map prevState, Map props);

/// Typedef of a non-transactional [Component2.setState] callback.
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef SetStateCallback();
