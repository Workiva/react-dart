/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
/// Prefix to namespace react-dart symbols
var _reactDartSymbolPrefix = 'react-dart.';
/// A global symbol to identify javascript objects owned by react-dart context,
/// in order to jsify and unjsify context objects correctly.
var _reactDartContextSymbol = Symbol(_reactDartSymbolPrefix+'context');

/// A JS side function to allow Dart to throw an error from JS in order to catch it Dart side.
/// Used within Component2 error boundry methods to dartify the error argument.
/// See: https://github.com/dart-lang/sdk/issues/36363
function _throwErrorFromJS(error){
  throw error;
}

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
      this.state = null;
      this.dartComponent = dartInteropStatics.initComponent(this, componentStatics);
      const initialStateFromGetInitialState =
      dartInteropStatics.handleGetInitialState(this.dartComponent);
      // If the returned state is empty, assume it's coming from the default implementation.
      // This is done to avoid changing the default getInitialState implementation to null, which would cause breakages.
      if (this.state && Object.keys(initialStateFromGetInitialState).length != 0) {
        throw 'Error: State cannot be initialized in both init and getInitialState';
      } else if (!this.state) {
        this.state = initialStateFromGetInitialState;
      }
    }

    componentDidMount() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    }
    shouldComponentUpdate(nextProps, nextState, nextContext) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent, nextProps, nextState, nextContext);
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
      return dartInteropStatics.handleGetDerivedStateFromError(componentStatics, error);
    }
    render() {
      var result = dartInteropStatics.handleRender(this.dartComponent, this.props, this.state, this.context);
      if (typeof result === 'undefined') result = null;
      return result;
    }
  }

  // Delete methods that the user does not want to include (such as error boundary event).
  jsConfig.skipMethods.forEach((method) => {
    if (ReactDartComponent2[method]) {
      delete ReactDartComponent2[method];
    } else {
      delete ReactDartComponent2.prototype[method];
    }
  });

  if (jsConfig) {
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
}
