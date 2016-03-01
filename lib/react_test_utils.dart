// Copyright (c) 2016, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

/// Returns [component] if it is already a [JsObject], and converts [component] if
/// it is an [Element]. If [component] is neither a [JsObject] or an [Element], throws an
/// [ArgumentError].
///
/// React does not use the same type of object for primitive components as composite components,
/// and Dart converts the React objects used for primitive components to [Element]s automatically.
/// This is problematic in some cases - primarily the test utility methods that return [JsObject]s,
/// and render, which also needs to return a [JsObject]. This method can be used for handling this
/// by converting the [Element] back to a [JsObject].
JsObject normalizeReactComponent(dynamic component) {
  if (component is JsObject) return component;
  if (component is Element) return new JsObject.fromBrowserObject(component);
  if (component == null) return null;

  throw new ArgumentError('$component component is not a valid ReactComponent');
}

/// Returns the 'type' of a component.
///
/// For a DOM components, this with return the String corresponding to its tagName ('div', 'a', etc.).
/// For React.createClass()-based components, this with return the React class as a JsFunction.
dynamic getComponentType(ReactComponentFactory componentFactory) {
  if (componentFactory is ReactComponentFactoryProxy) {
    return (componentFactory as ReactComponentFactoryProxy).type;
  }
  return null;
}

typedef bool ComponentTestFunction(JsObject componentInstance);

/// Event simulation interface.
///
/// Provides methods for each type of event that can be handled by a React
/// component.  All methods are used in the same way:
///
///   Simulate.{eventName}(dynamic instanceOrNode, [Map] eventData)
///
/// This should include all events documented at:
/// http://facebook.github.io/react/docs/events.html
class Simulate {

