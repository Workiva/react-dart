const ShallowRenderer = require('react-test-renderer/shallow');
const TestUtils = require('react-dom/test-utils');


if (!window.React.addons) {
    window.React.addons = {};
}
window.React.addons.TestUtils = TestUtils;
if (!window.React.addons.TestUtils.createRenderer) {
    window.React.addons.TestUtils.createRenderer = ShallowRenderer.createRenderer;
}
window.ReactShallowRenderer = ShallowRenderer;

