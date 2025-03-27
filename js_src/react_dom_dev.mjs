import ShallowRenderer from 'react-test-renderer/shallow';
import TestUtils from 'react-dom/test-utils';
import React from 'react';

if (!React.addons) {
    React.addons = {};
}
React.addons.TestUtils = TestUtils;
if (!React.addons.TestUtils.createRenderer) {
    React.addons.TestUtils.createRenderer = ShallowRenderer.createRenderer;
}

