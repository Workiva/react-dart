// Copyright (c) 2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// __DEPRECATED.__
///
/// This library will not be maintained beyond the `5.0.0` release.
@Deprecated('5.0.0')
library react_dom_server;

/// __DEPRECATED.__
///
/// Server-side rendering support via APIs in the `react` package will not be maintained beyond the `5.0.0` release.
@Deprecated('5.0.0')
var renderToString;

/// __DEPRECATED.__
///
/// Server-side rendering support via APIs in the `react` package will not be maintained beyond the `5.0.0` release.
@Deprecated('5.0.0')
var renderToStaticMarkup;

/// __DEPRECATED.__
///
/// Server-side rendering support via APIs in the `react` package will not be maintained beyond the `5.0.0` release.
@Deprecated('5.0.0')
setReactDOMServerConfiguration(
    customRenderToString, customRenderToStaticMarkup) {
  renderToString = customRenderToString;
  renderToStaticMarkup = customRenderToStaticMarkup;
}
