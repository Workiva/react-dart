/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
function _getProperty(obj, key) { return obj[key]; }
function _setProperty(obj, key, value) { return obj[key] = value; }

function _createReactDartComponentClass(dartInteropStatics, componentStatics) {
  return class extends React.Component {
    constructor(props) {
      super(props);
      dartInteropStatics.initComponent(this, this.props.internal, componentStatics);
    }
    UNSAFE_componentWillMount() {
      dartInteropStatics.handleComponentWillMount(this.props.internal);
    }
    componentDidMount() {
      dartInteropStatics.handleComponentDidMount(this.props.internal);
    }
    /*
    /// This cannot be used with UNSAFE_ lifecycle methods.
    getDerivedStateFromProps(nextProps, prevState) {
      return dartInteropStatics.handleGetDerivedStateFromProps(this.props.internal, nextProps.internal);
    }
    */
    UNSAFE_componentWillReceiveProps(nextProps) {
      dartInteropStatics.handleComponentWillReceiveProps(this.props.internal, nextProps.internal);
    }
    shouldComponentUpdate(nextProps, nextState) {
      return dartInteropStatics.handleShouldComponentUpdate(this.props.internal, nextProps.internal);
    }
    /*
    /// This cannot be used with UNSAFE_ lifecycle methods.
    getSnapshotBeforeUpdate() {
      return dartInteropStatics.handleGetSnapshotBeforeUpdate(this.props.internal, prevProps.internal);
    }
    */
    UNSAFE_componentWillUpdate(nextProps, nextState) {
      dartInteropStatics.handleComponentWillUpdate(this.props.internal, nextProps.internal);
    }
    componentDidUpdate(prevProps, prevState) {
      dartInteropStatics.handleComponentDidUpdate(this.props.internal, prevProps.internal);
    }
    componentWillUnmount() {
      dartInteropStatics.handleComponentWillUnmount(this.props.internal);
    }
    render() {
      return dartInteropStatics.handleRender(this.props.internal)
    }
    componentDidCatch(error, info) {
      dartInteropStatics.handleComponentDidCatch(error, info);
    }
  }
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
