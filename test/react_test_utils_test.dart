@TestOn('browser')
library react_test_utils_test;

import 'dart:html';
import 'dart:js_util';

import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';
import 'package:react/react_test_utils.dart';
import 'package:test/test.dart';

import 'test_components.dart' as component1;
import 'test_components2.dart' as component2;
import 'util.dart';

void main() {
  testUtils(
      isComponent2: false,
      eventComponent: component1.eventComponent,
      sampleComponent: component1.sampleComponent,
      wrapperComponent: component1.wrapperComponent);
  testUtils(
      isComponent2: true,
      eventComponent: component2.eventComponent,
      sampleComponent: component2.sampleComponent,
      wrapperComponent: component2.wrapperComponent);
}

testUtils({isComponent2: false, dynamic eventComponent, dynamic sampleComponent, dynamic wrapperComponent}) {
  var component;
  Element domNode;

  tearDown(() {
    component = null;
    domNode = null;
  });

  group('Shallow Rendering with a Component${isComponent2 ? "2" : ""}', () {
    ReactElement content;
    ReactShallowRenderer shallowRenderer;

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

  group('Simulate on a Component${isComponent2 ? "2" : ""}', () {
    setUp(() {
      component = renderIntoDocument(eventComponent({}));
      domNode = react_dom.findDOMNode(component);
      expect(domNode.text, equals(''));
    });

    void testEvent(void event(dynamic instanceOrNode, Map eventData), String eventName,
        [void expectEventType(SyntheticEvent e)]) {
      final eventHandlerName = 'on${eventName[0].toUpperCase() + eventName.substring(1)}';
      eventName = eventName.toLowerCase();
      Map eventData;
      int fakeTimeStamp;

      setUp(() {
        fakeTimeStamp = eventName.hashCode;
        eventData = {
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

      if (expectEventType != null) {
        test('with correct type', () {
          SyntheticEvent capturedEvent;
          final component = renderIntoDocument(div({
            eventHandlerName: (e) => capturedEvent = e,
          }));
          event(react_dom.findDOMNode(component), eventData);
          expectEventType(capturedEvent);
        });
      }
    }

    group('event', () {
      group('animationEnd',
          () => testEvent(Simulate.animationEnd, 'animationEnd', (e) => expect(e.isAnimationEvent, isTrue)));
      group(
          'animationIteration',
          () =>
              testEvent(Simulate.animationIteration, 'animationIteration', (e) => expect(e.isAnimationEvent, isTrue)));
      group('animationStart',
          () => testEvent(Simulate.animationStart, 'animationStart', (e) => expect(e.isAnimationEvent, isTrue)));
      group('blur', () => testEvent(Simulate.blur, 'blur', (e) => expect(e.isFocusEvent, isTrue)));
      group('change', () => testEvent(Simulate.change, 'change'));
      group('click', () => testEvent(Simulate.click, 'click', (e) => expect(e.isMouseEvent, isTrue)));
      group('copy', () => testEvent(Simulate.copy, 'copy', (e) => expect(e.isClipboardEvent, isTrue)));
      group('compositionEnd',
          () => testEvent(Simulate.compositionEnd, 'compositionEnd', (e) => expect(e.isCompositionEvent, isTrue)));
      group('compositionStart',
          () => testEvent(Simulate.compositionStart, 'compositionStart', (e) => expect(e.isCompositionEvent, isTrue)));
      group(
          'compositionUpdate',
          () =>
              testEvent(Simulate.compositionUpdate, 'compositionUpdate', (e) => expect(e.isCompositionEvent, isTrue)));
      group('cut', () => testEvent(Simulate.cut, 'cut', (e) => expect(e.isClipboardEvent, isTrue)));
      group('doubleClick', () => testEvent(Simulate.doubleClick, 'doubleClick', (e) => expect(e.isMouseEvent, isTrue)));
      group('drag', () => testEvent(Simulate.drag, 'drag', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragEnd', () => testEvent(Simulate.dragEnd, 'dragEnd', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragEnter', () => testEvent(Simulate.dragEnter, 'dragEnter', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragExit', () => testEvent(Simulate.dragExit, 'dragExit', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragLeave', () => testEvent(Simulate.dragLeave, 'dragLeave', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragOver', () => testEvent(Simulate.dragOver, 'dragOver', (e) => expect(e.isMouseEvent, isTrue)));
      group('dragStart', () => testEvent(Simulate.dragStart, 'dragStart', (e) => expect(e.isMouseEvent, isTrue)));
      group('drop', () => testEvent(Simulate.drop, 'drop', (e) => expect(e.isMouseEvent, isTrue)));
      group('focus', () => testEvent(Simulate.focus, 'focus', (e) => expect(e.isFocusEvent, isTrue)));
      group('gotPointerCapture',
          () => testEvent(Simulate.gotPointerCapture, 'gotPointerCapture', (e) => expect(e.isPointerEvent, isTrue)));
      group('input', () => testEvent(Simulate.input, 'input'));
      group('keyDown', () => testEvent(Simulate.keyDown, 'keyDown', (e) => expect(e.isKeyboardEvent, isTrue)));
      group('keyPress', () => testEvent(Simulate.keyPress, 'keyPress', (e) => expect(e.isKeyboardEvent, isTrue)));
      group('keyUp', () => testEvent(Simulate.keyUp, 'keyUp', (e) => expect(e.isKeyboardEvent, isTrue)));
      group('lostPointerCapture',
          () => testEvent(Simulate.lostPointerCapture, 'lostPointerCapture', (e) => expect(e.isPointerEvent, isTrue)));
      group('mouseDown', () => testEvent(Simulate.mouseDown, 'mouseDown', (e) => expect(e.isMouseEvent, isTrue)));
      group('mouseMove', () => testEvent(Simulate.mouseMove, 'mouseMove', (e) => expect(e.isMouseEvent, isTrue)));
      group('mouseOut', () => testEvent(Simulate.mouseOut, 'mouseOut', (e) => expect(e.isMouseEvent, isTrue)));
      group('mouseOver', () => testEvent(Simulate.mouseOver, 'mouseOver', (e) => expect(e.isMouseEvent, isTrue)));
      group('mouseUp', () => testEvent(Simulate.mouseUp, 'mouseUp', (e) => expect(e.isMouseEvent, isTrue)));
      group('paste', () => testEvent(Simulate.paste, 'paste', (e) => expect(e.isClipboardEvent, isTrue)));
      group('pointerCancel',
          () => testEvent(Simulate.pointerCancel, 'pointerCancel', (e) => expect(e.isPointerEvent, isTrue)));
      group(
          'pointerDown', () => testEvent(Simulate.pointerDown, 'pointerDown', (e) => expect(e.isPointerEvent, isTrue)));
      group('pointerEnter',
          () => testEvent(Simulate.pointerEnter, 'pointerEnter', (e) => expect(e.isPointerEvent, isTrue)));
      group('pointerLeave',
          () => testEvent(Simulate.pointerLeave, 'pointerLeave', (e) => expect(e.isPointerEvent, isTrue)));
      group(
          'pointerMove', () => testEvent(Simulate.pointerMove, 'pointerMove', (e) => expect(e.isPointerEvent, isTrue)));
      group(
          'pointerOver', () => testEvent(Simulate.pointerOver, 'pointerOver', (e) => expect(e.isPointerEvent, isTrue)));
      group('pointerOut', () => testEvent(Simulate.pointerOut, 'pointerOut', (e) => expect(e.isPointerEvent, isTrue)));
      group('pointerUp', () => testEvent(Simulate.pointerUp, 'pointerUp', (e) => expect(e.isPointerEvent, isTrue)));
      group('scroll', () => testEvent(Simulate.scroll, 'scroll', (e) => expect(e.isUiEvent, isTrue)));
      group('submit', () => testEvent(Simulate.submit, 'submit'));
      group('touchCancel', () => testEvent(Simulate.touchCancel, 'touchCancel', (e) => expect(e.isTouchEvent, isTrue)));
      group('touchEnd', () => testEvent(Simulate.touchEnd, 'touchEnd', (e) => expect(e.isTouchEvent, isTrue)));
      group('touchMove', () => testEvent(Simulate.touchMove, 'touchMove', (e) => expect(e.isTouchEvent, isTrue)));
      group('touchStart', () => testEvent(Simulate.touchStart, 'touchStart', (e) => expect(e.isTouchEvent, isTrue)));
      group('transitionEnd',
          () => testEvent(Simulate.transitionEnd, 'transitionEnd', (e) => expect(e.isTransitionEvent, isTrue)));
      group('wheel', () => testEvent(Simulate.wheel, 'wheel', (e) => expect(e.isWheelEvent, isTrue)));
    });

    test('passes in and jsifies eventData properly', () {
      const testKeyCode = 42;

      String callInfo;
      bool wasStopPropagationCalled = false;

      final renderedNode = renderIntoDocument(div({
        'onKeyDown': (event) {
          event.stopPropagation();
          callInfo = 'onKeyDown ${event.keyCode}';
        }
      }));

      Simulate.keyDown(renderedNode, {
        'keyCode': testKeyCode,
        'stopPropagation': () {
          wasStopPropagationCalled = true;
        }
      });

      expect(callInfo, 'onKeyDown $testKeyCode');
      expect(wasStopPropagationCalled, isTrue, reason: 'should have successfully called Dart function passed in');
    });
  });

  test('findRenderedDOMComponentWithClass on a Component${isComponent2 ? "2" : ""}', () {
    component = renderIntoDocument(sampleComponent({}));
    var spanComponent = findRenderedDOMComponentWithClass(component, 'span1');

    expect(getProperty(spanComponent, 'tagName'), equals('SPAN'));
  });

  test('findRenderedDOMComponentWithTag on a Component${isComponent2 ? "2" : ""}', () {
    component = renderIntoDocument(sampleComponent({}));
    var h1Component = findRenderedDOMComponentWithTag(component, 'h1');

    expect(getProperty(h1Component, 'tagName'), equals('H1'));
  });

  test('findRenderedComponentWithTypeV2 on a Component${isComponent2 ? "2" : ""}', () {
    component = renderIntoDocument(wrapperComponent({}, [sampleComponent({})]));
    var result = findRenderedComponentWithTypeV2(component, sampleComponent);
    expect(isCompositeComponentWithTypeV2(result, sampleComponent), isTrue);
  });

  group('isCompositeComponent on a Component${isComponent2 ? "2" : ""}', () {
    test('returns true when element is a composite component (created with React.createClass())', () {
      component = renderIntoDocument(eventComponent({}));

      expect(isCompositeComponent(component), isTrue);
    });

    test('returns false when element is not a composite component (created with React.createClass())', () {
      component = renderIntoDocument(div({}));

      expect(isCompositeComponent(component), isFalse);
    });
  });

  group('isCompositeComponentWithTypeV2 on a Component${isComponent2 ? "2" : ""}', () {
    var renderedInstance = renderIntoDocument(sampleComponent({}));

    test('returns true when element is a composite component (created with React.createClass()) of the specified type',
        () {
      expect(isCompositeComponentWithTypeV2(renderedInstance, sampleComponent), isTrue);
    });

    test(
        'returns false when element is not a composite component (created with React.createClass()) of the specified type',
        () {
      expect(isCompositeComponentWithTypeV2(renderedInstance, eventComponent), isFalse);
    });
  });

  group('isDOMComponent on a Component${isComponent2 ? "2" : ""}', () {
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

  group('isElementOfTypeV2', () {
    test('returns true argument is an element of type', () {
      expect(isElementOfTypeV2(div({}), div), isTrue);
    });

    test('returns false argument is not an element of type', () {
      expect(isElementOfTypeV2(div({}), span), isFalse);
    });
  });

  test('scryRenderedComponentsWithTypeV2 on a Component${isComponent2 ? "2" : ""}', () {
    component =
        renderIntoDocument(wrapperComponent({}, [sampleComponent({}), sampleComponent({}), eventComponent({})]));

    var results = scryRenderedComponentsWithTypeV2(component, sampleComponent);

    expect(results.length, 2);
    expect(isCompositeComponentWithTypeV2(results[0], sampleComponent), isTrue);
    expect(isCompositeComponentWithTypeV2(results[1], sampleComponent), isTrue);
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

  test('renderIntoDocument with a Component${isComponent2 ? "2" : ""}', () {
    var reactComponent = renderIntoDocument(sampleComponent({}));
    var divElements = scryRenderedDOMComponentsWithTag(reactComponent, 'div');
    var h1Elements = scryRenderedDOMComponentsWithTag(reactComponent, 'h1');
    var spanElements = scryRenderedDOMComponentsWithTag(reactComponent, 'span');

    expect(divElements.length, equals(3));
    // First div should be the parent div created by renderIntoDocument()
    expect(react_dom.findDOMNode(divElements[0]).text, equals('A headerFirst divSecond div'));
    expect(react_dom.findDOMNode(divElements[1]).text, equals('First div'));
    expect(react_dom.findDOMNode(divElements[2]).text, equals('Second div'));
    expect(h1Elements.length, equals(1));
    expect(react_dom.findDOMNode(h1Elements[0]).text, equals('A header'));
    expect(spanElements.length, equals(1));
    expect(react_dom.findDOMNode(spanElements[0]).text, equals(''));
  });
}
