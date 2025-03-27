// Custom dart side methods
import DartHelpers from './_dart_helpers';
import React from 'react';
import PropTypes from 'prop-types';
import createClass from 'create-react-class';

globalThis.React = {
  ...React,
  createClass, // TODO: Remove this once over_react_test doesnt rely on createClass.
  PropTypes: { ...PropTypes }, // Only needed to support legacy context until we update. lol jk we need it for prop validation now.
  __isDevelopment: process.env.NODE_ENV == 'development',
};

Object.assign(globalThis, {
  ...DartHelpers,
});

if (process.env.NODE_ENV == 'development') {
  import('./dart_env_dev.mjs');
}

// IE 11 polyfill
// Source: https://github.com/webcomponents/webcomponents-platform/issues/2
if (!('baseURI' in Node.prototype)) {
  Object.defineProperty(Node.prototype, 'baseURI', {
    get: function () {
      const base = (this.ownerDocument || this).querySelector('base');
      return (base || window.location).href;
    },
    configurable: true,
    enumerable: true,
  });
}
