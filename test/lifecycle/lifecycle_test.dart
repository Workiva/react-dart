// ignore_for_file: deprecated_member_use_from_same_package
@TestOn('browser')

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:meta/meta.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart' as react_interop;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/react_test_utils/internal_test_utils.dart';
import 'package:react_testing_library/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import 'component.dart' as components;
import 'component2.dart' as components2;
import 'util.dart';
import '../shared_type_tester.dart';
import '../fixtures/util.dart';

final _act = react_dom.ReactTestUtils.act;

main() {
  group('React Component lifecycle:', () {
    setUp(() => LifecycleTestHelper.staticLifecycleCalls = []);
    group('Component', () {
      react_dom.ReactRoot root;

      tearDownAll(() {
        root?.unmount();
      });

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
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components.SetStateTest({'ref': componentRef})));
        final component = componentRef.current;

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
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();

        const Map initialState = const {
          'initialState': 'initial',
        };
        int firstStateUpdateCalls;
        int secondStateUpdateCalls;
        Map initialProps;
        Map newState1;
        Map newState2;

        setUp(() {
          firstStateUpdateCalls = 0;
          secondStateUpdateCalls = 0;
          initialProps = unmodifiableMap({'getInitialState': (_) => initialState, 'ref': componentRef});
          newState1 = {'foo': 'bar'};
          newState2 = {'baz': 'foobar'};

          _act(() => root.render(components.LifecycleTest(initialProps)));
          componentRef.current.lifecycleCalls.clear();
        });

        tearDown(() {
          componentRef.current?.lifecycleCalls?.clear();
          componentRef.current = null;
          initialProps = null;
          newState1 = null;
          newState2 = null;
        });

        test('when `replaceState` is called from within another `replaceState` callback', () {
          void handleSecondStateUpdate() {
            secondStateUpdateCalls++;
            expect(componentRef.current.state, newState2);
          }

          void handleFirstStateUpdate() {
            firstStateUpdateCalls++;
            expect(componentRef.current.state, newState1);
            _act(
                () => componentRef.current.replaceState(newState2, Zone.current.bindCallback(handleSecondStateUpdate)));
          }

          _act(() => componentRef.current.replaceState(newState1, Zone.current.bindCallback(handleFirstStateUpdate)));

          expect(firstStateUpdateCalls, 1);
          expect(secondStateUpdateCalls, 1);

          expect(
              componentRef.current.lifecycleCalls,
              containsAllInOrder([
                matchCall('componentWillUpdate', args: [anything, newState1]),
                matchCall('componentWillUpdate', args: [anything, newState2]),
              ]));
        });
      });
    });

    group('Component2', () {
      react_dom.ReactRoot root;

      tearDownAll(() {
        root?.unmount();
      });

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

      group('propTypes', () {
        bool consoleErrorCalled;
        String consoleErrorMessage;
        JsFunction originalConsoleError;
        DivElement mountNode;
        react_dom.ReactRoot root;
        final String expectedWarningPrefix = 'Warning: Failed prop type: Invalid argument(s): intProp should be int. ';

        setUp(() {
          consoleErrorCalled = false;
          consoleErrorMessage = null;
          mountNode = new DivElement();
          root = react_dom.createRoot(mountNode);
          react_interop.PropTypes.resetWarningCache();
          originalConsoleError = context['console']['error'];
          context['console']['error'] = new JsFunction.withThis((self, message) {
            consoleErrorCalled = true;
            consoleErrorMessage = message;

            originalConsoleError.apply([message], thisArg: self);
          });
        });

        tearDown(() {
          context['console']['error'] = originalConsoleError;
        });

        tearDownAll(() {
          root.unmount();
        });

        group('fails validation with incorrect prop type', () {
          setUp(() {
            _act(() => root.render(components2.PropTypesTest({'intProp': 'test'})));
          });

          if (assertsEnabled()) {
            test('', () {
              expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
              expect(consoleErrorMessage, contains(expectedWarningPrefix));
            });
          } else {
            test('unless dart2js compiler is used', () {
              expect(consoleErrorCalled, isFalse,
                  reason: 'propTypes should only be present when using DDC to compile JS');
            });
          }
        });

        if (assertsEnabled()) {
          test('passes validation with correct prop type', () {
            _act(() => root.render(components2.PropTypesTest({'intProp': 1})));
            expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
          });

          test('passes through all of the expected arguments to the prop validator', () {
            _act(() => root.render(components2.PropTypesTest({'intProp': 'test'})));
            expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
            expect(
              consoleErrorMessage,
              contains(expectedWarningPrefix),
              reason: 'Did the warning message change? This test will break if the format cannot be converted to json.',
            );
            RegExp regExp = new RegExp(r'.*?({.*}).*', multiLine: true);
            var matches = regExp.allMatches(consoleErrorMessage);
            expect(matches, hasLength(1), reason: 'Should have found a json structure in the error.');
            var match = matches.elementAt(0); // => extract the first (and only) match
            Map errorArgs = json.decode(match.group(1));
            expect(errorArgs, {
              'props': '{intProp: test, children: []}',
              'propName': 'intProp',
              'componentName': 'PropTypesTestComponent',
              'location': 'prop',
              'propFullName': 'null',
            });
          });
        }
      });

      test('updates with correct lifecycle calls when `forceUpdate` is called', () {
        const Map initialState = const {
          'initialState': 'initial',
        };

        final Map initialProps =
            unmodifiableMap({'getInitialState': (_) => initialState, 'initialState': (_) => initialState});

        final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        final componentRef = react.createRef<LifecycleTestHelper>();
        rtl.render(components2.LifecycleTest({...initialProps, 'ref': componentRef}));

        componentRef.current.lifecycleCalls.clear();

        react_dom.ReactTestUtils.act(() => (componentRef.current as react.Component2).forceUpdate());

        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('getDerivedStateFromProps'),
              matchCall('render', state: initialState),
              matchCall('getSnapshotBeforeUpdate', args: [expectedProps, initialState], state: initialState),
              matchCall('componentDidUpdate', args: [expectedProps, initialState, null], state: initialState),
            ].where((matcher) => matcher != null).toList()));
      });

      group('componentDidUpdate receives the same value created in getSnapshotBeforeUpdate when snapshot is', () {
        void testSnapshotType(dynamic expectedSnapshot) {
          final componentRef = react.createRef<LifecycleTestHelper>();
          rtl.render(components2.LifecycleTest({
            'getSnapshotBeforeUpdate': (_, __, ___) => expectedSnapshot,
            'ref': componentRef,
          }));
          componentRef.current.lifecycleCalls.clear();
          react_dom.ReactTestUtils.act(() => componentRef.current.setState({}));

          expect(
            componentRef.current.lifecycleCalls,
            containsAllInOrder([
              matchCall('getSnapshotBeforeUpdate'),
              matchCall('componentDidUpdate', args: [anything, anything, same(expectedSnapshot)])
            ]),
          );
        }

        sharedTypeTests(testSnapshotType);
      });

      group('getDerivedStateFromProps returns', () {
        Ref<LifecycleTestHelper> componentRef;
        react_dom.ReactRoot root;

        setUp(() {
          componentRef = react.createRef<LifecycleTestHelper>();
          root = react_dom.createRoot(DivElement());
        });

        tearDown(() {
          root.unmount();
        });

        test('derived state, resulting in an updated instance state value', () {
          const Map initialDerivedState = const {
            'initialDerivedState': 'initial',
          };

          const Map updatedDerivedState = const {
            'initialDerivedState': 'updated',
          };

          final Map initialProps = unmodifiableMap({
            'getDerivedStateFromProps': (_, __, ___) => initialDerivedState,
            'defaultProp': 'default',
            'children': []
          });

          final Map updatedProps = unmodifiableMap({
            'getDerivedStateFromProps': (_, __, ___) => updatedDerivedState,
            'defaultProp': 'default',
            'children': []
          });

          _act(() => root.render(components2.LifecycleTest({
                ...initialProps,
                'ref': componentRef,
              })));

          expect(
              componentRef.current.lifecycleCalls,
              equals([
                matchCall('initialState'),
                matchCall('getDerivedStateFromProps', args: [initialProps, {}]),
                matchCall('render', state: initialDerivedState),
                matchCall('componentDidMount', state: initialDerivedState),
              ].where((matcher) => matcher != null).toList()));

          componentRef.current.lifecycleCalls.clear();

          _act(() => root.render(components2.LifecycleTest({
                ...updatedProps,
                'ref': componentRef,
              })));

          expect(
              componentRef.current.lifecycleCalls,
              equals([
                matchCall('getDerivedStateFromProps', args: [updatedProps, initialDerivedState]),
                matchCall('shouldComponentUpdate'),
                matchCall('render', state: updatedDerivedState),
                matchCall('getSnapshotBeforeUpdate'),
                matchCall('componentDidUpdate', state: updatedDerivedState),
              ].where((matcher) => matcher != null).toList()));
        });

        test('null, leaving the existing instance state value intact', () {
          const Map initialState = const {
            'foo': 'sudo',
          };
          final Map initialProps = unmodifiableMap({
            'getDerivedStateFromProps': (_, __, ___) => null,
            'getInitialState': (_) => initialState,
            'initialState': (_) => initialState,
          });

          final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

          _act(() => root.render(components2.LifecycleTest({
                ...initialProps,
                'ref': componentRef,
              })));

          componentRef.current.lifecycleCalls.clear();

          _act(() => (componentRef.current as react.Component2).forceUpdate());

          expect(
              componentRef.current.lifecycleCalls,
              equals([
                matchCall('getDerivedStateFromProps'),
                matchCall('render', state: initialState),
                matchCall('getSnapshotBeforeUpdate', args: [expectedProps, initialState], state: initialState),
                matchCall('componentDidUpdate', args: [expectedProps, initialState, null], state: initialState),
              ].where((matcher) => matcher != null).toList()));
        });
      });

      test('triggers error lifecycle events when an error is thrown', () {
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components2.SetStateTest({
              'ref': componentRef,
            })));
        LifecycleTestHelper.staticLifecycleCalls.clear();
        _act(() => componentRef.current.setState({"shouldThrow": true}));

        // First render throws an error, caught by `getDerivedStateFromError`.
        // `getDerivedStateFromError` sets state, starting the update cycle
        // again. `componentDidCatch` also sets the state (storing error
        // information), starting the update cycle again.
        expect(
            componentRef.current.lifecycleCallMemberNames,
            equals([
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getSnapshotBeforeUpdate',
              'componentDidUpdate',
              'componentDidCatch',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getSnapshotBeforeUpdate',
              'componentDidUpdate'
            ]));
        expect(componentRef.current.state["shouldThrow"], isFalse,
            reason: 'applies the state returned by `getDerivedStateFromError`');
      });

      test('handles null return value from getDerivedStateFromError as expected', () {
        final Map initialState = {
          'originalState': true,
        };
        var _shouldThrow = true;
        final Map initialProps = unmodifiableMap({
          'initialState': (_) => initialState,
          'getDerivedStateFromError': (_, __) => null,
          'render': (_) {
            if (_shouldThrow) {
              _shouldThrow = false;
              return components2.ErrorComponent({"key": "errorComp"});
            }
            return react.div({});
          }
        });

        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components2.ErrorLifecycleTest({
              ...initialProps,
              'ref': componentRef,
            })));

        expect(
            componentRef.current.lifecycleCallMemberNames,
            equals([
              'defaultProps',
              'initialState',
              'getDerivedStateFromProps',
              'render',
              'getDerivedStateFromError',
              'render',
              'initialState',
              'getDerivedStateFromProps',
              'render',
              'componentDidMount'
            ]));
        expect(componentRef.current.state, initialState,
            reason:
                'component.state should not update when an error is thrown within `render()` and `getDerivedStateFromError` returns null.');
      });

      test('handles unimplemented getDerivedStateFromError as expected when not included in skipMethods', () {
        final Map initialState = {
          'originalState': true,
        };
        var _shouldThrow = true;
        final Map initialProps = unmodifiableMap({
          'initialState': (_) => initialState,
          'render': (_) {
            if (_shouldThrow) {
              _shouldThrow = false;
              return components2.ErrorComponent({"key": "errorComp"});
            }
            return react.div({});
          }
        });

        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        expect(
          () => _act(() => root.render(components2.NoGetDerivedStateFromErrorLifecycleTest({
                ...initialProps,
                'ref': componentRef,
              }))),
          returnsNormally,
        );

        expect(
            componentRef.current.lifecycleCallMemberNames,
            equals([
              'defaultProps',
              'initialState',
              'getDerivedStateFromProps',
              'render',
              'render',
              'initialState',
              'getDerivedStateFromProps',
              'render',
              'componentDidMount'
            ]));
        expect(componentRef.current.state, initialState,
            reason:
                'component.state should not update when an error is thrown within `render()` and `getDerivedStateFromError` is not implemented.');
      });

      test('error lifecycle methods get passed Dartified Error/Exception when an error is thrown', () {
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components2.SetStateTest({
              'ref': componentRef,
            })));
        LifecycleTestHelper.staticLifecycleCalls.clear();
        _act(() => componentRef.current.setState({"shouldThrow": true}));

        expect(
            componentRef.current.lifecycleCalls,
            containsAll([
              matchCall('componentDidCatch',
                  args: [isA<components2.TestDartException>(), isA<react_interop.ReactErrorInfo>()]),
              matchCall('getDerivedStateFromError', args: [isA<components2.TestDartException>()]),
            ]));
        expect(componentRef.current.state["shouldThrow"], isFalse,
            reason: 'applies the state returned by `getDerivedStateFromError`');
      });

      test('can skip methods passed into _registerComponent2', () {
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components2.SkipMethodsTest({
              'ref': componentRef,
            })));
        LifecycleTestHelper.staticLifecycleCalls.clear();
        _act(() => componentRef.current.setState({"shouldThrow": true}));

        expect(
            componentRef.current.lifecycleCallMemberNames,
            equals([
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'getDerivedStateFromError',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'componentDidUpdate',
              'componentDidCatch',
              'getDerivedStateFromProps',
              'shouldComponentUpdate',
              'render',
              'componentDidUpdate'
            ]),
            reason: 'should have skipped getSnapshotBeforeUpdate');
      });

      test('passes the correct error/info to lifecycle methods when an error is thrown', () {
        final mountNode = DivElement();
        root = react_dom.createRoot(mountNode);
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(components2.SetStateTest({
              'ref': componentRef,
            })));
        LifecycleTestHelper.staticLifecycleCalls.clear();
        _act(() => componentRef.current.setState({"shouldThrow": true}));

        final rootNode = mountNode.children[0];
        expect(rootNode.children[1].text, contains(getComponent2ErrorMessage()));
        // Because the stacktrace will be different between JS and Dart, in
        // addition to DDC vs dart2js, the string 'created by' is checked
        // for. It is a commonality indicating that the stacktrace is
        // produced correctly.
        expect(rootNode.children[2].text.contains('Created By'), getComponent2ErrorInfo().contains('Created By'),
            reason: 'Check '
                'to make sure callstack is accessible');
        expect(rootNode.children[3].text, contains(getComponent2ErrorFromDerivedState()));
      });

      test('defaults toward not being an error boundary', () {
        root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();

        expect(() {
          _act(() => root.render(components2.DefaultSkipMethodsTest({
                'ref': componentRef,
              })));
          LifecycleTestHelper.staticLifecycleCalls.clear();
          _act(() => componentRef.current.setState({"shouldThrow": true}));
        }, throwsA(anything));
      });
    });

    group('Function Component', () {
      Element mountNode;
      react_dom.ReactRoot root;

      setUp(() {
        mountNode = DivElement();
        root = react_dom.createRoot(mountNode);
      });

      tearDown(() {
        root.unmount();
      });

      group('', () {
        ReactDartFunctionComponentFactoryProxy PropsTest;

        setUpAll(() {
          PropsTest = react.registerFunctionComponent((Map props) {
            return [props['testProp'], props['children']];
          });
        });

        test('renders correctly', () {
          var testProps = {'testProp': 'test'};
          _act(() => root.render(PropsTest(testProps, ['Child'])));
          expect(mountNode.innerHtml, 'testChild');
        });

        test('updates on rerender with new props', () {
          var testProps = {'testProp': 'test'};
          var updatedProps = {'testProp': 'test2'};
          _act(() => root.render(PropsTest(testProps, ['Child'])));
          expect(mountNode.innerHtml, 'testChild');
          _act(() => root.render(PropsTest(updatedProps, ['Child'])));
          expect(mountNode.innerHtml, 'test2Child');
        });
      });

      group('receives a JsBackedMap from the props argument', () {
        var propTypeCheck;
        ReactDartFunctionComponentFactoryProxy PropsArgTypeTest;

        setUp(() {
          propTypeCheck = null;
          PropsArgTypeTest = react.registerFunctionComponent((Map props) {
            propTypeCheck = props;
            return null;
          });
        });

        test('when provided with an empty dart map', () {
          _act(() => root.render(PropsArgTypeTest({})));
          expect(propTypeCheck, isA<JsBackedMap>());
        });
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
      test('is only called once per component factory and cached', () {
        final staticHelperInstance = defaultPropsCachingTestComponentFactory() as DefaultPropsCachingTestHelper;
        staticHelperInstance.staticGetDefaultPropsCallCount = 0;
        expect(staticHelperInstance.staticGetDefaultPropsCallCount, 0);

        // Need to run registerComponent in this test, which is what calls getDefaultProps.
        ReactDartComponentFactoryProxy DefaultPropsTest =
            react.registerComponent(defaultPropsCachingTestComponentFactory);
        var components = [
          renderIntoDocument(DefaultPropsTest({})),
          renderIntoDocument(DefaultPropsTest({})),
          renderIntoDocument(DefaultPropsTest({})),
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
          var props = getDartComponentProps(renderIntoDocument(DefaultPropsTest({})));
          expect(props, containsPair('defaultProp', 'default'));
        });

        test('the default props are overridden', () {
          var props = getDartComponentProps(renderIntoDocument(DefaultPropsTest({'defaultProp': 'overridden'})));
          expect(props, containsPair('defaultProp', 'overridden'));
        });

        test('non-default props are added', () {
          var props = getDartComponentProps(renderIntoDocument(DefaultPropsTest({'otherProp': 'other'})));
          expect(props, containsPair('defaultProp', 'default'));
          expect(props, containsPair('otherProp', 'other'));
        });
      });
    });

    test('receives correct lifecycle calls on component mount', () {
      LifecycleTestHelper component = getDartComponent(renderIntoDocument(LifecycleTest({})));
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
              matchCall('initialState'),
              matchCall('getDerivedStateFromProps'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      }
    });

    // FIXME: This test is intentionally not using root.render b/c the component instance won't be available to check the lifecycle calls after root.unmount is called.
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
        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(ContextWrapperWithoutKeys({
              'foo': false,
              'ref': componentRef,
            }, LifecycleTestWithContext({}))));

        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('getInitialState'),
              matchCall('componentWillMount'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      });

      test('calls getChildContext when childContextKeys exist', () {
        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(ContextWrapper({
              'foo': false,
              'ref': componentRef,
            }, LifecycleTestWithContext({}))));

        expect(
            componentRef.current.lifecycleCalls,
            containsAll([
              matchCall('getChildContext'),
              matchCall('getInitialState'),
              matchCall('componentWillMount'),
              matchCall('render'),
              matchCall('componentDidMount'),
            ]));
      });

      test('receives updated context with correct lifecycle calls', () {
        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();

        Map initialProps = {'foo': false, 'initialProp': 'initial', 'children': const []};
        Map newProps = {
          'children': const [],
          'foo': true,
          'newProp': 'new',
        };

        final Map initialPropsWithDefaults = unmodifiableMap({}
          ..addAll(defaultProps)
          ..addAll(initialProps));
        final Map newPropsWithDefaults = unmodifiableMap({}
          ..addAll(defaultProps)
          ..addAll(newProps));

        const Map expectedState = const {};

        const Map initialContext = const {'foo': false};

        const Map expectedContext = const {'foo': true};

        // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
        var initialPropsWithRef = {
          ...initialProps,
          'ref': componentRef,
        };
        var newPropsWithRef = {
          ...newPropsWithDefaults,
          'ref': componentRef,
        };

        // Render the initial instance
        _act(() => root.render(ContextWrapper({'foo': false}, LifecycleTestWithContext(initialPropsWithRef))));

        // Verify initial context/setup
        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('getChildContext', props: anything, context: anything),
              matchCall('getInitialState', props: initialPropsWithDefaults, context: initialContext),
              matchCall('componentWillMount', props: initialPropsWithDefaults, context: initialContext),
              matchCall('render', props: initialPropsWithDefaults, context: initialContext),
              matchCall('componentDidMount', props: initialPropsWithDefaults, context: initialContext),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        componentRef.current.lifecycleCalls.clear();

        // Trigger a re-render with new content
        _act(() => root.render(ContextWrapper({'foo': true}, LifecycleTestWithContext(newPropsWithRef))));

        // Verify updated context/setup
        expect(
            componentRef.current.lifecycleCalls,
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
        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();

        const Map expectedState = const {};

        const Map initialContext = const {'foo': false};

        const Map expectedContext = const {'foo': true};

        var initialProps = {...defaultProps, 'children': const []};
        // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
        var initialPropsWithRef = {
          ...initialProps,
          'ref': componentRef,
        };

        // Render the initial instance
        _act(() => root.render(ContextWrapper(
              {'foo': false},
              [
                LifecycleTestWithContext(initialPropsWithRef),
              ],
            )));

        // Verify initial context/setup
        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('initialState', props: initialProps, context: initialContext),
              matchCall('getDerivedStateFromProps', args: [initialProps, expectedState]),
              matchCall('render', props: initialProps, context: initialContext),
              matchCall('componentDidMount', props: initialProps, context: initialContext),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        componentRef.current.lifecycleCalls.clear();

        // Trigger a re-render with new content
        _act(() => root.render(ContextWrapper(
              {'foo': true},
              [
                LifecycleTestWithContext(initialPropsWithRef),
              ],
            )));

        // Verify updated context/setup
        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('getDerivedStateFromProps', args: [initialProps, expectedState]),
              matchCall('render', props: initialProps, context: expectedContext),
              matchCall('getSnapshotBeforeUpdate',
                  args: [initialProps, expectedState], props: initialProps, context: expectedContext),
              matchCall('componentDidUpdate',
                  args: [initialProps, expectedState, null], props: initialProps, context: expectedContext),
            ]));
      });

      test('receives updated context with correct lifecycle calls when wrapped with a consumer', () {
        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();

        const Map expectedState = const {};

        Map initialContext = {'foo': false};

        Map expectedContext = {'foo': true};

        var initialProps = {...defaultProps, ...initialContext, 'children': const []};
        // Add the 'ref' prop separately so it isn't an expected prop since React removes it internally
        var initialPropsWithRef = {
          ...initialProps,
          'ref': componentRef,
        };

        var expectedProps = {...initialProps, ...expectedContext};
        // Render the initial instance
        _act(() => root.render(ContextWrapper(
              initialContext,
              [
                ContextConsumerWrapper({}, [
                  (value) {
                    return LifecycleTest(initialPropsWithRef..addAll(value));
                  }
                ]),
              ],
            )));

        // Verify initial context/setup
        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('initialState', props: initialProps),
              matchCall('getDerivedStateFromProps'),
              matchCall('render', props: initialProps),
              matchCall('componentDidMount', props: initialProps),
            ]));

        // Clear the lifecycle calls for to not duplicate the initial calls below
        componentRef.current.lifecycleCalls.clear();

        // Trigger a re-render with new content3
        _act(() => root.render(ContextWrapper(
              expectedContext,
              [
                ContextConsumerWrapper({}, [
                  (value) {
                    return LifecycleTest(initialPropsWithRef..addAll(value));
                  }
                ]),
              ],
            )));

        // Verify updated context/setup
        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('getDerivedStateFromProps', args: [expectedProps, expectedState]),
              matchCall('shouldComponentUpdate', args: [expectedProps, expectedState], props: initialProps),
              matchCall('render', props: expectedProps),
              matchCall('getSnapshotBeforeUpdate', args: [initialProps, expectedState], props: expectedProps),
              matchCall('componentDidUpdate', args: [initialProps, expectedState, null], props: expectedProps),
            ]));
      });
    }

    test('receives updated props with correct lifecycle calls and defaults properly merged in', () {
      const Map initialProps = const {'initialProp': 'initial', 'children': const []};
      const Map newProps = const {'newProp': 'new', 'children': const []};

      final Map initialPropsWithDefaults = unmodifiableMap({}
        ..addAll(defaultProps)
        ..addAll(initialProps));
      final Map newPropsWithDefaults = unmodifiableMap({}
        ..addAll(defaultProps)
        ..addAll(newProps));

      const Map expectedState = const {};
      final dynamic expectedContext = isComponent2 ? null : const {};
      const Null expectedSnapshot = null;

      final root = react_dom.createRoot(DivElement());
      final componentRef = react.createRef<LifecycleTestHelper>();
      _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

      componentRef.current.lifecycleCalls.clear();

      _act(() => root.render(LifecycleTest({...newProps, 'ref': componentRef})));

      expect(
          componentRef.current.lifecycleCalls,
          equals([
            isComponent2 ? matchCall('getDerivedStateFromProps', args: [newPropsWithDefaults, expectedState]) : null,
            !isComponent2
                ? matchCall('componentWillReceiveProps', args: [newPropsWithDefaults], props: initialPropsWithDefaults)
                : null,
            skipLegacyContextTests
                ? null
                : matchCall('componentWillReceivePropsWithContext',
                    args: [newPropsWithDefaults, expectedContext], props: initialPropsWithDefaults),
            skipLegacyContextTests
                ? matchCall('shouldComponentUpdate',
                    args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults)
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

    if (isComponent2) {
      test('initializes state with the value set by `initialState`', () {
        const Map initialState = const {
          'initialState': 'initial',
        };

        final Map initialProps = unmodifiableMap({'initialState': (_) => initialState});
        final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

        expect(
            componentRef.current.lifecycleCalls,
            equals([
              matchCall('initialState', props: expectedProps),
              matchCall('getDerivedStateFromProps', args: {expectedProps, initialState}),
              matchCall('render', props: expectedProps, state: initialState),
              matchCall('componentDidMount', props: expectedProps, state: initialState)
            ].where((matcher) => matcher != null)));
        expect(componentRef.current.state, isA<JsBackedMap>());
      });
    }

    group('updates state with correct lifecycle calls', () {
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

      Map initialProps;
      Map expectedProps;
      dynamic newContext;
      Null expectedSnapshot;
      bool updatingStateWithNull;
      react_dom.ReactRoot root;
      Ref<LifecycleTestHelper> componentRef;

      setUp(() {
        initialProps = unmodifiableMap({'getInitialState': (_) => initialState, 'initialState': (_) => initialState});
        expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);
        newContext = isComponent2 ? null : const {};
        expectedSnapshot = null;
        updatingStateWithNull = false;

        root = react_dom.createRoot(DivElement());
        componentRef = react.createRef();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));
        componentRef.current.lifecycleCalls.clear();
      });

      tearDown(() {
        var expectedState = updatingStateWithNull ? initialState : newState;
        expect(
            componentRef.current.lifecycleCalls,
            (updatingStateWithNull && isComponent2)
                ? []
                : equals([
                    isComponent2 ? matchCall('getDerivedStateFromProps', args: [expectedProps, expectedState]) : null,
                    skipLegacyContextTests
                        ? matchCall('shouldComponentUpdate', args: [expectedProps, expectedState], state: initialState)
                        : matchCall('shouldComponentUpdateWithContext',
                            args: [expectedProps, expectedState, newContext], state: initialState),
                    !isComponent2
                        ? matchCall('componentWillUpdate', args: [expectedProps, expectedState], state: initialState)
                        : null,
                    skipLegacyContextTests
                        ? null
                        : matchCall('componentWillUpdateWithContext',
                            args: [expectedProps, expectedState, newContext], state: initialState),
                    matchCall('render', state: expectedState),
                    isComponent2
                        ? matchCall('getSnapshotBeforeUpdate',
                            args: [expectedProps, initialState], state: expectedState)
                        : null,
                    isComponent2
                        ? matchCall('componentDidUpdate',
                            args: [expectedProps, initialState, expectedSnapshot], state: expectedState)
                        : matchCall('componentDidUpdate', args: [expectedProps, initialState], state: expectedState),
                  ].where((matcher) => matcher != null)));

        root.unmount();
      });

      test('setState with Map argument', () {
        _act(() => componentRef.current.setState(stateDelta));
      });

      test('setState with updater argument', () {
        var calls = [];
        Map stateUpdater(Map prevState, Map props) {
          calls.add({
            'name': 'stateUpdater',
            'prevState': new Map.from(prevState),
            'props': new Map.from(props),
          });
          return stateDelta;
        }

        void setStateCallback() => calls.add({'name': 'setStateCallback'});

        if (isComponent2) {
          _act(() => (componentRef.current as react.Component2).setStateWithUpdater(stateUpdater, setStateCallback));
        } else {
          _act(() => componentRef.current.setState(stateUpdater, setStateCallback));
        }

        expect(
            calls,
            [
              {
                'name': 'stateUpdater',
                'prevState': initialState,
                'props': expectedProps,
              },
              {'name': 'setStateCallback'}
            ],
            reason: 'updater should be called with expected arguments');
      });

      test('setStateWithUpdater argument that returns null (no re-render)', () {
        updatingStateWithNull = true;
        var calls = [];
        Map stateUpdater(Map prevState, Map props) {
          calls.add({
            'name': 'stateUpdater',
            'prevState': new Map.from(prevState),
            'props': new Map.from(props),
          });
          return null;
        }

        void setStateCallback() => calls.add({'name': 'setStateCallback'});

        if (isComponent2) {
          _act(() => (componentRef.current as react.Component2).setStateWithUpdater(stateUpdater, setStateCallback));
        } else {
          _act(() => componentRef.current.setState(stateUpdater, setStateCallback));
        }

        expect(
            calls,
            [
              {
                'name': 'stateUpdater',
                'prevState': initialState,
                'props': expectedProps,
              },
              {'name': 'setStateCallback'}
            ],
            reason: 'updater should be called with expected arguments');
      });
    });

    test('updates state with correct lifecycle calls when `redraw` is called', () {
      const Map initialState = const {
        'initialState': 'initial',
      };

      final Map initialProps =
          unmodifiableMap({'initialState': (_) => initialState, 'getInitialState': (_) => initialState});

      final dynamic newContext = isComponent2 ? null : const {};

      final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

      final Null expectedSnapshot = null;

      final root = react_dom.createRoot(DivElement());
      final componentRef = react.createRef<LifecycleTestHelper>();
      _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

      componentRef.current.lifecycleCalls.clear();

      _act(() => componentRef.current.redraw());

      expect(
          componentRef.current.lifecycleCalls,
          equals([
            isComponent2 ? matchCall('getDerivedStateFromProps', args: [expectedProps, initialState]) : null,
            skipLegacyContextTests
                ? matchCall('shouldComponentUpdate', args: [expectedProps, initialState], state: initialState)
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

      root.unmount();
    });

    group('prevents concurrent modification of `_setStateCallbacks`', () {
      react_dom.ReactRoot root;
      Ref<LifecycleTestHelper> componentRef;
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
        initialProps = unmodifiableMap({'getInitialState': (_) => initialState, 'initialState': (_) => initialState});
        newState1 = {'foo': 'bar'};
        newState2 = {'baz': 'foobar'};
        expectedState1 = {}
          ..addAll(initialState)
          ..addAll(newState1);
        expectedState2 = {}
          ..addAll(expectedState1)
          ..addAll(newState2);

        root = react_dom.createRoot(DivElement());
        componentRef = react.createRef();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));
        componentRef.current.lifecycleCalls.clear();
      });

      tearDown(() {
        componentRef.current?.lifecycleCalls?.clear();
        root.unmount();
        initialProps = null;
        newState1 = null;
        expectedState1 = null;
        newState2 = null;
        expectedState2 = null;
      });

      test('when `setState` is called from within another `setState` callback', () {
        void handleSecondStateUpdate() {
          secondStateUpdateCalls++;
          expect(componentRef.current.state, expectedState2);
        }

        void handleFirstStateUpdate() {
          firstStateUpdateCalls++;
          expect(componentRef.current.state, expectedState1);
          _act(() => componentRef.current.setState(newState2, Zone.current.bindCallback(handleSecondStateUpdate)));
        }

        _act(() => componentRef.current.setState(newState1, Zone.current.bindCallback(handleFirstStateUpdate)));

        expect(firstStateUpdateCalls, 1);
        expect(secondStateUpdateCalls, 1);

        if (!isComponent2) {
          expect(
              componentRef.current.lifecycleCalls,
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

        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

        componentRef.current.lifecycleCalls.clear();

        _act(() => root.render(LifecycleTest({...newProps, 'ref': componentRef})));

        expect(
            componentRef.current.lifecycleCalls,
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
          'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) => shouldComponentUpdateWithContext,
          'initialProp': 'initial',
          'children': const []
        });
        const Map newProps = const {'newProp': 'new', 'children': const []};

        final Map initialPropsWithDefaults = unmodifiableMap(defaultProps, initialProps);
        final Map newPropsWithDefaults = unmodifiableMap(defaultProps, newProps);

        const Map expectedState = const {};

        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

        componentRef.current.lifecycleCalls.clear();

        _act(() => root.render(LifecycleTest({...newProps, 'ref': componentRef})));

        List calls = [
          isComponent2 ? matchCall('getDerivedStateFromProps', args: [newPropsWithDefaults, expectedState]) : null,
          isComponent2
              ? null
              : matchCall('componentWillReceiveProps', args: [newPropsWithDefaults], props: initialPropsWithDefaults),
          skipLegacyContextTests
              ? null
              : matchCall('componentWillReceivePropsWithContext',
                  args: [newPropsWithDefaults, expectedContext], props: initialPropsWithDefaults),
          isComponent2
              ? matchCall('shouldComponentUpdate',
                  args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults)
              : matchCall('shouldComponentUpdateWithContext',
                  args: [newPropsWithDefaults, expectedState, expectedContext], props: initialPropsWithDefaults),
        ].where((matcher) => matcher != null).toList();

        if (shouldComponentUpdateWithContext == null && !skipLegacyContextTests) {
          calls.add(
            matchCall('shouldComponentUpdate',
                args: [newPropsWithDefaults, expectedState], props: initialPropsWithDefaults),
          );
        }

        expect(componentRef.current.lifecycleCalls, equals(calls));
        expect(componentRef.current.props, equals(newPropsWithDefaults));
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
          'initialState': (_) => initialState,
          'shouldComponentUpdate': (_, __, ___) => shouldComponentUpdate,
          'shouldComponentUpdateWithContext': (_, __, ___, ____) => shouldComponentUpdateWithContext,
        });

        final Map expectedProps = unmodifiableMap(defaultProps, initialProps, emptyChildrenProps);

        final root = react_dom.createRoot(DivElement());
        final componentRef = react.createRef<LifecycleTestHelper>();
        _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));
        componentRef.current.lifecycleCalls.clear();

        _act(() => componentRef.current.setState(stateDelta));
        List calls;
        if (isComponent2) {
          calls = [
            matchCall('getDerivedStateFromProps', args: [expectedProps, newState]),
            matchCall('shouldComponentUpdate', args: [expectedProps, newState], state: initialState)
          ];
        } else {
          calls = [
            matchCall('shouldComponentUpdateWithContext',
                args: [expectedProps, newState, expectedContext], state: initialState)
          ];
        }

        if (shouldComponentUpdateWithContext == null && !skipLegacyContextTests) {
          calls.add(
            matchCall('shouldComponentUpdate', args: [expectedProps, newState], state: initialState),
          );
        }

        expect(componentRef.current.lifecycleCalls, equals(calls));
        expect(componentRef.current.state, equals(newState));
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

          final root = react_dom.createRoot(DivElement());
          final componentRef = react.createRef<LifecycleTestHelper>();
          _act(() => root.render(LifecycleTest({...initialProps, 'ref': componentRef})));

          componentRef.current.lifecycleCalls.clear();

          _act(() => root.render(LifecycleTest({...newProps, 'ref': componentRef})));

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

          expect(componentRef.current.lifecycleCalls, equals(calls));
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

    group('calling setState', () {
      react_dom.ReactRoot root;
      Ref<LifecycleTestHelper> componentRef;

      setUp(() {
        root = react_dom.createRoot(DivElement());
        componentRef = react.createRef();
        _act(() => root.render(SetStateTest({'ref': componentRef})));
        componentRef.current.lifecycleCalls.clear();
      });

      tearDown(() {
        componentRef.current?.lifecycleCalls?.clear();
        root.unmount();
      });

      if (isComponent2) {
        test('does not update the component when the value passed is null', () {
          _act(() => componentRef.current.callSetStateWithNullValue());

          expect(componentRef.current.lifecycleCalls, isEmpty);
        });
      } else {
        test('does update the component when the value passed is null', () {
          _act(() => componentRef.current.callSetStateWithNullValue());

          expect(componentRef.current.lifecycleCalls,
              ['shouldComponentUpdate', 'componentWillUpdate', 'render', 'componentDidUpdate']);
        });
      }
    });

    // FIXME: These tests fail when switching to createRoot, but I can't figure out how to change the expected value.
    group('calls the setState callback, and transactional setState callback in the correct order', () {
      test('when shouldComponentUpdate returns false', () {
        var mountNode = new DivElement();
        var renderedInstance = react_dom.render(SetStateTest({'shouldUpdate': false}), mountNode);
        Element renderedNode = react_dom.findDOMNode(renderedInstance);
        LifecycleTestHelper component = getDartComponent(renderedInstance);

        _act(renderedNode.children.first.click);
        // todo directly assert state change occured to aid in test debugging

        // Check against the JS component to ensure no regressions.
        expect(component.state['counter'], 3);
        if (isComponent2) {
          expect(component.lifecycleCallMemberNames, orderedEquals(getComponent2NonUpdatingSetStateLifeCycleCalls()));
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

        _act(renderedNode.children.first.click);
        // todo directly assert state change occured to aid in test debugging

        // Check against the JS component to ensure no regressions.
        expect(component.state['counter'], 3);

        if (isComponent2) {
          expect(component.lifecycleCallMemberNames, orderedEquals(getComponent2UpdatingSetStateLifeCycleCalls()));
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
