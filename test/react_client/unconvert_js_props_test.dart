@TestOn('browser')
import 'dart:html' show DivElement;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/component_factory.dart';
import 'package:react/react_client/react_interop.dart' show ReactComponent;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/react_client/event_prop_key_to_event_factory.dart';

import 'util.dart';

main() {
  group('unconvertJsProps', () {
    const List testChildren = const ['child1', 'child2'];
    const Map<String, dynamic> testStyle = const {'background': 'white'};

    test('returns props for a composite JS component ReactElement', () {
      ReactElement instance = testJsComponentFactory({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren);

      expect(
        unconvertJsProps(instance),
        equals({
          'jsProp': 'js',
          'style': testStyle,
          'children': testChildren,
        }),
      );
      expect(unconvertJsProps(instance)['style'], isA<Map<String, dynamic>>());
    });

    test('throws when a Dart component (Component2) is passed in', () {
      final instance = DartComponent2({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren);

      expect(() => unconvertJsProps(instance), throwsArgumentError);
    });

    test('throws when a Dart component is passed in', () {
      final instance = DartComponent({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren);

      expect(() => unconvertJsProps(instance), throwsArgumentError);
    });

    test('returns props for a composite JS ReactComponent', () {
      var mountNode = new DivElement();
      // ignore: deprecated_member_use_from_same_package
      ReactComponent renderedInstance = react_dom.render(
          testJsComponentFactory({
            'jsProp': 'js',
            'style': testStyle,
          }, testChildren),
          mountNode);

      expect(
        unconvertJsProps(renderedInstance),
        equals({
          'jsProp': 'js',
          'style': testStyle,
          'children': testChildren,
        }),
      );
    });

    test('returns props for a composite JS ReactComponent, even when the props change', () {
      var mountNode = new DivElement();
      // ignore: deprecated_member_use_from_same_package
      ReactComponent renderedInstance = react_dom.render(
          testJsComponentFactory({
            'jsProp': 'js',
            'style': testStyle,
          }, testChildren),
          mountNode);

      expect(
        unconvertJsProps(renderedInstance),
        equals({
          'jsProp': 'js',
          'style': testStyle,
          'children': testChildren,
        }),
      );

      // ignore: deprecated_member_use_from_same_package
      renderedInstance = react_dom.render(
          testJsComponentFactory({
            'jsProp': 'other js',
            'style': testStyle,
          }, testChildren),
          mountNode);

      expect(
          unconvertJsProps(renderedInstance),
          equals({
            'jsProp': 'other js',
            'style': testStyle,
            'children': testChildren,
          }));
    });

    test('returns props for a DOM component ReactElement', () {
      ReactElement instance = react.div({
        'domProp': 'dom',
        'style': testStyle,
      }, testChildren);

      expect(
          unconvertJsProps(instance),
          equals({
            'domProp': 'dom',
            'style': testStyle,
            'children': testChildren,
          }));
    });

    group('should unconvert JS event handlers', () {
      Function createHandler(eventKey) => (_) {
            print(eventKey);
          };
      Map<String, Function> originalHandlers;
      Map props;

      setUp(() {
        originalHandlers = {};
        props = {};

        for (final key in knownEventKeys) {
          props[key] = originalHandlers[key] = createHandler(key);
        }
      });

      test('for a DOM element', () {
        var component = react.div(props);
        var jsProps = unconvertJsProps(component);
        for (final key in knownEventKeys) {
          expect(jsProps[key], isNotNull, reason: 'JS event handler prop should not be null');
          expect(jsProps[key], anyOf(same(originalHandlers[key]), same(allowInterop(originalHandlers[key]))),
              reason: 'JS event handler should be the original or original wrapped in allowInterop');
        }
      });

      test(', except for a JS composite component (handlers should already be unconverted)', () {
        var component = testJsComponentFactory(props);
        var jsProps = unconvertJsProps(component);
        for (final key in knownEventKeys) {
          expect(jsProps[key], isNotNull, reason: 'JS event handler prop should not be null');
          expect(jsProps[key], same(allowInterop(originalHandlers[key])),
              reason: 'JS event handler prop was unexpectedly modified');
        }
      });
    });
  });
}
