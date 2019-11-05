// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library react.lifecycle_test.component2;

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'util.dart';

ReactDartComponentFactoryProxy2 SetStateTest = react.registerComponent(() => _SetStateTest(), [null]);
ReactDartComponentFactoryProxy2 DefaultSkipMethodsTest = react.registerComponent(() => _SetStateTest());
ReactDartComponentFactoryProxy2 SkipMethodsTest =
    react.registerComponent(() => _SetStateTest(), ['getSnapshotBeforeUpdate']);

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
    return {'shouldThrow': false, 'errorFromGetDerivedState': error};
  }

  Map outerTransactionalSetStateCallback(Map previousState, __) {
    lifecycleCall('outerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  Map innerTransactionalSetStateCallback(Map previousState, __) {
    lifecycleCall('innerTransactionalSetStateCallback');
    return {'counter': previousState['counter'] + 1};
  }

  @override
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
            state['shouldThrow'] ? ErrorComponent({'key': 'errorComp'}) : null,
            state['counter']
          ]));
    }
  }
}

_DefaultPropsCachingTest defaultPropsCachingTestComponentFactory() => _DefaultPropsCachingTest();

class _DefaultPropsCachingTest extends react.Component2 implements DefaultPropsCachingTestHelper {
  static int getDefaultPropsCallCount = 0;

  @override
  int get staticGetDefaultPropsCallCount => getDefaultPropsCallCount;

  @override
  set staticGetDefaultPropsCallCount(int value) => getDefaultPropsCallCount = value;

  @override
  get defaultProps {
    getDefaultPropsCallCount++;
    return {'getDefaultPropsCallCount': getDefaultPropsCallCount};
  }

  @override
  render() => false;
}

ReactDartComponentFactoryProxy2 DefaultPropsTest = react.registerComponent(() => _DefaultPropsTest());

class _DefaultPropsTest extends react.Component2 {
  static int getDefaultPropsCallCount = 0;

  @override
  get defaultProps => {'defaultProp': 'default'};

  @override
  render() => false;
}

ReactDartComponentFactoryProxy2 PropTypesTest = react.registerComponent(() => PropTypesTestComponent());

class PropTypesTestComponent extends react.Component2 {
  @override
  get propTypes => {
        // ignore: avoid_types_on_closure_parameters
        'intProp': (Map props, propName, componentName, location, propFullName) {
          if (props[propName] is! int) {
            return ArgumentError(
                '$propName should be int. {"props": "$props", "propName": "$propName", "componentName": "$componentName", "location": "$location", "propFullName": "$propFullName"}');
          }
          return null;
        }
      };

  @override
  render() => '';
}

react.Context LifecycleTestContext = react.createContext();

ReactDartComponentFactoryProxy2 ContextConsumerWrapper = react.registerComponent(() => _ContextConsumerWrapper());

class _ContextConsumerWrapper extends react.Component2 with LifecycleTestHelper {
  @override
  dynamic render() {
    return LifecycleTestContext.Consumer({}, props['children'].first);
  }
}

ReactDartComponentFactoryProxy2 ContextWrapper = react.registerComponent(() => _ContextWrapper());

class _ContextWrapper extends react.Component2 with LifecycleTestHelper {
  @override
  dynamic render() {
    return LifecycleTestContext.Provider(
      {
        'value': {'foo': props['foo']}
      },
      props['children'],
    );
  }
}

ReactDartComponentFactoryProxy2 LifecycleTestWithContext = react.registerComponent(() => _LifecycleTestWithContext());

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  get contextType => LifecycleTestContext;
}

ReactDartComponentFactoryProxy2 ErrorComponent = react.registerComponent(() => _ErrorComponent());

class TestDartException implements Exception {
  int code;
  String message;

  TestDartException(this.message, this.code);

  @override
  toString() {
    return message;
  }
}

class _ErrorComponent extends react.Component2 {
  void _throwError() {
    throw TestDartException('It crashed!', 100);
  }

  @override
  render() {
    _throwError();
    return react.div({'key': 'defaultMessage'}, 'Error');
  }
}

ReactDartComponentFactoryProxy2 LifecycleTest = react.registerComponent(() => _LifecycleTest());

class _LifecycleTest extends react.Component2 with LifecycleTestHelper {
  @override
  void componentDidMount() => lifecycleCall('componentDidMount');
  @override
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  @override
  Map getDerivedStateFromProps(nextProps, prevState) => lifecycleCall('getDerivedStateFromProps',
      arguments: [Map.from(nextProps), Map.from(prevState)], staticProps: nextProps);

  @override
  dynamic getSnapshotBeforeUpdate(prevProps, prevState) =>
      lifecycleCall('getSnapshotBeforeUpdate', arguments: [Map.from(prevProps), Map.from(prevState)]);

  @override
  void componentDidUpdate(prevProps, prevState, [snapshot]) =>
      lifecycleCall('componentDidUpdate', arguments: [Map.from(prevProps), Map.from(prevState), snapshot]);

  @override
  void componentDidCatch(error, info) => lifecycleCall('componentDidCatch', arguments: [error, info]);

  @override
  Map getDerivedStateFromError(error) => lifecycleCall('getDerivedStateFromError', arguments: [error]);

  @override
  bool shouldComponentUpdate(nextProps, nextState) => lifecycleCall('shouldComponentUpdate',
      arguments: [Map.from(nextProps), Map.from(nextState)], defaultReturnValue: () => true);

  @override
  dynamic render() => lifecycleCall('render', defaultReturnValue: () => react.div({}));

  @override
  get initialState => lifecycleCall('initialState', defaultReturnValue: () => {});

  @override
  get defaultProps => lifecycleCall('defaultProps', defaultReturnValue: () => {'defaultProp': 'default'});
}
