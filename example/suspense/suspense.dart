@JS()
library example.suspense.suspense;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import './simple_component.dart' deferred as simple;

main() {
  final content = wrapper({});

  react_dom.render(content, querySelector('#content')!);
}

final lazyComponent = react.lazy(() async {
  await Future.delayed(Duration(seconds: 5));
  await simple.loadLibrary();

  return simple.SimpleComponent;
});

var wrapper = react.registerFunctionComponent(WrapperComponent, displayName: 'wrapper');

WrapperComponent(Map props) {
  final showComponent = useState(false);
  return react.div({
    'id': 'lazy-wrapper'
  }, [
    react.button({
      'onClick': (_) {
        showComponent.set(!showComponent.value);
      }
    }, 'Toggle component'),
    react.Suspense({'fallback': 'Loading...'}, showComponent.value ? lazyComponent({}) : null)
  ]);
}
