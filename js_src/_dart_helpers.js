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

  if (jsConfig && jsConfig.contextType) {
    ReactDartComponent.contextType = jsConfig.contextType;
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
