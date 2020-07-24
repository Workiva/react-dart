@JS()
library react.test.common_factory_tests;

// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/react_client/react_interop.dart';

import '../util.dart';

void commonFactoryTests(ReactComponentFactoryProxy factory, {bool isFunctionComponent = false}) {
  _childKeyWarningTests(
    factory,
    renderWithUniqueOwnerName: _renderWithUniqueOwnerName,
  );

  test('renders an instance with the corresponding `type`', () {
    var instance = factory({});

    expect(instance.type, equals(factory.type));
  });

  void sharedChildrenTests(dynamic getChildren(ReactElement instance), {@required bool shouldAlwaysBeList}) {
    // There are different code paths for 0, 1, 2, 3, 4, 5, 6, and 6+ arguments.
    // Test all of them.
    group('a number of variadic children:', () {
      test('0', () {
        final instance = factory({});
        expect(getChildren(instance), shouldAlwaysBeList ? [] : isNull);
      });

      test('1', () {
        final instance = factory({}, 1);
        expect(getChildren(instance), shouldAlwaysBeList ? [1] : 1);
      });

      const firstGeneralCaseVariadicChildCount = 2;
      const maxSupportedVariadicChildCount = 40;
      for (var i = firstGeneralCaseVariadicChildCount; i < maxSupportedVariadicChildCount; i++) {
        final childrenCount = i;

        test('$childrenCount', () {
          final expectedChildren = new List.generate(childrenCount, (i) => i + 1);
          final arguments = <dynamic>[{}]..add(expectedChildren);
          final instance = Function.apply(factory, arguments);
          expect(getChildren(instance), expectedChildren);
        });
      }

      test('$maxSupportedVariadicChildCount (and passes static analysis)', () {
        final instance = factory({}, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
            24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40);
        // Generate these instead of hard coding them to ensure the arguments passed into this test match maxSupportedVariadicChildCount
        final expectedChildren = new List.generate(maxSupportedVariadicChildCount, (i) => i + 1);
        expect(getChildren(instance), equals(expectedChildren));
      });
    });

    test('a List', () {
      var instance = factory({}, [
        'one',
        'two',
      ]);
      expect(getChildren(instance), equals(['one', 'two']));
    });

    test('an empty List', () {
      var instance = factory({}, []);
      expect(getChildren(instance), equals([]));
    });

    test('an Iterable', () {
      var instance = factory({}, new Iterable.generate(3, (int i) => '$i'));
      expect(getChildren(instance), equals(['0', '1', '2']));
    });

    test('an empty Iterable', () {
      var instance = factory({}, new Iterable.empty());
      expect(getChildren(instance), equals([]));
    });
  }

  group('passes children to the JS component when specified as', () {
    dynamic getJsChildren(ReactElement instance) => getProperty(instance.props, 'children');

    sharedChildrenTests(getJsChildren,
        // Only Component2 should always get lists.
        // Component, DOM components, etc. should not for compatibility purposes.
        shouldAlwaysBeList: isDartComponent2(factory({})));
  });

  // Skipped for Function Components because they dont have instance members ... they are functions.
  if (isDartComponent(factory({})) && !isFunctionComponent) {
    group('passes children to the Dart component when specified as', () {
      dynamic getDartChildren(ReactElement instance) {
        // Actually render the component to provide full end-to-end coverage
        // from ReactElement to `this.props`.
        ReactComponent renderedInstance = rtu.renderIntoDocument(instance);
        return renderedInstance.dartComponent.props['children'];
      }

      sharedChildrenTests(getDartChildren, shouldAlwaysBeList: true);
    });
  }
}

