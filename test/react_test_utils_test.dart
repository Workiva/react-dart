@TestOn('browser')
@JS()
library react_test_utils_test;

import 'dart:html';

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart';
import 'package:test/test.dart';

import 'test_components.dart';


void main() {

  setClientConfiguration();

  var component;
  Element domNode;

  tearDown(() {
    component = null;
    domNode = null;
  });

  group('Shallow Rendering', () {
    ReactElement content;
    ReactShallowRenderer shallowRenderer;

    Map getProps(ReactElement element) {
      var props = element.props;

      return new Map.fromIterable(_objectKeys(props),
          value: (key) => getProperty(props, key));
    }

    setUp(() {
      content = sampleComponent({'className': 'test', 'id': 'createRendererTest'});

      shallowRenderer = createRenderer();
    });

    tearDown(() {
      ReactElement renderedOutput = shallowRenderer.getRenderOutput();
      var props = getProps(renderedOutput);

      expect(props['className'], 'test');
      expect(props['id'], 'createRendererTest');
    });

    test('without context', () {
      shallowRenderer.render(content);
    });

    test('with context', () {
      shallowRenderer.render(content, {});
    });
  });

  group('Simulate', () {
    setUp(() {
      component = renderIntoDocument(eventComponent({}));
      domNode = react_dom.findDOMNode(component);
      expect(domNode.text, equals(''));
    });

    void testEvent(void event(dynamic instanceOrNode, Map eventData), String eventName) {
      Map eventData;
      int fakeTimeStamp;

      setUp(() {
        fakeTimeStamp = eventName.hashCode;
        eventData = {
          'type': eventName,
          'timeStamp': fakeTimeStamp,
        };
      });

      test('with React instance as arg', () {
        event(findRenderedDOMComponentWithTag(component, 'div'), eventData);
        expect(domNode.text, equals('$eventName $fakeTimeStamp'));
      });

      test('with DOM Element as arg', () {
        event(domNode, eventData);
        expect(domNode.text, equals('$eventName $fakeTimeStamp'));
      });
    };

    group('event', () {
      group('blur', () => testEvent(Simulate.blur, 'blur'));
      group('change', () => testEvent(Simulate.change, 'change'));
      group('click', () => testEvent(Simulate.click, 'click'));
      group('copy', () => testEvent(Simulate.copy, 'copy'));
      group('cut', () => testEvent(Simulate.cut, 'cut'));
      group('doubleClick', () => testEvent(Simulate.doubleClick, 'doubleClick'));
      group('drag', () => testEvent(Simulate.drag, 'drag'));
      group('dragEnd', () => testEvent(Simulate.dragEnd, 'dragEnd'));
      group('dragEnter', () => testEvent(Simulate.dragEnter, 'dragEnter'));
      group('dragExit', () => testEvent(Simulate.dragExit, 'dragExit'));
      group('dragLeave', () => testEvent(Simulate.dragLeave, 'dragLeave'));
      group('dragOver', () => testEvent(Simulate.dragOver, 'dragOver'));
      group('dragStart', () => testEvent(Simulate.dragStart, 'dragStart'));
      group('drop', () => testEvent(Simulate.drop, 'drop'));
      group('focus', () => testEvent(Simulate.focus, 'focus'));
      group('input', () => testEvent(Simulate.input, 'input'));
      group('keyDown', () => testEvent(Simulate.keyDown, 'keyDown'));
      group('keyPress', () => testEvent(Simulate.keyPress, 'keyPress'));
      group('keyUp', () => testEvent(Simulate.keyUp, 'keyUp'));
      group('mouseDown', () => testEvent(Simulate.mouseDown, 'mouseDown'));
      group('mouseMove', () => testEvent(Simulate.mouseMove, 'mouseMove'));
      group('mouseOut', () => testEvent(Simulate.mouseOut, 'mouseOut'));
      group('mouseOver', () => testEvent(Simulate.mouseOver, 'mouseOver'));
      group('mouseUp', () => testEvent(Simulate.mouseUp, 'mouseUp'));
      group('paste', () => testEvent(Simulate.paste, 'paste'));
      group('scroll', () => testEvent(Simulate.scroll, 'scroll'));
      group('submit', () => testEvent(Simulate.submit, 'submit'));
      group('touchCancel', () => testEvent(Simulate.touchCancel, 'touchCancel'));
      group('touchEnd', () => testEvent(Simulate.touchEnd, 'touchEnd'));
      group('touchMove', () => testEvent(Simulate.touchMove, 'touchMove'));
      group('touchStart', () => testEvent(Simulate.touchStart, 'touchStart'));
      group('wheel', () => testEvent(Simulate.wheel, 'wheel'));
    });

    group('native event', () {
      group('blur', () => testEvent(SimulateNative.blur, 'blur'));
      group('click', () => testEvent(SimulateNative.click, 'click'));
      group('copy', () => testEvent(SimulateNative.copy, 'copy'));
      group('cut', () => testEvent(SimulateNative.cut, 'cut'));
      group('doubleClick', () => testEvent(SimulateNative.doubleClick, 'doubleClick'));
      group('drag', () => testEvent(SimulateNative.drag, 'drag'));
      group('dragEnd', () => testEvent(SimulateNative.dragEnd, 'dragEnd'));
      group('dragEnter', () => testEvent(SimulateNative.dragEnter, 'dragEnter'));
      group('dragExit', () => testEvent(SimulateNative.dragExit, 'dragExit'));
      group('dragLeave', () => testEvent(SimulateNative.dragLeave, 'dragLeave'));
      group('dragOver', () => testEvent(SimulateNative.dragOver, 'dragOver'));
      group('dragStart', () => testEvent(SimulateNative.dragStart, 'dragStart'));
      group('drop', () => testEvent(SimulateNative.drop, 'drop'));
      group('focus', () => testEvent(SimulateNative.focus, 'focus'));
      group('input', () => testEvent(SimulateNative.input, 'input'));
      group('keyDown', () => testEvent(SimulateNative.keyDown, 'keyDown'));
      group('keyUp', () => testEvent(SimulateNative.keyUp, 'keyUp'));
      group('mouseDown', () => testEvent(SimulateNative.mouseDown, 'mouseDown'));
      group('mouseMove', () => testEvent(SimulateNative.mouseMove, 'mouseMove'));
      group('mouseOut', () => testEvent(SimulateNative.mouseOut, 'mouseOut'));
      group('mouseOver', () => testEvent(SimulateNative.mouseOver, 'mouseOver'));
      group('mouseUp', () => testEvent(SimulateNative.mouseUp, 'mouseUp'));
      group('paste', () => testEvent(SimulateNative.paste, 'paste'));
      group('scroll', () => testEvent(SimulateNative.scroll, 'scroll'));
      group('submit', () => testEvent(SimulateNative.submit, 'submit'));
      group('touchCancel', () => testEvent(SimulateNative.touchCancel, 'touchCancel'));
      group('touchEnd', () => testEvent(SimulateNative.touchEnd, 'touchEnd'));
      group('touchMove', () => testEvent(SimulateNative.touchMove, 'touchMove'));
      group('touchStart', () => testEvent(SimulateNative.touchStart, 'touchStart'));
      group('wheel', () => testEvent(SimulateNative.wheel, 'wheel'));
    });
  });

  test('findRenderedDOMComponentWithClass', () {
    component = renderIntoDocument(sampleComponent({}));
    var spanComponent = findRenderedDOMComponentWithClass(component, 'span1');

    expect(getProperty(spanComponent, 'tagName'), equals('SPAN'));
  });

  test('findRenderedDOMComponentWithTag', () {
    component = renderIntoDocument(sampleComponent({}));
    var h1Component = findRenderedDOMComponentWithTag(component, 'h1');

    expect(getProperty(h1Component, 'tagName'), equals('H1'));
  });

  test('findRenderedComponentWithType', () {
    component = renderIntoDocument(wrapperComponent({}, [sampleComponent({})]));
    var result = findRenderedComponentWithType(component, sampleComponent);
    expect(isCompositeComponentWithType(result, sampleComponent), isTrue);
  });

  group('isCompositeComponent', () {
    test('returns true when element is a composite component (created with React.createClass())', () {
      component = renderIntoDocument(eventComponent({}));

      expect(isCompositeComponent(component), isTrue);
    });

    test('returns false when element is not a composite component (created with React.createClass())', () {
      component = renderIntoDocument(div({}));

      expect(isCompositeComponent(component), isFalse);
    });
  });

  group('isCompositeComponentWithType', () {
    var renderedInstance = renderIntoDocument(sampleComponent({}));

    test('returns true when element is a composite component (created with React.createClass()) of the specified type', () {
      expect(isCompositeComponentWithType(
          renderedInstance, sampleComponent), isTrue);
    });

    test('returns false when element is not a composite component (created with React.createClass()) of the specified type', () {
      expect(isCompositeComponentWithType(
          renderedInstance, eventComponent), isFalse);
    });
  });

  group('isDOMComponent', () {
    test('returns true when argument is a DOM component', () {
      component = renderIntoDocument(sampleComponent({}));
      var h1Element = findRenderedDOMComponentWithTag(component, 'h1');

      expect(isDOMComponent(h1Element), isTrue);
    });

    test('returns false when argument is not a DOM component', () {
      expect(isDOMComponent(h1({})), isFalse);
    });
  });

  group('isElement', () {
    test('returns true argument is an element', () {
      expect(isElement(div({})), isTrue);
    });

    test('returns false argument is not an element', () {
      expect(isElement(newObject()), isFalse);
    });
  });

  group('isElementOfType', () {
    test('returns true argument is an element of type', () {
      expect(isElementOfType(div({}), div as ReactComponentFactory), isTrue);
    });

    test('returns false argument is not an element of type', () {
      expect(isElementOfType(div({}), span as ReactComponentFactory), isFalse);
    });
  });

  test('scryRenderedComponentsWithType', () {
    component = renderIntoDocument(wrapperComponent({}, [
        sampleComponent({}), sampleComponent({}), eventComponent({})]));

    var results = scryRenderedComponentsWithType(component, sampleComponent);

    expect(results.length, 2);
    expect(isCompositeComponentWithType(results[0], sampleComponent), isTrue);
    expect(isCompositeComponentWithType(results[1], sampleComponent), isTrue);
  });

  test('scryRenderedDOMComponentsWithClass', () {
    component = renderIntoDocument(wrapperComponent({}, [
        div({'className': 'divClass'}),
        div({'className': 'divClass'}),
        span({})
    ]));

    var results = scryRenderedDOMComponentsWithClass(component, 'divClass');

    expect(results.length, 2);
    expect(getProperty(results[0], 'tagName'), equals('DIV'));
    expect(getProperty(results[1], 'tagName'), equals('DIV'));
  });

  test('scryRenderedDOMComponentsWithTag', () {
    component = renderIntoDocument(wrapperComponent({}, [div({}), div({}), span({})]));

    var results = scryRenderedDOMComponentsWithTag(component, 'div');

    expect(results.length, 3);
    expect(getProperty(results[0], 'tagName'), equals('DIV'));
    expect(getProperty(results[1], 'tagName'), equals('DIV'));
    expect(getProperty(results[2], 'tagName'), equals('DIV'));
  });

  test('renderIntoDocument', () {
    var reactComponent = renderIntoDocument(sampleComponent({}));
    var divElements = scryRenderedDOMComponentsWithTag(reactComponent, 'div');
    var h1Elements = scryRenderedDOMComponentsWithTag(reactComponent, 'h1');
    var spanElements = scryRenderedDOMComponentsWithTag(reactComponent, 'span');

    expect(divElements.length, equals(3));
    // First div should be the parent div created by renderIntoDocument()
    expect(react_dom.findDOMNode(
        divElements[0]).text, equals('A headerFirst divSecond div'));
    expect(react_dom.findDOMNode(divElements[1]).text, equals('First div'));
    expect(react_dom.findDOMNode(divElements[2]).text, equals('Second div'));
    expect(h1Elements.length, equals(1));
    expect(react_dom.findDOMNode(h1Elements[0]).text, equals('A header'));
    expect(spanElements.length, equals(1));
    expect(react_dom.findDOMNode(spanElements[0]).text, equals(''));
  });
}

@JS('Object.keys')
external List _objectKeys(obj);
