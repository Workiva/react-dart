// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_test;

import "package:react/react.dart";

class MarkupDescription {
  final String tag;
  final Map props;
  final List children;

  const MarkupDescription(this.tag, this.props, this.children);
}

/**
 * Create dart-react registered component for html tag.
 */
_reactDom(String name) {
  return (args, [children]) {
    if (children == null) {
      children = [];
    }
    if (children is! Iterable) {
      children = [children];
    }
    return new MarkupDescription(name, new Map.from(args), children.toList());
  };
}

initializeComponent(Component component, [Map props = const {}, List children, redraw]) {
  if (redraw == null) redraw = () {};
  component.initComponentInternal(props, redraw);
  component.initStateInternal();
  component.componentWillMount();
}

void setTestConfiguration() {
  setReactConfiguration(_reactDom, null, null, null);
}