void domEventHandlerWrappingTests(ReactComponentFactoryProxy factory) {
  Element renderAndGetRootNode(ReactElement content) {
    final mountNode = Element.div();
    react_dom.render(content, mountNode);
    return mountNode.children.single;
  }

  setUpAll(() {
    var called = false;

    final nodeWithClickHandler = renderAndGetRootNode(factory({
      'onClick': (_) {
        called = true;
      }
    }));

    rtu.Simulate.click(nodeWithClickHandler);

    expect(called, isTrue,
        reason: 'this set of tests assumes that the factory '
            'renders a single DOM node and passes props.onClick to it');
  });

  test('wraps the handler with a function that converts the synthetic event', () {
    var actualEvent;

    final nodeWithClickHandler = renderAndGetRootNode(factory({
      'onClick': (event) {
        actualEvent = event;
      }
    }));

    rtu.Simulate.click(nodeWithClickHandler);

    expect(actualEvent, isA<react.SyntheticEvent>());
  });

  group('wraps the handler with a function that proxies ReactJS event "persistence" as expected', () {
    test('when event.persist() is called', () {
      react.SyntheticMouseEvent actualEvent;

      final nodeWithClickHandler = renderAndGetRootNode(factory({
        'onClick': (react.SyntheticMouseEvent event) {
          event.persist();
          actualEvent = event;
        }
      }));

      rtu.Simulate.click(nodeWithClickHandler);

      // ignore: invalid_use_of_protected_member
      expect(actualEvent.$$jsPersistDoNotSetThisOrYouWillBeFired, isA<Function>());
      expect(actualEvent.isPersistent, isTrue);
    });

    test('when event.persist() is not called', () {
      react.SyntheticMouseEvent actualEvent;

      final nodeWithClickHandler = renderAndGetRootNode(factory({
        'onClick': (react.SyntheticMouseEvent event) {
          actualEvent = event;
        }
      }));

      rtu.Simulate.click(nodeWithClickHandler);

      // ignore: invalid_use_of_protected_member
      expect(actualEvent.$$jsPersistDoNotSetThisOrYouWillBeFired, isA<Function>());
      expect(actualEvent.isPersistent, isFalse);
    });
  });

  test('doesn\'t wrap the handler if it is null', () {
    final nodeWithClickHandler = renderAndGetRootNode(factory({'onClick': null}));

    expect(() => rtu.Simulate.click(nodeWithClickHandler), returnsNormally);
  });

  test('stores the original function in a way that it can be retrieved from unconvertJsEventHandler', () {
    final originalHandler = (event) {};

    var instance = factory({'onClick': originalHandler});
    var instanceProps = getProps(instance);

    expect(instanceProps['onClick'], isNot(same(originalHandler)),
        reason: 'test setup sanity check; should be different, converted function');
    expect(unconvertJsEventHandler(instanceProps['onClick']), same(originalHandler));
  });

  group('calls the handler in the zone the event was dispatched from', () {
    test('(simulated event)', () {
      final testZone = Zone.current;

      Element nodeWithClickHandler;
      // Run the ReactElement creation and rendering in a separate zone to
      // ensure the component lifecycle isn't run in the testZone, which could
      // create false positives in the `expect`.
      runZoned(() {
        nodeWithClickHandler = renderAndGetRootNode(factory({
          'onClick': (event) {
            expect(Zone.current, same(testZone));
          }
        }));
      });

      rtu.Simulate.click(nodeWithClickHandler);
    });

    test('(native event)', () {
      final testZone = Zone.current;

      Element nodeWithClickHandler;
      // Run the ReactElement creation and rendering in a separate zone to
      // ensure the component lifecycle isn't run in the testZone, which could
      // create false positives in the `expect`.
      runZoned(() {
        nodeWithClickHandler = renderAndGetRootNode(factory({
          'onClick': (event) {
            expect(Zone.current, same(testZone));
          }
        }));
      });

      nodeWithClickHandler.dispatchEvent(new MouseEvent('click'));
    });
  });
}

