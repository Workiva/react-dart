@JS()
library react_client.js_interop.react_test_utils;

import 'dart:async';
import 'dart:js';

import 'package:js/js.dart';
import 'package:meta/meta.dart';

abstract class ReactTestUtils {
  /// To prepare a component for assertions, wrap the code rendering it and performing updates inside an `act()` call.
  ///
  /// This makes your test run closer to how React works in the browser.
  @visibleForTesting
  static FutureOr<void> act(FutureOr<void> Function() callback) {
    // See: https://reactjs.org/blog/2022/03/08/react-18-upgrade-guide.html#configuring-your-testing-environment
    context['IS_REACT_ACT_ENVIRONMENT'] = true;
    return _JsReactTestUtils.act(allowInterop(callback));
  }
}

@JS('ReactTestUtils')
abstract class _JsReactTestUtils {
  external static FutureOr<void> act(FutureOr<void> Function() callback);
}
