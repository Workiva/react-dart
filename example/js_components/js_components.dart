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

  var content = JsFoo({
    // JsFoo forwards its props to its DOM nodes, so you can set
    // DOM props here and they'll work just how you'd expect them to.
    'title': 'Hey, quit hovering me!',
    'style': {
      'color': ['#f00', '#0f0', '#00f'][new Random().nextInt(3)]
    },
    'onMouseEnter': (react.SyntheticMouseEvent e) {
      print(e.runtimeType);
      print('Entered!');
    },
    'onButtonClick': _handleButtonClick,
    // Refs work the same, only you get back the JS component instance.
    // See below for how you can use this.
    'ref': (ref) {
      fooRef = ref;
    },

    // Props specific to the component can be specified as well!
    'foo': 'bar',
  }, [
    'This is a Dart Child'
  ]);

  react_dom.render(content, querySelector('#content'));

  // If you need to access a component instance, say,
  // to call an API method, you can do so by writing
  // a JS interop wrapper class.
  print((fooRef as JsFooComponent).getFoo());
}

void _handleButtonClick(react.SyntheticMouseEvent event) {
  print('Clicked!');
}

/// The JS component class.
///
/// Private since [JsFoo] will be used instead.
///
/// Accessible via `JsFoo.type`.
@JS()
external ReactClass get _JsFoo;

/// A factory for the "JsFoo" JS components class that allows it
/// to be used via Dart code.
///
/// Use this to render instances of the component from within Dart code.
///
/// This converts the Dart props [Map] passed into it in the
/// the same way props are converted for DOM components.
final JsFoo = new ReactJsComponentFactoryProxy(_JsFoo);

/// JS interop wrapper class for the component,
/// allowing us to interact with component instances
/// made available via refs or [react_dom.render] calls.
///
/// This is optional, as you won't always need to access the component's API.
@JS('_JsFoo')
class JsFooComponent {
  external String getFoo();
}
