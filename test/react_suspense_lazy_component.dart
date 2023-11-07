import 'package:react/react.dart' as react;

var SimpleFunctionComponent = react.registerFunctionComponent(SimpleComponent, displayName: 'simple');

SimpleComponent(Map props) {
  return react.div({'id': 'simple-component'}, []);
}
