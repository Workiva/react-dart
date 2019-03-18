function getUpdatingSetStateLifeCycleCalls() {
  return _updatingSetStateLifeCycleCalls;
}

var _updatingSetStateLifeCycleCalls = [];

function getComponent2UpdatingSetStateLifeCycleCalls() {
  return _component2UpdatingSetStateLifeCycleCalls;
}

var _component2UpdatingSetStateLifeCycleCalls = [];

function getNonUpdatingSetStateLifeCycleCalls() {
  return _nonUpdatingSetStateLifeCycleCalls;
}

var _nonUpdatingSetStateLifeCycleCalls = [];

function getComponent2NonUpdatingSetStateLifeCycleCalls() {
  return _component2NonUpdatingSetStateLifeCycleCalls;
}

var _component2NonUpdatingSetStateLifeCycleCalls = [];

function getLatestJSCounter() {
  return _counter;
}

function getUpdatingRenderedCounter() {
  return ReactDOM.findDOMNode(updatingInstance).textContent;
}

function getNonUpdatingRenderedCounter() {
  return ReactDOM.findDOMNode(nonUpdatingInstance).textContent;
}

var _counter;

class ReactSetStateTestComponent extends React.Component {
  constructor(props) {
    super(props);
    _counter = 1;
    this.state = {counter: _counter};
  }

  recordStateChange(newCount) {
    _counter = newCount;
  }

  recordLifecyleCall(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name);
    this.recordStateChange(this.state.counter);
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
    this.recordLifecyleCall('render');
    return React.createElement("div", {onClick: this.handleOuterClick.bind(this)},
      React.createElement("div", {onClick: this.handleInnerClick.bind(this)}, this.state.counter)
    );
  }
}

class ReactSetStateTestComponent2 extends React.Component2 {
  constructor(props) {
    super(props);
    _counter = 1;
    this.state = {counter: _counter};
  }

  recordStateChange(newCount) {
    _counter = newCount;
  }

  recordLifecyleCall(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name);
    this.recordStateChange(this.state.counter);
  }

  recordComponent2LifecyleCall(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name);
    this.recordStateChange(this.state.counter);
  }

  shouldComponentUpdate(_, __) {
    this.recordComponent2LifecyleCall("shouldComponentUpdate");
    return this.props.shouldUpdate;
  }

  getSnapshotBeforeUpdate(_, __) {
    this.recordComponent2LifecyleCall("getSnapshotBeforeUpdate");
  }

  componentDidUpdate(_, __, ___) {
    this.recordComponent2LifecyleCall("componentDidUpdate");
  }

  outerSetStateCallback() {
    this.recordComponent2LifecyleCall('outerSetStateCallback');
  }

  innerSetStateCallback() {
    this.recordComponent2LifecyleCall('innerSetStateCallback');
  }

  outerTransactionalSetStateCallback(previousState, props) {
    this.recordComponent2LifecyleCall('outerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  innerTransactionalSetStateCallback(previousState, props) {
    this.recordComponent2LifecyleCall('innerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  handleOuterClick(_) {
    this.setState(this.outerTransactionalSetStateCallback.bind(this), this.outerSetStateCallback.bind(this));
  }

  handleInnerClick(_) {
    this.setState(this.innerTransactionalSetStateCallback.bind(this), this.innerSetStateCallback.bind(this));
  }

  render() {
    this.recordComponent2LifecyleCall('render');
    return React.createElement("div", {onClick: this.handleOuterClick.bind(this)},
        React.createElement("div", {onClick: this.handleInnerClick.bind(this)}, this.state.counter)
    );
  }
}

ReactSetStateTestComponent.defaultProps = { shouldUpdate: true };
ReactSetStateTestComponent2.defaultProps = { shouldUpdate: true };

var updatingInstance = ReactDOM.render(
  React.createElement(ReactSetStateTestComponent),
  document.createElement("div")
);

var nonUpdatingInstance = ReactDOM.render(
    React.createElement(ReactSetStateTestComponent, {shouldUpdate: false}),
    document.createElement("div")
);

var reactComponent2UpdatingInstance = ReactDOM.render(
    React.createElement(ReactSetStateTestComponent2),
    document.createElement("div")
);

var reactComponent2NonUpdatingInstance = ReactDOM.render(
    React.createElement(ReactSetStateTestComponent2, {shouldUpdate: false}),
    document.createElement("div")
);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(updatingInstance).children[0]);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(nonUpdatingInstance).children[0]);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(reactComponent2UpdatingInstance).children[0]);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(reactComponent2NonUpdatingInstance).children[0]);
