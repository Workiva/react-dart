import 'package:js/js.dart';
import 'package:react/react.dart';
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/src/typedefs.dart';

/// A function that returns a bridge instance for use with a given [component].
///
/// Where possible, it is recommended to avoid creating creating bridge objects
/// unnecessarily, and instead reuse a const instance.
///
/// See [Component2BridgeImpl.bridgeFactory] for an example.
typedef Component2BridgeFactory = Component2Bridge Function(Component2 component);

/// A bridge from the Dart component instance to the JS component instance,
/// encapsulating non-lifecycle-related functionality that is injected into
/// component instances upon creation.
///
/// Each rendered Dart component has a bridge associated with it, which is
/// accessible via [forComponent]. Most implementations will share a single
/// bridge instance across many components.
///
/// These implementations translate Dart calls into JS calls, performing any
/// interop necessary.
///
/// See [Component2BridgeImpl] for the basic implementation.
///
/// __For internal/advanced use only.__
abstract class Component2Bridge {
  static final Expando<Component2Bridge> bridgeForComponent = new Expando();

  const Component2Bridge();

  /// Returns the bridge instance associated with the given [component].
  ///
  /// This will only be available for components that are instantiated by the
  /// [ReactDartComponentFactoryProxy2], and not when manually instantiated.
  ///
  /// __For internal/advanced use only.__
  static Component2Bridge forComponent(Component2 component) => bridgeForComponent[component];

  void setState(Component2 component, Map newState, SetStateCallback callback);
  void setStateWithUpdater(Component2 component, StateUpdaterCallback stateUpdater, SetStateCallback callback);
  void forceUpdate(Component2 component, SetStateCallback callback);
  void initializeState(Component2 component, Map state);
  JsMap jsifyPropTypes(Component2 component, Map propTypes);
}

// TODO 3.1.0-wip custom adapter for over_react to avoid typedPropsFactory usages?

/// A basic bridge implementation compatible with [Component2].
///
/// See [Component2Bridge] for more info.
class Component2BridgeImpl extends Component2Bridge {
  const Component2BridgeImpl();

  /// Returns a const bridge instance suitable for use with any component.
  ///
  /// See [Component2BridgeFactory] for more info.
  static Component2BridgeImpl bridgeFactory(Component2 _) => const Component2BridgeImpl();

  @override
  void forceUpdate(Component2 component, SetStateCallback callback) {
    if (callback == null) {
      component.jsThis.forceUpdate();
    } else {
      component.jsThis.forceUpdate(allowInterop(callback));
    }
  }

  @override
  void setState(Component2 component, Map newState, SetStateCallback callback) {
    // Short-circuit to match the ReactJS 16 behavior of not re-rendering the component if newState is null.
    if (newState == null) return;

    dynamic firstArg = jsBackingMapOrJsCopy(newState);

    if (callback == null) {
      component.jsThis.setState(firstArg);
    } else {
      component.jsThis.setState(firstArg, allowInterop(([_]) {
        callback();
      }));
    }
  }

  @override
  void initializeState(Component2 component, Map state) {
    dynamic jsState = jsBackingMapOrJsCopy(state);
    component.jsThis.state = jsState;
  }

  @override
  void setStateWithUpdater(Component2 component, StateUpdaterCallback stateUpdater, SetStateCallback callback) {
    final firstArg = allowInterop((JsMap jsPrevState, JsMap jsProps, [_]) {
      return jsBackingMapOrJsCopy(stateUpdater(
        new JsBackedMap.backedBy(jsPrevState),
        new JsBackedMap.backedBy(jsProps),
      ));
    });

    if (callback == null) {
      component.jsThis.setState(firstArg);
    } else {
      component.jsThis.setState(firstArg, allowInterop(([_]) {
        callback();
      }));
    }
  }

  @override
  @override
  JsMap jsifyPropTypes(Component2 component, Map propTypes) {
    return JsBackedMap.from(propTypes.map((propKey, validator) {
      dynamic handlePropValidator(
        dynamic props,
        dynamic propName,
        dynamic componentName,
        dynamic location,
        dynamic propFullName,
        dynamic secret,
      ) {
        var convertedProps = JsBackedMap.fromJs(props);
        var error = validator(convertedProps, propName, componentName, location, propFullName);
        if (error != null) {
          return JsError(error.toString());
        }
        return error;
      }

      return MapEntry(propKey, allowInterop(handlePropValidator));
    })).jsObject;
  }
}
