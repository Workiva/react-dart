// ignore_for_file: deprecated_member_use_from_same_package
@TestOn('browser')
import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart';
import 'package:react/src/typedefs.dart';
import 'package:test/test.dart';

void main() {
  // These tests redundantly test some React behavior, but mostly serve to validate that
  // all supported inputs/outputs are handled properly by the Dart bindings and their typings.
  group('react_dom entrypoint APIs:', () {
    group('render', () {
      group(
          'accepts and renders content of different supported types,'
          ' and returns a representation of what was mounted', () {
        test('ReactElement for a DOM component', () {
          final mountNode = DivElement();
          final result = react_dom.render(react.button({}, 'test button'), mountNode);
          expect(mountNode.children, [isA<ButtonElement>()]);
          expect(mountNode.children.single.innerText, 'test button');
          expect(result, isA<ButtonElement>());
        });

        test('ReactElement for a class component', () {
          final mountNode = DivElement();
          final result = react_dom.render(classComponent({}), mountNode);
          expect(mountNode.innerText, 'class component content');
          expect(result, isA<ReactComponent>().having((c) => c.dartComponent, 'dartComponent', isA<_ClassComponent>()));
        });

        test('ReactElement for a function component', () {
          final mountNode = DivElement();
          final result = react_dom.render(functionComponent({}), mountNode);
          expect(mountNode.innerText, 'function component content');
          expect(result, isNull);
        });

        group('other "ReactNode" types:', () {
          test('string', () {
            final mountNode = DivElement();
            final result = react_dom.render('test string', mountNode);
            expect(mountNode.innerText, 'test string');
            expect(result, isA<Node>());
          });

          test('lists and nested lists', () {
            final mountNode = DivElement();
            final result = react_dom.render([
              'test string',
              ['test string 2', react.span({}, 'test span')]
            ], mountNode);
            expect(mountNode.innerText, 'test string' 'test string 2' 'test span');
            expect(result, isA<Node>());
          });

          test('number', () {
            final mountNode = DivElement();
            final result = react_dom.render(123, mountNode);
            expect(mountNode.innerText, '123');
            expect(result, isA<Node>());
          });

          test('false', () {
            final mountNode = DivElement();
            react_dom.render(react.span({}, 'test content that will be cleared'), mountNode);
            expect(mountNode.innerText, 'test content that will be cleared');
            final result = react_dom.render(false, mountNode);
            expect(mountNode.innerText, isEmpty);
            expect(result, isNull);
          });

          test('null', () {
            final mountNode = DivElement();
            react_dom.render(react.span({}, 'test content that will be cleared'), mountNode);
            expect(mountNode.innerText, 'test content that will be cleared');
            final result = react_dom.render(null, mountNode);
            expect(mountNode.innerText, isEmpty);
            expect(result, isNull);
          });
        });
      });
    });

    group('unmountComponentAtNode', () {
      test('unmounts a React tree at a node, and returns true to indicate it has unmounted', () {
        final mountNode = DivElement();
        react_dom.render(react.span({}), mountNode);
        final result = react_dom.unmountComponentAtNode(mountNode);
        expect(result, isTrue);
      });

      test('returns false when a React tree has already been unmounted', () {
        final mountNode = DivElement();
        react_dom.render(react.span({}), mountNode);
        final result = react_dom.unmountComponentAtNode(mountNode);
        expect(result, isTrue, reason: 'test setup check');
        final secondUnmountResult = react_dom.unmountComponentAtNode(mountNode);
        expect(secondUnmountResult, isFalse);
      });

      test('returns false when no React tree has been mounted within a node', () {
        final result = react_dom.unmountComponentAtNode(DivElement());
        expect(result, isFalse);
      });
    });

    group('findDOMNode', () {
      group('returns the mounted element when provided', () {
        test('a Dart class component instance', () {
          final ref = createRef<_ClassComponent>();
          renderIntoDocument(classComponent({'ref': ref}));
          final dartComponentInstance = ref.current;
          expect(dartComponentInstance, isNotNull, reason: 'test setup check');
          dartComponentInstance!;
          expect(react_dom.findDOMNode(dartComponentInstance), isA<AnchorElement>());
        });

        test('a JS class component instance', () {
          final ref = createRef<_ClassComponent>();
          renderIntoDocument(classComponent({'ref': ref}));
          final jsComponentInstance = ref.current!.jsThis;
          expect(jsComponentInstance, isNotNull, reason: 'test setup check');
          expect(react_dom.findDOMNode(jsComponentInstance), isA<AnchorElement>());
        });

        test('an element representing a mounted component', () {
          final ref = createRef<SpanElement>();
          renderIntoDocument(react.span({'ref': ref}));
          final element = ref.current;
          expect(element, isNotNull, reason: 'test setup check');
          element!;
          expect(react_dom.findDOMNode(element), same(element));
        });
      });

      test('returns null when a component does not render any content', () {
        final ref = createRef<_ClassComponentThatRendersNothing>();
        renderIntoDocument(classComponentThatRendersNothing({'ref': ref}));
        final dartComponentInstance = ref.current;
        expect(dartComponentInstance, isNotNull, reason: 'test setup check');
        dartComponentInstance!;
        expect(react_dom.findDOMNode(dartComponentInstance), isNull);
      });

      test('passes through a non-React-mounted element', () {
        final element = DivElement();
        expect(react_dom.findDOMNode(element), same(element));
      });

      test('passes through null', () {
        expect(react_dom.findDOMNode(null), isNull);
      });

      group('throws when passed other objects that don\'t represent mounted React components', () {
        test('arbitrary Dart objects', () {
          expect(() => react_dom.findDOMNode(Object()),
              throwsA(isA<Object>().havingToStringValue(contains('Argument appears to not be a ReactComponent'))));
        });

        test('ReactElement', () {
          expect(() => react_dom.findDOMNode(react.span({})),
              throwsA(isA<Object>().havingToStringValue(contains('Argument appears to not be a ReactComponent'))));
        });
      });
    });
  });
}

final classComponent = react.registerComponent2(() => _ClassComponent());

class _ClassComponent extends react.Component2 {
  @override
  ReactNode render() => react.a({}, 'class component content');
}

final classComponentThatRendersNothing = react.registerComponent2(() => _ClassComponentThatRendersNothing());

class _ClassComponentThatRendersNothing extends react.Component2 {
  @override
  ReactNode render() => null;
}

final functionComponent = react.registerFunctionComponent((props) {
  return react.pre({}, 'function component content');
});

extension<T> on TypeMatcher<T> {
  TypeMatcher<T> havingToStringValue(dynamic matcher) => having((o) => o.toString(), 'toString() value', matcher);
}
