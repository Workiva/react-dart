import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;

const containerStyle = {
  'border': '1px solid black',
  'margin': 8,
  'padding': 8,
};

void main() {
  final content = react.div(
    {},
    _ErrorBoundary(
      {
        'onComponentDidCatch': (dynamic error, ReactErrorInfo info) {
          print('componentDidCatch: info.componentStack ${info.componentStack}');
        },
      },
      react.div(
        {'style': containerStyle},
        '(Inside an error boundary)',
        _ThrowingComponent({}),
      ),
    ),
    _ErrorBoundary(
      {},
      react.div(
        {'style': containerStyle},
        '(Outside an error boundary)',
        _ThrowingComponent({}),
      ),
    ),
  );

  react_dom.render(content, querySelector('#content'));
}

final _ErrorBoundary = react.registerComponent2(() => _ErrorBoundaryComponent(), skipMethods: []);

class _ErrorBoundaryComponent extends react.Component2 {
  @override
  Map get initialState => {'hasError': false};

  @override
  getDerivedStateFromError(dynamic error) => {'hasError': true};

  @override
  componentDidCatch(dynamic error, ReactErrorInfo info) {
    props['onComponentDidCatch']?.call(error, info);
  }

  @override
  render() {
    return (state['hasError'] as bool) ? 'Error boundary caught an error' : props['children'];
  }
}

final _ThrowingComponent = react.registerComponent2(() => _ThrowingComponentComponent2());

class _ThrowingComponentComponent2 extends react.Component2 {
  @override
  Map get initialState => {'shouldThrow': false};

  @override
  render() {
    if (state['shouldThrow'] as bool) {
      throw Exception();
    }

    return react.button({
      'type': 'button',
      'onClick': (_) {
        setState({'shouldThrow': true});
      }
    }, 'Click me to throw');
  }
}
