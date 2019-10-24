// Copyright (c) 2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_dom;

import 'dart:html';

import 'react_client/react_interop.dart';

typedef ReactDomRenderFunction = dynamic Function(dynamic, Element);
typedef ReactDomUnmountComponentAtNodeFunction = bool Function(Element);
typedef ReactDomFindDOMNodeFunction = dynamic Function(dynamic);

/// Renders a ReactElement into the DOM in the supplied [container] and return a reference to the [component]
/// (or returns null for stateless components).
///
/// If the ReactElement was previously rendered into the [container], this will perform an update on it and only
/// mutate the DOM as necessary to reflect the latest React component.
///
/// TODO: Is there any reason to omit the [ReactElement] type for [component] or the [Element] type for [container]?
ReactDomRenderFunction render = (/* ReactComponent */ component, /* Element */ container) {
  throw new Exception('setClientConfiguration must be called before render.');
};

/// Removes a mounted React [Component] from the DOM and cleans up its event handlers and state.
///
/// > Returns `false` if no component was mounted in the container specified via [render], otherwise returns `true`.
ReactDomUnmountComponentAtNodeFunction unmountComponentAtNode;

/// If the [Component] has been mounted into the DOM, this returns the corresponding native browser DOM [Element].
ReactDomFindDOMNodeFunction findDOMNode;

/// Sets configuration based on passed functions.
///
/// Passes arguments to global variables.
setReactDOMConfiguration(ReactDomRenderFunction customRender, ReactDomUnmountComponentAtNodeFunction customUnmountComponentAtNode, ReactDomFindDOMNodeFunction customFindDOMNode) {
  render = customRender;
  unmountComponentAtNode = customUnmountComponentAtNode;
  findDOMNode = customFindDOMNode;
}
