@TestOn('browser')
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
    return dartComponent.dartComponent;
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
      test(
          'getDefaultProps() is only called once per component class and cached',
          () {
        expect(_DefaultPropsCachingTest.getDefaultPropsCallCount, 0);

        var DefaultPropsComponent =
            react.registerComponent(() => new _DefaultPropsCachingTest());
        var components = [
          render(DefaultPropsComponent({})),
          render(DefaultPropsComponent({})),
          render(DefaultPropsComponent({})),
        ];

        expect(components.map(getDartComponentProps),
            everyElement(containsPair('getDefaultPropsCallCount', 1)));
        expect(_DefaultPropsCachingTest.getDefaultPropsCallCount, 1);
      });

      group('are merged into props when the ReactElement is created when', () {
        test('the specified props are empty', () {
          var props = getDartElementProps(DefaultPropsTest({}));
          expect(props, containsPair('defaultProp', 'default'));
        });

        test('the default props are overridden', () {
          var props = getDartElementProps(
              DefaultPropsTest({'defaultProp': 'overridden'}));
          expect(props, containsPair('defaultProp', 'overridden'));
        });

        test('non-default props are added', () {
          var props =
              getDartElementProps(DefaultPropsTest({'otherProp': 'other'}));
          expect(props, containsPair('defaultProp', 'default'));
          expect(props, containsPair('otherProp', 'other'));
        });
      });

      group(
          'are merged into props by the time the Dart Component is rendered when',
          () {
        test('the specified props are empty', () {
          var props = getDartComponentProps(render(DefaultPropsTest({})));
          expect(props, containsPair('defaultProp', 'default'));
        });

        test('the default props are overridden', () {
          var props = getDartComponentProps(
              render(DefaultPropsTest({'defaultProp': 'overridden'})));
          expect(props, containsPair('defaultProp', 'overridden'));
        });

        test('non-default props are added', () {
          var props = getDartComponentProps(
              render(DefaultPropsTest({'otherProp': 'other'})));
          expect(props, containsPair('defaultProp', 'default'));
          expect(props, containsPair('otherProp', 'other'));
        });
      });
    });
  });

  group('React component lifecycle:', () {
    const Map defaultProps = const {'defaultProp': 'default'};
    const Map emptyChildrenProps = const {'children': const []};

    Map matchCall(String memberName,
        {args: anything, props: anything, state: anything, context: anything}) {
      return {
        'memberName': memberName,
        'arguments': args,
        'props': props,
        'state': state,
        'context': context,
      };
    }

    test('receives correct lifecycle calls on component mount', () {
      _LifecycleTest component = getDartComponent(render(LifecycleTest({})));

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('getInitialState'),
            matchCall('componentWillMount'),
            matchCall('render'),
            matchCall('componentDidMount'),
          ]));
    });

    test('receives correct lifecycle calls on component unmount order', () {
      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest({}), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.unmountComponentAtNode(mountNode);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('componentWillUnmount'),
          ]));
    });

    test('does not call getChildContext when childContextKeys is empty', () {
      var mountNode = new DivElement();
      var instance = react_dom.render(
          ContextWrapperWithoutKeys(
              {'foo': false}, LifecycleTestWithContext({})),
          mountNode);
      _ContextWrapperWithoutKeys component = getDartComponent(instance);

      expect(component.lifecycleCalls, isEmpty);
    });

    test('calls getChildContext when childContextKeys exist', () {
      var mountNode = new DivElement();
      var instance = react_dom.render(
          ContextWrapper({'foo': false}, LifecycleTestWithContext({})),
          mountNode);
      _ContextWrapper component = getDartComponent(instance);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('getChildContext'),
          ]));
    });

    test('receives updated context with correct lifecycle calls', () {
      _LifecycleTestWithContext component;

      Map initialProps = {
        'foo': false,
        'initialProp': 'initial',
        'children': const []
      };
      Map newProps = {
        'children': const [],
        'foo': true,
        'newProp': 'new',
      };

      final Map initialPropsWithDefaults =
          unmodifiableMap({}..addAll(defaultProps)..addAll(initialProps));
      final Map newPropsWithDefaults =
          unmodifiableMap({}..addAll(defaultProps)..addAll(newProps));

      const Map expectedState = const {};

      const Map initialContext = const {'foo': false};

      const Map expectedContext = const {'foo': true};

      Map refMap = {
        'ref': ((ref) => component = ref),
      };

      // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
      var initialPropsWithRef = new Map.from(initialProps)..addAll(refMap);
      var newPropsWithRef = new Map.from(newPropsWithDefaults)..addAll(refMap);

      // Render the initial instance
      var mountNode = new DivElement();
      react_dom.render(
          ContextWrapper(
              {'foo': false}, LifecycleTestWithContext(initialPropsWithRef)),
          mountNode);

      // Verify initial context/setup
      expect(
          component.lifecycleCalls,
          equals([
            matchCall('getInitialState',
                props: initialPropsWithDefaults, context: initialContext),
            matchCall('componentWillMount',
                props: initialPropsWithDefaults, context: initialContext),
            matchCall('render',
                props: initialPropsWithDefaults, context: initialContext),
            matchCall('componentDidMount',
                props: initialPropsWithDefaults, context: initialContext),
          ]));

      // Clear the lifecycle calls for to not duplicate the initial calls below
      component.lifecycleCalls.clear();

      // Trigger a re-render with new content
      react_dom.render(
          ContextWrapper(
              {'foo': true}, LifecycleTestWithContext(newPropsWithRef)),
          mountNode);

      // Verify updated context/setup
      expect(
          component.lifecycleCalls,
          equals([
            matchCall('componentWillReceiveProps',
                args: [newPropsWithDefaults],
                props: initialPropsWithDefaults,
                context: initialContext),
            matchCall('componentWillReceivePropsWithContext',
                args: [newPropsWithDefaults, expectedContext],
                props: initialPropsWithDefaults,
                context: initialContext),
            matchCall('shouldComponentUpdateWithContext',
                args: [newPropsWithDefaults, expectedState, expectedContext],
                props: initialPropsWithDefaults,
                context: initialContext),
            matchCall('componentWillUpdate',
                args: [newPropsWithDefaults, expectedState],
                props: initialPropsWithDefaults,
                context: initialContext),
            matchCall('componentWillUpdateWithContext',
                args: [newPropsWithDefaults, expectedState, expectedContext],
                props: initialPropsWithDefaults,
                context: initialContext),
            matchCall('render',
                props: newPropsWithDefaults, context: expectedContext),
            matchCall('componentDidUpdate',
                args: [initialPropsWithDefaults, expectedState],
                props: newPropsWithDefaults,
                context: expectedContext),
          ]));
    });

    test(
        'receives updated props with correct lifecycle calls and defaults properly merged in',
        () {
      const Map initialProps = const {
        'initialProp': 'initial',
        'children': const []
      };
      const Map newProps = const {'newProp': 'new', 'children': const []};

      final Map initialPropsWithDefaults =
          unmodifiableMap({}..addAll(defaultProps)..addAll(initialProps));
      final Map newPropsWithDefaults =
          unmodifiableMap({}..addAll(defaultProps)..addAll(newProps));

      const Map expectedState = const {};
      const Map expectedContext = const {};

      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.render(LifecycleTest(newProps), mountNode);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('componentWillReceiveProps',
                args: [newPropsWithDefaults], props: initialPropsWithDefaults),
            matchCall('componentWillReceivePropsWithContext',
                args: [newPropsWithDefaults, expectedContext],
                props: initialPropsWithDefaults),
            matchCall('shouldComponentUpdateWithContext',
                args: [newPropsWithDefaults, expectedState, expectedContext],
                props: initialPropsWithDefaults),
            matchCall('componentWillUpdate',
                args: [newPropsWithDefaults, expectedState],
                props: initialPropsWithDefaults),
            matchCall('componentWillUpdateWithContext',
                args: [newPropsWithDefaults, expectedState, expectedContext],
                props: initialPropsWithDefaults),
            matchCall('render', props: newPropsWithDefaults),
            matchCall('componentDidUpdate',
                args: [initialPropsWithDefaults, expectedState],
                props: newPropsWithDefaults),
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

      final Map initialProps =
          unmodifiableMap({'getInitialState': (_) => initialState});

      final Map newContext = const {};

      final Map expectedProps =
          unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

      _LifecycleTest component =
          getDartComponent(render(LifecycleTest(initialProps)));

      component.lifecycleCalls.clear();

      component.setState(stateDelta);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('shouldComponentUpdateWithContext',
                args: [expectedProps, newState, newContext],
                state: initialState),
            matchCall('componentWillUpdate',
                args: [expectedProps, newState], state: initialState),
            matchCall('componentWillUpdateWithContext',
                args: [expectedProps, newState, newContext],
                state: initialState),
            matchCall('render', state: newState),
            matchCall('componentDidUpdate',
                args: [expectedProps, initialState], state: newState),
          ]));
    });

    test('updates state with correct lifecycle calls when `redraw` is called',
        () {
      const Map initialState = const {
        'initialState': 'initial',
      };

      final Map initialProps =
          unmodifiableMap({'getInitialState': (_) => initialState});

      final Map newContext = const {};

      final Map expectedProps =
          unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

      _LifecycleTest component =
          getDartComponent(render(LifecycleTest(initialProps)));

      component.lifecycleCalls.clear();

      component.redraw();

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('shouldComponentUpdateWithContext',
                args: [expectedProps, initialState, newContext],
                state: initialState),
            matchCall('componentWillUpdate',
                args: [expectedProps, initialState], state: initialState),
            matchCall('componentWillUpdateWithContext',
                args: [expectedProps, initialState, newContext],
                state: initialState),
            matchCall('render', state: initialState),
            matchCall('componentDidUpdate',
                args: [expectedProps, initialState], state: initialState),
          ]));
    });

    group('prevents concurrent modification of `_setStateCallbacks`', () {
      _LifecycleTest component;
      const Map initialState = const {
        'initialState': 'initial',
      };
      int firstStateUpdateCalls;
      int secondStateUpdateCalls;
      Map initialProps;
      Map newState1;
      Map expectedState1;
      Map newState2;
      Map expectedState2;

      setUp(() {
        firstStateUpdateCalls = 0;
        secondStateUpdateCalls = 0;
        initialProps =
            unmodifiableMap({'getInitialState': (_) => initialState});
        newState1 = {'foo': 'bar'};
        newState2 = {'baz': 'foobar'};
        expectedState1 = {}..addAll(initialState)..addAll(newState1);
        expectedState2 = {}..addAll(expectedState1)..addAll(newState2);

        component = getDartComponent(render(LifecycleTest(initialProps)));
        component.lifecycleCalls.clear();
      });

      tearDown(() {
        component?.lifecycleCalls?.clear();
        component = null;
        initialProps = null;
        newState1 = null;
        expectedState1 = null;
        newState2 = null;
        expectedState2 = null;
      });

      test('when `setState` is called from within another `setState` callback',
          () {
        void handleSecondStateUpdate() {
          secondStateUpdateCalls++;
          expect(component.state, expectedState2);
        }

        void handleFirstStateUpdate() {
          firstStateUpdateCalls++;
          expect(component.state, expectedState1);
          component.setState(newState2, handleSecondStateUpdate);
        }

        component.setState(newState1, handleFirstStateUpdate);

        expect(firstStateUpdateCalls, 1);
        expect(secondStateUpdateCalls, 1);

        expect(
            component.lifecycleCalls,
            containsAllInOrder([
              matchCall('componentWillUpdate',
                  args: [anything, expectedState1]),
              matchCall('componentWillUpdate',
                  args: [anything, expectedState2]),
            ]));
      });

      test(
          'when `replaceState` is called from within another `replaceState` callback',
          () {
        void handleSecondStateUpdate() {
          secondStateUpdateCalls++;
          expect(component.state, newState2);
        }

        void handleFirstStateUpdate() {
          firstStateUpdateCalls++;
          expect(component.state, newState1);
          component.replaceState(newState2, handleSecondStateUpdate);
        }

        component.replaceState(newState1, handleFirstStateUpdate);

        expect(firstStateUpdateCalls, 1);
        expect(secondStateUpdateCalls, 1);

        expect(
            component.lifecycleCalls,
            containsAllInOrder([
              matchCall('componentWillUpdate', args: [anything, newState1]),
              matchCall('componentWillUpdate', args: [anything, newState2]),
            ]));
      });
    });

    test('properly handles a call to setState within componentWillReceiveProps',
        () {
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
      const Map expectedContext = const {};

      final Map lifecycleTestProps = unmodifiableMap({
        'getInitialState': (_) => initialState,
        'componentWillReceiveProps': (_LifecycleTest component, Map props) {
          component.setState(stateDelta);
        },
      });
      final Map initialProps =
          unmodifiableMap({'initialProp': 'initial'}, lifecycleTestProps);
      final Map newProps =
          unmodifiableMap({'newProp': 'new'}, lifecycleTestProps);

      final Map initialPropsWithDefaults =
          unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);
      final Map newPropsWithDefaults =
          unmodifiableMap(defaultProps, newProps, emptyChildrenProps);

      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
      _LifecycleTest component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.render(LifecycleTest(newProps), mountNode);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('componentWillReceiveProps',
                args: [newPropsWithDefaults],
                props: initialPropsWithDefaults,
                state: initialState),
            matchCall('componentWillReceivePropsWithContext',
                args: [newPropsWithDefaults, expectedContext],
                props: initialPropsWithDefaults,
                state: initialState),
            matchCall('shouldComponentUpdateWithContext',
                args: [newPropsWithDefaults, newState, expectedContext],
                props: initialPropsWithDefaults,
                state: initialState),
            matchCall('componentWillUpdate',
                args: [newPropsWithDefaults, newState],
                props: initialPropsWithDefaults,
                state: initialState),
            matchCall('componentWillUpdateWithContext',
                args: [newPropsWithDefaults, newState, expectedContext],
                props: initialPropsWithDefaults,
                state: initialState),
            matchCall('render', props: newPropsWithDefaults, state: newState),
            matchCall('componentDidUpdate',
                args: [initialPropsWithDefaults, initialState],
                props: newPropsWithDefaults,
                state: newState),
          ]));
    });

    void testShouldUpdates(
        {bool shouldComponentUpdateWithContext, bool shouldComponentUpdate}) {
      test(
          'receives updated props with correct lifecycle calls and does not rerender',
          () {
        final Map expectedContext = const {};
        final Map initialProps = unmodifiableMap({
          'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) =>
              shouldComponentUpdateWithContext,
          'initialProp': 'initial',
          'children': const []
        });
        const Map newProps = const {'newProp': 'new', 'children': const []};

        final Map initialPropsWithDefaults =
            unmodifiableMap(defaultProps, initialProps);
        final Map newPropsWithDefaults =
            unmodifiableMap(defaultProps, newProps);

        const Map expectedState = const {};

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        _LifecycleTest component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        List calls = [
          matchCall('componentWillReceiveProps',
              args: [newPropsWithDefaults], props: initialPropsWithDefaults),
          matchCall('componentWillReceivePropsWithContext',
              args: [newPropsWithDefaults, expectedContext],
              props: initialPropsWithDefaults),
          matchCall('shouldComponentUpdateWithContext',
              args: [newPropsWithDefaults, expectedState, expectedContext],
              props: initialPropsWithDefaults),
        ];

        if (shouldComponentUpdateWithContext == null) {
          calls.add(
            matchCall('shouldComponentUpdate',
                args: [newPropsWithDefaults, expectedState],
                props: initialPropsWithDefaults),
          );
        }

        expect(component.lifecycleCalls, equals(calls));
        expect(component.props, equals(newPropsWithDefaults));
      });

      test('updates state with correct lifecycle calls and does not rerender',
          () {
        const Map expectedContext = const {};
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
          'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) =>
              shouldComponentUpdateWithContext,
        });

        final Map expectedProps =
            unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        _LifecycleTest component =
            getDartComponent(render(LifecycleTest(initialProps)));
        component.lifecycleCalls.clear();

        component.setState(stateDelta);

        List calls = [
          matchCall('shouldComponentUpdateWithContext',
              args: [expectedProps, newState, expectedContext],
              state: initialState),
        ];

        if (shouldComponentUpdateWithContext == null) {
          calls.add(
            matchCall('shouldComponentUpdate',
                args: [expectedProps, newState], state: initialState),
          );
        }

        expect(component.lifecycleCalls, equals(calls));
        expect(component.state, equals(newState));
      });

      test(
          'properly handles a call to setState within componentWillReceiveProps and does not rerender',
          () {
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
          'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) =>
              shouldComponentUpdateWithContext,
          'getInitialState': (_) => initialState,
          'componentWillReceiveProps': (_LifecycleTest component, Map props) {
            component.setState(stateDelta);
          },
        });
        final Map initialProps =
            unmodifiableMap({'initialProp': 'initial'}, lifecycleTestProps);
        final Map newProps =
            unmodifiableMap({'newProp': 'new'}, lifecycleTestProps);

        final Map initialPropsWithDefaults =
            unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);
        final Map newPropsWithDefaults =
            unmodifiableMap(defaultProps, newProps, emptyChildrenProps);

        final Map expectedContext = const {};

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        _LifecycleTest component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        List calls = [
          matchCall('componentWillReceiveProps',
              args: [newPropsWithDefaults],
              props: initialPropsWithDefaults,
              state: initialState),
          matchCall('componentWillReceivePropsWithContext',
              args: [newPropsWithDefaults, expectedContext],
              props: initialPropsWithDefaults,
              state: initialState),
          matchCall('shouldComponentUpdateWithContext',
              args: [newPropsWithDefaults, newState, expectedContext],
              props: initialPropsWithDefaults,
              state: initialState),
        ];

        if (shouldComponentUpdateWithContext == null) {
          calls.add(
            matchCall('shouldComponentUpdate',
                args: [newPropsWithDefaults, newState],
                props: initialPropsWithDefaults,
                state: initialState),
          );
        }

        expect(component.lifecycleCalls, equals(calls));
      });
    }

    group('when shouldComponentUpdate returns false:', () {
      testShouldUpdates(
          shouldComponentUpdateWithContext: null, shouldComponentUpdate: false);
    });

    group('when shouldComponentUpdateWithContext returns false:', () {
      testShouldUpdates(
          shouldComponentUpdateWithContext: false,
          shouldComponentUpdate: false);
    });

    group(
        'calls the setState callback, and transactional setState callback in the correct order',
        () {
      test('when shouldComponentUpdate returns false', () {
        var mountNode = new DivElement();
        var renderedInstance =
            react_dom.render(SetStateTest({'shouldUpdate': false}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        _SetStateTest component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);

        // Check against the JS component to ensure no regressions.
        expect(component.lifecycleCalls,
            orderedEquals(getNonUpdatingSetStateLifeCycleCalls()));
        expect(renderedNode.children.first.text, '1');
      });

      test('when shouldComponentUpdate returns true', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        _SetStateTest component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);

        // Check against the JS component to ensure no regressions.
        expect(component.lifecycleCalls,
            orderedEquals(getUpdatingSetStateLifeCycleCalls()));
        expect(renderedNode.children.first.text, '3');
      });
    });

    test(
        'throws when setState is called with something other than a Map or Function that accepts two parameters',
        () {
      var mountNode = new DivElement();
      var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
      _SetStateTest component = getDartComponent(renderedInstance);

      expect(() => component.setState(new Map()), returnsNormally);
      expect(
          () => component.setState((_, __) {
                return {};
              }),
          returnsNormally);
      expect(() => component.setState(null), returnsNormally);

      expect(() => component.setState('Not A Valid Parameter'),
          throwsArgumentError);
      expect(() => component.setState(5), throwsArgumentError);
    });
  });
}

