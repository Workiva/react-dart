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
mixin LifecycleTestHelper on Component {
  dynamic context;
  Map props;
  Map state;

  List lifecycleCalls = [];

  dynamic lifecycleCall(String memberName, {List arguments: const [], defaultReturnValue()}) {
    lifecycleCalls.add({
      'memberName': memberName,
      'arguments': arguments,
      'props': props == null ? null : new Map.from(props),
      'state': state == null ? null : new Map.from(state),
      'context': context,
    });

    var lifecycleCallback = props == null ? null : props[memberName];
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

abstract class DefaultPropsCachingTestHelper implements Component {
  int get staticGetDefaultPropsCallCount;
  set staticGetDefaultPropsCallCount(int value);
}
