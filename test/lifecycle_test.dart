@JS()
library lifecycle_test;

import 'dart:html';

import "package:js/js.dart";
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

void main() {
  setClientConfiguration();

  ReactComponent render(ReactElement reactElement) {
    return react_test_utils.renderIntoDocument(reactElement);
  }

  react.Component getDartComponent(ReactComponent dartComponent) {
    return dartComponent.props.internal.component;
  }

  Map getDartComponentProps(ReactComponent dartComponent) {
    return getDartComponent(dartComponent).props;
  }

  Map getDartElementProps(ReactElement dartElement) {
    return dartElement.props.internal.props;
  }

  /// Returns a new [Map.unmodifiable] with all argument maps merged in.
  Map unmodifiableMap([Map map1, Map map2, Map map3, Map map4]) {
    var merged = {};
    if (map1 != null) merged.addAll(map1);
    if (map2 != null) merged.addAll(map2);
    if (map3 != null) merged.addAll(map3);
    if (map4 != null) merged.addAll(map4);
    return new Map.unmodifiable(merged);
  }

  group('React component lifecycle:', () {
    group('default props', () {
      test('getDefaultProps() is only called once per component class and cached', () {
        expect(_DefaultPropsCachingTest.getDefaultPropsCallCount, 0);

        var DefaultPropsComponent = react.registerComponent(() => new _DefaultPropsCachingTest());
        var components = [
          render(DefaultPropsComponent({})),
          render(DefaultPropsComponent({})),
          render(DefaultPropsComponent({})),
        ];

        expect(components.map(getDartComponentProps), everyElement(containsPair('getDefaultPropsCallCount', 1)));
        expect(_DefaultPropsCachingTest.getDefaultPropsCallCount, 1);
      });

      group('are merged into props when the ReactElement is created when', () {
        test('the specified props are empty', () {
          var props = getDartElementProps(DefaultPropsTest({}));
          expect(props, containsPair('defaultProp', 'default'));
        });

        test('the default props are overridden', () {
          var props = getDartElementProps(DefaultPropsTest({'defaultProp': 'overridden'}));
          expect(props, containsPair('defaultProp', 'overridden'));
        });

        test('non-default props are added', () {
          var props = getDartElementProps(DefaultPropsTest({'otherProp': 'other'}));
          expect(props, containsPair('defaultProp', 'default'));
          expect(props, containsPair('otherProp', 'other'));
        });
      });

      group('are merged into props by the time the Dart Component is rendered when', () {
        test('the specified props are empty', () {
          var props = getDartComponentProps(render(DefaultPropsTest({})));
          expect(props, containsPair('defaultProp', 'default'));
        });

        test('the default props are overridden', () {
          var props = getDartComponentProps(render(DefaultPropsTest({'defaultProp': 'overridden'})));
          expect(props, containsPair('defaultProp', 'overridden'));
        });

        test('non-default props are added', () {
          var props = getDartComponentProps(render(DefaultPropsTest({'otherProp': 'other'})));
          expect(props, containsPair('defaultProp', 'default'));
          expect(props, containsPair('otherProp', 'other'));
        });
      });
    });
  });

  group('React component lifecycle:', () {
    const Map defaultProps = const {
      'defaultProp': 'default'
    };
    const Map emptyChildrenProps = const {
      'children': const []
    };

    Map matchCall(String memberName, {args: anything, props: anything, state: anything}) {
      return {
        'memberName': memberName,
        'arguments': args,
        'props': props,
        'state': state,
      };
    }

    test('recieves correct lifecycle calls on component mount', () {
      _LifecycleTest component = getDartComponent(
          render(LifecycleTest({}))
      );

      expect(component.lifecycleCalls, equals([
        matchCall('getInitialState'),
        matchCall('componentWillMount'),
        matchCall('render'),
        matchCall('componentDidMount'),
      ]));
    });

    test('recieves correct lifecycle calls on component unmount order', () {
      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest({}), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.unmountComponentAtNode(mountNode);

      expect(component.lifecycleCalls, equals([
        matchCall('componentWillUnmount'),
      ]));
    });

    test('recieves updated props with correct lifecycle calls and defaults properly merged in', () {
      const Map initialProps = const {
        'initialProp': 'initial',
        'children': const []
      };
      const Map newProps = const {
        'newProp': 'new',
        'children': const []
      };

      final Map initialPropsWithDefaults = unmodifiableMap({}
        ..addAll(defaultProps)
        ..addAll(initialProps)
      );
      final Map newPropsWithDefaults = unmodifiableMap({}
        ..addAll(defaultProps)
        ..addAll(newProps)
      );

      const Map expectedState = const {};

      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.render(LifecycleTest(newProps), mountNode);

      expect(component.lifecycleCalls, equals([
        matchCall('componentWillReceiveProps', args: [newPropsWithDefaults],                    props: initialPropsWithDefaults),
        matchCall('shouldComponentUpdate',     args: [newPropsWithDefaults, expectedState],     props: initialPropsWithDefaults),
        matchCall('componentWillUpdate',       args: [newPropsWithDefaults, expectedState],     props: initialPropsWithDefaults),
        matchCall('render',                                                                     props: newPropsWithDefaults),
        matchCall('componentDidUpdate',        args: [initialPropsWithDefaults, expectedState], props: newPropsWithDefaults),
      ]));
    });

    test('updates state with correct lifecycle calls', () {
      const Map initialState = const {
        'initialState': 'initial',
      };
      const Map newState = const {
        'initialState': 'initial',
        'newState': 'new',
      };
      const Map stateDelta = const {
        'newState': 'new',
      };

      final Map initialProps = unmodifiableMap({
        'getInitialState': (_) => initialState
      });

      final Map expectedProps = unmodifiableMap(
          defaultProps,
          initialProps,
          emptyChildrenProps
      );

      _LifecycleTest component = getDartComponent(render(LifecycleTest(initialProps)));

      component.lifecycleCalls.clear();

      component.setState(stateDelta);

      expect(component.lifecycleCalls, equals([
        matchCall('shouldComponentUpdate', args: [expectedProps, newState],     state: initialState),
        matchCall('componentWillUpdate',   args: [expectedProps, newState],     state: initialState),
        matchCall('render',                                                     state: newState),
        matchCall('componentDidUpdate',    args: [expectedProps, initialState], state: newState),
      ]));
    });

    test('properly handles a call to setState within componentWillReceiveProps', () {
      const Map initialState = const {
        'initialState': 'initial',
      };
      const Map newState = const {
        'initialState': 'initial',
        'newState': 'new',
      };
      const Map stateDelta = const {
        'newState': 'new',
      };

      final Map lifecycleTestProps = unmodifiableMap({
        'getInitialState': (_) => initialState,
        'componentWillReceiveProps': (_LifecycleTest component, Map props) {
          component.setState(stateDelta);
        },
      });
      final Map initialProps = unmodifiableMap(
          {'initialProp': 'initial'}, lifecycleTestProps
      );
      final Map newProps = unmodifiableMap(
          {'newProp': 'new'}, lifecycleTestProps
      );

      final Map initialPropsWithDefaults = unmodifiableMap(
        defaultProps, initialProps, emptyChildrenProps
      );
      final Map newPropsWithDefaults = unmodifiableMap(
        defaultProps, newProps, emptyChildrenProps
      );

      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.render(LifecycleTest(newProps), mountNode);

      expect(component.lifecycleCalls, equals([
        matchCall('componentWillReceiveProps', args: [newPropsWithDefaults],           props: initialPropsWithDefaults, state: initialState),
        matchCall('shouldComponentUpdate',     args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState),
        matchCall('componentWillUpdate',       args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState),
        matchCall('render',                                                                    props: newPropsWithDefaults, state: newState),
        matchCall('componentDidUpdate',        args: [initialPropsWithDefaults, initialState], props: newPropsWithDefaults, state: newState),
      ]));
    });

    group('when shouldComponentUpdate returns false:', () {
      test('recieves updated props with correct lifecycle calls and does not rerender', () {
        final Map initialProps = unmodifiableMap({
          'shouldComponentUpdate': (_, __, ___) => false,
          'initialProp': 'initial',
          'children': const []
        });
        const Map newProps = const {
          'newProp': 'new',
          'children': const []
        };

        final Map initialPropsWithDefaults = unmodifiableMap(
            defaultProps, initialProps
        );
        final Map newPropsWithDefaults = unmodifiableMap(
            defaultProps, newProps
        );

        const Map expectedState = const {};

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        _LifecycleTest component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        expect(component.lifecycleCalls, equals([
          matchCall('componentWillReceiveProps', args: [newPropsWithDefaults],                props: initialPropsWithDefaults),
          matchCall('shouldComponentUpdate',     args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults),
        ]));
        expect(component.props, equals(newPropsWithDefaults));
      });

      test('updates state with correct lifecycle calls and does not rerender', () {
        const Map initialState = const {
          'initialState': 'initial',
        };
        const Map newState = const {
          'initialState': 'initial',
          'newState': 'new',
        };
        const Map stateDelta = const {
          'newState': 'new',
        };

        final Map initialProps = unmodifiableMap({
          'getInitialState': (_) => initialState,
          'shouldComponentUpdate': (_, __, ___) => false,
        });

        final Map expectedProps = unmodifiableMap(
            defaultProps, initialProps, emptyChildrenProps
        );

        _LifecycleTest component = getDartComponent(render(LifecycleTest(initialProps)));
        component.lifecycleCalls.clear();

        component.setState(stateDelta);

        expect(component.lifecycleCalls, equals([
          matchCall('shouldComponentUpdate', args: [expectedProps, newState], state: initialState),
        ]));
        expect(component.state, equals(newState));
      });

      test('properly handles a call to setState within componentWillReceiveProps and does not rerender', () {
        const Map initialState = const {
          'initialState': 'initial',
        };
        const Map newState = const {
          'initialState': 'initial',
          'newState': 'new',
        };
        const Map stateDelta = const {
          'newState': 'new',
        };

        final Map lifecycleTestProps = unmodifiableMap({
          'shouldComponentUpdate': (_, __, ___) => false,
          'getInitialState': (_) => initialState,
          'componentWillReceiveProps': (_LifecycleTest component, Map props) {
            component.setState(stateDelta);
          },
        });
        final Map initialProps = unmodifiableMap(
            {'initialProp': 'initial'}, lifecycleTestProps
        );
        final Map newProps = unmodifiableMap(
            {'newProp': 'new'}, lifecycleTestProps
        );

        final Map initialPropsWithDefaults = unmodifiableMap(
          defaultProps, initialProps, emptyChildrenProps
        );
        final Map newPropsWithDefaults = unmodifiableMap(
          defaultProps, newProps, emptyChildrenProps
        );

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        _LifecycleTest component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        expect(component.lifecycleCalls, equals([
          matchCall('componentWillReceiveProps', args: [newPropsWithDefaults],           props: initialPropsWithDefaults, state: initialState),
          matchCall('shouldComponentUpdate',     args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState),
        ]));
      });
    });

    group('calls the setState callback, and transactional setState callback in the correct order', () {
      test('when shouldComponentUpdate returns false', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({'shouldUpdate': false}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        _SetStateTest component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);

        // Check against the JS component to ensure no regressions.
        expect(component.lifecycleCalls, orderedEquals(getNonUpdatingSetStateLifeCycleCalls()));
        expect(renderedNode.children.first.text, '1');
      });

      test('when shouldComponentUpdate returns true', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        _SetStateTest component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);

        // Check against the JS component to ensure no regressions.
        expect(component.lifecycleCalls, orderedEquals(getUpdatingSetStateLifeCycleCalls()));
        expect(renderedNode.children.first.text, '3');
      });
    });

    test('throws when setState is called with something other than a Map or Function that accepts two parameters', () {
      var mountNode = new DivElement();
      var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
      _SetStateTest component = getDartComponent(renderedInstance);

      expect(() => component.setState(new Map()), returnsNormally);
      expect(() => component.setState((_, __) { return {}; }), returnsNormally);
      expect(() => component.setState(null), returnsNormally);

      expect(() => component.setState('Not A Valid Parameter'), throwsArgumentError);
      expect(() => component.setState(5), throwsArgumentError);
    });
  });
}

