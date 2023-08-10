@TestOn('browser')
import 'dart:html';

import 'package:react/react_client/react_interop.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';

main() {
  group('createRoot', () {
    group('creates a root that can be rendered into', () {
      Element mountNode;
      react_dom.ReactRoot root;

      setUp(() {
        mountNode = DivElement();
        root = react_dom.createRoot(mountNode);
      });

      tearDown(() {
        root.unmount();
      });

      test('', () {
        react_dom.ReactTestUtils.act(() => root.render(react.StrictMode({}, 'oh hai')));

        expect(mountNode.text, contains('oh hai'));
      });
    });
  });

  group('ReactDom.createPortal', () {
    group('creates a portal ReactNode that renders correctly', () {
      Element mountNode;
      react_dom.ReactRoot root;

      setUp(() {
        mountNode = DivElement();
        root = react_dom.createRoot(mountNode);
      });

      tearDown(() {
        root.unmount();
      });

      test('with simple children', () {
        final portalTargetNode = Element.div();
        final portal = ReactDom.createPortal('foo', portalTargetNode);
        react_dom.ReactTestUtils.act(() => root.render(portal));

        expect(portalTargetNode.text, contains('foo'));
      });

      test('with nested list children', () {
        final portalTargetNode = Element.div();
        final portal = ReactDom.createPortal([
          ['foo'],
          [
            'bar',
            ['baz']
          ]
        ], portalTargetNode);
        react_dom.ReactTestUtils.act(() => root.render(portal));

        expect(portalTargetNode.text, contains('foobarbaz'));
      });
    });
  });
}
