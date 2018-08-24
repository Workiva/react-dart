
/**
 * react-dart JS interop helpers (used by react_client.dart and react_client/js_interop_helpers.dart)
 */
function _getProperty(obj, key) { return obj[key]; }
function _setProperty(obj, key, value) { return obj[key] = value; }

// Object.assign polyfill for IE11 from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign
if (typeof Object.assign !== 'function') {
  // Must be writable: true, enumerable: false, configurable: true
  Object.defineProperty(Object, 'assign', {
    value: function assign(target, varArgs) { // .length of function is 2
      'use strict';
      if (target == null) { // TypeError if undefined or null
        throw new TypeError('Cannot convert undefined or null to object');
      }

      var to = Object(target);

      for (var index = 1; index < arguments.length; index++) {
        var nextSource = arguments[index];

        if (nextSource != null) { // Skip over if undefined or null
          for (var nextKey in nextSource) {
            // Avoid bugs when hasOwnProperty is shadowed
            if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
              to[nextKey] = nextSource[nextKey];
            }
          }
        }
      }
      return to;
    },
    writable: true,
    configurable: true
  });
}

// Reflect.deleteProperty polyfill for IE11
if (typeof Reflect === 'undefined') {
  Reflect = {};
}
if (typeof Reflect.deleteProperty !== 'function') {
  Object.defineProperty(Reflect, 'deleteProperty', {
    value: function deleteProperty(target, propertyKey) {
      return (delete target[propertyKey]);
    }
  });
}

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
      var result = dartInteropStatics.handleRender(this.dartComponent);
      if (typeof result === 'undefined') result = null;
      return result;
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

function _createReactDartComponentClassConfig2(dartInteropStatics, componentStatics, jsConfig) {
  var config = {
    getInitialState: function() {
      // TODO combine these two calls into one
      this.dartComponent = dartInteropStatics.initComponent(this, componentStatics);
      return dartInteropStatics.handleGetInitialState(this.dartComponent);
    },
    componentWillMount: function() {
      dartInteropStatics.handleComponentWillMount(this.dartComponent, this);
    },
    componentDidMount: function() {
      dartInteropStatics.handleComponentDidMount(this.dartComponent);
    },
    componentWillReceiveProps: function(nextProps) {
      dartInteropStatics.handleComponentWillReceiveProps(this.dartComponent, nextProps);
    },
    shouldComponentUpdate: function(nextProps, nextState) {
      return dartInteropStatics.handleShouldComponentUpdate(this.dartComponent, nextProps, nextState);
    },
    componentWillUpdate: function(nextProps, nextState) {
      dartInteropStatics.handleComponentWillUpdate(this.dartComponent, nextProps, nextState);
    },
    componentDidUpdate: function(prevProps, prevState) {
      dartInteropStatics.handleComponentDidUpdate(this.dartComponent, this, prevProps, prevState);
    },
    componentWillUnmount: function() {
      dartInteropStatics.handleComponentWillUnmount(this.dartComponent);
    },
    render: function() {
      return dartInteropStatics.handleRender(this.dartComponent);
    }
  };

  return config;
}