@JS()
external List getUpdatingSetStateLifeCycleCalls();

@JS()
external List getNonUpdatingSetStateLifeCycleCalls();

ReactDartComponentFactoryProxy<_SetStateTest> SetStateTest = react.registerComponent(() => new _SetStateTest()) as ReactDartComponentFactoryProxy<_SetStateTest>;
class _SetStateTest extends react.Component {
  @override
  Map getDefaultProps() => {'shouldUpdate': true};

  @override
  getInitialState() => {"counter": 1};

  @override
  componentWillReceiveProps(_) {
    recordLifecyleCall('componentWillReceiveProps');
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
    lifecycleCalls.add(name);
  }

  render() {
    return react.div({
      'onClick': (_) {
        setState(outerTransactionalSetStateCallback, () { recordLifecyleCall('outerSetStateCallback'); });
      }
    },
      react.div({
        'onClick': (_) {
          setState(innerTransactionalSetStateCallback, () { recordLifecyleCall('innerSetStateCallback'); });
        }
      },
        state['counter']
      )
    );
  }

  List lifecycleCalls = [];
}

class _DefaultPropsCachingTest extends react.Component {
  static int getDefaultPropsCallCount = 0;

  Map getDefaultProps() {
    getDefaultPropsCallCount++;
    return {
      'getDefaultPropsCallCount': getDefaultPropsCallCount
    };
  }

