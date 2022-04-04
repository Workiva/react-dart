@TestOn('browser')
import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';

main() {
  group('Fragment', () {
    test('renders nothing but its children', () {
      final wrappingDivRef = react.createRef<Element>();
      final root = react_dom.createRoot(DivElement());

      react_dom.ReactTestUtils.act(() => root.render(react.div({
            'ref': wrappingDivRef
          }, [
            react.Fragment({}, [
              react.div({}),
              react.div({}),
              react.div({}),
              react.div({}),
            ])
          ])));

      expect(wrappingDivRef.current.children, hasLength(4));
    });

    test('passes the key properly onto the fragment', () {
      var callCount = 0;
      final root = react_dom.createRoot(DivElement());

      react_dom.ReactTestUtils.act(() => root.render(react.Fragment({
            'key': 1
          }, [
            FragmentTestDummy({
              'onComponentDidMount': () {
                callCount++;
              }
            })
          ])));

      expect(callCount, 1);

      react_dom.ReactTestUtils.act(() => root.render(react.Fragment({
            'key': 2
          }, [
            FragmentTestDummy({
              'onComponentDidMount': () {
                callCount++;
              }
            })
          ])));

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

final FragmentTestDummy = react.registerComponent2(() => new _FragmentTestDummy());
