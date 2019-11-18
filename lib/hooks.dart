@JS()
library hooks;

import 'package:js/js.dart';
import 'package:react/react.dart';
import 'package:react/react_client/react_interop.dart';

/// The return value of [useState].
///
/// The current value of the state is available via [value] and
/// functions to update it are available via [set] and [setWithUpdater].
///
/// Note there are two rules for using Hooks (<https://reactjs.org/docs/hooks-rules.html>):
///
/// * Only call Hooks at the top level.
/// * Only call Hooks from inside a [DartFunctionComponent].
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

  /// Constructor for [useStateLazy], calls lazy version of [React.useState] to
  /// initialize [_value] to the return value of [init].
  ///
  /// See: <https://reactjs.org/docs/hooks-reference.html#lazy-initial-state>.
  StateHook.lazy(T init()) {
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
  void setWithUpdater(T computeNewValue(T oldValue)) => _setValue(allowInterop(computeNewValue));
}

/// Adds local state to a [DartFunctionComponent]
/// by returning a [StateHook] with [StateHook.value] initialized to [initialValue].
///
/// > __Note:__ If the [initialValue] is expensive to compute, [useStateLazy] should be used instead.
///
/// __Example__:
///
/// ```
/// UseStateTestComponent(Map props) {
///   final count = useState(0);
///
///   return react.div({}, [
///     count.value,
///     react.button({'onClick': (_) => count.set(0)}, ['Reset']),
///     react.button({
///       'onClick': (_) => count.setWithUpdater((prev) {
///             if (props['enabled']) {
///               return prev + 1;
///             } else {
///               return prev;
///             }
///           }),
///     }, ['+']),
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-state.html>.
StateHook<T> useState<T>(T initialValue) => StateHook(initialValue);

/// Adds local state to a [DartFunctionComponent]
/// by returning a [StateHook] with [StateHook.value] initialized to the return value of [init].
///
/// __Example__:
///
/// ```
/// UseStateTestComponent(Map props) {
///   final count = useStateLazy(() {
///     var initialState = someExpensiveComputation(props);
///     return initialState;
///   }));
///
///   return react.div({}, [
///     count.value,
///     react.button({'onClick': (_) => count.set(0)}, ['Reset']),
///     react.button({'onClick': (_) => count.set(count.value + 1)}, ['+']),
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#lazy-initial-state>.
StateHook<T> useStateLazy<T>(T init()) => StateHook.lazy(init);

class ReducerHook {
  /// The first item of the pair returned by [React.userReducer].
  Map _state;

  /// The second item in the pair returned by [React.userReducer].
  void Function(dynamic) _dispatch;

  ReducerHook(Function reducer, dynamic initialState) {
    final result = React.useReducer(allowInterop(reducer), initialState);
    _state = result[0];
    _dispatch = result[1];
  }

  ReducerHook.lazy(Function reducer, dynamic initialState, Function init) {
    final result = React.useReducer(allowInterop(reducer), initialState, allowInterop(init));
    _state = result[0];
    _dispatch = result[1];
  }

  /// The current value of the state.
  ///
  /// See: <https://reactjs.org/docs/hooks-reference.html#usestate>.
  Map get state => _state;

  /// Updates [value] to [newValue].
  ///
  /// See: <https://reactjs.org/docs/hooks-state.html#updating-state>.
  void dispatch(dynamic action) => _dispatch(action);
}

///
///
/// __Example__:
///
/// ```
/// Map reducer(Map state, Map action) {
///   switch (action['type']) {
///     case 'increment':
///       return {'count': state['count'] + 1};
///     case 'decrement':
///       return {'count': state['count'] - 1};
///     default:
///       return state;
///   }
/// }
///
/// UseReducerTestComponent(Map props) {
///   final state = useReducer(reducer, {'count': 0});
///
///   return react.Fragment({}, [
///     state.state['count'],
///     react.button({
///       'onClick': (_) => state.dispatch({'type': 'increment'})
///     }, [
///       '+'
///     ]),
///     react.button({
///       'onClick': (_) => state.dispatch({'type': 'decrement'})
///     }, [
///       '-'
///     ]),
///   ]);
/// }
/// ```
///
/// See: <https://reactjs.org/docs/hooks-reference.html#usereducer>.
ReducerHook useReducer(Function reducer, dynamic initialState) => ReducerHook(reducer, initialState);

///
///
/// __Example__:
///
/// ```
/// Map initializeCount(int initialValue) {
///   return {'count': initialValue};
/// }
///
/// Map reducer(Map state, Map action) {
///   switch (action['type']) {
///     case 'increment':
///       return {'count': state['count'] + 1};
///     case 'decrement':
///       return {'count': state['count'] - 1};
///     case 'reset':
///       return initializeCount(action['payload']);
///     default:
///       return state;
///   }
/// }
///
/// UseReducerTestComponent(Map props) {
///   final state = useReducerLazy(reducer, props['initialCount'], initializeCount);
///
///   return react.Fragment({}, [
///     state.state['count'],
///     react.button({
///       'onClick': (_) => state.dispatch({'type': 'increment'})
///     }, [
///       '+'
///     ]),
///     react.button({
///       'onClick': (_) => state.dispatch({'type': 'decrement'})
///     }, [
///       '-'
///     ]),
///     react.button({
///       'onClick': (_) => state.dispatch({
///         'type': 'reset',
///         'payload': props['initialCount'],
///       })
///     }, [
///       'reset'
///     ]),
///   ]);
/// }
/// ```
///
/// See: <https://reactjs.org/docs/hooks-reference.html#lazy-initialization>.
ReducerHook useReducerLazy(Function reducer, dynamic initialState, Function init) =>
    ReducerHook.lazy(reducer, initialState, init);