  render() => false;
}

ReactDartComponentFactoryProxy<_DefaultPropsTest> DefaultPropsTest = react.registerComponent(() => new _DefaultPropsTest()) as ReactDartComponentFactoryProxy<_DefaultPropsTest>;
class _DefaultPropsTest extends react.Component {
  static int getDefaultPropsCallCount = 0;

  Map getDefaultProps() => {
    'defaultProp': 'default'
  };

  render() => false;
}

ReactDartComponentFactoryProxy<_LifecycleTest> LifecycleTest = react.registerComponent(() => new _LifecycleTest()) as ReactDartComponentFactoryProxy<_LifecycleTest>;
class _LifecycleTest extends react.Component {
  List lifecycleCalls = [];

  dynamic lifecycleCall(String memberName, {List arguments: const [], defaultReturnValue()}) {
    lifecycleCalls.add({
      'memberName': memberName,
      'arguments': arguments,
      'props': props == null ? null : new Map.from(props),
      'state': state == null ? null : new Map.from(state),
    });

    var lifecycleCallback = props == null ? null : props[memberName];
    if (lifecycleCallback != null) {
      return Function.apply(lifecycleCallback, []
          ..add(this)
          ..addAll(arguments));
    }

    if (defaultReturnValue != null) {
      return defaultReturnValue();
    }

    return null;
  }

  void componentWillMount() => lifecycleCall('componentWillMount');
  void componentDidMount() => lifecycleCall('componentDidMount');
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  void componentWillReceiveProps(newProps) =>
    lifecycleCall('componentWillReceiveProps', arguments: [new Map.from(newProps)]);

  void componentWillUpdate(nextProps, nextState) =>
    lifecycleCall('componentWillUpdate', arguments: [new Map.from(nextProps), new Map.from(nextState)]);

  void componentDidUpdate(prevProps, prevState) =>
    lifecycleCall('componentDidUpdate', arguments: [new Map.from(prevProps), new Map.from(prevState)]);

  bool shouldComponentUpdate(nextProps, nextState) =>
    lifecycleCall('shouldComponentUpdate', arguments: [new Map.from(nextProps), new Map.from(nextState)],
        defaultReturnValue: () => true);

  dynamic render() =>
    lifecycleCall('render', defaultReturnValue: () => react.div({}));

  Map getInitialState() =>
    lifecycleCall('getInitialState', defaultReturnValue: () => {});

  Map getDefaultProps() {
    lifecycleCall('getDefaultProps');

    return {
      'defaultProp': 'default'
    };
  }
}
