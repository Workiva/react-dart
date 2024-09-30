@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';

import './react_suspense_lazy_component.dart' deferred as simple;

main() {
  group('Suspense', () {
    test('renders fallback UI first followed by the real component', () async {
      final lazyComponent = react.lazy(() async {
        await simple.loadLibrary();
        await Future.delayed(Duration(seconds: 1));
        return simple.SimpleFunctionComponent;
      });
      var wrappingDivRef;
      final mountElement = Element.div();
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
      final lazyComponent = react.lazy(() async {
        await simple.loadLibrary();
        await Future.delayed(Duration(seconds: 1));
        return simple.SimpleFunctionComponent;
      });
      var wrappingDivRef;
      var wrappingDivRef2;
      final mountElement = Element.div();
      final mountElement2 = Element.div();

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
