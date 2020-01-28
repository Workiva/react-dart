// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package
library react_client;

export 'package:react/react.dart' show ReactComponentFactoryProxy, ComponentFactory;
export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory, inReactDevMode, Ref;
export 'package:react/react_client/react_proxies.dart'
    show
        ReactDomComponentFactoryProxy,
        ReactJsComponentFactoryProxy,
        ReactDartComponentFactoryProxy,
        ReactDartComponentFactoryProxy2,
        ReactJsContextComponentFactoryProxy,
        ReactDartFunctionComponentFactoryProxy;
export 'package:react/react_client/utils.dart' show listifyChildren, unconvertJsProps, unconvertJsEventHandler;
export 'package:react/react_client/react_zone.dart' show componentZone;
export 'package:react/src/react_client/synthetic_event_factories.dart'
    show
        syntheticEventFactory,
        syntheticClipboardEventFactory,
        syntheticKeyboardEventFactory,
        syntheticFocusEventFactory,
        syntheticFormEventFactory,
        syntheticDataTransferFactory,
        syntheticPointerEventFactory,
        syntheticMouseEventFactory,
        syntheticTouchEventFactory,
        syntheticTransitionEventFactory,
        syntheticAnimationEventFactory,
        syntheticUIEventFactory,
        syntheticWheelEventFactory;
export 'package:react/src/typedefs.dart' show JsFunctionComponent;

/// Method used to initialize the React environment.
///
/// > __DEPRECATED.__
/// >
/// > Environment configuration is now done by default and should not be altered. This can now be removed.
/// > This will be removed in 6.0.0, along with other configuration setting functions.
@Deprecated('It is not longer required and can be removed. 6.0.0')
void setClientConfiguration() {}
