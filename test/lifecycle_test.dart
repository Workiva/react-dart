@TestOn('browser')
@JS()
library lifecycle_test;

import 'dart:async';
import 'dart:html';

import "package:js/js.dart";
import 'package:meta/meta.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

import 'lifecycle_test/component.dart' as components;
import 'lifecycle_test/component2.dart' as components2;
import 'lifecycle_test/util.dart';
import 'shared_type_tester.dart';
import 'util.dart';

main() {
  setClientConfiguration();

  group('React component lifecycle:', () {
    setUp(() => LifecycleTestHelper.staticLifecycleCalls = []);
    group('Component', () {
      sharedLifecycleTests(
        skipLegacyContextTests: false,
        defaultPropsCachingTestComponentFactory: components.defaultPropsCachingTestComponentFactory,
        SetStateTest: components.SetStateTest,
        DefaultPropsTest: components.DefaultPropsTest,
        ContextConsumerWrapper: null,
        ContextWrapperWithoutKeys: components.ContextWrapperWithoutKeys,
        ContextWrapper: components.ContextWrapper,
        LifecycleTestWithContext: components.LifecycleTestWithContext,
        LifecycleTest: components.LifecycleTest,
        isComponent2: false,
      );

      test('throws when setState is called with something other than a Map or Function that accepts two parameters',
          () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(components.SetStateTest({}), mountNode);
        LifecycleTestHelper component = getDartComponent(renderedInstance);

        expect(() => component.setState(new Map()), returnsNormally);
        expect(
            () => component.setState((_, __) {
                  return {};
                }),
            returnsNormally);
        expect(() => component.setState(null), returnsNormally);

        expect(() => component.setState('Not A Valid Parameter'), throwsArgumentError);
        expect(() => component.setState(5), throwsArgumentError);
      });

      group('prevents concurrent modification of `_setStateCallbacks`', () {
        LifecycleTestHelper component;
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
          initialProps = unmodifiableMap({'getInitialState': (_) => initialState});
          newState1 = {'foo': 'bar'};
          newState2 = {'baz': 'foobar'};
          expectedState1 = {}..addAll(initialState)..addAll(newState1);
          expectedState2 = {}..addAll(expectedState1)..addAll(newState2);

          component = getDartComponent(render(components.LifecycleTest(initialProps)));
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

        test('when `replaceState` is called from within another `replaceState` callback', () {
          void handleSecondStateUpdate() {
            secondStateUpdateCalls++;
            expect(component.state, newState2);
          }

          void handleFirstStateUpdate() {
            firstStateUpdateCalls++;
            expect(component.state, newState1);
            component.replaceState(newState2, Zone.current.bindCallback(handleSecondStateUpdate));
          }

          component.replaceState(newState1, Zone.current.bindCallback(handleFirstStateUpdate));

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
    });

    group('Component2', () {
      sharedLifecycleTests(
        skipLegacyContextTests: true,
        defaultPropsCachingTestComponentFactory: components2.defaultPropsCachingTestComponentFactory,
        SetStateTest: components2.SetStateTest,
        DefaultPropsTest: components2.DefaultPropsTest,
        ContextWrapperWithoutKeys: null,
        ContextConsumerWrapper: components2.ContextConsumerWrapper,
        ContextWrapper: components2.ContextWrapper,
        LifecycleTestWithContext: components2.LifecycleTestWithContext,
        LifecycleTest: components2.LifecycleTest,
        isComponent2: true,
      );

      test('updates with correct lifecycle calls when `forceUpdate` is called', () {
        const Map initialState = const {
          'initialState': 'initial',
        };

        final Map initialProps = unmodifiableMap({'getInitialState': (_) => initialState});

        final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        LifecycleTestHelper component = getDartComponent(render(components2.LifecycleTest(initialProps)));

        component.lifecycleCalls.clear();

        (component as react.Component2).forceUpdate();

        expect(
            component.lifecycleCalls,
            equals([
              matchCall('render', state: initialState),
              matchCall('getSnapshotBeforeUpdate', args: [expectedProps, initialState], state: initialState),
              matchCall('componentDidUpdate', args: [expectedProps, initialState, null], state: initialState),
            ].where((matcher) => matcher != null).toList()));
      });

      group('componentDidUpdate receives the same value created in getSnapshotBeforeUpdate when snapshot is', () {
        void testSnapshotType(dynamic expectedSnapshot) {
          LifecycleTestHelper component = getDartComponent(
              render(components2.LifecycleTest({'getSnapshotBeforeUpdate': (_, __, ___) => expectedSnapshot})));
          component.lifecycleCalls.clear();
          component.setState({});

          expect(
            component.lifecycleCalls,
            containsAllInOrder([
              matchCall('getSnapshotBeforeUpdate'),
              matchCall('componentDidUpdate', args: [anything, anything, same(expectedSnapshot)])
            ]),
          );
        }

        sharedTypeTests(testSnapshotType);
      });

      test('triggers error lifecycle events when an error is thrown', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(components2.SetStateTest({}), mountNode);
        LifecycleTestHelper component = getDartComponent(renderedInstance);
        LifecycleTestHelper.staticLifecycleCalls.clear();
        component.setState({"shouldThrow": true});

        // First render throws an error, caught by `getDerivedStateFromError`.
        // `getDerivedStateFromError` sets state, starting the update cycle
        // again. `componentDidCatch` also sets the state (storing error
        // information), starting the update cycle again.
        expect(
            component.lifecycleCalls,
            equals([
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'shouldComponentUpdate',
              'render',
              'getSnapshotBeforeUpdate',
              'componentDidUpdate',
              'componentDidCatch',
              'shouldComponentUpdate',
              'render',
              'getSnapshotBeforeUpdate',
              'componentDidUpdate'
            ]));
        expect(component.state["shouldThrow"], isFalse,
            reason: 'applies the state returned by `getDerivedStateFromError`');
      });

      test('can skip methods passed into _registerComponent2', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(components2.SkipMethodsTest({}), mountNode);
        LifecycleTestHelper component = getDartComponent(renderedInstance);
        LifecycleTestHelper.staticLifecycleCalls.clear();
        component.setState({"shouldThrow": true});

        expect(
            component.lifecycleCalls,
            equals([
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'shouldComponentUpdate',
              'render',
              'componentDidUpdate',
              'componentDidCatch',
              'shouldComponentUpdate',
              'render',
              'componentDidUpdate'
            ]));
      });

      test('passes the correct error/info to lifecycle methods when an error is thrown', () {
        int lengthOfKey = 15;
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(components2.SetStateTest({}), mountNode);
        LifecycleTestHelper component = getDartComponent(renderedInstance);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        LifecycleTestHelper.staticLifecycleCalls.clear();
        component.setState({"shouldThrow": true});

        expect(renderedNode.children[1].text.contains(getComponent2ErrorMessage()), isTrue);
        expect(renderedNode.children[2].text.substring(1, lengthOfKey), getComponent2ErrorInfo());
      });

      test('defaults toward not being an error boundary', () {
        var mountNode = new DivElement();

        expect(() {
          var renderedInstance = react_dom.render(components2.DefaultSkipMethodsTest({}), mountNode);
          LifecycleTestHelper component = getDartComponent(renderedInstance);
          Element renderedNode = react_dom.findDOMNode(renderedInstance);
          LifecycleTestHelper.staticLifecycleCalls.clear();
          component.setState({"shouldThrow": true});
        }, throwsA(anything));
      });
    });
  });
}

void sharedLifecycleTests<T extends react.Component>({
  @required bool skipLegacyContextTests,
  // Need this generic to avoid function typing issues caused by using
  // the same factory for Component and Component2:
  // > Expected a value of type '() => Component2<Map<dynamic, dynamic>>', but got one of type '() => DefaultPropsCachingTestHelper'
  @required T Function() defaultPropsCachingTestComponentFactory,
  @required ReactDartComponentFactoryProxy SetStateTest,
  @required ReactDartComponentFactoryProxy DefaultPropsTest,
  @required ReactDartComponentFactoryProxy ContextWrapperWithoutKeys,
  @required ReactDartComponentFactoryProxy ContextConsumerWrapper,
  @required ReactDartComponentFactoryProxy ContextWrapper,
  @required ReactDartComponentFactoryProxy LifecycleTestWithContext,
  @required ReactDartComponentFactoryProxy LifecycleTest,
  @required bool isComponent2,
}) {
  group('(shared behavior)', () {
    group('default props', () {
      test('getDefaultProps() is only called once per component factory and cached', () {
        final staticHelperInstance = defaultPropsCachingTestComponentFactory() as DefaultPropsCachingTestHelper;
        staticHelperInstance.staticGetDefaultPropsCallCount = 0;
        expect(staticHelperInstance.staticGetDefaultPropsCallCount, 0);

        // Need to run registerComponent in this test, which is what calls getDefaultProps.
        ReactDartComponentFactoryProxy DefaultPropsTest =
            react.registerComponent(defaultPropsCachingTestComponentFactory);
        var components = [
          render(DefaultPropsTest({})),
          render(DefaultPropsTest({})),
          render(DefaultPropsTest({})),
        ];

        expect(components.map(getDartComponentProps), everyElement(containsPair('getDefaultPropsCallCount', 1)));
        expect(staticHelperInstance.staticGetDefaultPropsCallCount, 1);
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

    test('receives correct lifecycle calls on component mount', () {
      LifecycleTestHelper component = getDartComponent(render(LifecycleTest({})));
      if (!isComponent2) {
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getInitialState'),
              matchCall('componentWillMount'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      } else {
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getInitialState'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      }
    });

    test('receives correct lifecycle calls on component unmount order', () {
      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest({}), mountNode);
      LifecycleTestHelper component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.unmountComponentAtNode(mountNode);

      expect(
          component.lifecycleCalls,
          equals([
            matchCall('componentWillUnmount'),
          ]));
    });

    if (!isComponent2) {
      test('does not call getChildContext when childContextKeys is empty', () {
        var mountNode = new DivElement();
        var instance =
            react_dom.render(ContextWrapperWithoutKeys({'foo': false}, LifecycleTestWithContext({})), mountNode);
        LifecycleTestHelper component = getDartComponent(instance);

        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getInitialState'),
              matchCall('componentWillMount'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      });

      test('calls getChildContext when childContextKeys exist', () {
        var mountNode = new DivElement();
        var instance = react_dom.render(ContextWrapper({'foo': false}, LifecycleTestWithContext({})), mountNode);
        LifecycleTestHelper component = getDartComponent(instance);

        expect(
            component.lifecycleCalls,
            containsAll([
              matchCall('getChildContext'),
            ]));
      });

      test('receives updated context with correct lifecycle calls', () {
        LifecycleTestHelper component;

        Map initialProps = {'foo': false, 'initialProp': 'initial', 'children': const []};
        Map newProps = {
          'children': const [],
          'foo': true,
          'newProp': 'new',
        };

        final Map initialPropsWithDefaults = unmodifiableMap({}..addAll(defaultProps)..addAll(initialProps));
        final Map newPropsWithDefaults = unmodifiableMap({}..addAll(defaultProps)..addAll(newProps));

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
        react_dom.render(ContextWrapper({'foo': false}, LifecycleTestWithContext(initialPropsWithRef)), mountNode);

        // Verify initial context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getChildContext', props: anything, context: anything),
              matchCall('getInitialState', props: initialPropsWithDefaults, context: initialContext),
              matchCall('componentWillMount', props: initialPropsWithDefaults, context: initialContext),
              matchCall('render', props: initialPropsWithDefaults, context: initialContext),
              matchCall('componentDidMount', props: initialPropsWithDefaults, context: initialContext),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        component.lifecycleCalls.clear();

        // Trigger a re-render with new content
        react_dom.render(ContextWrapper({'foo': true}, LifecycleTestWithContext(newPropsWithRef)), mountNode);

        // Verify updated context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getChildContext', props: anything, context: anything),
              matchCall('componentWillReceiveProps',
                  args: [newPropsWithDefaults], props: initialPropsWithDefaults, context: initialContext),
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
              matchCall('render', props: newPropsWithDefaults, context: expectedContext),
              matchCall('componentDidUpdate',
                  args: [initialPropsWithDefaults, expectedState],
                  props: newPropsWithDefaults,
                  context: expectedContext),
            ]));
      });
    }

    if (isComponent2) {
      test('receives updated context with correct lifecycle calls', () {
        LifecycleTestHelper component;

        const Map expectedState = const {};

        const Map initialContext = const {'foo': false};

        const Map expectedContext = const {'foo': true};

        Map refMap = {
          'ref': ((ref) => component = ref),
        };

        var initialProps = new Map.from(defaultProps)..addAll({'children': const []});
        // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
        var initialPropsWithRef = new Map.from(initialProps)..addAll(refMap);

        // Render the initial instance
        var mountNode = new DivElement();
        react_dom.render(
            ContextWrapper(
              {'foo': false},
              [
                LifecycleTestWithContext(initialPropsWithRef),
              ],
            ),
            mountNode);

        // Verify initial context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getInitialState', props: initialProps, context: initialContext),
              matchCall('render', props: initialProps, context: initialContext),
              matchCall('componentDidMount', props: initialProps, context: initialContext),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        component.lifecycleCalls.clear();

        // Trigger a re-render with new content
        react_dom.render(
            ContextWrapper(
              {'foo': true},
              [
                LifecycleTestWithContext(initialPropsWithRef),
              ],
            ),
            mountNode);

        // Verify updated context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('render', props: initialProps, context: expectedContext),
              matchCall('getSnapshotBeforeUpdate',
                  args: [initialProps, expectedState], props: initialProps, context: expectedContext),
              matchCall('componentDidUpdate',
                  args: [initialProps, expectedState, null], props: initialProps, context: expectedContext),
            ]));
      });

      test('receives updated context with correct lifecycle calls when wrapped with a consumer', () {
        LifecycleTestHelper component;

        const Map expectedState = const {};

        Map initialContext = {'foo': false};

        Map expectedContext = {'foo': true};

        Map refMap = {
          'ref': ((ref) => component = ref),
        };

        var initialProps = new Map.from(defaultProps)..addAll(initialContext)..addAll({'children': const []});
        // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
        var initialPropsWithRef = new Map.from(initialProps)..addAll(refMap);

        var expectedProps = new Map.from(initialProps)..addAll(expectedContext);
        // Render the initial instance
        var mountNode = new DivElement();
        react_dom.render(
            ContextWrapper(
              initialContext,
              [
                ContextConsumerWrapper({}, [
                  (value) {
                    return LifecycleTest(initialPropsWithRef..addAll(value));
                  }
                ]),
              ],
            ),
            mountNode);

        // Verify initial context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('getInitialState', props: initialProps),
              matchCall('render', props: initialProps),
              matchCall('componentDidMount', props: initialProps),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        component.lifecycleCalls.clear();

        // Trigger a re-render with new content3
        react_dom.render(
            ContextWrapper(
              expectedContext,
              [
                ContextConsumerWrapper({}, [
                  (value) {
                    return LifecycleTest(initialPropsWithRef..addAll(value));
                  }
                ]),
              ],
            ),
            mountNode);

        // Verify updated context/setup
        expect(
            component.lifecycleCalls,
            equals([
              matchCall('shouldComponentUpdate', args: [expectedProps, expectedState, null], props: initialProps),
              matchCall('render', props: expectedProps),
              matchCall('getSnapshotBeforeUpdate', args: [initialProps, expectedState], props: expectedProps),
              matchCall('componentDidUpdate', args: [initialProps, expectedState, null], props: expectedProps),
            ]));
      });
    }

    test('receives updated props with correct lifecycle calls and defaults properly merged in', () {
      const Map initialProps = const {'initialProp': 'initial', 'children': const []};
      const Map newProps = const {'newProp': 'new', 'children': const []};

      final Map initialPropsWithDefaults = unmodifiableMap({}..addAll(defaultProps)..addAll(initialProps));
      final Map newPropsWithDefaults = unmodifiableMap({}..addAll(defaultProps)..addAll(newProps));

      const Map expectedState = const {};
      final dynamic expectedContext = isComponent2 ? null : const {};
      const Null expectedSnapshot = null;

      var mountNode = new DivElement();
      var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
      LifecycleTestHelper component = getDartComponent(instance);

      component.lifecycleCalls.clear();

      react_dom.render(LifecycleTest(newProps), mountNode);

      expect(
          component.lifecycleCalls,
          equals([
            !isComponent2
                ? matchCall('componentWillReceiveProps', args: [newPropsWithDefaults], props: initialPropsWithDefaults)
                : null,
            skipLegacyContextTests
                ? null
                : matchCall('componentWillReceivePropsWithContext',
                    args: [newPropsWithDefaults, expectedContext], props: initialPropsWithDefaults),
            skipLegacyContextTests
                ? matchCall('shouldComponentUpdate',
                    args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults)
                : matchCall('shouldComponentUpdateWithContext',
                    args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults),
            !isComponent2
                ? matchCall('componentWillUpdate',
                    args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults)
                : null,
            skipLegacyContextTests
                ? null
                : matchCall('componentWillUpdateWithContext',
                    args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults),
            matchCall('render', props: newPropsWithDefaults),
            isComponent2
                ? matchCall('getSnapshotBeforeUpdate',
                    args: [initialPropsWithDefaults, expectedState], props: newPropsWithDefaults)
                : null,
            isComponent2
                ? matchCall('componentDidUpdate',
                    args: [initialPropsWithDefaults, expectedState, expectedSnapshot], props: newPropsWithDefaults)
                : matchCall('componentDidUpdate',
                    args: [initialPropsWithDefaults, expectedState], props: newPropsWithDefaults),
          ].where((matcher) => matcher != null).toList()));
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

      final Map initialProps = unmodifiableMap({'getInitialState': (_) => initialState});

      final dynamic newContext = isComponent2 ? null : const {};

      final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

      final Null expectedSnapshot = null;

      LifecycleTestHelper component = getDartComponent(render(LifecycleTest(initialProps)));

      component.lifecycleCalls.clear();

      component.setState(stateDelta);

      expect(
          component.lifecycleCalls,
          equals([
            skipLegacyContextTests
                ? matchCall('shouldComponentUpdate', args: [expectedProps, newState, newContext], state: initialState)
                : matchCall('shouldComponentUpdateWithContext',
                    args: [expectedProps, newState, newContext], state: initialState),
            !isComponent2
                ? matchCall('componentWillUpdate', args: [expectedProps, newState], state: initialState)
                : null,
            skipLegacyContextTests
                ? null
                : matchCall('componentWillUpdateWithContext',
                    args: [expectedProps, newState, newContext], state: initialState),
            matchCall('render', state: newState),
            isComponent2
                ? matchCall('getSnapshotBeforeUpdate', args: [expectedProps, initialState], state: newState)
                : null,
            isComponent2
                ? matchCall('componentDidUpdate',
                    args: [expectedProps, initialState, expectedSnapshot], state: newState)
                : matchCall('componentDidUpdate', args: [expectedProps, initialState], state: newState),
          ].where((matcher) => matcher != null)));
    });

    test('updates state with correct lifecycle calls when `redraw` is called', () {
      const Map initialState = const {
        'initialState': 'initial',
      };

      final Map initialProps = unmodifiableMap({'getInitialState': (_) => initialState});

      final dynamic newContext = isComponent2 ? null : const {};

      final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

      final Null expectedSnapshot = null;

      LifecycleTestHelper component = getDartComponent(render(LifecycleTest(initialProps)));

      component.lifecycleCalls.clear();

      component.redraw();

      expect(
          component.lifecycleCalls,
          equals([
            skipLegacyContextTests
                ? matchCall('shouldComponentUpdate',
                    args: [expectedProps, initialState, newContext], state: initialState)
                : matchCall('shouldComponentUpdateWithContext',
                    args: [expectedProps, initialState, newContext], state: initialState),
            !isComponent2
                ? matchCall('componentWillUpdate', args: [expectedProps, initialState], state: initialState)
                : null,
            skipLegacyContextTests
                ? null
                : matchCall('componentWillUpdateWithContext',
                    args: [expectedProps, initialState, newContext], state: initialState),
            matchCall('render', state: initialState),
            isComponent2
                ? matchCall('getSnapshotBeforeUpdate', args: [expectedProps, initialState], state: initialState)
                : null,
            isComponent2
                ? matchCall('componentDidUpdate',
                    args: [expectedProps, initialState, expectedSnapshot], state: initialState)
                : matchCall('componentDidUpdate', args: [expectedProps, initialState], state: initialState),
          ].where((matcher) => matcher != null).toList()));
    });

    group('prevents concurrent modification of `_setStateCallbacks`', () {
      LifecycleTestHelper component;
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
        initialProps = unmodifiableMap({'getInitialState': (_) => initialState});
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

      test('when `setState` is called from within another `setState` callback', () {
        void handleSecondStateUpdate() {
          secondStateUpdateCalls++;
          expect(component.state, expectedState2);
        }

        void handleFirstStateUpdate() {
          firstStateUpdateCalls++;
          expect(component.state, expectedState1);
          component.setState(newState2, Zone.current.bindCallback(handleSecondStateUpdate));
        }

        component.setState(newState1, Zone.current.bindCallback(handleFirstStateUpdate));

        expect(firstStateUpdateCalls, 1);
        expect(secondStateUpdateCalls, 1);

        if (!isComponent2) {
          expect(
              component.lifecycleCalls,
              containsAllInOrder([
                matchCall('componentWillUpdate', args: [anything, expectedState1]),
                matchCall('componentWillUpdate', args: [anything, expectedState2]),
              ]));
        }
      });
    });

    if (!isComponent2) {
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
        const Map expectedContext = const {};

        final Map lifecycleTestProps = unmodifiableMap({
          'getInitialState': (_) => initialState,
          'componentWillReceiveProps': (LifecycleTestHelper component, Map props) {
            component.setState(stateDelta);
          },
        });
        final Map initialProps = unmodifiableMap({'initialProp': 'initial'}, lifecycleTestProps);
        final Map newProps = unmodifiableMap({'newProp': 'new'}, lifecycleTestProps);

        final Map initialPropsWithDefaults = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);
        final Map newPropsWithDefaults = unmodifiableMap(defaultProps, newProps, emptyChildrenProps);

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        LifecycleTestHelper component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        expect(
            component.lifecycleCalls,
            equals([
              matchCall('componentWillReceiveProps',
                  args: [newPropsWithDefaults], props: initialPropsWithDefaults, state: initialState),
              skipLegacyContextTests
                  ? null
                  : matchCall('componentWillReceivePropsWithContext',
                      args: [newPropsWithDefaults, expectedContext],
                      props: initialPropsWithDefaults,
                      state: initialState),
              skipLegacyContextTests
                  ? matchCall('shouldComponentUpdate',
                      args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState)
                  : matchCall('shouldComponentUpdateWithContext',
                      args: [newPropsWithDefaults, newState, expectedContext],
                      props: initialPropsWithDefaults,
                      state: initialState),
              matchCall('componentWillUpdate',
                  args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState),
              skipLegacyContextTests
                  ? null
                  : matchCall('componentWillUpdateWithContext',
                      args: [newPropsWithDefaults, newState, expectedContext],
                      props: initialPropsWithDefaults,
                      state: initialState),
              matchCall('render', props: newPropsWithDefaults, state: newState),
              matchCall('componentDidUpdate',
                  args: [initialPropsWithDefaults, initialState], props: newPropsWithDefaults, state: newState),
            ].where((matcher) => matcher != null).toList()));
      });
    }

    void testShouldUpdates({bool shouldComponentUpdateWithContext, bool shouldComponentUpdate}) {
      test('receives updated props with correct lifecycle calls and does not rerender', () {
        final dynamic expectedContext = isComponent2 ? null : const {};
        final Map initialProps = unmodifiableMap({
          'shouldComponentUpdate':
              isComponent2 ? (_, __, ___, ____) => shouldComponentUpdate : (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) => shouldComponentUpdateWithContext,
          'initialProp': 'initial',
          'children': const []
        });
        const Map newProps = const {'newProp': 'new', 'children': const []};

        final Map initialPropsWithDefaults = unmodifiableMap(defaultProps, initialProps);
        final Map newPropsWithDefaults = unmodifiableMap(defaultProps, newProps);

        const Map expectedState = const {};

        var mountNode = new DivElement();
        var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
        LifecycleTestHelper component = getDartComponent(instance);

        component.lifecycleCalls.clear();

        react_dom.render(LifecycleTest(newProps), mountNode);

        List calls = [
          isComponent2
              ? null
              : matchCall('componentWillReceiveProps', args: [newPropsWithDefaults], props: initialPropsWithDefaults),
          skipLegacyContextTests
              ? null
              : matchCall('componentWillReceivePropsWithContext',
                  args: [newPropsWithDefaults, expectedContext], props: initialPropsWithDefaults),
          isComponent2
              ? matchCall('shouldComponentUpdate',
                  args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults)
              : matchCall('shouldComponentUpdateWithContext',
                  args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults),
        ].where((matcher) => matcher != null).toList();

        if (shouldComponentUpdateWithContext == null && !skipLegacyContextTests) {
          calls.add(
            matchCall('shouldComponentUpdate',
                args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults),
          );
        }

        expect(component.lifecycleCalls, equals(calls));
        expect(component.props, equals(newPropsWithDefaults));
      });

      test('updates state with correct lifecycle calls and does not rerender', () {
        final dynamic expectedContext = isComponent2 ? null : const {};
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
          'shouldComponentUpdate':
              isComponent2 ? (_, __, ___, ____) => shouldComponentUpdate : (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) => shouldComponentUpdateWithContext,
        });

        final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        LifecycleTestHelper component = getDartComponent(render(LifecycleTest(initialProps)));
        component.lifecycleCalls.clear();

        component.setState(stateDelta);

        List calls = [
          isComponent2
              ? matchCall('shouldComponentUpdate',
                  args: [expectedProps, newState, expectedContext], state: initialState)
              : matchCall('shouldComponentUpdateWithContext',
                  args: [expectedProps, newState, expectedContext], state: initialState),
        ];

        if (shouldComponentUpdateWithContext == null && !skipLegacyContextTests) {
          calls.add(
            matchCall('shouldComponentUpdate', args: [expectedProps, newState], state: initialState),
          );
        }

        expect(component.lifecycleCalls, equals(calls));
        expect(component.state, equals(newState));
      });

      if (!isComponent2) {
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
            'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
            'shouldComponentUpdateWithContext': (_, __, ___, ____) => shouldComponentUpdateWithContext,
            'getInitialState': (_) => initialState,
            'componentWillReceiveProps': (LifecycleTestHelper component, Map props) {
              component.setState(stateDelta);
            },
          });
          final Map initialProps = unmodifiableMap({'initialProp': 'initial'}, lifecycleTestProps);
          final Map newProps = unmodifiableMap({'newProp': 'new'}, lifecycleTestProps);

          final Map initialPropsWithDefaults = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);
          final Map newPropsWithDefaults = unmodifiableMap(defaultProps, newProps, emptyChildrenProps);

          final Map expectedContext = const {};

          var mountNode = new DivElement();
          var instance = react_dom.render(LifecycleTest(initialProps), mountNode);
          LifecycleTestHelper component = getDartComponent(instance);

          component.lifecycleCalls.clear();

          react_dom.render(LifecycleTest(newProps), mountNode);

          List calls = [
            matchCall('componentWillReceiveProps',
                args: [newPropsWithDefaults], props: initialPropsWithDefaults, state: initialState),
            skipLegacyContextTests
                ? null
                : matchCall('componentWillReceivePropsWithContext',
                    args: [newPropsWithDefaults, expectedContext],
                    props: initialPropsWithDefaults,
                    state: initialState),
            skipLegacyContextTests
                ? null
                : matchCall('shouldComponentUpdateWithContext',
                    args: [newPropsWithDefaults, newState, expectedContext],
                    props: initialPropsWithDefaults,
                    state: initialState),
          ].where((matcher) => matcher != null).toList();

          if (shouldComponentUpdateWithContext == null) {
            calls.add(
              matchCall('shouldComponentUpdate',
                  args: [newPropsWithDefaults, newState], props: initialPropsWithDefaults, state: initialState),
            );
          }

          expect(component.lifecycleCalls, equals(calls));
        });
      }
    }

    group('when shouldComponentUpdate returns false:', () {
      testShouldUpdates(shouldComponentUpdateWithContext: null, shouldComponentUpdate: false);
    });

    if (!skipLegacyContextTests) {
      group('when shouldComponentUpdateWithContext returns false:', () {
        testShouldUpdates(shouldComponentUpdateWithContext: false, shouldComponentUpdate: false);
      });
    }

    test('calling setState does not update the component when the value passed is null', () {
      var mountNode = new DivElement();
      var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
      LifecycleTestHelper component = getDartComponent(renderedInstance);
      component.lifecycleCalls.clear();

      component.callSetStateWithNullValue();

      expect(component.lifecycleCalls, isEmpty);
    });

    group('calls the setState callback, and transactional setState callback in the correct order', () {
      test('when shouldComponentUpdate returns false', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({'shouldUpdate': false}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        LifecycleTestHelper component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);
        // todo directly assert state change occured to aid in test debugging

        // Check against the JS component to ensure no regressions.
        expect(component.state['counter'], 3);
        if (isComponent2) {
          expect(component.lifecycleCalls, orderedEquals(getComponent2NonUpdatingSetStateLifeCycleCalls()));
          expect(component.state['counter'], getComponent2LatestJSCounter());
          expect(renderedNode.children.first.text, getComponent2NonUpdatingRenderedCounter());
        } else {
          expect(component.lifecycleCalls, orderedEquals(getNonUpdatingSetStateLifeCycleCalls()));
          expect(component.state['counter'], getLatestJSCounter());
          expect(renderedNode.children.first.text, getNonUpdatingRenderedCounter());
        }
        expect(renderedNode.children.first.text, '1');
      });

      test('when shouldComponentUpdate returns true', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        LifecycleTestHelper component = getDartComponent(renderedInstance);

        react_test_utils.Simulate.click(renderedNode.children.first);
        // todo directly assert state change occured to aid in test debugging

        // Check against the JS component to ensure no regressions.
        expect(component.state['counter'], 3);

        if (isComponent2) {
          expect(component.lifecycleCalls, orderedEquals(getComponent2UpdatingSetStateLifeCycleCalls()));
          expect(component.state['counter'], getComponent2LatestJSCounter());
          expect(renderedNode.children.first.text, getComponent2UpdatingRenderedCounter());
        } else {
          expect(component.lifecycleCalls, orderedEquals(getUpdatingSetStateLifeCycleCalls()));
          expect(component.state['counter'], getLatestJSCounter());
          expect(renderedNode.children.first.text, getUpdatingRenderedCounter());
        }
        expect(renderedNode.children.first.text, '3');
      });
    });
  });
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