@JS()
external List getUpdatingSetStateLifeCycleCalls();

@JS()
external List getNonUpdatingSetStateLifeCycleCalls();

/// A test helper to record lifecycle calls
abstract class LifecycleTestHelper {
  Map context;
  Map props;
  Map state;

  List lifecycleCalls = [];

  dynamic lifecycleCall(String memberName,
      {List arguments: const [], defaultReturnValue()}) {
    lifecycleCalls.add({
      'memberName': memberName,
      'arguments': arguments,
      'props': props == null ? null : new Map.from(props),
      'state': state == null ? null : new Map.from(state),
      'context': new Map.from(context ?? const {}),
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
}

ReactDartComponentFactoryProxy SetStateTest =
    react.registerComponent(() => new _SetStateTest());

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
    lifecycleCalls.add(name);
  }

  render() {
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
        }, state['counter']));
  }

  List lifecycleCalls = [];
}

class _DefaultPropsCachingTest extends react.Component {
  static int getDefaultPropsCallCount = 0;

  Map getDefaultProps() {
    getDefaultPropsCallCount++;
    return {'getDefaultPropsCallCount': getDefaultPropsCallCount};
  }

  render() => false;
}

ReactDartComponentFactoryProxy DefaultPropsTest =
    react.registerComponent(() => new _DefaultPropsTest());

