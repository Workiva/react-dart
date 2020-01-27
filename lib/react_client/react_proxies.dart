/// The Dart proxy classes that wrap JavaSript's React classes.
///
/// For use in `react_client.dart` and `react.dart` and by advanced react-dart users.
library react_client.react_proxies;

import 'dart:js';

import "package:js/js.dart";

import "package:react/react.dart";
import 'package:react/react_client/js_backed_map.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/utils.dart';

import 'package:react/src/context.dart';
import 'package:react/src/ddc_emulated_function_name_bug.dart' as ddc_emulated_function_name_bug;
import "package:react/src/react_client/utils.dart";

/// The type of `Component.ref` specified as a callback.
///
/// See: <https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute>
typedef _CallbackRef<T>(T componentOrDomNode);

/// Use [ReactDartComponentFactoryProxy2] instead.
///
/// Will be removed when [Component] is removed in the `6.0.0` release.
@Deprecated('6.0.0')
class ReactDartComponentFactoryProxy<TComponent extends Component> extends ReactComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final ReactJsComponentFactory reactComponentFactory;

  /// The cached Dart default props retrieved from [reactClass] that are passed
  /// into [generateExtendedJsProps] upon [ReactElement] creation.
  final Map defaultProps;

  ReactDartComponentFactoryProxy(ReactClass reactClass)
      : this.reactClass = reactClass,
        this.reactComponentFactory = React.createFactory(reactClass),
        this.defaultProps = reactClass.dartDefaultProps;

  ReactClass get type => reactClass;

  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    return reactComponentFactory(generateExtendedJsProps(props, children, defaultProps: defaultProps), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static InteropProps generateExtendedJsProps(Map props, dynamic children, {Map defaultProps}) {
    if (children == null) {
      children = [];
    } else if (children is! Iterable) {
      children = [children];
    }

    // 1. Merge in defaults (if they were specified)
    // 2. Add specified props and children.
    // 3. Remove "reserved" props that should not be visible to the rendered component.

    // [1]
    Map extendedProps = (defaultProps != null ? new Map.from(defaultProps) : {})
    // [2]
      ..addAll(props)
      ..['children'] = children
    // [3]
      ..remove('key')
      ..remove('ref');

    var internal = new ReactDartComponentInternal()..props = extendedProps;

    var interopProps = new InteropProps(internal: internal);

    // Don't pass a key into InteropProps if one isn't defined, so that the value will
    // be `undefined` in the JS, which is ignored by React, whereas `null` isn't.
    if (props.containsKey('key')) {
      interopProps.key = props['key'];
    }

    if (props.containsKey('ref')) {
      var ref = props['ref'];

      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      //
      // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
      // would fail the `is _CallbackRef<dynamic>` check.
      // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
      if (ref is _CallbackRef<Null>) {
        interopProps.ref = allowInterop((ReactComponent instance) {
          // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
          // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
          return (ref as dynamic)(instance?.dartComponent);
        });
      } else if (ref is Ref) {
        interopProps.ref = ref.jsRef;
      } else {
        interopProps.ref = ref;
      }
    }

    return interopProps;
  }
}

/// Creates ReactJS [Component2] instances for Dart components.
class ReactDartComponentFactoryProxy2<TComponent extends Component2> extends ReactComponentFactoryProxy
    implements ReactDartComponentFactoryProxy {
  /// The ReactJS class used as the type for all [ReactElement]s built by
  /// this factory.
  final ReactClass reactClass;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final ReactJsComponentFactory reactComponentFactory;

  final Map defaultProps;

  ReactDartComponentFactoryProxy2(ReactClass reactClass)
      : this.reactClass = reactClass,
        this.reactComponentFactory = React.createFactory(reactClass),
        this.defaultProps = new JsBackedMap.fromJs(reactClass.defaultProps);

  ReactClass get type => reactClass;

  ReactElement build(Map props, [List childrenArgs = const []]) {
    // TODO 3.1.0-wip if we don't pass in a list into React, we don't get a list back in Dart...

    List children;
    if (childrenArgs.isEmpty) {
      children = childrenArgs;
    } else if (childrenArgs.length == 1) {
      final singleChild = listifyChildren(childrenArgs[0]);
      if (singleChild is List) {
        children = singleChild;
      }
    }

    if (children == null) {
      // FIXME 3.1.0-wip are we cool to modify this list?
      // FIXME 3.1.0-wip why are there unmodifiable lists here?
      children = childrenArgs.map(listifyChildren).toList();
      markChildrenValidated(children);
    }

    return reactComponentFactory(
      generateExtendedJsProps(props),
      children,
    );
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  static JsMap generateExtendedJsProps(Map props) {
    final propsForJs = new JsBackedMap.from(props);

    final ref = propsForJs['ref'];
    if (ref != null) {
      // If the ref is a callback, pass ReactJS a function that will call it
      // with the Dart Component instance, not the ReactComponent instance.
      //
      // Use _CallbackRef<Null> to check arity, since parameters could be non-dynamic, and thus
      // would fail the `is _CallbackRef<dynamic>` check.
      // See https://github.com/dart-lang/sdk/issues/34593 for more information on arity checks.
      if (ref is _CallbackRef<Null>) {
        propsForJs['ref'] = allowInterop((ReactComponent instance) {
          // Call as dynamic to perform dynamic dispatch, since we can't cast to _CallbackRef<dynamic>,
          // and since calling with non-null values will fail at runtime due to the _CallbackRef<Null> typing.
          return (ref as dynamic)(instance?.dartComponent);
        });
      }

      if (ref is Ref) {
        propsForJs['ref'] = ref.jsRef;
      }
    }

    return propsForJs.jsObject;
  }
}

/// Creates ReactJS [ReactElement] instances for DOM components.
class ReactDomComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The name of the proxied DOM component.
  ///
  /// E.g. `'div'`, `'a'`, `'h1'`
  final String name;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final Function factory;

  ReactDomComponentFactoryProxy(name)
      : this.name = name,
        this.factory = React.createFactory(name) {
    // TODO: Should we remove this once we validate that the bug is gone in Dart 2 DDC?
    if (ddc_emulated_function_name_bug.isBugPresent) {
      ddc_emulated_function_name_bug.patchName(this);
    }
  }

  @override
  String get type => name;

  @override
  ReactElement build(Map props, [List childrenArgs = const []]) {
    var children = convertArgsToChildren(childrenArgs);
    children = listifyChildren(children);

    // We can't mutate the original since we can't be certain that the value of the
    // the converted event handler will be compatible with the Map's type parameters.
    var convertibleProps = new Map.from(props);
    convertProps(convertibleProps);

    // jsifyAndAllowInterop also handles converting props with nested Map/List structures, like `style`
    return factory(jsifyAndAllowInterop(convertibleProps), children);
  }

  /// Performs special handling of certain props for consumption by ReactJS DOM components.
  static void convertProps(Map props) {
    convertEventHandlers(props);
    convertRefValue(props);
  }
}

