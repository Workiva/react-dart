const React = require('react/lib/ReactWithAddonsUMDEntry');
const DartHelpers = require('./_dart_helpers');

window.React = React;
Object.assign(window, DartHelpers);
