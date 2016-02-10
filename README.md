#Dart wrapper library for [facebook/react](http://facebook.github.io/)

[![Pub](https://img.shields.io/pub/v/react.svg)](https://pub.dartlang.org/packages/react)

##Getting started

If you are not familiar with React library read [react tutorial](http://facebook.github.io/react/docs/getting-started.html) first.

To integrate in Dart project add dependency [react](https://pub.dartlang.org/packages/react) to pubspec.yaml.

Include native react library (provided with this library for compatibility reasons) to index.html and create element where you'll mount the react component you'll create.

```html
<html>
  <head>
    <script async src="packages/react/react.js"></script>
    <script async type="application/dart" src="your_app_name.dart"></script>
    <script async src="packages/browser/dart.js"></script>
  </head>
  <body>
    <div id="content">Here will be react content</div>
  </body>
</html>
```

Initialize React in our Dart application. Mount simple component into '#content' div.

```dart
import 'dart:html';
import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart';

main() {
  //this should be called once at the begging of application
  reactClient.setClientConfiguration();
  var component = div({}, "Hello world!");
  render(component, querySelector('#content'));
}
```

Inverse method to rendering component is unmountComponentAtNode

```dart
  unmountComponentAtNode(querySelector('#content'));
```

##Using browser native elements

If you are familiar with React (without JSX extension) React-dart shouldn't surprise you much. All elements are defined as
functions that take `props` as first argument and `children` as optional second argument. `props` should implement `Map` and `children` is either one React element or `List` with multiple elements.

```dart
div({"className": "somehing"}, [
  h1({"style": {"height": "20px"}}, "Headline"),
  a({"href":"something.com"}, "Something"),
  "Some text"
])
```

For event handlers you must provide function that take `SyntheticEvent` (defined in this library).

```dart
div({"onClick": (SyntheticMouseEvent e) => print(e)})
```

##Defining custom elements

Define custom class that extends Component and implements at least render.

```dart
import 'package:react/react.dart';
class MyComponent extends Component {
  render() => div({}, "MyComponent");
}
```

Register this class so React can recognize it.

```dart
var myComponent = registerComponent(() => new MyComponent());
```

Use this registered component similarly as native elements.

```dart
render(myComponent({}), querySelector('#content'));
// or
div({}, [
  myComponent({})
])
```

Warning: `registerComponent` should be called only once per component and lifetime of application.

### Custom element with props

```dart
var myComponent = registerComponent(() => new MyComponent());
class MyComponent extends Component {
  render() => div({}, props['text']);
}
myComponent({"text":"Somehting"})
```

####Creating components with richer interface than just props and children and with type control

```dart
typedef MyComponentType({String headline, String text});

var _myComponent = registerComponent(() => new MyComponent());

MyComponentType myComponent = ({headline, text}) =>
    _myComponent({'headline':headline, 'text':text});

class MyComponent extends Component {
  get headline => props['headline'];
  get text => props['text'];
  render() =>
    div({},[
      h1({}, headline),
      span({}, text),
    ]);
}

void main() {
  reactClient.setClientConfiguration();
  render(
    myComponent(headline: "My custom headline",
                text: "My custom text"),
    querySelector('#content')
  );
}
```
## Using refs and findDOMNode

Proper usage of refs here is a little bit different from usage in react. You can specify
a ref name in component props and then call ref method to get the referenced element.
Return value for dart components and for javascript components is different.
For dart component, you get an instance of dart class of the component.
For js components (like DOM elements), you get instance of jsObject representing the
react component. If you want to work with DOM nodes instead of a component, you can
call top level method findDOMNode on anything the ref returns.

```
var DartComponent = registerComponent(() => new _DartComponent());
class _DartComponent extends Component {
  var someData = 11;
  render() => div({});
}
var ParentComponent = registerComponent(() => new _ParentComponent());
class _ParentComponent extends Component {
  render() =>
    div({},[
      input({"ref": "input"}),
      DartComponent({"ref": "dart"})
    ]);
  componentDidMount(root) {
    var inputRef = ref("input"); //return react jsObject
    InputElement input = findDOMNode(inputRef); // return InputElement in dom

    _DartComponent dartRef = ref("dart"); //return instance of _DartComponent
    dartRef.someData; // you can call methods or get values from it
    findDOMNode(dartRef); //return div element rendered from _DartComponent

    findDOMNode(this); //return root dom element rendered from this component
  }
}
```

## Geocodes Example

For more robust example take a look at [example/geocodes/geocodes.dart](https://github.com/cleandart/react-dart/tree/master/example/geocodes).

## Life-cycle methods of a component

These are quite similar to React life-cycle methods, so refer to React tutorial for further
explanation/spec. Their signatures in Dart are as:

```dart
class MyComponent extends Component {
  void componentWillMount() {}
  void componentDidMount(/*DOMElement*/rootNode) {}
  void componentWillReceiveProps(newProps) {}
  bool shouldComponentUpdate(nextProps, nextState) => true;
  void componentWillUpdate(nextProps, nextState) {}
  void componentDidUpdate(prevProps, prevState, /*DOMElement */ rootNode) {}
  void componentWillUnmount() {}
  Map getInitialState() => {};
  Map getDefaultProps() => {};
  render() => div({}, props['text']);
}
```

## Testing using React Test Utilities

[lib/react_test_utils.dart](lib/react_test_utils.dart) is a Dart wrapper for the [React TestUtils](http://facebook.github.io/react/docs/test-utils.html) library allowing for tests to be made for React components in Dart.

Here is an example of how to use React TestUtils within a Dart test.

```dart
import 'package:unittest/unittest.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' as reactClient;
import 'package:react/react_test_utils.dart' as reactTestUtils;

class MyTestComponent extends react.Component {
  getInitialState() => {'text': 'testing...'};
  render() {
    return react.div({}, [
        react.button({'onClick': (e) => setState({'text': 'success'})}),
        react.span({'className': 'spanText'}, state['text'])
    ]);
  }
}

var myTestComponent = react.registerComponent(() => new MyTestComponent());

void main() {
  reactClient.setClientConfiguration();

  test('should click button and set span text to "success"', () {
    var component = reactTestUtils.renderIntoDocument(myTestComponent({}));

    // Find button using tag name
    var buttonElement = reactTestUtils.findRenderedDOMComponentWithTag(
        component, 'button');

    // Find span using class name
    var spanElement = reactTestUtils.findRenderedDOMComponentWithClass(
        component, 'spanText');

    var buttonNode = reactTestUtils.getDomNode(buttonElement);
    var spanNode = reactTestUtils.getDomNode(spanElement);

    // Span text should equal the initial state
    expect(spanNode.text, equals('testing...'));

    // Click the button and trigger the onClick event
    reactTestUtils.Simulate.click(buttonNode);

    // Span text should change to 'success'
    expect(spanNode.text, equals('success'));
  });
}
```

To test the Dart wrapper, take a look at [test/react_test_utils_test.dart](test).
