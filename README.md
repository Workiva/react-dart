# Dart wrapper for [React JS](https://reactjs.org/)

[![Pub](https://img.shields.io/pub/v/react.svg)](https://pub.dartlang.org/packages/react)
![ReactJS v15.6.0](https://img.shields.io/badge/React_JS-v15.6.0-green.svg)
[![Build Status](https://travis-ci.com/cleandart/react-dart.svg?branch=master)](https://travis-ci.com/cleandart/react-dart)
[![React Dart API Docs](https://img.shields.io/badge/api_docs-react-blue.svg)](https://pub.dartlang.org/documentation/react/latest/)

## Getting Started

### Installation

If you are not familiar with the ReactJS library, read this [react tutorial](http://facebook.github.io/react/docs/getting-started.html) first.

1. Install the Dart SDK

    ```bash
    brew install dart
    ```
    
2. Create a `pubspec.yaml` file in the root of your project, and add `react` as a dependency: 

    ```yaml
    name: your_package_name
    version: 1.0.0
    environment:
      sdk: ^2.0.0 
    dependencies:
      react: ^4.5.0
    ```

3. Install the dependencies using pub:

    ```bash
    pub get
    ```

### Wire things up

#### HTML

In a `.html` file where Include the native javascript `react` and `react_dom` libraries 
_(provided with this library for compatibility reasons)_ within your `.html` file, 
and add an element with an `id` to mount your React component into.

Lastly, add the `.js` file that Dart will generate. The file will be the name of the `.dart` file that
contains your `main` entrypoint, with `.js` at the end.

```html
<html>
  <head>
    <!-- ... -->
  </head>
  <body>
    <div id="react_mount_point">Here will be react content</div>
    
    <script src="packages/react/react.js"></script>
    <script src="packages/react/react_dom.js"></script>
    <script defer src="your_dart_file_name.dart.js"></script>
  </body>
</html>
```

> __Note:__ When serving your application in production, use `packages/react/react_with_react_dom_prod.js`
  file instead of the un-minified `react.js` / `react_dom.js` files shown in the example above.  

#### Dart App

Once you have an `.html` file containing the necessary `.js` files, you can initialize React 
in the `main` entrypoint of your Dart application.

```dart
import 'dart:html';

import 'package:react/react_client.dart' as react_client;
import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;

main() {
  // This should be called once at the beginning of the application.
  react_client.setClientConfiguration();
  
  // Something to render... in this case a simple <div> with no props, and a string as its children.
  var component = div({}, "Hello world!");
  
  // Render it into the mount node we created in our .html file. 
  react_dom.render(component, querySelector('#react_mount_point'));
}
```

## Build Stuff

### Using browser native elements

If you are familiar with React (without JSX extension) React-dart shouldn't surprise you much. All elements are defined as
functions that take `props` as first argument and `children` as optional second argument. `props` should implement `Map` and `children` is either one React element or `List` with multiple elements.

```dart
var aDiv = div({"className": "something"}, [
  h1({"style": {"height": "20px"}}, "Headline"),
  a({"href":"something.com"}, "Something"),
  "Some text"
]);
```

For event handlers you must provide function that takes a `SyntheticEvent` _(defined in this library)_.

```dart
var aButton = button({"onClick": (SyntheticMouseEvent event) => print(event)});
```

### Defining custom components

1. Define custom class that extends Component and implements - at a minimum - `render`.

    ```dart
    // cool_widget.dart
 
    import 'package:react/react.dart';
    
    class CoolWidgetComponent extends Component {
      render() => div({}, "CoolWidgetComponent");
    }
    ```

2. Then register the class so ReactJS can recognize it.

    ```dart
    var CoolWidget = registerComponent(() => new CoolWidgetComponent());
    ```

    > __Warning:__ `registerComponent` should be called only once per component and lifetime of application.

3. Then you can use the registered component similarly as native elements.

    ```dart
    // app.dart

    import 'dart:html';

    import 'package:react/react_client.dart' as react_client;
    import 'package:react/react.dart';
    import 'package:react/react_dom.dart' as react_dom;

    import 'cool_widget.dart';
 
    main() {
      // This should be called once at the beginning of the application.
      react_client.setClientConfiguration();

      react_dom.render(CoolWidget({}), querySelector('#react_mount_point'));
    }
    ```

#### Custom component with props

```dart
// cool_widget.dart

import 'package:react/react.dart';

class CoolWidgetComponent extends Component {
  @override
  render() {
    return div({}, props['text']);
  }
}

var CoolWidget = registerComponent(() => new CoolWidgetComponent());
```

```dart
// app.dart

import 'dart:html';

import 'package:react/react_client.dart' as react_client;
import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;

import 'cool_widget.dart';

main() {
  // This should be called once at the beginning of the application.
  react_client.setClientConfiguration();
      
  react_dom.render(CoolWidget({"text": "Something"}), querySelector('#react_mount_point'));
}
```

#### Custom component with a typed interface

> __Note:__ The typed interface capabilities of this library are fairly limited, and can result in
  extremely verbose implementations. We strongly recommend using the 
  [OverReact](https://pub.dartlang.org/packages/over_react) package - which 
  makes creating statically-typed React UI components using Dart easy.

```dart
// cool_widget.dart
typedef CoolWidgetType({String headline, String text, int counter});

var _CoolWidget = registerComponent(() => new CoolWidgetComponent());

CoolWidgetType CoolWidget({String headline, String text, int counter}) {
  return _CoolWidget({'headline':headline, 'text':text});
}

class CoolWidgetComponent extends Component {
  String get headline => props['headline'];
  String get text => props['text'];
  int get counter => props['counter'];
  
  @override
  render() {
    return div({}, 
      h1({}, headline),
      span({}, text),
      span({}, counter),
    );
  }
}
```

```dart
// app.dart

import 'dart:html';

import 'package:react/react_client.dart' as react_client;
import 'package:react/react.dart';
import 'package:react/react_dom.dart' as react_dom;

import 'cool_widget.dart';

void main() {
  // This should be called once at the beginning of the application.
  react_client.setClientConfiguration();

  react_dom.render(
    myComponent(
        headline: "My custom headline",
        text: "My custom text",
        counter: 3,
    ),
    querySelector('#react_mount_point')
  );
}
```

#### React Component Lifecycle methods

The `Component` class mirrors ReactJS' `React.Component` class, and contains all the same methods. 

> See: [ReactJS Lifecycle Method Documentation](https://reactjs.org/docs/react-component.html) for more information.

```dart
class MyComponent extends Component {
  @override
  void componentWillMount() {}
  
  @override
  void componentDidMount() {}
  
  @override
  void componentWillReceiveProps(Map nextProps) {}
  
  @override
  void componentWillUpdate(Map nextProps, Map nextState) {}
  
  @override
  void componentDidUpdate(Map prevProps, Map prevState) {}
  
  @override
  void componentWillUnmount() {}
  
  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState) => true;
  
  @override
  Map getInitialState() => {};
  
  @override
  Map getDefaultProps() => {};
  
  @override
  render() => div({}, props['text']);
}
```

#### Using refs and findDOMNode

The use of component `ref`s in react-dart is a bit different from React JS. 

* You can specify a ref name in component props and then call ref method to get the referenced element.
* Return values for Dart components, DOM components and JavaScript components are different.
    * For a Dart component, you get an instance of the Dart class of the component.
    * For primitive components (like DOM elements), you get the DOM node. 
    * For JavaScript composite components, you get a `ReactElement` representing the react component.

If you want to work with DOM nodes of dart or JS components instead, 
you can call top level `findDOMNode` on anything the ref returns.

```dart
var DartComponent = registerComponent(() => new _DartComponent());
class _DartComponent extends Component {
  @override
  render() => div({});
  
  void someInstanceMethod(int count) {
    window.alert('count: $count');
  }
}

var ParentComponent = registerComponent(() => new _ParentComponent());
class _ParentComponent extends Component {
  @override
  void componentDidMount() {
    InputElement input = ref("input"); // Returns the DOM node.
    print(input.value); // Prints "hello" to the console.

    _DartComponent dartComponentRef = ref("dartComponent"); // Returns instance of _DartComponent
    dartComponentRef.someInstanceMethod(5); // Calls the method defined in _DartComponent
    react_dom.findDOMNode(dartRef); // Returns div element rendered from _DartComponent

    react_dom.findDOMNode(this); // Returns root dom element rendered from this component
  }
  
  @override
  render() {
    return div({},
      input({"ref": "input", "value": "hello"}),
      DartComponent({"ref": "dartComponent"}),
    );
  }
}
```

### Example Application

For more robust examples take a look at our [examples](https://github.com/cleandart/react-dart/tree/master/example).



## Unit Testing Utilities

[lib/react_test_utils.dart](https://github.com/cleandart/react-dart/blob/master/lib/react_test_utils.dart) is a 
Dart wrapper for the [ReactJS TestUtils](https://reactjs.org/docs/test-utils.html) library allowing for unit tests 
to be made for React components in Dart.

Here is an example of how to use React TestUtils within a Dart test.

```dart
import 'package:test/test.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;

class MyTestComponent extends react.Component {
  @override
  Map getInitialState() => {'text': 'testing...'};
  
  @override
  render() {
    return react.div({}, 
        react.button({'onClick': (_) => setState({'text': 'success'})}),
        react.span({'className': 'spanText'}, state['text']),
    );
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


## Contributing

### Running Tests

#### Dart 2: dart2js

```bash
pub run test -p chrome
```
_Or any other browser, e.g. `-p firefox`._

#### Dart 2: Dart Dev Compiler ("DDC")

```bash
pub run build_runner test -- -p chrome
```
_DDC only works in chrome._

#### Dart 1: Dart VM

```bash
pub run test -p content-shell
```

#### Dart 1: dart2js

```bash
pub run test -p chrome
```
_Or any other browser platform, e.g. `-p firefox`._

#### Dart 1: Dart Dev Compiler ("DDC")

1. In one terminal, serve the test directory using the dev compiler:
    ```bash
    pub serve test --port=8090 --web-compiler=dartdevc
    ```
2. In another terminal, run the tests, referencing the port the dev compiler is using to serve the test directory:
    ```bash
    pub run test -p chrome --pub-serve=8090
    ``` 
    _DDC only works in chrome._

### Building React JS Source Files

After modifying dart_helpers.js, run:

```bash
./tool/build_js.sh
```
