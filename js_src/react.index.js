// React 16 Polyfill requirements: https://reactjs.org/docs/javascript-environment-requirements.html
import 'core-js/es/map';
import 'core-js/es/set';

// Know required Polyfill's for dart side usage
import 'core-js/stable/reflect/delete-property';
import 'core-js/stable/object/assign';

// Used by dart_env_dev.js
import 'core-js/stable/string/starts-with';

// IE 11 polyfill
// Source: https://github.com/webcomponents/webcomponents-platform/issues/2
if (!('baseURI' in Node.prototype)) {
  Object.defineProperty(Node.prototype, 'baseURI', {
    get: function() {
      const base = (this.ownerDocument || this).querySelector('base');
      return (base || window.location).href;
    },
    configurable: true,
    enumerable: true
  });
}

import * as reactExports from './react';
// Custom dart side methods
import * as dartHelpers from './_dart_helpers';

window.ReactDart ??= {};
Object.assign(window.ReactDart, {
  ...reactExports,
  dartHelpers
});
