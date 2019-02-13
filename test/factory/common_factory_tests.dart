import 'dart:js';

import 'package:test/test.dart';

import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as rtu;
import 'package:react/react.dart' as react;
import "package:react/react_client/js_interop_helpers.dart";

void commonFactoryTests(Function factory) {
  _childKeyWarningTests(factory);

  test('renders an instance with the corresponding `type`', () {
    var instance = factory({});

    expect(instance.type, equals((factory as ReactComponentFactoryProxy).type));
  });

  group('passes children to the component when specified as', () {
    dynamic getJsChildren(ReactElement instance) => getProperty(instance.props, 'children');

    test('no arguments', () {
      var instance = factory({});
      expect(getJsChildren(instance), isNull);
    });

    test('a single argument', () {
      var instance = factory({}, 'single',);
      expect(getJsChildren(instance), equals('single'));
    });

    test('multiple arguments', () {
      var instance = factory({}, 'one', 'two');
      expect(getJsChildren(instance), equals(['one', 'two']));
    }, tags: 'ddcFailure'); // This test cannot be run using ddc until https://github.com/dart-lang/sdk/issues/29904 is resolved

    test('a List', () {
      var instance = factory({}, ['one', 'two',]);
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

void domEventHandlerWrappingTests(Function factory) {
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
            'passes the click handler to the rendered DOM node'
    );
  });

  test('wraps the handler with a function that converts the synthetic event', () {
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
    var renderedInstance = rtu.renderIntoDocument(factory({
      'onClick': null
    }));

    expect(() => rtu.Simulate.click(react_dom.findDOMNode(renderedInstance)), returnsNormally);
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

    /*
    TODO: Remove due to invaliditiy with React 16
    test('warns when a single child is passed as a list', () {
      _renderWithUniqueOwnerName(() =>
          factory({}, [
            react.span({})
          ])
      );

      expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
      expect(consoleErrorMessage, contains('Each child in a list should have a unique "key" prop.'));
    });
    */

    /*
    TODO: Remove due to invaliditiy with React 16
    test('warns when multiple children are passed as a list', () {
      _renderWithUniqueOwnerName(() =>
          factory({}, [
            react.span({}),
            react.span({}),
            react.span({})
          ])
      );

      expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
      expect(consoleErrorMessage, contains('Each child in a list should have a unique "key" prop.'));
    });
    */

    test('does not warn when multiple children are passed as variadic args', () {
      _renderWithUniqueOwnerName(() =>
          factory({},
            react.span({}),
            react.span({}),
            react.span({})
          )
      );

      expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
    }, tags: 'ddcFailure'); // This test cannot be run using ddc until https://github.com/dart-lang/sdk/issues/29904 is resolved

    test('when rendering custom Dart components', () {
      _renderWithUniqueOwnerName(() =>
          factory({},
            react.span({})
          )
      );

      expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
    });
  });
}

int _nextFactoryId = 0;

/// Renders the provided [render] function with an owner that will have a unique name.
///
/// This prevents React JS from not printing key warnings it deems as "duplicates".
void _renderWithUniqueOwnerName(ReactElement render()) {
  final factory =
    react.registerComponent(() => new _OwnerHelperComponent()) as ReactDartComponentFactoryProxy;
  factory.reactClass.displayName = 'OwnerHelperComponent_$_nextFactoryId';
  _nextFactoryId++;

  rtu.renderIntoDocument(
      factory({'render': render})
  );
}

class _OwnerHelperComponent extends react.Component {
  @override
  render() => props['render']();
}
