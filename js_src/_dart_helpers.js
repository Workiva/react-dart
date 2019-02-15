/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
function _getProperty(obj, key) { return obj[key]; }
function _setProperty(obj, key, value) { return obj[key] = value; }

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

function _markChildValidated(child) {
  const store = child._store;
  if (store) store.validated = true;
}

module.exports = {
  _getProperty,
  _setProperty,
  _createReactDartComponentClass,
  _markChildValidated,
};