class _DefaultPropsTest extends react.Component {
  static int getDefaultPropsCallCount = 0;

  Map getDefaultProps() => {'defaultProp': 'default'};

  render() => false;
}

ReactDartComponentFactoryProxy ContextWrapperWithoutKeys =
    react.registerComponent(() => new _ContextWrapperWithoutKeys());

class _ContextWrapperWithoutKeys extends react.Component
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

ReactDartComponentFactoryProxy ContextWrapper =
    react.registerComponent(() => new _ContextWrapper());

class _ContextWrapper extends react.Component with LifecycleTestHelper {
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

ReactDartComponentFactoryProxy LifecycleTestWithContext =
    react.registerComponent(() => new _LifecycleTestWithContext());

class _LifecycleTestWithContext extends _LifecycleTest {
  @override
  Iterable<String> get contextKeys =>
      const ['foo']; // only listening to one context key
}

ReactDartComponentFactoryProxy LifecycleTest =
    react.registerComponent(() => new _LifecycleTest());

class _LifecycleTest extends react.Component with LifecycleTestHelper {
  void componentWillMount() => lifecycleCall('componentWillMount');
  void componentDidMount() => lifecycleCall('componentDidMount');
  void componentWillUnmount() => lifecycleCall('componentWillUnmount');

  void componentWillReceiveProps(newProps) =>
      lifecycleCall('componentWillReceiveProps',
          arguments: [new Map.from(newProps)]);

  void componentWillReceivePropsWithContext(newProps, newContext) =>
      lifecycleCall('componentWillReceivePropsWithContext',
          arguments: [new Map.from(newProps), new Map.from(newContext)]);

  void componentWillUpdate(nextProps, nextState) =>
      lifecycleCall('componentWillUpdate',
          arguments: [new Map.from(nextProps), new Map.from(nextState)]);

  void componentWillUpdateWithContext(nextProps, nextState, nextContext) =>
      lifecycleCall('componentWillUpdateWithContext', arguments: [
        new Map.from(nextProps),
        new Map.from(nextState),
        new Map.from(nextContext)
      ]);

  void componentDidUpdate(prevProps, prevState) =>
      lifecycleCall('componentDidUpdate',
          arguments: [new Map.from(prevProps), new Map.from(prevState)]);

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
