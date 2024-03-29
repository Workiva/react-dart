// Copyright (c) 2013-2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package
library react_client;

export 'package:react/react.dart' show ReactComponentFactoryProxy, ComponentFactory;
export 'package:react/react_client/react_interop.dart' show ReactElement, ReactJsComponentFactory, inReactDevMode, Ref;
export 'package:react/react_client/component_factory.dart'
    show
        listifyChildren,
        unconvertJsProps,
        ReactDomComponentFactoryProxy,
        ReactJsComponentFactoryProxy,
        ReactDartComponentFactoryProxy,
        ReactDartComponentFactoryProxy2,
        ReactJsContextComponentFactoryProxy,
        ReactDartFunctionComponentFactoryProxy,
        JsBackedMapComponentFactoryMixin;
export 'package:react/react_client/zone.dart' show componentZone;
export 'package:react/src/react_client/chain_refs.dart' show chainRefs, chainRefList;
export 'package:react/src/typedefs.dart' show JsFunctionComponent, ReactNode;

/// Method used to initialize the React environment.
///
/// > __DEPRECATED.__
/// >
/// > Environment configuration is now done by default and should not be altered. This can now be removed.
@Deprecated('Calls to this function are no longer required and can be removed.')
void setClientConfiguration() {}
