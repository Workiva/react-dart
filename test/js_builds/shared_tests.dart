// ignore_for_file: deprecated_member_use_from_same_package
@JS()
library js_function_test;

import 'dart:html';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client/react_interop.dart';
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
      test('is function that does not throw when called', () {
        expect(() => createReactDartComponentClass(null, null), returnsNormally);
      });
    });

    group('createReactDartComponentClass2', () {
      test('is function that does not throw when called', () {
        expect(() => createReactDartComponentClass2(null, null, JsComponentConfig2(skipMethods: [])), returnsNormally);
      });
    });
  });
}

/// The arguments corresponding to each call of `console.warn`,
/// collected via a spy set up in console_spy_include_this_js_first.js
@JS()
external List<List<dynamic>> get consoleWarnCalls;
@JS()
external set consoleWarnCalls(List<dynamic> value);

/// Like window.console.warn, but allows more than one argument.
@JS('console.warn')
external void consoleWarn([a, b, c, d]);

void sharedConsoleWarnTests({@required bool expectDeduplicateSyntheticEventWarnings}) {
  group('console.warn wrapper (or lack thereof)', () {
    void clearConsoleWarnCalls() => consoleWarnCalls = [];

    setUp(clearConsoleWarnCalls);

    test('warns as expected with any number of arguments', () {
      consoleWarn('foo');
      consoleWarn('foo', 'bar', 'baz');
      consoleWarn();
      expect(consoleWarnCalls, [
        ['foo'],
        ['foo', 'bar', 'baz'],
        [],
      ]);
    });

    // Test this explicitly since we inspect the first arg in the filtering logic
    test('has no issues when the first arg isn\'t a string', () {
      consoleWarn(); // "undefined" first arg
      consoleWarn(1);
      consoleWarn(null);
      consoleWarn(jsify({}));
      expect(consoleWarnCalls, [
        [],
        [1],
        [null],
        [anything],
      ]);
    });

    void triggerRealDdcSyntheticEventWarning<T extends react.SyntheticEvent>() {
      if (T == react.SyntheticEvent) {
        throw ArgumentError('T must a subclass of SyntheticEvent, not SyntheticEvent itself, for this to reproduce.');
      }

      // Adapted from reduced test case in https://github.com/dart-lang/sdk/issues/43939
      // ignore: prefer_function_declarations_over_variables
      final function = (react.SyntheticEvent event) {} as dynamic;
      // ignore: unused_local_variable
      final function2 = function as dynamic Function(T);
    }

    group('(DDC only)', () {
      if (expectDeduplicateSyntheticEventWarnings) {
        test(
            'only logs DDC issues related to SyntheticEvent typing once,'
            ' and also logs a helpful message (integration test)', () {
          triggerRealDdcSyntheticEventWarning<react.SyntheticMouseEvent>();
          expect(consoleWarnCalls, [
            ['Cannot find native JavaScript type (SyntheticMouseEvent) for type check'],
            [
              'The above warning is expected and is the result of a workaround to https://github.com/dart-lang/sdk/issues/43939'
            ],
          ]);

          clearConsoleWarnCalls();
          triggerRealDdcSyntheticEventWarning<react.SyntheticMouseEvent>();
          triggerRealDdcSyntheticEventWarning<react.SyntheticKeyboardEvent>();
          triggerRealDdcSyntheticEventWarning<react.SyntheticKeyboardEvent>();
          triggerRealDdcSyntheticEventWarning<react.SyntheticMouseEvent>();
          expect(consoleWarnCalls, []);
        });
      } else {
        test('does not attempt to deduplicate SyntheticEvent typing logs', () {
          triggerRealDdcSyntheticEventWarning<react.SyntheticMouseEvent>();
          triggerRealDdcSyntheticEventWarning<react.SyntheticKeyboardEvent>();
          expect(consoleWarnCalls, [
            ['Cannot find native JavaScript type (SyntheticMouseEvent) for type check'],
            ['Cannot find native JavaScript type (SyntheticEvent) for type check'],
            ['Cannot find native JavaScript type (SyntheticKeyboardEvent) for type check'],
            ['Cannot find native JavaScript type (SyntheticEvent) for type check'],
          ]);
        });
      }
    }, tags: ['no-dart2js', 'no-sdk-2-14-plus']);

    test('logs other duplicate messages properly', () {
      consoleWarn('foo');
      consoleWarn('foo');
      consoleWarn('bar');
      consoleWarn('foo');

      expect(consoleWarnCalls, [
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
    void expectRenderErrorWithComponentName(ReactElement element, {@required String expectedComponentName}) {
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
  Map get initialState => {'hasError': false};

  @override
  Map getDerivedStateFromError(dynamic error) => {'hasError': true};

  @override
  void componentDidCatch(dynamic error, ReactErrorInfo info) {
    props['onComponentDidCatch'](error, info);
  }

  @override
  render() {
    return (state['hasError'] as bool) ? null : props['children'];
  }
}

final _ThrowingComponent = react.registerComponent(() => _ThrowingComponentComponent());

class _ThrowingComponentComponent extends react.Component {
  @override
  String get displayName => r'DisplayName$_ThrowingComponentComponent';

  @override
  render() {
    throw Exception();
  }
}

final _ThrowingComponent2 = react.registerComponent2(() => _ThrowingComponent2Component());

class _ThrowingComponent2Component extends react.Component2 {
  @override
  String get displayName => r'DisplayName$_ThrowingComponent2Component';

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
