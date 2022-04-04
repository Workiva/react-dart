@TestOn('browser')
import 'package:react/react.dart' as react;
import 'package:react/react_client/bridge.dart';
import 'package:react_testing_library/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

main() {
  // Test behavior that isn't functionally tested via component lifecycle tests.
  group('Component2Bridge', () {
    group('.forComponent returns the bridge used by that mounted component, which', () {
      test('by default is a const instance of Component2BridgeImpl', () {
        final componentRef = react.createRef<react.Component2>();
        rtl.render(Foo({'ref': componentRef}));
        expect(Component2Bridge.forComponent(componentRef.current), same(const Component2BridgeImpl()));
      });

      test('can be a custom bridge specified via registerComponent2', () {
        customBridgeCalls = [];
        addTearDown(() => customBridgeCalls = null);

        final componentRef = react.createRef<react.Component2>();
        rtl.render(BridgeTest({'ref': componentRef}));
        final bridge = Component2Bridge.forComponent(componentRef.current);
        expect(bridge, isNotNull);
        expect(
          customBridgeCalls,
          // Use `contains` since the static component instance and its bridge also get instantiated,
          // adding entries to customBridgeCalls.
          // `equals` is needed otherwise deep matching with matchers won't work
          contains(equals({
            'component': same(componentRef.current),
            'returnedBridge': same(bridge),
          })),
        );
      });
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

List<Map> customBridgeCalls;

final BridgeTest = react.registerComponent2(() => new _BridgeTest(), bridgeFactory: (component) {
  final returnedBridge = new CustomComponent2Bridge();
  customBridgeCalls?.add({
    'component': component,
    'returnedBridge': returnedBridge,
  });
  return returnedBridge;
});

class _BridgeTest extends react.Component2 {
  @override
  render() => react.div({});
}

class CustomComponent2Bridge extends Component2BridgeImpl {}
