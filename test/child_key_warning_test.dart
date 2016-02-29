import 'dart:js';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;

void main() {
  useHtmlConfiguration();
  setClientConfiguration();

  void render(JsObject reactElement) {
    react_test_utils.renderIntoDocument(reactElement);
  }

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
        render(
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
        render(
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
        render(
            react.div({},
              react.span({}),
              react.span({}),
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        render(
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
        render(
            react.div({},
              react.span({})
            )
        );

        expect(consoleErrorCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        render(
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
  render() => react.div({}, []);
}
