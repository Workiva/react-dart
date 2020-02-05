library react_client.zone;

import 'dart:async';

import 'package:meta/meta.dart';

/// The zone in which React will call component lifecycle methods.
///
/// This can be used to sync a test's zone and React's component zone, ensuring that component prop callbacks and
/// lifecycle method output all occurs within the same zone as the test.
///
/// __Example:__
///
///     test('zone test', () {
///       componentZone = Zone.current;
///
///       // ... test your component
///     }
@visibleForTesting
Zone componentZone = Zone.root;
