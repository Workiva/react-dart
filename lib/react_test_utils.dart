library react.test_utils;

import 'dart:js';
import 'dart:html';
import 'package:react/react.dart';
import "package:react/react_client.dart";


const missingAddonsMessage = 'React.addons.TestUtils not found. Ensure you\'ve '
    'included the React addons in your HTML file.'
    '\n  This:\n<script src="packages/react/react-with-addons.js"></script>'
    '\n  Not this:\n<script src="packages/react/react.js"></script>';

JsObject _TestUtils = _getNestedJsObject(
    context, ['React', 'addons', 'TestUtils'], missingAddonsMessage);

JsObject _Simulate = _TestUtils['Simulate'];

JsObject _SimulateNative = _TestUtils['SimulateNative'];

_getNestedJsObject(
    JsObject base, List<String> keys, [String errorIfNotFound='']) {
  JsObject object = base;
  for (String key in keys) {
    if (!object.hasProperty(key)) {
      throw 'Unable to resolve '
          '$key in $base.${keys.join('.')}}.\n$errorIfNotFound';
    }
    object = object[key];
  }
  return object;
}

JsFunction getFactory(component) {
  if (component is ReactComponentFactoryProxy) {
    return (component as ReactComponentFactoryProxy).reactComponentFactory;
  }
  return null;
}

typedef bool ComponentTestFunction(JsObject componentInstance);

/// Event simulation interface.
///
/// Provides methods for each type of event that can be handled by a React
/// component.  All methods are used in the same way:
///
///   Simulate.{eventName}([JsObject] element, [Map] eventData)
///
/// This should include all events documented at:
/// http://facebook.github.io/react/docs/events.html
class Simulate {

