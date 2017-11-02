
/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
function _getProperty(obj, key) { return obj[key]; }
function _setProperty(obj, key, value) { return obj[key] = value; }

function _createReactDartComponentClassConfig(dartInteropStatics, componentStatics, jsConfig) {
  var config = {
    getInitialState: function() {
      this.dartComponent = dartInteropStatics.initComponent(this, this.props.internal, this.context, componentStatics);
      return {};
    },
    componentWillMount: function() {
      dartInteropStatics.handleComponentWillMount(this.dartComponent);
    },
    componentDidMount: function() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    },
    componentWillReceiveProps: function(nextProps, nextContext) {
      dartInteropStatics.handleComponentWillReceiveProps(this.dartComponent, nextProps.internal, nextContext);
    },
    shouldComponentUpdate: function(nextProps, nextState, nextContext) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent, nextContext);
    },
    componentWillUpdate: function(nextProps, nextState, nextContext) {
      dartInteropStatics.handleComponentWillUpdate(this.dartComponent, nextContext);
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

  // React limits the accessible context entries
  // to the keys specified in childContextTypes/contextTypes.

  var childContextKeys = jsConfig && jsConfig.childContextKeys;
  var contextKeys = jsConfig && jsConfig.contextKeys;

  if (childContextKeys && childContextKeys.length !== 0) {
    config.childContextTypes = {};
    for (var i = 0; i < childContextKeys.length; i++) {
      config.childContextTypes[childContextKeys[i]] = React.PropTypes.object;
    }

    // Only declare this when `childContextKeys` is non-empty to avoid unnecessarily
    // creating interop context objects for components that won't use it.
    config.getChildContext = function() {
      return dartInteropStatics.handleGetChildContext(this.dartComponent);
    };
  }

  if (contextKeys && contextKeys.length !== 0) {
    config.contextTypes = {};
    for (var i = 0; i < contextKeys.length; i++) {
      config.contextTypes[contextKeys[i]] = React.PropTypes.object;
    }
  }

  return config;
}

function _markChildValidated(child) {
  var store = child._store;
  if (store) store.validated = true;
}
