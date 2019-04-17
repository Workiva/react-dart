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

function getComponent2UpdatingErrorMessage() {
    return ReactDOM.findDOMNode(updatingInstance).textContent;
}

function getComponent2NonUpdatingErrorMessage() {
    return ReactDOM.findDOMNode(nonUpdatingInstance).textContent;
}

function staticLifecycleCallProxy(name, shouldUpdate){
    shouldUpdate ? _component2UpdatingSetStateLifeCycleCalls.push(name) : _component2NonUpdatingSetStateLifeCycleCalls.push(name);
}

function getComponent2ErrorMessage(){
    return _error.toString();
}

function getComponent2ErrorInfo(){
    return _info.componentStack;
}

function getComponent2ErrorFromDerivedState(){
    return _errorFromGetDerivedState.toString();
}

var _component2Counter;
var _shouldThrow;
var _shouldUpdate;
var _error;
var _info;
var _errorFromGetDerivedState;

class ReactSetStateTestComponent2 extends React.Component {
    constructor(props) {
        super(props);
        _component2Counter = 1;
        _shouldThrow = true;
        _shouldUpdate = props.shouldUpdate;
        this.state = {counter: _component2Counter, shouldThrow: _shouldThrow, error: '', info: '', errorFromGetDerivedState: ''};
    }

    recordStateChange(newCount) {
        _component2Counter = newCount;
    }

    recordLifecycleCall(name) {
        this.props.shouldUpdate ? _component2UpdatingSetStateLifeCycleCalls.push(name) : _component2NonUpdatingSetStateLifeCycleCalls.push(name);
        this.recordStateChange(this.state.counter);
    }

    static getDerivedStateFromProps(nextProps, __) {
        _shouldUpdate = nextProps.shouldUpdate;
        _shouldUpdate 
            ? _component2UpdatingSetStateLifeCycleCalls.push("getDerivedStateFromProps") 
            : _component2NonUpdatingSetStateLifeCycleCalls.push("getDerivedStateFromProps");
        return null;
    }

    shouldComponentUpdate(_, __) {
        this.recordLifecycleCall("shouldComponentUpdate");
        _shouldUpdate = this.props.shouldUpdate;
        return this.props.shouldUpdate;
    }

    getSnapshotBeforeUpdate(_, __) {
        this.recordLifecycleCall("getSnapshotBeforeUpdate");
        return null;
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

    componentDidCatch(error, info) {
        this.recordLifecycleCall('componentDidCatch');
        _error = error;
        _info = info;
        this.setState({error, info});
    }

    static getDerivedStateFromError(error) {
        staticLifecycleCallProxy('getDerivedStateFromError', _shouldUpdate);
        _errorFromGetDerivedState = error;
        return {shouldThrow: false, errorFromGetDerivedState: error};
    }

    render() {
        this.recordLifecycleCall('render');
        if (!this.state.shouldThrow) {
            return React.createElement("div", {onClick: this.handleOuterClick.bind(this)},
                [
                    React.createElement("div", {onClick: this.handleInnerClick.bind(this), key: 'c1'}, this.state.counter),
                    React.createElement("div", {onClick: this.handleInnerClick.bind(this), key: 'c2'}, this.state.error.toString()),
                    React.createElement("div", {onClick: this.handleInnerClick.bind(this), key: 'c3'}, this.state.info.toString()),
                    React.createElement("div", {onClick: this.handleInnerClick.bind(this), key: 'c4'}, this.state.errorFromGetDerivedState.toString()),
                ]
            );
        } else {
            return React.createElement("div", {onClick: this.handleOuterClick.bind(this)},
                [
                    React.createElement("div", {onClick: this.handleInnerClick.bind(this), key: 'c1'}, this.state.counter),
                    React.createElement(ErrorComponent, {key: 'c2'}, null)
                ]
            );
        }
    }
}


class ErrorComponent extends React.Component {
    throwError() {
        throw "It crashed!";
    }

    render() {
        this.throwError();
        return React.createElement("div", {}, "Error");
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
