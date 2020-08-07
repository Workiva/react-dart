// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.lifecycle_test.component2;

import "package:js/js.dart";
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'util.dart';

final SetStateTest = react.registerComponent2(() => new _SetStateTest(), skipMethods: [null]);
final DefaultSkipMethodsTest = react.registerComponent2(() => new _SetStateTest());
final SkipMethodsTest = react.registerComponent2(() => new _SetStateTest(), skipMethods: ['getSnapshotBeforeUpdate']);

class _SetStateTest extends react.Component2 with LifecycleTestHelper {
  @override
  get defaultProps => {
        'shouldUpdate': true,
      };

  @override
  get initialState => {
        'counter': 1,
        'shouldThrow': true,
        'errorFromGetDerivedState': '',
        'error': '',
        'info': '',
      };

  @override
  Map getDerivedStateFromProps(_, __) {
    lifecycleCall('getDerivedStateFromProps');
    return {};
  }

  @override
  getSnapshotBeforeUpdate(_, __) {
    lifecycleCall('getSnapshotBeforeUpdate');
  }

  @override
  componentDidUpdate(_, __, [___]) {
    lifecycleCall('componentDidUpdate');
  }

  @override
  shouldComponentUpdate(_, __) {
    lifecycleCall('shouldComponentUpdate');
    return props['shouldUpdate'] as bool;
  }

  @override
  componentDidCatch(dynamic error, ReactErrorInfo info) {
    lifecycleCall('componentDidCatch', arguments: [error, info]);
    this.setState({'error': error, 'info': info.componentStack});
  }

  @override
  Map getDerivedStateFromError(error) {
    lifecycleCall('getDerivedStateFromError', arguments: [error]);
    return {"shouldThrow": false, "errorFromGetDerivedState": error};
  }

