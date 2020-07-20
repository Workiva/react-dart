// ignore_for_file: deprecated_member_use_from_same_package
@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html' show DivElement;

import 'package:js/js.dart';
import 'package:react/react.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart' show React, ReactComponent;
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

        for (final key in eventPropKeyToEventFactory.keys) {
          props[key] = originalHandlers[key] = createHandler(key);
        }
      });

      test('for a DOM element', () {
        var component = react.div(props);
        var jsProps = unconvertJsProps(component);
        for (final key in eventPropKeyToEventFactory.keys) {
          expect(jsProps[key], isNotNull, reason: 'JS event handler prop should not be null');
          expect(jsProps[key], same(originalHandlers[key]), reason: 'JS event handler prop was not unconverted');
        }
      });

      test(', except for a JS composite component (handlers should already be unconverted)', () {
        var component = testJsComponentFactory(props);
        var jsProps = unconvertJsProps(component);
        for (final key in eventPropKeyToEventFactory.keys) {
          expect(jsProps[key], isNotNull, reason: 'JS event handler prop should not be null');
          expect(jsProps[key], same(allowInterop(originalHandlers[key])),
              reason: 'JS event handler prop was unexpectedly modified');
        }
      });
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

  group('registerComponent', () {
    test('throws with printed error', () {
      expect(() => react.registerComponent(() => ThrowsInDefaultPropsComponent()), throwsA(Error));
      expect(() {
        try {
          react.registerComponent(() => ThrowsInDefaultPropsComponent());
        } catch (_) {}
      }, prints(contains('Error when registering Component:')));
    });
  });

  group('registerComponent2', () {
    test('throws with specific error when defaultProps throws', () {
      expect(() => react.registerComponent2(() => ThrowsInDefaultPropsComponent2()), throwsA(Error));
      expect(() {
        try {
          react.registerComponent2(() => ThrowsInDefaultPropsComponent2());
        } catch (_) {}
      }, prints(contains('Error when registering Component2 when getting defaultProps')));
    });

    test('throws with specific error when propTypes throws', () {
      expect(() => react.registerComponent2(() => ThrowsInPropTypesComponent2()), throwsA(Error));
      expect(() {
        try {
          react.registerComponent2(() => ThrowsInPropTypesComponent2());
        } catch (_) {}
      }, prints(contains('Error when registering Component2 when getting propTypes')));
    });

    test('throws with generic error when something else throws', () {
      expect(() => react.registerComponent2(() => DartComponent2Component(), bridgeFactory: (component) => throw Error),
          throwsA(Error));
      expect(() {
        try {
          react.registerComponent2(() => DartComponent2Component(), bridgeFactory: (component) => throw Error);
        } catch (_) {}
      }, prints(contains('Error when registering Component2:')));
    });
  });
}

@JS()
external Function compositeComponent();

/// A factory for a JS composite component, for use in testing.
final Function testJsComponentFactory = (() {
  var reactFactory = React.createFactory(compositeComponent());

  return ([props = const {}, children]) {
    return reactFactory(jsifyAndAllowInterop(props), listifyChildren(children));
  };
})();

class ThrowsInDefaultPropsComponent extends Component {
  @override
  Map getDefaultProps() => throw Error;

  @override
  render() {
    return null;
  }
}

class ThrowsInDefaultPropsComponent2 extends Component2 {
  get defaultProps => throw Error;

  @override
  render() {
    return null;
  }
}

class ThrowsInPropTypesComponent2 extends Component2 {
  get propTypes => throw Error;

  @override
  render() {
    return null;
  }
}

class DartComponent2Component extends Component2 {
  @override
  render() {
    return null;
  }
}

ReactDartComponentFactoryProxy2 DartComponent2 = react.registerComponent(() => new DartComponent2Component());

class DartComponentComponent extends Component {
  @override
  render() {
    return null;
  }
}

ReactDartComponentFactoryProxy DartComponent = react.registerComponent(() => new DartComponentComponent());