  static void blur(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('blur', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void change(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('change', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void click(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('click', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void contextMenu(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('contextMenu', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void copy(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('copy', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void cut(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('cut', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void doubleClick(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('doubleClick', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void drag(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('drag', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragEnd(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragEnd', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragEnter(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragEnter', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragExit(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragExit', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragLeave(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragLeave', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragOver(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragOver', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragStart(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('dragStart', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void drop(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('drop', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void focus(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('focus', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void input(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('input', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void keyDown(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyDown', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void keyPress(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyPress', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void keyUp(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('keyUp', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseDown(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseDown', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseMove(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseMove', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseOut(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseOut', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseOver(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseOver', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseUp(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('mouseUp', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void paste(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('paste', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void scroll(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('scroll', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void submit(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('submit', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchCancel(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchCancel', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchEnd(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchEnd', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchMove(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchMove', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchStart(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('touchStart', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void wheel(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _Simulate.callMethod('wheel', [instanceOrNode, new JsObject.jsify(eventData)]);

}

/// Native event simulation interface.
///
/// Current implementation does not support change and keyPress native events
///
/// Provides methods for each type of event that can be handled by a React
/// component.  All methods are used in the same way:
///
///   SimulateNative.{eventName}(dynamic instanceOrNode, [Map] eventData)

class SimulateNative {

  static void blur(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('blur', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void click(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('click', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void contextMenu(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('contextMenu', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void copy(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('copy', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void cut(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('cut', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void doubleClick(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('doubleClick', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void drag(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('drag', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragEnd(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragEnd', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragEnter(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragEnter', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragExit(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragExit', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragLeave(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragLeave', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragOver(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragOver', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void dragStart(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('dragStart', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void drop(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('drop', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void focus(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('focus', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void input(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('input', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void keyDown(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('keyDown', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void keyUp(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('keyUp', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseDown(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseDown', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseMove(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseMove', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseOut(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseOut', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseOver(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseOver', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void mouseUp(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('mouseUp', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void paste(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('paste', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void scroll(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('scroll', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void submit(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('submit', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchCancel(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('touchCancel', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchEnd(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('touchEnd', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchMove(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('touchMove', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void touchStart(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('touchStart', [instanceOrNode, new JsObject.jsify(eventData)]);

  static void wheel(dynamic instanceOrNode, [Map eventData = const{}]) =>
      _SimulateNative.callMethod('wheel', [instanceOrNode, new JsObject.jsify(eventData)]);

}

/// Traverse all components in tree and accumulate all components where
/// test(component) is true. This is not that useful on its own, but it's
/// used as a primitive for other test utils
///
/// Included in Dart for completeness
List findAllInRenderedTree(JsObject tree, JsFunction test) {
  var components = _TestUtils.callMethod('findAllInRenderedTree', [tree, test]);

  components.map(normalizeReactComponent).toList();

  return components;
}

/// Like scryRenderedDOMComponentsWithClass() but expects there to be one
/// result, and returns that one result, or throws exception if there is
/// any other number of matches besides one.
JsObject findRenderedDOMComponentWithClass(JsObject tree, String className) {
  var component = _TestUtils.callMethod(
      'findRenderedDOMComponentWithClass', [tree, className]);

  return normalizeReactComponent(component);
}

/// Like scryRenderedDOMComponentsWithTag() but expects there to be one result,
/// and returns that one result, or throws exception if there is any other
/// number of matches besides one.
JsObject findRenderedDOMComponentWithTag(JsObject tree, String tag) {
  var component = _TestUtils.callMethod(
      'findRenderedDOMComponentWithTag', [tree, tag]);

  return normalizeReactComponent(component);
}

/// Same as scryRenderedComponentsWithType() but expects there to be one result
/// and returns that one result, or throws exception if there is any other
/// number of matches besides one.
JsObject findRenderedComponentWithType(
    JsObject tree, ReactComponentFactory componentType) {
  return _TestUtils.callMethod(
      'findRenderedComponentWithType', [tree, getComponentType(componentType)]);
}

/// Returns true if element is a composite component.
/// (created with React.createClass()).
bool isCompositeComponent(JsObject instance) {
  return _TestUtils.callMethod('isCompositeComponent', [instance])
         // Workaround for DOM components being detected as composite: https://github.com/facebook/react/pull/3839
         && instance['tagName'] == null;
}

/// Returns true if instance is a composite component.
/// (created with React.createClass()) whose type is of a React componentClass.
bool isCompositeComponentWithType(
    JsObject instance, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'isCompositeComponentWithType', [instance, getComponentType(componentClass)]);
}

/// Returns true if instance is a DOM component (such as a <div> or <span>).
bool isDOMComponent(JsObject instance) {
  return _TestUtils.callMethod('isDOMComponent', [instance]);
}

/// Returns true if [object] is a valid React component.
bool isElement(JsObject object) {
  return _TestUtils.callMethod('isElement', [object]);
}

/// Returns true if element is a ReactElement whose type is of a
/// React componentClass.
bool isElementOfType(JsObject element, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'isElementOfType', [element, getComponentType(componentClass)]);
}

/// Finds all instances of components with type equal to componentClass.
JsObject scryRenderedComponentsWithType(
    JsObject tree, ReactComponentFactory componentClass) {
  return _TestUtils.callMethod(
      'scryRenderedComponentsWithType', [tree, getComponentType(componentClass)]);
}

/// Finds all instances of components in the rendered tree that are DOM
/// components with the class name matching className.
List scryRenderedDOMComponentsWithClass(JsObject tree, String className) {
  var components = _TestUtils.callMethod(
      'scryRenderedDOMComponentsWithClass', [tree, className]);

  components = components.map(normalizeReactComponent).toList();

  return components;
}

/// Finds all instances of components in the rendered tree that are DOM
/// components with the tag name matching tagName.
List scryRenderedDOMComponentsWithTag(JsObject tree, String tagName) {
  var components = _TestUtils.callMethod(
      'scryRenderedDOMComponentsWithTag', [tree, tagName]);

  components = components.map(normalizeReactComponent).toList();

  return components;
}

/// Render a Component into a detached DOM node in the document.
JsObject renderIntoDocument(JsObject instance) {
  var component = _TestUtils.callMethod('renderIntoDocument', [instance]);

  return normalizeReactComponent(component);
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

/// Returns a ReactShallowRenderer instance
///
/// More info on using shallow rendering: https://facebook.github.io/react/docs/test-utils.html#shallow-rendering
ReactShallowRenderer createRenderer() {
  return new ReactShallowRenderer.jsObject(_TestUtils.callMethod('createRenderer', []));
}

/// ReactShallowRenderer wrapper
///
/// Usage:
/// ```
/// ReactShallowRenderer shallowRenderer = createRenderer();
/// shallowRenderer.render(div({'className': 'active'}));
///
/// JsObject renderedOutput = shallowRenderer.getRenderOutput();
/// expect(renderedOutput['props']['className'], 'active');
/// ```
///
/// See react_with_addons.js#ReactShallowRenderer
class ReactShallowRenderer {
  final JsObject jsRenderer;

  ReactShallowRenderer.jsObject(JsObject this.jsRenderer);

  /// Get the rendered output. [render] must be called first
  JsObject getRenderOutput() => jsRenderer.callMethod('getRenderOutput', []);

  render(JsObject element, [Map context]) {
    JsObject c = context == null ? null : new JsObject.jsify(context);

    jsRenderer.callMethod('render', [element, c]);
  }

  unmount() {
    jsRenderer.callMethod('unmount', []);
  }
}
