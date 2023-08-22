// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.lifecycle_test.component;

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';

import 'util.dart';

final SetStateTest = react.registerComponent(() => _SetStateTest()) as ReactDartComponentFactoryProxy;

class _SetStateTest extends react.Component with LifecycleTestHelper {
  @override
  getDefaultProps() => const {'shouldUpdate': true};

  @override
  getInitialState() => const {'counter': 1};

  @override
  componentWillReceiveProps(_) {
    recordLifecyleCall('componentWillReceiveProps');
  }

  @override
  componentWillReceivePropsWithContext(_, __) {
    recordLifecyleCall('componentWillReceivePropsWithContext');
  }

  @override
  componentWillUpdate(_, __) {
    recordLifecyleCall('componentWillUpdate');
  }

  @override
  componentDidUpdate(_, __) {
    recordLifecyleCall('componentDidUpdate');
  }

  @override
  shouldComponentUpdate(_, __) {
    recordLifecyleCall('shouldComponentUpdate');
    return props['shouldUpdate'] as bool;
  }

  Map outerTransactionalSetStateCallback(previousState, __) {
    recordLifecyleCall('outerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  Map innerTransactionalSetStateCallback(previousState, __) {
    recordLifecyleCall('innerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  void recordLifecyleCall(String name) {
    // TODO update this class to use lifecycleCall instead
    lifecycleCalls.add(name);
  }

  @override
  render() {
    recordLifecyleCall('render');

    return react.div(
      {
        'onClick': (_) {
          setState(outerTransactionalSetStateCallback, () {
            recordLifecyleCall('outerSetStateCallback');
          });
        }
      },
      react.div({
        'onClick': (_) {
          setState(innerTransactionalSetStateCallback, () {
            recordLifecyleCall('innerSetStateCallback');
          });
        }
      }, state['counter']),
    );
  }
}

_DefaultPropsCachingTest defaultPropsCachingTestComponentFactory() => _DefaultPropsCachingTest();

class _DefaultPropsCachingTest extends react.Component implements DefaultPropsCachingTestHelper {
  static int getDefaultPropsCallCount = 0;

  @override
  get staticGetDefaultPropsCallCount => getDefaultPropsCallCount;

  @override
  set staticGetDefaultPropsCallCount(int value) => getDefaultPropsCallCount = value;

  @override
  getDefaultProps() {
    getDefaultPropsCallCount++;
    return {'getDefaultPropsCallCount': getDefaultPropsCallCount};
  }

  @override
  render() => null;
}

final DefaultPropsTest = react.registerComponent(() => _DefaultPropsTest()) as ReactDartComponentFactoryProxy;

class _DefaultPropsTest extends react.Component {
  static int getDefaultPropsCallCount = 0;

  /// A workaround for not being able to call static methods when the
  /// class is not known.
  int get staticGetDefaultPropsCallCount => getDefaultPropsCallCount;

  @override
  getDefaultProps() => {'defaultProp': 'default'};

  @override
  render() => null;
}

final ContextWrapperWithoutKeys =
    react.registerComponent(() => _ContextWrapperWithoutKeys()) as ReactDartComponentFactoryProxy;

class _ContextWrapperWithoutKeys extends react.Component with LifecycleTestHelper {
  @override
  get childContextKeys => const [];

  @override
  getChildContext() {
    lifecycleCall('getChildContext');
    return {
      'foo': props['foo'],
      'extraContext': props['extraContext'],
    };
  }

  @override
  render() => react.div({}, props['children']);
}

final ContextWrapper = react.registerComponent(() => _ContextWrapper()) as ReactDartComponentFactoryProxy;

class _ContextWrapper extends react.Component with LifecycleTestHelper {
  @override
  get childContextKeys => const ['foo', 'extraContext'];

  @override
  getChildContext() {
    lifecycleCall('getChildContext');
    return {
      'foo': props['foo'],
      'extraContext': props['extraContext'],
    };
  }

  @override
  render() => react.div({}, props['children']);
}

final LifecycleTestWithContext =
    react.registerComponent(() => _LifecycleTestWithContext()) as ReactDartComponentFactoryProxy;

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  get contextKeys => const ['foo']; // only listening to one context key
}

final LifecycleTest = react.registerComponent(() => _LifecycleTest()) as ReactDartComponentFactoryProxy;

class _LifecycleTest extends react.Component with LifecycleTestHelper {
  @override
  componentWillMount() => lifecycleCall('componentWillMount');
  @override
  componentDidMount() => lifecycleCall('componentDidMount');
  @override
  componentWillUnmount() => lifecycleCall('componentWillUnmount');

  @override
  componentWillReceiveProps(newProps) => lifecycleCall('componentWillReceiveProps', arguments: [Map.from(newProps)]);

  @override
  componentWillReceivePropsWithContext(newProps, newContext) => lifecycleCall('componentWillReceivePropsWithContext',
      arguments: [Map.from(newProps), Map.from(newContext as Map)]);

  @override
  componentWillUpdate(nextProps, nextState) =>
      lifecycleCall('componentWillUpdate', arguments: [Map.from(nextProps), Map.from(nextState)]);

  @override
  componentWillUpdateWithContext(nextProps, nextState, nextContext) => lifecycleCall('componentWillUpdateWithContext',
      arguments: [Map.from(nextProps), Map.from(nextState), Map.from(nextContext)]);

  @override
  componentDidUpdate(prevProps, prevState) =>
      lifecycleCall('componentDidUpdate', arguments: [Map.from(prevProps), Map.from(prevState)]);

  @override
  shouldComponentUpdate(nextProps, nextState) => lifecycleCall('shouldComponentUpdate',
      arguments: [Map.from(nextProps), Map.from(nextState)], defaultReturnValue: () => true);

  @override
  shouldComponentUpdateWithContext(nextProps, nextState, nextContext) =>
      lifecycleCall('shouldComponentUpdateWithContext',
          arguments: [Map.from(nextProps), Map.from(nextState), Map.from(nextContext)], defaultReturnValue: () => true);

  @override
  render() => lifecycleCall('render', defaultReturnValue: () => react.div({}));

  @override
  getInitialState() => lifecycleCall('getInitialState', defaultReturnValue: () => {});

  @override
  getDefaultProps() {
    lifecycleCall('getDefaultProps');

    return {'defaultProp': 'default'};
  }
}