void refTests<T>(ReactComponentFactoryProxy factory, {void verifyRefValue(dynamic refValue)}) {
  if (T == dynamic) {
    throw ArgumentError('Generic parameter T must be specified');
  }

  test('callback refs are called with the correct value', () {
    var called = false;
    var refValue;

    rtu.renderIntoDocument(factory({
      'ref': (ref) {
        called = true;
        refValue = ref;
      }
    }));

    expect(called, isTrue, reason: 'should have called the callback ref');
    verifyRefValue(refValue);
  });

  test('string refs are created with the correct value', () {
    ReactComponent renderedInstance = _renderWithStringRefSupportingOwner(() => factory({'ref': 'test'}));

    // ignore: deprecated_member_use_from_same_package
    verifyRefValue(renderedInstance.dartComponent.ref('test'));
  });

  test('createRef function creates ref with correct value', () {
    final Ref ref = createRef();

    rtu.renderIntoDocument(factory({
      'ref': ref,
    }));

    verifyRefValue(ref.current);
  });

  test('forwardRef function passes a ref through a component to one of its children', () {
    var ForwardRefTestComponent = forwardRef((props, ref) {
      // Extra type checking since JS refs being passed through
      // aren't caught by built-in type checking.
      expect(ref, isA<Ref>());

      return factory({
        'ref': ref,
        'id': props['childId'],
      });
    });

    final Ref refObject = createRef();

    rtu.renderIntoDocument(ForwardRefTestComponent({
      'ref': refObject,
      'childId': 'test',
    }));

    // Props are accessed differently for DOM, Dart, and JS components.
    var idValue;
    final current = refObject.current;
    expect(current, isNotNull);
    if (current is Element) {
      idValue = current.id;
    } else if (current is react.Component) {
      idValue = current.props['id'];
    } else if (rtu.isCompositeComponent(current)) {
      idValue = JsBackedMap.fromJs((current as ReactComponent).props)['id'];
    } else {
      fail('Unknown instance type: current');
    }

    expect(idValue, equals('test'), reason: 'child component should have access to parent props');
    verifyRefValue(refObject.current);
  });

  group('forwardRef sets displayName on the rendered component as expected', () {
    test('when displayName argument is not passed to forwardRef', () {
      var ForwardRefTestComponent = forwardRef((props, ref) {
        // Extra type checking since JS refs being passed through
        // aren't caught by built-in type checking.
        expect(ref, isA<Ref>());

        return factory({'ref': ref});
      });

      expect(getProperty(getProperty(ForwardRefTestComponent.type, 'render'), 'displayName'), 'Anonymous');
    });

    test('when displayName argument is passed to forwardRef', () {
      var ForwardRefTestComponent = forwardRef((props, ref) {
        // Extra type checking since JS refs being passed through
        // aren't caught by built-in type checking.
        expect(ref, isA<Ref>());

        return factory({'ref': ref});
      }, displayName: 'ForwardRefTestComponent');

      expect(
          getProperty(getProperty(ForwardRefTestComponent.type, 'render'), 'displayName'), 'ForwardRefTestComponent');
    });
  });

  group('forwardRef wraps event handlers properly,', () {
    final isDartComponent = factory is ReactDartComponentFactoryProxy;

    const dartInside = EventTestCase.dart('onMouseDown', 'inside forwardRef');
    const dart = EventTestCase.dart('onMouseUp', 'set on forwardRef hoc');
    const dartCloned = EventTestCase.dart('onMouseLeave', 'cloned onto forwardRef hoc');
    const jsCloned = EventTestCase.js('onClick', 'cloned onto forwardRef hoc ');
    const eventCases = {dartInside, dart, jsCloned, dartCloned};

    Element node;
    Map<EventTestCase, dynamic> events;
    Map propsFromDartRender;

    setUpAll(() {
      expect(eventCases.map((h) => h.eventPropKey).toSet(), hasLength(eventCases.length),
          reason: 'test setup: each helper should have a unique event key');

      node = null;
      events = {};
      propsFromDartRender = null;

      final ForwardRefTestComponent = forwardRef((props, ref) {
        return factory({
          ...props,
          'onDartRender': (p) {
            propsFromDartRender = p;
          },
          dartInside.eventPropKey: (event) => events[dartInside] = event,
          isDartComponent ? 'forwardedRef' : 'ref': ref,
        }, props['children']);
      });

      final refObject = createRef();
      var element = ForwardRefTestComponent({
        'ref': refObject,
        dart.eventPropKey: (event) => events[dart] = event,
      });

      element = React.cloneElement(
        element,
        jsifyAndAllowInterop({
          jsCloned.eventPropKey: (event) => events[jsCloned] = event,
        }),
      );

      element = React.cloneElement(
        element,
        // Invoke the factory corresponding to element's type
        // to get the correct version of the handler (converted or non-converted)
        // before passing it straight to the JS.
        ForwardRefTestComponent({
          dartCloned.eventPropKey: (event) => events[dartCloned] = event,
        }).props,
      );

      rtu.renderIntoDocument(element);

      node = react_dom.findDOMNode(refObject.current);
    });

    group('passing Dart events to Dart handlers, and JS events to handlers originating from JS:', () {
      for (var eventCase in eventCases) {
        test(eventCase.description, () {
          eventCase.simulate(node);
          expect(events[eventCase], isNotNull, reason: 'handler should have been called');
          expect(events[eventCase],
              eventCase.isDart ? isA<react.SyntheticMouseEvent>() : isNot(isA<react.SyntheticMouseEvent>()));
        });
      }
    });

    if (isDartComponent) {
      group('in a way that the handlers are callable from within the Dart component:', () {
        setUpAll(() {
          expect(propsFromDartRender, isNotNull,
              reason: 'test setup: component must pass props into props.onDartRender');
        });

        final dummyEvent = react.SyntheticMouseEvent(null, null, null, null, null, null, null, null, null, null, null,
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);

        for (var eventCase in eventCases.where((helper) => helper.isDart)) {
          test(eventCase.description, () {
            expect(() => propsFromDartRender[eventCase.eventPropKey](dummyEvent), returnsNormally);
          });
        }
      });
    }
  });

  group('has functional callback refs when they are typed as', () {
    test('`dynamic Function(dynamic)`', () {
      T fooRef;
      callbackRef(dynamic ref) {
        fooRef = ref;
      }

      expect(() => rtu.renderIntoDocument(factory({'ref': callbackRef})), returnsNormally,
          reason: 'React should not have a problem with the ref we pass it, and calling it should not throw');
      expect(fooRef, isA<T>(), reason: 'should be the correct type, not be a NativeJavaScriptObject/etc.');
    });

    test('`dynamic Function(ComponentClass)`', () {
      T fooRef;
      callbackRef(T ref) {
        fooRef = ref;
      }

      expect(() => rtu.renderIntoDocument(factory({'ref': callbackRef})), returnsNormally,
          reason: 'React should not have a problem with the ref we pass it, and calling it should not throw');
      expect(fooRef, isA<T>(), reason: 'should be the correct type, not be a NativeJavaScriptObject/etc.');
    });
  });

  group('chainRefList works', () {
    test('with all different types of values, ignoring null', () {
      final testCases = RefTestCase.allChainable<T>();

      T refValue;
      rtu.renderIntoDocument(factory({
        'ref': chainRefList([
          (ref) => refValue = ref,
          null,
          null,
          ...testCases.map((t) => t.ref),
        ]),
      }));
      // Test setup check: verify refValue is correct,
      // which we'll use below to verify refs were updated.
      verifyRefValue(refValue);

      for (final testCase in testCases) {
        testCase.verifyRefWasUpdated(refValue);
      }
    });

    // Other cases tested in chainRefList's own tests
  });
}

