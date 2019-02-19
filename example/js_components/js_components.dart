@JS()
library js_components;

import 'dart:html';
import 'dart:math';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;

var fooRef;

main() {
  setClientConfiguration();

  var content = Foo({
    // Foo forwards its props to its DOM nodes, so you can set
    // DOM props here and they'll work just how you'd expect them to.
    'title': 'Hey, quit hovering me!',
    'style': {
      'color': ['#f00', '#0f0', '#00f'][new Random().nextInt(3)]
    },
    'onMouseEnter': (react.SyntheticMouseEvent e) {
      print('Entered!');
    },

    // Refs work the same, only you get back the JS component instance.
    // See below for how you can use this.
    'ref': (ref) { fooRef = ref; },

    // Props specific to the component can be specified as well!
    'foo': 'bar',
//    // Non-DOM event handlers props can't be automatically wrapped with
//    // conversion logic, so this has to be done manually if you need
//    // access to the Dart [react.SyntheticEvent] and not the JS one.
//    //
//    // See [wrapEventHandler] docs for more info.
//    'onButtonClick': wrapEventHandler(_handleButtonClick, 'onClick'),
  });

  react_dom.render(content, querySelector('#content'));

  // If you need to access a component instance, say,
  // to call an API method, you can do so by writing
  // a JS interop wrapper class.
  print((fooRef as FooComponent).getFoo());
}

void _handleButtonClick(react.SyntheticMouseEvent event) {
  print('Clicked!');
}


/// The JS component class.
///
/// Private since [Foo] will be used instead.
///
/// Accessible via `Foo.type`.
@JS('Foo')
external ReactClass get _Foo;

/// A factory for the "Foo" JS components class that allows it
/// to be used via Dart code.
///
/// Use this to render instances of the component from within Dart code.
///
/// This converts the Dart props [Map] passed into it in the
/// the same way props are converted for DOM components.
final Foo = new ReactJsComponentFactoryProxy(_Foo);

/// JS interop wrapper class for the component,
/// allowing us to interact with component instances
/// made available via refs or [react_dom.render] calls.
///
/// This is optional, as you won't always need to access the component's API.
@JS()
class FooComponent {
  external String getFoo();
}