/// Creates ReactJS [ReactElement] instances for components defined in the JS.
class ReactJsComponentFactoryProxy extends ReactComponentFactoryProxy {
  /// The JS class used by this factory.
  @override
  final ReactClass type;

  /// The JS component factory used by this factory to build [ReactElement]s.
  final Function factory;

  /// Whether to automatically prepare props relating to bound values and event handlers
  /// via [ReactDomComponentFactoryProxy.convertProps] for consumption by React JS DOM components.
  ///
  /// Useful when the JS component forwards DOM props to its rendered DOM components.
  ///
  /// Disable for more custom handling of these props.
  final bool shouldConvertDomProps;

  /// Whether the props.children should always be treated as a list or not.
  /// Default: `false`
  final bool alwaysReturnChildrenAsList;

  ReactJsComponentFactoryProxy(ReactClass jsClass,
      {this.shouldConvertDomProps: true, this.alwaysReturnChildrenAsList: false})
      : this.type = jsClass,
        this.factory = React.createFactory(jsClass) {
    if (jsClass == null) {
      throw new ArgumentError('`jsClass` must not be null. '
          'Ensure that the JS component class you\'re referencing is available and being accessed correctly.');
    }
  }

  @override
  ReactElement build(Map props, [List childrenArgs]) {
    dynamic children = convertArgsToChildren(childrenArgs);

    if (alwaysReturnChildrenAsList && children is! List) {
      children = [children];
    }

    Map potentiallyConvertedProps;

    final mightNeedConverting = shouldConvertDomProps || props['ref'] != null;
    if (mightNeedConverting) {
      // We can't mutate the original since we can't be certain that the value of the
      // the converted event handler will be compatible with the Map's type parameters.
      // We also want to avoid mutating the original map where possible.
      // So, make a copy and mutate that.
      potentiallyConvertedProps = Map.from(props);
      if (shouldConvertDomProps) {
        convertEventHandlers(potentiallyConvertedProps);
      }
      convertRefValue(potentiallyConvertedProps);
    } else {
      potentiallyConvertedProps = props;
    }

    // jsifyAndAllowInterop also handles converting props with nested Map/List structures, like `style`
    return factory(jsifyAndAllowInterop(potentiallyConvertedProps), children);
  }
}

/// Creates ReactJS [ReactElement] instances for `JSContext` components.
///
/// Adds special jsifying and unjsifying of the `value` prop.
class ReactJsContextComponentFactoryProxy extends ReactJsComponentFactoryProxy {
  /// The JS class used by this factory.
  @override
  final ReactClass type;
  final bool isConsumer;
  final bool isProvider;
  final Function factory;
  final bool shouldConvertDomProps;

  ReactJsContextComponentFactoryProxy(
      ReactClass jsClass, {
        this.shouldConvertDomProps: true,
        this.isConsumer: false,
        this.isProvider: false,
      })  : this.type = jsClass,
        this.factory = React.createFactory(jsClass),
        super(jsClass, shouldConvertDomProps: shouldConvertDomProps);

  @override
  ReactElement build(Map props, [List childrenArgs]) {
    dynamic children = convertArgsToChildren(childrenArgs);

    if (isConsumer) {
      if (children is Function) {
        Function contextCallback = children;
        children = allowInterop((args) {
          return contextCallback(ContextHelpers.unjsifyNewContext(args));
        });
      }
    }

    return factory(generateExtendedJsProps(props), children);
  }

  /// Returns a JavaScript version of the specified [props], preprocessed for consumption by ReactJS and prepared for
  /// consumption by the [react] library internals.
  JsMap generateExtendedJsProps(Map props) {
    JsBackedMap propsForJs = new JsBackedMap.from(props);

    if (isProvider) {
      propsForJs['value'] = ContextHelpers.jsifyNewContext(propsForJs['value']);
    }

    return propsForJs.jsObject;
  }
}
