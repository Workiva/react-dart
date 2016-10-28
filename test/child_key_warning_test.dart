import 'dart:js';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;

int _nextFactoryId = 0;

/// Renders the provided [render] function with an owner that will have a unique name.
///
/// This prevents React JS from not printing key warnings it deems as "duplicates".
void renderWithUniqueOwnerName(ReactElement render()) {
  ReactDartComponentFactoryProxy factory =
      (react.registerComponent(() => new _OwnerHelperComponent())) as ReactDartComponentFactoryProxy;
  factory.reactClass.displayName = 'OwnerHelperComponent_$_nextFactoryId';
  _nextFactoryId++;

  react_test_utils.renderIntoDocument(
      factory({'render': render})
  );
}

void main() {
  useHtmlConfiguration();
  setClientConfiguration();

  group('Key/children validation', () {
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

    group('warns when multiple children are passed as a list', () {
      test('when rendering DOM components', () {
        renderWithUniqueOwnerName(() =>
            react.div({}, [
              react.span({}),
              react.span({}),
              react.span({})
            ])
        );

        expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
        expect(consoleErrorMessage, contains('Each child in an array or iterator should have a unique "key" prop.'));
      });

      test('when rendering custom Dart components', () {
        renderWithUniqueOwnerName(() =>
            CustomComponent({}, [
              react.span({}),
              react.span({}),
              react.span({})
            ])
        );

        expect(consoleErrorCalled, isTrue, reason: 'should have outputted a warning');
        expect(consoleErrorMessage, contains('Each child in an array or iterator should have a unique "key" prop.'));
      });
    });

    group('does not warn when multiple children are passed as variadic args', () {
      test('when rendering DOM components', () {
        renderWithUniqueOwnerName(() =>
            react.div({},
              react.span({}),
              react.span({}),
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        renderWithUniqueOwnerName(() =>
            CustomComponent({},
              react.span({}),
              react.span({}),
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });
    });

    group('does not warn when a single child is passed', () {
      test('when rendering DOM components', () {
        renderWithUniqueOwnerName(() =>
            react.div({},
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        renderWithUniqueOwnerName(() =>
            CustomComponent({},
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });
    });
  });
}

Function CustomComponent = react.registerComponent(() => new _CustomComponent());
class _CustomComponent extends react.Component {
  @override
  render() => react.div({}, []);
}

class _OwnerHelperComponent extends react.Component {
  @override
  render() => props['render']();
}
