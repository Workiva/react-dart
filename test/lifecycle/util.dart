@JS()
library react.test.lifecycle.util;

import 'package:js/js.dart';
import 'package:matcher/matcher.dart';
import 'package:react/react.dart';

const Map defaultProps = const {'defaultProp': 'default'};
const Map emptyChildrenProps = const {'children': const []};

Map matchCall(String memberName, {args: anything, props: anything, state: anything, context: anything}) {
  return {
    'memberName': memberName,
    'arguments': args,
    'props': props,
    'state': state,
    'context': context,
  };
}

/// A test helper to record lifecycle calls
// ignore: deprecated_member_use_from_same_package
mixin LifecycleTestHelper on Component {
  static List staticLifecycleCalls = [];

  /// We needed to add [staticLifecycleCalls] to be able to test static
  /// lifecycle methods like [getDerivedStateFromProps] and
  /// [getDerivedStateFromError], which don't get called on the same instance
  /// as other lifecycle methods.
  ///
  /// This alllows static and instance lifecycle methods to add calls to the same list
  List get lifecycleCalls => staticLifecycleCalls;

  List get lifecycleCallMemberNames => staticLifecycleCalls.map((call) {
        return call['memberName'];
      }).toList();

  dynamic lifecycleCall(String memberName, {List arguments: const [], defaultReturnValue(), Map staticProps}) {
    lifecycleCalls.add({
      'memberName': memberName,
      'arguments': arguments,
      'props': props == null ? null : new Map.from(props),
      'state': state == null ? null : new Map.from(state),
      'context': context,
    });

    var lifecycleCallback = props == null
        ? staticProps == null
            ? null
            : staticProps[memberName]
        : props[memberName];
    if (lifecycleCallback != null) {
      return Function.apply(
          lifecycleCallback,
          []
            ..add(this)
            ..addAll(arguments));
    }

    if (defaultReturnValue != null) {
      return defaultReturnValue();
    }

    return null;
  }

  void callSetStateWithNullValue() {
    setState(null);
  }
}

// ignore: deprecated_member_use_from_same_package
abstract class DefaultPropsCachingTestHelper implements Component {
  int get staticGetDefaultPropsCallCount;
  set staticGetDefaultPropsCallCount(int value);
}

@JS()
external List getUpdatingSetStateLifeCycleCalls();

@JS()
external List getComponent2UpdatingSetStateLifeCycleCalls();

@JS()
external List getNonUpdatingSetStateLifeCycleCalls();

@JS()
external List getComponent2NonUpdatingSetStateLifeCycleCalls();

@JS()
external int getLatestJSCounter();

@JS()
external int getComponent2LatestJSCounter();

@JS()
external String getUpdatingRenderedCounter();

@JS()
external String getComponent2UpdatingRenderedCounter();

@JS()
external String getNonUpdatingRenderedCounter();

@JS()
external String getComponent2NonUpdatingRenderedCounter();

@JS()
external String getComponent2ErrorMessage();

@JS()
external dynamic getComponent2ErrorInfo();

@JS()
external String getComponent2ErrorFromDerivedState();
