#Dart wraper library for [facebook/react](http://facebook.github.io/)

##Getting started

If you are not familiar with react library read their [react tutorial](http://facebook.github.io/react/docs/getting-started.html).

To integrate it in dart project add dependency on [react](https://pub.dartlang.org/packages/react) to pubspec.yaml.

Include native react library(providet with this library for compatibility reasons) to index.html and create element where our react components will live.

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

Iniciliaze react in our dart application. And put simple component into our html.

    import 'dart:html';
    import 'package:react/react_client.dart' as reactClient;
    import 'package:react/react.dart';
    
    main() {
      //this should be called once at the begging of application
      reactClient.setClientConfiguration();
      var component = div({}, "Hello world!");
      renderComponent(component, querySelector('#content'));
    }

##Using browser native elements

If you are famliliar with react without JSX extension then its almost same with react-dart. All elements are defined as 
functions that take props as first argument and children as optional second argument. Props are normal dart map and children is one react element or dart list with multiple elements.

    div({"className": "somehing"}, [
      h1({"style": {"height": "20px"}}, "Headline"),
      a({"href":"something.com"}, "Something"),
      "Some text"
    ])

For event handlers you must provide function that take SynteticEvents defined in this library.

    div({"onClick": (SyntheticMouseEvent e) => print(e)})

##Defining custom elements

Define custom class that extends Component and implements at least render.

    import 'package:react/react.dart';
    class MyComponent extends Component {
     render() => div({}, "MyComponent");
    }
    
Register this class so react can reacoginze it.

    var myComponent = registerComponent(() => new MyComponent());

Use this registered component as native elements.

    renderComponent(myComponent({}), querySelector('#content'));
    // or
    div({}, [
      myComponent({})
    ])

Warning: registerComponent should be called only once per component and lifetime of application.

### Custom element with props

    var myComponent = registerComponent(() => new MyComponent());
    class MyComponent extends Component {
      render() => div({}, props['text']);
    }
    myComponent({"text":"Somehting"})

####Creating components with richer interface than just props and children and with type control

    typedef MyComponentType({String headline, String text});
    MyComponentType myComponent = ({headline, text}) =>
        registerComponent(() => new MyComponent())({'headline':headline, 'text':text});
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
      renderComponent(
        myComponent(headline: "My custom headline",
                    text: "My custom text"),
        querySelector('#content')
      );
    }

## Life time functions of component

If you are familiar wiht react lifetime methods then here are their dart signatures.

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

