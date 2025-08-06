@JS()
library react_client_private_utils;

import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/js_interop_util.dart';
import 'package:react/src/react_client/component_registration.dart' show registerComponent2;
import 'package:react/src/react_client/internal_react_interop.dart';

import '../../react.dart' show Component2;

/// A flag used to cache whether React is accessible.
///
/// This is used when setting environment variables to ensure they can be set properly.
bool _isJsApiValid = false;

@Deprecated(
    'This is only used with the legacy context APIs in the deprecated Component, and will be removed along with them.')
InteropContextValue jsifyContext(Map<String, dynamic> context) {
  final interopContext = InteropContextValue();
  context.forEach((key, value) {
    // ignore: argument_type_not_assignable
    setProperty(interopContext, key, ReactDartContextInternal(value));
  });

  return interopContext;
}

/// Validates that React is available (see [validateJsApi]) before returning the result of [computeReturn]).
T validateJsApiThenReturn<T>(T Function() computeReturn) {
  validateJsApi();
  return computeReturn();
}

@Deprecated(
    'This is only used with the legacy context APIs in the deprecated Component, and will be removed along with them.')
Map<String, dynamic> unjsifyContext(InteropContextValue interopContext) {
  // TODO consider using `contextKeys` for this if perf of objectKeys is bad.
  return {
    for (final key in objectKeys(interopContext).cast<String>())
      key: (getProperty(interopContext, key) as ReactDartContextInternal?)?.value
  };
}

/// Validates that React JS has been loaded and its APIs made available on the window,
/// throwing an exception otherwise.
void validateJsApi() {
  if (_isJsApiValid) return;

  try {
    // Attempt to invoke JS interop methods, which will throw if the
    // corresponding JS functions are not available.
    React.isValidElement(null);
    ReactDom.findDOMNode(null);
    // This indirectly calls createReactDartComponentClass2
    registerComponent2(() => _DummyComponent2());
    _isJsApiValid = true;
  } on NoSuchMethodError catch (_) {
    throw Exception('`packages/react/js/react.dev.js` or `packages/react/js/react.min.js` must be loaded.');
  } catch (_) {
    throw Exception('Loaded react.js must include react-dart JS interop helpers.');
  }
}

class _DummyComponent2 extends Component2 {
  @override
  render() => null;
}

/// A wrapper around a value that can't be stored in its raw form
/// within a JS object (e.g., a Dart function).
class DartValueWrapper {
  final Object? value;

  const DartValueWrapper(this.value);

  static dynamic wrapIfNeeded(Object? value) {
    if (value is Function && !identical(allowInterop(value), value)) {
      return DartValueWrapper(value);
    }
    return value;
  }

  static dynamic unwrapIfNeeded(Object? value) {
    if (value is DartValueWrapper) {
      return value.value;
    }
    return value;
  }
}
