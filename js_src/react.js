// Additional polyfills are included by core-js based on 'usage' and browser requirements

const React = require('react');
const PropTypes = require('prop-types');
const CreateReactClass = require('create-react-class');

React.createClass = CreateReactClass; // TODO: Remove this once over_react_test doesnt rely on createClass.
React.PropTypes = PropTypes; // Only needed to support legacy context until we update. lol jk we need it for prop validation now.

if (process.env.NODE_ENV == 'production') {
  React.__isDevelopment = false;
  require('./dart_env_prod');
} else {
  React.__isDevelopment = true;
  require('./dart_env_dev');
}
export { React };
