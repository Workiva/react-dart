require('@babel/polyfill');
const ReactDOM = require('react-dom');

window.ReactDOM = ReactDOM;

if (process.env.NODE_ENV == 'development') {
    require('./react_dom_dev');
}
