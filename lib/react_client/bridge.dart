import 'package:js/js.dart';
import 'package:meta/meta.dart';
import 'package:react/react.dart';
import 'package:react/react_client/react_interop.dart';

import 'package:react/src/typedefs.dart';
import 'package:react/src/react_client/js_backed_map.dart';

/// A function that creates a bridge for a component.
typedef Component2BridgeFactory = Component2Bridge Function(Component2);

/// A bridge from the Dart component instance to the JS component instance,
/// encapsulating non-lifecycle-related functionality that is injected into
/// component instances upon creation.
///
/// Each rendered Dart component has a bridge instance associated with it,
/// which is accessible via [forComponent].
///
/// These implementations translate Dart calls into JS calls, performing any
/// interop necessary.
///
/// See [Component2BridgeImpl] for the basic implementation.
///
/// __For internal/advanced use only.__
abstract class Component2Bridge {
  @visibleForTesting
  static final Expando<Component2Bridge> bridgeForComponent = new Expando();

  /// Returns the bridge instance associated with the given [component].
  ///
  /// This will only be available for components that are instantiated by the
  /// [ReactDartComponentFactoryProxy2], and not when manually instantiated.
  ///
  /// __For internal/advanced use only.__
  static Component2Bridge forComponent(Component2 component) => bridgeForComponent[component];

  void setState(Map newState, SetStateCallback callback);
  void setStateWithUpdater(StateUpdaterCallback stateUpdater, SetStateCallback callback);
  void forceUpdate(SetStateCallback callback);
  void initializeState(Map state);
  JsMap jsifyPropTypes(Map propTypes);
}

// TODO custom adapter for over_react to avoid typedPropsFactory usages?

/// A basic bridge implementation compatible with [Component2].
///
/// See [Component2Bridge] for more info.
class Component2BridgeImpl extends Component2Bridge {
  /// The Dart component instance associated with this bridge.
  final Component2 component;

  /// The JS component instance associated with this bridge.
  ReactComponent get jsThis => component.jsThis;

  Component2BridgeImpl(this.component);

  static Component2BridgeImpl bridgeFactory(Component2 component) => Component2BridgeImpl(component);

  @override
  void forceUpdate(SetStateCallback callback) {
    if (callback == null) {
      jsThis.forceUpdate();
    } else {
      jsThis.forceUpdate(allowInterop(callback));
    }
  }

  @override
  void setState(Map newState, SetStateCallback callback) {
    // Short-circuit to match the ReactJS 16 behavior of not re-rendering the component if newState is null.
    if (newState == null) return;

    dynamic firstArg = jsBackingMapOrJsCopy(newState);

    if (callback == null) {
      jsThis.setState(firstArg);
    } else {
      jsThis.setState(firstArg, allowInterop(([_]) {
        callback();
      }));
    }
  }

  @override
  void initializeState(Map state) {
    dynamic jsState = jsBackingMapOrJsCopy(state);
    jsThis.state = jsState;
  }

  @override
  void setStateWithUpdater(StateUpdaterCallback stateUpdater, SetStateCallback callback) {
    final firstArg = allowInterop((JsMap jsPrevState, JsMap jsProps, [_]) {
      return jsBackingMapOrJsCopy(stateUpdater(
        new JsBackedMap.backedBy(jsPrevState),
        new JsBackedMap.backedBy(jsProps),
      ));
    });

    if (callback == null) {
      jsThis.setState(firstArg);
    } else {
      jsThis.setState(firstArg, allowInterop(([_]) {
        callback();
      }));
    }
  }

  @override
  JsMap jsifyPropTypes(Map propTypes) {
    // TODO: implement jsifyPropTypes
    return null;
  }
}