  Map outerTransactionalSetStateCallback(Map previousState, __) {
    lifecycleCall('outerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  Map innerTransactionalSetStateCallback(Map previousState, __) {
    lifecycleCall('innerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  render() {
    lifecycleCall('render');

    if (!state['shouldThrow']) {
      return react.div({
        'onClick': (_) {
          setStateWithUpdater(outerTransactionalSetStateCallback, () {
            lifecycleCall('outerSetStateCallback');
          });
        }
      }, [
        react.div({
          'onClick': (_) {
            setStateWithUpdater(innerTransactionalSetStateCallback, () {
              lifecycleCall('innerSetStateCallback');
            });
          },
          'key': 'c1',
        }, state['counter']),
        react.div({'key': 'c2'}, state['error'].toString()),
        react.div({'key': 'c3'}, state['info'].toString()),
        react.div({'key': 'c4'}, state['errorFromGetDerivedState'].toString()),
      ]);
    } else {
      return react.div(
          {
            'onClick': (_) {
              setStateWithUpdater(outerTransactionalSetStateCallback, () {
                lifecycleCall('outerSetStateCallback');
              });
            }
          },
          react.div({
            'onClick': (_) {
              setStateWithUpdater(innerTransactionalSetStateCallback, () {
                lifecycleCall('innerSetStateCallback');
              });
            }
          }, [
            state["shouldThrow"] ? ErrorComponent({"key": "errorComp"}) : null,
            state['counter']
          ]));
    }
  }
}

_DefaultPropsCachingTest defaultPropsCachingTestComponentFactory() => new _DefaultPropsCachingTest();

class _DefaultPropsCachingTest extends react.Component2 implements DefaultPropsCachingTestHelper {
  static int getDefaultPropsCallCount = 0;

  int get staticGetDefaultPropsCallCount => getDefaultPropsCallCount;

  @override
  set staticGetDefaultPropsCallCount(int value) => getDefaultPropsCallCount = value;

  Map get defaultProps {
    getDefaultPropsCallCount++;
    return {'getDefaultPropsCallCount': getDefaultPropsCallCount};
  }

  render() => false;
}

final DefaultPropsTest = react.registerComponent2(() => new _DefaultPropsTest());

class _DefaultPropsTest extends react.Component2 {
  Map get defaultProps => {'defaultProp': 'default'};

  render() => false;
}

final PropTypesTest = react.registerComponent2(() => new PropTypesTestComponent());

class PropTypesTestComponent extends react.Component2 {
  get propTypes => {
        'intProp': (Map props, info) {
          var propValue = props[info.propName];
          if (propValue is! int) {
            return ArgumentError(
                '${info.propName} should be int. {"props": "$props", "propName": "${info.propName}", "componentName": "${info.componentName}", "location": "${info.location}", "propFullName": "${info.propFullName}"}');
          }
          return null;
        }
      };

  render() => '';
}

react.Context LifecycleTestContext = react.createContext();

final ContextConsumerWrapper = react.registerComponent2(() => new _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 with LifecycleTestHelper {
  dynamic render() {
    return LifecycleTestContext.Consumer({}, props['children'].first);
  }
}

final ContextWrapper = react.registerComponent2(() => new _ContextWrapper());

class _ContextWrapper extends react.Component2 with LifecycleTestHelper {
  dynamic render() {
    return LifecycleTestContext.Provider(
      {
        'value': {'foo': props['foo']}
      },
      props['children'],
    );
  }
}

final LifecycleTestWithContext = react.registerComponent2(() => new _LifecycleTestWithContext());

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  get contextType => LifecycleTestContext;
}

final ErrorComponent = react.registerComponent2(() => new _ErrorComponent());

class TestDartException implements Exception {
  int code;
  String message;

  TestDartException(this.message, this.code);

  toString() {
    return message;
  }
}

class _ErrorComponent extends react.Component2 {
  void _throwError() {
    throw TestDartException("It crashed!", 100);
  }

  void render() {
    _throwError();
    return react.div({'key': 'defaultMessage'}, "Error");
  }
}

final ErrorLifecycleTest = react.registerComponent2(() => new _LifecycleTest(), skipMethods: []);
final LifecycleTest = react.registerComponent2(() => new _LifecycleTest());

class _LifecycleTest extends react.Component2 with LifecycleTestHelper {
  void componentDidMount() => lifecycleCall('componentDidMount');
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  Map getDerivedStateFromProps(nextProps, prevState) => lifecycleCall('getDerivedStateFromProps',
      arguments: [new Map.from(nextProps), new Map.from(prevState)], staticProps: nextProps);

  dynamic getSnapshotBeforeUpdate(prevProps, prevState) =>
      lifecycleCall('getSnapshotBeforeUpdate', arguments: [new Map.from(prevProps), new Map.from(prevState)]);

  void componentDidUpdate(prevProps, prevState, [snapshot]) =>
      lifecycleCall('componentDidUpdate', arguments: [new Map.from(prevProps), new Map.from(prevState), snapshot]);

  void componentDidCatch(error, info) => lifecycleCall('componentDidCatch', arguments: [error, info]);

  Map getDerivedStateFromError(error) => lifecycleCall('getDerivedStateFromError', arguments: [error]);

  bool shouldComponentUpdate(nextProps, nextState) => lifecycleCall('shouldComponentUpdate',
      arguments: [new Map.from(nextProps), new Map.from(nextState)], defaultReturnValue: () => true);

  dynamic render() => lifecycleCall('render', defaultReturnValue: () => react.div({}));

  Map get initialState => lifecycleCall('initialState', defaultReturnValue: () => {});

  Map get defaultProps => lifecycleCall('defaultProps', defaultReturnValue: () => {'defaultProp': 'default'});
}

final NoGetDerivedStateFromErrorLifecycleTest =
    react.registerComponent2(() => new _NoGetDerivedStateFromErrorLifecycleTest(), skipMethods: []);

class _NoGetDerivedStateFromErrorLifecycleTest extends react.Component2 with LifecycleTestHelper {
  void componentDidMount() => lifecycleCall('componentDidMount');
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  Map getDerivedStateFromProps(nextProps, prevState) => lifecycleCall('getDerivedStateFromProps',
      arguments: [new Map.from(nextProps), new Map.from(prevState)], staticProps: nextProps);

  dynamic getSnapshotBeforeUpdate(prevProps, prevState) =>
      lifecycleCall('getSnapshotBeforeUpdate', arguments: [new Map.from(prevProps), new Map.from(prevState)]);

  void componentDidUpdate(prevProps, prevState, [snapshot]) =>
      lifecycleCall('componentDidUpdate', arguments: [new Map.from(prevProps), new Map.from(prevState), snapshot]);

  void componentDidCatch(error, info) => lifecycleCall('componentDidCatch', arguments: [error, info]);

  bool shouldComponentUpdate(nextProps, nextState) => lifecycleCall('shouldComponentUpdate',
      arguments: [new Map.from(nextProps), new Map.from(nextState)], defaultReturnValue: () => true);

  dynamic render() => lifecycleCall('render', defaultReturnValue: () => react.div({}));

  Map get initialState => lifecycleCall('initialState', defaultReturnValue: () => {});

  Map get defaultProps => lifecycleCall('defaultProps', defaultReturnValue: () => {'defaultProp': 'default'});
}
