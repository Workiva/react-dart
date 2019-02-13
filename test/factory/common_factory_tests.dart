import 'dart:js';

import 'package:test/test.dart';

import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/react.dart' as react;
import "package:react/react_client/js_interop_helpers.dart";

import '../util.dart';

void commonFactoryTests(ReactComponentFactoryProxy factory) {
  _childKeyWarningTests(factory);

  test('renders an instance with the corresponding `type`', () {
    var instance = factory({});

    expect(instance.type, equals(factory.type));
  });

  group('passes children to the component when specified as', () {
    dynamic getJsChildren(ReactElement instance) =>
        getProperty(instance.props, 'children');

    // There are different code paths for 0, 1, 2, 3, 4, 5, 6, and 6+ arguments.
    // Test all of them.
    group('a number of variadic children:', () {
      test('0', () {
        final instance = factory({});
        expect(getJsChildren(instance), isNull);
      });

      test('1', () {
        final instance = factory({}, 1);
        expect(getJsChildren(instance), equals(1));
      });

      const firstGeneralCaseVariadicChildCount = 2;
      const maxSupportedVariadicChildCount = 40;
      for (var i = firstGeneralCaseVariadicChildCount;
          i < maxSupportedVariadicChildCount;
          i++) {
        final childrenCount = i;

        test('$childrenCount', () {
          final expectedChildren =
              new List.generate(childrenCount, (i) => i + 1);
          final arguments = <dynamic>[{}]..add(expectedChildren);
          final instance = Function.apply(factory, arguments);
          expect(getJsChildren(instance), expectedChildren);
        });
      }

      test('$maxSupportedVariadicChildCount (and passes static analysis)', () {
        final instance = factory({},
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            39,
            40);
        // Generate these instead of hard coding them to ensure the arguments passed into this test match maxSupportedVariadicChildCount
        final expectedChildren =
            new List.generate(maxSupportedVariadicChildCount, (i) => i + 1);
        expect(getJsChildren(instance), equals(expectedChildren));
      });
    });

    test('a List', () {
      var instance = factory({}, [
        'one',
        'two',
      ]);
      expect(getJsChildren(instance), equals(['one', 'two']));
    });

    test('an empty List', () {
      var instance = factory({}, []);
      expect(getJsChildren(instance), equals([]));
    });

    test('an Iterable', () {
      var instance = factory({}, new Iterable.generate(3, (int i) => '$i'));
      expect(getJsChildren(instance), equals(['0', '1', '2']));
    });

    test('an empty Iterable', () {
      var instance = factory({}, new Iterable.empty());
      expect(getJsChildren(instance), equals([]));
    });
  });
}

void domEventHandlerWrappingTests(ReactDomComponentFactoryProxy factory) {
  setUpAll(() {
    var called = false;

    var renderedInstance = rtu.renderIntoDocument(factory({
      'onClick': (_) {
        called = true;
      }
    }));

    rtu.Simulate.click(react_dom.findDOMNode(renderedInstance));

    expect(called, isTrue,
        reason: 'this set of tests assumes that the factory '
            'passes the click handler to the rendered DOM node');
  });

  test('wraps the handler with a function that converts the synthetic event',
      () {
    var actualEvent;

    var renderedInstance = rtu.renderIntoDocument(factory({
      'onClick': (event) {
        actualEvent = event;
      }
    }));

    rtu.Simulate.click(react_dom.findDOMNode(renderedInstance));

    expect(actualEvent, const isInstanceOf<react.SyntheticEvent>());
  });

  test('doesn\'t wrap the handler if it is null', () {
    var renderedInstance = rtu.renderIntoDocument(factory({'onClick': null}));

    expect(() => rtu.Simulate.click(react_dom.findDOMNode(renderedInstance)),
        returnsNormally);
  });

  test(
      'stores the original function in a way that it can be retrieved from unconvertJsEventHandler',
      () {
    final originalHandler = (event) {};

    var instance = factory({'onClick': originalHandler});
    var instanceProps = getProps(instance);

    expect(instanceProps['onClick'], isNot(same(originalHandler)),
        reason:
            'test setup sanity check; should be different, converted function');
    expect(unconvertJsEventHandler(instanceProps['onClick']),
        same(originalHandler));
  });
}

void _childKeyWarningTests(Function factory) {
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

      expect(consoleErrorCalled, isTrue,
          reason: 'should have outputted a warning');
      expect(
          consoleErrorMessage,
          contains(
              'Each child in a list should have a unique "key" prop.'));
    });

    /*
    /// This might not be a thing in react16.
    test('warns when multiple children are passed as a list', () {
      _renderWithUniqueOwnerName(
          () => factory({}, [react.span({}), react.span({}), react.span({})]));

      expect(consoleErrorCalled, isTrue,
          reason: 'should have outputted a warning');
      expect(
          consoleErrorMessage,
          contains(
              'Each child in a list should have a unique "key" prop.'));
    });
    */

    test('does not warn when multiple children are passed as variadic args',
        () {
      _renderWithUniqueOwnerName(
          () => factory({}, react.span({}), react.span({}), react.span({})));

      expect(consoleErrorCalled, isFalse,
          reason: 'should not have outputted a warning');
    });

    test('when rendering custom Dart components', () {
      _renderWithUniqueOwnerName(() => factory({}, react.span({})));

      expect(consoleErrorCalled, isFalse,
          reason: 'should not have outputted a warning');
    });
  });
}

int _nextFactoryId = 0;

/// Renders the provided [render] function with an owner that will have a unique name.
///
/// This prevents React JS from not printing key warnings it deems as "duplicates".
void _renderWithUniqueOwnerName(ReactElement render()) {
  final factory = react.registerComponent(() => new _OwnerHelperComponent())
      as ReactDartComponentFactoryProxy;
  factory.reactClass.displayName = 'OwnerHelperComponent_$_nextFactoryId';
  _nextFactoryId++;

  rtu.renderIntoDocument(factory({'render': render}));
}

class _OwnerHelperComponent extends react.Component {
  @override
  render() => props['render']();
}
