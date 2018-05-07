library react.typedefs;

import 'dart:collection';

import 'package:react/react.dart';

/// Typedef for `react.Component.ref`, which should return one of the following specified by the provided [ref]:
///
/// * `react.Component` if it is a Dart component.
/// * `Element` _(DOM node)_ if it is a React DOM component.
typedef dynamic Ref(String ref);

/// Typedef of a transactional [Component.setState] callback.
///
/// See: <https://facebook.github.io/react/docs/react-component.html#setstate>
typedef Map TransactionalSetStateCallback(
    Map prevState,
    UnmodifiableMapView props,
);
