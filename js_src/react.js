// React 16 Polyfill requirements: https://reactjs.org/docs/javascript-environment-requirements.html
import 'core-js/es/map';
import 'core-js/es/set';

// Know required Polyfill's for dart side usage
import 'core-js/stable/reflect/delete-property';
import 'core-js/stable/object/assign';

// Additional polyfills are included by core-js based on 'usage' and browser requirements

// Custom dart side methods
import DartHelpers from './_dart_helpers';

const React = require('react');
const PropTypes = require('prop-types');
const CreateReactClass = require('create-react-class');

window.React = React;
Object.assign(window, DartHelpers);

React.createClass = CreateReactClass; // TODO: Remove this once over_react_test doesnt rely on createClass.
React.PropTypes = PropTypes; // Only needed to support legacy context until we update. lol jk we need it for prop validation now.

if (process.env.NODE_ENV == 'production') {
    require('./dart_env_prod');
} else {
    require('./dart_env_dev');
}
