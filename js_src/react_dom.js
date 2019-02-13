const ReactDOM = require('react-dom');
const ReactTestUtils = require('react-dom/test-utils');
const ShallowRenderer = require('react-test-renderer/shallow');

window.ReactTestUtils = ReactTestUtils;
window.ShallowRenderer = ShallowRenderer;
window.ReactDOM = ReactDOM;
