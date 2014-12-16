#Dart wraper library for [facebook/react](http://facebook.github.io/)

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

var _myComponent = registerComponent(() => new MyComponent())

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

## Geocodes Example

For more robust example take a look at [example/geocodes/geocodes.dart]().

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

