/**
 * Returns a ReactClass config with lifecycle methods that hook into the specified methods, allowing for
 * react_client interop.
 */
function _createReactDartComponentClassConfig(dartInteropStatics, componentStatics) {
  return {
    getInitialState: function() {
      dartInteropStatics.initComponent(this, this.props.internal, componentStatics);
      return {};
    },
    componentWillMount: function() {
      dartInteropStatics.handleComponentWillMount(this.props.internal);
    },
    componentDidMount: function() {
      dartInteropStatics.handleComponentDidMount(this.props.internal);
    },
    componentWillReceiveProps: function(nextProps) {
      dartInteropStatics.handleComponentWillReceiveProps(this.props.internal, nextProps.internal);
    },
    shouldComponentUpdate: function(nextProps, nextState) {
      return dartInteropStatics.handleShouldComponentUpdate(this.props.internal, nextProps.internal);
    },
    componentWillUpdate: function(nextProps, nextState) {
      dartInteropStatics.handleComponentWillUpdate(this.props.internal, nextProps.internal);
    },
    componentDidUpdate: function(prevProps, prevState) {
      dartInteropStatics.handleComponentDidUpdate(this.props.internal, prevProps.internal);
    },
    componentWillUnmount: function() {
      dartInteropStatics.handleComponentWillUnmount(this.props.internal);
    },
    render: function() {
      return dartInteropStatics.handleRender(this.props.internal)
    }
  };
}

/**
 * Marks a ReactElement child as validated so that React doesn't emit key warnings.
 */
function _markChildValidated(child) {
  var store = child._store;
  if (store) store.validated = true;
}
