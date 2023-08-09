@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/js_interop_util.dart';
import 'package:test/test.dart';

import './react_suspense_lazy_component.dart' deferred as simple;

@JS('React.lazy')
external ReactClass jsLazy(Promise Function() factory);

// Only intended for testing purposes, Please do not copy/paste this into repo.
// This will most likely be added to the PUBLIC api in the future,
// but needs more testing and Typing decisions to be made first.
ReactJsComponentFactoryProxy lazy(Future<ReactComponentFactoryProxy> factory()) => ReactJsComponentFactoryProxy(
      jsLazy(
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
  group('Suspense', () {
    test('renders fallback UI first followed by the real component', () async {
      final lazyComponent = lazy(() async {
        await simple.loadLibrary();
        await Future.delayed(Duration(seconds: 1));
        return simple.SimpleFunctionComponent;
      });
      var wrappingDivRef;
      var mountElement = Element.div();
      react_dom.render(
        react.div({
          'ref': (ref) {
            wrappingDivRef = ref;
          }
        }, [
          react.Suspense({
            'fallback': react.span({'id': 'loading'}, 'Loading...')
          }, [
            lazyComponent({})
          ])
        ]),
        mountElement,
      );

      expect(wrappingDivRef.querySelector('#loading'), isNotNull,
          reason: 'It should be showing the fallback UI for 2 seconds.');
      expect(wrappingDivRef.querySelector('#simple-component'), isNull,
          reason: 'This component should not be present yet.');
      await Future.delayed(Duration(seconds: 2));
      expect(wrappingDivRef.querySelector('#simple-component'), isNotNull,
          reason: 'This component should be present now.');
      expect(wrappingDivRef.querySelector('#loading'), isNull, reason: 'The loader should have hidden.');
    });

    test('is instant after the lazy component has been loaded once', () async {
      final lazyComponent = lazy(() async {
        await simple.loadLibrary();
        await Future.delayed(Duration(seconds: 1));
        return simple.SimpleFunctionComponent;
      });
      var wrappingDivRef;
      var wrappingDivRef2;
      var mountElement = Element.div();
      var mountElement2 = Element.div();

      react_dom.render(
        react.div({
          'ref': (ref) {
            wrappingDivRef = ref;
          }
        }, [
          react.Suspense({
            'fallback': react.span({'id': 'loading'}, 'Loading...')
          }, [
            lazyComponent({})
          ])
        ]),
        mountElement,
      );

      expect(wrappingDivRef.querySelector('#loading'), isNotNull,
          reason: 'It should be showing the fallback UI for 2 seconds.');
      expect(wrappingDivRef.querySelector('#simple-component'), isNull,
          reason: 'This component should not be present yet.');
      await Future.delayed(Duration(seconds: 2));
      expect(wrappingDivRef.querySelector('#simple-component'), isNotNull,
          reason: 'This component should be present now.');
      expect(wrappingDivRef.querySelector('#loading'), isNull, reason: 'The loader should have hidden.');

      // Mounting to a new element should be instant since it was already loaded before
      react_dom.render(
        react.div({
          'ref': (ref) {
            wrappingDivRef2 = ref;
          }
        }, [
          react.Suspense({
            'fallback': react.span({'id': 'loading'}, 'Loading...')
          }, [
            lazyComponent({})
          ])
        ]),
        mountElement2,
      );
      expect(wrappingDivRef2.querySelector('#simple-component'), isNotNull,
          reason: 'Its already been loaded, so this should appear instantly.');
      expect(wrappingDivRef2.querySelector('#loading'), isNull,
          reason: 'Its already been loaded, so the loading UI shouldn\'t show.');
    });
  });
}
