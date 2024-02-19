@JS()
library react.src.react_test_utils.internal_test_utils;

import 'dart:js_util' show getProperty;

import 'package:js/js.dart';
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

/// Returns the [ReactComponentFactoryProxy.type] of a given [componentFactory].
///
/// * For DOM components, this with return the String corresponding to its tagName ('div', 'a', etc.).
/// * For custom composite components React.createClass()-based components, this will return the [ReactClass].
dynamic getComponentTypeV2(ReactComponentFactoryProxy componentFactory) => componentFactory.type;

@JS('React.addons.TestUtils.isCompositeComponent')
external bool _isCompositeComponent(/* [1] */ instance);

/// Returns true if element is a composite component.
/// (created with React.createClass()).
bool isCompositeComponent(/* [1] */ instance) {
  return _isCompositeComponent(instance)
      // Workaround for DOM components being detected as composite: https://github.com/facebook/react/pull/3839
      &&
      getProperty(instance as Object, 'tagName') == null;
}

@JS('React.addons.TestUtils.isCompositeComponentWithType')
external bool _isCompositeComponentWithType(/* [1] */ instance, dynamic type);

/// Returns `true` if instance is a custom composite component created using `React.createClass()`
/// that is of the [ReactComponentFactoryProxy.type] of the provided [componentFactory].
bool isCompositeComponentWithTypeV2(
    /* [1] */ instance,
    ReactComponentFactoryProxy componentFactory) {
  return _isCompositeComponentWithType(instance, getComponentTypeV2(componentFactory));
}

/// Returns true if instance is a DOM component (such as a <div> or <span>).
@JS('React.addons.TestUtils.isDOMComponent')
external bool isDOMComponent(/* [1] */ instance);

/// Returns true if [object] is a valid React component.
@JS('React.addons.TestUtils.isElement')
external bool isElement(dynamic object);

@JS('React.addons.TestUtils.isElementOfType')
external bool _isElementOfType(dynamic element, dynamic componentClass);

/// Returns `true` if [element] is a [ReactElement]
/// that is of the [ReactComponentFactoryProxy.type] of the provided [componentFactory].
bool isElementOfTypeV2(dynamic element, ReactComponentFactoryProxy componentFactory) {
  return _isElementOfType(element, getComponentTypeV2(componentFactory));
}

/// Render a Component into a detached DOM node in the document.
@JS('React.addons.TestUtils.renderIntoDocument')
external ReactComponent renderIntoDocument(ReactElement instance);
