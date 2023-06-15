@JS()
library js_components;

import 'dart:html';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/js_interop_util.dart';
import './simple_component.dart' deferred as simple;


// Only intended for testing purposes, Please do not copy/paste this into repo.
// This will most likely be added to the PUBLIC api in the future,
// but needs more testing and Typing decisions to be made first.
ReactJsComponentFactoryProxy lazy(Future<ReactComponentFactoryProxy> factory()) => ReactJsComponentFactoryProxy(
      React.lazy(
        allowInterop(
          () => futureToPromise(
            // React.lazy only supports "default exports" from a module.
            // This `{default: yourExport}` workaround can be found in the React.lazy RFC comments.
            // See: https://github.com/reactjs/rfcs/pull/64#issuecomment-431507924
            (() async => jsify({'default': (await factory()).type}))(),
          ),
        ),
      ),
    );

main() {
  var content = wrapper({});

  react_dom.render(content, querySelector('#content'));
}

final lazyComponent = lazy(() async {
  await simple.loadLibrary();
  await Future.delayed(Duration(seconds: 5));
  return simple.SimpleComponent;
});

var wrapper = react.registerFunctionComponent(WrapperComponent, displayName: 'wrapper');

WrapperComponent(Map props) {
  return react.div({
    'id': 'lazy-wrapper'
  }, [
    react.Suspense({'fallback': 'Loading...'}, [lazyComponent({})])
  ]);
}
