function getUpdatingSetStateLifeCycleCalls() {
  return _updatingSetStateLifeCycleCalls;
}

var _updatingSetStateLifeCycleCalls = [];

function getNonUpdatingSetStateLifeCycleCalls() {
  return _nonUpdatingSetStateLifeCycleCalls;
}

var _nonUpdatingSetStateLifeCycleCalls = [];

class ReactSetStateTestComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {counter: 1};
  }

  recordLifecyleCall(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name)
  }

  UNSAFE_componentWillReceiveProps(_) {
    this.recordLifecyleCall("componentWillReceiveProps");
  }

  shouldComponentUpdate(_, __) {
    this.recordLifecyleCall("shouldComponentUpdate");
    return this.props.shouldUpdate;
  }

  UNSAFE_componentWillUpdate(_, __) {
    this.recordLifecyleCall("componentWillUpdate");
  }

  componentDidUpdate(_, __) {
    this.recordLifecyleCall("componentDidUpdate");
  }

  outerSetStateCallback() {
    this.recordLifecyleCall('outerSetStateCallback');
  }

  innerSetStateCallback() {
    this.recordLifecyleCall('innerSetStateCallback');
  }

  outerTransactionalSetStateCallback(previousState, props) {
    this.recordLifecyleCall('outerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  innerTransactionalSetStateCallback(previousState, props) {
    this.recordLifecyleCall('innerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  handleOuterClick(_) {
    this.setState(this.outerTransactionalSetStateCallback.bind(this), this.outerSetStateCallback.bind(this));
  }

  handleInnerClick(_) {
    this.setState(this.innerTransactionalSetStateCallback.bind(this), this.innerSetStateCallback.bind(this));
  }

  render() {
    return React.createElement("div", {onClick: this.handleOuterClick.bind(this)},
      React.createElement("div", {onClick: this.handleInnerClick.bind(this)}, this.state.counter)
    );
  }
}

ReactSetStateTestComponent.defaultProps = { shouldUpdate: true };

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
