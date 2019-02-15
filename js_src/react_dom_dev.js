const ShallowRenderer = require('react-test-renderer/shallow');
const TestUtils = require('react-dom/test-utils');


if (!window.React.addons) {
    window.React.addons = {};
}
window.React.addons.TestUtils = TestUtils;
window.ReactShallowRenderer = ShallowRenderer;

