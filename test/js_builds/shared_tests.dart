// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library js_function_test;

import 'dart:html';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/react_client/internal_react_interop.dart';
import 'package:test/test.dart';

void verifyJsFileLoaded(String filename) {
  final isLoaded = document.getElementsByTagName('script').any((script) {
    return Uri.parse((script as ScriptElement).src).pathSegments.last == filename;
  });

  if (!isLoaded) throw Exception('$filename is not loaded');
}

void sharedJsFunctionTests() {
  group('JS functions:', () {
    group('markChildValidated', () {
      test('is function that does not throw when called', () {
        expect(() => markChildValidated(newObject()), returnsNormally);
      });
    });

    group('createReactDartComponentClass', () {
      test('is a function that does not throw when called (indirectly tested by registering a Component)', () {
        expect(() => react.registerComponent(() => DummyComponent()), returnsNormally);
      });
    });

    group('createReactDartComponentClass2', () {
      test('is function that does not throw when called (indirectly tested by registering a Component2)', () {
        expect(() => react.registerComponent(() => DummyComponent2()), returnsNormally);
      });
    });
  });
}

class DummyComponent extends react.Component {
  @override
  render() => null;
}

class DummyComponent2 extends react.Component2 {
  @override
  render() => null;
}

/// The arguments corresponding to each call of `console.warn`,
/// collected via a spy set up in console_spy_include_this_js_first.js
@JS()
external List<List<Object?>> consoleWarnCalls;

/// The arguments corresponding to each call of `console.warn`,
/// collected via a spy set up in console_spy_include_this_js_first.js
@JS()
external List<List<Object?>> consoleErrorCalls;

/// Like window.console.warn, but allows more than one argument.
@JS('console.warn')
external void consoleWarn([a, b, c, d]);

/// Like window.console.warn, but allows more than one argument.
@JS('console.error')
external void consoleError([a, b, c, d]);

void sharedConsoleFilteringTests({required bool expectDeduplicateSyntheticEventWarnings}) {
  group('console.error wrapper (or lack thereof)', () {
    void clearConsoleErrorCalls() => consoleErrorCalls = [];

    setUp(clearConsoleErrorCalls);

    test('errors as expected with any number of arguments', () {
      consoleError('foo');
      consoleError('foo', 'bar', 'baz');
      consoleError();
      expect(consoleErrorCalls, [
        ['foo'],
        ['foo', 'bar', 'baz'],
        [],
      ]);
    });

    // Test this explicitly since we inspect the first arg in the filtering logic
    test('has no issues when the first arg isn\'t a string', () {
      consoleError(); // "undefined" first arg
      consoleError(1);
      consoleError(null);
      consoleError(jsify({}));
      expect(consoleErrorCalls, [
        [],
        [1],
        [null],
        [anything],
      ]);
    });

    test('filters out react_dom.render deprecation warnings (emitted via console.error)', () {
      final mountNode = DivElement();
      react_dom.render(react.span({}, 'test button'), mountNode);
      expect(consoleErrorCalls, isEmpty);
    });

    test('logs other duplicate messages properly', () {
      consoleError('foo');
      consoleError('foo');
      consoleError('bar');
      consoleError('foo');

      expect(consoleErrorCalls, [
        ['foo'],
        ['foo'],
        ['bar'],
        ['foo'],
      ]);
    });
  });
}

void sharedErrorBoundaryComponentNameTests() {
  group('includes the Dart component displayName in error boundary errors for', () {
    void expectRenderErrorWithComponentName(ReactElement element, {required String expectedComponentName}) {
      final capturedInfos = <ReactErrorInfo>[];
      react_dom.render(
          _ErrorBoundary({
            'onComponentDidCatch': (dynamic error, ReactErrorInfo info) {
              capturedInfos.add(info);
            }
          }, element),
          DivElement());
      expect(capturedInfos, hasLength(1), reason: 'test setup check; should have captured a single component error');
      expect(capturedInfos[0].componentStack, contains('at $expectedComponentName'));
    }

    test('Component components', () {
      expectRenderErrorWithComponentName(
        _ThrowingComponent({}),
        expectedComponentName: r'DisplayName$_ThrowingComponent',
      );
    });

    test('Component2 components', () {
      expectRenderErrorWithComponentName(
        _ThrowingComponent2({}),
        expectedComponentName: r'DisplayName$_ThrowingComponent2',
      );
    });

    test('function components', () {
      expectRenderErrorWithComponentName(
        _ThrowingFunctionComponent({}),
        expectedComponentName: r'DisplayName$_ThrowingFunctionComponent',
      );
    });

    test('forwardRef function components', () {
      expectRenderErrorWithComponentName(
        _ThrowingForwardRefFunctionComponent({}),
        expectedComponentName: r'DisplayName$_ThrowingForwardRefFunctionComponent',
      );
    });
  });
}

final _ErrorBoundary = react.registerComponent2(() => _ErrorBoundaryComponent(), skipMethods: []);

class _ErrorBoundaryComponent extends react.Component2 {
  @override
  get initialState => {'hasError': false};

  @override
  getDerivedStateFromError(dynamic error) => {'hasError': true};

  @override
  componentDidCatch(dynamic error, ReactErrorInfo info) {
    props['onComponentDidCatch'](error, info);
  }

  @override
  render() {
    return (state['hasError'] as bool) ? null : props['children'];
  }
}

final _ThrowingComponent =
    react.registerComponent(() => _ThrowingComponentComponent()) as ReactDartComponentFactoryProxy;

class _ThrowingComponentComponent extends react.Component {
  @override
  get displayName => r'DisplayName$_ThrowingComponentComponent';

  @override
  render() {
    throw Exception();
  }
}

final _ThrowingComponent2 = react.registerComponent2(() => _ThrowingComponent2Component());

class _ThrowingComponent2Component extends react.Component2 {
  @override
  get displayName => r'DisplayName$_ThrowingComponent2Component';

  @override
  render() {
    throw Exception();
  }
}

final _ThrowingFunctionComponent = react.registerFunctionComponent(
  (props) {
    throw Exception();
  },
  displayName: r'DisplayName$_ThrowingFunctionComponent',
);

final _ThrowingForwardRefFunctionComponent = react.forwardRef2(
  (props, ref) {
    throw Exception();
  },
  displayName: r'DisplayName$_ThrowingForwardRefFunctionComponent',
);
