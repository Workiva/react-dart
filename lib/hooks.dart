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
/// > __Note:__ there are two [rules for using Hooks](https://reactjs.org/docs/hooks-rules.html):
/// >
/// > * Only call Hooks at the top level.
/// > * Only call Hooks from inside a [DartFunctionComponent].
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
///       'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
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
///     react.button({'onClick': (_) => count.set((prev) => prev + 1)}, ['+']),
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#lazy-initial-state>.
StateHook<T> useStateLazy<T>(T init()) => StateHook.lazy(init);

/// Runs [sideEffect] after every completed render of a [DartFunctionComponent].
///
/// If [dependencies] are given, [sideEffect] will only run if one of the [dependencies] have changed.
/// [sideEffect] may return a cleanup function that is run before the component unmounts or re-renders.
///
/// > __Note:__ there are two [rules for using Hooks](https://reactjs.org/docs/hooks-rules.html):
/// >
/// > * Only call Hooks at the top level.
/// > * Only call Hooks from inside a [DartFunctionComponent].
///
/// __Example__:
///
/// ```
/// UseEffectTestComponent(Map props) {
///   final count = useState(1);
///   final evenOdd = useState('even');
///
///   useEffect(() {
///     if (count.value % 2 == 0) {
///       evenOdd.set('even');
///     } else {
///       evenOdd.set('odd');
///     }
///     return () {
///       print('count is changing... do some cleanup if you need to');
///     };
///
///     // This dependency prevents the effect from running every time [evenOdd.value] changes.
///   }, [count.value]);
///
///   return react.div({}, [
///     react.p({}, ['${count.value} is ${evenOdd.value}']),
///     react.button({'onClick': (_) => count.set(count.value + 1)}, ['+']),
///   ]);
/// }
/// ```
///
/// See: <https://reactjs.org/docs/hooks-effect.html#tip-optimizing-performance-by-skipping-effects>.
void useEffect(dynamic Function() sideEffect, [List<Object> dependencies]) {
  var wrappedSideEffect = allowInterop(() {
    var result = sideEffect();
    if (result is Function) {
      return allowInterop(result);
    }

    /// When no cleanup function is returned, [sideEffect] returns undefined.
    return jsUndefined;
  });

  if (dependencies != null) {
    return React.useEffect(wrappedSideEffect, dependencies);
  } else {
    return React.useEffect(wrappedSideEffect);
  }
}

/// Returns a memoized version of [callback] that only changes if one of the [dependencies] has changed.
///
/// > __Note:__ there are two [rules for using Hooks](https://reactjs.org/docs/hooks-rules.html):
/// >
/// > * Only call Hooks at the top level.
/// > * Only call Hooks from inside a [DartFunctionComponent].
///
/// __Example__:
///
/// ```
/// UseCallbackTestComponent(Map props) {
///   final count = useState(0);
///   final delta = useState(1);
///
///   var increment = useCallback((_) {
///     count.setWithUpdater((prev) => prev + delta.value);
///   }, [delta.value]);
///
///   var incrementDelta = useCallback((_) {
///     delta.setWithUpdater((prev) => prev + 1);
///   }, []);
///
///   return react.div({}, [
///     react.div({}, ['Delta is ${delta.value}']),
///     react.div({}, ['Count is ${count.value}']),
///     react.button({'onClick': increment}, ['Increment count']),
///     react.button({'onClick': incrementDelta}, ['Increment delta']),
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#usecallback>.
Function useCallback(Function callback, List dependencies) => React.useCallback(allowInterop(callback), dependencies);

/// Returns the value of the nearest [Context.Provider] for the provided [context] object every time that context is
/// updated.
///
/// The usage is similar to that of a [Context.Consumer] in that the return type of [useContext] is dependent upon
/// the typing of the value passed into [createContext] and [Context.Provider].
///
/// > __Note:__ there are two [rules for using Hooks](https://reactjs.org/docs/hooks-rules.html):
/// >
/// > * Only call Hooks at the top level.
/// > * Only call Hooks from inside a [DartFunctionComponent].
///
/// __Example__:
///
/// ```
/// Context countContext = createContext(0);
///
/// UseCallbackTestComponent(Map props) {
///   final count = useContext(countContext);
///
///   return react.div({}, [
///     react.div({}, ['The count from context is $count']), // initially renders: 'The count from context is 0'
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#usecontext>.
T useContext<T>(Context<T> context) => ContextHelpers.unjsifyNewContext(React.useContext(context.jsThis));

/// Returns a mutable [Ref] object that will persist for the full lifetime of the component.
///
/// The [Ref.current] property is initialized to [initialValue] and does not cause a re-render of
/// the containing [DartFunctionComponent] when updated.
///
/// > __Note:__ there are two [rules for using Hooks](https://reactjs.org/docs/hooks-rules.html):
/// >
/// > * Only call Hooks at the top level.
/// > * Only call Hooks from inside a [DartFunctionComponent].
///
/// __Example__:
///
/// ```
/// UseRefTestComponent(Map props) {
///   final inputElement = useRef();
///
///   onButtonClick(_) {
///     inputElement.current.focus();
///   }
///
///   return react.Fragment({}, [
///     react.input({'ref': inputElement}),
///     react.button({'onClick': onButtonClick}, ['Focus the input']),
///   ]);
/// }
/// ```
///
/// Learn more: <https://reactjs.org/docs/hooks-reference.html#useref>.
Ref useRef([dynamic initialValue]) => new Ref.useRefInit(initialValue);
