function getComponent2UpdatingSetStateLifeCycleCalls() {
    return _component2UpdatingSetStateLifeCycleCalls;
}

var _component2UpdatingSetStateLifeCycleCalls = [];

function getComponent2NonUpdatingSetStateLifeCycleCalls() {
    return _component2NonUpdatingSetStateLifeCycleCalls;
}

var _component2NonUpdatingSetStateLifeCycleCalls = [];

function getComponent2LatestJSCounter() {
    return _component2Counter;
}

function getComponent2UpdatingRenderedCounter() {
    return ReactDOM.findDOMNode(updatingInstance).textContent;
}

function getComponent2NonUpdatingRenderedCounter() {
    return ReactDOM.findDOMNode(nonUpdatingInstance).textContent;
}

var _component2Counter;

class ReactSetStateTestComponent2 extends React.Component {
    constructor(props) {
        super(props);
        _component2Counter = 1;
        this.state = {counter: _component2Counter};
    }

    recordStateChange(newCount) {
        _component2Counter = newCount;
    }

    recordLifecycleCall(name) {
        this.props.shouldUpdate ? _component2UpdatingSetStateLifeCycleCalls.push(name) : _component2NonUpdatingSetStateLifeCycleCalls.push(name);
        this.recordStateChange(this.state.counter);
    }

    getDerivedStateFromProps(_, __) {
        this.recordLifecycleCall("getDerivedStateFromProps");
    }

    shouldComponentUpdate(_, __) {
        this.recordLifecycleCall("shouldComponentUpdate");
        return this.props.shouldUpdate;
    }

    getSnapshotBeforeUpdate(_, __) {
        this.recordLifecycleCall("getSnapshotBeforeUpdate");
    }

    componentDidUpdate(_, __, ___) {
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


ReactSetStateTestComponent2.defaultProps = { shouldUpdate: true };

var reactComponent2UpdatingInstance = ReactDOM.render(
    React.createElement(ReactSetStateTestComponent2),
    document.createElement("div")
);

var reactComponent2NonUpdatingInstance = ReactDOM.render(
    React.createElement(ReactSetStateTestComponent2, {shouldUpdate: false}),
    document.createElement("div")
);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(reactComponent2UpdatingInstance).children[0]);

React.addons.TestUtils.Simulate.click(ReactDOM.findDOMNode(reactComponent2NonUpdatingInstance).children[0]);
