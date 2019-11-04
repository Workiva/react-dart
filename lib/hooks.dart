@JS()
library hooks;

import 'package:js/js.dart';
import 'package:react/react.dart';

@JS()
abstract class React {
  external static List<dynamic> useState(dynamic value);
  external static void useEffect(void Function() effect);
}

/// The return value of [useState].
///
/// The current value of the state is available via [value] and
/// functions to update it are available via [set] and [setTx].
///
/// Learn more: <https://reactjs.org/docs/hooks-state.html>.
class StateHook<T> {
  /// The first item of the pair returned by [React.useState].
  T _value;

  /// The second item in the pair returned by [React.useState].
  void Function(dynamic) _setValue;

  StateHook(T initialValue) {
    final result = React.useState(initialValue);
    _value = result[0];
    _setValue = result[1];
  }

  StateHook.init(T init()) {
    final result = React.useState(allowInterop(init));
    _value = result[0];
    _setValue = result[1];
  }

  /// The current value of the state.
  ///
  /// See: <https://reactjs.org/docs/hooks-reference.html#usestate>.
  T get value => _value;

  /// Updates [value] to [newValue].
  ///
  /// See: <https://reactjs.org/docs/hooks-state.html#updating-state>.
  void set(T newValue) => _setValue(newValue);

  /// Updates [value] to the return value of [computeNewValue].
  ///
  /// See: <https://reactjs.org/docs/hooks-reference.html#functional-updates>.
  void setTx(T computeNewValue(T oldValue)) => _setValue(allowInterop(computeNewValue));
}

/// When called inside a [DartFunctionComponent], adds a local state to the component.
///
/// Returns a [StateHook] with [StateHook.value] initialized to [initialValue].
///
/// __Example__:
///
///     UseStateTestComponent(Map props) {
///       final count = react.useState(0);
///
///       return react.div({}, [
///         count.value,
///         react.button({'onClick': (_) => count.set(0)}, ['Reset']),
///         react.button({'onClick': (_) => count.setTx((prev) => prev + 1)}, ['+']),
///       ]);
///     }
///
/// Learn more: <https://reactjs.org/docs/hooks-state.html>.
StateHook<T> useState<T>(T initialValue) => new StateHook(initialValue);

/// When called inside a [DartFunctionComponent], adds a local state to the component.
///
/// Returns a [StateHook] with [StateHook.value] initialized to the return value of [init].
///
/// __Example__:
///
///     UseStateTestComponent(Map props) {
///       final count = react.useStateInit(() {
///         var initialState = someExpensiveComputation(props);
///         return initialState;
///       }));
///
///       return react.div({}, [
///         count.value,
///         react.button({'onClick': (_) => count.set(0)}, ['Reset']),
///         react.button({'onClick': (_) => count.setTx((prev) => prev + 1)}, ['+']),
///       ]);
///     }
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#lazy-initial-state>.
StateHook<T> useStateInit<T>(T init()) => new StateHook.init(init);