  static void blur(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('blur', [element, new JsObject.jsify(eventData)]);

  static void change(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('change', [element, new JsObject.jsify(eventData)]);

  static void click(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('click', [element, new JsObject.jsify(eventData)]);
      
  static void contextMenu(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('contextMenu', [element, new JsObject.jsify(eventData)]);
      
  static void copy(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('copy', [element, new JsObject.jsify(eventData)]);
      
  static void cut(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('cut', [element, new JsObject.jsify(eventData)]);
      
  static void doubleClick(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('doubleClick', [element, new JsObject.jsify(eventData)]);
      
  static void drag(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('drag', [element, new JsObject.jsify(eventData)]);
      
  static void dragEnd(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragEnd', [element, new JsObject.jsify(eventData)]);
      
  static void dragEnter(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragEnter', [element, new JsObject.jsify(eventData)]);

  static void dragExit(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragExit', [element, new JsObject.jsify(eventData)]);

  static void dragLeave(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragLeave', [element, new JsObject.jsify(eventData)]);

  static void dragOver(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragOver', [element, new JsObject.jsify(eventData)]);

  static void dragStart(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragStart', [element, new JsObject.jsify(eventData)]);

  static void drop(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('drop', [element, new JsObject.jsify(eventData)]);

  static void focus(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('focus', [element, new JsObject.jsify(eventData)]);

  static void input(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('input', [element, new JsObject.jsify(eventData)]);

  static void keyDown(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyDown', [element, new JsObject.jsify(eventData)]);

  static void keyPress(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyPress', [element, new JsObject.jsify(eventData)]);

  static void keyUp(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyUp', [element, new JsObject.jsify(eventData)]);

  static void mouseDown(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseDown', [element, new JsObject.jsify(eventData)]);

  static void mouseMove(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseMove', [element, new JsObject.jsify(eventData)]);

  static void mouseOut(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseOut', [element, new JsObject.jsify(eventData)]);

  static void mouseOver(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseOver', [element, new JsObject.jsify(eventData)]);

  static void mouseUp(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseUp', [element, new JsObject.jsify(eventData)]);

  static void paste(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('paste', [element, new JsObject.jsify(eventData)]);

  static void scroll(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('scroll', [element, new JsObject.jsify(eventData)]);

  static void submit(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('submit', [element, new JsObject.jsify(eventData)]);

  static void touchCancel(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchCancel', [element, new JsObject.jsify(eventData)]);

  static void touchEnd(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchEnd', [element, new JsObject.jsify(eventData)]);

  static void touchMove(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchMove', [element, new JsObject.jsify(eventData)]);

  static void touchStart(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchStart', [element, new JsObject.jsify(eventData)]);

  static void wheel(JsObject element, [Map eventData = const{}]) =>
      _Simulate.callMethod('wheel', [element, new JsObject.jsify(eventData)]);

}

/// Native event simulation interface.
///
/// Provides methods that allow for simulation of mouseEnter and mouseLeave

class SimulateNative {

  static void mouseOut(JsObject element, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseOut', [element, new JsObject.jsify(eventData)]);

  static void mouseOver(JsObject element, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseOver', [element, new JsObject.jsify(eventData)]);

}

/// Traverse all components in tree and accumulate all components where
/// test(component) is true. This is not that useful on its own, but it's
/// used as a primitive for other test utils
///
/// Included in Dart for completeness
List findAllInRenderedTree(JsObject tree, JsFunction test) {
  return _TestUtils.callMethod('findAllInRenderedTree', [tree, test]);
}

/// Like scryRenderedDOMComponentsWithClass() but expects there to be one
/// result, and returns that one result, or throws exception if there is
/// any other number of matches besides one.
JsObject findRenderedDOMComponentWithClass(JsObject tree, String className) {
  return _TestUtils.callMethod(
      'findRenderedDOMComponentWithClass', [tree, className]);
}

/// Like scryRenderedDOMComponentsWithTag() but expects there to be one result,
/// and returns that one result, or throws exception if there is any other
/// number of matches besides one.
JsObject findRenderedDOMComponentWithTag(JsObject tree, String tag) {
  return _TestUtils.callMethod(
      'findRenderedDOMComponentWithTag', [tree, tag]);
}

/// Same as scryRenderedComponentsWithType() but expects there to be one result
/// and returns that one result, or throws exception if there is any other
/// number of matches besides one.
JsObject findRenderedComponentWithType(
    JsObject tree, ReactComponentFactory componentType) {
  return _TestUtils.callMethod(
      'findRenderedComponentWithType', [tree, getFactory(componentType)]);
}

/// Returns true if element is a composite component.
/// (created with React.createClass()).
bool isCompositeComponent(JsObject instance) {
  return _TestUtils.callMethod('isCompositeComponent', [instance]);
}

/// Returns true if instance is a composite component.
/// (created with React.createClass()) whose type is of a React componentClass.
bool isCompositeComponentWithType(
    JsObject instance, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'isCompositeComponentWithType', [instance, getFactory(componentClass)]);
}

/// Returns true if instance is a DOM component (such as a <div> or <span>).
bool isDOMComponent(JsObject instance) {
  return _TestUtils.callMethod('isDOMComponent', [instance]);
}

/// Returns true if element is any ReactElement.
bool isElement(JsObject element) {
  return _TestUtils.callMethod('isElement', [element]);
}

/// Returns true if element is a ReactElement whose type is of a
/// React componentClass.
bool isElementOfType(JsObject element, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'isElementOfType', [element, getFactory(componentClass)]);
}

/// Finds all instances of components with type equal to componentClass.
JsObject scryRenderedComponentsWithType(
    JsObject tree, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'scryRenderedComponentsWithType', [tree, getFactory(componentClass)]);
}

/// Finds all instances of components in the rendered tree that are DOM
/// components with the class name matching className.
List scryRenderedDOMComponentsWithClass(JsObject tree, String className) {
  return _TestUtils.callMethod(
      'scryRenderedDOMComponentsWithClass', [tree, className]);
}

/// Finds all instances of components in the rendered tree that are DOM
/// components with the tag name matching tagName.
JsObject scryRenderedDOMComponentsWithTag(JsObject tree, String tagName) {
  return _TestUtils.callMethod(
      'scryRenderedDOMComponentsWithTag', [tree, tagName]);
}

/// Render a Component into a detached DOM node in the document.
JsObject renderIntoDocument(JsObject instance) {
  var div = new DivElement();
  return _TestUtils.callMethod('renderIntoDocument', [instance]);
}

Element getDomNode(JsObject object) => object.callMethod('getDOMNode', []);

/// Pass a mocked component module to this method to augment it with useful
/// methods that allow it to be used as a dummy React component. Instead of
/// rendering as usual, the component will become a simple <div> (or other tag
/// if mockTagName is provided) containing any provided children.
JsObject mockComponent(JsObject componentClass, String mockTagName) {
  return _TestUtils.callMethod(
      'mockComponent', [componentClass, mockTagName]);
}