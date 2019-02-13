const React = require('react');
const PropTypes = require('prop-types');
const DartHelpers = require('./_dart_helpers');

// Only needed to support legacy context until we update.
window.ReactPropTypes = PropTypes;

window.React = React;
Object.assign(window, DartHelpers);

if (process.env.NODE_ENV == 'production') {
    require('./dart_env_prod');
} else {
    require('./dart_env_dev');
}
