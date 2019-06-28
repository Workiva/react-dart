@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';
import 'package:react/react_client.dart';

main() {
  setClientConfiguration();

  group('Fragment', () {
    test('renders nothing but its children', () {
      var wrappingDivRef;

      react_dom.render(
        react.div({
          'ref': (ref) {
            wrappingDivRef = ref;
          }
        }, [
          react.Fragment({}, [
            react.div({}),
            react.div({}),
            react.div({}),
            react.div({}),
          ])
        ]),
        new Element.div(),
      );

      expect(wrappingDivRef.children, hasLength(4));
    });

    test('passes the key properly onto the fragment', () {
      var callCount = 0;

      var mountElement = new Element.div();

      react_dom.render(
          react.Fragment({
            'key': 1
          }, [
            FragmentTestDummy({
              'onComponentDidMount': () {
                callCount++;
              }
            })
          ]),
          mountElement);

      expect(callCount, 1);

      react_dom.render(
          react.Fragment({
            'key': 2
          }, [
            FragmentTestDummy({
              'onComponentDidMount': () {
                callCount++;
              }
            })
          ]),
          mountElement);

      expect(callCount, 2, reason: 'Dummy should have been remounted as a result of Fragment key changing');
    });
  });
}

class _FragmentTestDummy extends react.Component2 {
  @override
  componentDidMount() {
    props['onComponentDidMount']();
  }

  render() {
    return react.button(props, 'hi');
  }
}

ReactDartComponentFactoryProxy2 FragmentTestDummy = react.registerComponent(() => new _FragmentTestDummy());
