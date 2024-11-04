import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

// ignore: avoid_positional_boolean_parameters
void customAssert(String text, bool condition) {
  if (condition) {
    print('$text passed');
  } else {
    throw Exception(text);
  }
}

var ChildComponent = react.registerComponent2(() => _ChildComponent());

class _ChildComponent extends react.Component2 {
  var counter = 0;

  @override
  render() => react.div({}, [
        'Test element',
        counter.toString(),
        react.button({
          'type': 'button',
          'key': 'button',
          'className': 'btn btn-primary',
          'onClick': (_) {
            counter++;
            setState({});
          },
        }, 'Increase counter')
      ]);
}

var SimpleComponent = react.registerComponent2(() => _SimpleComponent());

class _SimpleComponent extends react.Component2 {
  var refToSpan;
  var refToElement;

  @override
  componentWillUnmount() => print('unmount');

  @override
  componentDidMount() {
    print('mount');
    customAssert('ref to span return span ', refToSpan.text == 'Test');
    // ignore: deprecated_member_use_from_same_package
    customAssert('findDOMNode works on this', react_dom.findDOMNode(this) != null);
    // ignore: deprecated_member_use_from_same_package
    customAssert('random ref resolves to null', ref('someRandomRef') == null);
  }

  var counter = 0;

  @override
  render() => react.div({}, [
        react.span({
          'key': 'span1',
          'ref': (ref) {
            refToSpan = ref;
          }
        }, 'Test'),
        react.span({'key': 'span2'}, counter),
        react.button({
          'type': 'button',
          'key': 'button1',
          'className': 'btn btn-primary',
          // ignore: deprecated_member_use_from_same_package
          'onClick': (_) => (react_dom.findDOMNode(this) as HtmlElement).children.first.text = (++counter).toString()
        }, 'Increase counter'),
        react.br({'key': 'br'}),
        ChildComponent({
          'key': 'child',
          'ref': (ref) {
            refToElement = ref;
          }
        }),
        react.button({
          'type': 'button',
          'key': 'button2',
          'className': 'btn btn-primary',
          'onClick': (_) => window.alert(refToElement.counter.toString())
        }, 'Show value of child element'),
      ]);
}

void main() {
  final root = react_dom.createRoot(querySelector('#content')!);
  root.render(SimpleComponent({}));
}
