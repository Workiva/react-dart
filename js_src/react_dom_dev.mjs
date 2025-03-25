import ShallowRenderer from 'react-test-renderer/shallow';
import TestUtils from 'react-dom/test-utils';

if (!window.React.addons) {
    window.React.addons = {};
}
window.React.addons.TestUtils = TestUtils;
if (!window.React.addons.TestUtils.createRenderer) {
    window.React.addons.TestUtils.createRenderer = ShallowRenderer.createRenderer;
}

