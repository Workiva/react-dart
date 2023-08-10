@TestOn('browser')
import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';

main() {
  group('StrictMode', () {
    test('renders nothing but its children', () {
      final wrappingDivRef = react.createRef<Element>();
      final root = react_dom.createRoot(Element.div());

      react_dom.ReactTestUtils.act(() => root.render(
            react.div({
              'ref': wrappingDivRef
            }, [
              react.StrictMode({}, [
                react.div({}),
                react.div({}),
                react.div({}),
                react.div({}),
              ])
            ]),
          ));

      expect(wrappingDivRef.current.children, hasLength(4));
    });
  });
}
