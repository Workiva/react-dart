// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A Dart library for building user interfaces.
 */
library react;

abstract class Component {
  Map props;
  final _jsThis;
  Map state = {};

  Component(this.props, this._jsThis);

  void setState(Map newState) {
    state.addAll(newState);
    _jsThis.callMethod('setState', [null]);
  }

  void replaceState(Map newState) {
    state = new Map.from(newState);
    _jsThis.callMethod('setState', [null]);
  }
  
  void componentWillReceiveProps(newProps) {

  }

  void componentWillMount() {

  }

  dynamic render();

}

var renderComponent;
var registerComponent;

/** Basic DOM elements
 * <var> is renamed to <variable> because var is reserved word in Dart.
 */
var a, abbr, address, area, article, aside, audio, b, base, bdi, bdo, big, blockquote, body, br,
button, canvas, caption, cite, code, col, colgroup, data, datalist, dd, del, details, dfn,
div, dl, dt, em, embed, fieldset, figcaption, figure, footer, form, h1, h2, h3, h4, h5, h6,
head, header, hr, html, i, iframe, img, input, ins, kbd, keygen, label, legend, li, link, main,
map, mark, menu, menuitem, meta, meter, nav, noscript, object, ol, optgroup, option, output,
p, param, pre, progress, q, rp, rt, ruby, s, samp, script, section, select, small, source,
span, strong, style, sub, summary, sup, table, tbody, td, textarea, tfoot, th, thead, time,
title, tr, track, u, ul, variable, video, wbr;

/** SVG elements */
var circle, g, line, path, polyline, rect, svg, text;