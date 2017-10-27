function getUpdatingSetStateLifeCycleCalls() {
  return _updatingSetStateLifeCycleCalls;
}

var _updatingSetStateLifeCycleCalls = [];

function getNonUpdatingSetStateLifeCycleCalls() {
  return _nonUpdatingSetStateLifeCycleCalls;
}

var _nonUpdatingSetStateLifeCycleCalls = [];

var ReactSetStateTestComponent = React.createClass({
  getDefaultProps: function() {
    return {shouldUpdate: true};
  },

  getInitialState: function() {
    return {counter: 0};
  },

  recordLifecyleCall: function(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name)
  },

  componentWillReceiveProps: function(_) {
    this.recordLifecyleCall("componentWillReceiveProps");
  },

  componentWillReceivePropsWithContext: function(_) {
    this.recordLifecyleCall("componentWillReceivePropsWithContext");
  },

  shouldComponentUpdate: function(_, __) {
    this.recordLifecyleCall("shouldComponentUpdate");
    return this.props.shouldUpdate;
  },

  shouldComponentUpdateWithContext: function(_, __, ___) {
    this.recordLifecyleCall("shouldComponentUpdateWithContext");
    return this.props.shouldUpdate;
  },

  componentWillUpdate: function(_, __) {
    this.recordLifecyleCall("componentWillUpdate");
  },

  componentWillUpdateWithContext: function(_, __, ___) {
    this.recordLifecyleCall("componentWillUpdateWithContext");
  },

  componentDidUpdate: function(_, __) {
    this.recordLifecyleCall("componentDidUpdate");
  },

  componentDidUpdateWithContext: function(_, __, ___) {
    this.recordLifecyleCall("componentDidUpdateWithContext");
  },

  outerSetStateCallback: function() {
    this.recordLifecyleCall('outerSetStateCallback');
  },

  innerSetStateCallback: function() {
    this.recordLifecyleCall('innerSetStateCallback');
  },

  outerTransactionalSetStateCallback: function(previousState, props) {
    this.recordLifecyleCall('outerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  },

  innerTransactionalSetStateCallback: function(previousState, props) {
    this.recordLifecyleCall('innerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  },

  handleOuterClick: function(_) {
    this.setState(this.outerTransactionalSetStateCallback, this.outerSetStateCallback);
  },

  handleInnerClick: function(_) {
    this.setState(this.innerTransactionalSetStateCallback, this.innerSetStateCallback);
  },

  render: function() {
    return React.createElement("div", {onClick: this.handleOuterClick},
      React.createElement("div", {onClick: this.handleInnerClick}, this.state.counter)
    );
  }
});

var updatingInstance = ReactDOM.render(
  React.createElement(ReactSetStateTestComponent),
  document.createElement("div")
);

var nonUpdatingInstance = ReactDOM.render(
  React.createElement(ReactSetStateTestComponent, {shouldUpdate: false}),
  document.createElement("div")
);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(updatingInstance).children[0]);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(nonUpdatingInstance).children[0]);
