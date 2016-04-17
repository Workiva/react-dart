function _initReactDartInteropMixin(dartInteropStatics, componentFactory) {
  var ReactDartInteropMixin = {
    getInitialState: function() {
      dartInteropStatics.initComponent(this, this.props.internal, componentFactory);
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

  return ReactDartInteropMixin;
}

function _markChildValidated(child) {
  var store = child._store;
  if (store) store.validated = true;
}
