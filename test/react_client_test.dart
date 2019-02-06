@TestOn('browser')
library react_test_utils_test;

import 'dart:html' show DivElement;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react show div;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart' show React, ReactClassConfig, ReactComponent;
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/src/react_client/event_prop_key_to_event_factory.dart';

main() {
  setClientConfiguration();

  group('unconvertJsProps', () {
    const List testChildren = const ['child1', 'child2'];
    const Map<String, dynamic> testStyle = const {'background': 'white'};

    test('returns props for a composite JS component ReactElement', () {
      ReactElement instance = testJsComponentFactory({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren);

      expect(unconvertJsProps(instance), equals({
        'jsProp': 'js',
        'style': testStyle,
        'children': testChildren
      }));
    });

    test('returns props for a composite JS ReactComponent', () {
      var mountNode = new DivElement();
      ReactComponent renderedInstance = react_dom.render(testJsComponentFactory({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren), mountNode);

      expect(unconvertJsProps(renderedInstance), equals({
        'jsProp': 'js',
        'style': testStyle,
        'children': testChildren
      }));
    });

    test('returns props for a composite JS ReactComponent, even when the props change', () {
      var mountNode = new DivElement();
      ReactComponent renderedInstance = react_dom.render(testJsComponentFactory({
        'jsProp': 'js',
        'style': testStyle,
      }, testChildren), mountNode);

      expect(unconvertJsProps(renderedInstance), equals({
        'jsProp': 'js',
        'style': testStyle,
        'children': testChildren
      }));

      renderedInstance = react_dom.render(testJsComponentFactory({
        'jsProp': 'other js',
        'style': testStyle,
      }, testChildren), mountNode);

      expect(unconvertJsProps(renderedInstance), equals({
        'jsProp': 'other js',
        'style': testStyle,
        'children': testChildren
      }));
    });

    test('returns props for a DOM component ReactElement', () {
      ReactElement instance = react.div({
        'domProp': 'dom',
        'style': testStyle,
      }, testChildren);

      expect(unconvertJsProps(instance), equals({
        'domProp': 'dom',
        'style': testStyle,
        'children': testChildren
      }));
    });

    test('should unconvert JS event handlers', () {
      var genericEventHandler = (_) {};
      var props = new Map.fromIterable(eventPropKeyToEventFactory.keys, value: (key) {
        return genericEventHandler;
      });
      var component = react.div(props);
      var jsProps = unconvertJsProps(component);
      for (final key in eventPropKeyToEventFactory.keys) {
        expect(identical(jsProps[key], genericEventHandler), isTrue);
      }
    });
  });

  group('unconvertJsEventHandler', () {
    test('returns null when the input is null', () {
      var result;
      expect(() {
        result = unconvertJsEventHandler(null);
      }, returnsNormally);

      expect(result, isNull);
    });
  });
}

/// A factory for a JS composite component, for use in testing.
final Function testJsComponentFactory = (() {
  var componentClass = React.createClass(new ReactClassConfig(
    displayName: 'testJsComponent',
    render: allowInterop(() => react.div({}, 'test js component'))
  ));

  var reactFactory = React.createFactory(componentClass);

  return ([props = const {}, children]) {
    return reactFactory(jsify(props), listifyChildren(children));
  };
})();