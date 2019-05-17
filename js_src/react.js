require('./polyfill/delete_property');
require('./polyfill/object_assign');
require('@babel/polyfill');

const React = require('react');
const PropTypes = require('prop-types');
const DartHelpers = require('./_dart_helpers');
const CreateReactClass = require('create-react-class');

window.React = React;
Object.assign(window, DartHelpers);

React.createClass = CreateReactClass; // TODO: Remove this once over_react_test doesnt rely on createClass.
React.PropTypes = PropTypes; // Only needed to support legacy context until we update.

if (process.env.NODE_ENV == 'production') {
    require('./dart_env_prod');
} else {
    require('./dart_env_dev');
}
