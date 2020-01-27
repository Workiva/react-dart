// Copyright (c) 2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_dom;

import 'package:react/react.dart' show Component;
import 'package:react/react_client/react_interop.dart' show ReactDom;
import 'package:react/src/react_client/utils.dart' show validateJsApiThenReturn;

/// Renders a ReactElement into the DOM in the supplied [container] and return a reference to the [component]
/// (or returns null for stateless components).
///
/// If the ReactElement was previously rendered into the [container], this will perform an update on it and only
/// mutate the DOM as necessary to reflect the latest React component.
///
/// TODO: Is there any reason to omit the [ReactElement] type for [component] or the [Element] type for [container]?
Function render = validateJsApiThenReturn(() => ReactDom.render);

/// Removes a mounted React [Component] from the DOM and cleans up its event handlers and state.
///
/// > Returns `false` if no component was mounted in the container specified via [render], otherwise returns `true`.
Function unmountComponentAtNode = validateJsApiThenReturn(() => ReactDom.unmountComponentAtNode);

/// If the [Component] has been mounted into the DOM, this returns the corresponding native browser DOM [Element].
Function findDOMNode = validateJsApiThenReturn(() => _findDomNode);

dynamic _findDomNode(component) {
  return ReactDom.findDOMNode(component is Component ? component.jsThis : component);
}

/// Sets configuration based on passed functions.
///
/// Passes arguments to global variables.
///
/// > __DEPRECATED.__
/// >
/// > Environment configuration is now done by default and should not be altered. This can now be removed.
/// > This will be removed in 6.0.0, along with other configuration setting functions.
@Deprecated('6.0.0')
setReactDOMConfiguration(Function customRender, Function customUnmountComponentAtNode, Function customFindDOMNode) {
  render = customRender;
  unmountComponentAtNode = customUnmountComponentAtNode;
  findDOMNode = customFindDOMNode;
}
