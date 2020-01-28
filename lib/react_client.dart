// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react_client;

import 'dart:async';

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:react/react_client/js_backed_map.dart';

export 'package:react/react.dart' show ReactComponentFactoryProxy, ComponentFactory;
export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory, inReactDevMode, Ref;
export 'package:react/react_client/react_proxies.dart' show ReactDomComponentFactoryProxy, ReactJsComponentFactoryProxy, ReactDartComponentFactoryProxy, ReactDartComponentFactoryProxy2, ReactJsContextComponentFactoryProxy, ReactDartFunctionComponentFactoryProxy;
export 'package:react/react_client/synthetic_events.dart' show syntheticEventFactory, syntheticClipboardEventFactory, syntheticKeyboardEventFactory, syntheticFocusEventFactory, syntheticFormEventFactory, syntheticDataTransferFactory, syntheticPointerEventFactory, syntheticMouseEventFactory, syntheticTouchEventFactory, syntheticTransitionEventFactory, syntheticAnimationEventFactory, syntheticUIEventFactory, syntheticWheelEventFactory;

/// The function signature for ReactJS Function Components.
///
/// - [props] will always be supplied as the first argument
/// - [legacyContext] has been deprecated and should not be used but remains for backward compatibility and is necessary
/// to match Dart's generated call signature based on the number of args React provides.
typedef JsFunctionComponent = dynamic Function(JsMap props, [JsMap legacyContext]);

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

/// Method used to initialize the React environment.
///
/// > __DEPRECATED.__
/// >
/// > Environment configuration is now done by default and should not be altered. This can now be removed.
/// > This will be removed in 6.0.0, along with other configuration setting functions.
@Deprecated('It is not longer required and can be removed. 6.0.0')
void setClientConfiguration() {}
