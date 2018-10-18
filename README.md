# Dart wrapper library for [facebook/react](http://facebook.github.io/)

[![Pub](https://img.shields.io/pub/v/react.svg)](https://pub.dartlang.org/packages/react)
[![documentation](https://img.shields.io/badge/Documentation-react-blue.svg)](https://www.dartdocs.org/documentation/react/latest/)

## Getting started

If you are not familiar with the ReactJS library, read this [react tutorial](http://facebook.github.io/react/docs/getting-started.html) first.

To integrate in Dart project add dependency [react](https://pub.dartlang.org/packages/react) to pubspec.yaml.

Include the native javascript `react` and `react_dom` libraries (provided with this library for compatibility reasons) in `index.html` and create element where you'll mount the react component you'll create.

```html
<html>
  <head>
    <script async src="packages/react/react.js"></script>
    <script async src="packages/react/react_dom.js"></script>
    <script async type="application/dart" src="your_app_name.dart"></script>
    <script async src="packages/browser/dart.js"></script>
  </head>
  <body>
    <div id="content">Here will be react content</div>
  </body>
</html>
```

If it fits the needs of your application better, you may alternatively load the concatenated minified `react` and `react_dom`
libraries in a single file:

```html
<script async src="packages/react/react_with_react_dom_prod.js"></script>
```

Initialize React in our Dart application. Mount simple component into '#content' div.

```dart
import 'dart:html';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;

main() {
  // This should be called once at the beginning of the application
  react_client.setClientConfiguration();
  var component = div({}, "Hello world!");
  react_dom.render(component, querySelector('#content'));
}
```

Inverse method to rendering component is `unmountComponentAtNode`

```dart
  react_dom.unmountComponentAtNode(querySelector('#content'));
```

## Using browser native elements

If you are familiar with React (without JSX extension) React-dart shouldn't surprise you much. All elements are defined as
functions that take `props` as first argument and `children` as optional second argument. `props` should implement `Map` and `children` is either one React element or `List` with multiple elements.

```dart
div({"className": "something"}, [
  h1({"style": {"height": "20px"}}, "Headline"),
  a({"href":"something.com"}, "Something"),
  "Some text"
])
```

For event handlers you must provide function that take `SyntheticEvent` (defined in this library).

```dart
div({"onClick": (SyntheticMouseEvent e) => print(e)})
```

## Defining custom elements

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
react_dom.render(myComponent({}), querySelector('#content'));
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

#### Creating components with richer interface than just props and children and with type control

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
  react_client.setClientConfiguration();
  react_dom.render(
    myComponent(headline: "My custom headline",
                text: "My custom text"),
    querySelector('#content')
  );
}
```
## Using refs and findDOMNode

Proper usage of refs here is a little bit different from usage in react. You can specify
a ref name in component props and then call ref method to get the referenced element.
Return values for Dart components, DOM components and JavaScript components are different.
For a Dart component, you get an instance of the Dart class of the component.
For primitive components (like DOM elements), you get the DOM node. For JavaScript composite components,
you get a `ReactElement` representing the react component.

If you want to work with DOM nodes of dart or JS components instead, you can call top level method `findDOMNode` on anything the ref returns.

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
  componentDidMount() {
    InputElement input = ref("input"); // Returns the DOM node.

    _DartComponent dartRef = ref("dart"); // Returns instance of _DartComponent
    dartRef.someData; // you can call methods or get values from it
    react_dom.findDOMNode(dartRef); // return div element rendered from _DartComponent

    react_dom.findDOMNode(this); // return root dom element rendered from this component
  }
}
```

## Geocodes Example

For more robust example take a look at our [examples](https://github.com/cleandart/react-dart/tree/master/example).

## Life-cycle methods of a component

These are quite similar to React life-cycle methods, so refer to React tutorial for further
explanation/spec. Their signatures in Dart are as:

```dart
class MyComponent extends Component {
  void componentWillMount() {}
  void componentDidMount() {}
  void componentWillReceiveProps(newProps) {}
  bool shouldComponentUpdate(nextProps, nextState) => true;
  void componentWillUpdate(nextProps, nextState) {}
  void componentDidUpdate(prevProps, prevState) {}
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
import 'package:test/test.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;

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
  react_client.setClientConfiguration();

  test('should click button and set span text to "success"', () {
    var component = react_test_utils.renderIntoDocument(myTestComponent({}));

    // Find button using tag name
    var buttonElement = react_test_utils.findRenderedDOMComponentWithTag(
        component, 'button');

    // Find span using class name
    var spanElement = react_test_utils.findRenderedDOMComponentWithClass(
        component, 'spanText');

    var buttonNode = react_dom.findDOMNode(buttonElement);
    var spanNode = react_dom.findDOMNode(spanElement);

    // Span text should equal the initial state
    expect(spanNode.text, equals('testing...'));

    // Click the button and trigger the onClick event
    react_test_utils.Simulate.click(buttonNode);

    // Span text should change to 'success'
    expect(spanNode.text, equals('success'));
  });
}
```

To test the Dart wrapper, take a look at [test/react_test_utils_test.dart](test).

## Contributing

### Running Tests

#### Dart VM 

```bash
pub run test -p content-shell
```

#### dart2js

```bash
pub run test -p chrome
```

#### Dart Dev Compiler ("DDC")

1. In one terminal, serve the test directory using the dev compiler:
    ```bash
    pub serve test --port=8090 --web-compiler=dartdevc
    ```
2. In another terminal, run the tests, referencing the port the dev compiler is using to serve the test directory:
    ```bash
    pub run test -p chrome --pub-serve=8090
    ``` 

### Build JS

After modifying dart_helpers.js, run:

```bash
./tool/build_js.sh
```
