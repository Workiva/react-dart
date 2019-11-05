library react.typedefs;

import 'package:react/react.dart';

/// Typedef for `react.Component.ref`, which should return one of the following specified by the provided [ref]:
///
/// * `react.Component` if it is a Dart component.
/// * `Element` _(DOM node)_ if it is a React DOM component.
typedef RefMethod = dynamic Function(String ref);

/// Typedef for the `updater` argument of [Component2.setStateWithUpdater].
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef StateUpdaterCallback = Map Function(Map prevState, Map props);

/// Typedef of a non-transactional [Component2.setState] callback.
///
/// See: <https://reactjs.org/docs/react-component.html#setstate>
typedef SetStateCallback = Function();
