
/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
function _getProperty(obj, key) { return obj[key]; }
function _setProperty(obj, key, value) { return obj[key] = value; }

function _createReactDartComponentClassConfig(dartInteropStatics, componentStatics) {
  return {
    getInitialState: function() {
      this.dartComponent = dartInteropStatics.initComponent(this, this.props.internal, componentStatics);
      return {};
    },
    componentWillMount: function() {
      dartInteropStatics.handleComponentWillMount(this.dartComponent);
    },
    componentDidMount: function() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    },
    componentWillReceiveProps: function(nextProps) {
      dartInteropStatics.handleComponentWillReceiveProps(this.dartComponent, nextProps.internal);
    },
    shouldComponentUpdate: function(nextProps, nextState) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent);
    },
    componentWillUpdate: function(nextProps, nextState) {
      dartInteropStatics.handleComponentWillUpdate(this.dartComponent);
    },
    componentDidUpdate: function(prevProps, prevState) {
      dartInteropStatics.handleComponentDidUpdate(this.dartComponent, prevProps.internal);
    },
    componentWillUnmount: function() {
      dartInteropStatics.handleComponentWillUnmount(this.dartComponent);
    },
    render: function() {
      return dartInteropStatics.handleRender(this.dartComponent);
    }
  };
}

function _markChildValidated(child) {
  var store = child._store;
  if (store) store.validated = true;
}
