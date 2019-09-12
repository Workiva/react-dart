// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.lifecycle_test.component2;

import "package:js/js.dart";
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'util.dart';

ReactDartComponentFactoryProxy2 SetStateTest = react.registerComponent(() => new _SetStateTest(), [null]);
ReactDartComponentFactoryProxy2 DefaultSkipMethodsTest = react.registerComponent(() => new _SetStateTest());
ReactDartComponentFactoryProxy2 SkipMethodsTest =
    react.registerComponent(() => new _SetStateTest(), ['getSnapshotBeforeUpdate']);

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

ReactDartComponentFactoryProxy2 DefaultPropsTest = react.registerComponent(() => new _DefaultPropsTest());

class _DefaultPropsTest extends react.Component2 {
  static int getDefaultPropsCallCount = 0;

  Map get defaultProps => {'defaultProp': 'default'};

  render() => false;
}

ReactDartComponentFactoryProxy2 PropTypesTest = react.registerComponent(() => new PropTypesTestComponent());

class PropTypesTestComponent extends react.Component2 {
  get propTypes => {
        'intProp': (Map props, propName, componentName, location, propFullName) {
          if (props[propName] is! int) {
            return ArgumentError(
                '$propName should be int. {"props": "$props", "propName": "$propName", "componentName": "$componentName", "location": "$location", "propFullName": "$propFullName"}');
          }
          return null;
        }
      };

  render() => '';
}

react.Context LifecycleTestContext = react.createContext();

ReactDartComponentFactoryProxy2 ContextConsumerWrapper = react.registerComponent(() => new _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 with LifecycleTestHelper {
  dynamic render() {
    return LifecycleTestContext.Consumer({}, props['children'].first);
  }
}

ReactDartComponentFactoryProxy2 ContextWrapper = react.registerComponent(() => new _ContextWrapper());

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

ReactDartComponentFactoryProxy2 LifecycleTestWithContext =
    react.registerComponent(() => new _LifecycleTestWithContext());

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  get contextType => LifecycleTestContext;
}

ReactDartComponentFactoryProxy2 ErrorComponent = react.registerComponent(() => new _ErrorComponent());

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

ReactDartComponentFactoryProxy2 LifecycleTest = react.registerComponent(() => new _LifecycleTest());

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
