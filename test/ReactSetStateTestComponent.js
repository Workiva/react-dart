function getUpdatingSetStateLifeCycleCalls() {
  return _updatingSetStateLifeCycleCalls;
}

var _updatingSetStateLifeCycleCalls = [];

function getNonUpdatingSetStateLifeCycleCalls() {
  return _nonUpdatingSetStateLifeCycleCalls;
}

var _nonUpdatingSetStateLifeCycleCalls = [];

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

  recordLifecycleCall(name) {
    this.props.shouldUpdate ? _updatingSetStateLifeCycleCalls.push(name) : _nonUpdatingSetStateLifeCycleCalls.push(name);
    this.recordStateChange(this.state.counter);
  }

  UNSAFE_componentWillReceiveProps(_) {
    this.recordLifecycleCall("componentWillReceiveProps");
  }

  shouldComponentUpdate(_, __) {
    this.recordLifecycleCall("shouldComponentUpdate");
    return this.props.shouldUpdate;
  }

  UNSAFE_componentWillUpdate(_, __) {
    this.recordLifecycleCall("componentWillUpdate");
  }

  componentDidUpdate(_, __) {
    this.recordLifecycleCall("componentDidUpdate");
  }

  outerSetStateCallback() {
    this.recordLifecycleCall('outerSetStateCallback');
  }

  innerSetStateCallback() {
    this.recordLifecycleCall('innerSetStateCallback');
  }

  outerTransactionalSetStateCallback(previousState, props) {
    this.recordLifecycleCall('outerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  innerTransactionalSetStateCallback(previousState, props) {
    this.recordLifecycleCall('innerTransactionalSetStateCallback');
    return {counter: previousState.counter + 1};
  }

  handleOuterClick(_) {
    this.setState(this.outerTransactionalSetStateCallback.bind(this), this.outerSetStateCallback.bind(this));
  }

  handleInnerClick(_) {
    this.setState(this.innerTransactionalSetStateCallback.bind(this), this.innerSetStateCallback.bind(this));
  }

  render() {
    this.recordLifecycleCall('render');
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