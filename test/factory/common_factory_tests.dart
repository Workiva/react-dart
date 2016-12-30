import 'dart:js';

import 'package:js/js_util.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;

void commonFactoryTests(Function factory) {
  childKeyWarningTests(factory);

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
    });

    test('a List', () {
      var instance = factory({}, ['one', 'two',]);
      expect(getJsChildren(instance), equals(['one', 'two']));
    });
  });
}

void childKeyWarningTests(Function factory) {
  group('key/children validation', () {
    bool consoleErrorCalled;
    var consoleErrorMessage;
    JsFunction originalConsoleError;

    setUp(() {
      consoleErrorCalled = false;
      consoleErrorMessage = null;

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

    test('warns when multiple children are passed as a list', () {
      _renderWithUniqueOwnerName(() =>
          factory({}, [
            react.span({}),
            react.span({}),
            react.span({})
          ])
      );

      expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
      expect(consoleErrorMessage, contains('Each child in an array or iterator should have a unique "key" prop.'));
    });

    test('does not warn when multiple children are passed as variadic args', () {
      _renderWithUniqueOwnerName(() =>
          factory({},
            react.span({}),
            react.span({}),
            react.span({})
          )
      );

      expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
    });

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

  react_test_utils.renderIntoDocument(
      factory({'render': render})
  );
}

class _OwnerHelperComponent extends react.Component {
  @override
  render() => props['render']();
}
