/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */

/// Prefix to namespace react-dart symbols
const _reactDartSymbolPrefix = 'react-dart.';

/// A global symbol to identify javascript objects owned by react-dart context,
/// in order to jsify and unjsify context objects correctly.
const _reactDartContextSymbol = Symbol(_reactDartSymbolPrefix + 'context');

/// A JS side function to allow Dart to throw an error from JS in order to catch it Dart side.
/// Used within Component2 error boundry methods to dartify the error argument.
/// See: https://github.com/dart-lang/sdk/issues/36363
function _throwErrorFromJS(error) {
  throw error;
}

/// A JS variable that can be used with Fart interop in order to force returning a
/// JavaScript `null`. This prevents dart2js from possibly converting Dart `null` into `undefined`.
const _jsNull = null;

function _createReactDartComponentClass(dartInteropStatics, componentStatics, jsConfig) {
  class ReactDartComponent extends React.Component {
    constructor(props, context) {
      super(props, context);
      this.dartComponent = dartInteropStatics.initComponent(this, this.props.internal, this.context, componentStatics);
    }
    UNSAFE_componentWillMount() {
      dartInteropStatics.handleComponentWillMount(this.dartComponent);
    }
    componentDidMount() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    }
    /*
    /// This cannot be used with UNSAFE_ lifecycle methods.
    getDerivedStateFromProps(nextProps, prevState) {
      return dartInteropStatics.handleGetDerivedStateFromProps(this.props.internal, nextProps.internal);
    }
    */
    UNSAFE_componentWillReceiveProps(nextProps, nextContext) {
      dartInteropStatics.handleComponentWillReceiveProps(this.dartComponent, nextProps.internal, nextContext);
    }
    shouldComponentUpdate(nextProps, nextState, nextContext) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent, nextContext);
    }
    /*
    /// This cannot be used with UNSAFE_ lifecycle methods.
    getSnapshotBeforeUpdate() {
      return dartInteropStatics.handleGetSnapshotBeforeUpdate(this.props.internal, prevProps.internal);
    }
    */
    UNSAFE_componentWillUpdate(nextProps, nextState, nextContext) {
      dartInteropStatics.handleComponentWillUpdate(this.dartComponent, nextContext);
    }
    componentDidUpdate(prevProps, prevState) {
      dartInteropStatics.handleComponentDidUpdate(this.dartComponent, prevProps.internal);
    }
    componentWillUnmount() {
      dartInteropStatics.handleComponentWillUnmount(this.dartComponent);
    }
    render() {
      var result = dartInteropStatics.handleRender(this.dartComponent);
      if (typeof result === 'undefined') result = null;
      return result;
    }
  }

  // React limits the accessible context entries
  // to the keys specified in childContextTypes/contextTypes.
  var childContextKeys = jsConfig && jsConfig.childContextKeys;
  var contextKeys = jsConfig && jsConfig.contextKeys;

  if (childContextKeys && childContextKeys.length !== 0) {
    ReactDartComponent.childContextTypes = {};
    for (var i = 0; i < childContextKeys.length; i++) {
      ReactDartComponent.childContextTypes[childContextKeys[i]] = React.PropTypes.object;
    }
    // Only declare this when `childContextKeys` is non-empty to avoid unnecessarily
    // creating interop context objects for components that won't use it.
    ReactDartComponent.prototype['getChildContext'] = function() {
      return dartInteropStatics.handleGetChildContext(this.dartComponent);
    };
  }

  if (contextKeys && contextKeys.length !== 0) {
    ReactDartComponent.contextTypes = {};
    for (var i = 0; i < contextKeys.length; i++) {
      ReactDartComponent.contextTypes[contextKeys[i]] = React.PropTypes.object;
    }
  }

  return ReactDartComponent;
}

function _createReactDartComponentClass2(dartInteropStatics, componentStatics, jsConfig) {
  class ReactDartComponent2 extends React.Component {
    constructor(props, context) {
      super(props, context);
      // TODO combine these two calls into one
      this.dartComponent = dartInteropStatics.initComponent(this, componentStatics);
    }

    componentDidMount() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    }
    shouldComponentUpdate(nextProps, nextState) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent, nextProps, nextState);
    }

    static getDerivedStateFromProps(nextProps, prevState) {
      let derivedState = dartInteropStatics.handleGetDerivedStateFromProps(componentStatics, nextProps, prevState);
      return typeof derivedState !== 'undefined' ? derivedState : null;
    }

    getSnapshotBeforeUpdate(prevProps, prevState) {
      let snapshot = dartInteropStatics.handleGetSnapshotBeforeUpdate(this.dartComponent, prevProps, prevState);
      return typeof snapshot !== 'undefined' ? snapshot : null;
    }
    componentDidUpdate(prevProps, prevState, snapshot) {
      dartInteropStatics.handleComponentDidUpdate(this.dartComponent, this, prevProps, prevState, snapshot);
    }
    componentWillUnmount() {
      dartInteropStatics.handleComponentWillUnmount(this.dartComponent);
    }
    componentDidCatch(error, info) {
      dartInteropStatics.handleComponentDidCatch(this.dartComponent, error, info);
    }
    static getDerivedStateFromError(error) {
      let derivedState = dartInteropStatics.handleGetDerivedStateFromError(componentStatics, error);
      return typeof derivedState !== 'undefined' ? derivedState : null;
    }
    render() {
      // Must call checkPropTypes manually because React moved away from using the `prop-types` package.
      // See: https://github.com/facebook/react/pull/18127
      // React now uses its own internal cache of errors for PropTypes which broke `PropTypes.resetWarningCache()`.
      // Solution was to use `PropTypes.checkPropTypes` directly which makes `PropTypes.resetWarningCache()` work.
      // Solution from: https://github.com/facebook/react/issues/18251#issuecomment-609024557
      // TODO: figure out how to get the `displayName` here...
      React.PropTypes.checkPropTypes(jsConfig.propTypes, this.props, 'prop', this._getDisplayName());
      var result = dartInteropStatics.handleRender(this.dartComponent, this.props, this.state, this.context);
      if (typeof result === 'undefined') result = null;
      return result;
    }
    // Hacky workaround to get the displayName for `checkPropTypes` call.
    _getDisplayName() {
      return ReactDartComponent2.displayName;
    }
  }

  if (jsConfig) {
    // Delete methods that the user does not want to include (such as error boundary event).
    jsConfig.skipMethods.forEach(method => {
      if (ReactDartComponent2[method]) {
        delete ReactDartComponent2[method];
      } else {
        delete ReactDartComponent2.prototype[method];
      }
    });

    if (jsConfig.contextType) {
      ReactDartComponent2.contextType = jsConfig.contextType;
    }
    if (jsConfig.defaultProps) {
      ReactDartComponent2.defaultProps = jsConfig.defaultProps;
    }
  }

  return ReactDartComponent2;
}

function _markChildValidated(child) {
  const store = child._store;
  if (store) store.validated = true;
}

export default {
  _reactDartContextSymbol,
  _createReactDartComponentClass,
  _createReactDartComponentClass2,
  _markChildValidated,
  _throwErrorFromJS,
  _jsNull,
};
