// Copyright (c) 2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_dom;

/// Renders a ReactElement into the DOM in the supplied `container` and return a reference to the `component`
/// (or returns null for stateless components).
///
/// If the ReactElement was previously rendered into the `container`, this will perform an update on it and only
/// mutate the DOM as necessary to reflect the latest React component.
///
/// TODO: Is there any reason to omit the `ReactElement` type for `component` or the `Element` type for `container`?
// ignore: prefer_function_declarations_over_variables
Function render = (/* ReactComponent */ component, /* Element */ container) {
  throw Exception('setClientConfiguration must be called before render.');
};

/// Removes a mounted React `Component` from the DOM and cleans up its event handlers and state.
///
/// > Returns `false` if no component was mounted in the container specified via [render], otherwise returns `true`.
Function unmountComponentAtNode;

/// If the `Component` has been mounted into the DOM, this returns the corresponding native browser DOM `Element`.
Function findDOMNode;

/// Sets configuration based on passed functions.
///
/// Passes arguments to global variables.
setReactDOMConfiguration(Function customRender, Function customUnmountComponentAtNode, Function customFindDOMNode) {
  render = customRender;
  unmountComponentAtNode = customUnmountComponentAtNode;
  findDOMNode = customFindDOMNode;
}