void _childKeyWarningTests(Function factory, {Function(ReactElement Function()) renderWithUniqueOwnerName}) {
  group('key/children validation', () {
    bool consoleErrorCalled;
    var consoleErrorMessage;
    JsFunction originalConsoleError;

    setUp(() {
      consoleErrorCalled = false;
      consoleErrorMessage = null;

      originalConsoleError = context['console']['error'];
      context['console']['error'] = new JsFunction.withThis((self, message, arg1, arg2, arg3) {
        consoleErrorCalled = true;
        consoleErrorMessage = message;

        originalConsoleError.apply([message], thisArg: self);
      });
    });

    tearDown(() {
      context['console']['error'] = originalConsoleError;
    });

    test('warns when a single child is passed as a list', () {
      _renderWithUniqueOwnerName(() => factory({}, [react.span({})]));

      expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
      expect(consoleErrorMessage, contains('Each child in a list should have a unique "key" prop.'));
    });

    test('warns when multiple children are passed as a list', () {
      renderWithUniqueOwnerName(() => factory({}, [react.span({}), react.span({}), react.span({})]));

      expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
    });

    test('does not warn when multiple children are passed as variadic args', () {
      renderWithUniqueOwnerName(() => factory({}, react.span({}), react.span({}), react.span({})));

      expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
    });

    test('when rendering custom Dart components', () {
      renderWithUniqueOwnerName(() => factory({}, react.span({})));

      expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
    });
  });
}

class _StringRefOwnerOwnerHelperComponent extends react.Component {
  @override
  render() => props['render']();
}

/// Renders the provided [render] function with a Component owner that supports string refs,
/// for string ref tests.
ReactComponent _renderWithStringRefSupportingOwner(ReactElement render()) {
  final factory =
      react.registerComponent(() => new _StringRefOwnerOwnerHelperComponent()) as ReactDartComponentFactoryProxy;

  return rtu.renderIntoDocument(factory({'render': render}));
}

int _nextFactoryId = 0;

/// Renders the provided [render] function with a Component2 owner that will have a unique name.
///
/// This prevents React JS from not printing key warnings it deems as "duplicates".
void _renderWithUniqueOwnerName(ReactElement render()) {
  final factory = react.registerComponent2(() => new _UniqueOwnerHelperComponent());
  factory.reactClass.displayName = 'OwnerHelperComponent_$_nextFactoryId';
  _nextFactoryId++;

  rtu.renderIntoDocument(factory({'render': render}));
}

class _UniqueOwnerHelperComponent extends react.Component2 {
  @override
  render() => props['render']();
}

class EventTestCase {
  /// The prop key for an arbitrary event handler that will be used to test this case.
  final String eventPropKey;

  /// A description of this test case.
  final String description;

  /// Whether the tested event handler is a Dart function expecting a Dart synthetic event,
  /// as opposed to a JS function expecting a JS synthetic event.
  final bool isDart;

  const EventTestCase.dart(this.eventPropKey, String description)
      : isDart = true,
        description = 'Dart handler $description';

  const EventTestCase.js(this.eventPropKey, String description)
      : isDart = false,
        description = 'JS handler $description';

  String get _camelCaseEventName {
    var name = eventPropKey.replaceFirst(RegExp(r'^on'), '');
    name = name.substring(0, 1).toLowerCase() + name.substring(1);
    return name;
  }

  void simulate(Element node) => callMethod(_Simulate, _camelCaseEventName, [node]);

  @override
  String toString() => 'EventHelper: ($eventPropKey) $description';
}

@JS('React.addons.TestUtils.Simulate')
external dynamic get _Simulate;
