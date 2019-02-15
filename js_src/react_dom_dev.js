const ShallowRenderer = require('react-test-renderer/shallow');
const TestUtils = require('react-dom/test-utils');

window.ReactTestUtils = TestUtils;
window.ReactShallowRenderer = ShallowRenderer;

