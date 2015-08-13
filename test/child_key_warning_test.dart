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
    bool consoleWarnCalled;
    var consoleWarnMessage;
    JsFunction originalConsoleWarn;

    setUp(() {
      consoleWarnCalled = false;
      consoleWarnMessage = null;

      originalConsoleWarn = context['console']['warn'];
      context['console']['warn'] = new JsFunction.withThis((self, message) {
        consoleWarnCalled = true;
        consoleWarnMessage = message;

        originalConsoleWarn.apply([message], thisArg: self);
      });
    });

    tearDown(() {
      context['console']['warn'] = originalConsoleWarn;
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

        expect(consoleWarnCalled, isTrue, reason: 'should have outputted a warning');
        expect(consoleWarnMessage, contains('Each child in an array or iterator should have a unique "key" prop.'));
      });

      test('when rendering custom Dart components', () {
        render(
            CustomComponent({}, [
              react.span({}),
              react.span({}),
              react.span({})
            ])
        );

        expect(consoleWarnCalled, isTrue, reason: 'should have outputted a warning');
        expect(consoleWarnMessage, contains('Each child in an array or iterator should have a unique "key" prop.'));
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

        expect(consoleWarnCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        render(
            CustomComponent({},
              react.span({}),
              react.span({}),
              react.span({})
            )
        );

        expect(consoleWarnCalled, isFalse, reason: 'should not have outputted a warning');
      });
    });

    group('does not warn when a single child is passed', () {
      test('when rendering DOM components', () {
        render(
            react.div({},
              react.span({})
            )
        );

        expect(consoleWarnCalled, isFalse, reason: 'should not have outputted a warning');
      });

      test('when rendering custom Dart components', () {
        render(
            CustomComponent({},
              react.span({})
            )
        );

        expect(consoleWarnCalled, isFalse, reason: 'should not have outputted a warning');
      });
    });
  });
}

Function CustomComponent = react.registerComponent(() => new _CustomComponent());
class _CustomComponent extends react.Component {
  render() => react.div({}, []);
}
