const ReactRedux = require('react-redux');
const ReactDOM = require('react-dom');
const ReactDOMClient = require('react-dom/client');
const ReactTestUtils = require('react-dom/test-utils');

window.ReactDOM = ReactDOM;
window.ReactDOMClient = ReactDOMClient;
window.ReactRedux = ReactRedux;
window.ReactTestUtils = {
  'act': ReactTestUtils.act,
}

if (process.env.NODE_ENV == 'development') {
    require('./react_dom_dev');
}
