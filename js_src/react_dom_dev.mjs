import ShallowRenderer from 'react-test-renderer/shallow';
import TestUtils from 'react-dom/test-utils';

if (!globalThis.React.addons) {
  globalThis.React.addons = {};
}
globalThis.React.addons.TestUtils = TestUtils;
if (!globalThis.React.addons.TestUtils.createRenderer) {
  globalThis.React.addons.TestUtils.createRenderer = ShallowRenderer.createRenderer;
}
