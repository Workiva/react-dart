// ignore_for_file: deprecated_member_use_from_same_package
import 'package:matcher/matcher.dart';
import 'package:react/react.dart';

const Map defaultProps = {'defaultProp': 'default'};
const Map emptyChildrenProps = {'children': []};

Map matchCall(String memberName, {args = anything, props = anything, state = anything, context = anything}) {
  return {
    'memberName': memberName,
    'arguments': args,
    'props': props,
    'state': state,
    'context': context,
  };
}

/// A test helper to record lifecycle calls
mixin LifecycleTestHelper on Component {
  static List staticLifecycleCalls = [];

  /// We needed to add [staticLifecycleCalls] to be able to test static
  /// lifecycle methods like `getDerivedStateFromProps` and
  /// `getDerivedStateFromError`, which don't get called on the same instance
  /// as other lifecycle methods.
  ///
  /// This allows static and instance lifecycle methods to add calls to the same list
  List get lifecycleCalls => staticLifecycleCalls;

  List get lifecycleCallMemberNames => staticLifecycleCalls.map((call) {
        return call['memberName'];
      }).toList();

  T lifecycleCall<T>(String memberName,
      {List arguments = const [], T Function()? defaultReturnValue, Map? staticProps}) {
    // Don't try to access late variables props/state/jsThis before they're initialized.
    const staticLifecycleMethods = {
      'defaultProps',
      'getDefaultProps',
      'getDerivedStateFromProps',
      'getDerivedStateFromError',
    };
    final hasPropsInitialized = !staticLifecycleMethods.contains(memberName);
    final hasStateInitialized = !{
      ...staticLifecycleMethods,
      'initialState',
      'getInitialState',
    }.contains(memberName);

    lifecycleCalls.add({
      'memberName': memberName,
      'arguments': arguments,
      'props': hasPropsInitialized ? Map.from(props) : null,
      'state': hasStateInitialized ? Map.from(state) : null,
      'context': context,
    });

    final lifecycleCallback = (staticProps ?? (hasPropsInitialized ? props : {}))[memberName];
    if (lifecycleCallback != null) {
      return Function.apply(lifecycleCallback as Function, [this, ...arguments]) as T;
    }

    if (defaultReturnValue != null) {
      return defaultReturnValue();
    }

    return null as T;
  }

  void callSetStateWithNullValue() {
    setState(null);
  }
}

abstract class DefaultPropsCachingTestHelper implements Component {
  int get staticGetDefaultPropsCallCount;
  set staticGetDefaultPropsCallCount(int value);
}
