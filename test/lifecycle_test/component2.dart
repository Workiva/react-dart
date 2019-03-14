@JS()
library react.lifecycle_test.component2;

import "package:js/js.dart";
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';

import 'util.dart';

ReactDartComponentFactoryProxy2 SetStateTest =
    react.registerComponent(() => new _SetStateTest());

class _SetStateTest extends react.Component2 with LifecycleTestHelper {
  @override
  Map getDefaultProps() => {'shouldUpdate': true};

  @override
  getInitialState() => {"counter": 1};

  @override
  componentWillReceiveProps(_) {
    recordLifecyleCall('componentWillReceiveProps');
  }

  @override
  componentWillReceivePropsWithContext(_, __) {
    recordLifecyleCall('componentWillReceivePropsWithContext');
  }

  @override
  getSnapshotBeforeUpdate(_, __) {
    recordLifecyleCall('getSnapshotBeforeUpdate');
  }

  @override
  componentDidUpdate(_, __, [___]) {
    recordLifecyleCall('componentDidUpdate');
  }

  @override
  shouldComponentUpdate(_, __) {
    recordLifecyleCall('shouldComponentUpdate');
    return props['shouldUpdate'] as bool;
  }

  Map outerTransactionalSetStateCallback(Map previousState, __) {
    recordLifecyleCall('outerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  Map innerTransactionalSetStateCallback(Map previousState, __) {
    recordLifecyleCall('innerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  void recordLifecyleCall(String name) {
    // TODO update this class to use lifecycleCall instead
    lifecycleCalls.add(name);
  }

  render() {
    recordLifecyleCall('render');

    return react.div(
        {
          'onClick': (_) {
            setStateWithUpdater(outerTransactionalSetStateCallback, () {
              recordLifecyleCall('outerSetStateCallback');
            });
          }
        },
        react.div({
          'onClick': (_) {
            setStateWithUpdater(innerTransactionalSetStateCallback, () {
              recordLifecyleCall('innerSetStateCallback');
            });
          }
        }, state['counter']));
  }
}

_DefaultPropsCachingTest defaultPropsCachingTestComponentFactory() =>
    new _DefaultPropsCachingTest();

class _DefaultPropsCachingTest extends react.Component2
    implements DefaultPropsCachingTestHelper {
  static int getDefaultPropsCallCount = 0;

  int get staticGetDefaultPropsCallCount => getDefaultPropsCallCount;

  @override
  set staticGetDefaultPropsCallCount(int value) =>
      getDefaultPropsCallCount = value;

  Map getDefaultProps() {
    getDefaultPropsCallCount++;
    return {'getDefaultPropsCallCount': getDefaultPropsCallCount};
  }

  render() => false;
}

ReactDartComponentFactoryProxy2 DefaultPropsTest =
    react.registerComponent(() => new _DefaultPropsTest());

class _DefaultPropsTest extends react.Component2 {
  static int getDefaultPropsCallCount = 0;

  Map getDefaultProps() => {'defaultProp': 'default'};

  render() => false;
}

ReactDartComponentFactoryProxy2 ContextWrapperWithoutKeys =
    react.registerComponent(() => new _ContextWrapperWithoutKeys());

class _ContextWrapperWithoutKeys extends react.Component2
    with LifecycleTestHelper {
  @override
  Iterable<String> get childContextKeys => const [];

  @override
  Map<String, dynamic> getChildContext() {
    lifecycleCall('getChildContext');
    return {
      'foo': props['foo'],
      'extraContext': props['extraContext'],
    };
  }

  dynamic render() => react.div({}, props['children']);
}

ReactDartComponentFactoryProxy2 ContextWrapper =
    react.registerComponent(() => new _ContextWrapper());

class _ContextWrapper extends react.Component2 with LifecycleTestHelper {
  @override
  Iterable<String> get childContextKeys => const ['foo', 'extraContext'];

  @override
  Map<String, dynamic> getChildContext() {
    lifecycleCall('getChildContext');
    return {
      'foo': props['foo'],
      'extraContext': props['extraContext'],
    };
  }

  dynamic render() => react.div({}, props['children']);
}

ReactDartComponentFactoryProxy2 LifecycleTestWithContext =
    react.registerComponent(() => new _LifecycleTestWithContext());

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  Iterable<String> get contextKeys =>
      const ['foo']; // only listening to one context key
}

ReactDartComponentFactoryProxy2 LifecycleTest =
    react.registerComponent(() => new _LifecycleTest());

class _LifecycleTest extends react.Component2 with LifecycleTestHelper {
  void componentWillMount() => lifecycleCall('componentWillMount');
  void componentDidMount() => lifecycleCall('componentDidMount');
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  void componentWillReceiveProps(newProps) =>
      lifecycleCall('componentWillReceiveProps',
          arguments: [new Map.from(newProps)]);

  void componentWillReceivePropsWithContext(newProps, newContext) =>
      lifecycleCall('componentWillReceivePropsWithContext',
          arguments: [new Map.from(newProps), new Map.from(newContext)]);

  void componentWillUpdateWithContext(nextProps, nextState, nextContext) =>
      lifecycleCall('componentWillUpdateWithContext', arguments: [
        new Map.from(nextProps),
        new Map.from(nextState),
        new Map.from(nextContext)
      ]);

  dynamic getSnapshotBeforeUpdate(prevProps, prevState) =>
      lifecycleCall('getSnapshotBeforeUpdate',
          arguments: [new Map.from(prevProps), new Map.from(prevState)]);

  void componentDidUpdate(prevProps, prevState, [snapshot]) => lifecycleCall(
      'componentDidUpdate',
      arguments: [new Map.from(prevProps), new Map.from(prevState), snapshot]);

  bool shouldComponentUpdate(nextProps, nextState) =>
      lifecycleCall('shouldComponentUpdate',
          arguments: [new Map.from(nextProps), new Map.from(nextState)],
          defaultReturnValue: () => true);

  bool shouldComponentUpdateWithContext(nextProps, nextState, nextContext) =>
      lifecycleCall('shouldComponentUpdateWithContext',
          arguments: [
            new Map.from(nextProps),
            new Map.from(nextState),
            new Map.from(nextContext)
          ],
          defaultReturnValue: () => true);

  dynamic render() =>
      lifecycleCall('render', defaultReturnValue: () => react.div({}));

  Map getInitialState() =>
      lifecycleCall('getInitialState', defaultReturnValue: () => {});

  Map getDefaultProps() {
    lifecycleCall('getDefaultProps');

    return {'defaultProp': 'default'};
  }
}
