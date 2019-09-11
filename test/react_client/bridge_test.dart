@TestOn('browser')
library react.bridge_test;

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/bridge.dart';
import 'package:test/test.dart';

import '../util.dart';

main() {
  setClientConfiguration();

  // Test behavior that isn't functionally tested via component lifecycle tests.
  group('Component2Bridge', () {
    test(
        '.forComponent returns the bridge used by that mounted component,'
        ' which by default is a const instance of Component2BridgeImpl', () {
      final instance = getDartComponent<_Foo>(render(Foo({})));
      expect(Component2Bridge.forComponent(instance), same(const Component2BridgeImpl()));
    });

    group('- Component2BridgeImpl', () {
      test('.bridgeFactory returns a const instance of Component2BridgeImpl', () {
        expect(Component2BridgeImpl.bridgeFactory(new _Foo()), same(const Component2BridgeImpl()));
      });
    });
  });
}

final Foo = react.registerComponent2(() => new _Foo());

class _Foo extends react.Component2 {
  @override
  render() => react.div({});
}
