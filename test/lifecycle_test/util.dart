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

  static bool _throwsLateInitializationError(void Function() accessLateVariable) {
    try {
      accessLateVariable();
    } catch (e) {
      if (e.toString().contains('LateInitializationError')) {
        return true;
      } else {
        rethrow;
      }
    }

    return false;
  }

  T lifecycleCall<T>(String memberName,
      {List arguments = const [], T Function()? defaultReturnValue, Map? staticProps}) {
    // If this is false and we access late variables, such as jsThis/props/state, we'll get a LateInitializationError
    // fixme rethink this solution, since it's gross and also might not work in dart2js or mixed mode; perhaps conditionally don't try to access props/state in early lifecycle methods
    final hasPropsInitialized = !_throwsLateInitializationError(() => props);
    final hasStateInitialized = !_throwsLateInitializationError(() => state);

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
