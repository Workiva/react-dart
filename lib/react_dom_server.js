/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./js_src/react_dom_server.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./js_src/react_dom_server.js":
/*!************************************!*\
  !*** ./js_src/react_dom_server.js ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

const ReactDOMServer = __webpack_require__(/*! react-dom/server */ "./node_modules/react-dom/server.browser.js");

module.exports = ReactDOMServer;


/***/ }),

/***/ "./node_modules/object-assign/index.js":
/*!*********************************************!*\
  !*** ./node_modules/object-assign/index.js ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/*
object-assign
(c) Sindre Sorhus
@license MIT
*/


/* eslint-disable no-unused-vars */
var getOwnPropertySymbols = Object.getOwnPropertySymbols;
var hasOwnProperty = Object.prototype.hasOwnProperty;
var propIsEnumerable = Object.prototype.propertyIsEnumerable;

function toObject(val) {
	if (val === null || val === undefined) {
		throw new TypeError('Object.assign cannot be called with null or undefined');
	}

	return Object(val);
}

function shouldUseNative() {
	try {
		if (!Object.assign) {
			return false;
		}

		// Detect buggy property enumeration order in older V8 versions.

		// https://bugs.chromium.org/p/v8/issues/detail?id=4118
		var test1 = new String('abc');  // eslint-disable-line no-new-wrappers
		test1[5] = 'de';
		if (Object.getOwnPropertyNames(test1)[0] === '5') {
			return false;
		}

		// https://bugs.chromium.org/p/v8/issues/detail?id=3056
		var test2 = {};
		for (var i = 0; i < 10; i++) {
			test2['_' + String.fromCharCode(i)] = i;
		}
		var order2 = Object.getOwnPropertyNames(test2).map(function (n) {
			return test2[n];
		});
		if (order2.join('') !== '0123456789') {
			return false;
		}

		// https://bugs.chromium.org/p/v8/issues/detail?id=3056
		var test3 = {};
		'abcdefghijklmnopqrst'.split('').forEach(function (letter) {
			test3[letter] = letter;
		});
		if (Object.keys(Object.assign({}, test3)).join('') !==
				'abcdefghijklmnopqrst') {
			return false;
		}

		return true;
	} catch (err) {
		// We don't expect any of the above to throw, but better to be safe.
		return false;
	}
}

module.exports = shouldUseNative() ? Object.assign : function (target, source) {
	var from;
	var to = toObject(target);
	var symbols;

	for (var s = 1; s < arguments.length; s++) {
		from = Object(arguments[s]);

		for (var key in from) {
			if (hasOwnProperty.call(from, key)) {
				to[key] = from[key];
			}
		}

		if (getOwnPropertySymbols) {
			symbols = getOwnPropertySymbols(from);
			for (var i = 0; i < symbols.length; i++) {
				if (propIsEnumerable.call(from, symbols[i])) {
					to[symbols[i]] = from[symbols[i]];
				}
			}
		}
	}

	return to;
};


/***/ }),

/***/ "./node_modules/prop-types/checkPropTypes.js":
/*!***************************************************!*\
  !*** ./node_modules/prop-types/checkPropTypes.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * Copyright (c) 2013-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */



var printWarning = function() {};

if (true) {
  var ReactPropTypesSecret = __webpack_require__(/*! ./lib/ReactPropTypesSecret */ "./node_modules/prop-types/lib/ReactPropTypesSecret.js");
  var loggedTypeFailures = {};
  var has = Function.call.bind(Object.prototype.hasOwnProperty);

  printWarning = function(text) {
    var message = 'Warning: ' + text;
    if (typeof console !== 'undefined') {
      console.error(message);
    }
    try {
      // --- Welcome to debugging React ---
      // This error was thrown as a convenience so that you can use this stack
      // to find the callsite that caused this warning to fire.
      throw new Error(message);
    } catch (x) {}
  };
}

/**
 * Assert that the values match with the type specs.
 * Error messages are memorized and will only be shown once.
 *
 * @param {object} typeSpecs Map of name to a ReactPropType
 * @param {object} values Runtime values that need to be type-checked
 * @param {string} location e.g. "prop", "context", "child context"
 * @param {string} componentName Name of the component for error messages.
 * @param {?Function} getStack Returns the component stack.
 * @private
 */
function checkPropTypes(typeSpecs, values, location, componentName, getStack) {
  if (true) {
    for (var typeSpecName in typeSpecs) {
      if (has(typeSpecs, typeSpecName)) {
        var error;
        // Prop type validation may throw. In case they do, we don't want to
        // fail the render phase where it didn't fail before. So we log it.
        // After these have been cleaned up, we'll let them throw.
        try {
          // This is intentionally an invariant that gets caught. It's the same
          // behavior as without this statement except with a better message.
          if (typeof typeSpecs[typeSpecName] !== 'function') {
            var err = Error(
              (componentName || 'React class') + ': ' + location + ' type `' + typeSpecName + '` is invalid; ' +
              'it must be a function, usually from the `prop-types` package, but received `' + typeof typeSpecs[typeSpecName] + '`.'
            );
            err.name = 'Invariant Violation';
            throw err;
          }
          error = typeSpecs[typeSpecName](values, typeSpecName, componentName, location, null, ReactPropTypesSecret);
        } catch (ex) {
          error = ex;
        }
        if (error && !(error instanceof Error)) {
          printWarning(
            (componentName || 'React class') + ': type specification of ' +
            location + ' `' + typeSpecName + '` is invalid; the type checker ' +
            'function must return `null` or an `Error` but returned a ' + typeof error + '. ' +
            'You may have forgotten to pass an argument to the type checker ' +
            'creator (arrayOf, instanceOf, objectOf, oneOf, oneOfType, and ' +
            'shape all require an argument).'
          );
        }
        if (error instanceof Error && !(error.message in loggedTypeFailures)) {
          // Only monitor this failure once because there tends to be a lot of the
          // same error.
          loggedTypeFailures[error.message] = true;

          var stack = getStack ? getStack() : '';

          printWarning(
            'Failed ' + location + ' type: ' + error.message + (stack != null ? stack : '')
          );
        }
      }
    }
  }
}

/**
 * Resets warning cache when testing.
 *
 * @private
 */
checkPropTypes.resetWarningCache = function() {
  if (true) {
    loggedTypeFailures = {};
  }
}

module.exports = checkPropTypes;


/***/ }),

/***/ "./node_modules/prop-types/lib/ReactPropTypesSecret.js":
/*!*************************************************************!*\
  !*** ./node_modules/prop-types/lib/ReactPropTypesSecret.js ***!
  \*************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * Copyright (c) 2013-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */



var ReactPropTypesSecret = 'SECRET_DO_NOT_PASS_THIS_OR_YOU_WILL_BE_FIRED';

module.exports = ReactPropTypesSecret;


/***/ }),

/***/ "./node_modules/react-dom/cjs/react-dom-server.browser.development.js":
/*!****************************************************************************!*\
  !*** ./node_modules/react-dom/cjs/react-dom-server.browser.development.js ***!
  \****************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/** @license React v16.8.1
 * react-dom-server.browser.development.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */





if (true) {
  (function() {
'use strict';

var _assign = __webpack_require__(/*! object-assign */ "./node_modules/object-assign/index.js");
var React = __webpack_require__(/*! react */ "./node_modules/react/index.js");
var checkPropTypes = __webpack_require__(/*! prop-types/checkPropTypes */ "./node_modules/prop-types/checkPropTypes.js");

/**
 * Use invariant() to assert state which your program assumes to be true.
 *
 * Provide sprintf-style format (only %s is supported) and arguments
 * to provide information about what broke and what you were
 * expecting.
 *
 * The invariant message will be stripped in production, but the invariant
 * will remain to ensure logic does not differ in production.
 */

var validateFormat = function () {};

{
  validateFormat = function (format) {
    if (format === undefined) {
      throw new Error('invariant requires an error message argument');
    }
  };
}

function invariant(condition, format, a, b, c, d, e, f) {
  validateFormat(format);

  if (!condition) {
    var error = void 0;
    if (format === undefined) {
      error = new Error('Minified exception occurred; use the non-minified dev environment ' + 'for the full error message and additional helpful warnings.');
    } else {
      var args = [a, b, c, d, e, f];
      var argIndex = 0;
      error = new Error(format.replace(/%s/g, function () {
        return args[argIndex++];
      }));
      error.name = 'Invariant Violation';
    }

    error.framesToPop = 1; // we don't care about invariant's own frame
    throw error;
  }
}

// Relying on the `invariant()` implementation lets us
// preserve the format and params in the www builds.

// TODO: this is special because it gets imported during build.

var ReactVersion = '16.8.1';

/**
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var warningWithoutStack = function () {};

{
  warningWithoutStack = function (condition, format) {
    for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      args[_key - 2] = arguments[_key];
    }

    if (format === undefined) {
      throw new Error('`warningWithoutStack(condition, format, ...args)` requires a warning ' + 'message argument');
    }
    if (args.length > 8) {
      // Check before the condition to catch violations early.
      throw new Error('warningWithoutStack() currently supports at most 8 arguments.');
    }
    if (condition) {
      return;
    }
    if (typeof console !== 'undefined') {
      var argsWithFormat = args.map(function (item) {
        return '' + item;
      });
      argsWithFormat.unshift('Warning: ' + format);

      // We intentionally don't use spread (or .apply) directly because it
      // breaks IE9: https://github.com/facebook/react/issues/13610
      Function.prototype.apply.call(console.error, console, argsWithFormat);
    }
    try {
      // --- Welcome to debugging React ---
      // This error was thrown as a convenience so that you can use this stack
      // to find the callsite that caused this warning to fire.
      var argIndex = 0;
      var message = 'Warning: ' + format.replace(/%s/g, function () {
        return args[argIndex++];
      });
      throw new Error(message);
    } catch (x) {}
  };
}

var warningWithoutStack$1 = warningWithoutStack;

// The Symbol used to tag the ReactElement-like types. If there is no native Symbol
// nor polyfill, then a plain number is used for performance.
var hasSymbol = typeof Symbol === 'function' && Symbol.for;


var REACT_PORTAL_TYPE = hasSymbol ? Symbol.for('react.portal') : 0xeaca;
var REACT_FRAGMENT_TYPE = hasSymbol ? Symbol.for('react.fragment') : 0xeacb;
var REACT_STRICT_MODE_TYPE = hasSymbol ? Symbol.for('react.strict_mode') : 0xeacc;
var REACT_PROFILER_TYPE = hasSymbol ? Symbol.for('react.profiler') : 0xead2;
var REACT_PROVIDER_TYPE = hasSymbol ? Symbol.for('react.provider') : 0xeacd;
var REACT_CONTEXT_TYPE = hasSymbol ? Symbol.for('react.context') : 0xeace;

var REACT_CONCURRENT_MODE_TYPE = hasSymbol ? Symbol.for('react.concurrent_mode') : 0xeacf;
var REACT_FORWARD_REF_TYPE = hasSymbol ? Symbol.for('react.forward_ref') : 0xead0;
var REACT_SUSPENSE_TYPE = hasSymbol ? Symbol.for('react.suspense') : 0xead1;
var REACT_MEMO_TYPE = hasSymbol ? Symbol.for('react.memo') : 0xead3;
var REACT_LAZY_TYPE = hasSymbol ? Symbol.for('react.lazy') : 0xead4;

var Resolved = 1;


function refineResolvedLazyComponent(lazyComponent) {
  return lazyComponent._status === Resolved ? lazyComponent._result : null;
}

function getWrappedName(outerType, innerType, wrapperName) {
  var functionName = innerType.displayName || innerType.name || '';
  return outerType.displayName || (functionName !== '' ? wrapperName + '(' + functionName + ')' : wrapperName);
}

function getComponentName(type) {
  if (type == null) {
    // Host root, text node or just invalid type.
    return null;
  }
  {
    if (typeof type.tag === 'number') {
      warningWithoutStack$1(false, 'Received an unexpected object in getComponentName(). ' + 'This is likely a bug in React. Please file an issue.');
    }
  }
  if (typeof type === 'function') {
    return type.displayName || type.name || null;
  }
  if (typeof type === 'string') {
    return type;
  }
  switch (type) {
    case REACT_CONCURRENT_MODE_TYPE:
      return 'ConcurrentMode';
    case REACT_FRAGMENT_TYPE:
      return 'Fragment';
    case REACT_PORTAL_TYPE:
      return 'Portal';
    case REACT_PROFILER_TYPE:
      return 'Profiler';
    case REACT_STRICT_MODE_TYPE:
      return 'StrictMode';
    case REACT_SUSPENSE_TYPE:
      return 'Suspense';
  }
  if (typeof type === 'object') {
    switch (type.$$typeof) {
      case REACT_CONTEXT_TYPE:
        return 'Context.Consumer';
      case REACT_PROVIDER_TYPE:
        return 'Context.Provider';
      case REACT_FORWARD_REF_TYPE:
        return getWrappedName(type, type.render, 'ForwardRef');
      case REACT_MEMO_TYPE:
        return getComponentName(type.type);
      case REACT_LAZY_TYPE:
        {
          var thenable = type;
          var resolvedThenable = refineResolvedLazyComponent(thenable);
          if (resolvedThenable) {
            return getComponentName(resolvedThenable);
          }
        }
    }
  }
  return null;
}

/**
 * Forked from fbjs/warning:
 * https://github.com/facebook/fbjs/blob/e66ba20ad5be433eb54423f2b097d829324d9de6/packages/fbjs/src/__forks__/warning.js
 *
 * Only change is we use console.warn instead of console.error,
 * and do nothing when 'console' is not supported.
 * This really simplifies the code.
 * ---
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var lowPriorityWarning = function () {};

{
  var printWarning = function (format) {
    for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      args[_key - 1] = arguments[_key];
    }

    var argIndex = 0;
    var message = 'Warning: ' + format.replace(/%s/g, function () {
      return args[argIndex++];
    });
    if (typeof console !== 'undefined') {
      console.warn(message);
    }
    try {
      // --- Welcome to debugging React ---
      // This error was thrown as a convenience so that you can use this stack
      // to find the callsite that caused this warning to fire.
      throw new Error(message);
    } catch (x) {}
  };

  lowPriorityWarning = function (condition, format) {
    if (format === undefined) {
      throw new Error('`lowPriorityWarning(condition, format, ...args)` requires a warning ' + 'message argument');
    }
    if (!condition) {
      for (var _len2 = arguments.length, args = Array(_len2 > 2 ? _len2 - 2 : 0), _key2 = 2; _key2 < _len2; _key2++) {
        args[_key2 - 2] = arguments[_key2];
      }

      printWarning.apply(undefined, [format].concat(args));
    }
  };
}

var lowPriorityWarning$1 = lowPriorityWarning;

var ReactSharedInternals = React.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED;

// Prevent newer renderers from RTE when used with older react package versions.
// Current owner and dispatcher used to share the same ref,
// but PR #14548 split them out to better support the react-debug-tools package.
if (!ReactSharedInternals.hasOwnProperty('ReactCurrentDispatcher')) {
  ReactSharedInternals.ReactCurrentDispatcher = {
    current: null
  };
}

/**
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var warning = warningWithoutStack$1;

{
  warning = function (condition, format) {
    if (condition) {
      return;
    }
    var ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame;
    var stack = ReactDebugCurrentFrame.getStackAddendum();
    // eslint-disable-next-line react-internal/warning-and-invariant-args

    for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      args[_key - 2] = arguments[_key];
    }

    warningWithoutStack$1.apply(undefined, [false, format + '%s'].concat(args, [stack]));
  };
}

var warning$1 = warning;

var BEFORE_SLASH_RE = /^(.*)[\\\/]/;

var describeComponentFrame = function (name, source, ownerName) {
  var sourceInfo = '';
  if (source) {
    var path = source.fileName;
    var fileName = path.replace(BEFORE_SLASH_RE, '');
    {
      // In DEV, include code for a common special case:
      // prefer "folder/index.js" instead of just "index.js".
      if (/^index\./.test(fileName)) {
        var match = path.match(BEFORE_SLASH_RE);
        if (match) {
          var pathBeforeSlash = match[1];
          if (pathBeforeSlash) {
            var folderName = pathBeforeSlash.replace(BEFORE_SLASH_RE, '');
            fileName = folderName + '/' + fileName;
          }
        }
      }
    }
    sourceInfo = ' (at ' + fileName + ':' + source.lineNumber + ')';
  } else if (ownerName) {
    sourceInfo = ' (created by ' + ownerName + ')';
  }
  return '\n    in ' + (name || 'Unknown') + sourceInfo;
};

// Helps identify side effects in begin-phase lifecycle hooks and setState reducers:


// In some cases, StrictMode should also double-render lifecycles.
// This can be confusing for tests though,
// And it can be bad for performance in production.
// This feature flag can be used to control the behavior:


// To preserve the "Pause on caught exceptions" behavior of the debugger, we
// replay the begin phase of a failed component inside invokeGuardedCallback.


// Warn about deprecated, async-unsafe lifecycles; relates to RFC #6:
var warnAboutDeprecatedLifecycles = false;

// Gather advanced timing metrics for Profiler subtrees.


// Trace which interactions trigger each commit.


// Only used in www builds.
var enableSuspenseServerRenderer = false; // TODO: true? Here it might just be false.

// Only used in www builds.


// Only used in www builds.


// React Fire: prevent the value and checked attributes from syncing
// with their related DOM properties


// These APIs will no longer be "unstable" in the upcoming 16.7 release,
// Control this behavior with a flag to support 16.6 minor releases in the meanwhile.

var ReactDebugCurrentFrame$1 = void 0;
{
  ReactDebugCurrentFrame$1 = ReactSharedInternals.ReactDebugCurrentFrame;
}

var didWarnAboutInvalidateContextType = {};

var emptyObject = {};
{
  Object.freeze(emptyObject);
}

function maskContext(type, context) {
  var contextTypes = type.contextTypes;
  if (!contextTypes) {
    return emptyObject;
  }
  var maskedContext = {};
  for (var contextName in contextTypes) {
    maskedContext[contextName] = context[contextName];
  }
  return maskedContext;
}

function checkContextTypes(typeSpecs, values, location) {
  {
    checkPropTypes(typeSpecs, values, location, 'Component', ReactDebugCurrentFrame$1.getCurrentStack);
  }
}

function validateContextBounds(context, threadID) {
  // If we don't have enough slots in this context to store this threadID,
  // fill it in without leaving any holes to ensure that the VM optimizes
  // this as non-holey index properties.
  // (Note: If `react` package is < 16.6, _threadCount is undefined.)
  for (var i = context._threadCount | 0; i <= threadID; i++) {
    // We assume that this is the same as the defaultValue which might not be
    // true if we're rendering inside a secondary renderer but they are
    // secondary because these use cases are very rare.
    context[i] = context._currentValue2;
    context._threadCount = i + 1;
  }
}

function processContext(type, context, threadID) {
  var contextType = type.contextType;
  if (typeof contextType === 'object' && contextType !== null) {
    {
      if (contextType.$$typeof !== REACT_CONTEXT_TYPE) {
        var name = getComponentName(type) || 'Component';
        if (!didWarnAboutInvalidateContextType[name]) {
          didWarnAboutInvalidateContextType[name] = true;
          warningWithoutStack$1(false, '%s defines an invalid contextType. ' + 'contextType should point to the Context object returned by React.createContext(). ' + 'Did you accidentally pass the Context.Provider instead?', name);
        }
      }
    }
    validateContextBounds(contextType, threadID);
    return contextType[threadID];
  } else {
    var maskedContext = maskContext(type, context);
    {
      if (type.contextTypes) {
        checkContextTypes(type.contextTypes, maskedContext, 'context');
      }
    }
    return maskedContext;
  }
}

// Allocates a new index for each request. Tries to stay as compact as possible so that these
// indices can be used to reference a tightly packaged array. As opposed to being used in a Map.
// The first allocated index is 1.

var nextAvailableThreadIDs = new Uint16Array(16);
for (var i = 0; i < 15; i++) {
  nextAvailableThreadIDs[i] = i + 1;
}
nextAvailableThreadIDs[15] = 0;

function growThreadCountAndReturnNextAvailable() {
  var oldArray = nextAvailableThreadIDs;
  var oldSize = oldArray.length;
  var newSize = oldSize * 2;
  !(newSize <= 0x10000) ? invariant(false, 'Maximum number of concurrent React renderers exceeded. This can happen if you are not properly destroying the Readable provided by React. Ensure that you call .destroy() on it if you no longer want to read from it, and did not read to the end. If you use .pipe() this should be automatic.') : void 0;
  var newArray = new Uint16Array(newSize);
  newArray.set(oldArray);
  nextAvailableThreadIDs = newArray;
  nextAvailableThreadIDs[0] = oldSize + 1;
  for (var _i = oldSize; _i < newSize - 1; _i++) {
    nextAvailableThreadIDs[_i] = _i + 1;
  }
  nextAvailableThreadIDs[newSize - 1] = 0;
  return oldSize;
}

function allocThreadID() {
  var nextID = nextAvailableThreadIDs[0];
  if (nextID === 0) {
    return growThreadCountAndReturnNextAvailable();
  }
  nextAvailableThreadIDs[0] = nextAvailableThreadIDs[nextID];
  return nextID;
}

function freeThreadID(id) {
  nextAvailableThreadIDs[id] = nextAvailableThreadIDs[0];
  nextAvailableThreadIDs[0] = id;
}

// A reserved attribute.
// It is handled by React separately and shouldn't be written to the DOM.
var RESERVED = 0;

// A simple string attribute.
// Attributes that aren't in the whitelist are presumed to have this type.
var STRING = 1;

// A string attribute that accepts booleans in React. In HTML, these are called
// "enumerated" attributes with "true" and "false" as possible values.
// When true, it should be set to a "true" string.
// When false, it should be set to a "false" string.
var BOOLEANISH_STRING = 2;

// A real boolean attribute.
// When true, it should be present (set either to an empty string or its name).
// When false, it should be omitted.
var BOOLEAN = 3;

// An attribute that can be used as a flag as well as with a value.
// When true, it should be present (set either to an empty string or its name).
// When false, it should be omitted.
// For any other value, should be present with that value.
var OVERLOADED_BOOLEAN = 4;

// An attribute that must be numeric or parse as a numeric.
// When falsy, it should be removed.
var NUMERIC = 5;

// An attribute that must be positive numeric or parse as a positive numeric.
// When falsy, it should be removed.
var POSITIVE_NUMERIC = 6;

/* eslint-disable max-len */
var ATTRIBUTE_NAME_START_CHAR = ':A-Z_a-z\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u02FF\\u0370-\\u037D\\u037F-\\u1FFF\\u200C-\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD';
/* eslint-enable max-len */
var ATTRIBUTE_NAME_CHAR = ATTRIBUTE_NAME_START_CHAR + '\\-.0-9\\u00B7\\u0300-\\u036F\\u203F-\\u2040';


var ROOT_ATTRIBUTE_NAME = 'data-reactroot';
var VALID_ATTRIBUTE_NAME_REGEX = new RegExp('^[' + ATTRIBUTE_NAME_START_CHAR + '][' + ATTRIBUTE_NAME_CHAR + ']*$');

var hasOwnProperty$1 = Object.prototype.hasOwnProperty;
var illegalAttributeNameCache = {};
var validatedAttributeNameCache = {};

function isAttributeNameSafe(attributeName) {
  if (hasOwnProperty$1.call(validatedAttributeNameCache, attributeName)) {
    return true;
  }
  if (hasOwnProperty$1.call(illegalAttributeNameCache, attributeName)) {
    return false;
  }
  if (VALID_ATTRIBUTE_NAME_REGEX.test(attributeName)) {
    validatedAttributeNameCache[attributeName] = true;
    return true;
  }
  illegalAttributeNameCache[attributeName] = true;
  {
    warning$1(false, 'Invalid attribute name: `%s`', attributeName);
  }
  return false;
}

function shouldIgnoreAttribute(name, propertyInfo, isCustomComponentTag) {
  if (propertyInfo !== null) {
    return propertyInfo.type === RESERVED;
  }
  if (isCustomComponentTag) {
    return false;
  }
  if (name.length > 2 && (name[0] === 'o' || name[0] === 'O') && (name[1] === 'n' || name[1] === 'N')) {
    return true;
  }
  return false;
}

function shouldRemoveAttributeWithWarning(name, value, propertyInfo, isCustomComponentTag) {
  if (propertyInfo !== null && propertyInfo.type === RESERVED) {
    return false;
  }
  switch (typeof value) {
    case 'function':
    // $FlowIssue symbol is perfectly valid here
    case 'symbol':
      // eslint-disable-line
      return true;
    case 'boolean':
      {
        if (isCustomComponentTag) {
          return false;
        }
        if (propertyInfo !== null) {
          return !propertyInfo.acceptsBooleans;
        } else {
          var prefix = name.toLowerCase().slice(0, 5);
          return prefix !== 'data-' && prefix !== 'aria-';
        }
      }
    default:
      return false;
  }
}

function shouldRemoveAttribute(name, value, propertyInfo, isCustomComponentTag) {
  if (value === null || typeof value === 'undefined') {
    return true;
  }
  if (shouldRemoveAttributeWithWarning(name, value, propertyInfo, isCustomComponentTag)) {
    return true;
  }
  if (isCustomComponentTag) {
    return false;
  }
  if (propertyInfo !== null) {
    switch (propertyInfo.type) {
      case BOOLEAN:
        return !value;
      case OVERLOADED_BOOLEAN:
        return value === false;
      case NUMERIC:
        return isNaN(value);
      case POSITIVE_NUMERIC:
        return isNaN(value) || value < 1;
    }
  }
  return false;
}

function getPropertyInfo(name) {
  return properties.hasOwnProperty(name) ? properties[name] : null;
}

function PropertyInfoRecord(name, type, mustUseProperty, attributeName, attributeNamespace) {
  this.acceptsBooleans = type === BOOLEANISH_STRING || type === BOOLEAN || type === OVERLOADED_BOOLEAN;
  this.attributeName = attributeName;
  this.attributeNamespace = attributeNamespace;
  this.mustUseProperty = mustUseProperty;
  this.propertyName = name;
  this.type = type;
}

// When adding attributes to this list, be sure to also add them to
// the `possibleStandardNames` module to ensure casing and incorrect
// name warnings.
var properties = {};

// These props are reserved by React. They shouldn't be written to the DOM.
['children', 'dangerouslySetInnerHTML',
// TODO: This prevents the assignment of defaultValue to regular
// elements (not just inputs). Now that ReactDOMInput assigns to the
// defaultValue property -- do we need this?
'defaultValue', 'defaultChecked', 'innerHTML', 'suppressContentEditableWarning', 'suppressHydrationWarning', 'style'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, RESERVED, false, // mustUseProperty
  name, // attributeName
  null);
} // attributeNamespace
);

// A few React string attributes have a different name.
// This is a mapping from React prop names to the attribute names.
[['acceptCharset', 'accept-charset'], ['className', 'class'], ['htmlFor', 'for'], ['httpEquiv', 'http-equiv']].forEach(function (_ref) {
  var name = _ref[0],
      attributeName = _ref[1];

  properties[name] = new PropertyInfoRecord(name, STRING, false, // mustUseProperty
  attributeName, // attributeName
  null);
} // attributeNamespace
);

// These are "enumerated" HTML attributes that accept "true" and "false".
// In React, we let users pass `true` and `false` even though technically
// these aren't boolean attributes (they are coerced to strings).
['contentEditable', 'draggable', 'spellCheck', 'value'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, BOOLEANISH_STRING, false, // mustUseProperty
  name.toLowerCase(), // attributeName
  null);
} // attributeNamespace
);

// These are "enumerated" SVG attributes that accept "true" and "false".
// In React, we let users pass `true` and `false` even though technically
// these aren't boolean attributes (they are coerced to strings).
// Since these are SVG attributes, their attribute names are case-sensitive.
['autoReverse', 'externalResourcesRequired', 'focusable', 'preserveAlpha'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, BOOLEANISH_STRING, false, // mustUseProperty
  name, // attributeName
  null);
} // attributeNamespace
);

// These are HTML boolean attributes.
['allowFullScreen', 'async',
// Note: there is a special case that prevents it from being written to the DOM
// on the client side because the browsers are inconsistent. Instead we call focus().
'autoFocus', 'autoPlay', 'controls', 'default', 'defer', 'disabled', 'formNoValidate', 'hidden', 'loop', 'noModule', 'noValidate', 'open', 'playsInline', 'readOnly', 'required', 'reversed', 'scoped', 'seamless',
// Microdata
'itemScope'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, BOOLEAN, false, // mustUseProperty
  name.toLowerCase(), // attributeName
  null);
} // attributeNamespace
);

// These are the few React props that we set as DOM properties
// rather than attributes. These are all booleans.
['checked',
// Note: `option.selected` is not updated if `select.multiple` is
// disabled with `removeAttribute`. We have special logic for handling this.
'multiple', 'muted', 'selected'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, BOOLEAN, true, // mustUseProperty
  name, // attributeName
  null);
} // attributeNamespace
);

// These are HTML attributes that are "overloaded booleans": they behave like
// booleans, but can also accept a string value.
['capture', 'download'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, OVERLOADED_BOOLEAN, false, // mustUseProperty
  name, // attributeName
  null);
} // attributeNamespace
);

// These are HTML attributes that must be positive numbers.
['cols', 'rows', 'size', 'span'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, POSITIVE_NUMERIC, false, // mustUseProperty
  name, // attributeName
  null);
} // attributeNamespace
);

// These are HTML attributes that must be numbers.
['rowSpan', 'start'].forEach(function (name) {
  properties[name] = new PropertyInfoRecord(name, NUMERIC, false, // mustUseProperty
  name.toLowerCase(), // attributeName
  null);
} // attributeNamespace
);

var CAMELIZE = /[\-\:]([a-z])/g;
var capitalize = function (token) {
  return token[1].toUpperCase();
};

// This is a list of all SVG attributes that need special casing, namespacing,
// or boolean value assignment. Regular attributes that just accept strings
// and have the same names are omitted, just like in the HTML whitelist.
// Some of these attributes can be hard to find. This list was created by
// scrapping the MDN documentation.
['accent-height', 'alignment-baseline', 'arabic-form', 'baseline-shift', 'cap-height', 'clip-path', 'clip-rule', 'color-interpolation', 'color-interpolation-filters', 'color-profile', 'color-rendering', 'dominant-baseline', 'enable-background', 'fill-opacity', 'fill-rule', 'flood-color', 'flood-opacity', 'font-family', 'font-size', 'font-size-adjust', 'font-stretch', 'font-style', 'font-variant', 'font-weight', 'glyph-name', 'glyph-orientation-horizontal', 'glyph-orientation-vertical', 'horiz-adv-x', 'horiz-origin-x', 'image-rendering', 'letter-spacing', 'lighting-color', 'marker-end', 'marker-mid', 'marker-start', 'overline-position', 'overline-thickness', 'paint-order', 'panose-1', 'pointer-events', 'rendering-intent', 'shape-rendering', 'stop-color', 'stop-opacity', 'strikethrough-position', 'strikethrough-thickness', 'stroke-dasharray', 'stroke-dashoffset', 'stroke-linecap', 'stroke-linejoin', 'stroke-miterlimit', 'stroke-opacity', 'stroke-width', 'text-anchor', 'text-decoration', 'text-rendering', 'underline-position', 'underline-thickness', 'unicode-bidi', 'unicode-range', 'units-per-em', 'v-alphabetic', 'v-hanging', 'v-ideographic', 'v-mathematical', 'vector-effect', 'vert-adv-y', 'vert-origin-x', 'vert-origin-y', 'word-spacing', 'writing-mode', 'xmlns:xlink', 'x-height'].forEach(function (attributeName) {
  var name = attributeName.replace(CAMELIZE, capitalize);
  properties[name] = new PropertyInfoRecord(name, STRING, false, // mustUseProperty
  attributeName, null);
} // attributeNamespace
);

// String SVG attributes with the xlink namespace.
['xlink:actuate', 'xlink:arcrole', 'xlink:href', 'xlink:role', 'xlink:show', 'xlink:title', 'xlink:type'].forEach(function (attributeName) {
  var name = attributeName.replace(CAMELIZE, capitalize);
  properties[name] = new PropertyInfoRecord(name, STRING, false, // mustUseProperty
  attributeName, 'http://www.w3.org/1999/xlink');
});

// String SVG attributes with the xml namespace.
['xml:base', 'xml:lang', 'xml:space'].forEach(function (attributeName) {
  var name = attributeName.replace(CAMELIZE, capitalize);
  properties[name] = new PropertyInfoRecord(name, STRING, false, // mustUseProperty
  attributeName, 'http://www.w3.org/XML/1998/namespace');
});

// Special case: this attribute exists both in HTML and SVG.
// Its "tabindex" attribute name is case-sensitive in SVG so we can't just use
// its React `tabIndex` name, like we do for attributes that exist only in HTML.
properties.tabIndex = new PropertyInfoRecord('tabIndex', STRING, false, // mustUseProperty
'tabindex', // attributeName
null);

// code copied and modified from escape-html
/**
 * Module variables.
 * @private
 */

var matchHtmlRegExp = /["'&<>]/;

/**
 * Escapes special characters and HTML entities in a given html string.
 *
 * @param  {string} string HTML string to escape for later insertion
 * @return {string}
 * @public
 */

function escapeHtml(string) {
  var str = '' + string;
  var match = matchHtmlRegExp.exec(str);

  if (!match) {
    return str;
  }

  var escape = void 0;
  var html = '';
  var index = void 0;
  var lastIndex = 0;

  for (index = match.index; index < str.length; index++) {
    switch (str.charCodeAt(index)) {
      case 34:
        // "
        escape = '&quot;';
        break;
      case 38:
        // &
        escape = '&amp;';
        break;
      case 39:
        // '
        escape = '&#x27;'; // modified from escape-html; used to be '&#39'
        break;
      case 60:
        // <
        escape = '&lt;';
        break;
      case 62:
        // >
        escape = '&gt;';
        break;
      default:
        continue;
    }

    if (lastIndex !== index) {
      html += str.substring(lastIndex, index);
    }

    lastIndex = index + 1;
    html += escape;
  }

  return lastIndex !== index ? html + str.substring(lastIndex, index) : html;
}
// end code copied and modified from escape-html

/**
 * Escapes text to prevent scripting attacks.
 *
 * @param {*} text Text value to escape.
 * @return {string} An escaped string.
 */
function escapeTextForBrowser(text) {
  if (typeof text === 'boolean' || typeof text === 'number') {
    // this shortcircuit helps perf for types that we know will never have
    // special characters, especially given that this function is used often
    // for numeric dom ids.
    return '' + text;
  }
  return escapeHtml(text);
}

/**
 * Escapes attribute value to prevent scripting attacks.
 *
 * @param {*} value Value to escape.
 * @return {string} An escaped string.
 */
function quoteAttributeValueForBrowser(value) {
  return '"' + escapeTextForBrowser(value) + '"';
}

/**
 * Operations for dealing with DOM properties.
 */

/**
 * Creates markup for the ID property.
 *
 * @param {string} id Unescaped ID.
 * @return {string} Markup string.
 */


function createMarkupForRoot() {
  return ROOT_ATTRIBUTE_NAME + '=""';
}

/**
 * Creates markup for a property.
 *
 * @param {string} name
 * @param {*} value
 * @return {?string} Markup string, or null if the property was invalid.
 */
function createMarkupForProperty(name, value) {
  var propertyInfo = getPropertyInfo(name);
  if (name !== 'style' && shouldIgnoreAttribute(name, propertyInfo, false)) {
    return '';
  }
  if (shouldRemoveAttribute(name, value, propertyInfo, false)) {
    return '';
  }
  if (propertyInfo !== null) {
    var attributeName = propertyInfo.attributeName;
    var type = propertyInfo.type;

    if (type === BOOLEAN || type === OVERLOADED_BOOLEAN && value === true) {
      return attributeName + '=""';
    } else {
      return attributeName + '=' + quoteAttributeValueForBrowser(value);
    }
  } else if (isAttributeNameSafe(name)) {
    return name + '=' + quoteAttributeValueForBrowser(value);
  }
  return '';
}

/**
 * Creates markup for a custom property.
 *
 * @param {string} name
 * @param {*} value
 * @return {string} Markup string, or empty string if the property was invalid.
 */
function createMarkupForCustomAttribute(name, value) {
  if (!isAttributeNameSafe(name) || value == null) {
    return '';
  }
  return name + '=' + quoteAttributeValueForBrowser(value);
}

/**
 * inlined Object.is polyfill to avoid requiring consumers ship their own
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
 */
function is(x, y) {
  return x === y && (x !== 0 || 1 / x === 1 / y) || x !== x && y !== y // eslint-disable-line no-self-compare
  ;
}

var currentlyRenderingComponent = null;
var firstWorkInProgressHook = null;
var workInProgressHook = null;
// Whether the work-in-progress hook is a re-rendered hook
var isReRender = false;
// Whether an update was scheduled during the currently executing render pass.
var didScheduleRenderPhaseUpdate = false;
// Lazily created map of render-phase updates
var renderPhaseUpdates = null;
// Counter to prevent infinite loops.
var numberOfReRenders = 0;
var RE_RENDER_LIMIT = 25;

var isInHookUserCodeInDev = false;

// In DEV, this is the name of the currently executing primitive hook
var currentHookNameInDev = void 0;

function resolveCurrentlyRenderingComponent() {
  !(currentlyRenderingComponent !== null) ? invariant(false, 'Hooks can only be called inside the body of a function component. (https://fb.me/react-invalid-hook-call)') : void 0;
  {
    !!isInHookUserCodeInDev ? warning$1(false, 'Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. ' + 'You can only call Hooks at the top level of your React function. ' + 'For more information, see ' + 'https://fb.me/rules-of-hooks') : void 0;
  }
  return currentlyRenderingComponent;
}

function areHookInputsEqual(nextDeps, prevDeps) {
  if (prevDeps === null) {
    {
      warning$1(false, '%s received a final argument during this render, but not during ' + 'the previous render. Even though the final argument is optional, ' + 'its type cannot change between renders.', currentHookNameInDev);
    }
    return false;
  }

  {
    // Don't bother comparing lengths in prod because these arrays should be
    // passed inline.
    if (nextDeps.length !== prevDeps.length) {
      warning$1(false, 'The final argument passed to %s changed size between renders. The ' + 'order and size of this array must remain constant.\n\n' + 'Previous: %s\n' + 'Incoming: %s', currentHookNameInDev, '[' + nextDeps.join(', ') + ']', '[' + prevDeps.join(', ') + ']');
    }
  }
  for (var i = 0; i < prevDeps.length && i < nextDeps.length; i++) {
    if (is(nextDeps[i], prevDeps[i])) {
      continue;
    }
    return false;
  }
  return true;
}

function createHook() {
  if (numberOfReRenders > 0) {
    invariant(false, 'Rendered more hooks than during the previous render');
  }
  return {
    memoizedState: null,
    queue: null,
    next: null
  };
}

function createWorkInProgressHook() {
  if (workInProgressHook === null) {
    // This is the first hook in the list
    if (firstWorkInProgressHook === null) {
      isReRender = false;
      firstWorkInProgressHook = workInProgressHook = createHook();
    } else {
      // There's already a work-in-progress. Reuse it.
      isReRender = true;
      workInProgressHook = firstWorkInProgressHook;
    }
  } else {
    if (workInProgressHook.next === null) {
      isReRender = false;
      // Append to the end of the list
      workInProgressHook = workInProgressHook.next = createHook();
    } else {
      // There's already a work-in-progress. Reuse it.
      isReRender = true;
      workInProgressHook = workInProgressHook.next;
    }
  }
  return workInProgressHook;
}

function prepareToUseHooks(componentIdentity) {
  currentlyRenderingComponent = componentIdentity;
  {
    isInHookUserCodeInDev = false;
  }

  // The following should have already been reset
  // didScheduleRenderPhaseUpdate = false;
  // firstWorkInProgressHook = null;
  // numberOfReRenders = 0;
  // renderPhaseUpdates = null;
  // workInProgressHook = null;
}

function finishHooks(Component, props, children, refOrContext) {
  // This must be called after every function component to prevent hooks from
  // being used in classes.

  while (didScheduleRenderPhaseUpdate) {
    // Updates were scheduled during the render phase. They are stored in
    // the `renderPhaseUpdates` map. Call the component again, reusing the
    // work-in-progress hooks and applying the additional updates on top. Keep
    // restarting until no more updates are scheduled.
    didScheduleRenderPhaseUpdate = false;
    numberOfReRenders += 1;

    // Start over from the beginning of the list
    workInProgressHook = null;

    children = Component(props, refOrContext);
  }
  currentlyRenderingComponent = null;
  firstWorkInProgressHook = null;
  numberOfReRenders = 0;
  renderPhaseUpdates = null;
  workInProgressHook = null;
  {
    isInHookUserCodeInDev = false;
  }

  // These were reset above
  // currentlyRenderingComponent = null;
  // didScheduleRenderPhaseUpdate = false;
  // firstWorkInProgressHook = null;
  // numberOfReRenders = 0;
  // renderPhaseUpdates = null;
  // workInProgressHook = null;

  return children;
}

function readContext(context, observedBits) {
  var threadID = currentThreadID;
  validateContextBounds(context, threadID);
  {
    !!isInHookUserCodeInDev ? warning$1(false, 'Context can only be read while React is rendering. ' + 'In classes, you can read it in the render method or getDerivedStateFromProps. ' + 'In function components, you can read it directly in the function body, but not ' + 'inside Hooks like useReducer() or useMemo().') : void 0;
  }
  return context[threadID];
}

function useContext(context, observedBits) {
  {
    currentHookNameInDev = 'useContext';
  }
  resolveCurrentlyRenderingComponent();
  var threadID = currentThreadID;
  validateContextBounds(context, threadID);
  return context[threadID];
}

function basicStateReducer(state, action) {
  return typeof action === 'function' ? action(state) : action;
}

function useState(initialState) {
  {
    currentHookNameInDev = 'useState';
  }
  return useReducer(basicStateReducer,
  // useReducer has a special case to support lazy useState initializers
  initialState);
}

function useReducer(reducer, initialArg, init) {
  {
    if (reducer !== basicStateReducer) {
      currentHookNameInDev = 'useReducer';
    }
  }
  currentlyRenderingComponent = resolveCurrentlyRenderingComponent();
  workInProgressHook = createWorkInProgressHook();
  if (isReRender) {
    // This is a re-render. Apply the new render phase updates to the previous
    var _queue = workInProgressHook.queue;
    var _dispatch = _queue.dispatch;
    if (renderPhaseUpdates !== null) {
      // Render phase updates are stored in a map of queue -> linked list
      var firstRenderPhaseUpdate = renderPhaseUpdates.get(_queue);
      if (firstRenderPhaseUpdate !== undefined) {
        renderPhaseUpdates.delete(_queue);
        var newState = workInProgressHook.memoizedState;
        var update = firstRenderPhaseUpdate;
        do {
          // Process this render phase update. We don't have to check the
          // priority because it will always be the same as the current
          // render's.
          var _action = update.action;
          {
            isInHookUserCodeInDev = true;
          }
          newState = reducer(newState, _action);
          {
            isInHookUserCodeInDev = false;
          }
          update = update.next;
        } while (update !== null);

        workInProgressHook.memoizedState = newState;

        return [newState, _dispatch];
      }
    }
    return [workInProgressHook.memoizedState, _dispatch];
  } else {
    {
      isInHookUserCodeInDev = true;
    }
    var initialState = void 0;
    if (reducer === basicStateReducer) {
      // Special case for `useState`.
      initialState = typeof initialArg === 'function' ? initialArg() : initialArg;
    } else {
      initialState = init !== undefined ? init(initialArg) : initialArg;
    }
    {
      isInHookUserCodeInDev = false;
    }
    workInProgressHook.memoizedState = initialState;
    var _queue2 = workInProgressHook.queue = {
      last: null,
      dispatch: null
    };
    var _dispatch2 = _queue2.dispatch = dispatchAction.bind(null, currentlyRenderingComponent, _queue2);
    return [workInProgressHook.memoizedState, _dispatch2];
  }
}

function useMemo(nextCreate, deps) {
  currentlyRenderingComponent = resolveCurrentlyRenderingComponent();
  workInProgressHook = createWorkInProgressHook();

  var nextDeps = deps === undefined ? null : deps;

  if (workInProgressHook !== null) {
    var prevState = workInProgressHook.memoizedState;
    if (prevState !== null) {
      if (nextDeps !== null) {
        var prevDeps = prevState[1];
        if (areHookInputsEqual(nextDeps, prevDeps)) {
          return prevState[0];
        }
      }
    }
  }

  {
    isInHookUserCodeInDev = true;
  }
  var nextValue = nextCreate();
  {
    isInHookUserCodeInDev = false;
  }
  workInProgressHook.memoizedState = [nextValue, nextDeps];
  return nextValue;
}

function useRef(initialValue) {
  currentlyRenderingComponent = resolveCurrentlyRenderingComponent();
  workInProgressHook = createWorkInProgressHook();
  var previousRef = workInProgressHook.memoizedState;
  if (previousRef === null) {
    var ref = { current: initialValue };
    {
      Object.seal(ref);
    }
    workInProgressHook.memoizedState = ref;
    return ref;
  } else {
    return previousRef;
  }
}

function useLayoutEffect(create, inputs) {
  {
    currentHookNameInDev = 'useLayoutEffect';
  }
  warning$1(false, 'useLayoutEffect does nothing on the server, because its effect cannot ' + "be encoded into the server renderer's output format. This will lead " + 'to a mismatch between the initial, non-hydrated UI and the intended ' + 'UI. To avoid this, useLayoutEffect should only be used in ' + 'components that render exclusively on the client.');
}

function dispatchAction(componentIdentity, queue, action) {
  !(numberOfReRenders < RE_RENDER_LIMIT) ? invariant(false, 'Too many re-renders. React limits the number of renders to prevent an infinite loop.') : void 0;

  if (componentIdentity === currentlyRenderingComponent) {
    // This is a render phase update. Stash it in a lazily-created map of
    // queue -> linked list of updates. After this render pass, we'll restart
    // and apply the stashed updates on top of the work-in-progress hook.
    didScheduleRenderPhaseUpdate = true;
    var update = {
      action: action,
      next: null
    };
    if (renderPhaseUpdates === null) {
      renderPhaseUpdates = new Map();
    }
    var firstRenderPhaseUpdate = renderPhaseUpdates.get(queue);
    if (firstRenderPhaseUpdate === undefined) {
      renderPhaseUpdates.set(queue, update);
    } else {
      // Append the update to the end of the list.
      var lastRenderPhaseUpdate = firstRenderPhaseUpdate;
      while (lastRenderPhaseUpdate.next !== null) {
        lastRenderPhaseUpdate = lastRenderPhaseUpdate.next;
      }
      lastRenderPhaseUpdate.next = update;
    }
  } else {
    // This means an update has happened after the function component has
    // returned. On the server this is a no-op. In React Fiber, the update
    // would be scheduled for a future render.
  }
}

function useCallback(callback, deps) {
  // Callbacks are passed as they are in the server environment.
  return callback;
}

function noop() {}

var currentThreadID = 0;

function setCurrentThreadID(threadID) {
  currentThreadID = threadID;
}

var Dispatcher = {
  readContext: readContext,
  useContext: useContext,
  useMemo: useMemo,
  useReducer: useReducer,
  useRef: useRef,
  useState: useState,
  useLayoutEffect: useLayoutEffect,
  useCallback: useCallback,
  // useImperativeHandle is not run in the server environment
  useImperativeHandle: noop,
  // Effects are not run in the server environment.
  useEffect: noop,
  // Debugging effect
  useDebugValue: noop
};

var HTML_NAMESPACE = 'http://www.w3.org/1999/xhtml';
var MATH_NAMESPACE = 'http://www.w3.org/1998/Math/MathML';
var SVG_NAMESPACE = 'http://www.w3.org/2000/svg';

var Namespaces = {
  html: HTML_NAMESPACE,
  mathml: MATH_NAMESPACE,
  svg: SVG_NAMESPACE
};

// Assumes there is no parent namespace.
function getIntrinsicNamespace(type) {
  switch (type) {
    case 'svg':
      return SVG_NAMESPACE;
    case 'math':
      return MATH_NAMESPACE;
    default:
      return HTML_NAMESPACE;
  }
}

function getChildNamespace(parentNamespace, type) {
  if (parentNamespace == null || parentNamespace === HTML_NAMESPACE) {
    // No (or default) parent namespace: potential entry point.
    return getIntrinsicNamespace(type);
  }
  if (parentNamespace === SVG_NAMESPACE && type === 'foreignObject') {
    // We're leaving SVG.
    return HTML_NAMESPACE;
  }
  // By default, pass namespace below.
  return parentNamespace;
}

var ReactDebugCurrentFrame$2 = null;

var ReactControlledValuePropTypes = {
  checkPropTypes: null
};

{
  ReactDebugCurrentFrame$2 = ReactSharedInternals.ReactDebugCurrentFrame;

  var hasReadOnlyValue = {
    button: true,
    checkbox: true,
    image: true,
    hidden: true,
    radio: true,
    reset: true,
    submit: true
  };

  var propTypes = {
    value: function (props, propName, componentName) {
      if (hasReadOnlyValue[props.type] || props.onChange || props.readOnly || props.disabled || props[propName] == null) {
        return null;
      }
      return new Error('You provided a `value` prop to a form field without an ' + '`onChange` handler. This will render a read-only field. If ' + 'the field should be mutable use `defaultValue`. Otherwise, ' + 'set either `onChange` or `readOnly`.');
    },
    checked: function (props, propName, componentName) {
      if (props.onChange || props.readOnly || props.disabled || props[propName] == null) {
        return null;
      }
      return new Error('You provided a `checked` prop to a form field without an ' + '`onChange` handler. This will render a read-only field. If ' + 'the field should be mutable use `defaultChecked`. Otherwise, ' + 'set either `onChange` or `readOnly`.');
    }
  };

  /**
   * Provide a linked `value` attribute for controlled forms. You should not use
   * this outside of the ReactDOM controlled form components.
   */
  ReactControlledValuePropTypes.checkPropTypes = function (tagName, props) {
    checkPropTypes(propTypes, props, 'prop', tagName, ReactDebugCurrentFrame$2.getStackAddendum);
  };
}

// For HTML, certain tags should omit their close tag. We keep a whitelist for
// those special-case tags.

var omittedCloseTags = {
  area: true,
  base: true,
  br: true,
  col: true,
  embed: true,
  hr: true,
  img: true,
  input: true,
  keygen: true,
  link: true,
  meta: true,
  param: true,
  source: true,
  track: true,
  wbr: true
  // NOTE: menuitem's close tag should be omitted, but that causes problems.
};

// For HTML, certain tags cannot have children. This has the same purpose as
// `omittedCloseTags` except that `menuitem` should still have its closing tag.

var voidElementTags = _assign({
  menuitem: true
}, omittedCloseTags);

// TODO: We can remove this if we add invariantWithStack()
// or add stack by default to invariants where possible.
var HTML = '__html';

var ReactDebugCurrentFrame$3 = null;
{
  ReactDebugCurrentFrame$3 = ReactSharedInternals.ReactDebugCurrentFrame;
}

function assertValidProps(tag, props) {
  if (!props) {
    return;
  }
  // Note the use of `==` which checks for null or undefined.
  if (voidElementTags[tag]) {
    !(props.children == null && props.dangerouslySetInnerHTML == null) ? invariant(false, '%s is a void element tag and must neither have `children` nor use `dangerouslySetInnerHTML`.%s', tag, ReactDebugCurrentFrame$3.getStackAddendum()) : void 0;
  }
  if (props.dangerouslySetInnerHTML != null) {
    !(props.children == null) ? invariant(false, 'Can only set one of `children` or `props.dangerouslySetInnerHTML`.') : void 0;
    !(typeof props.dangerouslySetInnerHTML === 'object' && HTML in props.dangerouslySetInnerHTML) ? invariant(false, '`props.dangerouslySetInnerHTML` must be in the form `{__html: ...}`. Please visit https://fb.me/react-invariant-dangerously-set-inner-html for more information.') : void 0;
  }
  {
    !(props.suppressContentEditableWarning || !props.contentEditable || props.children == null) ? warning$1(false, 'A component is `contentEditable` and contains `children` managed by ' + 'React. It is now your responsibility to guarantee that none of ' + 'those nodes are unexpectedly modified or duplicated. This is ' + 'probably not intentional.') : void 0;
  }
  !(props.style == null || typeof props.style === 'object') ? invariant(false, 'The `style` prop expects a mapping from style properties to values, not a string. For example, style={{marginRight: spacing + \'em\'}} when using JSX.%s', ReactDebugCurrentFrame$3.getStackAddendum()) : void 0;
}

/**
 * CSS properties which accept numbers but are not in units of "px".
 */
var isUnitlessNumber = {
  animationIterationCount: true,
  borderImageOutset: true,
  borderImageSlice: true,
  borderImageWidth: true,
  boxFlex: true,
  boxFlexGroup: true,
  boxOrdinalGroup: true,
  columnCount: true,
  columns: true,
  flex: true,
  flexGrow: true,
  flexPositive: true,
  flexShrink: true,
  flexNegative: true,
  flexOrder: true,
  gridArea: true,
  gridRow: true,
  gridRowEnd: true,
  gridRowSpan: true,
  gridRowStart: true,
  gridColumn: true,
  gridColumnEnd: true,
  gridColumnSpan: true,
  gridColumnStart: true,
  fontWeight: true,
  lineClamp: true,
  lineHeight: true,
  opacity: true,
  order: true,
  orphans: true,
  tabSize: true,
  widows: true,
  zIndex: true,
  zoom: true,

  // SVG-related properties
  fillOpacity: true,
  floodOpacity: true,
  stopOpacity: true,
  strokeDasharray: true,
  strokeDashoffset: true,
  strokeMiterlimit: true,
  strokeOpacity: true,
  strokeWidth: true
};

/**
 * @param {string} prefix vendor-specific prefix, eg: Webkit
 * @param {string} key style name, eg: transitionDuration
 * @return {string} style name prefixed with `prefix`, properly camelCased, eg:
 * WebkitTransitionDuration
 */
function prefixKey(prefix, key) {
  return prefix + key.charAt(0).toUpperCase() + key.substring(1);
}

/**
 * Support style names that may come passed in prefixed by adding permutations
 * of vendor prefixes.
 */
var prefixes = ['Webkit', 'ms', 'Moz', 'O'];

// Using Object.keys here, or else the vanilla for-in loop makes IE8 go into an
// infinite loop, because it iterates over the newly added props too.
Object.keys(isUnitlessNumber).forEach(function (prop) {
  prefixes.forEach(function (prefix) {
    isUnitlessNumber[prefixKey(prefix, prop)] = isUnitlessNumber[prop];
  });
});

/**
 * Convert a value into the proper css writable value. The style name `name`
 * should be logical (no hyphens), as specified
 * in `CSSProperty.isUnitlessNumber`.
 *
 * @param {string} name CSS property name such as `topMargin`.
 * @param {*} value CSS property value such as `10px`.
 * @return {string} Normalized style value with dimensions applied.
 */
function dangerousStyleValue(name, value, isCustomProperty) {
  // Note that we've removed escapeTextForBrowser() calls here since the
  // whole string will be escaped when the attribute is injected into
  // the markup. If you provide unsafe user data here they can inject
  // arbitrary CSS which may be problematic (I couldn't repro this):
  // https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet
  // http://www.thespanner.co.uk/2007/11/26/ultimate-xss-css-injection/
  // This is not an XSS hole but instead a potential CSS injection issue
  // which has lead to a greater discussion about how we're going to
  // trust URLs moving forward. See #2115901

  var isEmpty = value == null || typeof value === 'boolean' || value === '';
  if (isEmpty) {
    return '';
  }

  if (!isCustomProperty && typeof value === 'number' && value !== 0 && !(isUnitlessNumber.hasOwnProperty(name) && isUnitlessNumber[name])) {
    return value + 'px'; // Presumes implicit 'px' suffix for unitless numbers
  }

  return ('' + value).trim();
}

var uppercasePattern = /([A-Z])/g;
var msPattern = /^ms-/;

/**
 * Hyphenates a camelcased CSS property name, for example:
 *
 *   > hyphenateStyleName('backgroundColor')
 *   < "background-color"
 *   > hyphenateStyleName('MozTransition')
 *   < "-moz-transition"
 *   > hyphenateStyleName('msTransition')
 *   < "-ms-transition"
 *
 * As Modernizr suggests (http://modernizr.com/docs/#prefixed), an `ms` prefix
 * is converted to `-ms-`.
 */
function hyphenateStyleName(name) {
  return name.replace(uppercasePattern, '-$1').toLowerCase().replace(msPattern, '-ms-');
}

function isCustomComponent(tagName, props) {
  if (tagName.indexOf('-') === -1) {
    return typeof props.is === 'string';
  }
  switch (tagName) {
    // These are reserved SVG and MathML elements.
    // We don't mind this whitelist too much because we expect it to never grow.
    // The alternative is to track the namespace in a few places which is convoluted.
    // https://w3c.github.io/webcomponents/spec/custom/#custom-elements-core-concepts
    case 'annotation-xml':
    case 'color-profile':
    case 'font-face':
    case 'font-face-src':
    case 'font-face-uri':
    case 'font-face-format':
    case 'font-face-name':
    case 'missing-glyph':
      return false;
    default:
      return true;
  }
}

var warnValidStyle = function () {};

{
  // 'msTransform' is correct, but the other prefixes should be capitalized
  var badVendoredStyleNamePattern = /^(?:webkit|moz|o)[A-Z]/;
  var msPattern$1 = /^-ms-/;
  var hyphenPattern = /-(.)/g;

  // style values shouldn't contain a semicolon
  var badStyleValueWithSemicolonPattern = /;\s*$/;

  var warnedStyleNames = {};
  var warnedStyleValues = {};
  var warnedForNaNValue = false;
  var warnedForInfinityValue = false;

  var camelize = function (string) {
    return string.replace(hyphenPattern, function (_, character) {
      return character.toUpperCase();
    });
  };

  var warnHyphenatedStyleName = function (name) {
    if (warnedStyleNames.hasOwnProperty(name) && warnedStyleNames[name]) {
      return;
    }

    warnedStyleNames[name] = true;
    warning$1(false, 'Unsupported style property %s. Did you mean %s?', name,
    // As Andi Smith suggests
    // (http://www.andismith.com/blog/2012/02/modernizr-prefixed/), an `-ms` prefix
    // is converted to lowercase `ms`.
    camelize(name.replace(msPattern$1, 'ms-')));
  };

  var warnBadVendoredStyleName = function (name) {
    if (warnedStyleNames.hasOwnProperty(name) && warnedStyleNames[name]) {
      return;
    }

    warnedStyleNames[name] = true;
    warning$1(false, 'Unsupported vendor-prefixed style property %s. Did you mean %s?', name, name.charAt(0).toUpperCase() + name.slice(1));
  };

  var warnStyleValueWithSemicolon = function (name, value) {
    if (warnedStyleValues.hasOwnProperty(value) && warnedStyleValues[value]) {
      return;
    }

    warnedStyleValues[value] = true;
    warning$1(false, "Style property values shouldn't contain a semicolon. " + 'Try "%s: %s" instead.', name, value.replace(badStyleValueWithSemicolonPattern, ''));
  };

  var warnStyleValueIsNaN = function (name, value) {
    if (warnedForNaNValue) {
      return;
    }

    warnedForNaNValue = true;
    warning$1(false, '`NaN` is an invalid value for the `%s` css style property.', name);
  };

  var warnStyleValueIsInfinity = function (name, value) {
    if (warnedForInfinityValue) {
      return;
    }

    warnedForInfinityValue = true;
    warning$1(false, '`Infinity` is an invalid value for the `%s` css style property.', name);
  };

  warnValidStyle = function (name, value) {
    if (name.indexOf('-') > -1) {
      warnHyphenatedStyleName(name);
    } else if (badVendoredStyleNamePattern.test(name)) {
      warnBadVendoredStyleName(name);
    } else if (badStyleValueWithSemicolonPattern.test(value)) {
      warnStyleValueWithSemicolon(name, value);
    }

    if (typeof value === 'number') {
      if (isNaN(value)) {
        warnStyleValueIsNaN(name, value);
      } else if (!isFinite(value)) {
        warnStyleValueIsInfinity(name, value);
      }
    }
  };
}

var warnValidStyle$1 = warnValidStyle;

var ariaProperties = {
  'aria-current': 0, // state
  'aria-details': 0,
  'aria-disabled': 0, // state
  'aria-hidden': 0, // state
  'aria-invalid': 0, // state
  'aria-keyshortcuts': 0,
  'aria-label': 0,
  'aria-roledescription': 0,
  // Widget Attributes
  'aria-autocomplete': 0,
  'aria-checked': 0,
  'aria-expanded': 0,
  'aria-haspopup': 0,
  'aria-level': 0,
  'aria-modal': 0,
  'aria-multiline': 0,
  'aria-multiselectable': 0,
  'aria-orientation': 0,
  'aria-placeholder': 0,
  'aria-pressed': 0,
  'aria-readonly': 0,
  'aria-required': 0,
  'aria-selected': 0,
  'aria-sort': 0,
  'aria-valuemax': 0,
  'aria-valuemin': 0,
  'aria-valuenow': 0,
  'aria-valuetext': 0,
  // Live Region Attributes
  'aria-atomic': 0,
  'aria-busy': 0,
  'aria-live': 0,
  'aria-relevant': 0,
  // Drag-and-Drop Attributes
  'aria-dropeffect': 0,
  'aria-grabbed': 0,
  // Relationship Attributes
  'aria-activedescendant': 0,
  'aria-colcount': 0,
  'aria-colindex': 0,
  'aria-colspan': 0,
  'aria-controls': 0,
  'aria-describedby': 0,
  'aria-errormessage': 0,
  'aria-flowto': 0,
  'aria-labelledby': 0,
  'aria-owns': 0,
  'aria-posinset': 0,
  'aria-rowcount': 0,
  'aria-rowindex': 0,
  'aria-rowspan': 0,
  'aria-setsize': 0
};

var warnedProperties = {};
var rARIA = new RegExp('^(aria)-[' + ATTRIBUTE_NAME_CHAR + ']*$');
var rARIACamel = new RegExp('^(aria)[A-Z][' + ATTRIBUTE_NAME_CHAR + ']*$');

var hasOwnProperty$2 = Object.prototype.hasOwnProperty;

function validateProperty(tagName, name) {
  if (hasOwnProperty$2.call(warnedProperties, name) && warnedProperties[name]) {
    return true;
  }

  if (rARIACamel.test(name)) {
    var ariaName = 'aria-' + name.slice(4).toLowerCase();
    var correctName = ariaProperties.hasOwnProperty(ariaName) ? ariaName : null;

    // If this is an aria-* attribute, but is not listed in the known DOM
    // DOM properties, then it is an invalid aria-* attribute.
    if (correctName == null) {
      warning$1(false, 'Invalid ARIA attribute `%s`. ARIA attributes follow the pattern aria-* and must be lowercase.', name);
      warnedProperties[name] = true;
      return true;
    }
    // aria-* attributes should be lowercase; suggest the lowercase version.
    if (name !== correctName) {
      warning$1(false, 'Invalid ARIA attribute `%s`. Did you mean `%s`?', name, correctName);
      warnedProperties[name] = true;
      return true;
    }
  }

  if (rARIA.test(name)) {
    var lowerCasedName = name.toLowerCase();
    var standardName = ariaProperties.hasOwnProperty(lowerCasedName) ? lowerCasedName : null;

    // If this is an aria-* attribute, but is not listed in the known DOM
    // DOM properties, then it is an invalid aria-* attribute.
    if (standardName == null) {
      warnedProperties[name] = true;
      return false;
    }
    // aria-* attributes should be lowercase; suggest the lowercase version.
    if (name !== standardName) {
      warning$1(false, 'Unknown ARIA attribute `%s`. Did you mean `%s`?', name, standardName);
      warnedProperties[name] = true;
      return true;
    }
  }

  return true;
}

function warnInvalidARIAProps(type, props) {
  var invalidProps = [];

  for (var key in props) {
    var isValid = validateProperty(type, key);
    if (!isValid) {
      invalidProps.push(key);
    }
  }

  var unknownPropString = invalidProps.map(function (prop) {
    return '`' + prop + '`';
  }).join(', ');

  if (invalidProps.length === 1) {
    warning$1(false, 'Invalid aria prop %s on <%s> tag. ' + 'For details, see https://fb.me/invalid-aria-prop', unknownPropString, type);
  } else if (invalidProps.length > 1) {
    warning$1(false, 'Invalid aria props %s on <%s> tag. ' + 'For details, see https://fb.me/invalid-aria-prop', unknownPropString, type);
  }
}

function validateProperties(type, props) {
  if (isCustomComponent(type, props)) {
    return;
  }
  warnInvalidARIAProps(type, props);
}

var didWarnValueNull = false;

function validateProperties$1(type, props) {
  if (type !== 'input' && type !== 'textarea' && type !== 'select') {
    return;
  }

  if (props != null && props.value === null && !didWarnValueNull) {
    didWarnValueNull = true;
    if (type === 'select' && props.multiple) {
      warning$1(false, '`value` prop on `%s` should not be null. ' + 'Consider using an empty array when `multiple` is set to `true` ' + 'to clear the component or `undefined` for uncontrolled components.', type);
    } else {
      warning$1(false, '`value` prop on `%s` should not be null. ' + 'Consider using an empty string to clear the component or `undefined` ' + 'for uncontrolled components.', type);
    }
  }
}

/**
 * Registers plugins so that they can extract and dispatch events.
 *
 * @see {EventPluginHub}
 */

/**
 * Ordered list of injected plugins.
 */


/**
 * Mapping from event name to dispatch config
 */


/**
 * Mapping from registration name to plugin module
 */
var registrationNameModules = {};

/**
 * Mapping from registration name to event name
 */


/**
 * Mapping from lowercase registration names to the properly cased version,
 * used to warn in the case of missing event handlers. Available
 * only in true.
 * @type {Object}
 */
var possibleRegistrationNames = {};
// Trust the developer to only use possibleRegistrationNames in true

/**
 * Injects an ordering of plugins (by plugin name). This allows the ordering
 * to be decoupled from injection of the actual plugins so that ordering is
 * always deterministic regardless of packaging, on-the-fly injection, etc.
 *
 * @param {array} InjectedEventPluginOrder
 * @internal
 * @see {EventPluginHub.injection.injectEventPluginOrder}
 */


/**
 * Injects plugins to be used by `EventPluginHub`. The plugin names must be
 * in the ordering injected by `injectEventPluginOrder`.
 *
 * Plugins can be injected as part of page initialization or on-the-fly.
 *
 * @param {object} injectedNamesToPlugins Map from names to plugin modules.
 * @internal
 * @see {EventPluginHub.injection.injectEventPluginsByName}
 */

// When adding attributes to the HTML or SVG whitelist, be sure to
// also add them to this module to ensure casing and incorrect name
// warnings.
var possibleStandardNames = {
  // HTML
  accept: 'accept',
  acceptcharset: 'acceptCharset',
  'accept-charset': 'acceptCharset',
  accesskey: 'accessKey',
  action: 'action',
  allowfullscreen: 'allowFullScreen',
  alt: 'alt',
  as: 'as',
  async: 'async',
  autocapitalize: 'autoCapitalize',
  autocomplete: 'autoComplete',
  autocorrect: 'autoCorrect',
  autofocus: 'autoFocus',
  autoplay: 'autoPlay',
  autosave: 'autoSave',
  capture: 'capture',
  cellpadding: 'cellPadding',
  cellspacing: 'cellSpacing',
  challenge: 'challenge',
  charset: 'charSet',
  checked: 'checked',
  children: 'children',
  cite: 'cite',
  class: 'className',
  classid: 'classID',
  classname: 'className',
  cols: 'cols',
  colspan: 'colSpan',
  content: 'content',
  contenteditable: 'contentEditable',
  contextmenu: 'contextMenu',
  controls: 'controls',
  controlslist: 'controlsList',
  coords: 'coords',
  crossorigin: 'crossOrigin',
  dangerouslysetinnerhtml: 'dangerouslySetInnerHTML',
  data: 'data',
  datetime: 'dateTime',
  default: 'default',
  defaultchecked: 'defaultChecked',
  defaultvalue: 'defaultValue',
  defer: 'defer',
  dir: 'dir',
  disabled: 'disabled',
  download: 'download',
  draggable: 'draggable',
  enctype: 'encType',
  for: 'htmlFor',
  form: 'form',
  formmethod: 'formMethod',
  formaction: 'formAction',
  formenctype: 'formEncType',
  formnovalidate: 'formNoValidate',
  formtarget: 'formTarget',
  frameborder: 'frameBorder',
  headers: 'headers',
  height: 'height',
  hidden: 'hidden',
  high: 'high',
  href: 'href',
  hreflang: 'hrefLang',
  htmlfor: 'htmlFor',
  httpequiv: 'httpEquiv',
  'http-equiv': 'httpEquiv',
  icon: 'icon',
  id: 'id',
  innerhtml: 'innerHTML',
  inputmode: 'inputMode',
  integrity: 'integrity',
  is: 'is',
  itemid: 'itemID',
  itemprop: 'itemProp',
  itemref: 'itemRef',
  itemscope: 'itemScope',
  itemtype: 'itemType',
  keyparams: 'keyParams',
  keytype: 'keyType',
  kind: 'kind',
  label: 'label',
  lang: 'lang',
  list: 'list',
  loop: 'loop',
  low: 'low',
  manifest: 'manifest',
  marginwidth: 'marginWidth',
  marginheight: 'marginHeight',
  max: 'max',
  maxlength: 'maxLength',
  media: 'media',
  mediagroup: 'mediaGroup',
  method: 'method',
  min: 'min',
  minlength: 'minLength',
  multiple: 'multiple',
  muted: 'muted',
  name: 'name',
  nomodule: 'noModule',
  nonce: 'nonce',
  novalidate: 'noValidate',
  open: 'open',
  optimum: 'optimum',
  pattern: 'pattern',
  placeholder: 'placeholder',
  playsinline: 'playsInline',
  poster: 'poster',
  preload: 'preload',
  profile: 'profile',
  radiogroup: 'radioGroup',
  readonly: 'readOnly',
  referrerpolicy: 'referrerPolicy',
  rel: 'rel',
  required: 'required',
  reversed: 'reversed',
  role: 'role',
  rows: 'rows',
  rowspan: 'rowSpan',
  sandbox: 'sandbox',
  scope: 'scope',
  scoped: 'scoped',
  scrolling: 'scrolling',
  seamless: 'seamless',
  selected: 'selected',
  shape: 'shape',
  size: 'size',
  sizes: 'sizes',
  span: 'span',
  spellcheck: 'spellCheck',
  src: 'src',
  srcdoc: 'srcDoc',
  srclang: 'srcLang',
  srcset: 'srcSet',
  start: 'start',
  step: 'step',
  style: 'style',
  summary: 'summary',
  tabindex: 'tabIndex',
  target: 'target',
  title: 'title',
  type: 'type',
  usemap: 'useMap',
  value: 'value',
  width: 'width',
  wmode: 'wmode',
  wrap: 'wrap',

  // SVG
  about: 'about',
  accentheight: 'accentHeight',
  'accent-height': 'accentHeight',
  accumulate: 'accumulate',
  additive: 'additive',
  alignmentbaseline: 'alignmentBaseline',
  'alignment-baseline': 'alignmentBaseline',
  allowreorder: 'allowReorder',
  alphabetic: 'alphabetic',
  amplitude: 'amplitude',
  arabicform: 'arabicForm',
  'arabic-form': 'arabicForm',
  ascent: 'ascent',
  attributename: 'attributeName',
  attributetype: 'attributeType',
  autoreverse: 'autoReverse',
  azimuth: 'azimuth',
  basefrequency: 'baseFrequency',
  baselineshift: 'baselineShift',
  'baseline-shift': 'baselineShift',
  baseprofile: 'baseProfile',
  bbox: 'bbox',
  begin: 'begin',
  bias: 'bias',
  by: 'by',
  calcmode: 'calcMode',
  capheight: 'capHeight',
  'cap-height': 'capHeight',
  clip: 'clip',
  clippath: 'clipPath',
  'clip-path': 'clipPath',
  clippathunits: 'clipPathUnits',
  cliprule: 'clipRule',
  'clip-rule': 'clipRule',
  color: 'color',
  colorinterpolation: 'colorInterpolation',
  'color-interpolation': 'colorInterpolation',
  colorinterpolationfilters: 'colorInterpolationFilters',
  'color-interpolation-filters': 'colorInterpolationFilters',
  colorprofile: 'colorProfile',
  'color-profile': 'colorProfile',
  colorrendering: 'colorRendering',
  'color-rendering': 'colorRendering',
  contentscripttype: 'contentScriptType',
  contentstyletype: 'contentStyleType',
  cursor: 'cursor',
  cx: 'cx',
  cy: 'cy',
  d: 'd',
  datatype: 'datatype',
  decelerate: 'decelerate',
  descent: 'descent',
  diffuseconstant: 'diffuseConstant',
  direction: 'direction',
  display: 'display',
  divisor: 'divisor',
  dominantbaseline: 'dominantBaseline',
  'dominant-baseline': 'dominantBaseline',
  dur: 'dur',
  dx: 'dx',
  dy: 'dy',
  edgemode: 'edgeMode',
  elevation: 'elevation',
  enablebackground: 'enableBackground',
  'enable-background': 'enableBackground',
  end: 'end',
  exponent: 'exponent',
  externalresourcesrequired: 'externalResourcesRequired',
  fill: 'fill',
  fillopacity: 'fillOpacity',
  'fill-opacity': 'fillOpacity',
  fillrule: 'fillRule',
  'fill-rule': 'fillRule',
  filter: 'filter',
  filterres: 'filterRes',
  filterunits: 'filterUnits',
  floodopacity: 'floodOpacity',
  'flood-opacity': 'floodOpacity',
  floodcolor: 'floodColor',
  'flood-color': 'floodColor',
  focusable: 'focusable',
  fontfamily: 'fontFamily',
  'font-family': 'fontFamily',
  fontsize: 'fontSize',
  'font-size': 'fontSize',
  fontsizeadjust: 'fontSizeAdjust',
  'font-size-adjust': 'fontSizeAdjust',
  fontstretch: 'fontStretch',
  'font-stretch': 'fontStretch',
  fontstyle: 'fontStyle',
  'font-style': 'fontStyle',
  fontvariant: 'fontVariant',
  'font-variant': 'fontVariant',
  fontweight: 'fontWeight',
  'font-weight': 'fontWeight',
  format: 'format',
  from: 'from',
  fx: 'fx',
  fy: 'fy',
  g1: 'g1',
  g2: 'g2',
  glyphname: 'glyphName',
  'glyph-name': 'glyphName',
  glyphorientationhorizontal: 'glyphOrientationHorizontal',
  'glyph-orientation-horizontal': 'glyphOrientationHorizontal',
  glyphorientationvertical: 'glyphOrientationVertical',
  'glyph-orientation-vertical': 'glyphOrientationVertical',
  glyphref: 'glyphRef',
  gradienttransform: 'gradientTransform',
  gradientunits: 'gradientUnits',
  hanging: 'hanging',
  horizadvx: 'horizAdvX',
  'horiz-adv-x': 'horizAdvX',
  horizoriginx: 'horizOriginX',
  'horiz-origin-x': 'horizOriginX',
  ideographic: 'ideographic',
  imagerendering: 'imageRendering',
  'image-rendering': 'imageRendering',
  in2: 'in2',
  in: 'in',
  inlist: 'inlist',
  intercept: 'intercept',
  k1: 'k1',
  k2: 'k2',
  k3: 'k3',
  k4: 'k4',
  k: 'k',
  kernelmatrix: 'kernelMatrix',
  kernelunitlength: 'kernelUnitLength',
  kerning: 'kerning',
  keypoints: 'keyPoints',
  keysplines: 'keySplines',
  keytimes: 'keyTimes',
  lengthadjust: 'lengthAdjust',
  letterspacing: 'letterSpacing',
  'letter-spacing': 'letterSpacing',
  lightingcolor: 'lightingColor',
  'lighting-color': 'lightingColor',
  limitingconeangle: 'limitingConeAngle',
  local: 'local',
  markerend: 'markerEnd',
  'marker-end': 'markerEnd',
  markerheight: 'markerHeight',
  markermid: 'markerMid',
  'marker-mid': 'markerMid',
  markerstart: 'markerStart',
  'marker-start': 'markerStart',
  markerunits: 'markerUnits',
  markerwidth: 'markerWidth',
  mask: 'mask',
  maskcontentunits: 'maskContentUnits',
  maskunits: 'maskUnits',
  mathematical: 'mathematical',
  mode: 'mode',
  numoctaves: 'numOctaves',
  offset: 'offset',
  opacity: 'opacity',
  operator: 'operator',
  order: 'order',
  orient: 'orient',
  orientation: 'orientation',
  origin: 'origin',
  overflow: 'overflow',
  overlineposition: 'overlinePosition',
  'overline-position': 'overlinePosition',
  overlinethickness: 'overlineThickness',
  'overline-thickness': 'overlineThickness',
  paintorder: 'paintOrder',
  'paint-order': 'paintOrder',
  panose1: 'panose1',
  'panose-1': 'panose1',
  pathlength: 'pathLength',
  patterncontentunits: 'patternContentUnits',
  patterntransform: 'patternTransform',
  patternunits: 'patternUnits',
  pointerevents: 'pointerEvents',
  'pointer-events': 'pointerEvents',
  points: 'points',
  pointsatx: 'pointsAtX',
  pointsaty: 'pointsAtY',
  pointsatz: 'pointsAtZ',
  prefix: 'prefix',
  preservealpha: 'preserveAlpha',
  preserveaspectratio: 'preserveAspectRatio',
  primitiveunits: 'primitiveUnits',
  property: 'property',
  r: 'r',
  radius: 'radius',
  refx: 'refX',
  refy: 'refY',
  renderingintent: 'renderingIntent',
  'rendering-intent': 'renderingIntent',
  repeatcount: 'repeatCount',
  repeatdur: 'repeatDur',
  requiredextensions: 'requiredExtensions',
  requiredfeatures: 'requiredFeatures',
  resource: 'resource',
  restart: 'restart',
  result: 'result',
  results: 'results',
  rotate: 'rotate',
  rx: 'rx',
  ry: 'ry',
  scale: 'scale',
  security: 'security',
  seed: 'seed',
  shaperendering: 'shapeRendering',
  'shape-rendering': 'shapeRendering',
  slope: 'slope',
  spacing: 'spacing',
  specularconstant: 'specularConstant',
  specularexponent: 'specularExponent',
  speed: 'speed',
  spreadmethod: 'spreadMethod',
  startoffset: 'startOffset',
  stddeviation: 'stdDeviation',
  stemh: 'stemh',
  stemv: 'stemv',
  stitchtiles: 'stitchTiles',
  stopcolor: 'stopColor',
  'stop-color': 'stopColor',
  stopopacity: 'stopOpacity',
  'stop-opacity': 'stopOpacity',
  strikethroughposition: 'strikethroughPosition',
  'strikethrough-position': 'strikethroughPosition',
  strikethroughthickness: 'strikethroughThickness',
  'strikethrough-thickness': 'strikethroughThickness',
  string: 'string',
  stroke: 'stroke',
  strokedasharray: 'strokeDasharray',
  'stroke-dasharray': 'strokeDasharray',
  strokedashoffset: 'strokeDashoffset',
  'stroke-dashoffset': 'strokeDashoffset',
  strokelinecap: 'strokeLinecap',
  'stroke-linecap': 'strokeLinecap',
  strokelinejoin: 'strokeLinejoin',
  'stroke-linejoin': 'strokeLinejoin',
  strokemiterlimit: 'strokeMiterlimit',
  'stroke-miterlimit': 'strokeMiterlimit',
  strokewidth: 'strokeWidth',
  'stroke-width': 'strokeWidth',
  strokeopacity: 'strokeOpacity',
  'stroke-opacity': 'strokeOpacity',
  suppresscontenteditablewarning: 'suppressContentEditableWarning',
  suppresshydrationwarning: 'suppressHydrationWarning',
  surfacescale: 'surfaceScale',
  systemlanguage: 'systemLanguage',
  tablevalues: 'tableValues',
  targetx: 'targetX',
  targety: 'targetY',
  textanchor: 'textAnchor',
  'text-anchor': 'textAnchor',
  textdecoration: 'textDecoration',
  'text-decoration': 'textDecoration',
  textlength: 'textLength',
  textrendering: 'textRendering',
  'text-rendering': 'textRendering',
  to: 'to',
  transform: 'transform',
  typeof: 'typeof',
  u1: 'u1',
  u2: 'u2',
  underlineposition: 'underlinePosition',
  'underline-position': 'underlinePosition',
  underlinethickness: 'underlineThickness',
  'underline-thickness': 'underlineThickness',
  unicode: 'unicode',
  unicodebidi: 'unicodeBidi',
  'unicode-bidi': 'unicodeBidi',
  unicoderange: 'unicodeRange',
  'unicode-range': 'unicodeRange',
  unitsperem: 'unitsPerEm',
  'units-per-em': 'unitsPerEm',
  unselectable: 'unselectable',
  valphabetic: 'vAlphabetic',
  'v-alphabetic': 'vAlphabetic',
  values: 'values',
  vectoreffect: 'vectorEffect',
  'vector-effect': 'vectorEffect',
  version: 'version',
  vertadvy: 'vertAdvY',
  'vert-adv-y': 'vertAdvY',
  vertoriginx: 'vertOriginX',
  'vert-origin-x': 'vertOriginX',
  vertoriginy: 'vertOriginY',
  'vert-origin-y': 'vertOriginY',
  vhanging: 'vHanging',
  'v-hanging': 'vHanging',
  videographic: 'vIdeographic',
  'v-ideographic': 'vIdeographic',
  viewbox: 'viewBox',
  viewtarget: 'viewTarget',
  visibility: 'visibility',
  vmathematical: 'vMathematical',
  'v-mathematical': 'vMathematical',
  vocab: 'vocab',
  widths: 'widths',
  wordspacing: 'wordSpacing',
  'word-spacing': 'wordSpacing',
  writingmode: 'writingMode',
  'writing-mode': 'writingMode',
  x1: 'x1',
  x2: 'x2',
  x: 'x',
  xchannelselector: 'xChannelSelector',
  xheight: 'xHeight',
  'x-height': 'xHeight',
  xlinkactuate: 'xlinkActuate',
  'xlink:actuate': 'xlinkActuate',
  xlinkarcrole: 'xlinkArcrole',
  'xlink:arcrole': 'xlinkArcrole',
  xlinkhref: 'xlinkHref',
  'xlink:href': 'xlinkHref',
  xlinkrole: 'xlinkRole',
  'xlink:role': 'xlinkRole',
  xlinkshow: 'xlinkShow',
  'xlink:show': 'xlinkShow',
  xlinktitle: 'xlinkTitle',
  'xlink:title': 'xlinkTitle',
  xlinktype: 'xlinkType',
  'xlink:type': 'xlinkType',
  xmlbase: 'xmlBase',
  'xml:base': 'xmlBase',
  xmllang: 'xmlLang',
  'xml:lang': 'xmlLang',
  xmlns: 'xmlns',
  'xml:space': 'xmlSpace',
  xmlnsxlink: 'xmlnsXlink',
  'xmlns:xlink': 'xmlnsXlink',
  xmlspace: 'xmlSpace',
  y1: 'y1',
  y2: 'y2',
  y: 'y',
  ychannelselector: 'yChannelSelector',
  z: 'z',
  zoomandpan: 'zoomAndPan'
};

var validateProperty$1 = function () {};

{
  var warnedProperties$1 = {};
  var _hasOwnProperty = Object.prototype.hasOwnProperty;
  var EVENT_NAME_REGEX = /^on./;
  var INVALID_EVENT_NAME_REGEX = /^on[^A-Z]/;
  var rARIA$1 = new RegExp('^(aria)-[' + ATTRIBUTE_NAME_CHAR + ']*$');
  var rARIACamel$1 = new RegExp('^(aria)[A-Z][' + ATTRIBUTE_NAME_CHAR + ']*$');

  validateProperty$1 = function (tagName, name, value, canUseEventSystem) {
    if (_hasOwnProperty.call(warnedProperties$1, name) && warnedProperties$1[name]) {
      return true;
    }

    var lowerCasedName = name.toLowerCase();
    if (lowerCasedName === 'onfocusin' || lowerCasedName === 'onfocusout') {
      warning$1(false, 'React uses onFocus and onBlur instead of onFocusIn and onFocusOut. ' + 'All React events are normalized to bubble, so onFocusIn and onFocusOut ' + 'are not needed/supported by React.');
      warnedProperties$1[name] = true;
      return true;
    }

    // We can't rely on the event system being injected on the server.
    if (canUseEventSystem) {
      if (registrationNameModules.hasOwnProperty(name)) {
        return true;
      }
      var registrationName = possibleRegistrationNames.hasOwnProperty(lowerCasedName) ? possibleRegistrationNames[lowerCasedName] : null;
      if (registrationName != null) {
        warning$1(false, 'Invalid event handler property `%s`. Did you mean `%s`?', name, registrationName);
        warnedProperties$1[name] = true;
        return true;
      }
      if (EVENT_NAME_REGEX.test(name)) {
        warning$1(false, 'Unknown event handler property `%s`. It will be ignored.', name);
        warnedProperties$1[name] = true;
        return true;
      }
    } else if (EVENT_NAME_REGEX.test(name)) {
      // If no event plugins have been injected, we are in a server environment.
      // So we can't tell if the event name is correct for sure, but we can filter
      // out known bad ones like `onclick`. We can't suggest a specific replacement though.
      if (INVALID_EVENT_NAME_REGEX.test(name)) {
        warning$1(false, 'Invalid event handler property `%s`. ' + 'React events use the camelCase naming convention, for example `onClick`.', name);
      }
      warnedProperties$1[name] = true;
      return true;
    }

    // Let the ARIA attribute hook validate ARIA attributes
    if (rARIA$1.test(name) || rARIACamel$1.test(name)) {
      return true;
    }

    if (lowerCasedName === 'innerhtml') {
      warning$1(false, 'Directly setting property `innerHTML` is not permitted. ' + 'For more information, lookup documentation on `dangerouslySetInnerHTML`.');
      warnedProperties$1[name] = true;
      return true;
    }

    if (lowerCasedName === 'aria') {
      warning$1(false, 'The `aria` attribute is reserved for future use in React. ' + 'Pass individual `aria-` attributes instead.');
      warnedProperties$1[name] = true;
      return true;
    }

    if (lowerCasedName === 'is' && value !== null && value !== undefined && typeof value !== 'string') {
      warning$1(false, 'Received a `%s` for a string attribute `is`. If this is expected, cast ' + 'the value to a string.', typeof value);
      warnedProperties$1[name] = true;
      return true;
    }

    if (typeof value === 'number' && isNaN(value)) {
      warning$1(false, 'Received NaN for the `%s` attribute. If this is expected, cast ' + 'the value to a string.', name);
      warnedProperties$1[name] = true;
      return true;
    }

    var propertyInfo = getPropertyInfo(name);
    var isReserved = propertyInfo !== null && propertyInfo.type === RESERVED;

    // Known attributes should match the casing specified in the property config.
    if (possibleStandardNames.hasOwnProperty(lowerCasedName)) {
      var standardName = possibleStandardNames[lowerCasedName];
      if (standardName !== name) {
        warning$1(false, 'Invalid DOM property `%s`. Did you mean `%s`?', name, standardName);
        warnedProperties$1[name] = true;
        return true;
      }
    } else if (!isReserved && name !== lowerCasedName) {
      // Unknown attributes should have lowercase casing since that's how they
      // will be cased anyway with server rendering.
      warning$1(false, 'React does not recognize the `%s` prop on a DOM element. If you ' + 'intentionally want it to appear in the DOM as a custom ' + 'attribute, spell it as lowercase `%s` instead. ' + 'If you accidentally passed it from a parent component, remove ' + 'it from the DOM element.', name, lowerCasedName);
      warnedProperties$1[name] = true;
      return true;
    }

    if (typeof value === 'boolean' && shouldRemoveAttributeWithWarning(name, value, propertyInfo, false)) {
      if (value) {
        warning$1(false, 'Received `%s` for a non-boolean attribute `%s`.\n\n' + 'If you want to write it to the DOM, pass a string instead: ' + '%s="%s" or %s={value.toString()}.', value, name, name, value, name);
      } else {
        warning$1(false, 'Received `%s` for a non-boolean attribute `%s`.\n\n' + 'If you want to write it to the DOM, pass a string instead: ' + '%s="%s" or %s={value.toString()}.\n\n' + 'If you used to conditionally omit it with %s={condition && value}, ' + 'pass %s={condition ? value : undefined} instead.', value, name, name, value, name, name, name);
      }
      warnedProperties$1[name] = true;
      return true;
    }

    // Now that we've validated casing, do not validate
    // data types for reserved props
    if (isReserved) {
      return true;
    }

    // Warn when a known attribute is a bad type
    if (shouldRemoveAttributeWithWarning(name, value, propertyInfo, false)) {
      warnedProperties$1[name] = true;
      return false;
    }

    // Warn when passing the strings 'false' or 'true' into a boolean prop
    if ((value === 'false' || value === 'true') && propertyInfo !== null && propertyInfo.type === BOOLEAN) {
      warning$1(false, 'Received the string `%s` for the boolean attribute `%s`. ' + '%s ' + 'Did you mean %s={%s}?', value, name, value === 'false' ? 'The browser will interpret it as a truthy value.' : 'Although this works, it will not work as expected if you pass the string "false".', name, value);
      warnedProperties$1[name] = true;
      return true;
    }

    return true;
  };
}

var warnUnknownProperties = function (type, props, canUseEventSystem) {
  var unknownProps = [];
  for (var key in props) {
    var isValid = validateProperty$1(type, key, props[key], canUseEventSystem);
    if (!isValid) {
      unknownProps.push(key);
    }
  }

  var unknownPropString = unknownProps.map(function (prop) {
    return '`' + prop + '`';
  }).join(', ');
  if (unknownProps.length === 1) {
    warning$1(false, 'Invalid value for prop %s on <%s> tag. Either remove it from the element, ' + 'or pass a string or number value to keep it in the DOM. ' + 'For details, see https://fb.me/react-attribute-behavior', unknownPropString, type);
  } else if (unknownProps.length > 1) {
    warning$1(false, 'Invalid values for props %s on <%s> tag. Either remove them from the element, ' + 'or pass a string or number value to keep them in the DOM. ' + 'For details, see https://fb.me/react-attribute-behavior', unknownPropString, type);
  }
};

function validateProperties$2(type, props, canUseEventSystem) {
  if (isCustomComponent(type, props)) {
    return;
  }
  warnUnknownProperties(type, props, canUseEventSystem);
}

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

// Based on reading the React.Children implementation. TODO: type this somewhere?

var toArray = React.Children.toArray;

// This is only used in DEV.
// Each entry is `this.stack` from a currently executing renderer instance.
// (There may be more than one because ReactDOMServer is reentrant).
// Each stack is an array of frames which may contain nested stacks of elements.
var currentDebugStacks = [];

var ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher;
var ReactDebugCurrentFrame = void 0;
var prevGetCurrentStackImpl = null;
var getCurrentServerStackImpl = function () {
  return '';
};
var describeStackFrame = function (element) {
  return '';
};

var validatePropertiesInDevelopment = function (type, props) {};
var pushCurrentDebugStack = function (stack) {};
var pushElementToDebugStack = function (element) {};
var popCurrentDebugStack = function () {};
var hasWarnedAboutUsingContextAsConsumer = false;

{
  ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame;

  validatePropertiesInDevelopment = function (type, props) {
    validateProperties(type, props);
    validateProperties$1(type, props);
    validateProperties$2(type, props, /* canUseEventSystem */false);
  };

  describeStackFrame = function (element) {
    var source = element._source;
    var type = element.type;
    var name = getComponentName(type);
    var ownerName = null;
    return describeComponentFrame(name, source, ownerName);
  };

  pushCurrentDebugStack = function (stack) {
    currentDebugStacks.push(stack);

    if (currentDebugStacks.length === 1) {
      // We are entering a server renderer.
      // Remember the previous (e.g. client) global stack implementation.
      prevGetCurrentStackImpl = ReactDebugCurrentFrame.getCurrentStack;
      ReactDebugCurrentFrame.getCurrentStack = getCurrentServerStackImpl;
    }
  };

  pushElementToDebugStack = function (element) {
    // For the innermost executing ReactDOMServer call,
    var stack = currentDebugStacks[currentDebugStacks.length - 1];
    // Take the innermost executing frame (e.g. <Foo>),
    var frame = stack[stack.length - 1];
    // and record that it has one more element associated with it.
    frame.debugElementStack.push(element);
    // We only need this because we tail-optimize single-element
    // children and directly handle them in an inner loop instead of
    // creating separate frames for them.
  };

  popCurrentDebugStack = function () {
    currentDebugStacks.pop();

    if (currentDebugStacks.length === 0) {
      // We are exiting the server renderer.
      // Restore the previous (e.g. client) global stack implementation.
      ReactDebugCurrentFrame.getCurrentStack = prevGetCurrentStackImpl;
      prevGetCurrentStackImpl = null;
    }
  };

  getCurrentServerStackImpl = function () {
    if (currentDebugStacks.length === 0) {
      // Nothing is currently rendering.
      return '';
    }
    // ReactDOMServer is reentrant so there may be multiple calls at the same time.
    // Take the frames from the innermost call which is the last in the array.
    var frames = currentDebugStacks[currentDebugStacks.length - 1];
    var stack = '';
    // Go through every frame in the stack from the innermost one.
    for (var i = frames.length - 1; i >= 0; i--) {
      var frame = frames[i];
      // Every frame might have more than one debug element stack entry associated with it.
      // This is because single-child nesting doesn't create materialized frames.
      // Instead it would push them through `pushElementToDebugStack()`.
      var _debugElementStack = frame.debugElementStack;
      for (var ii = _debugElementStack.length - 1; ii >= 0; ii--) {
        stack += describeStackFrame(_debugElementStack[ii]);
      }
    }
    return stack;
  };
}

var didWarnDefaultInputValue = false;
var didWarnDefaultChecked = false;
var didWarnDefaultSelectValue = false;
var didWarnDefaultTextareaValue = false;
var didWarnInvalidOptionChildren = false;
var didWarnAboutNoopUpdateForComponent = {};
var didWarnAboutBadClass = {};
var didWarnAboutDeprecatedWillMount = {};
var didWarnAboutUndefinedDerivedState = {};
var didWarnAboutUninitializedState = {};
var valuePropNames = ['value', 'defaultValue'];
var newlineEatingTags = {
  listing: true,
  pre: true,
  textarea: true
};

// We accept any tag to be rendered but since this gets injected into arbitrary
// HTML, we want to make sure that it's a safe tag.
// http://www.w3.org/TR/REC-xml/#NT-Name
var VALID_TAG_REGEX = /^[a-zA-Z][a-zA-Z:_\.\-\d]*$/; // Simplified subset
var validatedTagCache = {};
function validateDangerousTag(tag) {
  if (!validatedTagCache.hasOwnProperty(tag)) {
    !VALID_TAG_REGEX.test(tag) ? invariant(false, 'Invalid tag: %s', tag) : void 0;
    validatedTagCache[tag] = true;
  }
}

var styleNameCache = {};
var processStyleName = function (styleName) {
  if (styleNameCache.hasOwnProperty(styleName)) {
    return styleNameCache[styleName];
  }
  var result = hyphenateStyleName(styleName);
  styleNameCache[styleName] = result;
  return result;
};

function createMarkupForStyles(styles) {
  var serialized = '';
  var delimiter = '';
  for (var styleName in styles) {
    if (!styles.hasOwnProperty(styleName)) {
      continue;
    }
    var isCustomProperty = styleName.indexOf('--') === 0;
    var styleValue = styles[styleName];
    {
      if (!isCustomProperty) {
        warnValidStyle$1(styleName, styleValue);
      }
    }
    if (styleValue != null) {
      serialized += delimiter + processStyleName(styleName) + ':';
      serialized += dangerousStyleValue(styleName, styleValue, isCustomProperty);

      delimiter = ';';
    }
  }
  return serialized || null;
}

function warnNoop(publicInstance, callerName) {
  {
    var _constructor = publicInstance.constructor;
    var componentName = _constructor && getComponentName(_constructor) || 'ReactClass';
    var warningKey = componentName + '.' + callerName;
    if (didWarnAboutNoopUpdateForComponent[warningKey]) {
      return;
    }

    warningWithoutStack$1(false, '%s(...): Can only update a mounting component. ' + 'This usually means you called %s() outside componentWillMount() on the server. ' + 'This is a no-op.\n\nPlease check the code for the %s component.', callerName, callerName, componentName);
    didWarnAboutNoopUpdateForComponent[warningKey] = true;
  }
}

function shouldConstruct(Component) {
  return Component.prototype && Component.prototype.isReactComponent;
}

function getNonChildrenInnerMarkup(props) {
  var innerHTML = props.dangerouslySetInnerHTML;
  if (innerHTML != null) {
    if (innerHTML.__html != null) {
      return innerHTML.__html;
    }
  } else {
    var content = props.children;
    if (typeof content === 'string' || typeof content === 'number') {
      return escapeTextForBrowser(content);
    }
  }
  return null;
}

function flattenTopLevelChildren(children) {
  if (!React.isValidElement(children)) {
    return toArray(children);
  }
  var element = children;
  if (element.type !== REACT_FRAGMENT_TYPE) {
    return [element];
  }
  var fragmentChildren = element.props.children;
  if (!React.isValidElement(fragmentChildren)) {
    return toArray(fragmentChildren);
  }
  var fragmentChildElement = fragmentChildren;
  return [fragmentChildElement];
}

function flattenOptionChildren(children) {
  if (children === undefined || children === null) {
    return children;
  }
  var content = '';
  // Flatten children and warn if they aren't strings or numbers;
  // invalid types are ignored.
  React.Children.forEach(children, function (child) {
    if (child == null) {
      return;
    }
    content += child;
    {
      if (!didWarnInvalidOptionChildren && typeof child !== 'string' && typeof child !== 'number') {
        didWarnInvalidOptionChildren = true;
        warning$1(false, 'Only strings and numbers are supported as <option> children.');
      }
    }
  });
  return content;
}

var hasOwnProperty = Object.prototype.hasOwnProperty;
var STYLE = 'style';
var RESERVED_PROPS = {
  children: null,
  dangerouslySetInnerHTML: null,
  suppressContentEditableWarning: null,
  suppressHydrationWarning: null
};

function createOpenTagMarkup(tagVerbatim, tagLowercase, props, namespace, makeStaticMarkup, isRootElement) {
  var ret = '<' + tagVerbatim;

  for (var propKey in props) {
    if (!hasOwnProperty.call(props, propKey)) {
      continue;
    }
    var propValue = props[propKey];
    if (propValue == null) {
      continue;
    }
    if (propKey === STYLE) {
      propValue = createMarkupForStyles(propValue);
    }
    var markup = null;
    if (isCustomComponent(tagLowercase, props)) {
      if (!RESERVED_PROPS.hasOwnProperty(propKey)) {
        markup = createMarkupForCustomAttribute(propKey, propValue);
      }
    } else {
      markup = createMarkupForProperty(propKey, propValue);
    }
    if (markup) {
      ret += ' ' + markup;
    }
  }

  // For static pages, no need to put React ID and checksum. Saves lots of
  // bytes.
  if (makeStaticMarkup) {
    return ret;
  }

  if (isRootElement) {
    ret += ' ' + createMarkupForRoot();
  }
  return ret;
}

function validateRenderResult(child, type) {
  if (child === undefined) {
    invariant(false, '%s(...): Nothing was returned from render. This usually means a return statement is missing. Or, to render nothing, return null.', getComponentName(type) || 'Component');
  }
}

function resolve(child, context, threadID) {
  while (React.isValidElement(child)) {
    // Safe because we just checked it's an element.
    var element = child;
    var Component = element.type;
    {
      pushElementToDebugStack(element);
    }
    if (typeof Component !== 'function') {
      break;
    }
    processChild(element, Component);
  }

  // Extra closure so queue and replace can be captured properly
  function processChild(element, Component) {
    var publicContext = processContext(Component, context, threadID);

    var queue = [];
    var replace = false;
    var updater = {
      isMounted: function (publicInstance) {
        return false;
      },
      enqueueForceUpdate: function (publicInstance) {
        if (queue === null) {
          warnNoop(publicInstance, 'forceUpdate');
          return null;
        }
      },
      enqueueReplaceState: function (publicInstance, completeState) {
        replace = true;
        queue = [completeState];
      },
      enqueueSetState: function (publicInstance, currentPartialState) {
        if (queue === null) {
          warnNoop(publicInstance, 'setState');
          return null;
        }
        queue.push(currentPartialState);
      }
    };

    var inst = void 0;
    if (shouldConstruct(Component)) {
      inst = new Component(element.props, publicContext, updater);

      if (typeof Component.getDerivedStateFromProps === 'function') {
        {
          if (inst.state === null || inst.state === undefined) {
            var componentName = getComponentName(Component) || 'Unknown';
            if (!didWarnAboutUninitializedState[componentName]) {
              warningWithoutStack$1(false, '`%s` uses `getDerivedStateFromProps` but its initial state is ' + '%s. This is not recommended. Instead, define the initial state by ' + 'assigning an object to `this.state` in the constructor of `%s`. ' + 'This ensures that `getDerivedStateFromProps` arguments have a consistent shape.', componentName, inst.state === null ? 'null' : 'undefined', componentName);
              didWarnAboutUninitializedState[componentName] = true;
            }
          }
        }

        var partialState = Component.getDerivedStateFromProps.call(null, element.props, inst.state);

        {
          if (partialState === undefined) {
            var _componentName = getComponentName(Component) || 'Unknown';
            if (!didWarnAboutUndefinedDerivedState[_componentName]) {
              warningWithoutStack$1(false, '%s.getDerivedStateFromProps(): A valid state object (or null) must be returned. ' + 'You have returned undefined.', _componentName);
              didWarnAboutUndefinedDerivedState[_componentName] = true;
            }
          }
        }

        if (partialState != null) {
          inst.state = _assign({}, inst.state, partialState);
        }
      }
    } else {
      {
        if (Component.prototype && typeof Component.prototype.render === 'function') {
          var _componentName2 = getComponentName(Component) || 'Unknown';

          if (!didWarnAboutBadClass[_componentName2]) {
            warningWithoutStack$1(false, "The <%s /> component appears to have a render method, but doesn't extend React.Component. " + 'This is likely to cause errors. Change %s to extend React.Component instead.', _componentName2, _componentName2);
            didWarnAboutBadClass[_componentName2] = true;
          }
        }
      }
      var componentIdentity = {};
      prepareToUseHooks(componentIdentity);
      inst = Component(element.props, publicContext, updater);
      inst = finishHooks(Component, element.props, inst, publicContext);

      if (inst == null || inst.render == null) {
        child = inst;
        validateRenderResult(child, Component);
        return;
      }
    }

    inst.props = element.props;
    inst.context = publicContext;
    inst.updater = updater;

    var initialState = inst.state;
    if (initialState === undefined) {
      inst.state = initialState = null;
    }
    if (typeof inst.UNSAFE_componentWillMount === 'function' || typeof inst.componentWillMount === 'function') {
      if (typeof inst.componentWillMount === 'function') {
        {
          if (warnAboutDeprecatedLifecycles && inst.componentWillMount.__suppressDeprecationWarning !== true) {
            var _componentName3 = getComponentName(Component) || 'Unknown';

            if (!didWarnAboutDeprecatedWillMount[_componentName3]) {
              lowPriorityWarning$1(false, '%s: componentWillMount() is deprecated and will be ' + 'removed in the next major version. Read about the motivations ' + 'behind this change: ' + 'https://fb.me/react-async-component-lifecycle-hooks' + '\n\n' + 'As a temporary workaround, you can rename to ' + 'UNSAFE_componentWillMount instead.', _componentName3);
              didWarnAboutDeprecatedWillMount[_componentName3] = true;
            }
          }
        }

        // In order to support react-lifecycles-compat polyfilled components,
        // Unsafe lifecycles should not be invoked for any component with the new gDSFP.
        if (typeof Component.getDerivedStateFromProps !== 'function') {
          inst.componentWillMount();
        }
      }
      if (typeof inst.UNSAFE_componentWillMount === 'function' && typeof Component.getDerivedStateFromProps !== 'function') {
        // In order to support react-lifecycles-compat polyfilled components,
        // Unsafe lifecycles should not be invoked for any component with the new gDSFP.
        inst.UNSAFE_componentWillMount();
      }
      if (queue.length) {
        var oldQueue = queue;
        var oldReplace = replace;
        queue = null;
        replace = false;

        if (oldReplace && oldQueue.length === 1) {
          inst.state = oldQueue[0];
        } else {
          var nextState = oldReplace ? oldQueue[0] : inst.state;
          var dontMutate = true;
          for (var i = oldReplace ? 1 : 0; i < oldQueue.length; i++) {
            var partial = oldQueue[i];
            var _partialState = typeof partial === 'function' ? partial.call(inst, nextState, element.props, publicContext) : partial;
            if (_partialState != null) {
              if (dontMutate) {
                dontMutate = false;
                nextState = _assign({}, nextState, _partialState);
              } else {
                _assign(nextState, _partialState);
              }
            }
          }
          inst.state = nextState;
        }
      } else {
        queue = null;
      }
    }
    child = inst.render();

    {
      if (child === undefined && inst.render._isMockFunction) {
        // This is probably bad practice. Consider warning here and
        // deprecating this convenience.
        child = null;
      }
    }
    validateRenderResult(child, Component);

    var childContext = void 0;
    if (typeof inst.getChildContext === 'function') {
      var childContextTypes = Component.childContextTypes;
      if (typeof childContextTypes === 'object') {
        childContext = inst.getChildContext();
        for (var contextKey in childContext) {
          !(contextKey in childContextTypes) ? invariant(false, '%s.getChildContext(): key "%s" is not defined in childContextTypes.', getComponentName(Component) || 'Unknown', contextKey) : void 0;
        }
      } else {
        warningWithoutStack$1(false, '%s.getChildContext(): childContextTypes must be defined in order to ' + 'use getChildContext().', getComponentName(Component) || 'Unknown');
      }
    }
    if (childContext) {
      context = _assign({}, context, childContext);
    }
  }
  return { child: child, context: context };
}

var ReactDOMServerRenderer = function () {
  // DEV-only

  // TODO: type this more strictly:
  function ReactDOMServerRenderer(children, makeStaticMarkup) {
    _classCallCheck(this, ReactDOMServerRenderer);

    var flatChildren = flattenTopLevelChildren(children);

    var topFrame = {
      type: null,
      // Assume all trees start in the HTML namespace (not totally true, but
      // this is what we did historically)
      domNamespace: Namespaces.html,
      children: flatChildren,
      childIndex: 0,
      context: emptyObject,
      footer: ''
    };
    {
      topFrame.debugElementStack = [];
    }
    this.threadID = allocThreadID();
    this.stack = [topFrame];
    this.exhausted = false;
    this.currentSelectValue = null;
    this.previousWasTextNode = false;
    this.makeStaticMarkup = makeStaticMarkup;
    this.suspenseDepth = 0;

    // Context (new API)
    this.contextIndex = -1;
    this.contextStack = [];
    this.contextValueStack = [];
    {
      this.contextProviderStack = [];
    }
  }

  ReactDOMServerRenderer.prototype.destroy = function destroy() {
    if (!this.exhausted) {
      this.exhausted = true;
      freeThreadID(this.threadID);
    }
  };

  /**
   * Note: We use just two stacks regardless of how many context providers you have.
   * Providers are always popped in the reverse order to how they were pushed
   * so we always know on the way down which provider you'll encounter next on the way up.
   * On the way down, we push the current provider, and its context value *before*
   * we mutated it, onto the stacks. Therefore, on the way up, we always know which
   * provider needs to be "restored" to which value.
   * https://github.com/facebook/react/pull/12985#issuecomment-396301248
   */

  ReactDOMServerRenderer.prototype.pushProvider = function pushProvider(provider) {
    var index = ++this.contextIndex;
    var context = provider.type._context;
    var threadID = this.threadID;
    validateContextBounds(context, threadID);
    var previousValue = context[threadID];

    // Remember which value to restore this context to on our way up.
    this.contextStack[index] = context;
    this.contextValueStack[index] = previousValue;
    {
      // Only used for push/pop mismatch warnings.
      this.contextProviderStack[index] = provider;
    }

    // Mutate the current value.
    context[threadID] = provider.props.value;
  };

  ReactDOMServerRenderer.prototype.popProvider = function popProvider(provider) {
    var index = this.contextIndex;
    {
      !(index > -1 && provider === this.contextProviderStack[index]) ? warningWithoutStack$1(false, 'Unexpected pop.') : void 0;
    }

    var context = this.contextStack[index];
    var previousValue = this.contextValueStack[index];

    // "Hide" these null assignments from Flow by using `any`
    // because conceptually they are deletions--as long as we
    // promise to never access values beyond `this.contextIndex`.
    this.contextStack[index] = null;
    this.contextValueStack[index] = null;
    {
      this.contextProviderStack[index] = null;
    }
    this.contextIndex--;

    // Restore to the previous value we stored as we were walking down.
    // We've already verified that this context has been expanded to accommodate
    // this thread id, so we don't need to do it again.
    context[this.threadID] = previousValue;
  };

  ReactDOMServerRenderer.prototype.read = function read(bytes) {
    if (this.exhausted) {
      return null;
    }

    var prevThreadID = currentThreadID;
    setCurrentThreadID(this.threadID);
    var prevDispatcher = ReactCurrentDispatcher.current;
    ReactCurrentDispatcher.current = Dispatcher;
    try {
      // Markup generated within <Suspense> ends up buffered until we know
      // nothing in that boundary suspended
      var out = [''];
      var suspended = false;
      while (out[0].length < bytes) {
        if (this.stack.length === 0) {
          this.exhausted = true;
          freeThreadID(this.threadID);
          break;
        }
        var frame = this.stack[this.stack.length - 1];
        if (suspended || frame.childIndex >= frame.children.length) {
          var _footer = frame.footer;
          if (_footer !== '') {
            this.previousWasTextNode = false;
          }
          this.stack.pop();
          if (frame.type === 'select') {
            this.currentSelectValue = null;
          } else if (frame.type != null && frame.type.type != null && frame.type.type.$$typeof === REACT_PROVIDER_TYPE) {
            var provider = frame.type;
            this.popProvider(provider);
          } else if (frame.type === REACT_SUSPENSE_TYPE) {
            this.suspenseDepth--;
            var buffered = out.pop();

            if (suspended) {
              suspended = false;
              // If rendering was suspended at this boundary, render the fallbackFrame
              var _fallbackFrame = frame.fallbackFrame;
              !_fallbackFrame ? invariant(false, 'suspense fallback not found, something is broken') : void 0;
              this.stack.push(_fallbackFrame);
              // Skip flushing output since we're switching to the fallback
              continue;
            } else {
              out[this.suspenseDepth] += buffered;
            }
          }

          // Flush output
          out[this.suspenseDepth] += _footer;
          continue;
        }
        var child = frame.children[frame.childIndex++];

        var outBuffer = '';
        {
          pushCurrentDebugStack(this.stack);
          // We're starting work on this frame, so reset its inner stack.
          frame.debugElementStack.length = 0;
        }
        try {
          outBuffer += this.render(child, frame.context, frame.domNamespace);
        } catch (err) {
          if (enableSuspenseServerRenderer && typeof err.then === 'function') {
            suspended = true;
          } else {
            throw err;
          }
        } finally {
          {
            popCurrentDebugStack();
          }
        }
        if (out.length <= this.suspenseDepth) {
          out.push('');
        }
        out[this.suspenseDepth] += outBuffer;
      }
      return out[0];
    } finally {
      ReactCurrentDispatcher.current = prevDispatcher;
      setCurrentThreadID(prevThreadID);
    }
  };

  ReactDOMServerRenderer.prototype.render = function render(child, context, parentNamespace) {
    if (typeof child === 'string' || typeof child === 'number') {
      var text = '' + child;
      if (text === '') {
        return '';
      }
      if (this.makeStaticMarkup) {
        return escapeTextForBrowser(text);
      }
      if (this.previousWasTextNode) {
        return '<!-- -->' + escapeTextForBrowser(text);
      }
      this.previousWasTextNode = true;
      return escapeTextForBrowser(text);
    } else {
      var nextChild = void 0;

      var _resolve = resolve(child, context, this.threadID);

      nextChild = _resolve.child;
      context = _resolve.context;

      if (nextChild === null || nextChild === false) {
        return '';
      } else if (!React.isValidElement(nextChild)) {
        if (nextChild != null && nextChild.$$typeof != null) {
          // Catch unexpected special types early.
          var $$typeof = nextChild.$$typeof;
          !($$typeof !== REACT_PORTAL_TYPE) ? invariant(false, 'Portals are not currently supported by the server renderer. Render them conditionally so that they only appear on the client render.') : void 0;
          // Catch-all to prevent an infinite loop if React.Children.toArray() supports some new type.
          invariant(false, 'Unknown element-like object type: %s. This is likely a bug in React. Please file an issue.', $$typeof.toString());
        }
        var nextChildren = toArray(nextChild);
        var frame = {
          type: null,
          domNamespace: parentNamespace,
          children: nextChildren,
          childIndex: 0,
          context: context,
          footer: ''
        };
        {
          frame.debugElementStack = [];
        }
        this.stack.push(frame);
        return '';
      }
      // Safe because we just checked it's an element.
      var nextElement = nextChild;
      var elementType = nextElement.type;

      if (typeof elementType === 'string') {
        return this.renderDOM(nextElement, context, parentNamespace);
      }

      switch (elementType) {
        case REACT_STRICT_MODE_TYPE:
        case REACT_CONCURRENT_MODE_TYPE:
        case REACT_PROFILER_TYPE:
        case REACT_FRAGMENT_TYPE:
          {
            var _nextChildren = toArray(nextChild.props.children);
            var _frame = {
              type: null,
              domNamespace: parentNamespace,
              children: _nextChildren,
              childIndex: 0,
              context: context,
              footer: ''
            };
            {
              _frame.debugElementStack = [];
            }
            this.stack.push(_frame);
            return '';
          }
        case REACT_SUSPENSE_TYPE:
          {
            if (enableSuspenseServerRenderer) {
              var fallbackChildren = toArray(nextChild.props.fallback);
              var _nextChildren2 = toArray(nextChild.props.children);
              var _fallbackFrame2 = {
                type: null,
                domNamespace: parentNamespace,
                children: fallbackChildren,
                childIndex: 0,
                context: context,
                footer: '',
                out: ''
              };
              var _frame2 = {
                fallbackFrame: _fallbackFrame2,
                type: REACT_SUSPENSE_TYPE,
                domNamespace: parentNamespace,
                children: _nextChildren2,
                childIndex: 0,
                context: context,
                footer: ''
              };
              {
                _frame2.debugElementStack = [];
                _fallbackFrame2.debugElementStack = [];
              }
              this.stack.push(_frame2);
              this.suspenseDepth++;
              return '';
            } else {
              invariant(false, 'ReactDOMServer does not yet support Suspense.');
            }
          }
        // eslint-disable-next-line-no-fallthrough
        default:
          break;
      }
      if (typeof elementType === 'object' && elementType !== null) {
        switch (elementType.$$typeof) {
          case REACT_FORWARD_REF_TYPE:
            {
              var element = nextChild;
              var _nextChildren3 = void 0;
              var componentIdentity = {};
              prepareToUseHooks(componentIdentity);
              _nextChildren3 = elementType.render(element.props, element.ref);
              _nextChildren3 = finishHooks(elementType.render, element.props, _nextChildren3, element.ref);
              _nextChildren3 = toArray(_nextChildren3);
              var _frame3 = {
                type: null,
                domNamespace: parentNamespace,
                children: _nextChildren3,
                childIndex: 0,
                context: context,
                footer: ''
              };
              {
                _frame3.debugElementStack = [];
              }
              this.stack.push(_frame3);
              return '';
            }
          case REACT_MEMO_TYPE:
            {
              var _element = nextChild;
              var _nextChildren4 = [React.createElement(elementType.type, _assign({ ref: _element.ref }, _element.props))];
              var _frame4 = {
                type: null,
                domNamespace: parentNamespace,
                children: _nextChildren4,
                childIndex: 0,
                context: context,
                footer: ''
              };
              {
                _frame4.debugElementStack = [];
              }
              this.stack.push(_frame4);
              return '';
            }
          case REACT_PROVIDER_TYPE:
            {
              var provider = nextChild;
              var nextProps = provider.props;
              var _nextChildren5 = toArray(nextProps.children);
              var _frame5 = {
                type: provider,
                domNamespace: parentNamespace,
                children: _nextChildren5,
                childIndex: 0,
                context: context,
                footer: ''
              };
              {
                _frame5.debugElementStack = [];
              }

              this.pushProvider(provider);

              this.stack.push(_frame5);
              return '';
            }
          case REACT_CONTEXT_TYPE:
            {
              var reactContext = nextChild.type;
              // The logic below for Context differs depending on PROD or DEV mode. In
              // DEV mode, we create a separate object for Context.Consumer that acts
              // like a proxy to Context. This proxy object adds unnecessary code in PROD
              // so we use the old behaviour (Context.Consumer references Context) to
              // reduce size and overhead. The separate object references context via
              // a property called "_context", which also gives us the ability to check
              // in DEV mode if this property exists or not and warn if it does not.
              {
                if (reactContext._context === undefined) {
                  // This may be because it's a Context (rather than a Consumer).
                  // Or it may be because it's older React where they're the same thing.
                  // We only want to warn if we're sure it's a new React.
                  if (reactContext !== reactContext.Consumer) {
                    if (!hasWarnedAboutUsingContextAsConsumer) {
                      hasWarnedAboutUsingContextAsConsumer = true;
                      warning$1(false, 'Rendering <Context> directly is not supported and will be removed in ' + 'a future major release. Did you mean to render <Context.Consumer> instead?');
                    }
                  }
                } else {
                  reactContext = reactContext._context;
                }
              }
              var _nextProps = nextChild.props;
              var threadID = this.threadID;
              validateContextBounds(reactContext, threadID);
              var nextValue = reactContext[threadID];

              var _nextChildren6 = toArray(_nextProps.children(nextValue));
              var _frame6 = {
                type: nextChild,
                domNamespace: parentNamespace,
                children: _nextChildren6,
                childIndex: 0,
                context: context,
                footer: ''
              };
              {
                _frame6.debugElementStack = [];
              }
              this.stack.push(_frame6);
              return '';
            }
          case REACT_LAZY_TYPE:
            invariant(false, 'ReactDOMServer does not yet support lazy-loaded components.');
        }
      }

      var info = '';
      {
        var owner = nextElement._owner;
        if (elementType === undefined || typeof elementType === 'object' && elementType !== null && Object.keys(elementType).length === 0) {
          info += ' You likely forgot to export your component from the file ' + "it's defined in, or you might have mixed up default and " + 'named imports.';
        }
        var ownerName = owner ? getComponentName(owner) : null;
        if (ownerName) {
          info += '\n\nCheck the render method of `' + ownerName + '`.';
        }
      }
      invariant(false, 'Element type is invalid: expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s', elementType == null ? elementType : typeof elementType, info);
    }
  };

  ReactDOMServerRenderer.prototype.renderDOM = function renderDOM(element, context, parentNamespace) {
    var tag = element.type.toLowerCase();

    var namespace = parentNamespace;
    if (parentNamespace === Namespaces.html) {
      namespace = getIntrinsicNamespace(tag);
    }

    {
      if (namespace === Namespaces.html) {
        // Should this check be gated by parent namespace? Not sure we want to
        // allow <SVG> or <mATH>.
        !(tag === element.type) ? warning$1(false, '<%s /> is using incorrect casing. ' + 'Use PascalCase for React components, ' + 'or lowercase for HTML elements.', element.type) : void 0;
      }
    }

    validateDangerousTag(tag);

    var props = element.props;
    if (tag === 'input') {
      {
        ReactControlledValuePropTypes.checkPropTypes('input', props);

        if (props.checked !== undefined && props.defaultChecked !== undefined && !didWarnDefaultChecked) {
          warning$1(false, '%s contains an input of type %s with both checked and defaultChecked props. ' + 'Input elements must be either controlled or uncontrolled ' + '(specify either the checked prop, or the defaultChecked prop, but not ' + 'both). Decide between using a controlled or uncontrolled input ' + 'element and remove one of these props. More info: ' + 'https://fb.me/react-controlled-components', 'A component', props.type);
          didWarnDefaultChecked = true;
        }
        if (props.value !== undefined && props.defaultValue !== undefined && !didWarnDefaultInputValue) {
          warning$1(false, '%s contains an input of type %s with both value and defaultValue props. ' + 'Input elements must be either controlled or uncontrolled ' + '(specify either the value prop, or the defaultValue prop, but not ' + 'both). Decide between using a controlled or uncontrolled input ' + 'element and remove one of these props. More info: ' + 'https://fb.me/react-controlled-components', 'A component', props.type);
          didWarnDefaultInputValue = true;
        }
      }

      props = _assign({
        type: undefined
      }, props, {
        defaultChecked: undefined,
        defaultValue: undefined,
        value: props.value != null ? props.value : props.defaultValue,
        checked: props.checked != null ? props.checked : props.defaultChecked
      });
    } else if (tag === 'textarea') {
      {
        ReactControlledValuePropTypes.checkPropTypes('textarea', props);
        if (props.value !== undefined && props.defaultValue !== undefined && !didWarnDefaultTextareaValue) {
          warning$1(false, 'Textarea elements must be either controlled or uncontrolled ' + '(specify either the value prop, or the defaultValue prop, but not ' + 'both). Decide between using a controlled or uncontrolled textarea ' + 'and remove one of these props. More info: ' + 'https://fb.me/react-controlled-components');
          didWarnDefaultTextareaValue = true;
        }
      }

      var initialValue = props.value;
      if (initialValue == null) {
        var defaultValue = props.defaultValue;
        // TODO (yungsters): Remove support for children content in <textarea>.
        var textareaChildren = props.children;
        if (textareaChildren != null) {
          {
            warning$1(false, 'Use the `defaultValue` or `value` props instead of setting ' + 'children on <textarea>.');
          }
          !(defaultValue == null) ? invariant(false, 'If you supply `defaultValue` on a <textarea>, do not pass children.') : void 0;
          if (Array.isArray(textareaChildren)) {
            !(textareaChildren.length <= 1) ? invariant(false, '<textarea> can only have at most one child.') : void 0;
            textareaChildren = textareaChildren[0];
          }

          defaultValue = '' + textareaChildren;
        }
        if (defaultValue == null) {
          defaultValue = '';
        }
        initialValue = defaultValue;
      }

      props = _assign({}, props, {
        value: undefined,
        children: '' + initialValue
      });
    } else if (tag === 'select') {
      {
        ReactControlledValuePropTypes.checkPropTypes('select', props);

        for (var i = 0; i < valuePropNames.length; i++) {
          var propName = valuePropNames[i];
          if (props[propName] == null) {
            continue;
          }
          var isArray = Array.isArray(props[propName]);
          if (props.multiple && !isArray) {
            warning$1(false, 'The `%s` prop supplied to <select> must be an array if ' + '`multiple` is true.', propName);
          } else if (!props.multiple && isArray) {
            warning$1(false, 'The `%s` prop supplied to <select> must be a scalar ' + 'value if `multiple` is false.', propName);
          }
        }

        if (props.value !== undefined && props.defaultValue !== undefined && !didWarnDefaultSelectValue) {
          warning$1(false, 'Select elements must be either controlled or uncontrolled ' + '(specify either the value prop, or the defaultValue prop, but not ' + 'both). Decide between using a controlled or uncontrolled select ' + 'element and remove one of these props. More info: ' + 'https://fb.me/react-controlled-components');
          didWarnDefaultSelectValue = true;
        }
      }
      this.currentSelectValue = props.value != null ? props.value : props.defaultValue;
      props = _assign({}, props, {
        value: undefined
      });
    } else if (tag === 'option') {
      var selected = null;
      var selectValue = this.currentSelectValue;
      var optionChildren = flattenOptionChildren(props.children);
      if (selectValue != null) {
        var value = void 0;
        if (props.value != null) {
          value = props.value + '';
        } else {
          value = optionChildren;
        }
        selected = false;
        if (Array.isArray(selectValue)) {
          // multiple
          for (var j = 0; j < selectValue.length; j++) {
            if ('' + selectValue[j] === value) {
              selected = true;
              break;
            }
          }
        } else {
          selected = '' + selectValue === value;
        }

        props = _assign({
          selected: undefined,
          children: undefined
        }, props, {
          selected: selected,
          children: optionChildren
        });
      }
    }

    {
      validatePropertiesInDevelopment(tag, props);
    }

    assertValidProps(tag, props);

    var out = createOpenTagMarkup(element.type, tag, props, namespace, this.makeStaticMarkup, this.stack.length === 1);
    var footer = '';
    if (omittedCloseTags.hasOwnProperty(tag)) {
      out += '/>';
    } else {
      out += '>';
      footer = '</' + element.type + '>';
    }
    var children = void 0;
    var innerMarkup = getNonChildrenInnerMarkup(props);
    if (innerMarkup != null) {
      children = [];
      if (newlineEatingTags[tag] && innerMarkup.charAt(0) === '\n') {
        // text/html ignores the first character in these tags if it's a newline
        // Prefer to break application/xml over text/html (for now) by adding
        // a newline specifically to get eaten by the parser. (Alternately for
        // textareas, replacing "^\n" with "\r\n" doesn't get eaten, and the first
        // \r is normalized out by HTMLTextAreaElement#value.)
        // See: <http://www.w3.org/TR/html-polyglot/#newlines-in-textarea-and-pre>
        // See: <http://www.w3.org/TR/html5/syntax.html#element-restrictions>
        // See: <http://www.w3.org/TR/html5/syntax.html#newlines>
        // See: Parsing of "textarea" "listing" and "pre" elements
        //  from <http://www.w3.org/TR/html5/syntax.html#parsing-main-inbody>
        out += '\n';
      }
      out += innerMarkup;
    } else {
      children = toArray(props.children);
    }
    var frame = {
      domNamespace: getChildNamespace(parentNamespace, element.type),
      type: tag,
      children: children,
      childIndex: 0,
      context: context,
      footer: footer
    };
    {
      frame.debugElementStack = [];
    }
    this.stack.push(frame);
    this.previousWasTextNode = false;
    return out;
  };

  return ReactDOMServerRenderer;
}();

/**
 * Render a ReactElement to its initial HTML. This should only be used on the
 * server.
 * See https://reactjs.org/docs/react-dom-server.html#rendertostring
 */
function renderToString(element) {
  var renderer = new ReactDOMServerRenderer(element, false);
  try {
    var markup = renderer.read(Infinity);
    return markup;
  } finally {
    renderer.destroy();
  }
}

/**
 * Similar to renderToString, except this doesn't create extra DOM attributes
 * such as data-react-id that React uses internally.
 * See https://reactjs.org/docs/react-dom-server.html#rendertostaticmarkup
 */
function renderToStaticMarkup(element) {
  var renderer = new ReactDOMServerRenderer(element, true);
  try {
    var markup = renderer.read(Infinity);
    return markup;
  } finally {
    renderer.destroy();
  }
}

function renderToNodeStream() {
  invariant(false, 'ReactDOMServer.renderToNodeStream(): The streaming API is not available in the browser. Use ReactDOMServer.renderToString() instead.');
}

function renderToStaticNodeStream() {
  invariant(false, 'ReactDOMServer.renderToStaticNodeStream(): The streaming API is not available in the browser. Use ReactDOMServer.renderToStaticMarkup() instead.');
}

// Note: when changing this, also consider https://github.com/facebook/react/issues/11526
var ReactDOMServerBrowser = {
  renderToString: renderToString,
  renderToStaticMarkup: renderToStaticMarkup,
  renderToNodeStream: renderToNodeStream,
  renderToStaticNodeStream: renderToStaticNodeStream,
  version: ReactVersion
};

var ReactDOMServerBrowser$1 = Object.freeze({
	default: ReactDOMServerBrowser
});

var ReactDOMServer = ( ReactDOMServerBrowser$1 && ReactDOMServerBrowser ) || ReactDOMServerBrowser$1;

// TODO: decide on the top-level export form.
// This is hacky but makes it work with both Rollup and Jest
var server_browser = ReactDOMServer.default || ReactDOMServer;

module.exports = server_browser;
  })();
}


/***/ }),

/***/ "./node_modules/react-dom/server.browser.js":
/*!**************************************************!*\
  !*** ./node_modules/react-dom/server.browser.js ***!
  \**************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


if (false) {} else {
  module.exports = __webpack_require__(/*! ./cjs/react-dom-server.browser.development.js */ "./node_modules/react-dom/cjs/react-dom-server.browser.development.js");
}


/***/ }),

/***/ "./node_modules/react/cjs/react.development.js":
/*!*****************************************************!*\
  !*** ./node_modules/react/cjs/react.development.js ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/** @license React v16.8.1
 * react.development.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */





if (true) {
  (function() {
'use strict';

var _assign = __webpack_require__(/*! object-assign */ "./node_modules/object-assign/index.js");
var checkPropTypes = __webpack_require__(/*! prop-types/checkPropTypes */ "./node_modules/prop-types/checkPropTypes.js");

// TODO: this is special because it gets imported during build.

var ReactVersion = '16.8.1';

// The Symbol used to tag the ReactElement-like types. If there is no native Symbol
// nor polyfill, then a plain number is used for performance.
var hasSymbol = typeof Symbol === 'function' && Symbol.for;

var REACT_ELEMENT_TYPE = hasSymbol ? Symbol.for('react.element') : 0xeac7;
var REACT_PORTAL_TYPE = hasSymbol ? Symbol.for('react.portal') : 0xeaca;
var REACT_FRAGMENT_TYPE = hasSymbol ? Symbol.for('react.fragment') : 0xeacb;
var REACT_STRICT_MODE_TYPE = hasSymbol ? Symbol.for('react.strict_mode') : 0xeacc;
var REACT_PROFILER_TYPE = hasSymbol ? Symbol.for('react.profiler') : 0xead2;
var REACT_PROVIDER_TYPE = hasSymbol ? Symbol.for('react.provider') : 0xeacd;
var REACT_CONTEXT_TYPE = hasSymbol ? Symbol.for('react.context') : 0xeace;

var REACT_CONCURRENT_MODE_TYPE = hasSymbol ? Symbol.for('react.concurrent_mode') : 0xeacf;
var REACT_FORWARD_REF_TYPE = hasSymbol ? Symbol.for('react.forward_ref') : 0xead0;
var REACT_SUSPENSE_TYPE = hasSymbol ? Symbol.for('react.suspense') : 0xead1;
var REACT_MEMO_TYPE = hasSymbol ? Symbol.for('react.memo') : 0xead3;
var REACT_LAZY_TYPE = hasSymbol ? Symbol.for('react.lazy') : 0xead4;

var MAYBE_ITERATOR_SYMBOL = typeof Symbol === 'function' && Symbol.iterator;
var FAUX_ITERATOR_SYMBOL = '@@iterator';

function getIteratorFn(maybeIterable) {
  if (maybeIterable === null || typeof maybeIterable !== 'object') {
    return null;
  }
  var maybeIterator = MAYBE_ITERATOR_SYMBOL && maybeIterable[MAYBE_ITERATOR_SYMBOL] || maybeIterable[FAUX_ITERATOR_SYMBOL];
  if (typeof maybeIterator === 'function') {
    return maybeIterator;
  }
  return null;
}

/**
 * Use invariant() to assert state which your program assumes to be true.
 *
 * Provide sprintf-style format (only %s is supported) and arguments
 * to provide information about what broke and what you were
 * expecting.
 *
 * The invariant message will be stripped in production, but the invariant
 * will remain to ensure logic does not differ in production.
 */

var validateFormat = function () {};

{
  validateFormat = function (format) {
    if (format === undefined) {
      throw new Error('invariant requires an error message argument');
    }
  };
}

function invariant(condition, format, a, b, c, d, e, f) {
  validateFormat(format);

  if (!condition) {
    var error = void 0;
    if (format === undefined) {
      error = new Error('Minified exception occurred; use the non-minified dev environment ' + 'for the full error message and additional helpful warnings.');
    } else {
      var args = [a, b, c, d, e, f];
      var argIndex = 0;
      error = new Error(format.replace(/%s/g, function () {
        return args[argIndex++];
      }));
      error.name = 'Invariant Violation';
    }

    error.framesToPop = 1; // we don't care about invariant's own frame
    throw error;
  }
}

// Relying on the `invariant()` implementation lets us
// preserve the format and params in the www builds.

/**
 * Forked from fbjs/warning:
 * https://github.com/facebook/fbjs/blob/e66ba20ad5be433eb54423f2b097d829324d9de6/packages/fbjs/src/__forks__/warning.js
 *
 * Only change is we use console.warn instead of console.error,
 * and do nothing when 'console' is not supported.
 * This really simplifies the code.
 * ---
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var lowPriorityWarning = function () {};

{
  var printWarning = function (format) {
    for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      args[_key - 1] = arguments[_key];
    }

    var argIndex = 0;
    var message = 'Warning: ' + format.replace(/%s/g, function () {
      return args[argIndex++];
    });
    if (typeof console !== 'undefined') {
      console.warn(message);
    }
    try {
      // --- Welcome to debugging React ---
      // This error was thrown as a convenience so that you can use this stack
      // to find the callsite that caused this warning to fire.
      throw new Error(message);
    } catch (x) {}
  };

  lowPriorityWarning = function (condition, format) {
    if (format === undefined) {
      throw new Error('`lowPriorityWarning(condition, format, ...args)` requires a warning ' + 'message argument');
    }
    if (!condition) {
      for (var _len2 = arguments.length, args = Array(_len2 > 2 ? _len2 - 2 : 0), _key2 = 2; _key2 < _len2; _key2++) {
        args[_key2 - 2] = arguments[_key2];
      }

      printWarning.apply(undefined, [format].concat(args));
    }
  };
}

var lowPriorityWarning$1 = lowPriorityWarning;

/**
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var warningWithoutStack = function () {};

{
  warningWithoutStack = function (condition, format) {
    for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      args[_key - 2] = arguments[_key];
    }

    if (format === undefined) {
      throw new Error('`warningWithoutStack(condition, format, ...args)` requires a warning ' + 'message argument');
    }
    if (args.length > 8) {
      // Check before the condition to catch violations early.
      throw new Error('warningWithoutStack() currently supports at most 8 arguments.');
    }
    if (condition) {
      return;
    }
    if (typeof console !== 'undefined') {
      var argsWithFormat = args.map(function (item) {
        return '' + item;
      });
      argsWithFormat.unshift('Warning: ' + format);

      // We intentionally don't use spread (or .apply) directly because it
      // breaks IE9: https://github.com/facebook/react/issues/13610
      Function.prototype.apply.call(console.error, console, argsWithFormat);
    }
    try {
      // --- Welcome to debugging React ---
      // This error was thrown as a convenience so that you can use this stack
      // to find the callsite that caused this warning to fire.
      var argIndex = 0;
      var message = 'Warning: ' + format.replace(/%s/g, function () {
        return args[argIndex++];
      });
      throw new Error(message);
    } catch (x) {}
  };
}

var warningWithoutStack$1 = warningWithoutStack;

var didWarnStateUpdateForUnmountedComponent = {};

function warnNoop(publicInstance, callerName) {
  {
    var _constructor = publicInstance.constructor;
    var componentName = _constructor && (_constructor.displayName || _constructor.name) || 'ReactClass';
    var warningKey = componentName + '.' + callerName;
    if (didWarnStateUpdateForUnmountedComponent[warningKey]) {
      return;
    }
    warningWithoutStack$1(false, "Can't call %s on a component that is not yet mounted. " + 'This is a no-op, but it might indicate a bug in your application. ' + 'Instead, assign to `this.state` directly or define a `state = {};` ' + 'class property with the desired state in the %s component.', callerName, componentName);
    didWarnStateUpdateForUnmountedComponent[warningKey] = true;
  }
}

/**
 * This is the abstract API for an update queue.
 */
var ReactNoopUpdateQueue = {
  /**
   * Checks whether or not this composite component is mounted.
   * @param {ReactClass} publicInstance The instance we want to test.
   * @return {boolean} True if mounted, false otherwise.
   * @protected
   * @final
   */
  isMounted: function (publicInstance) {
    return false;
  },

  /**
   * Forces an update. This should only be invoked when it is known with
   * certainty that we are **not** in a DOM transaction.
   *
   * You may want to call this when you know that some deeper aspect of the
   * component's state has changed but `setState` was not called.
   *
   * This will not invoke `shouldComponentUpdate`, but it will invoke
   * `componentWillUpdate` and `componentDidUpdate`.
   *
   * @param {ReactClass} publicInstance The instance that should rerender.
   * @param {?function} callback Called after component is updated.
   * @param {?string} callerName name of the calling function in the public API.
   * @internal
   */
  enqueueForceUpdate: function (publicInstance, callback, callerName) {
    warnNoop(publicInstance, 'forceUpdate');
  },

  /**
   * Replaces all of the state. Always use this or `setState` to mutate state.
   * You should treat `this.state` as immutable.
   *
   * There is no guarantee that `this.state` will be immediately updated, so
   * accessing `this.state` after calling this method may return the old value.
   *
   * @param {ReactClass} publicInstance The instance that should rerender.
   * @param {object} completeState Next state.
   * @param {?function} callback Called after component is updated.
   * @param {?string} callerName name of the calling function in the public API.
   * @internal
   */
  enqueueReplaceState: function (publicInstance, completeState, callback, callerName) {
    warnNoop(publicInstance, 'replaceState');
  },

  /**
   * Sets a subset of the state. This only exists because _pendingState is
   * internal. This provides a merging strategy that is not available to deep
   * properties which is confusing. TODO: Expose pendingState or don't use it
   * during the merge.
   *
   * @param {ReactClass} publicInstance The instance that should rerender.
   * @param {object} partialState Next partial state to be merged with state.
   * @param {?function} callback Called after component is updated.
   * @param {?string} Name of the calling function in the public API.
   * @internal
   */
  enqueueSetState: function (publicInstance, partialState, callback, callerName) {
    warnNoop(publicInstance, 'setState');
  }
};

var emptyObject = {};
{
  Object.freeze(emptyObject);
}

/**
 * Base class helpers for the updating state of a component.
 */
function Component(props, context, updater) {
  this.props = props;
  this.context = context;
  // If a component has string refs, we will assign a different object later.
  this.refs = emptyObject;
  // We initialize the default updater but the real one gets injected by the
  // renderer.
  this.updater = updater || ReactNoopUpdateQueue;
}

Component.prototype.isReactComponent = {};

/**
 * Sets a subset of the state. Always use this to mutate
 * state. You should treat `this.state` as immutable.
 *
 * There is no guarantee that `this.state` will be immediately updated, so
 * accessing `this.state` after calling this method may return the old value.
 *
 * There is no guarantee that calls to `setState` will run synchronously,
 * as they may eventually be batched together.  You can provide an optional
 * callback that will be executed when the call to setState is actually
 * completed.
 *
 * When a function is provided to setState, it will be called at some point in
 * the future (not synchronously). It will be called with the up to date
 * component arguments (state, props, context). These values can be different
 * from this.* because your function may be called after receiveProps but before
 * shouldComponentUpdate, and this new state, props, and context will not yet be
 * assigned to this.
 *
 * @param {object|function} partialState Next partial state or function to
 *        produce next partial state to be merged with current state.
 * @param {?function} callback Called after state is updated.
 * @final
 * @protected
 */
Component.prototype.setState = function (partialState, callback) {
  !(typeof partialState === 'object' || typeof partialState === 'function' || partialState == null) ? invariant(false, 'setState(...): takes an object of state variables to update or a function which returns an object of state variables.') : void 0;
  this.updater.enqueueSetState(this, partialState, callback, 'setState');
};

/**
 * Forces an update. This should only be invoked when it is known with
 * certainty that we are **not** in a DOM transaction.
 *
 * You may want to call this when you know that some deeper aspect of the
 * component's state has changed but `setState` was not called.
 *
 * This will not invoke `shouldComponentUpdate`, but it will invoke
 * `componentWillUpdate` and `componentDidUpdate`.
 *
 * @param {?function} callback Called after update is complete.
 * @final
 * @protected
 */
Component.prototype.forceUpdate = function (callback) {
  this.updater.enqueueForceUpdate(this, callback, 'forceUpdate');
};

/**
 * Deprecated APIs. These APIs used to exist on classic React classes but since
 * we would like to deprecate them, we're not going to move them over to this
 * modern base class. Instead, we define a getter that warns if it's accessed.
 */
{
  var deprecatedAPIs = {
    isMounted: ['isMounted', 'Instead, make sure to clean up subscriptions and pending requests in ' + 'componentWillUnmount to prevent memory leaks.'],
    replaceState: ['replaceState', 'Refactor your code to use setState instead (see ' + 'https://github.com/facebook/react/issues/3236).']
  };
  var defineDeprecationWarning = function (methodName, info) {
    Object.defineProperty(Component.prototype, methodName, {
      get: function () {
        lowPriorityWarning$1(false, '%s(...) is deprecated in plain JavaScript React classes. %s', info[0], info[1]);
        return undefined;
      }
    });
  };
  for (var fnName in deprecatedAPIs) {
    if (deprecatedAPIs.hasOwnProperty(fnName)) {
      defineDeprecationWarning(fnName, deprecatedAPIs[fnName]);
    }
  }
}

function ComponentDummy() {}
ComponentDummy.prototype = Component.prototype;

/**
 * Convenience component with default shallow equality check for sCU.
 */
function PureComponent(props, context, updater) {
  this.props = props;
  this.context = context;
  // If a component has string refs, we will assign a different object later.
  this.refs = emptyObject;
  this.updater = updater || ReactNoopUpdateQueue;
}

var pureComponentPrototype = PureComponent.prototype = new ComponentDummy();
pureComponentPrototype.constructor = PureComponent;
// Avoid an extra prototype jump for these methods.
_assign(pureComponentPrototype, Component.prototype);
pureComponentPrototype.isPureReactComponent = true;

// an immutable object with a single mutable value
function createRef() {
  var refObject = {
    current: null
  };
  {
    Object.seal(refObject);
  }
  return refObject;
}

/**
 * Keeps track of the current dispatcher.
 */
var ReactCurrentDispatcher = {
  /**
   * @internal
   * @type {ReactComponent}
   */
  current: null
};

/**
 * Keeps track of the current owner.
 *
 * The current owner is the component who should own any components that are
 * currently being constructed.
 */
var ReactCurrentOwner = {
  /**
   * @internal
   * @type {ReactComponent}
   */
  current: null
};

var BEFORE_SLASH_RE = /^(.*)[\\\/]/;

var describeComponentFrame = function (name, source, ownerName) {
  var sourceInfo = '';
  if (source) {
    var path = source.fileName;
    var fileName = path.replace(BEFORE_SLASH_RE, '');
    {
      // In DEV, include code for a common special case:
      // prefer "folder/index.js" instead of just "index.js".
      if (/^index\./.test(fileName)) {
        var match = path.match(BEFORE_SLASH_RE);
        if (match) {
          var pathBeforeSlash = match[1];
          if (pathBeforeSlash) {
            var folderName = pathBeforeSlash.replace(BEFORE_SLASH_RE, '');
            fileName = folderName + '/' + fileName;
          }
        }
      }
    }
    sourceInfo = ' (at ' + fileName + ':' + source.lineNumber + ')';
  } else if (ownerName) {
    sourceInfo = ' (created by ' + ownerName + ')';
  }
  return '\n    in ' + (name || 'Unknown') + sourceInfo;
};

var Resolved = 1;


function refineResolvedLazyComponent(lazyComponent) {
  return lazyComponent._status === Resolved ? lazyComponent._result : null;
}

function getWrappedName(outerType, innerType, wrapperName) {
  var functionName = innerType.displayName || innerType.name || '';
  return outerType.displayName || (functionName !== '' ? wrapperName + '(' + functionName + ')' : wrapperName);
}

function getComponentName(type) {
  if (type == null) {
    // Host root, text node or just invalid type.
    return null;
  }
  {
    if (typeof type.tag === 'number') {
      warningWithoutStack$1(false, 'Received an unexpected object in getComponentName(). ' + 'This is likely a bug in React. Please file an issue.');
    }
  }
  if (typeof type === 'function') {
    return type.displayName || type.name || null;
  }
  if (typeof type === 'string') {
    return type;
  }
  switch (type) {
    case REACT_CONCURRENT_MODE_TYPE:
      return 'ConcurrentMode';
    case REACT_FRAGMENT_TYPE:
      return 'Fragment';
    case REACT_PORTAL_TYPE:
      return 'Portal';
    case REACT_PROFILER_TYPE:
      return 'Profiler';
    case REACT_STRICT_MODE_TYPE:
      return 'StrictMode';
    case REACT_SUSPENSE_TYPE:
      return 'Suspense';
  }
  if (typeof type === 'object') {
    switch (type.$$typeof) {
      case REACT_CONTEXT_TYPE:
        return 'Context.Consumer';
      case REACT_PROVIDER_TYPE:
        return 'Context.Provider';
      case REACT_FORWARD_REF_TYPE:
        return getWrappedName(type, type.render, 'ForwardRef');
      case REACT_MEMO_TYPE:
        return getComponentName(type.type);
      case REACT_LAZY_TYPE:
        {
          var thenable = type;
          var resolvedThenable = refineResolvedLazyComponent(thenable);
          if (resolvedThenable) {
            return getComponentName(resolvedThenable);
          }
        }
    }
  }
  return null;
}

var ReactDebugCurrentFrame = {};

var currentlyValidatingElement = null;

function setCurrentlyValidatingElement(element) {
  {
    currentlyValidatingElement = element;
  }
}

{
  // Stack implementation injected by the current renderer.
  ReactDebugCurrentFrame.getCurrentStack = null;

  ReactDebugCurrentFrame.getStackAddendum = function () {
    var stack = '';

    // Add an extra top frame while an element is being validated
    if (currentlyValidatingElement) {
      var name = getComponentName(currentlyValidatingElement.type);
      var owner = currentlyValidatingElement._owner;
      stack += describeComponentFrame(name, currentlyValidatingElement._source, owner && getComponentName(owner.type));
    }

    // Delegate to the injected renderer-specific implementation
    var impl = ReactDebugCurrentFrame.getCurrentStack;
    if (impl) {
      stack += impl() || '';
    }

    return stack;
  };
}

var ReactSharedInternals = {
  ReactCurrentDispatcher: ReactCurrentDispatcher,
  ReactCurrentOwner: ReactCurrentOwner,
  // Used by renderers to avoid bundling object-assign twice in UMD bundles:
  assign: _assign
};

{
  _assign(ReactSharedInternals, {
    // These should not be included in production.
    ReactDebugCurrentFrame: ReactDebugCurrentFrame,
    // Shim for React DOM 16.0.0 which still destructured (but not used) this.
    // TODO: remove in React 17.0.
    ReactComponentTreeHook: {}
  });
}

/**
 * Similar to invariant but only logs a warning if the condition is not met.
 * This can be used to log issues in development environments in critical
 * paths. Removing the logging code for production environments will keep the
 * same logic and follow the same code paths.
 */

var warning = warningWithoutStack$1;

{
  warning = function (condition, format) {
    if (condition) {
      return;
    }
    var ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame;
    var stack = ReactDebugCurrentFrame.getStackAddendum();
    // eslint-disable-next-line react-internal/warning-and-invariant-args

    for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      args[_key - 2] = arguments[_key];
    }

    warningWithoutStack$1.apply(undefined, [false, format + '%s'].concat(args, [stack]));
  };
}

var warning$1 = warning;

var hasOwnProperty = Object.prototype.hasOwnProperty;

var RESERVED_PROPS = {
  key: true,
  ref: true,
  __self: true,
  __source: true
};

var specialPropKeyWarningShown = void 0;
var specialPropRefWarningShown = void 0;

function hasValidRef(config) {
  {
    if (hasOwnProperty.call(config, 'ref')) {
      var getter = Object.getOwnPropertyDescriptor(config, 'ref').get;
      if (getter && getter.isReactWarning) {
        return false;
      }
    }
  }
  return config.ref !== undefined;
}

function hasValidKey(config) {
  {
    if (hasOwnProperty.call(config, 'key')) {
      var getter = Object.getOwnPropertyDescriptor(config, 'key').get;
      if (getter && getter.isReactWarning) {
        return false;
      }
    }
  }
  return config.key !== undefined;
}

function defineKeyPropWarningGetter(props, displayName) {
  var warnAboutAccessingKey = function () {
    if (!specialPropKeyWarningShown) {
      specialPropKeyWarningShown = true;
      warningWithoutStack$1(false, '%s: `key` is not a prop. Trying to access it will result ' + 'in `undefined` being returned. If you need to access the same ' + 'value within the child component, you should pass it as a different ' + 'prop. (https://fb.me/react-special-props)', displayName);
    }
  };
  warnAboutAccessingKey.isReactWarning = true;
  Object.defineProperty(props, 'key', {
    get: warnAboutAccessingKey,
    configurable: true
  });
}

function defineRefPropWarningGetter(props, displayName) {
  var warnAboutAccessingRef = function () {
    if (!specialPropRefWarningShown) {
      specialPropRefWarningShown = true;
      warningWithoutStack$1(false, '%s: `ref` is not a prop. Trying to access it will result ' + 'in `undefined` being returned. If you need to access the same ' + 'value within the child component, you should pass it as a different ' + 'prop. (https://fb.me/react-special-props)', displayName);
    }
  };
  warnAboutAccessingRef.isReactWarning = true;
  Object.defineProperty(props, 'ref', {
    get: warnAboutAccessingRef,
    configurable: true
  });
}

/**
 * Factory method to create a new React element. This no longer adheres to
 * the class pattern, so do not use new to call it. Also, no instanceof check
 * will work. Instead test $$typeof field against Symbol.for('react.element') to check
 * if something is a React Element.
 *
 * @param {*} type
 * @param {*} key
 * @param {string|object} ref
 * @param {*} self A *temporary* helper to detect places where `this` is
 * different from the `owner` when React.createElement is called, so that we
 * can warn. We want to get rid of owner and replace string `ref`s with arrow
 * functions, and as long as `this` and owner are the same, there will be no
 * change in behavior.
 * @param {*} source An annotation object (added by a transpiler or otherwise)
 * indicating filename, line number, and/or other information.
 * @param {*} owner
 * @param {*} props
 * @internal
 */
var ReactElement = function (type, key, ref, self, source, owner, props) {
  var element = {
    // This tag allows us to uniquely identify this as a React Element
    $$typeof: REACT_ELEMENT_TYPE,

    // Built-in properties that belong on the element
    type: type,
    key: key,
    ref: ref,
    props: props,

    // Record the component responsible for creating this element.
    _owner: owner
  };

  {
    // The validation flag is currently mutative. We put it on
    // an external backing store so that we can freeze the whole object.
    // This can be replaced with a WeakMap once they are implemented in
    // commonly used development environments.
    element._store = {};

    // To make comparing ReactElements easier for testing purposes, we make
    // the validation flag non-enumerable (where possible, which should
    // include every environment we run tests in), so the test framework
    // ignores it.
    Object.defineProperty(element._store, 'validated', {
      configurable: false,
      enumerable: false,
      writable: true,
      value: false
    });
    // self and source are DEV only properties.
    Object.defineProperty(element, '_self', {
      configurable: false,
      enumerable: false,
      writable: false,
      value: self
    });
    // Two elements created in two different places should be considered
    // equal for testing purposes and therefore we hide it from enumeration.
    Object.defineProperty(element, '_source', {
      configurable: false,
      enumerable: false,
      writable: false,
      value: source
    });
    if (Object.freeze) {
      Object.freeze(element.props);
      Object.freeze(element);
    }
  }

  return element;
};

/**
 * Create and return a new ReactElement of the given type.
 * See https://reactjs.org/docs/react-api.html#createelement
 */
function createElement(type, config, children) {
  var propName = void 0;

  // Reserved names are extracted
  var props = {};

  var key = null;
  var ref = null;
  var self = null;
  var source = null;

  if (config != null) {
    if (hasValidRef(config)) {
      ref = config.ref;
    }
    if (hasValidKey(config)) {
      key = '' + config.key;
    }

    self = config.__self === undefined ? null : config.__self;
    source = config.__source === undefined ? null : config.__source;
    // Remaining properties are added to a new props object
    for (propName in config) {
      if (hasOwnProperty.call(config, propName) && !RESERVED_PROPS.hasOwnProperty(propName)) {
        props[propName] = config[propName];
      }
    }
  }

  // Children can be more than one argument, and those are transferred onto
  // the newly allocated props object.
  var childrenLength = arguments.length - 2;
  if (childrenLength === 1) {
    props.children = children;
  } else if (childrenLength > 1) {
    var childArray = Array(childrenLength);
    for (var i = 0; i < childrenLength; i++) {
      childArray[i] = arguments[i + 2];
    }
    {
      if (Object.freeze) {
        Object.freeze(childArray);
      }
    }
    props.children = childArray;
  }

  // Resolve default props
  if (type && type.defaultProps) {
    var defaultProps = type.defaultProps;
    for (propName in defaultProps) {
      if (props[propName] === undefined) {
        props[propName] = defaultProps[propName];
      }
    }
  }
  {
    if (key || ref) {
      var displayName = typeof type === 'function' ? type.displayName || type.name || 'Unknown' : type;
      if (key) {
        defineKeyPropWarningGetter(props, displayName);
      }
      if (ref) {
        defineRefPropWarningGetter(props, displayName);
      }
    }
  }
  return ReactElement(type, key, ref, self, source, ReactCurrentOwner.current, props);
}

/**
 * Return a function that produces ReactElements of a given type.
 * See https://reactjs.org/docs/react-api.html#createfactory
 */


function cloneAndReplaceKey(oldElement, newKey) {
  var newElement = ReactElement(oldElement.type, newKey, oldElement.ref, oldElement._self, oldElement._source, oldElement._owner, oldElement.props);

  return newElement;
}

/**
 * Clone and return a new ReactElement using element as the starting point.
 * See https://reactjs.org/docs/react-api.html#cloneelement
 */
function cloneElement(element, config, children) {
  !!(element === null || element === undefined) ? invariant(false, 'React.cloneElement(...): The argument must be a React element, but you passed %s.', element) : void 0;

  var propName = void 0;

  // Original props are copied
  var props = _assign({}, element.props);

  // Reserved names are extracted
  var key = element.key;
  var ref = element.ref;
  // Self is preserved since the owner is preserved.
  var self = element._self;
  // Source is preserved since cloneElement is unlikely to be targeted by a
  // transpiler, and the original source is probably a better indicator of the
  // true owner.
  var source = element._source;

  // Owner will be preserved, unless ref is overridden
  var owner = element._owner;

  if (config != null) {
    if (hasValidRef(config)) {
      // Silently steal the ref from the parent.
      ref = config.ref;
      owner = ReactCurrentOwner.current;
    }
    if (hasValidKey(config)) {
      key = '' + config.key;
    }

    // Remaining properties override existing props
    var defaultProps = void 0;
    if (element.type && element.type.defaultProps) {
      defaultProps = element.type.defaultProps;
    }
    for (propName in config) {
      if (hasOwnProperty.call(config, propName) && !RESERVED_PROPS.hasOwnProperty(propName)) {
        if (config[propName] === undefined && defaultProps !== undefined) {
          // Resolve default props
          props[propName] = defaultProps[propName];
        } else {
          props[propName] = config[propName];
        }
      }
    }
  }

  // Children can be more than one argument, and those are transferred onto
  // the newly allocated props object.
  var childrenLength = arguments.length - 2;
  if (childrenLength === 1) {
    props.children = children;
  } else if (childrenLength > 1) {
    var childArray = Array(childrenLength);
    for (var i = 0; i < childrenLength; i++) {
      childArray[i] = arguments[i + 2];
    }
    props.children = childArray;
  }

  return ReactElement(element.type, key, ref, self, source, owner, props);
}

/**
 * Verifies the object is a ReactElement.
 * See https://reactjs.org/docs/react-api.html#isvalidelement
 * @param {?object} object
 * @return {boolean} True if `object` is a ReactElement.
 * @final
 */
function isValidElement(object) {
  return typeof object === 'object' && object !== null && object.$$typeof === REACT_ELEMENT_TYPE;
}

var SEPARATOR = '.';
var SUBSEPARATOR = ':';

/**
 * Escape and wrap key so it is safe to use as a reactid
 *
 * @param {string} key to be escaped.
 * @return {string} the escaped key.
 */
function escape(key) {
  var escapeRegex = /[=:]/g;
  var escaperLookup = {
    '=': '=0',
    ':': '=2'
  };
  var escapedString = ('' + key).replace(escapeRegex, function (match) {
    return escaperLookup[match];
  });

  return '$' + escapedString;
}

/**
 * TODO: Test that a single child and an array with one item have the same key
 * pattern.
 */

var didWarnAboutMaps = false;

var userProvidedKeyEscapeRegex = /\/+/g;
function escapeUserProvidedKey(text) {
  return ('' + text).replace(userProvidedKeyEscapeRegex, '$&/');
}

var POOL_SIZE = 10;
var traverseContextPool = [];
function getPooledTraverseContext(mapResult, keyPrefix, mapFunction, mapContext) {
  if (traverseContextPool.length) {
    var traverseContext = traverseContextPool.pop();
    traverseContext.result = mapResult;
    traverseContext.keyPrefix = keyPrefix;
    traverseContext.func = mapFunction;
    traverseContext.context = mapContext;
    traverseContext.count = 0;
    return traverseContext;
  } else {
    return {
      result: mapResult,
      keyPrefix: keyPrefix,
      func: mapFunction,
      context: mapContext,
      count: 0
    };
  }
}

function releaseTraverseContext(traverseContext) {
  traverseContext.result = null;
  traverseContext.keyPrefix = null;
  traverseContext.func = null;
  traverseContext.context = null;
  traverseContext.count = 0;
  if (traverseContextPool.length < POOL_SIZE) {
    traverseContextPool.push(traverseContext);
  }
}

/**
 * @param {?*} children Children tree container.
 * @param {!string} nameSoFar Name of the key path so far.
 * @param {!function} callback Callback to invoke with each child found.
 * @param {?*} traverseContext Used to pass information throughout the traversal
 * process.
 * @return {!number} The number of children in this subtree.
 */
function traverseAllChildrenImpl(children, nameSoFar, callback, traverseContext) {
  var type = typeof children;

  if (type === 'undefined' || type === 'boolean') {
    // All of the above are perceived as null.
    children = null;
  }

  var invokeCallback = false;

  if (children === null) {
    invokeCallback = true;
  } else {
    switch (type) {
      case 'string':
      case 'number':
        invokeCallback = true;
        break;
      case 'object':
        switch (children.$$typeof) {
          case REACT_ELEMENT_TYPE:
          case REACT_PORTAL_TYPE:
            invokeCallback = true;
        }
    }
  }

  if (invokeCallback) {
    callback(traverseContext, children,
    // If it's the only child, treat the name as if it was wrapped in an array
    // so that it's consistent if the number of children grows.
    nameSoFar === '' ? SEPARATOR + getComponentKey(children, 0) : nameSoFar);
    return 1;
  }

  var child = void 0;
  var nextName = void 0;
  var subtreeCount = 0; // Count of children found in the current subtree.
  var nextNamePrefix = nameSoFar === '' ? SEPARATOR : nameSoFar + SUBSEPARATOR;

  if (Array.isArray(children)) {
    for (var i = 0; i < children.length; i++) {
      child = children[i];
      nextName = nextNamePrefix + getComponentKey(child, i);
      subtreeCount += traverseAllChildrenImpl(child, nextName, callback, traverseContext);
    }
  } else {
    var iteratorFn = getIteratorFn(children);
    if (typeof iteratorFn === 'function') {
      {
        // Warn about using Maps as children
        if (iteratorFn === children.entries) {
          !didWarnAboutMaps ? warning$1(false, 'Using Maps as children is unsupported and will likely yield ' + 'unexpected results. Convert it to a sequence/iterable of keyed ' + 'ReactElements instead.') : void 0;
          didWarnAboutMaps = true;
        }
      }

      var iterator = iteratorFn.call(children);
      var step = void 0;
      var ii = 0;
      while (!(step = iterator.next()).done) {
        child = step.value;
        nextName = nextNamePrefix + getComponentKey(child, ii++);
        subtreeCount += traverseAllChildrenImpl(child, nextName, callback, traverseContext);
      }
    } else if (type === 'object') {
      var addendum = '';
      {
        addendum = ' If you meant to render a collection of children, use an array ' + 'instead.' + ReactDebugCurrentFrame.getStackAddendum();
      }
      var childrenString = '' + children;
      invariant(false, 'Objects are not valid as a React child (found: %s).%s', childrenString === '[object Object]' ? 'object with keys {' + Object.keys(children).join(', ') + '}' : childrenString, addendum);
    }
  }

  return subtreeCount;
}

/**
 * Traverses children that are typically specified as `props.children`, but
 * might also be specified through attributes:
 *
 * - `traverseAllChildren(this.props.children, ...)`
 * - `traverseAllChildren(this.props.leftPanelChildren, ...)`
 *
 * The `traverseContext` is an optional argument that is passed through the
 * entire traversal. It can be used to store accumulations or anything else that
 * the callback might find relevant.
 *
 * @param {?*} children Children tree object.
 * @param {!function} callback To invoke upon traversing each child.
 * @param {?*} traverseContext Context for traversal.
 * @return {!number} The number of children in this subtree.
 */
function traverseAllChildren(children, callback, traverseContext) {
  if (children == null) {
    return 0;
  }

  return traverseAllChildrenImpl(children, '', callback, traverseContext);
}

/**
 * Generate a key string that identifies a component within a set.
 *
 * @param {*} component A component that could contain a manual key.
 * @param {number} index Index that is used if a manual key is not provided.
 * @return {string}
 */
function getComponentKey(component, index) {
  // Do some typechecking here since we call this blindly. We want to ensure
  // that we don't block potential future ES APIs.
  if (typeof component === 'object' && component !== null && component.key != null) {
    // Explicit key
    return escape(component.key);
  }
  // Implicit key determined by the index in the set
  return index.toString(36);
}

function forEachSingleChild(bookKeeping, child, name) {
  var func = bookKeeping.func,
      context = bookKeeping.context;

  func.call(context, child, bookKeeping.count++);
}

/**
 * Iterates through children that are typically specified as `props.children`.
 *
 * See https://reactjs.org/docs/react-api.html#reactchildrenforeach
 *
 * The provided forEachFunc(child, index) will be called for each
 * leaf child.
 *
 * @param {?*} children Children tree container.
 * @param {function(*, int)} forEachFunc
 * @param {*} forEachContext Context for forEachContext.
 */
function forEachChildren(children, forEachFunc, forEachContext) {
  if (children == null) {
    return children;
  }
  var traverseContext = getPooledTraverseContext(null, null, forEachFunc, forEachContext);
  traverseAllChildren(children, forEachSingleChild, traverseContext);
  releaseTraverseContext(traverseContext);
}

function mapSingleChildIntoContext(bookKeeping, child, childKey) {
  var result = bookKeeping.result,
      keyPrefix = bookKeeping.keyPrefix,
      func = bookKeeping.func,
      context = bookKeeping.context;


  var mappedChild = func.call(context, child, bookKeeping.count++);
  if (Array.isArray(mappedChild)) {
    mapIntoWithKeyPrefixInternal(mappedChild, result, childKey, function (c) {
      return c;
    });
  } else if (mappedChild != null) {
    if (isValidElement(mappedChild)) {
      mappedChild = cloneAndReplaceKey(mappedChild,
      // Keep both the (mapped) and old keys if they differ, just as
      // traverseAllChildren used to do for objects as children
      keyPrefix + (mappedChild.key && (!child || child.key !== mappedChild.key) ? escapeUserProvidedKey(mappedChild.key) + '/' : '') + childKey);
    }
    result.push(mappedChild);
  }
}

function mapIntoWithKeyPrefixInternal(children, array, prefix, func, context) {
  var escapedPrefix = '';
  if (prefix != null) {
    escapedPrefix = escapeUserProvidedKey(prefix) + '/';
  }
  var traverseContext = getPooledTraverseContext(array, escapedPrefix, func, context);
  traverseAllChildren(children, mapSingleChildIntoContext, traverseContext);
  releaseTraverseContext(traverseContext);
}

/**
 * Maps children that are typically specified as `props.children`.
 *
 * See https://reactjs.org/docs/react-api.html#reactchildrenmap
 *
 * The provided mapFunction(child, key, index) will be called for each
 * leaf child.
 *
 * @param {?*} children Children tree container.
 * @param {function(*, int)} func The map function.
 * @param {*} context Context for mapFunction.
 * @return {object} Object containing the ordered map of results.
 */
function mapChildren(children, func, context) {
  if (children == null) {
    return children;
  }
  var result = [];
  mapIntoWithKeyPrefixInternal(children, result, null, func, context);
  return result;
}

/**
 * Count the number of children that are typically specified as
 * `props.children`.
 *
 * See https://reactjs.org/docs/react-api.html#reactchildrencount
 *
 * @param {?*} children Children tree container.
 * @return {number} The number of children.
 */
function countChildren(children) {
  return traverseAllChildren(children, function () {
    return null;
  }, null);
}

/**
 * Flatten a children object (typically specified as `props.children`) and
 * return an array with appropriately re-keyed children.
 *
 * See https://reactjs.org/docs/react-api.html#reactchildrentoarray
 */
function toArray(children) {
  var result = [];
  mapIntoWithKeyPrefixInternal(children, result, null, function (child) {
    return child;
  });
  return result;
}

/**
 * Returns the first child in a collection of children and verifies that there
 * is only one child in the collection.
 *
 * See https://reactjs.org/docs/react-api.html#reactchildrenonly
 *
 * The current implementation of this function assumes that a single child gets
 * passed without a wrapper, but the purpose of this helper function is to
 * abstract away the particular structure of children.
 *
 * @param {?object} children Child collection structure.
 * @return {ReactElement} The first and only `ReactElement` contained in the
 * structure.
 */
function onlyChild(children) {
  !isValidElement(children) ? invariant(false, 'React.Children.only expected to receive a single React element child.') : void 0;
  return children;
}

function createContext(defaultValue, calculateChangedBits) {
  if (calculateChangedBits === undefined) {
    calculateChangedBits = null;
  } else {
    {
      !(calculateChangedBits === null || typeof calculateChangedBits === 'function') ? warningWithoutStack$1(false, 'createContext: Expected the optional second argument to be a ' + 'function. Instead received: %s', calculateChangedBits) : void 0;
    }
  }

  var context = {
    $$typeof: REACT_CONTEXT_TYPE,
    _calculateChangedBits: calculateChangedBits,
    // As a workaround to support multiple concurrent renderers, we categorize
    // some renderers as primary and others as secondary. We only expect
    // there to be two concurrent renderers at most: React Native (primary) and
    // Fabric (secondary); React DOM (primary) and React ART (secondary).
    // Secondary renderers store their context values on separate fields.
    _currentValue: defaultValue,
    _currentValue2: defaultValue,
    // Used to track how many concurrent renderers this context currently
    // supports within in a single renderer. Such as parallel server rendering.
    _threadCount: 0,
    // These are circular
    Provider: null,
    Consumer: null
  };

  context.Provider = {
    $$typeof: REACT_PROVIDER_TYPE,
    _context: context
  };

  var hasWarnedAboutUsingNestedContextConsumers = false;
  var hasWarnedAboutUsingConsumerProvider = false;

  {
    // A separate object, but proxies back to the original context object for
    // backwards compatibility. It has a different $$typeof, so we can properly
    // warn for the incorrect usage of Context as a Consumer.
    var Consumer = {
      $$typeof: REACT_CONTEXT_TYPE,
      _context: context,
      _calculateChangedBits: context._calculateChangedBits
    };
    // $FlowFixMe: Flow complains about not setting a value, which is intentional here
    Object.defineProperties(Consumer, {
      Provider: {
        get: function () {
          if (!hasWarnedAboutUsingConsumerProvider) {
            hasWarnedAboutUsingConsumerProvider = true;
            warning$1(false, 'Rendering <Context.Consumer.Provider> is not supported and will be removed in ' + 'a future major release. Did you mean to render <Context.Provider> instead?');
          }
          return context.Provider;
        },
        set: function (_Provider) {
          context.Provider = _Provider;
        }
      },
      _currentValue: {
        get: function () {
          return context._currentValue;
        },
        set: function (_currentValue) {
          context._currentValue = _currentValue;
        }
      },
      _currentValue2: {
        get: function () {
          return context._currentValue2;
        },
        set: function (_currentValue2) {
          context._currentValue2 = _currentValue2;
        }
      },
      _threadCount: {
        get: function () {
          return context._threadCount;
        },
        set: function (_threadCount) {
          context._threadCount = _threadCount;
        }
      },
      Consumer: {
        get: function () {
          if (!hasWarnedAboutUsingNestedContextConsumers) {
            hasWarnedAboutUsingNestedContextConsumers = true;
            warning$1(false, 'Rendering <Context.Consumer.Consumer> is not supported and will be removed in ' + 'a future major release. Did you mean to render <Context.Consumer> instead?');
          }
          return context.Consumer;
        }
      }
    });
    // $FlowFixMe: Flow complains about missing properties because it doesn't understand defineProperty
    context.Consumer = Consumer;
  }

  {
    context._currentRenderer = null;
    context._currentRenderer2 = null;
  }

  return context;
}

function lazy(ctor) {
  var lazyType = {
    $$typeof: REACT_LAZY_TYPE,
    _ctor: ctor,
    // React uses these fields to store the result.
    _status: -1,
    _result: null
  };

  {
    // In production, this would just set it on the object.
    var defaultProps = void 0;
    var propTypes = void 0;
    Object.defineProperties(lazyType, {
      defaultProps: {
        configurable: true,
        get: function () {
          return defaultProps;
        },
        set: function (newDefaultProps) {
          warning$1(false, 'React.lazy(...): It is not supported to assign `defaultProps` to ' + 'a lazy component import. Either specify them where the component ' + 'is defined, or create a wrapping component around it.');
          defaultProps = newDefaultProps;
          // Match production behavior more closely:
          Object.defineProperty(lazyType, 'defaultProps', {
            enumerable: true
          });
        }
      },
      propTypes: {
        configurable: true,
        get: function () {
          return propTypes;
        },
        set: function (newPropTypes) {
          warning$1(false, 'React.lazy(...): It is not supported to assign `propTypes` to ' + 'a lazy component import. Either specify them where the component ' + 'is defined, or create a wrapping component around it.');
          propTypes = newPropTypes;
          // Match production behavior more closely:
          Object.defineProperty(lazyType, 'propTypes', {
            enumerable: true
          });
        }
      }
    });
  }

  return lazyType;
}

function forwardRef(render) {
  {
    if (render != null && render.$$typeof === REACT_MEMO_TYPE) {
      warningWithoutStack$1(false, 'forwardRef requires a render function but received a `memo` ' + 'component. Instead of forwardRef(memo(...)), use ' + 'memo(forwardRef(...)).');
    } else if (typeof render !== 'function') {
      warningWithoutStack$1(false, 'forwardRef requires a render function but was given %s.', render === null ? 'null' : typeof render);
    } else {
      !(
      // Do not warn for 0 arguments because it could be due to usage of the 'arguments' object
      render.length === 0 || render.length === 2) ? warningWithoutStack$1(false, 'forwardRef render functions accept exactly two parameters: props and ref. %s', render.length === 1 ? 'Did you forget to use the ref parameter?' : 'Any additional parameter will be undefined.') : void 0;
    }

    if (render != null) {
      !(render.defaultProps == null && render.propTypes == null) ? warningWithoutStack$1(false, 'forwardRef render functions do not support propTypes or defaultProps. ' + 'Did you accidentally pass a React component?') : void 0;
    }
  }

  return {
    $$typeof: REACT_FORWARD_REF_TYPE,
    render: render
  };
}

function isValidElementType(type) {
  return typeof type === 'string' || typeof type === 'function' ||
  // Note: its typeof might be other than 'symbol' or 'number' if it's a polyfill.
  type === REACT_FRAGMENT_TYPE || type === REACT_CONCURRENT_MODE_TYPE || type === REACT_PROFILER_TYPE || type === REACT_STRICT_MODE_TYPE || type === REACT_SUSPENSE_TYPE || typeof type === 'object' && type !== null && (type.$$typeof === REACT_LAZY_TYPE || type.$$typeof === REACT_MEMO_TYPE || type.$$typeof === REACT_PROVIDER_TYPE || type.$$typeof === REACT_CONTEXT_TYPE || type.$$typeof === REACT_FORWARD_REF_TYPE);
}

function memo(type, compare) {
  {
    if (!isValidElementType(type)) {
      warningWithoutStack$1(false, 'memo: The first argument must be a component. Instead ' + 'received: %s', type === null ? 'null' : typeof type);
    }
  }
  return {
    $$typeof: REACT_MEMO_TYPE,
    type: type,
    compare: compare === undefined ? null : compare
  };
}

function resolveDispatcher() {
  var dispatcher = ReactCurrentDispatcher.current;
  !(dispatcher !== null) ? invariant(false, 'Hooks can only be called inside the body of a function component. (https://fb.me/react-invalid-hook-call)') : void 0;
  return dispatcher;
}

function useContext(Context, unstable_observedBits) {
  var dispatcher = resolveDispatcher();
  {
    !(unstable_observedBits === undefined) ? warning$1(false, 'useContext() second argument is reserved for future ' + 'use in React. Passing it is not supported. ' + 'You passed: %s.%s', unstable_observedBits, typeof unstable_observedBits === 'number' && Array.isArray(arguments[2]) ? '\n\nDid you call array.map(useContext)? ' + 'Calling Hooks inside a loop is not supported. ' + 'Learn more at https://fb.me/rules-of-hooks' : '') : void 0;

    // TODO: add a more generic warning for invalid values.
    if (Context._context !== undefined) {
      var realContext = Context._context;
      // Don't deduplicate because this legitimately causes bugs
      // and nobody should be using this in existing code.
      if (realContext.Consumer === Context) {
        warning$1(false, 'Calling useContext(Context.Consumer) is not supported, may cause bugs, and will be ' + 'removed in a future major release. Did you mean to call useContext(Context) instead?');
      } else if (realContext.Provider === Context) {
        warning$1(false, 'Calling useContext(Context.Provider) is not supported. ' + 'Did you mean to call useContext(Context) instead?');
      }
    }
  }
  return dispatcher.useContext(Context, unstable_observedBits);
}

function useState(initialState) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useState(initialState);
}

function useReducer(reducer, initialArg, init) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useReducer(reducer, initialArg, init);
}

function useRef(initialValue) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useRef(initialValue);
}

function useEffect(create, inputs) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useEffect(create, inputs);
}

function useLayoutEffect(create, inputs) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useLayoutEffect(create, inputs);
}

function useCallback(callback, inputs) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useCallback(callback, inputs);
}

function useMemo(create, inputs) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useMemo(create, inputs);
}

function useImperativeHandle(ref, create, inputs) {
  var dispatcher = resolveDispatcher();
  return dispatcher.useImperativeHandle(ref, create, inputs);
}

function useDebugValue(value, formatterFn) {
  {
    var dispatcher = resolveDispatcher();
    return dispatcher.useDebugValue(value, formatterFn);
  }
}

/**
 * ReactElementValidator provides a wrapper around a element factory
 * which validates the props passed to the element. This is intended to be
 * used only in DEV and could be replaced by a static type checker for languages
 * that support it.
 */

var propTypesMisspellWarningShown = void 0;

{
  propTypesMisspellWarningShown = false;
}

function getDeclarationErrorAddendum() {
  if (ReactCurrentOwner.current) {
    var name = getComponentName(ReactCurrentOwner.current.type);
    if (name) {
      return '\n\nCheck the render method of `' + name + '`.';
    }
  }
  return '';
}

function getSourceInfoErrorAddendum(elementProps) {
  if (elementProps !== null && elementProps !== undefined && elementProps.__source !== undefined) {
    var source = elementProps.__source;
    var fileName = source.fileName.replace(/^.*[\\\/]/, '');
    var lineNumber = source.lineNumber;
    return '\n\nCheck your code at ' + fileName + ':' + lineNumber + '.';
  }
  return '';
}

/**
 * Warn if there's no key explicitly set on dynamic arrays of children or
 * object keys are not valid. This allows us to keep track of children between
 * updates.
 */
var ownerHasKeyUseWarning = {};

function getCurrentComponentErrorInfo(parentType) {
  var info = getDeclarationErrorAddendum();

  if (!info) {
    var parentName = typeof parentType === 'string' ? parentType : parentType.displayName || parentType.name;
    if (parentName) {
      info = '\n\nCheck the top-level render call using <' + parentName + '>.';
    }
  }
  return info;
}

/**
 * Warn if the element doesn't have an explicit key assigned to it.
 * This element is in an array. The array could grow and shrink or be
 * reordered. All children that haven't already been validated are required to
 * have a "key" property assigned to it. Error statuses are cached so a warning
 * will only be shown once.
 *
 * @internal
 * @param {ReactElement} element Element that requires a key.
 * @param {*} parentType element's parent's type.
 */
function validateExplicitKey(element, parentType) {
  if (!element._store || element._store.validated || element.key != null) {
    return;
  }
  element._store.validated = true;

  var currentComponentErrorInfo = getCurrentComponentErrorInfo(parentType);
  if (ownerHasKeyUseWarning[currentComponentErrorInfo]) {
    return;
  }
  ownerHasKeyUseWarning[currentComponentErrorInfo] = true;

  // Usually the current owner is the offender, but if it accepts children as a
  // property, it may be the creator of the child that's responsible for
  // assigning it a key.
  var childOwner = '';
  if (element && element._owner && element._owner !== ReactCurrentOwner.current) {
    // Give the component that originally created this child.
    childOwner = ' It was passed a child from ' + getComponentName(element._owner.type) + '.';
  }

  setCurrentlyValidatingElement(element);
  {
    warning$1(false, 'Each child in a list should have a unique "key" prop.' + '%s%s See https://fb.me/react-warning-keys for more information.', currentComponentErrorInfo, childOwner);
  }
  setCurrentlyValidatingElement(null);
}

/**
 * Ensure that every element either is passed in a static location, in an
 * array with an explicit keys property defined, or in an object literal
 * with valid key property.
 *
 * @internal
 * @param {ReactNode} node Statically passed child of any type.
 * @param {*} parentType node's parent's type.
 */
function validateChildKeys(node, parentType) {
  if (typeof node !== 'object') {
    return;
  }
  if (Array.isArray(node)) {
    for (var i = 0; i < node.length; i++) {
      var child = node[i];
      if (isValidElement(child)) {
        validateExplicitKey(child, parentType);
      }
    }
  } else if (isValidElement(node)) {
    // This element was passed in a valid location.
    if (node._store) {
      node._store.validated = true;
    }
  } else if (node) {
    var iteratorFn = getIteratorFn(node);
    if (typeof iteratorFn === 'function') {
      // Entry iterators used to provide implicit keys,
      // but now we print a separate warning for them later.
      if (iteratorFn !== node.entries) {
        var iterator = iteratorFn.call(node);
        var step = void 0;
        while (!(step = iterator.next()).done) {
          if (isValidElement(step.value)) {
            validateExplicitKey(step.value, parentType);
          }
        }
      }
    }
  }
}

/**
 * Given an element, validate that its props follow the propTypes definition,
 * provided by the type.
 *
 * @param {ReactElement} element
 */
function validatePropTypes(element) {
  var type = element.type;
  if (type === null || type === undefined || typeof type === 'string') {
    return;
  }
  var name = getComponentName(type);
  var propTypes = void 0;
  if (typeof type === 'function') {
    propTypes = type.propTypes;
  } else if (typeof type === 'object' && (type.$$typeof === REACT_FORWARD_REF_TYPE ||
  // Note: Memo only checks outer props here.
  // Inner props are checked in the reconciler.
  type.$$typeof === REACT_MEMO_TYPE)) {
    propTypes = type.propTypes;
  } else {
    return;
  }
  if (propTypes) {
    setCurrentlyValidatingElement(element);
    checkPropTypes(propTypes, element.props, 'prop', name, ReactDebugCurrentFrame.getStackAddendum);
    setCurrentlyValidatingElement(null);
  } else if (type.PropTypes !== undefined && !propTypesMisspellWarningShown) {
    propTypesMisspellWarningShown = true;
    warningWithoutStack$1(false, 'Component %s declared `PropTypes` instead of `propTypes`. Did you misspell the property assignment?', name || 'Unknown');
  }
  if (typeof type.getDefaultProps === 'function') {
    !type.getDefaultProps.isReactClassApproved ? warningWithoutStack$1(false, 'getDefaultProps is only used on classic React.createClass ' + 'definitions. Use a static property named `defaultProps` instead.') : void 0;
  }
}

/**
 * Given a fragment, validate that it can only be provided with fragment props
 * @param {ReactElement} fragment
 */
function validateFragmentProps(fragment) {
  setCurrentlyValidatingElement(fragment);

  var keys = Object.keys(fragment.props);
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    if (key !== 'children' && key !== 'key') {
      warning$1(false, 'Invalid prop `%s` supplied to `React.Fragment`. ' + 'React.Fragment can only have `key` and `children` props.', key);
      break;
    }
  }

  if (fragment.ref !== null) {
    warning$1(false, 'Invalid attribute `ref` supplied to `React.Fragment`.');
  }

  setCurrentlyValidatingElement(null);
}

function createElementWithValidation(type, props, children) {
  var validType = isValidElementType(type);

  // We warn in this case but don't throw. We expect the element creation to
  // succeed and there will likely be errors in render.
  if (!validType) {
    var info = '';
    if (type === undefined || typeof type === 'object' && type !== null && Object.keys(type).length === 0) {
      info += ' You likely forgot to export your component from the file ' + "it's defined in, or you might have mixed up default and named imports.";
    }

    var sourceInfo = getSourceInfoErrorAddendum(props);
    if (sourceInfo) {
      info += sourceInfo;
    } else {
      info += getDeclarationErrorAddendum();
    }

    var typeString = void 0;
    if (type === null) {
      typeString = 'null';
    } else if (Array.isArray(type)) {
      typeString = 'array';
    } else if (type !== undefined && type.$$typeof === REACT_ELEMENT_TYPE) {
      typeString = '<' + (getComponentName(type.type) || 'Unknown') + ' />';
      info = ' Did you accidentally export a JSX literal instead of a component?';
    } else {
      typeString = typeof type;
    }

    warning$1(false, 'React.createElement: type is invalid -- expected a string (for ' + 'built-in components) or a class/function (for composite ' + 'components) but got: %s.%s', typeString, info);
  }

  var element = createElement.apply(this, arguments);

  // The result can be nullish if a mock or a custom function is used.
  // TODO: Drop this when these are no longer allowed as the type argument.
  if (element == null) {
    return element;
  }

  // Skip key warning if the type isn't valid since our key validation logic
  // doesn't expect a non-string/function type and can throw confusing errors.
  // We don't want exception behavior to differ between dev and prod.
  // (Rendering will throw with a helpful message and as soon as the type is
  // fixed, the key warnings will appear.)
  if (validType) {
    for (var i = 2; i < arguments.length; i++) {
      validateChildKeys(arguments[i], type);
    }
  }

  if (type === REACT_FRAGMENT_TYPE) {
    validateFragmentProps(element);
  } else {
    validatePropTypes(element);
  }

  return element;
}

function createFactoryWithValidation(type) {
  var validatedFactory = createElementWithValidation.bind(null, type);
  validatedFactory.type = type;
  // Legacy hook: remove it
  {
    Object.defineProperty(validatedFactory, 'type', {
      enumerable: false,
      get: function () {
        lowPriorityWarning$1(false, 'Factory.type is deprecated. Access the class directly ' + 'before passing it to createFactory.');
        Object.defineProperty(this, 'type', {
          value: type
        });
        return type;
      }
    });
  }

  return validatedFactory;
}

function cloneElementWithValidation(element, props, children) {
  var newElement = cloneElement.apply(this, arguments);
  for (var i = 2; i < arguments.length; i++) {
    validateChildKeys(arguments[i], newElement.type);
  }
  validatePropTypes(newElement);
  return newElement;
}

// Helps identify side effects in begin-phase lifecycle hooks and setState reducers:


// In some cases, StrictMode should also double-render lifecycles.
// This can be confusing for tests though,
// And it can be bad for performance in production.
// This feature flag can be used to control the behavior:


// To preserve the "Pause on caught exceptions" behavior of the debugger, we
// replay the begin phase of a failed component inside invokeGuardedCallback.


// Warn about deprecated, async-unsafe lifecycles; relates to RFC #6:


// Gather advanced timing metrics for Profiler subtrees.


// Trace which interactions trigger each commit.


// Only used in www builds.
 // TODO: true? Here it might just be false.

// Only used in www builds.


// Only used in www builds.


// React Fire: prevent the value and checked attributes from syncing
// with their related DOM properties


// These APIs will no longer be "unstable" in the upcoming 16.7 release,
// Control this behavior with a flag to support 16.6 minor releases in the meanwhile.
var enableStableConcurrentModeAPIs = false;

var React = {
  Children: {
    map: mapChildren,
    forEach: forEachChildren,
    count: countChildren,
    toArray: toArray,
    only: onlyChild
  },

  createRef: createRef,
  Component: Component,
  PureComponent: PureComponent,

  createContext: createContext,
  forwardRef: forwardRef,
  lazy: lazy,
  memo: memo,

  useCallback: useCallback,
  useContext: useContext,
  useEffect: useEffect,
  useImperativeHandle: useImperativeHandle,
  useDebugValue: useDebugValue,
  useLayoutEffect: useLayoutEffect,
  useMemo: useMemo,
  useReducer: useReducer,
  useRef: useRef,
  useState: useState,

  Fragment: REACT_FRAGMENT_TYPE,
  StrictMode: REACT_STRICT_MODE_TYPE,
  Suspense: REACT_SUSPENSE_TYPE,

  createElement: createElementWithValidation,
  cloneElement: cloneElementWithValidation,
  createFactory: createFactoryWithValidation,
  isValidElement: isValidElement,

  version: ReactVersion,

  unstable_ConcurrentMode: REACT_CONCURRENT_MODE_TYPE,
  unstable_Profiler: REACT_PROFILER_TYPE,

  __SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED: ReactSharedInternals
};

// Note: some APIs are added with feature flags.
// Make sure that stable builds for open source
// don't modify the React object to avoid deopts.
// Also let's not expose their names in stable builds.

if (enableStableConcurrentModeAPIs) {
  React.ConcurrentMode = REACT_CONCURRENT_MODE_TYPE;
  React.Profiler = REACT_PROFILER_TYPE;
  React.unstable_ConcurrentMode = undefined;
  React.unstable_Profiler = undefined;
}



var React$2 = Object.freeze({
	default: React
});

var React$3 = ( React$2 && React ) || React$2;

// TODO: decide on the top-level export form.
// This is hacky but makes it work with both Rollup and Jest.
var react = React$3.default || React$3;

module.exports = react;
  })();
}


/***/ }),

/***/ "./node_modules/react/index.js":
/*!*************************************!*\
  !*** ./node_modules/react/index.js ***!
  \*************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


if (false) {} else {
  module.exports = __webpack_require__(/*! ./cjs/react.development.js */ "./node_modules/react/cjs/react.development.js");
}


/***/ })

/******/ });
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAiLCJ3ZWJwYWNrOi8vLy4vanNfc3JjL3JlYWN0X2RvbV9zZXJ2ZXIuanMiLCJ3ZWJwYWNrOi8vLy4vbm9kZV9tb2R1bGVzL29iamVjdC1hc3NpZ24vaW5kZXguanMiLCJ3ZWJwYWNrOi8vLy4vbm9kZV9tb2R1bGVzL3Byb3AtdHlwZXMvY2hlY2tQcm9wVHlwZXMuanMiLCJ3ZWJwYWNrOi8vLy4vbm9kZV9tb2R1bGVzL3Byb3AtdHlwZXMvbGliL1JlYWN0UHJvcFR5cGVzU2VjcmV0LmpzIiwid2VicGFjazovLy8uL25vZGVfbW9kdWxlcy9yZWFjdC1kb20vY2pzL3JlYWN0LWRvbS1zZXJ2ZXIuYnJvd3Nlci5kZXZlbG9wbWVudC5qcyIsIndlYnBhY2s6Ly8vLi9ub2RlX21vZHVsZXMvcmVhY3QtZG9tL3NlcnZlci5icm93c2VyLmpzIiwid2VicGFjazovLy8uL25vZGVfbW9kdWxlcy9yZWFjdC9janMvcmVhY3QuZGV2ZWxvcG1lbnQuanMiLCJ3ZWJwYWNrOi8vLy4vbm9kZV9tb2R1bGVzL3JlYWN0L2luZGV4LmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLGtEQUEwQyxnQ0FBZ0M7QUFDMUU7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxnRUFBd0Qsa0JBQWtCO0FBQzFFO0FBQ0EseURBQWlELGNBQWM7QUFDL0Q7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGlEQUF5QyxpQ0FBaUM7QUFDMUUsd0hBQWdILG1CQUFtQixFQUFFO0FBQ3JJO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsbUNBQTJCLDBCQUEwQixFQUFFO0FBQ3ZELHlDQUFpQyxlQUFlO0FBQ2hEO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDhEQUFzRCwrREFBK0Q7O0FBRXJIO0FBQ0E7OztBQUdBO0FBQ0E7Ozs7Ozs7Ozs7OztBQ2xGQSx1QkFBdUIsbUJBQU8sQ0FBQyxvRUFBa0I7O0FBRWpEOzs7Ozs7Ozs7Ozs7O0FDRkE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFYTtBQUNiO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBLGdDQUFnQztBQUNoQztBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsaUJBQWlCLFFBQVE7QUFDekI7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNILGtDQUFrQztBQUNsQztBQUNBO0FBQ0E7O0FBRUE7QUFDQSxFQUFFO0FBQ0Y7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUEsZ0JBQWdCLHNCQUFzQjtBQUN0Qzs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxrQkFBa0Isb0JBQW9CO0FBQ3RDO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOzs7Ozs7Ozs7Ozs7O0FDekZBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFYTs7QUFFYjs7QUFFQSxJQUFJLElBQXFDO0FBQ3pDLDZCQUE2QixtQkFBTyxDQUFDLHlGQUE0QjtBQUNqRTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLE9BQU87QUFDbEIsV0FBVyxPQUFPO0FBQ2xCLFdBQVcsT0FBTztBQUNsQixXQUFXLE9BQU87QUFDbEIsV0FBVyxVQUFVO0FBQ3JCO0FBQ0E7QUFDQTtBQUNBLE1BQU0sSUFBcUM7QUFDM0M7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLDRHQUE0RztBQUM1RztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLDJEQUEyRDtBQUMzRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE1BQU0sSUFBcUM7QUFDM0M7QUFDQTtBQUNBOztBQUVBOzs7Ozs7Ozs7Ozs7O0FDckdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFYTs7QUFFYjs7QUFFQTs7Ozs7Ozs7Ozs7OztBQ1hBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRWE7Ozs7QUFJYixJQUFJLElBQXFDO0FBQ3pDO0FBQ0E7O0FBRUEsY0FBYyxtQkFBTyxDQUFDLDREQUFlO0FBQ3JDLFlBQVksbUJBQU8sQ0FBQyw0Q0FBTztBQUMzQixxQkFBcUIsbUJBQU8sQ0FBQyw4RUFBMkI7O0FBRXhEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EscURBQXFEO0FBQ3JELEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBOztBQUVBLDBCQUEwQjtBQUMxQjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBLHNGQUFzRixhQUFhO0FBQ25HO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBLEtBQUs7QUFDTDtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0Esc0ZBQXNGLGFBQWE7QUFDbkc7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsNEZBQTRGLGVBQWU7QUFDM0c7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLHNGQUFzRixhQUFhO0FBQ25HO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7OztBQUdBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOzs7QUFHQSxrREFBa0Q7QUFDbEQ7O0FBRUE7OztBQUdBOzs7QUFHQTtBQUNBLHlDQUF5Qzs7QUFFekM7OztBQUdBOzs7QUFHQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0Esd0NBQXdDLGVBQWU7QUFDdkQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsZUFBZSxRQUFRO0FBQ3ZCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx3QkFBd0Isa0JBQWtCO0FBQzFDO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQztBQUNEOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQztBQUNEOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxDQUFDO0FBQ0Q7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQztBQUNEOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLENBQUM7QUFDRDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQzs7QUFFRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsQ0FBQzs7QUFFRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxZQUFZLE9BQU87QUFDbkIsWUFBWTtBQUNaO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSwyQkFBMkIsb0JBQW9CO0FBQy9DO0FBQ0E7QUFDQTtBQUNBLHdCQUF3QjtBQUN4QjtBQUNBO0FBQ0E7QUFDQSx1QkFBdUI7QUFDdkI7QUFDQTtBQUNBO0FBQ0Esd0JBQXdCLEVBQUUsOEJBQThCO0FBQ3hEO0FBQ0E7QUFDQTtBQUNBLHNCQUFzQjtBQUN0QjtBQUNBO0FBQ0E7QUFDQSxzQkFBc0I7QUFDdEI7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVyxFQUFFO0FBQ2IsWUFBWSxPQUFPO0FBQ25CO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsRUFBRTtBQUNiLFlBQVksT0FBTztBQUNuQjtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVyxPQUFPO0FBQ2xCLFlBQVksT0FBTztBQUNuQjs7O0FBR0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsT0FBTztBQUNsQixXQUFXLEVBQUU7QUFDYixZQUFZLFFBQVE7QUFDcEI7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLE9BQU87QUFDbEIsV0FBVyxFQUFFO0FBQ2IsWUFBWSxPQUFPO0FBQ25CO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxpQkFBaUIsNENBQTRDO0FBQzdEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7O0FBRVQ7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsZUFBZTtBQUNmO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsQ0FBQzs7QUFFRDtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSw0S0FBNEssWUFBWTtBQUN4TDtBQUNBO0FBQ0E7QUFDQTtBQUNBLHVMQUF1TCwrQkFBK0I7QUFDdE47O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLFdBQVcsT0FBTztBQUNsQixXQUFXLE9BQU87QUFDbEIsWUFBWSxPQUFPO0FBQ25CO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNILENBQUM7O0FBRUQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsT0FBTztBQUNsQixXQUFXLEVBQUU7QUFDYixZQUFZLE9BQU87QUFDbkI7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLHdCQUF3QjtBQUN4Qjs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLDRDQUE0Qzs7QUFFNUM7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLDZDQUE2QztBQUM3QztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLDZDQUE2QztBQUM3QztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRzs7QUFFSDtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUOztBQUVBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsVUFBVTtBQUNWO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxNQUFNO0FBQ2pCO0FBQ0EsU0FBUztBQUNUOzs7QUFHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLE9BQU87QUFDbEI7QUFDQSxTQUFTO0FBQ1Q7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxpS0FBaUssaUJBQWlCO0FBQ2xMLE9BQU87QUFDUCxpS0FBaUssaUJBQWlCLHdEQUF3RCxtQkFBbUIsZ0JBQWdCLDhCQUE4QjtBQUMzUztBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLCtHQUErRyxHQUFHO0FBQ2xIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxpREFBaUQsMENBQTBDLDBEQUEwRCxFQUFFOztBQUV2Sjs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLG1DQUFtQyxRQUFRO0FBQzNDO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxrREFBa0QsU0FBUztBQUMzRDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0Esb0RBQW9EO0FBQ3BEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLG9CQUFvQjtBQUNwQjtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0EsaUNBQWlDO0FBQ2pDO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQSwwQ0FBMEMscUJBQXFCO0FBQy9EO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxzQ0FBc0M7QUFDdEMsZUFBZTtBQUNmO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQSwwQkFBMEI7QUFDMUI7QUFDQTtBQUNBLFVBQVU7QUFDVjs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXO0FBQ1g7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFhO0FBQ2I7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDs7QUFFQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWE7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsbUZBQW1GLG9CQUFvQjtBQUN2RztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsaUJBQWlCO0FBQ2pCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUCxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSx3QkFBd0I7QUFDeEI7QUFDQTtBQUNBLE9BQU87QUFDUCxLQUFLO0FBQ0w7QUFDQTs7QUFFQSx1QkFBdUIsMkJBQTJCO0FBQ2xEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx3QkFBd0I7QUFDeEI7QUFDQSxPQUFPO0FBQ1AsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSx5QkFBeUIsd0JBQXdCO0FBQ2pEO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLENBQUM7O0FBRUQ7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLENBQUM7O0FBRUQ7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsR0FBRztBQUNIOzs7Ozs7Ozs7Ozs7O0FDL2pIYTs7QUFFYixJQUFJLEtBQXFDLEVBQUUsRUFFMUM7QUFDRCxtQkFBbUIsbUJBQU8sQ0FBQywySEFBK0M7QUFDMUU7Ozs7Ozs7Ozs7Ozs7QUNOQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVhOzs7O0FBSWIsSUFBSSxJQUFxQztBQUN6QztBQUNBOztBQUVBLGNBQWMsbUJBQU8sQ0FBQyw0REFBZTtBQUNyQyxxQkFBcUIsbUJBQU8sQ0FBQyw4RUFBMkI7O0FBRXhEOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxxREFBcUQ7QUFDckQsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7O0FBRUEsMEJBQTBCO0FBQzFCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQSxzRkFBc0YsYUFBYTtBQUNuRztBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSw0RkFBNEYsZUFBZTtBQUMzRztBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0Esc0ZBQXNGLGFBQWE7QUFDbkc7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLHFPQUFxTztBQUNyTztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYSxXQUFXO0FBQ3hCLGNBQWMsUUFBUTtBQUN0QjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRzs7QUFFSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWEsV0FBVztBQUN4QixhQUFhLFVBQVU7QUFDdkIsYUFBYSxRQUFRO0FBQ3JCO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRzs7QUFFSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQWEsV0FBVztBQUN4QixhQUFhLE9BQU87QUFDcEIsYUFBYSxVQUFVO0FBQ3ZCLGFBQWEsUUFBUTtBQUNyQjtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7O0FBRUg7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsYUFBYSxXQUFXO0FBQ3hCLGFBQWEsT0FBTztBQUNwQixhQUFhLFVBQVU7QUFDdkIsYUFBYSxRQUFRO0FBQ3JCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLGdCQUFnQjtBQUMzQjtBQUNBLFdBQVcsVUFBVTtBQUNyQjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsVUFBVTtBQUNyQjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFlBQVk7QUFDWjtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsWUFBWTtBQUNaO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBOztBQUVBOzs7QUFHQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBLHNGQUFzRixhQUFhO0FBQ25HO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxFQUFFO0FBQ2IsV0FBVyxFQUFFO0FBQ2IsV0FBVyxjQUFjO0FBQ3pCLFdBQVcsRUFBRTtBQUNiO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxFQUFFO0FBQ2I7QUFDQSxXQUFXLEVBQUU7QUFDYixXQUFXLEVBQUU7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEtBQUs7QUFDTDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0EsbUJBQW1CLG9CQUFvQjtBQUN2QztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQSx3QkFBd0I7O0FBRXhCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQSxtQkFBbUIsb0JBQW9CO0FBQ3ZDO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVyxRQUFRO0FBQ25CLFlBQVksUUFBUTtBQUNwQjtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVyxPQUFPO0FBQ2xCLFlBQVksT0FBTztBQUNuQjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxHQUFHOztBQUVIO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQSxXQUFXLEdBQUc7QUFDZCxXQUFXLFFBQVE7QUFDbkIsV0FBVyxVQUFVO0FBQ3JCLFdBQVcsR0FBRztBQUNkO0FBQ0EsWUFBWSxRQUFRO0FBQ3BCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQSx1QkFBdUI7QUFDdkI7O0FBRUE7QUFDQSxtQkFBbUIscUJBQXFCO0FBQ3hDO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSwwSUFBMEkseUNBQXlDO0FBQ25MO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxHQUFHO0FBQ2QsV0FBVyxVQUFVO0FBQ3JCLFdBQVcsR0FBRztBQUNkLFlBQVksUUFBUTtBQUNwQjtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsV0FBVyxFQUFFO0FBQ2IsV0FBVyxPQUFPO0FBQ2xCLFlBQVk7QUFDWjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLEdBQUc7QUFDZCxXQUFXLGlCQUFpQjtBQUM1QixXQUFXLEVBQUU7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0wsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsR0FBRztBQUNkLFdBQVcsaUJBQWlCO0FBQzVCLFdBQVcsRUFBRTtBQUNiLFlBQVksT0FBTztBQUNuQjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxHQUFHO0FBQ2QsWUFBWSxPQUFPO0FBQ25CO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLFFBQVE7QUFDbkIsWUFBWSxhQUFhO0FBQ3pCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxHQUFHO0FBQ0g7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsMEJBQTBCO0FBQzFCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0E7QUFDQSxPQUFPO0FBQ1A7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBLE9BQU87QUFDUDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxTQUFTO0FBQ1Q7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVztBQUNYO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsU0FBUztBQUNUO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVc7QUFDWDtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQSxLQUFLO0FBQ0w7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsT0FBTztBQUNQO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFdBQVcsYUFBYTtBQUN4QixXQUFXLEVBQUU7QUFDYjtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxXQUFXLFVBQVU7QUFDckIsV0FBVyxFQUFFO0FBQ2I7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsbUJBQW1CLGlCQUFpQjtBQUNwQztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsV0FBVyxhQUFhO0FBQ3hCO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsR0FBRztBQUNIO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0EsV0FBVyxhQUFhO0FBQ3hCO0FBQ0E7QUFDQTs7QUFFQTtBQUNBLGlCQUFpQixpQkFBaUI7QUFDbEM7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0EsS0FBSztBQUNMO0FBQ0EsS0FBSztBQUNMO0FBQ0E7QUFDQSxLQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBOztBQUVBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsbUJBQW1CLHNCQUFzQjtBQUN6QztBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLEdBQUc7QUFDSDtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLFNBQVM7QUFDVDtBQUNBO0FBQ0EsS0FBSztBQUNMOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLGlCQUFpQixzQkFBc0I7QUFDdkM7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7O0FBR0E7QUFDQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7OztBQUdBLGtEQUFrRDs7O0FBR2xEOzs7QUFHQTs7O0FBR0E7QUFDQTs7QUFFQTs7O0FBR0E7OztBQUdBO0FBQ0E7OztBQUdBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLEdBQUc7O0FBRUg7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7O0FBSUE7QUFDQTtBQUNBLENBQUM7O0FBRUQ7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0EsR0FBRztBQUNIOzs7Ozs7Ozs7Ozs7O0FDNTJEYTs7QUFFYixJQUFJLEtBQXFDLEVBQUUsRUFFMUM7QUFDRCxtQkFBbUIsbUJBQU8sQ0FBQyxpRkFBNEI7QUFDdkQiLCJmaWxlIjoicmVhY3RfZG9tX3NlcnZlci5qcyIsInNvdXJjZXNDb250ZW50IjpbIiBcdC8vIFRoZSBtb2R1bGUgY2FjaGVcbiBcdHZhciBpbnN0YWxsZWRNb2R1bGVzID0ge307XG5cbiBcdC8vIFRoZSByZXF1aXJlIGZ1bmN0aW9uXG4gXHRmdW5jdGlvbiBfX3dlYnBhY2tfcmVxdWlyZV9fKG1vZHVsZUlkKSB7XG5cbiBcdFx0Ly8gQ2hlY2sgaWYgbW9kdWxlIGlzIGluIGNhY2hlXG4gXHRcdGlmKGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdKSB7XG4gXHRcdFx0cmV0dXJuIGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdLmV4cG9ydHM7XG4gXHRcdH1cbiBcdFx0Ly8gQ3JlYXRlIGEgbmV3IG1vZHVsZSAoYW5kIHB1dCBpdCBpbnRvIHRoZSBjYWNoZSlcbiBcdFx0dmFyIG1vZHVsZSA9IGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdID0ge1xuIFx0XHRcdGk6IG1vZHVsZUlkLFxuIFx0XHRcdGw6IGZhbHNlLFxuIFx0XHRcdGV4cG9ydHM6IHt9XG4gXHRcdH07XG5cbiBcdFx0Ly8gRXhlY3V0ZSB0aGUgbW9kdWxlIGZ1bmN0aW9uXG4gXHRcdG1vZHVsZXNbbW9kdWxlSWRdLmNhbGwobW9kdWxlLmV4cG9ydHMsIG1vZHVsZSwgbW9kdWxlLmV4cG9ydHMsIF9fd2VicGFja19yZXF1aXJlX18pO1xuXG4gXHRcdC8vIEZsYWcgdGhlIG1vZHVsZSBhcyBsb2FkZWRcbiBcdFx0bW9kdWxlLmwgPSB0cnVlO1xuXG4gXHRcdC8vIFJldHVybiB0aGUgZXhwb3J0cyBvZiB0aGUgbW9kdWxlXG4gXHRcdHJldHVybiBtb2R1bGUuZXhwb3J0cztcbiBcdH1cblxuXG4gXHQvLyBleHBvc2UgdGhlIG1vZHVsZXMgb2JqZWN0IChfX3dlYnBhY2tfbW9kdWxlc19fKVxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5tID0gbW9kdWxlcztcblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGUgY2FjaGVcbiBcdF9fd2VicGFja19yZXF1aXJlX18uYyA9IGluc3RhbGxlZE1vZHVsZXM7XG5cbiBcdC8vIGRlZmluZSBnZXR0ZXIgZnVuY3Rpb24gZm9yIGhhcm1vbnkgZXhwb3J0c1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5kID0gZnVuY3Rpb24oZXhwb3J0cywgbmFtZSwgZ2V0dGVyKSB7XG4gXHRcdGlmKCFfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZXhwb3J0cywgbmFtZSkpIHtcbiBcdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgbmFtZSwgeyBlbnVtZXJhYmxlOiB0cnVlLCBnZXQ6IGdldHRlciB9KTtcbiBcdFx0fVxuIFx0fTtcblxuIFx0Ly8gZGVmaW5lIF9fZXNNb2R1bGUgb24gZXhwb3J0c1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5yID0gZnVuY3Rpb24oZXhwb3J0cykge1xuIFx0XHRpZih0eXBlb2YgU3ltYm9sICE9PSAndW5kZWZpbmVkJyAmJiBTeW1ib2wudG9TdHJpbmdUYWcpIHtcbiBcdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgU3ltYm9sLnRvU3RyaW5nVGFnLCB7IHZhbHVlOiAnTW9kdWxlJyB9KTtcbiBcdFx0fVxuIFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgJ19fZXNNb2R1bGUnLCB7IHZhbHVlOiB0cnVlIH0pO1xuIFx0fTtcblxuIFx0Ly8gY3JlYXRlIGEgZmFrZSBuYW1lc3BhY2Ugb2JqZWN0XG4gXHQvLyBtb2RlICYgMTogdmFsdWUgaXMgYSBtb2R1bGUgaWQsIHJlcXVpcmUgaXRcbiBcdC8vIG1vZGUgJiAyOiBtZXJnZSBhbGwgcHJvcGVydGllcyBvZiB2YWx1ZSBpbnRvIHRoZSBuc1xuIFx0Ly8gbW9kZSAmIDQ6IHJldHVybiB2YWx1ZSB3aGVuIGFscmVhZHkgbnMgb2JqZWN0XG4gXHQvLyBtb2RlICYgOHwxOiBiZWhhdmUgbGlrZSByZXF1aXJlXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLnQgPSBmdW5jdGlvbih2YWx1ZSwgbW9kZSkge1xuIFx0XHRpZihtb2RlICYgMSkgdmFsdWUgPSBfX3dlYnBhY2tfcmVxdWlyZV9fKHZhbHVlKTtcbiBcdFx0aWYobW9kZSAmIDgpIHJldHVybiB2YWx1ZTtcbiBcdFx0aWYoKG1vZGUgJiA0KSAmJiB0eXBlb2YgdmFsdWUgPT09ICdvYmplY3QnICYmIHZhbHVlICYmIHZhbHVlLl9fZXNNb2R1bGUpIHJldHVybiB2YWx1ZTtcbiBcdFx0dmFyIG5zID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiBcdFx0X193ZWJwYWNrX3JlcXVpcmVfXy5yKG5zKTtcbiBcdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KG5zLCAnZGVmYXVsdCcsIHsgZW51bWVyYWJsZTogdHJ1ZSwgdmFsdWU6IHZhbHVlIH0pO1xuIFx0XHRpZihtb2RlICYgMiAmJiB0eXBlb2YgdmFsdWUgIT0gJ3N0cmluZycpIGZvcih2YXIga2V5IGluIHZhbHVlKSBfX3dlYnBhY2tfcmVxdWlyZV9fLmQobnMsIGtleSwgZnVuY3Rpb24oa2V5KSB7IHJldHVybiB2YWx1ZVtrZXldOyB9LmJpbmQobnVsbCwga2V5KSk7XG4gXHRcdHJldHVybiBucztcbiBcdH07XG5cbiBcdC8vIGdldERlZmF1bHRFeHBvcnQgZnVuY3Rpb24gZm9yIGNvbXBhdGliaWxpdHkgd2l0aCBub24taGFybW9ueSBtb2R1bGVzXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLm4gPSBmdW5jdGlvbihtb2R1bGUpIHtcbiBcdFx0dmFyIGdldHRlciA9IG1vZHVsZSAmJiBtb2R1bGUuX19lc01vZHVsZSA/XG4gXHRcdFx0ZnVuY3Rpb24gZ2V0RGVmYXVsdCgpIHsgcmV0dXJuIG1vZHVsZVsnZGVmYXVsdCddOyB9IDpcbiBcdFx0XHRmdW5jdGlvbiBnZXRNb2R1bGVFeHBvcnRzKCkgeyByZXR1cm4gbW9kdWxlOyB9O1xuIFx0XHRfX3dlYnBhY2tfcmVxdWlyZV9fLmQoZ2V0dGVyLCAnYScsIGdldHRlcik7XG4gXHRcdHJldHVybiBnZXR0ZXI7XG4gXHR9O1xuXG4gXHQvLyBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGxcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubyA9IGZ1bmN0aW9uKG9iamVjdCwgcHJvcGVydHkpIHsgcmV0dXJuIE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChvYmplY3QsIHByb3BlcnR5KTsgfTtcblxuIFx0Ly8gX193ZWJwYWNrX3B1YmxpY19wYXRoX19cbiBcdF9fd2VicGFja19yZXF1aXJlX18ucCA9IFwiXCI7XG5cblxuIFx0Ly8gTG9hZCBlbnRyeSBtb2R1bGUgYW5kIHJldHVybiBleHBvcnRzXG4gXHRyZXR1cm4gX193ZWJwYWNrX3JlcXVpcmVfXyhfX3dlYnBhY2tfcmVxdWlyZV9fLnMgPSBcIi4vanNfc3JjL3JlYWN0X2RvbV9zZXJ2ZXIuanNcIik7XG4iLCJjb25zdCBSZWFjdERPTVNlcnZlciA9IHJlcXVpcmUoJ3JlYWN0LWRvbS9zZXJ2ZXInKTtcblxubW9kdWxlLmV4cG9ydHMgPSBSZWFjdERPTVNlcnZlcjtcbiIsIi8qXG5vYmplY3QtYXNzaWduXG4oYykgU2luZHJlIFNvcmh1c1xuQGxpY2Vuc2UgTUlUXG4qL1xuXG4ndXNlIHN0cmljdCc7XG4vKiBlc2xpbnQtZGlzYWJsZSBuby11bnVzZWQtdmFycyAqL1xudmFyIGdldE93blByb3BlcnR5U3ltYm9scyA9IE9iamVjdC5nZXRPd25Qcm9wZXJ0eVN5bWJvbHM7XG52YXIgaGFzT3duUHJvcGVydHkgPSBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5O1xudmFyIHByb3BJc0VudW1lcmFibGUgPSBPYmplY3QucHJvdG90eXBlLnByb3BlcnR5SXNFbnVtZXJhYmxlO1xuXG5mdW5jdGlvbiB0b09iamVjdCh2YWwpIHtcblx0aWYgKHZhbCA9PT0gbnVsbCB8fCB2YWwgPT09IHVuZGVmaW5lZCkge1xuXHRcdHRocm93IG5ldyBUeXBlRXJyb3IoJ09iamVjdC5hc3NpZ24gY2Fubm90IGJlIGNhbGxlZCB3aXRoIG51bGwgb3IgdW5kZWZpbmVkJyk7XG5cdH1cblxuXHRyZXR1cm4gT2JqZWN0KHZhbCk7XG59XG5cbmZ1bmN0aW9uIHNob3VsZFVzZU5hdGl2ZSgpIHtcblx0dHJ5IHtcblx0XHRpZiAoIU9iamVjdC5hc3NpZ24pIHtcblx0XHRcdHJldHVybiBmYWxzZTtcblx0XHR9XG5cblx0XHQvLyBEZXRlY3QgYnVnZ3kgcHJvcGVydHkgZW51bWVyYXRpb24gb3JkZXIgaW4gb2xkZXIgVjggdmVyc2lvbnMuXG5cblx0XHQvLyBodHRwczovL2J1Z3MuY2hyb21pdW0ub3JnL3AvdjgvaXNzdWVzL2RldGFpbD9pZD00MTE4XG5cdFx0dmFyIHRlc3QxID0gbmV3IFN0cmluZygnYWJjJyk7ICAvLyBlc2xpbnQtZGlzYWJsZS1saW5lIG5vLW5ldy13cmFwcGVyc1xuXHRcdHRlc3QxWzVdID0gJ2RlJztcblx0XHRpZiAoT2JqZWN0LmdldE93blByb3BlcnR5TmFtZXModGVzdDEpWzBdID09PSAnNScpIHtcblx0XHRcdHJldHVybiBmYWxzZTtcblx0XHR9XG5cblx0XHQvLyBodHRwczovL2J1Z3MuY2hyb21pdW0ub3JnL3AvdjgvaXNzdWVzL2RldGFpbD9pZD0zMDU2XG5cdFx0dmFyIHRlc3QyID0ge307XG5cdFx0Zm9yICh2YXIgaSA9IDA7IGkgPCAxMDsgaSsrKSB7XG5cdFx0XHR0ZXN0MlsnXycgKyBTdHJpbmcuZnJvbUNoYXJDb2RlKGkpXSA9IGk7XG5cdFx0fVxuXHRcdHZhciBvcmRlcjIgPSBPYmplY3QuZ2V0T3duUHJvcGVydHlOYW1lcyh0ZXN0MikubWFwKGZ1bmN0aW9uIChuKSB7XG5cdFx0XHRyZXR1cm4gdGVzdDJbbl07XG5cdFx0fSk7XG5cdFx0aWYgKG9yZGVyMi5qb2luKCcnKSAhPT0gJzAxMjM0NTY3ODknKSB7XG5cdFx0XHRyZXR1cm4gZmFsc2U7XG5cdFx0fVxuXG5cdFx0Ly8gaHR0cHM6Ly9idWdzLmNocm9taXVtLm9yZy9wL3Y4L2lzc3Vlcy9kZXRhaWw/aWQ9MzA1NlxuXHRcdHZhciB0ZXN0MyA9IHt9O1xuXHRcdCdhYmNkZWZnaGlqa2xtbm9wcXJzdCcuc3BsaXQoJycpLmZvckVhY2goZnVuY3Rpb24gKGxldHRlcikge1xuXHRcdFx0dGVzdDNbbGV0dGVyXSA9IGxldHRlcjtcblx0XHR9KTtcblx0XHRpZiAoT2JqZWN0LmtleXMoT2JqZWN0LmFzc2lnbih7fSwgdGVzdDMpKS5qb2luKCcnKSAhPT1cblx0XHRcdFx0J2FiY2RlZmdoaWprbG1ub3BxcnN0Jykge1xuXHRcdFx0cmV0dXJuIGZhbHNlO1xuXHRcdH1cblxuXHRcdHJldHVybiB0cnVlO1xuXHR9IGNhdGNoIChlcnIpIHtcblx0XHQvLyBXZSBkb24ndCBleHBlY3QgYW55IG9mIHRoZSBhYm92ZSB0byB0aHJvdywgYnV0IGJldHRlciB0byBiZSBzYWZlLlxuXHRcdHJldHVybiBmYWxzZTtcblx0fVxufVxuXG5tb2R1bGUuZXhwb3J0cyA9IHNob3VsZFVzZU5hdGl2ZSgpID8gT2JqZWN0LmFzc2lnbiA6IGZ1bmN0aW9uICh0YXJnZXQsIHNvdXJjZSkge1xuXHR2YXIgZnJvbTtcblx0dmFyIHRvID0gdG9PYmplY3QodGFyZ2V0KTtcblx0dmFyIHN5bWJvbHM7XG5cblx0Zm9yICh2YXIgcyA9IDE7IHMgPCBhcmd1bWVudHMubGVuZ3RoOyBzKyspIHtcblx0XHRmcm9tID0gT2JqZWN0KGFyZ3VtZW50c1tzXSk7XG5cblx0XHRmb3IgKHZhciBrZXkgaW4gZnJvbSkge1xuXHRcdFx0aWYgKGhhc093blByb3BlcnR5LmNhbGwoZnJvbSwga2V5KSkge1xuXHRcdFx0XHR0b1trZXldID0gZnJvbVtrZXldO1xuXHRcdFx0fVxuXHRcdH1cblxuXHRcdGlmIChnZXRPd25Qcm9wZXJ0eVN5bWJvbHMpIHtcblx0XHRcdHN5bWJvbHMgPSBnZXRPd25Qcm9wZXJ0eVN5bWJvbHMoZnJvbSk7XG5cdFx0XHRmb3IgKHZhciBpID0gMDsgaSA8IHN5bWJvbHMubGVuZ3RoOyBpKyspIHtcblx0XHRcdFx0aWYgKHByb3BJc0VudW1lcmFibGUuY2FsbChmcm9tLCBzeW1ib2xzW2ldKSkge1xuXHRcdFx0XHRcdHRvW3N5bWJvbHNbaV1dID0gZnJvbVtzeW1ib2xzW2ldXTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXHRcdH1cblx0fVxuXG5cdHJldHVybiB0bztcbn07XG4iLCIvKipcbiAqIENvcHlyaWdodCAoYykgMjAxMy1wcmVzZW50LCBGYWNlYm9vaywgSW5jLlxuICpcbiAqIFRoaXMgc291cmNlIGNvZGUgaXMgbGljZW5zZWQgdW5kZXIgdGhlIE1JVCBsaWNlbnNlIGZvdW5kIGluIHRoZVxuICogTElDRU5TRSBmaWxlIGluIHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGlzIHNvdXJjZSB0cmVlLlxuICovXG5cbid1c2Ugc3RyaWN0JztcblxudmFyIHByaW50V2FybmluZyA9IGZ1bmN0aW9uKCkge307XG5cbmlmIChwcm9jZXNzLmVudi5OT0RFX0VOViAhPT0gJ3Byb2R1Y3Rpb24nKSB7XG4gIHZhciBSZWFjdFByb3BUeXBlc1NlY3JldCA9IHJlcXVpcmUoJy4vbGliL1JlYWN0UHJvcFR5cGVzU2VjcmV0Jyk7XG4gIHZhciBsb2dnZWRUeXBlRmFpbHVyZXMgPSB7fTtcbiAgdmFyIGhhcyA9IEZ1bmN0aW9uLmNhbGwuYmluZChPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5KTtcblxuICBwcmludFdhcm5pbmcgPSBmdW5jdGlvbih0ZXh0KSB7XG4gICAgdmFyIG1lc3NhZ2UgPSAnV2FybmluZzogJyArIHRleHQ7XG4gICAgaWYgKHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgY29uc29sZS5lcnJvcihtZXNzYWdlKTtcbiAgICB9XG4gICAgdHJ5IHtcbiAgICAgIC8vIC0tLSBXZWxjb21lIHRvIGRlYnVnZ2luZyBSZWFjdCAtLS1cbiAgICAgIC8vIFRoaXMgZXJyb3Igd2FzIHRocm93biBhcyBhIGNvbnZlbmllbmNlIHNvIHRoYXQgeW91IGNhbiB1c2UgdGhpcyBzdGFja1xuICAgICAgLy8gdG8gZmluZCB0aGUgY2FsbHNpdGUgdGhhdCBjYXVzZWQgdGhpcyB3YXJuaW5nIHRvIGZpcmUuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IobWVzc2FnZSk7XG4gICAgfSBjYXRjaCAoeCkge31cbiAgfTtcbn1cblxuLyoqXG4gKiBBc3NlcnQgdGhhdCB0aGUgdmFsdWVzIG1hdGNoIHdpdGggdGhlIHR5cGUgc3BlY3MuXG4gKiBFcnJvciBtZXNzYWdlcyBhcmUgbWVtb3JpemVkIGFuZCB3aWxsIG9ubHkgYmUgc2hvd24gb25jZS5cbiAqXG4gKiBAcGFyYW0ge29iamVjdH0gdHlwZVNwZWNzIE1hcCBvZiBuYW1lIHRvIGEgUmVhY3RQcm9wVHlwZVxuICogQHBhcmFtIHtvYmplY3R9IHZhbHVlcyBSdW50aW1lIHZhbHVlcyB0aGF0IG5lZWQgdG8gYmUgdHlwZS1jaGVja2VkXG4gKiBAcGFyYW0ge3N0cmluZ30gbG9jYXRpb24gZS5nLiBcInByb3BcIiwgXCJjb250ZXh0XCIsIFwiY2hpbGQgY29udGV4dFwiXG4gKiBAcGFyYW0ge3N0cmluZ30gY29tcG9uZW50TmFtZSBOYW1lIG9mIHRoZSBjb21wb25lbnQgZm9yIGVycm9yIG1lc3NhZ2VzLlxuICogQHBhcmFtIHs/RnVuY3Rpb259IGdldFN0YWNrIFJldHVybnMgdGhlIGNvbXBvbmVudCBzdGFjay5cbiAqIEBwcml2YXRlXG4gKi9cbmZ1bmN0aW9uIGNoZWNrUHJvcFR5cGVzKHR5cGVTcGVjcywgdmFsdWVzLCBsb2NhdGlvbiwgY29tcG9uZW50TmFtZSwgZ2V0U3RhY2spIHtcbiAgaWYgKHByb2Nlc3MuZW52Lk5PREVfRU5WICE9PSAncHJvZHVjdGlvbicpIHtcbiAgICBmb3IgKHZhciB0eXBlU3BlY05hbWUgaW4gdHlwZVNwZWNzKSB7XG4gICAgICBpZiAoaGFzKHR5cGVTcGVjcywgdHlwZVNwZWNOYW1lKSkge1xuICAgICAgICB2YXIgZXJyb3I7XG4gICAgICAgIC8vIFByb3AgdHlwZSB2YWxpZGF0aW9uIG1heSB0aHJvdy4gSW4gY2FzZSB0aGV5IGRvLCB3ZSBkb24ndCB3YW50IHRvXG4gICAgICAgIC8vIGZhaWwgdGhlIHJlbmRlciBwaGFzZSB3aGVyZSBpdCBkaWRuJ3QgZmFpbCBiZWZvcmUuIFNvIHdlIGxvZyBpdC5cbiAgICAgICAgLy8gQWZ0ZXIgdGhlc2UgaGF2ZSBiZWVuIGNsZWFuZWQgdXAsIHdlJ2xsIGxldCB0aGVtIHRocm93LlxuICAgICAgICB0cnkge1xuICAgICAgICAgIC8vIFRoaXMgaXMgaW50ZW50aW9uYWxseSBhbiBpbnZhcmlhbnQgdGhhdCBnZXRzIGNhdWdodC4gSXQncyB0aGUgc2FtZVxuICAgICAgICAgIC8vIGJlaGF2aW9yIGFzIHdpdGhvdXQgdGhpcyBzdGF0ZW1lbnQgZXhjZXB0IHdpdGggYSBiZXR0ZXIgbWVzc2FnZS5cbiAgICAgICAgICBpZiAodHlwZW9mIHR5cGVTcGVjc1t0eXBlU3BlY05hbWVdICE9PSAnZnVuY3Rpb24nKSB7XG4gICAgICAgICAgICB2YXIgZXJyID0gRXJyb3IoXG4gICAgICAgICAgICAgIChjb21wb25lbnROYW1lIHx8ICdSZWFjdCBjbGFzcycpICsgJzogJyArIGxvY2F0aW9uICsgJyB0eXBlIGAnICsgdHlwZVNwZWNOYW1lICsgJ2AgaXMgaW52YWxpZDsgJyArXG4gICAgICAgICAgICAgICdpdCBtdXN0IGJlIGEgZnVuY3Rpb24sIHVzdWFsbHkgZnJvbSB0aGUgYHByb3AtdHlwZXNgIHBhY2thZ2UsIGJ1dCByZWNlaXZlZCBgJyArIHR5cGVvZiB0eXBlU3BlY3NbdHlwZVNwZWNOYW1lXSArICdgLidcbiAgICAgICAgICAgICk7XG4gICAgICAgICAgICBlcnIubmFtZSA9ICdJbnZhcmlhbnQgVmlvbGF0aW9uJztcbiAgICAgICAgICAgIHRocm93IGVycjtcbiAgICAgICAgICB9XG4gICAgICAgICAgZXJyb3IgPSB0eXBlU3BlY3NbdHlwZVNwZWNOYW1lXSh2YWx1ZXMsIHR5cGVTcGVjTmFtZSwgY29tcG9uZW50TmFtZSwgbG9jYXRpb24sIG51bGwsIFJlYWN0UHJvcFR5cGVzU2VjcmV0KTtcbiAgICAgICAgfSBjYXRjaCAoZXgpIHtcbiAgICAgICAgICBlcnJvciA9IGV4O1xuICAgICAgICB9XG4gICAgICAgIGlmIChlcnJvciAmJiAhKGVycm9yIGluc3RhbmNlb2YgRXJyb3IpKSB7XG4gICAgICAgICAgcHJpbnRXYXJuaW5nKFxuICAgICAgICAgICAgKGNvbXBvbmVudE5hbWUgfHwgJ1JlYWN0IGNsYXNzJykgKyAnOiB0eXBlIHNwZWNpZmljYXRpb24gb2YgJyArXG4gICAgICAgICAgICBsb2NhdGlvbiArICcgYCcgKyB0eXBlU3BlY05hbWUgKyAnYCBpcyBpbnZhbGlkOyB0aGUgdHlwZSBjaGVja2VyICcgK1xuICAgICAgICAgICAgJ2Z1bmN0aW9uIG11c3QgcmV0dXJuIGBudWxsYCBvciBhbiBgRXJyb3JgIGJ1dCByZXR1cm5lZCBhICcgKyB0eXBlb2YgZXJyb3IgKyAnLiAnICtcbiAgICAgICAgICAgICdZb3UgbWF5IGhhdmUgZm9yZ290dGVuIHRvIHBhc3MgYW4gYXJndW1lbnQgdG8gdGhlIHR5cGUgY2hlY2tlciAnICtcbiAgICAgICAgICAgICdjcmVhdG9yIChhcnJheU9mLCBpbnN0YW5jZU9mLCBvYmplY3RPZiwgb25lT2YsIG9uZU9mVHlwZSwgYW5kICcgK1xuICAgICAgICAgICAgJ3NoYXBlIGFsbCByZXF1aXJlIGFuIGFyZ3VtZW50KS4nXG4gICAgICAgICAgKTtcbiAgICAgICAgfVxuICAgICAgICBpZiAoZXJyb3IgaW5zdGFuY2VvZiBFcnJvciAmJiAhKGVycm9yLm1lc3NhZ2UgaW4gbG9nZ2VkVHlwZUZhaWx1cmVzKSkge1xuICAgICAgICAgIC8vIE9ubHkgbW9uaXRvciB0aGlzIGZhaWx1cmUgb25jZSBiZWNhdXNlIHRoZXJlIHRlbmRzIHRvIGJlIGEgbG90IG9mIHRoZVxuICAgICAgICAgIC8vIHNhbWUgZXJyb3IuXG4gICAgICAgICAgbG9nZ2VkVHlwZUZhaWx1cmVzW2Vycm9yLm1lc3NhZ2VdID0gdHJ1ZTtcblxuICAgICAgICAgIHZhciBzdGFjayA9IGdldFN0YWNrID8gZ2V0U3RhY2soKSA6ICcnO1xuXG4gICAgICAgICAgcHJpbnRXYXJuaW5nKFxuICAgICAgICAgICAgJ0ZhaWxlZCAnICsgbG9jYXRpb24gKyAnIHR5cGU6ICcgKyBlcnJvci5tZXNzYWdlICsgKHN0YWNrICE9IG51bGwgPyBzdGFjayA6ICcnKVxuICAgICAgICAgICk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG4gIH1cbn1cblxuLyoqXG4gKiBSZXNldHMgd2FybmluZyBjYWNoZSB3aGVuIHRlc3RpbmcuXG4gKlxuICogQHByaXZhdGVcbiAqL1xuY2hlY2tQcm9wVHlwZXMucmVzZXRXYXJuaW5nQ2FjaGUgPSBmdW5jdGlvbigpIHtcbiAgaWYgKHByb2Nlc3MuZW52Lk5PREVfRU5WICE9PSAncHJvZHVjdGlvbicpIHtcbiAgICBsb2dnZWRUeXBlRmFpbHVyZXMgPSB7fTtcbiAgfVxufVxuXG5tb2R1bGUuZXhwb3J0cyA9IGNoZWNrUHJvcFR5cGVzO1xuIiwiLyoqXG4gKiBDb3B5cmlnaHQgKGMpIDIwMTMtcHJlc2VudCwgRmFjZWJvb2ssIEluYy5cbiAqXG4gKiBUaGlzIHNvdXJjZSBjb2RlIGlzIGxpY2Vuc2VkIHVuZGVyIHRoZSBNSVQgbGljZW5zZSBmb3VuZCBpbiB0aGVcbiAqIExJQ0VOU0UgZmlsZSBpbiB0aGUgcm9vdCBkaXJlY3Rvcnkgb2YgdGhpcyBzb3VyY2UgdHJlZS5cbiAqL1xuXG4ndXNlIHN0cmljdCc7XG5cbnZhciBSZWFjdFByb3BUeXBlc1NlY3JldCA9ICdTRUNSRVRfRE9fTk9UX1BBU1NfVEhJU19PUl9ZT1VfV0lMTF9CRV9GSVJFRCc7XG5cbm1vZHVsZS5leHBvcnRzID0gUmVhY3RQcm9wVHlwZXNTZWNyZXQ7XG4iLCIvKiogQGxpY2Vuc2UgUmVhY3QgdjE2LjguMVxuICogcmVhY3QtZG9tLXNlcnZlci5icm93c2VyLmRldmVsb3BtZW50LmpzXG4gKlxuICogQ29weXJpZ2h0IChjKSBGYWNlYm9vaywgSW5jLiBhbmQgaXRzIGFmZmlsaWF0ZXMuXG4gKlxuICogVGhpcyBzb3VyY2UgY29kZSBpcyBsaWNlbnNlZCB1bmRlciB0aGUgTUlUIGxpY2Vuc2UgZm91bmQgaW4gdGhlXG4gKiBMSUNFTlNFIGZpbGUgaW4gdGhlIHJvb3QgZGlyZWN0b3J5IG9mIHRoaXMgc291cmNlIHRyZWUuXG4gKi9cblxuJ3VzZSBzdHJpY3QnO1xuXG5cblxuaWYgKHByb2Nlc3MuZW52Lk5PREVfRU5WICE9PSBcInByb2R1Y3Rpb25cIikge1xuICAoZnVuY3Rpb24oKSB7XG4ndXNlIHN0cmljdCc7XG5cbnZhciBfYXNzaWduID0gcmVxdWlyZSgnb2JqZWN0LWFzc2lnbicpO1xudmFyIFJlYWN0ID0gcmVxdWlyZSgncmVhY3QnKTtcbnZhciBjaGVja1Byb3BUeXBlcyA9IHJlcXVpcmUoJ3Byb3AtdHlwZXMvY2hlY2tQcm9wVHlwZXMnKTtcblxuLyoqXG4gKiBVc2UgaW52YXJpYW50KCkgdG8gYXNzZXJ0IHN0YXRlIHdoaWNoIHlvdXIgcHJvZ3JhbSBhc3N1bWVzIHRvIGJlIHRydWUuXG4gKlxuICogUHJvdmlkZSBzcHJpbnRmLXN0eWxlIGZvcm1hdCAob25seSAlcyBpcyBzdXBwb3J0ZWQpIGFuZCBhcmd1bWVudHNcbiAqIHRvIHByb3ZpZGUgaW5mb3JtYXRpb24gYWJvdXQgd2hhdCBicm9rZSBhbmQgd2hhdCB5b3Ugd2VyZVxuICogZXhwZWN0aW5nLlxuICpcbiAqIFRoZSBpbnZhcmlhbnQgbWVzc2FnZSB3aWxsIGJlIHN0cmlwcGVkIGluIHByb2R1Y3Rpb24sIGJ1dCB0aGUgaW52YXJpYW50XG4gKiB3aWxsIHJlbWFpbiB0byBlbnN1cmUgbG9naWMgZG9lcyBub3QgZGlmZmVyIGluIHByb2R1Y3Rpb24uXG4gKi9cblxudmFyIHZhbGlkYXRlRm9ybWF0ID0gZnVuY3Rpb24gKCkge307XG5cbntcbiAgdmFsaWRhdGVGb3JtYXQgPSBmdW5jdGlvbiAoZm9ybWF0KSB7XG4gICAgaWYgKGZvcm1hdCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ2ludmFyaWFudCByZXF1aXJlcyBhbiBlcnJvciBtZXNzYWdlIGFyZ3VtZW50Jyk7XG4gICAgfVxuICB9O1xufVxuXG5mdW5jdGlvbiBpbnZhcmlhbnQoY29uZGl0aW9uLCBmb3JtYXQsIGEsIGIsIGMsIGQsIGUsIGYpIHtcbiAgdmFsaWRhdGVGb3JtYXQoZm9ybWF0KTtcblxuICBpZiAoIWNvbmRpdGlvbikge1xuICAgIHZhciBlcnJvciA9IHZvaWQgMDtcbiAgICBpZiAoZm9ybWF0ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIGVycm9yID0gbmV3IEVycm9yKCdNaW5pZmllZCBleGNlcHRpb24gb2NjdXJyZWQ7IHVzZSB0aGUgbm9uLW1pbmlmaWVkIGRldiBlbnZpcm9ubWVudCAnICsgJ2ZvciB0aGUgZnVsbCBlcnJvciBtZXNzYWdlIGFuZCBhZGRpdGlvbmFsIGhlbHBmdWwgd2FybmluZ3MuJyk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHZhciBhcmdzID0gW2EsIGIsIGMsIGQsIGUsIGZdO1xuICAgICAgdmFyIGFyZ0luZGV4ID0gMDtcbiAgICAgIGVycm9yID0gbmV3IEVycm9yKGZvcm1hdC5yZXBsYWNlKC8lcy9nLCBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiBhcmdzW2FyZ0luZGV4KytdO1xuICAgICAgfSkpO1xuICAgICAgZXJyb3IubmFtZSA9ICdJbnZhcmlhbnQgVmlvbGF0aW9uJztcbiAgICB9XG5cbiAgICBlcnJvci5mcmFtZXNUb1BvcCA9IDE7IC8vIHdlIGRvbid0IGNhcmUgYWJvdXQgaW52YXJpYW50J3Mgb3duIGZyYW1lXG4gICAgdGhyb3cgZXJyb3I7XG4gIH1cbn1cblxuLy8gUmVseWluZyBvbiB0aGUgYGludmFyaWFudCgpYCBpbXBsZW1lbnRhdGlvbiBsZXRzIHVzXG4vLyBwcmVzZXJ2ZSB0aGUgZm9ybWF0IGFuZCBwYXJhbXMgaW4gdGhlIHd3dyBidWlsZHMuXG5cbi8vIFRPRE86IHRoaXMgaXMgc3BlY2lhbCBiZWNhdXNlIGl0IGdldHMgaW1wb3J0ZWQgZHVyaW5nIGJ1aWxkLlxuXG52YXIgUmVhY3RWZXJzaW9uID0gJzE2LjguMSc7XG5cbi8qKlxuICogU2ltaWxhciB0byBpbnZhcmlhbnQgYnV0IG9ubHkgbG9ncyBhIHdhcm5pbmcgaWYgdGhlIGNvbmRpdGlvbiBpcyBub3QgbWV0LlxuICogVGhpcyBjYW4gYmUgdXNlZCB0byBsb2cgaXNzdWVzIGluIGRldmVsb3BtZW50IGVudmlyb25tZW50cyBpbiBjcml0aWNhbFxuICogcGF0aHMuIFJlbW92aW5nIHRoZSBsb2dnaW5nIGNvZGUgZm9yIHByb2R1Y3Rpb24gZW52aXJvbm1lbnRzIHdpbGwga2VlcCB0aGVcbiAqIHNhbWUgbG9naWMgYW5kIGZvbGxvdyB0aGUgc2FtZSBjb2RlIHBhdGhzLlxuICovXG5cbnZhciB3YXJuaW5nV2l0aG91dFN0YWNrID0gZnVuY3Rpb24gKCkge307XG5cbntcbiAgd2FybmluZ1dpdGhvdXRTdGFjayA9IGZ1bmN0aW9uIChjb25kaXRpb24sIGZvcm1hdCkge1xuICAgIGZvciAodmFyIF9sZW4gPSBhcmd1bWVudHMubGVuZ3RoLCBhcmdzID0gQXJyYXkoX2xlbiA+IDIgPyBfbGVuIC0gMiA6IDApLCBfa2V5ID0gMjsgX2tleSA8IF9sZW47IF9rZXkrKykge1xuICAgICAgYXJnc1tfa2V5IC0gMl0gPSBhcmd1bWVudHNbX2tleV07XG4gICAgfVxuXG4gICAgaWYgKGZvcm1hdCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ2B3YXJuaW5nV2l0aG91dFN0YWNrKGNvbmRpdGlvbiwgZm9ybWF0LCAuLi5hcmdzKWAgcmVxdWlyZXMgYSB3YXJuaW5nICcgKyAnbWVzc2FnZSBhcmd1bWVudCcpO1xuICAgIH1cbiAgICBpZiAoYXJncy5sZW5ndGggPiA4KSB7XG4gICAgICAvLyBDaGVjayBiZWZvcmUgdGhlIGNvbmRpdGlvbiB0byBjYXRjaCB2aW9sYXRpb25zIGVhcmx5LlxuICAgICAgdGhyb3cgbmV3IEVycm9yKCd3YXJuaW5nV2l0aG91dFN0YWNrKCkgY3VycmVudGx5IHN1cHBvcnRzIGF0IG1vc3QgOCBhcmd1bWVudHMuJyk7XG4gICAgfVxuICAgIGlmIChjb25kaXRpb24pIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG4gICAgaWYgKHR5cGVvZiBjb25zb2xlICE9PSAndW5kZWZpbmVkJykge1xuICAgICAgdmFyIGFyZ3NXaXRoRm9ybWF0ID0gYXJncy5tYXAoZnVuY3Rpb24gKGl0ZW0pIHtcbiAgICAgICAgcmV0dXJuICcnICsgaXRlbTtcbiAgICAgIH0pO1xuICAgICAgYXJnc1dpdGhGb3JtYXQudW5zaGlmdCgnV2FybmluZzogJyArIGZvcm1hdCk7XG5cbiAgICAgIC8vIFdlIGludGVudGlvbmFsbHkgZG9uJ3QgdXNlIHNwcmVhZCAob3IgLmFwcGx5KSBkaXJlY3RseSBiZWNhdXNlIGl0XG4gICAgICAvLyBicmVha3MgSUU5OiBodHRwczovL2dpdGh1Yi5jb20vZmFjZWJvb2svcmVhY3QvaXNzdWVzLzEzNjEwXG4gICAgICBGdW5jdGlvbi5wcm90b3R5cGUuYXBwbHkuY2FsbChjb25zb2xlLmVycm9yLCBjb25zb2xlLCBhcmdzV2l0aEZvcm1hdCk7XG4gICAgfVxuICAgIHRyeSB7XG4gICAgICAvLyAtLS0gV2VsY29tZSB0byBkZWJ1Z2dpbmcgUmVhY3QgLS0tXG4gICAgICAvLyBUaGlzIGVycm9yIHdhcyB0aHJvd24gYXMgYSBjb252ZW5pZW5jZSBzbyB0aGF0IHlvdSBjYW4gdXNlIHRoaXMgc3RhY2tcbiAgICAgIC8vIHRvIGZpbmQgdGhlIGNhbGxzaXRlIHRoYXQgY2F1c2VkIHRoaXMgd2FybmluZyB0byBmaXJlLlxuICAgICAgdmFyIGFyZ0luZGV4ID0gMDtcbiAgICAgIHZhciBtZXNzYWdlID0gJ1dhcm5pbmc6ICcgKyBmb3JtYXQucmVwbGFjZSgvJXMvZywgZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gYXJnc1thcmdJbmRleCsrXTtcbiAgICAgIH0pO1xuICAgICAgdGhyb3cgbmV3IEVycm9yKG1lc3NhZ2UpO1xuICAgIH0gY2F0Y2ggKHgpIHt9XG4gIH07XG59XG5cbnZhciB3YXJuaW5nV2l0aG91dFN0YWNrJDEgPSB3YXJuaW5nV2l0aG91dFN0YWNrO1xuXG4vLyBUaGUgU3ltYm9sIHVzZWQgdG8gdGFnIHRoZSBSZWFjdEVsZW1lbnQtbGlrZSB0eXBlcy4gSWYgdGhlcmUgaXMgbm8gbmF0aXZlIFN5bWJvbFxuLy8gbm9yIHBvbHlmaWxsLCB0aGVuIGEgcGxhaW4gbnVtYmVyIGlzIHVzZWQgZm9yIHBlcmZvcm1hbmNlLlxudmFyIGhhc1N5bWJvbCA9IHR5cGVvZiBTeW1ib2wgPT09ICdmdW5jdGlvbicgJiYgU3ltYm9sLmZvcjtcblxuXG52YXIgUkVBQ1RfUE9SVEFMX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5wb3J0YWwnKSA6IDB4ZWFjYTtcbnZhciBSRUFDVF9GUkFHTUVOVF9UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3QuZnJhZ21lbnQnKSA6IDB4ZWFjYjtcbnZhciBSRUFDVF9TVFJJQ1RfTU9ERV9UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3Quc3RyaWN0X21vZGUnKSA6IDB4ZWFjYztcbnZhciBSRUFDVF9QUk9GSUxFUl9UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3QucHJvZmlsZXInKSA6IDB4ZWFkMjtcbnZhciBSRUFDVF9QUk9WSURFUl9UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3QucHJvdmlkZXInKSA6IDB4ZWFjZDtcbnZhciBSRUFDVF9DT05URVhUX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5jb250ZXh0JykgOiAweGVhY2U7XG5cbnZhciBSRUFDVF9DT05DVVJSRU5UX01PREVfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LmNvbmN1cnJlbnRfbW9kZScpIDogMHhlYWNmO1xudmFyIFJFQUNUX0ZPUldBUkRfUkVGX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5mb3J3YXJkX3JlZicpIDogMHhlYWQwO1xudmFyIFJFQUNUX1NVU1BFTlNFX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5zdXNwZW5zZScpIDogMHhlYWQxO1xudmFyIFJFQUNUX01FTU9fVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0Lm1lbW8nKSA6IDB4ZWFkMztcbnZhciBSRUFDVF9MQVpZX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5sYXp5JykgOiAweGVhZDQ7XG5cbnZhciBSZXNvbHZlZCA9IDE7XG5cblxuZnVuY3Rpb24gcmVmaW5lUmVzb2x2ZWRMYXp5Q29tcG9uZW50KGxhenlDb21wb25lbnQpIHtcbiAgcmV0dXJuIGxhenlDb21wb25lbnQuX3N0YXR1cyA9PT0gUmVzb2x2ZWQgPyBsYXp5Q29tcG9uZW50Ll9yZXN1bHQgOiBudWxsO1xufVxuXG5mdW5jdGlvbiBnZXRXcmFwcGVkTmFtZShvdXRlclR5cGUsIGlubmVyVHlwZSwgd3JhcHBlck5hbWUpIHtcbiAgdmFyIGZ1bmN0aW9uTmFtZSA9IGlubmVyVHlwZS5kaXNwbGF5TmFtZSB8fCBpbm5lclR5cGUubmFtZSB8fCAnJztcbiAgcmV0dXJuIG91dGVyVHlwZS5kaXNwbGF5TmFtZSB8fCAoZnVuY3Rpb25OYW1lICE9PSAnJyA/IHdyYXBwZXJOYW1lICsgJygnICsgZnVuY3Rpb25OYW1lICsgJyknIDogd3JhcHBlck5hbWUpO1xufVxuXG5mdW5jdGlvbiBnZXRDb21wb25lbnROYW1lKHR5cGUpIHtcbiAgaWYgKHR5cGUgPT0gbnVsbCkge1xuICAgIC8vIEhvc3Qgcm9vdCwgdGV4dCBub2RlIG9yIGp1c3QgaW52YWxpZCB0eXBlLlxuICAgIHJldHVybiBudWxsO1xuICB9XG4gIHtcbiAgICBpZiAodHlwZW9mIHR5cGUudGFnID09PSAnbnVtYmVyJykge1xuICAgICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnUmVjZWl2ZWQgYW4gdW5leHBlY3RlZCBvYmplY3QgaW4gZ2V0Q29tcG9uZW50TmFtZSgpLiAnICsgJ1RoaXMgaXMgbGlrZWx5IGEgYnVnIGluIFJlYWN0LiBQbGVhc2UgZmlsZSBhbiBpc3N1ZS4nKTtcbiAgICB9XG4gIH1cbiAgaWYgKHR5cGVvZiB0eXBlID09PSAnZnVuY3Rpb24nKSB7XG4gICAgcmV0dXJuIHR5cGUuZGlzcGxheU5hbWUgfHwgdHlwZS5uYW1lIHx8IG51bGw7XG4gIH1cbiAgaWYgKHR5cGVvZiB0eXBlID09PSAnc3RyaW5nJykge1xuICAgIHJldHVybiB0eXBlO1xuICB9XG4gIHN3aXRjaCAodHlwZSkge1xuICAgIGNhc2UgUkVBQ1RfQ09OQ1VSUkVOVF9NT0RFX1RZUEU6XG4gICAgICByZXR1cm4gJ0NvbmN1cnJlbnRNb2RlJztcbiAgICBjYXNlIFJFQUNUX0ZSQUdNRU5UX1RZUEU6XG4gICAgICByZXR1cm4gJ0ZyYWdtZW50JztcbiAgICBjYXNlIFJFQUNUX1BPUlRBTF9UWVBFOlxuICAgICAgcmV0dXJuICdQb3J0YWwnO1xuICAgIGNhc2UgUkVBQ1RfUFJPRklMRVJfVFlQRTpcbiAgICAgIHJldHVybiAnUHJvZmlsZXInO1xuICAgIGNhc2UgUkVBQ1RfU1RSSUNUX01PREVfVFlQRTpcbiAgICAgIHJldHVybiAnU3RyaWN0TW9kZSc7XG4gICAgY2FzZSBSRUFDVF9TVVNQRU5TRV9UWVBFOlxuICAgICAgcmV0dXJuICdTdXNwZW5zZSc7XG4gIH1cbiAgaWYgKHR5cGVvZiB0eXBlID09PSAnb2JqZWN0Jykge1xuICAgIHN3aXRjaCAodHlwZS4kJHR5cGVvZikge1xuICAgICAgY2FzZSBSRUFDVF9DT05URVhUX1RZUEU6XG4gICAgICAgIHJldHVybiAnQ29udGV4dC5Db25zdW1lcic7XG4gICAgICBjYXNlIFJFQUNUX1BST1ZJREVSX1RZUEU6XG4gICAgICAgIHJldHVybiAnQ29udGV4dC5Qcm92aWRlcic7XG4gICAgICBjYXNlIFJFQUNUX0ZPUldBUkRfUkVGX1RZUEU6XG4gICAgICAgIHJldHVybiBnZXRXcmFwcGVkTmFtZSh0eXBlLCB0eXBlLnJlbmRlciwgJ0ZvcndhcmRSZWYnKTtcbiAgICAgIGNhc2UgUkVBQ1RfTUVNT19UWVBFOlxuICAgICAgICByZXR1cm4gZ2V0Q29tcG9uZW50TmFtZSh0eXBlLnR5cGUpO1xuICAgICAgY2FzZSBSRUFDVF9MQVpZX1RZUEU6XG4gICAgICAgIHtcbiAgICAgICAgICB2YXIgdGhlbmFibGUgPSB0eXBlO1xuICAgICAgICAgIHZhciByZXNvbHZlZFRoZW5hYmxlID0gcmVmaW5lUmVzb2x2ZWRMYXp5Q29tcG9uZW50KHRoZW5hYmxlKTtcbiAgICAgICAgICBpZiAocmVzb2x2ZWRUaGVuYWJsZSkge1xuICAgICAgICAgICAgcmV0dXJuIGdldENvbXBvbmVudE5hbWUocmVzb2x2ZWRUaGVuYWJsZSk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfVxuICB9XG4gIHJldHVybiBudWxsO1xufVxuXG4vKipcbiAqIEZvcmtlZCBmcm9tIGZianMvd2FybmluZzpcbiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9vay9mYmpzL2Jsb2IvZTY2YmEyMGFkNWJlNDMzZWI1NDQyM2YyYjA5N2Q4MjkzMjRkOWRlNi9wYWNrYWdlcy9mYmpzL3NyYy9fX2ZvcmtzX18vd2FybmluZy5qc1xuICpcbiAqIE9ubHkgY2hhbmdlIGlzIHdlIHVzZSBjb25zb2xlLndhcm4gaW5zdGVhZCBvZiBjb25zb2xlLmVycm9yLFxuICogYW5kIGRvIG5vdGhpbmcgd2hlbiAnY29uc29sZScgaXMgbm90IHN1cHBvcnRlZC5cbiAqIFRoaXMgcmVhbGx5IHNpbXBsaWZpZXMgdGhlIGNvZGUuXG4gKiAtLS1cbiAqIFNpbWlsYXIgdG8gaW52YXJpYW50IGJ1dCBvbmx5IGxvZ3MgYSB3YXJuaW5nIGlmIHRoZSBjb25kaXRpb24gaXMgbm90IG1ldC5cbiAqIFRoaXMgY2FuIGJlIHVzZWQgdG8gbG9nIGlzc3VlcyBpbiBkZXZlbG9wbWVudCBlbnZpcm9ubWVudHMgaW4gY3JpdGljYWxcbiAqIHBhdGhzLiBSZW1vdmluZyB0aGUgbG9nZ2luZyBjb2RlIGZvciBwcm9kdWN0aW9uIGVudmlyb25tZW50cyB3aWxsIGtlZXAgdGhlXG4gKiBzYW1lIGxvZ2ljIGFuZCBmb2xsb3cgdGhlIHNhbWUgY29kZSBwYXRocy5cbiAqL1xuXG52YXIgbG93UHJpb3JpdHlXYXJuaW5nID0gZnVuY3Rpb24gKCkge307XG5cbntcbiAgdmFyIHByaW50V2FybmluZyA9IGZ1bmN0aW9uIChmb3JtYXQpIHtcbiAgICBmb3IgKHZhciBfbGVuID0gYXJndW1lbnRzLmxlbmd0aCwgYXJncyA9IEFycmF5KF9sZW4gPiAxID8gX2xlbiAtIDEgOiAwKSwgX2tleSA9IDE7IF9rZXkgPCBfbGVuOyBfa2V5KyspIHtcbiAgICAgIGFyZ3NbX2tleSAtIDFdID0gYXJndW1lbnRzW19rZXldO1xuICAgIH1cblxuICAgIHZhciBhcmdJbmRleCA9IDA7XG4gICAgdmFyIG1lc3NhZ2UgPSAnV2FybmluZzogJyArIGZvcm1hdC5yZXBsYWNlKC8lcy9nLCBmdW5jdGlvbiAoKSB7XG4gICAgICByZXR1cm4gYXJnc1thcmdJbmRleCsrXTtcbiAgICB9KTtcbiAgICBpZiAodHlwZW9mIGNvbnNvbGUgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICBjb25zb2xlLndhcm4obWVzc2FnZSk7XG4gICAgfVxuICAgIHRyeSB7XG4gICAgICAvLyAtLS0gV2VsY29tZSB0byBkZWJ1Z2dpbmcgUmVhY3QgLS0tXG4gICAgICAvLyBUaGlzIGVycm9yIHdhcyB0aHJvd24gYXMgYSBjb252ZW5pZW5jZSBzbyB0aGF0IHlvdSBjYW4gdXNlIHRoaXMgc3RhY2tcbiAgICAgIC8vIHRvIGZpbmQgdGhlIGNhbGxzaXRlIHRoYXQgY2F1c2VkIHRoaXMgd2FybmluZyB0byBmaXJlLlxuICAgICAgdGhyb3cgbmV3IEVycm9yKG1lc3NhZ2UpO1xuICAgIH0gY2F0Y2ggKHgpIHt9XG4gIH07XG5cbiAgbG93UHJpb3JpdHlXYXJuaW5nID0gZnVuY3Rpb24gKGNvbmRpdGlvbiwgZm9ybWF0KSB7XG4gICAgaWYgKGZvcm1hdCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ2Bsb3dQcmlvcml0eVdhcm5pbmcoY29uZGl0aW9uLCBmb3JtYXQsIC4uLmFyZ3MpYCByZXF1aXJlcyBhIHdhcm5pbmcgJyArICdtZXNzYWdlIGFyZ3VtZW50Jyk7XG4gICAgfVxuICAgIGlmICghY29uZGl0aW9uKSB7XG4gICAgICBmb3IgKHZhciBfbGVuMiA9IGFyZ3VtZW50cy5sZW5ndGgsIGFyZ3MgPSBBcnJheShfbGVuMiA+IDIgPyBfbGVuMiAtIDIgOiAwKSwgX2tleTIgPSAyOyBfa2V5MiA8IF9sZW4yOyBfa2V5MisrKSB7XG4gICAgICAgIGFyZ3NbX2tleTIgLSAyXSA9IGFyZ3VtZW50c1tfa2V5Ml07XG4gICAgICB9XG5cbiAgICAgIHByaW50V2FybmluZy5hcHBseSh1bmRlZmluZWQsIFtmb3JtYXRdLmNvbmNhdChhcmdzKSk7XG4gICAgfVxuICB9O1xufVxuXG52YXIgbG93UHJpb3JpdHlXYXJuaW5nJDEgPSBsb3dQcmlvcml0eVdhcm5pbmc7XG5cbnZhciBSZWFjdFNoYXJlZEludGVybmFscyA9IFJlYWN0Ll9fU0VDUkVUX0lOVEVSTkFMU19ET19OT1RfVVNFX09SX1lPVV9XSUxMX0JFX0ZJUkVEO1xuXG4vLyBQcmV2ZW50IG5ld2VyIHJlbmRlcmVycyBmcm9tIFJURSB3aGVuIHVzZWQgd2l0aCBvbGRlciByZWFjdCBwYWNrYWdlIHZlcnNpb25zLlxuLy8gQ3VycmVudCBvd25lciBhbmQgZGlzcGF0Y2hlciB1c2VkIHRvIHNoYXJlIHRoZSBzYW1lIHJlZixcbi8vIGJ1dCBQUiAjMTQ1NDggc3BsaXQgdGhlbSBvdXQgdG8gYmV0dGVyIHN1cHBvcnQgdGhlIHJlYWN0LWRlYnVnLXRvb2xzIHBhY2thZ2UuXG5pZiAoIVJlYWN0U2hhcmVkSW50ZXJuYWxzLmhhc093blByb3BlcnR5KCdSZWFjdEN1cnJlbnREaXNwYXRjaGVyJykpIHtcbiAgUmVhY3RTaGFyZWRJbnRlcm5hbHMuUmVhY3RDdXJyZW50RGlzcGF0Y2hlciA9IHtcbiAgICBjdXJyZW50OiBudWxsXG4gIH07XG59XG5cbi8qKlxuICogU2ltaWxhciB0byBpbnZhcmlhbnQgYnV0IG9ubHkgbG9ncyBhIHdhcm5pbmcgaWYgdGhlIGNvbmRpdGlvbiBpcyBub3QgbWV0LlxuICogVGhpcyBjYW4gYmUgdXNlZCB0byBsb2cgaXNzdWVzIGluIGRldmVsb3BtZW50IGVudmlyb25tZW50cyBpbiBjcml0aWNhbFxuICogcGF0aHMuIFJlbW92aW5nIHRoZSBsb2dnaW5nIGNvZGUgZm9yIHByb2R1Y3Rpb24gZW52aXJvbm1lbnRzIHdpbGwga2VlcCB0aGVcbiAqIHNhbWUgbG9naWMgYW5kIGZvbGxvdyB0aGUgc2FtZSBjb2RlIHBhdGhzLlxuICovXG5cbnZhciB3YXJuaW5nID0gd2FybmluZ1dpdGhvdXRTdGFjayQxO1xuXG57XG4gIHdhcm5pbmcgPSBmdW5jdGlvbiAoY29uZGl0aW9uLCBmb3JtYXQpIHtcbiAgICBpZiAoY29uZGl0aW9uKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuICAgIHZhciBSZWFjdERlYnVnQ3VycmVudEZyYW1lID0gUmVhY3RTaGFyZWRJbnRlcm5hbHMuUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZTtcbiAgICB2YXIgc3RhY2sgPSBSZWFjdERlYnVnQ3VycmVudEZyYW1lLmdldFN0YWNrQWRkZW5kdW0oKTtcbiAgICAvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgcmVhY3QtaW50ZXJuYWwvd2FybmluZy1hbmQtaW52YXJpYW50LWFyZ3NcblxuICAgIGZvciAodmFyIF9sZW4gPSBhcmd1bWVudHMubGVuZ3RoLCBhcmdzID0gQXJyYXkoX2xlbiA+IDIgPyBfbGVuIC0gMiA6IDApLCBfa2V5ID0gMjsgX2tleSA8IF9sZW47IF9rZXkrKykge1xuICAgICAgYXJnc1tfa2V5IC0gMl0gPSBhcmd1bWVudHNbX2tleV07XG4gICAgfVxuXG4gICAgd2FybmluZ1dpdGhvdXRTdGFjayQxLmFwcGx5KHVuZGVmaW5lZCwgW2ZhbHNlLCBmb3JtYXQgKyAnJXMnXS5jb25jYXQoYXJncywgW3N0YWNrXSkpO1xuICB9O1xufVxuXG52YXIgd2FybmluZyQxID0gd2FybmluZztcblxudmFyIEJFRk9SRV9TTEFTSF9SRSA9IC9eKC4qKVtcXFxcXFwvXS87XG5cbnZhciBkZXNjcmliZUNvbXBvbmVudEZyYW1lID0gZnVuY3Rpb24gKG5hbWUsIHNvdXJjZSwgb3duZXJOYW1lKSB7XG4gIHZhciBzb3VyY2VJbmZvID0gJyc7XG4gIGlmIChzb3VyY2UpIHtcbiAgICB2YXIgcGF0aCA9IHNvdXJjZS5maWxlTmFtZTtcbiAgICB2YXIgZmlsZU5hbWUgPSBwYXRoLnJlcGxhY2UoQkVGT1JFX1NMQVNIX1JFLCAnJyk7XG4gICAge1xuICAgICAgLy8gSW4gREVWLCBpbmNsdWRlIGNvZGUgZm9yIGEgY29tbW9uIHNwZWNpYWwgY2FzZTpcbiAgICAgIC8vIHByZWZlciBcImZvbGRlci9pbmRleC5qc1wiIGluc3RlYWQgb2YganVzdCBcImluZGV4LmpzXCIuXG4gICAgICBpZiAoL15pbmRleFxcLi8udGVzdChmaWxlTmFtZSkpIHtcbiAgICAgICAgdmFyIG1hdGNoID0gcGF0aC5tYXRjaChCRUZPUkVfU0xBU0hfUkUpO1xuICAgICAgICBpZiAobWF0Y2gpIHtcbiAgICAgICAgICB2YXIgcGF0aEJlZm9yZVNsYXNoID0gbWF0Y2hbMV07XG4gICAgICAgICAgaWYgKHBhdGhCZWZvcmVTbGFzaCkge1xuICAgICAgICAgICAgdmFyIGZvbGRlck5hbWUgPSBwYXRoQmVmb3JlU2xhc2gucmVwbGFjZShCRUZPUkVfU0xBU0hfUkUsICcnKTtcbiAgICAgICAgICAgIGZpbGVOYW1lID0gZm9sZGVyTmFtZSArICcvJyArIGZpbGVOYW1lO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgICBzb3VyY2VJbmZvID0gJyAoYXQgJyArIGZpbGVOYW1lICsgJzonICsgc291cmNlLmxpbmVOdW1iZXIgKyAnKSc7XG4gIH0gZWxzZSBpZiAob3duZXJOYW1lKSB7XG4gICAgc291cmNlSW5mbyA9ICcgKGNyZWF0ZWQgYnkgJyArIG93bmVyTmFtZSArICcpJztcbiAgfVxuICByZXR1cm4gJ1xcbiAgICBpbiAnICsgKG5hbWUgfHwgJ1Vua25vd24nKSArIHNvdXJjZUluZm87XG59O1xuXG4vLyBIZWxwcyBpZGVudGlmeSBzaWRlIGVmZmVjdHMgaW4gYmVnaW4tcGhhc2UgbGlmZWN5Y2xlIGhvb2tzIGFuZCBzZXRTdGF0ZSByZWR1Y2VyczpcblxuXG4vLyBJbiBzb21lIGNhc2VzLCBTdHJpY3RNb2RlIHNob3VsZCBhbHNvIGRvdWJsZS1yZW5kZXIgbGlmZWN5Y2xlcy5cbi8vIFRoaXMgY2FuIGJlIGNvbmZ1c2luZyBmb3IgdGVzdHMgdGhvdWdoLFxuLy8gQW5kIGl0IGNhbiBiZSBiYWQgZm9yIHBlcmZvcm1hbmNlIGluIHByb2R1Y3Rpb24uXG4vLyBUaGlzIGZlYXR1cmUgZmxhZyBjYW4gYmUgdXNlZCB0byBjb250cm9sIHRoZSBiZWhhdmlvcjpcblxuXG4vLyBUbyBwcmVzZXJ2ZSB0aGUgXCJQYXVzZSBvbiBjYXVnaHQgZXhjZXB0aW9uc1wiIGJlaGF2aW9yIG9mIHRoZSBkZWJ1Z2dlciwgd2Vcbi8vIHJlcGxheSB0aGUgYmVnaW4gcGhhc2Ugb2YgYSBmYWlsZWQgY29tcG9uZW50IGluc2lkZSBpbnZva2VHdWFyZGVkQ2FsbGJhY2suXG5cblxuLy8gV2FybiBhYm91dCBkZXByZWNhdGVkLCBhc3luYy11bnNhZmUgbGlmZWN5Y2xlczsgcmVsYXRlcyB0byBSRkMgIzY6XG52YXIgd2FybkFib3V0RGVwcmVjYXRlZExpZmVjeWNsZXMgPSBmYWxzZTtcblxuLy8gR2F0aGVyIGFkdmFuY2VkIHRpbWluZyBtZXRyaWNzIGZvciBQcm9maWxlciBzdWJ0cmVlcy5cblxuXG4vLyBUcmFjZSB3aGljaCBpbnRlcmFjdGlvbnMgdHJpZ2dlciBlYWNoIGNvbW1pdC5cblxuXG4vLyBPbmx5IHVzZWQgaW4gd3d3IGJ1aWxkcy5cbnZhciBlbmFibGVTdXNwZW5zZVNlcnZlclJlbmRlcmVyID0gZmFsc2U7IC8vIFRPRE86IHRydWU/IEhlcmUgaXQgbWlnaHQganVzdCBiZSBmYWxzZS5cblxuLy8gT25seSB1c2VkIGluIHd3dyBidWlsZHMuXG5cblxuLy8gT25seSB1c2VkIGluIHd3dyBidWlsZHMuXG5cblxuLy8gUmVhY3QgRmlyZTogcHJldmVudCB0aGUgdmFsdWUgYW5kIGNoZWNrZWQgYXR0cmlidXRlcyBmcm9tIHN5bmNpbmdcbi8vIHdpdGggdGhlaXIgcmVsYXRlZCBET00gcHJvcGVydGllc1xuXG5cbi8vIFRoZXNlIEFQSXMgd2lsbCBubyBsb25nZXIgYmUgXCJ1bnN0YWJsZVwiIGluIHRoZSB1cGNvbWluZyAxNi43IHJlbGVhc2UsXG4vLyBDb250cm9sIHRoaXMgYmVoYXZpb3Igd2l0aCBhIGZsYWcgdG8gc3VwcG9ydCAxNi42IG1pbm9yIHJlbGVhc2VzIGluIHRoZSBtZWFud2hpbGUuXG5cbnZhciBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDEgPSB2b2lkIDA7XG57XG4gIFJlYWN0RGVidWdDdXJyZW50RnJhbWUkMSA9IFJlYWN0U2hhcmVkSW50ZXJuYWxzLlJlYWN0RGVidWdDdXJyZW50RnJhbWU7XG59XG5cbnZhciBkaWRXYXJuQWJvdXRJbnZhbGlkYXRlQ29udGV4dFR5cGUgPSB7fTtcblxudmFyIGVtcHR5T2JqZWN0ID0ge307XG57XG4gIE9iamVjdC5mcmVlemUoZW1wdHlPYmplY3QpO1xufVxuXG5mdW5jdGlvbiBtYXNrQ29udGV4dCh0eXBlLCBjb250ZXh0KSB7XG4gIHZhciBjb250ZXh0VHlwZXMgPSB0eXBlLmNvbnRleHRUeXBlcztcbiAgaWYgKCFjb250ZXh0VHlwZXMpIHtcbiAgICByZXR1cm4gZW1wdHlPYmplY3Q7XG4gIH1cbiAgdmFyIG1hc2tlZENvbnRleHQgPSB7fTtcbiAgZm9yICh2YXIgY29udGV4dE5hbWUgaW4gY29udGV4dFR5cGVzKSB7XG4gICAgbWFza2VkQ29udGV4dFtjb250ZXh0TmFtZV0gPSBjb250ZXh0W2NvbnRleHROYW1lXTtcbiAgfVxuICByZXR1cm4gbWFza2VkQ29udGV4dDtcbn1cblxuZnVuY3Rpb24gY2hlY2tDb250ZXh0VHlwZXModHlwZVNwZWNzLCB2YWx1ZXMsIGxvY2F0aW9uKSB7XG4gIHtcbiAgICBjaGVja1Byb3BUeXBlcyh0eXBlU3BlY3MsIHZhbHVlcywgbG9jYXRpb24sICdDb21wb25lbnQnLCBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDEuZ2V0Q3VycmVudFN0YWNrKTtcbiAgfVxufVxuXG5mdW5jdGlvbiB2YWxpZGF0ZUNvbnRleHRCb3VuZHMoY29udGV4dCwgdGhyZWFkSUQpIHtcbiAgLy8gSWYgd2UgZG9uJ3QgaGF2ZSBlbm91Z2ggc2xvdHMgaW4gdGhpcyBjb250ZXh0IHRvIHN0b3JlIHRoaXMgdGhyZWFkSUQsXG4gIC8vIGZpbGwgaXQgaW4gd2l0aG91dCBsZWF2aW5nIGFueSBob2xlcyB0byBlbnN1cmUgdGhhdCB0aGUgVk0gb3B0aW1pemVzXG4gIC8vIHRoaXMgYXMgbm9uLWhvbGV5IGluZGV4IHByb3BlcnRpZXMuXG4gIC8vIChOb3RlOiBJZiBgcmVhY3RgIHBhY2thZ2UgaXMgPCAxNi42LCBfdGhyZWFkQ291bnQgaXMgdW5kZWZpbmVkLilcbiAgZm9yICh2YXIgaSA9IGNvbnRleHQuX3RocmVhZENvdW50IHwgMDsgaSA8PSB0aHJlYWRJRDsgaSsrKSB7XG4gICAgLy8gV2UgYXNzdW1lIHRoYXQgdGhpcyBpcyB0aGUgc2FtZSBhcyB0aGUgZGVmYXVsdFZhbHVlIHdoaWNoIG1pZ2h0IG5vdCBiZVxuICAgIC8vIHRydWUgaWYgd2UncmUgcmVuZGVyaW5nIGluc2lkZSBhIHNlY29uZGFyeSByZW5kZXJlciBidXQgdGhleSBhcmVcbiAgICAvLyBzZWNvbmRhcnkgYmVjYXVzZSB0aGVzZSB1c2UgY2FzZXMgYXJlIHZlcnkgcmFyZS5cbiAgICBjb250ZXh0W2ldID0gY29udGV4dC5fY3VycmVudFZhbHVlMjtcbiAgICBjb250ZXh0Ll90aHJlYWRDb3VudCA9IGkgKyAxO1xuICB9XG59XG5cbmZ1bmN0aW9uIHByb2Nlc3NDb250ZXh0KHR5cGUsIGNvbnRleHQsIHRocmVhZElEKSB7XG4gIHZhciBjb250ZXh0VHlwZSA9IHR5cGUuY29udGV4dFR5cGU7XG4gIGlmICh0eXBlb2YgY29udGV4dFR5cGUgPT09ICdvYmplY3QnICYmIGNvbnRleHRUeXBlICE9PSBudWxsKSB7XG4gICAge1xuICAgICAgaWYgKGNvbnRleHRUeXBlLiQkdHlwZW9mICE9PSBSRUFDVF9DT05URVhUX1RZUEUpIHtcbiAgICAgICAgdmFyIG5hbWUgPSBnZXRDb21wb25lbnROYW1lKHR5cGUpIHx8ICdDb21wb25lbnQnO1xuICAgICAgICBpZiAoIWRpZFdhcm5BYm91dEludmFsaWRhdGVDb250ZXh0VHlwZVtuYW1lXSkge1xuICAgICAgICAgIGRpZFdhcm5BYm91dEludmFsaWRhdGVDb250ZXh0VHlwZVtuYW1lXSA9IHRydWU7XG4gICAgICAgICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnJXMgZGVmaW5lcyBhbiBpbnZhbGlkIGNvbnRleHRUeXBlLiAnICsgJ2NvbnRleHRUeXBlIHNob3VsZCBwb2ludCB0byB0aGUgQ29udGV4dCBvYmplY3QgcmV0dXJuZWQgYnkgUmVhY3QuY3JlYXRlQ29udGV4dCgpLiAnICsgJ0RpZCB5b3UgYWNjaWRlbnRhbGx5IHBhc3MgdGhlIENvbnRleHQuUHJvdmlkZXIgaW5zdGVhZD8nLCBuYW1lKTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgICB2YWxpZGF0ZUNvbnRleHRCb3VuZHMoY29udGV4dFR5cGUsIHRocmVhZElEKTtcbiAgICByZXR1cm4gY29udGV4dFR5cGVbdGhyZWFkSURdO1xuICB9IGVsc2Uge1xuICAgIHZhciBtYXNrZWRDb250ZXh0ID0gbWFza0NvbnRleHQodHlwZSwgY29udGV4dCk7XG4gICAge1xuICAgICAgaWYgKHR5cGUuY29udGV4dFR5cGVzKSB7XG4gICAgICAgIGNoZWNrQ29udGV4dFR5cGVzKHR5cGUuY29udGV4dFR5cGVzLCBtYXNrZWRDb250ZXh0LCAnY29udGV4dCcpO1xuICAgICAgfVxuICAgIH1cbiAgICByZXR1cm4gbWFza2VkQ29udGV4dDtcbiAgfVxufVxuXG4vLyBBbGxvY2F0ZXMgYSBuZXcgaW5kZXggZm9yIGVhY2ggcmVxdWVzdC4gVHJpZXMgdG8gc3RheSBhcyBjb21wYWN0IGFzIHBvc3NpYmxlIHNvIHRoYXQgdGhlc2Vcbi8vIGluZGljZXMgY2FuIGJlIHVzZWQgdG8gcmVmZXJlbmNlIGEgdGlnaHRseSBwYWNrYWdlZCBhcnJheS4gQXMgb3Bwb3NlZCB0byBiZWluZyB1c2VkIGluIGEgTWFwLlxuLy8gVGhlIGZpcnN0IGFsbG9jYXRlZCBpbmRleCBpcyAxLlxuXG52YXIgbmV4dEF2YWlsYWJsZVRocmVhZElEcyA9IG5ldyBVaW50MTZBcnJheSgxNik7XG5mb3IgKHZhciBpID0gMDsgaSA8IDE1OyBpKyspIHtcbiAgbmV4dEF2YWlsYWJsZVRocmVhZElEc1tpXSA9IGkgKyAxO1xufVxubmV4dEF2YWlsYWJsZVRocmVhZElEc1sxNV0gPSAwO1xuXG5mdW5jdGlvbiBncm93VGhyZWFkQ291bnRBbmRSZXR1cm5OZXh0QXZhaWxhYmxlKCkge1xuICB2YXIgb2xkQXJyYXkgPSBuZXh0QXZhaWxhYmxlVGhyZWFkSURzO1xuICB2YXIgb2xkU2l6ZSA9IG9sZEFycmF5Lmxlbmd0aDtcbiAgdmFyIG5ld1NpemUgPSBvbGRTaXplICogMjtcbiAgIShuZXdTaXplIDw9IDB4MTAwMDApID8gaW52YXJpYW50KGZhbHNlLCAnTWF4aW11bSBudW1iZXIgb2YgY29uY3VycmVudCBSZWFjdCByZW5kZXJlcnMgZXhjZWVkZWQuIFRoaXMgY2FuIGhhcHBlbiBpZiB5b3UgYXJlIG5vdCBwcm9wZXJseSBkZXN0cm95aW5nIHRoZSBSZWFkYWJsZSBwcm92aWRlZCBieSBSZWFjdC4gRW5zdXJlIHRoYXQgeW91IGNhbGwgLmRlc3Ryb3koKSBvbiBpdCBpZiB5b3Ugbm8gbG9uZ2VyIHdhbnQgdG8gcmVhZCBmcm9tIGl0LCBhbmQgZGlkIG5vdCByZWFkIHRvIHRoZSBlbmQuIElmIHlvdSB1c2UgLnBpcGUoKSB0aGlzIHNob3VsZCBiZSBhdXRvbWF0aWMuJykgOiB2b2lkIDA7XG4gIHZhciBuZXdBcnJheSA9IG5ldyBVaW50MTZBcnJheShuZXdTaXplKTtcbiAgbmV3QXJyYXkuc2V0KG9sZEFycmF5KTtcbiAgbmV4dEF2YWlsYWJsZVRocmVhZElEcyA9IG5ld0FycmF5O1xuICBuZXh0QXZhaWxhYmxlVGhyZWFkSURzWzBdID0gb2xkU2l6ZSArIDE7XG4gIGZvciAodmFyIF9pID0gb2xkU2l6ZTsgX2kgPCBuZXdTaXplIC0gMTsgX2krKykge1xuICAgIG5leHRBdmFpbGFibGVUaHJlYWRJRHNbX2ldID0gX2kgKyAxO1xuICB9XG4gIG5leHRBdmFpbGFibGVUaHJlYWRJRHNbbmV3U2l6ZSAtIDFdID0gMDtcbiAgcmV0dXJuIG9sZFNpemU7XG59XG5cbmZ1bmN0aW9uIGFsbG9jVGhyZWFkSUQoKSB7XG4gIHZhciBuZXh0SUQgPSBuZXh0QXZhaWxhYmxlVGhyZWFkSURzWzBdO1xuICBpZiAobmV4dElEID09PSAwKSB7XG4gICAgcmV0dXJuIGdyb3dUaHJlYWRDb3VudEFuZFJldHVybk5leHRBdmFpbGFibGUoKTtcbiAgfVxuICBuZXh0QXZhaWxhYmxlVGhyZWFkSURzWzBdID0gbmV4dEF2YWlsYWJsZVRocmVhZElEc1tuZXh0SURdO1xuICByZXR1cm4gbmV4dElEO1xufVxuXG5mdW5jdGlvbiBmcmVlVGhyZWFkSUQoaWQpIHtcbiAgbmV4dEF2YWlsYWJsZVRocmVhZElEc1tpZF0gPSBuZXh0QXZhaWxhYmxlVGhyZWFkSURzWzBdO1xuICBuZXh0QXZhaWxhYmxlVGhyZWFkSURzWzBdID0gaWQ7XG59XG5cbi8vIEEgcmVzZXJ2ZWQgYXR0cmlidXRlLlxuLy8gSXQgaXMgaGFuZGxlZCBieSBSZWFjdCBzZXBhcmF0ZWx5IGFuZCBzaG91bGRuJ3QgYmUgd3JpdHRlbiB0byB0aGUgRE9NLlxudmFyIFJFU0VSVkVEID0gMDtcblxuLy8gQSBzaW1wbGUgc3RyaW5nIGF0dHJpYnV0ZS5cbi8vIEF0dHJpYnV0ZXMgdGhhdCBhcmVuJ3QgaW4gdGhlIHdoaXRlbGlzdCBhcmUgcHJlc3VtZWQgdG8gaGF2ZSB0aGlzIHR5cGUuXG52YXIgU1RSSU5HID0gMTtcblxuLy8gQSBzdHJpbmcgYXR0cmlidXRlIHRoYXQgYWNjZXB0cyBib29sZWFucyBpbiBSZWFjdC4gSW4gSFRNTCwgdGhlc2UgYXJlIGNhbGxlZFxuLy8gXCJlbnVtZXJhdGVkXCIgYXR0cmlidXRlcyB3aXRoIFwidHJ1ZVwiIGFuZCBcImZhbHNlXCIgYXMgcG9zc2libGUgdmFsdWVzLlxuLy8gV2hlbiB0cnVlLCBpdCBzaG91bGQgYmUgc2V0IHRvIGEgXCJ0cnVlXCIgc3RyaW5nLlxuLy8gV2hlbiBmYWxzZSwgaXQgc2hvdWxkIGJlIHNldCB0byBhIFwiZmFsc2VcIiBzdHJpbmcuXG52YXIgQk9PTEVBTklTSF9TVFJJTkcgPSAyO1xuXG4vLyBBIHJlYWwgYm9vbGVhbiBhdHRyaWJ1dGUuXG4vLyBXaGVuIHRydWUsIGl0IHNob3VsZCBiZSBwcmVzZW50IChzZXQgZWl0aGVyIHRvIGFuIGVtcHR5IHN0cmluZyBvciBpdHMgbmFtZSkuXG4vLyBXaGVuIGZhbHNlLCBpdCBzaG91bGQgYmUgb21pdHRlZC5cbnZhciBCT09MRUFOID0gMztcblxuLy8gQW4gYXR0cmlidXRlIHRoYXQgY2FuIGJlIHVzZWQgYXMgYSBmbGFnIGFzIHdlbGwgYXMgd2l0aCBhIHZhbHVlLlxuLy8gV2hlbiB0cnVlLCBpdCBzaG91bGQgYmUgcHJlc2VudCAoc2V0IGVpdGhlciB0byBhbiBlbXB0eSBzdHJpbmcgb3IgaXRzIG5hbWUpLlxuLy8gV2hlbiBmYWxzZSwgaXQgc2hvdWxkIGJlIG9taXR0ZWQuXG4vLyBGb3IgYW55IG90aGVyIHZhbHVlLCBzaG91bGQgYmUgcHJlc2VudCB3aXRoIHRoYXQgdmFsdWUuXG52YXIgT1ZFUkxPQURFRF9CT09MRUFOID0gNDtcblxuLy8gQW4gYXR0cmlidXRlIHRoYXQgbXVzdCBiZSBudW1lcmljIG9yIHBhcnNlIGFzIGEgbnVtZXJpYy5cbi8vIFdoZW4gZmFsc3ksIGl0IHNob3VsZCBiZSByZW1vdmVkLlxudmFyIE5VTUVSSUMgPSA1O1xuXG4vLyBBbiBhdHRyaWJ1dGUgdGhhdCBtdXN0IGJlIHBvc2l0aXZlIG51bWVyaWMgb3IgcGFyc2UgYXMgYSBwb3NpdGl2ZSBudW1lcmljLlxuLy8gV2hlbiBmYWxzeSwgaXQgc2hvdWxkIGJlIHJlbW92ZWQuXG52YXIgUE9TSVRJVkVfTlVNRVJJQyA9IDY7XG5cbi8qIGVzbGludC1kaXNhYmxlIG1heC1sZW4gKi9cbnZhciBBVFRSSUJVVEVfTkFNRV9TVEFSVF9DSEFSID0gJzpBLVpfYS16XFxcXHUwMEMwLVxcXFx1MDBENlxcXFx1MDBEOC1cXFxcdTAwRjZcXFxcdTAwRjgtXFxcXHUwMkZGXFxcXHUwMzcwLVxcXFx1MDM3RFxcXFx1MDM3Ri1cXFxcdTFGRkZcXFxcdTIwMEMtXFxcXHUyMDBEXFxcXHUyMDcwLVxcXFx1MjE4RlxcXFx1MkMwMC1cXFxcdTJGRUZcXFxcdTMwMDEtXFxcXHVEN0ZGXFxcXHVGOTAwLVxcXFx1RkRDRlxcXFx1RkRGMC1cXFxcdUZGRkQnO1xuLyogZXNsaW50LWVuYWJsZSBtYXgtbGVuICovXG52YXIgQVRUUklCVVRFX05BTUVfQ0hBUiA9IEFUVFJJQlVURV9OQU1FX1NUQVJUX0NIQVIgKyAnXFxcXC0uMC05XFxcXHUwMEI3XFxcXHUwMzAwLVxcXFx1MDM2RlxcXFx1MjAzRi1cXFxcdTIwNDAnO1xuXG5cbnZhciBST09UX0FUVFJJQlVURV9OQU1FID0gJ2RhdGEtcmVhY3Ryb290JztcbnZhciBWQUxJRF9BVFRSSUJVVEVfTkFNRV9SRUdFWCA9IG5ldyBSZWdFeHAoJ15bJyArIEFUVFJJQlVURV9OQU1FX1NUQVJUX0NIQVIgKyAnXVsnICsgQVRUUklCVVRFX05BTUVfQ0hBUiArICddKiQnKTtcblxudmFyIGhhc093blByb3BlcnR5JDEgPSBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5O1xudmFyIGlsbGVnYWxBdHRyaWJ1dGVOYW1lQ2FjaGUgPSB7fTtcbnZhciB2YWxpZGF0ZWRBdHRyaWJ1dGVOYW1lQ2FjaGUgPSB7fTtcblxuZnVuY3Rpb24gaXNBdHRyaWJ1dGVOYW1lU2FmZShhdHRyaWJ1dGVOYW1lKSB7XG4gIGlmIChoYXNPd25Qcm9wZXJ0eSQxLmNhbGwodmFsaWRhdGVkQXR0cmlidXRlTmFtZUNhY2hlLCBhdHRyaWJ1dGVOYW1lKSkge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG4gIGlmIChoYXNPd25Qcm9wZXJ0eSQxLmNhbGwoaWxsZWdhbEF0dHJpYnV0ZU5hbWVDYWNoZSwgYXR0cmlidXRlTmFtZSkpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cbiAgaWYgKFZBTElEX0FUVFJJQlVURV9OQU1FX1JFR0VYLnRlc3QoYXR0cmlidXRlTmFtZSkpIHtcbiAgICB2YWxpZGF0ZWRBdHRyaWJ1dGVOYW1lQ2FjaGVbYXR0cmlidXRlTmFtZV0gPSB0cnVlO1xuICAgIHJldHVybiB0cnVlO1xuICB9XG4gIGlsbGVnYWxBdHRyaWJ1dGVOYW1lQ2FjaGVbYXR0cmlidXRlTmFtZV0gPSB0cnVlO1xuICB7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnSW52YWxpZCBhdHRyaWJ1dGUgbmFtZTogYCVzYCcsIGF0dHJpYnV0ZU5hbWUpO1xuICB9XG4gIHJldHVybiBmYWxzZTtcbn1cblxuZnVuY3Rpb24gc2hvdWxkSWdub3JlQXR0cmlidXRlKG5hbWUsIHByb3BlcnR5SW5mbywgaXNDdXN0b21Db21wb25lbnRUYWcpIHtcbiAgaWYgKHByb3BlcnR5SW5mbyAhPT0gbnVsbCkge1xuICAgIHJldHVybiBwcm9wZXJ0eUluZm8udHlwZSA9PT0gUkVTRVJWRUQ7XG4gIH1cbiAgaWYgKGlzQ3VzdG9tQ29tcG9uZW50VGFnKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG4gIGlmIChuYW1lLmxlbmd0aCA+IDIgJiYgKG5hbWVbMF0gPT09ICdvJyB8fCBuYW1lWzBdID09PSAnTycpICYmIChuYW1lWzFdID09PSAnbicgfHwgbmFtZVsxXSA9PT0gJ04nKSkge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG4gIHJldHVybiBmYWxzZTtcbn1cblxuZnVuY3Rpb24gc2hvdWxkUmVtb3ZlQXR0cmlidXRlV2l0aFdhcm5pbmcobmFtZSwgdmFsdWUsIHByb3BlcnR5SW5mbywgaXNDdXN0b21Db21wb25lbnRUYWcpIHtcbiAgaWYgKHByb3BlcnR5SW5mbyAhPT0gbnVsbCAmJiBwcm9wZXJ0eUluZm8udHlwZSA9PT0gUkVTRVJWRUQpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cbiAgc3dpdGNoICh0eXBlb2YgdmFsdWUpIHtcbiAgICBjYXNlICdmdW5jdGlvbic6XG4gICAgLy8gJEZsb3dJc3N1ZSBzeW1ib2wgaXMgcGVyZmVjdGx5IHZhbGlkIGhlcmVcbiAgICBjYXNlICdzeW1ib2wnOlxuICAgICAgLy8gZXNsaW50LWRpc2FibGUtbGluZVxuICAgICAgcmV0dXJuIHRydWU7XG4gICAgY2FzZSAnYm9vbGVhbic6XG4gICAgICB7XG4gICAgICAgIGlmIChpc0N1c3RvbUNvbXBvbmVudFRhZykge1xuICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgfVxuICAgICAgICBpZiAocHJvcGVydHlJbmZvICE9PSBudWxsKSB7XG4gICAgICAgICAgcmV0dXJuICFwcm9wZXJ0eUluZm8uYWNjZXB0c0Jvb2xlYW5zO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHZhciBwcmVmaXggPSBuYW1lLnRvTG93ZXJDYXNlKCkuc2xpY2UoMCwgNSk7XG4gICAgICAgICAgcmV0dXJuIHByZWZpeCAhPT0gJ2RhdGEtJyAmJiBwcmVmaXggIT09ICdhcmlhLSc7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICBkZWZhdWx0OlxuICAgICAgcmV0dXJuIGZhbHNlO1xuICB9XG59XG5cbmZ1bmN0aW9uIHNob3VsZFJlbW92ZUF0dHJpYnV0ZShuYW1lLCB2YWx1ZSwgcHJvcGVydHlJbmZvLCBpc0N1c3RvbUNvbXBvbmVudFRhZykge1xuICBpZiAodmFsdWUgPT09IG51bGwgfHwgdHlwZW9mIHZhbHVlID09PSAndW5kZWZpbmVkJykge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG4gIGlmIChzaG91bGRSZW1vdmVBdHRyaWJ1dGVXaXRoV2FybmluZyhuYW1lLCB2YWx1ZSwgcHJvcGVydHlJbmZvLCBpc0N1c3RvbUNvbXBvbmVudFRhZykpIHtcbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuICBpZiAoaXNDdXN0b21Db21wb25lbnRUYWcpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cbiAgaWYgKHByb3BlcnR5SW5mbyAhPT0gbnVsbCkge1xuICAgIHN3aXRjaCAocHJvcGVydHlJbmZvLnR5cGUpIHtcbiAgICAgIGNhc2UgQk9PTEVBTjpcbiAgICAgICAgcmV0dXJuICF2YWx1ZTtcbiAgICAgIGNhc2UgT1ZFUkxPQURFRF9CT09MRUFOOlxuICAgICAgICByZXR1cm4gdmFsdWUgPT09IGZhbHNlO1xuICAgICAgY2FzZSBOVU1FUklDOlxuICAgICAgICByZXR1cm4gaXNOYU4odmFsdWUpO1xuICAgICAgY2FzZSBQT1NJVElWRV9OVU1FUklDOlxuICAgICAgICByZXR1cm4gaXNOYU4odmFsdWUpIHx8IHZhbHVlIDwgMTtcbiAgICB9XG4gIH1cbiAgcmV0dXJuIGZhbHNlO1xufVxuXG5mdW5jdGlvbiBnZXRQcm9wZXJ0eUluZm8obmFtZSkge1xuICByZXR1cm4gcHJvcGVydGllcy5oYXNPd25Qcm9wZXJ0eShuYW1lKSA/IHByb3BlcnRpZXNbbmFtZV0gOiBudWxsO1xufVxuXG5mdW5jdGlvbiBQcm9wZXJ0eUluZm9SZWNvcmQobmFtZSwgdHlwZSwgbXVzdFVzZVByb3BlcnR5LCBhdHRyaWJ1dGVOYW1lLCBhdHRyaWJ1dGVOYW1lc3BhY2UpIHtcbiAgdGhpcy5hY2NlcHRzQm9vbGVhbnMgPSB0eXBlID09PSBCT09MRUFOSVNIX1NUUklORyB8fCB0eXBlID09PSBCT09MRUFOIHx8IHR5cGUgPT09IE9WRVJMT0FERURfQk9PTEVBTjtcbiAgdGhpcy5hdHRyaWJ1dGVOYW1lID0gYXR0cmlidXRlTmFtZTtcbiAgdGhpcy5hdHRyaWJ1dGVOYW1lc3BhY2UgPSBhdHRyaWJ1dGVOYW1lc3BhY2U7XG4gIHRoaXMubXVzdFVzZVByb3BlcnR5ID0gbXVzdFVzZVByb3BlcnR5O1xuICB0aGlzLnByb3BlcnR5TmFtZSA9IG5hbWU7XG4gIHRoaXMudHlwZSA9IHR5cGU7XG59XG5cbi8vIFdoZW4gYWRkaW5nIGF0dHJpYnV0ZXMgdG8gdGhpcyBsaXN0LCBiZSBzdXJlIHRvIGFsc28gYWRkIHRoZW0gdG9cbi8vIHRoZSBgcG9zc2libGVTdGFuZGFyZE5hbWVzYCBtb2R1bGUgdG8gZW5zdXJlIGNhc2luZyBhbmQgaW5jb3JyZWN0XG4vLyBuYW1lIHdhcm5pbmdzLlxudmFyIHByb3BlcnRpZXMgPSB7fTtcblxuLy8gVGhlc2UgcHJvcHMgYXJlIHJlc2VydmVkIGJ5IFJlYWN0LiBUaGV5IHNob3VsZG4ndCBiZSB3cml0dGVuIHRvIHRoZSBET00uXG5bJ2NoaWxkcmVuJywgJ2Rhbmdlcm91c2x5U2V0SW5uZXJIVE1MJyxcbi8vIFRPRE86IFRoaXMgcHJldmVudHMgdGhlIGFzc2lnbm1lbnQgb2YgZGVmYXVsdFZhbHVlIHRvIHJlZ3VsYXJcbi8vIGVsZW1lbnRzIChub3QganVzdCBpbnB1dHMpLiBOb3cgdGhhdCBSZWFjdERPTUlucHV0IGFzc2lnbnMgdG8gdGhlXG4vLyBkZWZhdWx0VmFsdWUgcHJvcGVydHkgLS0gZG8gd2UgbmVlZCB0aGlzP1xuJ2RlZmF1bHRWYWx1ZScsICdkZWZhdWx0Q2hlY2tlZCcsICdpbm5lckhUTUwnLCAnc3VwcHJlc3NDb250ZW50RWRpdGFibGVXYXJuaW5nJywgJ3N1cHByZXNzSHlkcmF0aW9uV2FybmluZycsICdzdHlsZSddLmZvckVhY2goZnVuY3Rpb24gKG5hbWUpIHtcbiAgcHJvcGVydGllc1tuYW1lXSA9IG5ldyBQcm9wZXJ0eUluZm9SZWNvcmQobmFtZSwgUkVTRVJWRUQsIGZhbHNlLCAvLyBtdXN0VXNlUHJvcGVydHlcbiAgbmFtZSwgLy8gYXR0cmlidXRlTmFtZVxuICBudWxsKTtcbn0gLy8gYXR0cmlidXRlTmFtZXNwYWNlXG4pO1xuXG4vLyBBIGZldyBSZWFjdCBzdHJpbmcgYXR0cmlidXRlcyBoYXZlIGEgZGlmZmVyZW50IG5hbWUuXG4vLyBUaGlzIGlzIGEgbWFwcGluZyBmcm9tIFJlYWN0IHByb3AgbmFtZXMgdG8gdGhlIGF0dHJpYnV0ZSBuYW1lcy5cbltbJ2FjY2VwdENoYXJzZXQnLCAnYWNjZXB0LWNoYXJzZXQnXSwgWydjbGFzc05hbWUnLCAnY2xhc3MnXSwgWydodG1sRm9yJywgJ2ZvciddLCBbJ2h0dHBFcXVpdicsICdodHRwLWVxdWl2J11dLmZvckVhY2goZnVuY3Rpb24gKF9yZWYpIHtcbiAgdmFyIG5hbWUgPSBfcmVmWzBdLFxuICAgICAgYXR0cmlidXRlTmFtZSA9IF9yZWZbMV07XG5cbiAgcHJvcGVydGllc1tuYW1lXSA9IG5ldyBQcm9wZXJ0eUluZm9SZWNvcmQobmFtZSwgU1RSSU5HLCBmYWxzZSwgLy8gbXVzdFVzZVByb3BlcnR5XG4gIGF0dHJpYnV0ZU5hbWUsIC8vIGF0dHJpYnV0ZU5hbWVcbiAgbnVsbCk7XG59IC8vIGF0dHJpYnV0ZU5hbWVzcGFjZVxuKTtcblxuLy8gVGhlc2UgYXJlIFwiZW51bWVyYXRlZFwiIEhUTUwgYXR0cmlidXRlcyB0aGF0IGFjY2VwdCBcInRydWVcIiBhbmQgXCJmYWxzZVwiLlxuLy8gSW4gUmVhY3QsIHdlIGxldCB1c2VycyBwYXNzIGB0cnVlYCBhbmQgYGZhbHNlYCBldmVuIHRob3VnaCB0ZWNobmljYWxseVxuLy8gdGhlc2UgYXJlbid0IGJvb2xlYW4gYXR0cmlidXRlcyAodGhleSBhcmUgY29lcmNlZCB0byBzdHJpbmdzKS5cblsnY29udGVudEVkaXRhYmxlJywgJ2RyYWdnYWJsZScsICdzcGVsbENoZWNrJywgJ3ZhbHVlJ10uZm9yRWFjaChmdW5jdGlvbiAobmFtZSkge1xuICBwcm9wZXJ0aWVzW25hbWVdID0gbmV3IFByb3BlcnR5SW5mb1JlY29yZChuYW1lLCBCT09MRUFOSVNIX1NUUklORywgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBuYW1lLnRvTG93ZXJDYXNlKCksIC8vIGF0dHJpYnV0ZU5hbWVcbiAgbnVsbCk7XG59IC8vIGF0dHJpYnV0ZU5hbWVzcGFjZVxuKTtcblxuLy8gVGhlc2UgYXJlIFwiZW51bWVyYXRlZFwiIFNWRyBhdHRyaWJ1dGVzIHRoYXQgYWNjZXB0IFwidHJ1ZVwiIGFuZCBcImZhbHNlXCIuXG4vLyBJbiBSZWFjdCwgd2UgbGV0IHVzZXJzIHBhc3MgYHRydWVgIGFuZCBgZmFsc2VgIGV2ZW4gdGhvdWdoIHRlY2huaWNhbGx5XG4vLyB0aGVzZSBhcmVuJ3QgYm9vbGVhbiBhdHRyaWJ1dGVzICh0aGV5IGFyZSBjb2VyY2VkIHRvIHN0cmluZ3MpLlxuLy8gU2luY2UgdGhlc2UgYXJlIFNWRyBhdHRyaWJ1dGVzLCB0aGVpciBhdHRyaWJ1dGUgbmFtZXMgYXJlIGNhc2Utc2Vuc2l0aXZlLlxuWydhdXRvUmV2ZXJzZScsICdleHRlcm5hbFJlc291cmNlc1JlcXVpcmVkJywgJ2ZvY3VzYWJsZScsICdwcmVzZXJ2ZUFscGhhJ10uZm9yRWFjaChmdW5jdGlvbiAobmFtZSkge1xuICBwcm9wZXJ0aWVzW25hbWVdID0gbmV3IFByb3BlcnR5SW5mb1JlY29yZChuYW1lLCBCT09MRUFOSVNIX1NUUklORywgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBuYW1lLCAvLyBhdHRyaWJ1dGVOYW1lXG4gIG51bGwpO1xufSAvLyBhdHRyaWJ1dGVOYW1lc3BhY2Vcbik7XG5cbi8vIFRoZXNlIGFyZSBIVE1MIGJvb2xlYW4gYXR0cmlidXRlcy5cblsnYWxsb3dGdWxsU2NyZWVuJywgJ2FzeW5jJyxcbi8vIE5vdGU6IHRoZXJlIGlzIGEgc3BlY2lhbCBjYXNlIHRoYXQgcHJldmVudHMgaXQgZnJvbSBiZWluZyB3cml0dGVuIHRvIHRoZSBET01cbi8vIG9uIHRoZSBjbGllbnQgc2lkZSBiZWNhdXNlIHRoZSBicm93c2VycyBhcmUgaW5jb25zaXN0ZW50LiBJbnN0ZWFkIHdlIGNhbGwgZm9jdXMoKS5cbidhdXRvRm9jdXMnLCAnYXV0b1BsYXknLCAnY29udHJvbHMnLCAnZGVmYXVsdCcsICdkZWZlcicsICdkaXNhYmxlZCcsICdmb3JtTm9WYWxpZGF0ZScsICdoaWRkZW4nLCAnbG9vcCcsICdub01vZHVsZScsICdub1ZhbGlkYXRlJywgJ29wZW4nLCAncGxheXNJbmxpbmUnLCAncmVhZE9ubHknLCAncmVxdWlyZWQnLCAncmV2ZXJzZWQnLCAnc2NvcGVkJywgJ3NlYW1sZXNzJyxcbi8vIE1pY3JvZGF0YVxuJ2l0ZW1TY29wZSddLmZvckVhY2goZnVuY3Rpb24gKG5hbWUpIHtcbiAgcHJvcGVydGllc1tuYW1lXSA9IG5ldyBQcm9wZXJ0eUluZm9SZWNvcmQobmFtZSwgQk9PTEVBTiwgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBuYW1lLnRvTG93ZXJDYXNlKCksIC8vIGF0dHJpYnV0ZU5hbWVcbiAgbnVsbCk7XG59IC8vIGF0dHJpYnV0ZU5hbWVzcGFjZVxuKTtcblxuLy8gVGhlc2UgYXJlIHRoZSBmZXcgUmVhY3QgcHJvcHMgdGhhdCB3ZSBzZXQgYXMgRE9NIHByb3BlcnRpZXNcbi8vIHJhdGhlciB0aGFuIGF0dHJpYnV0ZXMuIFRoZXNlIGFyZSBhbGwgYm9vbGVhbnMuXG5bJ2NoZWNrZWQnLFxuLy8gTm90ZTogYG9wdGlvbi5zZWxlY3RlZGAgaXMgbm90IHVwZGF0ZWQgaWYgYHNlbGVjdC5tdWx0aXBsZWAgaXNcbi8vIGRpc2FibGVkIHdpdGggYHJlbW92ZUF0dHJpYnV0ZWAuIFdlIGhhdmUgc3BlY2lhbCBsb2dpYyBmb3IgaGFuZGxpbmcgdGhpcy5cbidtdWx0aXBsZScsICdtdXRlZCcsICdzZWxlY3RlZCddLmZvckVhY2goZnVuY3Rpb24gKG5hbWUpIHtcbiAgcHJvcGVydGllc1tuYW1lXSA9IG5ldyBQcm9wZXJ0eUluZm9SZWNvcmQobmFtZSwgQk9PTEVBTiwgdHJ1ZSwgLy8gbXVzdFVzZVByb3BlcnR5XG4gIG5hbWUsIC8vIGF0dHJpYnV0ZU5hbWVcbiAgbnVsbCk7XG59IC8vIGF0dHJpYnV0ZU5hbWVzcGFjZVxuKTtcblxuLy8gVGhlc2UgYXJlIEhUTUwgYXR0cmlidXRlcyB0aGF0IGFyZSBcIm92ZXJsb2FkZWQgYm9vbGVhbnNcIjogdGhleSBiZWhhdmUgbGlrZVxuLy8gYm9vbGVhbnMsIGJ1dCBjYW4gYWxzbyBhY2NlcHQgYSBzdHJpbmcgdmFsdWUuXG5bJ2NhcHR1cmUnLCAnZG93bmxvYWQnXS5mb3JFYWNoKGZ1bmN0aW9uIChuYW1lKSB7XG4gIHByb3BlcnRpZXNbbmFtZV0gPSBuZXcgUHJvcGVydHlJbmZvUmVjb3JkKG5hbWUsIE9WRVJMT0FERURfQk9PTEVBTiwgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBuYW1lLCAvLyBhdHRyaWJ1dGVOYW1lXG4gIG51bGwpO1xufSAvLyBhdHRyaWJ1dGVOYW1lc3BhY2Vcbik7XG5cbi8vIFRoZXNlIGFyZSBIVE1MIGF0dHJpYnV0ZXMgdGhhdCBtdXN0IGJlIHBvc2l0aXZlIG51bWJlcnMuXG5bJ2NvbHMnLCAncm93cycsICdzaXplJywgJ3NwYW4nXS5mb3JFYWNoKGZ1bmN0aW9uIChuYW1lKSB7XG4gIHByb3BlcnRpZXNbbmFtZV0gPSBuZXcgUHJvcGVydHlJbmZvUmVjb3JkKG5hbWUsIFBPU0lUSVZFX05VTUVSSUMsIGZhbHNlLCAvLyBtdXN0VXNlUHJvcGVydHlcbiAgbmFtZSwgLy8gYXR0cmlidXRlTmFtZVxuICBudWxsKTtcbn0gLy8gYXR0cmlidXRlTmFtZXNwYWNlXG4pO1xuXG4vLyBUaGVzZSBhcmUgSFRNTCBhdHRyaWJ1dGVzIHRoYXQgbXVzdCBiZSBudW1iZXJzLlxuWydyb3dTcGFuJywgJ3N0YXJ0J10uZm9yRWFjaChmdW5jdGlvbiAobmFtZSkge1xuICBwcm9wZXJ0aWVzW25hbWVdID0gbmV3IFByb3BlcnR5SW5mb1JlY29yZChuYW1lLCBOVU1FUklDLCBmYWxzZSwgLy8gbXVzdFVzZVByb3BlcnR5XG4gIG5hbWUudG9Mb3dlckNhc2UoKSwgLy8gYXR0cmlidXRlTmFtZVxuICBudWxsKTtcbn0gLy8gYXR0cmlidXRlTmFtZXNwYWNlXG4pO1xuXG52YXIgQ0FNRUxJWkUgPSAvW1xcLVxcOl0oW2Etel0pL2c7XG52YXIgY2FwaXRhbGl6ZSA9IGZ1bmN0aW9uICh0b2tlbikge1xuICByZXR1cm4gdG9rZW5bMV0udG9VcHBlckNhc2UoKTtcbn07XG5cbi8vIFRoaXMgaXMgYSBsaXN0IG9mIGFsbCBTVkcgYXR0cmlidXRlcyB0aGF0IG5lZWQgc3BlY2lhbCBjYXNpbmcsIG5hbWVzcGFjaW5nLFxuLy8gb3IgYm9vbGVhbiB2YWx1ZSBhc3NpZ25tZW50LiBSZWd1bGFyIGF0dHJpYnV0ZXMgdGhhdCBqdXN0IGFjY2VwdCBzdHJpbmdzXG4vLyBhbmQgaGF2ZSB0aGUgc2FtZSBuYW1lcyBhcmUgb21pdHRlZCwganVzdCBsaWtlIGluIHRoZSBIVE1MIHdoaXRlbGlzdC5cbi8vIFNvbWUgb2YgdGhlc2UgYXR0cmlidXRlcyBjYW4gYmUgaGFyZCB0byBmaW5kLiBUaGlzIGxpc3Qgd2FzIGNyZWF0ZWQgYnlcbi8vIHNjcmFwcGluZyB0aGUgTUROIGRvY3VtZW50YXRpb24uXG5bJ2FjY2VudC1oZWlnaHQnLCAnYWxpZ25tZW50LWJhc2VsaW5lJywgJ2FyYWJpYy1mb3JtJywgJ2Jhc2VsaW5lLXNoaWZ0JywgJ2NhcC1oZWlnaHQnLCAnY2xpcC1wYXRoJywgJ2NsaXAtcnVsZScsICdjb2xvci1pbnRlcnBvbGF0aW9uJywgJ2NvbG9yLWludGVycG9sYXRpb24tZmlsdGVycycsICdjb2xvci1wcm9maWxlJywgJ2NvbG9yLXJlbmRlcmluZycsICdkb21pbmFudC1iYXNlbGluZScsICdlbmFibGUtYmFja2dyb3VuZCcsICdmaWxsLW9wYWNpdHknLCAnZmlsbC1ydWxlJywgJ2Zsb29kLWNvbG9yJywgJ2Zsb29kLW9wYWNpdHknLCAnZm9udC1mYW1pbHknLCAnZm9udC1zaXplJywgJ2ZvbnQtc2l6ZS1hZGp1c3QnLCAnZm9udC1zdHJldGNoJywgJ2ZvbnQtc3R5bGUnLCAnZm9udC12YXJpYW50JywgJ2ZvbnQtd2VpZ2h0JywgJ2dseXBoLW5hbWUnLCAnZ2x5cGgtb3JpZW50YXRpb24taG9yaXpvbnRhbCcsICdnbHlwaC1vcmllbnRhdGlvbi12ZXJ0aWNhbCcsICdob3Jpei1hZHYteCcsICdob3Jpei1vcmlnaW4teCcsICdpbWFnZS1yZW5kZXJpbmcnLCAnbGV0dGVyLXNwYWNpbmcnLCAnbGlnaHRpbmctY29sb3InLCAnbWFya2VyLWVuZCcsICdtYXJrZXItbWlkJywgJ21hcmtlci1zdGFydCcsICdvdmVybGluZS1wb3NpdGlvbicsICdvdmVybGluZS10aGlja25lc3MnLCAncGFpbnQtb3JkZXInLCAncGFub3NlLTEnLCAncG9pbnRlci1ldmVudHMnLCAncmVuZGVyaW5nLWludGVudCcsICdzaGFwZS1yZW5kZXJpbmcnLCAnc3RvcC1jb2xvcicsICdzdG9wLW9wYWNpdHknLCAnc3RyaWtldGhyb3VnaC1wb3NpdGlvbicsICdzdHJpa2V0aHJvdWdoLXRoaWNrbmVzcycsICdzdHJva2UtZGFzaGFycmF5JywgJ3N0cm9rZS1kYXNob2Zmc2V0JywgJ3N0cm9rZS1saW5lY2FwJywgJ3N0cm9rZS1saW5lam9pbicsICdzdHJva2UtbWl0ZXJsaW1pdCcsICdzdHJva2Utb3BhY2l0eScsICdzdHJva2Utd2lkdGgnLCAndGV4dC1hbmNob3InLCAndGV4dC1kZWNvcmF0aW9uJywgJ3RleHQtcmVuZGVyaW5nJywgJ3VuZGVybGluZS1wb3NpdGlvbicsICd1bmRlcmxpbmUtdGhpY2tuZXNzJywgJ3VuaWNvZGUtYmlkaScsICd1bmljb2RlLXJhbmdlJywgJ3VuaXRzLXBlci1lbScsICd2LWFscGhhYmV0aWMnLCAndi1oYW5naW5nJywgJ3YtaWRlb2dyYXBoaWMnLCAndi1tYXRoZW1hdGljYWwnLCAndmVjdG9yLWVmZmVjdCcsICd2ZXJ0LWFkdi15JywgJ3ZlcnQtb3JpZ2luLXgnLCAndmVydC1vcmlnaW4teScsICd3b3JkLXNwYWNpbmcnLCAnd3JpdGluZy1tb2RlJywgJ3htbG5zOnhsaW5rJywgJ3gtaGVpZ2h0J10uZm9yRWFjaChmdW5jdGlvbiAoYXR0cmlidXRlTmFtZSkge1xuICB2YXIgbmFtZSA9IGF0dHJpYnV0ZU5hbWUucmVwbGFjZShDQU1FTElaRSwgY2FwaXRhbGl6ZSk7XG4gIHByb3BlcnRpZXNbbmFtZV0gPSBuZXcgUHJvcGVydHlJbmZvUmVjb3JkKG5hbWUsIFNUUklORywgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBhdHRyaWJ1dGVOYW1lLCBudWxsKTtcbn0gLy8gYXR0cmlidXRlTmFtZXNwYWNlXG4pO1xuXG4vLyBTdHJpbmcgU1ZHIGF0dHJpYnV0ZXMgd2l0aCB0aGUgeGxpbmsgbmFtZXNwYWNlLlxuWyd4bGluazphY3R1YXRlJywgJ3hsaW5rOmFyY3JvbGUnLCAneGxpbms6aHJlZicsICd4bGluazpyb2xlJywgJ3hsaW5rOnNob3cnLCAneGxpbms6dGl0bGUnLCAneGxpbms6dHlwZSddLmZvckVhY2goZnVuY3Rpb24gKGF0dHJpYnV0ZU5hbWUpIHtcbiAgdmFyIG5hbWUgPSBhdHRyaWJ1dGVOYW1lLnJlcGxhY2UoQ0FNRUxJWkUsIGNhcGl0YWxpemUpO1xuICBwcm9wZXJ0aWVzW25hbWVdID0gbmV3IFByb3BlcnR5SW5mb1JlY29yZChuYW1lLCBTVFJJTkcsIGZhbHNlLCAvLyBtdXN0VXNlUHJvcGVydHlcbiAgYXR0cmlidXRlTmFtZSwgJ2h0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsnKTtcbn0pO1xuXG4vLyBTdHJpbmcgU1ZHIGF0dHJpYnV0ZXMgd2l0aCB0aGUgeG1sIG5hbWVzcGFjZS5cblsneG1sOmJhc2UnLCAneG1sOmxhbmcnLCAneG1sOnNwYWNlJ10uZm9yRWFjaChmdW5jdGlvbiAoYXR0cmlidXRlTmFtZSkge1xuICB2YXIgbmFtZSA9IGF0dHJpYnV0ZU5hbWUucmVwbGFjZShDQU1FTElaRSwgY2FwaXRhbGl6ZSk7XG4gIHByb3BlcnRpZXNbbmFtZV0gPSBuZXcgUHJvcGVydHlJbmZvUmVjb3JkKG5hbWUsIFNUUklORywgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuICBhdHRyaWJ1dGVOYW1lLCAnaHR0cDovL3d3dy53My5vcmcvWE1MLzE5OTgvbmFtZXNwYWNlJyk7XG59KTtcblxuLy8gU3BlY2lhbCBjYXNlOiB0aGlzIGF0dHJpYnV0ZSBleGlzdHMgYm90aCBpbiBIVE1MIGFuZCBTVkcuXG4vLyBJdHMgXCJ0YWJpbmRleFwiIGF0dHJpYnV0ZSBuYW1lIGlzIGNhc2Utc2Vuc2l0aXZlIGluIFNWRyBzbyB3ZSBjYW4ndCBqdXN0IHVzZVxuLy8gaXRzIFJlYWN0IGB0YWJJbmRleGAgbmFtZSwgbGlrZSB3ZSBkbyBmb3IgYXR0cmlidXRlcyB0aGF0IGV4aXN0IG9ubHkgaW4gSFRNTC5cbnByb3BlcnRpZXMudGFiSW5kZXggPSBuZXcgUHJvcGVydHlJbmZvUmVjb3JkKCd0YWJJbmRleCcsIFNUUklORywgZmFsc2UsIC8vIG11c3RVc2VQcm9wZXJ0eVxuJ3RhYmluZGV4JywgLy8gYXR0cmlidXRlTmFtZVxubnVsbCk7XG5cbi8vIGNvZGUgY29waWVkIGFuZCBtb2RpZmllZCBmcm9tIGVzY2FwZS1odG1sXG4vKipcbiAqIE1vZHVsZSB2YXJpYWJsZXMuXG4gKiBAcHJpdmF0ZVxuICovXG5cbnZhciBtYXRjaEh0bWxSZWdFeHAgPSAvW1wiJyY8Pl0vO1xuXG4vKipcbiAqIEVzY2FwZXMgc3BlY2lhbCBjaGFyYWN0ZXJzIGFuZCBIVE1MIGVudGl0aWVzIGluIGEgZ2l2ZW4gaHRtbCBzdHJpbmcuXG4gKlxuICogQHBhcmFtICB7c3RyaW5nfSBzdHJpbmcgSFRNTCBzdHJpbmcgdG8gZXNjYXBlIGZvciBsYXRlciBpbnNlcnRpb25cbiAqIEByZXR1cm4ge3N0cmluZ31cbiAqIEBwdWJsaWNcbiAqL1xuXG5mdW5jdGlvbiBlc2NhcGVIdG1sKHN0cmluZykge1xuICB2YXIgc3RyID0gJycgKyBzdHJpbmc7XG4gIHZhciBtYXRjaCA9IG1hdGNoSHRtbFJlZ0V4cC5leGVjKHN0cik7XG5cbiAgaWYgKCFtYXRjaCkge1xuICAgIHJldHVybiBzdHI7XG4gIH1cblxuICB2YXIgZXNjYXBlID0gdm9pZCAwO1xuICB2YXIgaHRtbCA9ICcnO1xuICB2YXIgaW5kZXggPSB2b2lkIDA7XG4gIHZhciBsYXN0SW5kZXggPSAwO1xuXG4gIGZvciAoaW5kZXggPSBtYXRjaC5pbmRleDsgaW5kZXggPCBzdHIubGVuZ3RoOyBpbmRleCsrKSB7XG4gICAgc3dpdGNoIChzdHIuY2hhckNvZGVBdChpbmRleCkpIHtcbiAgICAgIGNhc2UgMzQ6XG4gICAgICAgIC8vIFwiXG4gICAgICAgIGVzY2FwZSA9ICcmcXVvdDsnO1xuICAgICAgICBicmVhaztcbiAgICAgIGNhc2UgMzg6XG4gICAgICAgIC8vICZcbiAgICAgICAgZXNjYXBlID0gJyZhbXA7JztcbiAgICAgICAgYnJlYWs7XG4gICAgICBjYXNlIDM5OlxuICAgICAgICAvLyAnXG4gICAgICAgIGVzY2FwZSA9ICcmI3gyNzsnOyAvLyBtb2RpZmllZCBmcm9tIGVzY2FwZS1odG1sOyB1c2VkIHRvIGJlICcmIzM5J1xuICAgICAgICBicmVhaztcbiAgICAgIGNhc2UgNjA6XG4gICAgICAgIC8vIDxcbiAgICAgICAgZXNjYXBlID0gJyZsdDsnO1xuICAgICAgICBicmVhaztcbiAgICAgIGNhc2UgNjI6XG4gICAgICAgIC8vID5cbiAgICAgICAgZXNjYXBlID0gJyZndDsnO1xuICAgICAgICBicmVhaztcbiAgICAgIGRlZmF1bHQ6XG4gICAgICAgIGNvbnRpbnVlO1xuICAgIH1cblxuICAgIGlmIChsYXN0SW5kZXggIT09IGluZGV4KSB7XG4gICAgICBodG1sICs9IHN0ci5zdWJzdHJpbmcobGFzdEluZGV4LCBpbmRleCk7XG4gICAgfVxuXG4gICAgbGFzdEluZGV4ID0gaW5kZXggKyAxO1xuICAgIGh0bWwgKz0gZXNjYXBlO1xuICB9XG5cbiAgcmV0dXJuIGxhc3RJbmRleCAhPT0gaW5kZXggPyBodG1sICsgc3RyLnN1YnN0cmluZyhsYXN0SW5kZXgsIGluZGV4KSA6IGh0bWw7XG59XG4vLyBlbmQgY29kZSBjb3BpZWQgYW5kIG1vZGlmaWVkIGZyb20gZXNjYXBlLWh0bWxcblxuLyoqXG4gKiBFc2NhcGVzIHRleHQgdG8gcHJldmVudCBzY3JpcHRpbmcgYXR0YWNrcy5cbiAqXG4gKiBAcGFyYW0geyp9IHRleHQgVGV4dCB2YWx1ZSB0byBlc2NhcGUuXG4gKiBAcmV0dXJuIHtzdHJpbmd9IEFuIGVzY2FwZWQgc3RyaW5nLlxuICovXG5mdW5jdGlvbiBlc2NhcGVUZXh0Rm9yQnJvd3Nlcih0ZXh0KSB7XG4gIGlmICh0eXBlb2YgdGV4dCA9PT0gJ2Jvb2xlYW4nIHx8IHR5cGVvZiB0ZXh0ID09PSAnbnVtYmVyJykge1xuICAgIC8vIHRoaXMgc2hvcnRjaXJjdWl0IGhlbHBzIHBlcmYgZm9yIHR5cGVzIHRoYXQgd2Uga25vdyB3aWxsIG5ldmVyIGhhdmVcbiAgICAvLyBzcGVjaWFsIGNoYXJhY3RlcnMsIGVzcGVjaWFsbHkgZ2l2ZW4gdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIHVzZWQgb2Z0ZW5cbiAgICAvLyBmb3IgbnVtZXJpYyBkb20gaWRzLlxuICAgIHJldHVybiAnJyArIHRleHQ7XG4gIH1cbiAgcmV0dXJuIGVzY2FwZUh0bWwodGV4dCk7XG59XG5cbi8qKlxuICogRXNjYXBlcyBhdHRyaWJ1dGUgdmFsdWUgdG8gcHJldmVudCBzY3JpcHRpbmcgYXR0YWNrcy5cbiAqXG4gKiBAcGFyYW0geyp9IHZhbHVlIFZhbHVlIHRvIGVzY2FwZS5cbiAqIEByZXR1cm4ge3N0cmluZ30gQW4gZXNjYXBlZCBzdHJpbmcuXG4gKi9cbmZ1bmN0aW9uIHF1b3RlQXR0cmlidXRlVmFsdWVGb3JCcm93c2VyKHZhbHVlKSB7XG4gIHJldHVybiAnXCInICsgZXNjYXBlVGV4dEZvckJyb3dzZXIodmFsdWUpICsgJ1wiJztcbn1cblxuLyoqXG4gKiBPcGVyYXRpb25zIGZvciBkZWFsaW5nIHdpdGggRE9NIHByb3BlcnRpZXMuXG4gKi9cblxuLyoqXG4gKiBDcmVhdGVzIG1hcmt1cCBmb3IgdGhlIElEIHByb3BlcnR5LlxuICpcbiAqIEBwYXJhbSB7c3RyaW5nfSBpZCBVbmVzY2FwZWQgSUQuXG4gKiBAcmV0dXJuIHtzdHJpbmd9IE1hcmt1cCBzdHJpbmcuXG4gKi9cblxuXG5mdW5jdGlvbiBjcmVhdGVNYXJrdXBGb3JSb290KCkge1xuICByZXR1cm4gUk9PVF9BVFRSSUJVVEVfTkFNRSArICc9XCJcIic7XG59XG5cbi8qKlxuICogQ3JlYXRlcyBtYXJrdXAgZm9yIGEgcHJvcGVydHkuXG4gKlxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqIEBwYXJhbSB7Kn0gdmFsdWVcbiAqIEByZXR1cm4gez9zdHJpbmd9IE1hcmt1cCBzdHJpbmcsIG9yIG51bGwgaWYgdGhlIHByb3BlcnR5IHdhcyBpbnZhbGlkLlxuICovXG5mdW5jdGlvbiBjcmVhdGVNYXJrdXBGb3JQcm9wZXJ0eShuYW1lLCB2YWx1ZSkge1xuICB2YXIgcHJvcGVydHlJbmZvID0gZ2V0UHJvcGVydHlJbmZvKG5hbWUpO1xuICBpZiAobmFtZSAhPT0gJ3N0eWxlJyAmJiBzaG91bGRJZ25vcmVBdHRyaWJ1dGUobmFtZSwgcHJvcGVydHlJbmZvLCBmYWxzZSkpIHtcbiAgICByZXR1cm4gJyc7XG4gIH1cbiAgaWYgKHNob3VsZFJlbW92ZUF0dHJpYnV0ZShuYW1lLCB2YWx1ZSwgcHJvcGVydHlJbmZvLCBmYWxzZSkpIHtcbiAgICByZXR1cm4gJyc7XG4gIH1cbiAgaWYgKHByb3BlcnR5SW5mbyAhPT0gbnVsbCkge1xuICAgIHZhciBhdHRyaWJ1dGVOYW1lID0gcHJvcGVydHlJbmZvLmF0dHJpYnV0ZU5hbWU7XG4gICAgdmFyIHR5cGUgPSBwcm9wZXJ0eUluZm8udHlwZTtcblxuICAgIGlmICh0eXBlID09PSBCT09MRUFOIHx8IHR5cGUgPT09IE9WRVJMT0FERURfQk9PTEVBTiAmJiB2YWx1ZSA9PT0gdHJ1ZSkge1xuICAgICAgcmV0dXJuIGF0dHJpYnV0ZU5hbWUgKyAnPVwiXCInO1xuICAgIH0gZWxzZSB7XG4gICAgICByZXR1cm4gYXR0cmlidXRlTmFtZSArICc9JyArIHF1b3RlQXR0cmlidXRlVmFsdWVGb3JCcm93c2VyKHZhbHVlKTtcbiAgICB9XG4gIH0gZWxzZSBpZiAoaXNBdHRyaWJ1dGVOYW1lU2FmZShuYW1lKSkge1xuICAgIHJldHVybiBuYW1lICsgJz0nICsgcXVvdGVBdHRyaWJ1dGVWYWx1ZUZvckJyb3dzZXIodmFsdWUpO1xuICB9XG4gIHJldHVybiAnJztcbn1cblxuLyoqXG4gKiBDcmVhdGVzIG1hcmt1cCBmb3IgYSBjdXN0b20gcHJvcGVydHkuXG4gKlxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqIEBwYXJhbSB7Kn0gdmFsdWVcbiAqIEByZXR1cm4ge3N0cmluZ30gTWFya3VwIHN0cmluZywgb3IgZW1wdHkgc3RyaW5nIGlmIHRoZSBwcm9wZXJ0eSB3YXMgaW52YWxpZC5cbiAqL1xuZnVuY3Rpb24gY3JlYXRlTWFya3VwRm9yQ3VzdG9tQXR0cmlidXRlKG5hbWUsIHZhbHVlKSB7XG4gIGlmICghaXNBdHRyaWJ1dGVOYW1lU2FmZShuYW1lKSB8fCB2YWx1ZSA9PSBudWxsKSB7XG4gICAgcmV0dXJuICcnO1xuICB9XG4gIHJldHVybiBuYW1lICsgJz0nICsgcXVvdGVBdHRyaWJ1dGVWYWx1ZUZvckJyb3dzZXIodmFsdWUpO1xufVxuXG4vKipcbiAqIGlubGluZWQgT2JqZWN0LmlzIHBvbHlmaWxsIHRvIGF2b2lkIHJlcXVpcmluZyBjb25zdW1lcnMgc2hpcCB0aGVpciBvd25cbiAqIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2VuLVVTL2RvY3MvV2ViL0phdmFTY3JpcHQvUmVmZXJlbmNlL0dsb2JhbF9PYmplY3RzL09iamVjdC9pc1xuICovXG5mdW5jdGlvbiBpcyh4LCB5KSB7XG4gIHJldHVybiB4ID09PSB5ICYmICh4ICE9PSAwIHx8IDEgLyB4ID09PSAxIC8geSkgfHwgeCAhPT0geCAmJiB5ICE9PSB5IC8vIGVzbGludC1kaXNhYmxlLWxpbmUgbm8tc2VsZi1jb21wYXJlXG4gIDtcbn1cblxudmFyIGN1cnJlbnRseVJlbmRlcmluZ0NvbXBvbmVudCA9IG51bGw7XG52YXIgZmlyc3RXb3JrSW5Qcm9ncmVzc0hvb2sgPSBudWxsO1xudmFyIHdvcmtJblByb2dyZXNzSG9vayA9IG51bGw7XG4vLyBXaGV0aGVyIHRoZSB3b3JrLWluLXByb2dyZXNzIGhvb2sgaXMgYSByZS1yZW5kZXJlZCBob29rXG52YXIgaXNSZVJlbmRlciA9IGZhbHNlO1xuLy8gV2hldGhlciBhbiB1cGRhdGUgd2FzIHNjaGVkdWxlZCBkdXJpbmcgdGhlIGN1cnJlbnRseSBleGVjdXRpbmcgcmVuZGVyIHBhc3MuXG52YXIgZGlkU2NoZWR1bGVSZW5kZXJQaGFzZVVwZGF0ZSA9IGZhbHNlO1xuLy8gTGF6aWx5IGNyZWF0ZWQgbWFwIG9mIHJlbmRlci1waGFzZSB1cGRhdGVzXG52YXIgcmVuZGVyUGhhc2VVcGRhdGVzID0gbnVsbDtcbi8vIENvdW50ZXIgdG8gcHJldmVudCBpbmZpbml0ZSBsb29wcy5cbnZhciBudW1iZXJPZlJlUmVuZGVycyA9IDA7XG52YXIgUkVfUkVOREVSX0xJTUlUID0gMjU7XG5cbnZhciBpc0luSG9va1VzZXJDb2RlSW5EZXYgPSBmYWxzZTtcblxuLy8gSW4gREVWLCB0aGlzIGlzIHRoZSBuYW1lIG9mIHRoZSBjdXJyZW50bHkgZXhlY3V0aW5nIHByaW1pdGl2ZSBob29rXG52YXIgY3VycmVudEhvb2tOYW1lSW5EZXYgPSB2b2lkIDA7XG5cbmZ1bmN0aW9uIHJlc29sdmVDdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQoKSB7XG4gICEoY3VycmVudGx5UmVuZGVyaW5nQ29tcG9uZW50ICE9PSBudWxsKSA/IGludmFyaWFudChmYWxzZSwgJ0hvb2tzIGNhbiBvbmx5IGJlIGNhbGxlZCBpbnNpZGUgdGhlIGJvZHkgb2YgYSBmdW5jdGlvbiBjb21wb25lbnQuIChodHRwczovL2ZiLm1lL3JlYWN0LWludmFsaWQtaG9vay1jYWxsKScpIDogdm9pZCAwO1xuICB7XG4gICAgISFpc0luSG9va1VzZXJDb2RlSW5EZXYgPyB3YXJuaW5nJDEoZmFsc2UsICdEbyBub3QgY2FsbCBIb29rcyBpbnNpZGUgdXNlRWZmZWN0KC4uLiksIHVzZU1lbW8oLi4uKSwgb3Igb3RoZXIgYnVpbHQtaW4gSG9va3MuICcgKyAnWW91IGNhbiBvbmx5IGNhbGwgSG9va3MgYXQgdGhlIHRvcCBsZXZlbCBvZiB5b3VyIFJlYWN0IGZ1bmN0aW9uLiAnICsgJ0ZvciBtb3JlIGluZm9ybWF0aW9uLCBzZWUgJyArICdodHRwczovL2ZiLm1lL3J1bGVzLW9mLWhvb2tzJykgOiB2b2lkIDA7XG4gIH1cbiAgcmV0dXJuIGN1cnJlbnRseVJlbmRlcmluZ0NvbXBvbmVudDtcbn1cblxuZnVuY3Rpb24gYXJlSG9va0lucHV0c0VxdWFsKG5leHREZXBzLCBwcmV2RGVwcykge1xuICBpZiAocHJldkRlcHMgPT09IG51bGwpIHtcbiAgICB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICclcyByZWNlaXZlZCBhIGZpbmFsIGFyZ3VtZW50IGR1cmluZyB0aGlzIHJlbmRlciwgYnV0IG5vdCBkdXJpbmcgJyArICd0aGUgcHJldmlvdXMgcmVuZGVyLiBFdmVuIHRob3VnaCB0aGUgZmluYWwgYXJndW1lbnQgaXMgb3B0aW9uYWwsICcgKyAnaXRzIHR5cGUgY2Fubm90IGNoYW5nZSBiZXR3ZWVuIHJlbmRlcnMuJywgY3VycmVudEhvb2tOYW1lSW5EZXYpO1xuICAgIH1cbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICB7XG4gICAgLy8gRG9uJ3QgYm90aGVyIGNvbXBhcmluZyBsZW5ndGhzIGluIHByb2QgYmVjYXVzZSB0aGVzZSBhcnJheXMgc2hvdWxkIGJlXG4gICAgLy8gcGFzc2VkIGlubGluZS5cbiAgICBpZiAobmV4dERlcHMubGVuZ3RoICE9PSBwcmV2RGVwcy5sZW5ndGgpIHtcbiAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1RoZSBmaW5hbCBhcmd1bWVudCBwYXNzZWQgdG8gJXMgY2hhbmdlZCBzaXplIGJldHdlZW4gcmVuZGVycy4gVGhlICcgKyAnb3JkZXIgYW5kIHNpemUgb2YgdGhpcyBhcnJheSBtdXN0IHJlbWFpbiBjb25zdGFudC5cXG5cXG4nICsgJ1ByZXZpb3VzOiAlc1xcbicgKyAnSW5jb21pbmc6ICVzJywgY3VycmVudEhvb2tOYW1lSW5EZXYsICdbJyArIG5leHREZXBzLmpvaW4oJywgJykgKyAnXScsICdbJyArIHByZXZEZXBzLmpvaW4oJywgJykgKyAnXScpO1xuICAgIH1cbiAgfVxuICBmb3IgKHZhciBpID0gMDsgaSA8IHByZXZEZXBzLmxlbmd0aCAmJiBpIDwgbmV4dERlcHMubGVuZ3RoOyBpKyspIHtcbiAgICBpZiAoaXMobmV4dERlcHNbaV0sIHByZXZEZXBzW2ldKSkge1xuICAgICAgY29udGludWU7XG4gICAgfVxuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuICByZXR1cm4gdHJ1ZTtcbn1cblxuZnVuY3Rpb24gY3JlYXRlSG9vaygpIHtcbiAgaWYgKG51bWJlck9mUmVSZW5kZXJzID4gMCkge1xuICAgIGludmFyaWFudChmYWxzZSwgJ1JlbmRlcmVkIG1vcmUgaG9va3MgdGhhbiBkdXJpbmcgdGhlIHByZXZpb3VzIHJlbmRlcicpO1xuICB9XG4gIHJldHVybiB7XG4gICAgbWVtb2l6ZWRTdGF0ZTogbnVsbCxcbiAgICBxdWV1ZTogbnVsbCxcbiAgICBuZXh0OiBudWxsXG4gIH07XG59XG5cbmZ1bmN0aW9uIGNyZWF0ZVdvcmtJblByb2dyZXNzSG9vaygpIHtcbiAgaWYgKHdvcmtJblByb2dyZXNzSG9vayA9PT0gbnVsbCkge1xuICAgIC8vIFRoaXMgaXMgdGhlIGZpcnN0IGhvb2sgaW4gdGhlIGxpc3RcbiAgICBpZiAoZmlyc3RXb3JrSW5Qcm9ncmVzc0hvb2sgPT09IG51bGwpIHtcbiAgICAgIGlzUmVSZW5kZXIgPSBmYWxzZTtcbiAgICAgIGZpcnN0V29ya0luUHJvZ3Jlc3NIb29rID0gd29ya0luUHJvZ3Jlc3NIb29rID0gY3JlYXRlSG9vaygpO1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBUaGVyZSdzIGFscmVhZHkgYSB3b3JrLWluLXByb2dyZXNzLiBSZXVzZSBpdC5cbiAgICAgIGlzUmVSZW5kZXIgPSB0cnVlO1xuICAgICAgd29ya0luUHJvZ3Jlc3NIb29rID0gZmlyc3RXb3JrSW5Qcm9ncmVzc0hvb2s7XG4gICAgfVxuICB9IGVsc2Uge1xuICAgIGlmICh3b3JrSW5Qcm9ncmVzc0hvb2submV4dCA9PT0gbnVsbCkge1xuICAgICAgaXNSZVJlbmRlciA9IGZhbHNlO1xuICAgICAgLy8gQXBwZW5kIHRvIHRoZSBlbmQgb2YgdGhlIGxpc3RcbiAgICAgIHdvcmtJblByb2dyZXNzSG9vayA9IHdvcmtJblByb2dyZXNzSG9vay5uZXh0ID0gY3JlYXRlSG9vaygpO1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBUaGVyZSdzIGFscmVhZHkgYSB3b3JrLWluLXByb2dyZXNzLiBSZXVzZSBpdC5cbiAgICAgIGlzUmVSZW5kZXIgPSB0cnVlO1xuICAgICAgd29ya0luUHJvZ3Jlc3NIb29rID0gd29ya0luUHJvZ3Jlc3NIb29rLm5leHQ7XG4gICAgfVxuICB9XG4gIHJldHVybiB3b3JrSW5Qcm9ncmVzc0hvb2s7XG59XG5cbmZ1bmN0aW9uIHByZXBhcmVUb1VzZUhvb2tzKGNvbXBvbmVudElkZW50aXR5KSB7XG4gIGN1cnJlbnRseVJlbmRlcmluZ0NvbXBvbmVudCA9IGNvbXBvbmVudElkZW50aXR5O1xuICB7XG4gICAgaXNJbkhvb2tVc2VyQ29kZUluRGV2ID0gZmFsc2U7XG4gIH1cblxuICAvLyBUaGUgZm9sbG93aW5nIHNob3VsZCBoYXZlIGFscmVhZHkgYmVlbiByZXNldFxuICAvLyBkaWRTY2hlZHVsZVJlbmRlclBoYXNlVXBkYXRlID0gZmFsc2U7XG4gIC8vIGZpcnN0V29ya0luUHJvZ3Jlc3NIb29rID0gbnVsbDtcbiAgLy8gbnVtYmVyT2ZSZVJlbmRlcnMgPSAwO1xuICAvLyByZW5kZXJQaGFzZVVwZGF0ZXMgPSBudWxsO1xuICAvLyB3b3JrSW5Qcm9ncmVzc0hvb2sgPSBudWxsO1xufVxuXG5mdW5jdGlvbiBmaW5pc2hIb29rcyhDb21wb25lbnQsIHByb3BzLCBjaGlsZHJlbiwgcmVmT3JDb250ZXh0KSB7XG4gIC8vIFRoaXMgbXVzdCBiZSBjYWxsZWQgYWZ0ZXIgZXZlcnkgZnVuY3Rpb24gY29tcG9uZW50IHRvIHByZXZlbnQgaG9va3MgZnJvbVxuICAvLyBiZWluZyB1c2VkIGluIGNsYXNzZXMuXG5cbiAgd2hpbGUgKGRpZFNjaGVkdWxlUmVuZGVyUGhhc2VVcGRhdGUpIHtcbiAgICAvLyBVcGRhdGVzIHdlcmUgc2NoZWR1bGVkIGR1cmluZyB0aGUgcmVuZGVyIHBoYXNlLiBUaGV5IGFyZSBzdG9yZWQgaW5cbiAgICAvLyB0aGUgYHJlbmRlclBoYXNlVXBkYXRlc2AgbWFwLiBDYWxsIHRoZSBjb21wb25lbnQgYWdhaW4sIHJldXNpbmcgdGhlXG4gICAgLy8gd29yay1pbi1wcm9ncmVzcyBob29rcyBhbmQgYXBwbHlpbmcgdGhlIGFkZGl0aW9uYWwgdXBkYXRlcyBvbiB0b3AuIEtlZXBcbiAgICAvLyByZXN0YXJ0aW5nIHVudGlsIG5vIG1vcmUgdXBkYXRlcyBhcmUgc2NoZWR1bGVkLlxuICAgIGRpZFNjaGVkdWxlUmVuZGVyUGhhc2VVcGRhdGUgPSBmYWxzZTtcbiAgICBudW1iZXJPZlJlUmVuZGVycyArPSAxO1xuXG4gICAgLy8gU3RhcnQgb3ZlciBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgdGhlIGxpc3RcbiAgICB3b3JrSW5Qcm9ncmVzc0hvb2sgPSBudWxsO1xuXG4gICAgY2hpbGRyZW4gPSBDb21wb25lbnQocHJvcHMsIHJlZk9yQ29udGV4dCk7XG4gIH1cbiAgY3VycmVudGx5UmVuZGVyaW5nQ29tcG9uZW50ID0gbnVsbDtcbiAgZmlyc3RXb3JrSW5Qcm9ncmVzc0hvb2sgPSBudWxsO1xuICBudW1iZXJPZlJlUmVuZGVycyA9IDA7XG4gIHJlbmRlclBoYXNlVXBkYXRlcyA9IG51bGw7XG4gIHdvcmtJblByb2dyZXNzSG9vayA9IG51bGw7XG4gIHtcbiAgICBpc0luSG9va1VzZXJDb2RlSW5EZXYgPSBmYWxzZTtcbiAgfVxuXG4gIC8vIFRoZXNlIHdlcmUgcmVzZXQgYWJvdmVcbiAgLy8gY3VycmVudGx5UmVuZGVyaW5nQ29tcG9uZW50ID0gbnVsbDtcbiAgLy8gZGlkU2NoZWR1bGVSZW5kZXJQaGFzZVVwZGF0ZSA9IGZhbHNlO1xuICAvLyBmaXJzdFdvcmtJblByb2dyZXNzSG9vayA9IG51bGw7XG4gIC8vIG51bWJlck9mUmVSZW5kZXJzID0gMDtcbiAgLy8gcmVuZGVyUGhhc2VVcGRhdGVzID0gbnVsbDtcbiAgLy8gd29ya0luUHJvZ3Jlc3NIb29rID0gbnVsbDtcblxuICByZXR1cm4gY2hpbGRyZW47XG59XG5cbmZ1bmN0aW9uIHJlYWRDb250ZXh0KGNvbnRleHQsIG9ic2VydmVkQml0cykge1xuICB2YXIgdGhyZWFkSUQgPSBjdXJyZW50VGhyZWFkSUQ7XG4gIHZhbGlkYXRlQ29udGV4dEJvdW5kcyhjb250ZXh0LCB0aHJlYWRJRCk7XG4gIHtcbiAgICAhIWlzSW5Ib29rVXNlckNvZGVJbkRldiA/IHdhcm5pbmckMShmYWxzZSwgJ0NvbnRleHQgY2FuIG9ubHkgYmUgcmVhZCB3aGlsZSBSZWFjdCBpcyByZW5kZXJpbmcuICcgKyAnSW4gY2xhc3NlcywgeW91IGNhbiByZWFkIGl0IGluIHRoZSByZW5kZXIgbWV0aG9kIG9yIGdldERlcml2ZWRTdGF0ZUZyb21Qcm9wcy4gJyArICdJbiBmdW5jdGlvbiBjb21wb25lbnRzLCB5b3UgY2FuIHJlYWQgaXQgZGlyZWN0bHkgaW4gdGhlIGZ1bmN0aW9uIGJvZHksIGJ1dCBub3QgJyArICdpbnNpZGUgSG9va3MgbGlrZSB1c2VSZWR1Y2VyKCkgb3IgdXNlTWVtbygpLicpIDogdm9pZCAwO1xuICB9XG4gIHJldHVybiBjb250ZXh0W3RocmVhZElEXTtcbn1cblxuZnVuY3Rpb24gdXNlQ29udGV4dChjb250ZXh0LCBvYnNlcnZlZEJpdHMpIHtcbiAge1xuICAgIGN1cnJlbnRIb29rTmFtZUluRGV2ID0gJ3VzZUNvbnRleHQnO1xuICB9XG4gIHJlc29sdmVDdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQoKTtcbiAgdmFyIHRocmVhZElEID0gY3VycmVudFRocmVhZElEO1xuICB2YWxpZGF0ZUNvbnRleHRCb3VuZHMoY29udGV4dCwgdGhyZWFkSUQpO1xuICByZXR1cm4gY29udGV4dFt0aHJlYWRJRF07XG59XG5cbmZ1bmN0aW9uIGJhc2ljU3RhdGVSZWR1Y2VyKHN0YXRlLCBhY3Rpb24pIHtcbiAgcmV0dXJuIHR5cGVvZiBhY3Rpb24gPT09ICdmdW5jdGlvbicgPyBhY3Rpb24oc3RhdGUpIDogYWN0aW9uO1xufVxuXG5mdW5jdGlvbiB1c2VTdGF0ZShpbml0aWFsU3RhdGUpIHtcbiAge1xuICAgIGN1cnJlbnRIb29rTmFtZUluRGV2ID0gJ3VzZVN0YXRlJztcbiAgfVxuICByZXR1cm4gdXNlUmVkdWNlcihiYXNpY1N0YXRlUmVkdWNlcixcbiAgLy8gdXNlUmVkdWNlciBoYXMgYSBzcGVjaWFsIGNhc2UgdG8gc3VwcG9ydCBsYXp5IHVzZVN0YXRlIGluaXRpYWxpemVyc1xuICBpbml0aWFsU3RhdGUpO1xufVxuXG5mdW5jdGlvbiB1c2VSZWR1Y2VyKHJlZHVjZXIsIGluaXRpYWxBcmcsIGluaXQpIHtcbiAge1xuICAgIGlmIChyZWR1Y2VyICE9PSBiYXNpY1N0YXRlUmVkdWNlcikge1xuICAgICAgY3VycmVudEhvb2tOYW1lSW5EZXYgPSAndXNlUmVkdWNlcic7XG4gICAgfVxuICB9XG4gIGN1cnJlbnRseVJlbmRlcmluZ0NvbXBvbmVudCA9IHJlc29sdmVDdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQoKTtcbiAgd29ya0luUHJvZ3Jlc3NIb29rID0gY3JlYXRlV29ya0luUHJvZ3Jlc3NIb29rKCk7XG4gIGlmIChpc1JlUmVuZGVyKSB7XG4gICAgLy8gVGhpcyBpcyBhIHJlLXJlbmRlci4gQXBwbHkgdGhlIG5ldyByZW5kZXIgcGhhc2UgdXBkYXRlcyB0byB0aGUgcHJldmlvdXNcbiAgICB2YXIgX3F1ZXVlID0gd29ya0luUHJvZ3Jlc3NIb29rLnF1ZXVlO1xuICAgIHZhciBfZGlzcGF0Y2ggPSBfcXVldWUuZGlzcGF0Y2g7XG4gICAgaWYgKHJlbmRlclBoYXNlVXBkYXRlcyAhPT0gbnVsbCkge1xuICAgICAgLy8gUmVuZGVyIHBoYXNlIHVwZGF0ZXMgYXJlIHN0b3JlZCBpbiBhIG1hcCBvZiBxdWV1ZSAtPiBsaW5rZWQgbGlzdFxuICAgICAgdmFyIGZpcnN0UmVuZGVyUGhhc2VVcGRhdGUgPSByZW5kZXJQaGFzZVVwZGF0ZXMuZ2V0KF9xdWV1ZSk7XG4gICAgICBpZiAoZmlyc3RSZW5kZXJQaGFzZVVwZGF0ZSAhPT0gdW5kZWZpbmVkKSB7XG4gICAgICAgIHJlbmRlclBoYXNlVXBkYXRlcy5kZWxldGUoX3F1ZXVlKTtcbiAgICAgICAgdmFyIG5ld1N0YXRlID0gd29ya0luUHJvZ3Jlc3NIb29rLm1lbW9pemVkU3RhdGU7XG4gICAgICAgIHZhciB1cGRhdGUgPSBmaXJzdFJlbmRlclBoYXNlVXBkYXRlO1xuICAgICAgICBkbyB7XG4gICAgICAgICAgLy8gUHJvY2VzcyB0aGlzIHJlbmRlciBwaGFzZSB1cGRhdGUuIFdlIGRvbid0IGhhdmUgdG8gY2hlY2sgdGhlXG4gICAgICAgICAgLy8gcHJpb3JpdHkgYmVjYXVzZSBpdCB3aWxsIGFsd2F5cyBiZSB0aGUgc2FtZSBhcyB0aGUgY3VycmVudFxuICAgICAgICAgIC8vIHJlbmRlcidzLlxuICAgICAgICAgIHZhciBfYWN0aW9uID0gdXBkYXRlLmFjdGlvbjtcbiAgICAgICAgICB7XG4gICAgICAgICAgICBpc0luSG9va1VzZXJDb2RlSW5EZXYgPSB0cnVlO1xuICAgICAgICAgIH1cbiAgICAgICAgICBuZXdTdGF0ZSA9IHJlZHVjZXIobmV3U3RhdGUsIF9hY3Rpb24pO1xuICAgICAgICAgIHtcbiAgICAgICAgICAgIGlzSW5Ib29rVXNlckNvZGVJbkRldiA9IGZhbHNlO1xuICAgICAgICAgIH1cbiAgICAgICAgICB1cGRhdGUgPSB1cGRhdGUubmV4dDtcbiAgICAgICAgfSB3aGlsZSAodXBkYXRlICE9PSBudWxsKTtcblxuICAgICAgICB3b3JrSW5Qcm9ncmVzc0hvb2subWVtb2l6ZWRTdGF0ZSA9IG5ld1N0YXRlO1xuXG4gICAgICAgIHJldHVybiBbbmV3U3RhdGUsIF9kaXNwYXRjaF07XG4gICAgICB9XG4gICAgfVxuICAgIHJldHVybiBbd29ya0luUHJvZ3Jlc3NIb29rLm1lbW9pemVkU3RhdGUsIF9kaXNwYXRjaF07XG4gIH0gZWxzZSB7XG4gICAge1xuICAgICAgaXNJbkhvb2tVc2VyQ29kZUluRGV2ID0gdHJ1ZTtcbiAgICB9XG4gICAgdmFyIGluaXRpYWxTdGF0ZSA9IHZvaWQgMDtcbiAgICBpZiAocmVkdWNlciA9PT0gYmFzaWNTdGF0ZVJlZHVjZXIpIHtcbiAgICAgIC8vIFNwZWNpYWwgY2FzZSBmb3IgYHVzZVN0YXRlYC5cbiAgICAgIGluaXRpYWxTdGF0ZSA9IHR5cGVvZiBpbml0aWFsQXJnID09PSAnZnVuY3Rpb24nID8gaW5pdGlhbEFyZygpIDogaW5pdGlhbEFyZztcbiAgICB9IGVsc2Uge1xuICAgICAgaW5pdGlhbFN0YXRlID0gaW5pdCAhPT0gdW5kZWZpbmVkID8gaW5pdChpbml0aWFsQXJnKSA6IGluaXRpYWxBcmc7XG4gICAgfVxuICAgIHtcbiAgICAgIGlzSW5Ib29rVXNlckNvZGVJbkRldiA9IGZhbHNlO1xuICAgIH1cbiAgICB3b3JrSW5Qcm9ncmVzc0hvb2subWVtb2l6ZWRTdGF0ZSA9IGluaXRpYWxTdGF0ZTtcbiAgICB2YXIgX3F1ZXVlMiA9IHdvcmtJblByb2dyZXNzSG9vay5xdWV1ZSA9IHtcbiAgICAgIGxhc3Q6IG51bGwsXG4gICAgICBkaXNwYXRjaDogbnVsbFxuICAgIH07XG4gICAgdmFyIF9kaXNwYXRjaDIgPSBfcXVldWUyLmRpc3BhdGNoID0gZGlzcGF0Y2hBY3Rpb24uYmluZChudWxsLCBjdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQsIF9xdWV1ZTIpO1xuICAgIHJldHVybiBbd29ya0luUHJvZ3Jlc3NIb29rLm1lbW9pemVkU3RhdGUsIF9kaXNwYXRjaDJdO1xuICB9XG59XG5cbmZ1bmN0aW9uIHVzZU1lbW8obmV4dENyZWF0ZSwgZGVwcykge1xuICBjdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQgPSByZXNvbHZlQ3VycmVudGx5UmVuZGVyaW5nQ29tcG9uZW50KCk7XG4gIHdvcmtJblByb2dyZXNzSG9vayA9IGNyZWF0ZVdvcmtJblByb2dyZXNzSG9vaygpO1xuXG4gIHZhciBuZXh0RGVwcyA9IGRlcHMgPT09IHVuZGVmaW5lZCA/IG51bGwgOiBkZXBzO1xuXG4gIGlmICh3b3JrSW5Qcm9ncmVzc0hvb2sgIT09IG51bGwpIHtcbiAgICB2YXIgcHJldlN0YXRlID0gd29ya0luUHJvZ3Jlc3NIb29rLm1lbW9pemVkU3RhdGU7XG4gICAgaWYgKHByZXZTdGF0ZSAhPT0gbnVsbCkge1xuICAgICAgaWYgKG5leHREZXBzICE9PSBudWxsKSB7XG4gICAgICAgIHZhciBwcmV2RGVwcyA9IHByZXZTdGF0ZVsxXTtcbiAgICAgICAgaWYgKGFyZUhvb2tJbnB1dHNFcXVhbChuZXh0RGVwcywgcHJldkRlcHMpKSB7XG4gICAgICAgICAgcmV0dXJuIHByZXZTdGF0ZVswXTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgfVxuXG4gIHtcbiAgICBpc0luSG9va1VzZXJDb2RlSW5EZXYgPSB0cnVlO1xuICB9XG4gIHZhciBuZXh0VmFsdWUgPSBuZXh0Q3JlYXRlKCk7XG4gIHtcbiAgICBpc0luSG9va1VzZXJDb2RlSW5EZXYgPSBmYWxzZTtcbiAgfVxuICB3b3JrSW5Qcm9ncmVzc0hvb2subWVtb2l6ZWRTdGF0ZSA9IFtuZXh0VmFsdWUsIG5leHREZXBzXTtcbiAgcmV0dXJuIG5leHRWYWx1ZTtcbn1cblxuZnVuY3Rpb24gdXNlUmVmKGluaXRpYWxWYWx1ZSkge1xuICBjdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQgPSByZXNvbHZlQ3VycmVudGx5UmVuZGVyaW5nQ29tcG9uZW50KCk7XG4gIHdvcmtJblByb2dyZXNzSG9vayA9IGNyZWF0ZVdvcmtJblByb2dyZXNzSG9vaygpO1xuICB2YXIgcHJldmlvdXNSZWYgPSB3b3JrSW5Qcm9ncmVzc0hvb2subWVtb2l6ZWRTdGF0ZTtcbiAgaWYgKHByZXZpb3VzUmVmID09PSBudWxsKSB7XG4gICAgdmFyIHJlZiA9IHsgY3VycmVudDogaW5pdGlhbFZhbHVlIH07XG4gICAge1xuICAgICAgT2JqZWN0LnNlYWwocmVmKTtcbiAgICB9XG4gICAgd29ya0luUHJvZ3Jlc3NIb29rLm1lbW9pemVkU3RhdGUgPSByZWY7XG4gICAgcmV0dXJuIHJlZjtcbiAgfSBlbHNlIHtcbiAgICByZXR1cm4gcHJldmlvdXNSZWY7XG4gIH1cbn1cblxuZnVuY3Rpb24gdXNlTGF5b3V0RWZmZWN0KGNyZWF0ZSwgaW5wdXRzKSB7XG4gIHtcbiAgICBjdXJyZW50SG9va05hbWVJbkRldiA9ICd1c2VMYXlvdXRFZmZlY3QnO1xuICB9XG4gIHdhcm5pbmckMShmYWxzZSwgJ3VzZUxheW91dEVmZmVjdCBkb2VzIG5vdGhpbmcgb24gdGhlIHNlcnZlciwgYmVjYXVzZSBpdHMgZWZmZWN0IGNhbm5vdCAnICsgXCJiZSBlbmNvZGVkIGludG8gdGhlIHNlcnZlciByZW5kZXJlcidzIG91dHB1dCBmb3JtYXQuIFRoaXMgd2lsbCBsZWFkIFwiICsgJ3RvIGEgbWlzbWF0Y2ggYmV0d2VlbiB0aGUgaW5pdGlhbCwgbm9uLWh5ZHJhdGVkIFVJIGFuZCB0aGUgaW50ZW5kZWQgJyArICdVSS4gVG8gYXZvaWQgdGhpcywgdXNlTGF5b3V0RWZmZWN0IHNob3VsZCBvbmx5IGJlIHVzZWQgaW4gJyArICdjb21wb25lbnRzIHRoYXQgcmVuZGVyIGV4Y2x1c2l2ZWx5IG9uIHRoZSBjbGllbnQuJyk7XG59XG5cbmZ1bmN0aW9uIGRpc3BhdGNoQWN0aW9uKGNvbXBvbmVudElkZW50aXR5LCBxdWV1ZSwgYWN0aW9uKSB7XG4gICEobnVtYmVyT2ZSZVJlbmRlcnMgPCBSRV9SRU5ERVJfTElNSVQpID8gaW52YXJpYW50KGZhbHNlLCAnVG9vIG1hbnkgcmUtcmVuZGVycy4gUmVhY3QgbGltaXRzIHRoZSBudW1iZXIgb2YgcmVuZGVycyB0byBwcmV2ZW50IGFuIGluZmluaXRlIGxvb3AuJykgOiB2b2lkIDA7XG5cbiAgaWYgKGNvbXBvbmVudElkZW50aXR5ID09PSBjdXJyZW50bHlSZW5kZXJpbmdDb21wb25lbnQpIHtcbiAgICAvLyBUaGlzIGlzIGEgcmVuZGVyIHBoYXNlIHVwZGF0ZS4gU3Rhc2ggaXQgaW4gYSBsYXppbHktY3JlYXRlZCBtYXAgb2ZcbiAgICAvLyBxdWV1ZSAtPiBsaW5rZWQgbGlzdCBvZiB1cGRhdGVzLiBBZnRlciB0aGlzIHJlbmRlciBwYXNzLCB3ZSdsbCByZXN0YXJ0XG4gICAgLy8gYW5kIGFwcGx5IHRoZSBzdGFzaGVkIHVwZGF0ZXMgb24gdG9wIG9mIHRoZSB3b3JrLWluLXByb2dyZXNzIGhvb2suXG4gICAgZGlkU2NoZWR1bGVSZW5kZXJQaGFzZVVwZGF0ZSA9IHRydWU7XG4gICAgdmFyIHVwZGF0ZSA9IHtcbiAgICAgIGFjdGlvbjogYWN0aW9uLFxuICAgICAgbmV4dDogbnVsbFxuICAgIH07XG4gICAgaWYgKHJlbmRlclBoYXNlVXBkYXRlcyA9PT0gbnVsbCkge1xuICAgICAgcmVuZGVyUGhhc2VVcGRhdGVzID0gbmV3IE1hcCgpO1xuICAgIH1cbiAgICB2YXIgZmlyc3RSZW5kZXJQaGFzZVVwZGF0ZSA9IHJlbmRlclBoYXNlVXBkYXRlcy5nZXQocXVldWUpO1xuICAgIGlmIChmaXJzdFJlbmRlclBoYXNlVXBkYXRlID09PSB1bmRlZmluZWQpIHtcbiAgICAgIHJlbmRlclBoYXNlVXBkYXRlcy5zZXQocXVldWUsIHVwZGF0ZSk7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIEFwcGVuZCB0aGUgdXBkYXRlIHRvIHRoZSBlbmQgb2YgdGhlIGxpc3QuXG4gICAgICB2YXIgbGFzdFJlbmRlclBoYXNlVXBkYXRlID0gZmlyc3RSZW5kZXJQaGFzZVVwZGF0ZTtcbiAgICAgIHdoaWxlIChsYXN0UmVuZGVyUGhhc2VVcGRhdGUubmV4dCAhPT0gbnVsbCkge1xuICAgICAgICBsYXN0UmVuZGVyUGhhc2VVcGRhdGUgPSBsYXN0UmVuZGVyUGhhc2VVcGRhdGUubmV4dDtcbiAgICAgIH1cbiAgICAgIGxhc3RSZW5kZXJQaGFzZVVwZGF0ZS5uZXh0ID0gdXBkYXRlO1xuICAgIH1cbiAgfSBlbHNlIHtcbiAgICAvLyBUaGlzIG1lYW5zIGFuIHVwZGF0ZSBoYXMgaGFwcGVuZWQgYWZ0ZXIgdGhlIGZ1bmN0aW9uIGNvbXBvbmVudCBoYXNcbiAgICAvLyByZXR1cm5lZC4gT24gdGhlIHNlcnZlciB0aGlzIGlzIGEgbm8tb3AuIEluIFJlYWN0IEZpYmVyLCB0aGUgdXBkYXRlXG4gICAgLy8gd291bGQgYmUgc2NoZWR1bGVkIGZvciBhIGZ1dHVyZSByZW5kZXIuXG4gIH1cbn1cblxuZnVuY3Rpb24gdXNlQ2FsbGJhY2soY2FsbGJhY2ssIGRlcHMpIHtcbiAgLy8gQ2FsbGJhY2tzIGFyZSBwYXNzZWQgYXMgdGhleSBhcmUgaW4gdGhlIHNlcnZlciBlbnZpcm9ubWVudC5cbiAgcmV0dXJuIGNhbGxiYWNrO1xufVxuXG5mdW5jdGlvbiBub29wKCkge31cblxudmFyIGN1cnJlbnRUaHJlYWRJRCA9IDA7XG5cbmZ1bmN0aW9uIHNldEN1cnJlbnRUaHJlYWRJRCh0aHJlYWRJRCkge1xuICBjdXJyZW50VGhyZWFkSUQgPSB0aHJlYWRJRDtcbn1cblxudmFyIERpc3BhdGNoZXIgPSB7XG4gIHJlYWRDb250ZXh0OiByZWFkQ29udGV4dCxcbiAgdXNlQ29udGV4dDogdXNlQ29udGV4dCxcbiAgdXNlTWVtbzogdXNlTWVtbyxcbiAgdXNlUmVkdWNlcjogdXNlUmVkdWNlcixcbiAgdXNlUmVmOiB1c2VSZWYsXG4gIHVzZVN0YXRlOiB1c2VTdGF0ZSxcbiAgdXNlTGF5b3V0RWZmZWN0OiB1c2VMYXlvdXRFZmZlY3QsXG4gIHVzZUNhbGxiYWNrOiB1c2VDYWxsYmFjayxcbiAgLy8gdXNlSW1wZXJhdGl2ZUhhbmRsZSBpcyBub3QgcnVuIGluIHRoZSBzZXJ2ZXIgZW52aXJvbm1lbnRcbiAgdXNlSW1wZXJhdGl2ZUhhbmRsZTogbm9vcCxcbiAgLy8gRWZmZWN0cyBhcmUgbm90IHJ1biBpbiB0aGUgc2VydmVyIGVudmlyb25tZW50LlxuICB1c2VFZmZlY3Q6IG5vb3AsXG4gIC8vIERlYnVnZ2luZyBlZmZlY3RcbiAgdXNlRGVidWdWYWx1ZTogbm9vcFxufTtcblxudmFyIEhUTUxfTkFNRVNQQUNFID0gJ2h0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWwnO1xudmFyIE1BVEhfTkFNRVNQQUNFID0gJ2h0dHA6Ly93d3cudzMub3JnLzE5OTgvTWF0aC9NYXRoTUwnO1xudmFyIFNWR19OQU1FU1BBQ0UgPSAnaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnO1xuXG52YXIgTmFtZXNwYWNlcyA9IHtcbiAgaHRtbDogSFRNTF9OQU1FU1BBQ0UsXG4gIG1hdGhtbDogTUFUSF9OQU1FU1BBQ0UsXG4gIHN2ZzogU1ZHX05BTUVTUEFDRVxufTtcblxuLy8gQXNzdW1lcyB0aGVyZSBpcyBubyBwYXJlbnQgbmFtZXNwYWNlLlxuZnVuY3Rpb24gZ2V0SW50cmluc2ljTmFtZXNwYWNlKHR5cGUpIHtcbiAgc3dpdGNoICh0eXBlKSB7XG4gICAgY2FzZSAnc3ZnJzpcbiAgICAgIHJldHVybiBTVkdfTkFNRVNQQUNFO1xuICAgIGNhc2UgJ21hdGgnOlxuICAgICAgcmV0dXJuIE1BVEhfTkFNRVNQQUNFO1xuICAgIGRlZmF1bHQ6XG4gICAgICByZXR1cm4gSFRNTF9OQU1FU1BBQ0U7XG4gIH1cbn1cblxuZnVuY3Rpb24gZ2V0Q2hpbGROYW1lc3BhY2UocGFyZW50TmFtZXNwYWNlLCB0eXBlKSB7XG4gIGlmIChwYXJlbnROYW1lc3BhY2UgPT0gbnVsbCB8fCBwYXJlbnROYW1lc3BhY2UgPT09IEhUTUxfTkFNRVNQQUNFKSB7XG4gICAgLy8gTm8gKG9yIGRlZmF1bHQpIHBhcmVudCBuYW1lc3BhY2U6IHBvdGVudGlhbCBlbnRyeSBwb2ludC5cbiAgICByZXR1cm4gZ2V0SW50cmluc2ljTmFtZXNwYWNlKHR5cGUpO1xuICB9XG4gIGlmIChwYXJlbnROYW1lc3BhY2UgPT09IFNWR19OQU1FU1BBQ0UgJiYgdHlwZSA9PT0gJ2ZvcmVpZ25PYmplY3QnKSB7XG4gICAgLy8gV2UncmUgbGVhdmluZyBTVkcuXG4gICAgcmV0dXJuIEhUTUxfTkFNRVNQQUNFO1xuICB9XG4gIC8vIEJ5IGRlZmF1bHQsIHBhc3MgbmFtZXNwYWNlIGJlbG93LlxuICByZXR1cm4gcGFyZW50TmFtZXNwYWNlO1xufVxuXG52YXIgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZSQyID0gbnVsbDtcblxudmFyIFJlYWN0Q29udHJvbGxlZFZhbHVlUHJvcFR5cGVzID0ge1xuICBjaGVja1Byb3BUeXBlczogbnVsbFxufTtcblxue1xuICBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDIgPSBSZWFjdFNoYXJlZEludGVybmFscy5SZWFjdERlYnVnQ3VycmVudEZyYW1lO1xuXG4gIHZhciBoYXNSZWFkT25seVZhbHVlID0ge1xuICAgIGJ1dHRvbjogdHJ1ZSxcbiAgICBjaGVja2JveDogdHJ1ZSxcbiAgICBpbWFnZTogdHJ1ZSxcbiAgICBoaWRkZW46IHRydWUsXG4gICAgcmFkaW86IHRydWUsXG4gICAgcmVzZXQ6IHRydWUsXG4gICAgc3VibWl0OiB0cnVlXG4gIH07XG5cbiAgdmFyIHByb3BUeXBlcyA9IHtcbiAgICB2YWx1ZTogZnVuY3Rpb24gKHByb3BzLCBwcm9wTmFtZSwgY29tcG9uZW50TmFtZSkge1xuICAgICAgaWYgKGhhc1JlYWRPbmx5VmFsdWVbcHJvcHMudHlwZV0gfHwgcHJvcHMub25DaGFuZ2UgfHwgcHJvcHMucmVhZE9ubHkgfHwgcHJvcHMuZGlzYWJsZWQgfHwgcHJvcHNbcHJvcE5hbWVdID09IG51bGwpIHtcbiAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICB9XG4gICAgICByZXR1cm4gbmV3IEVycm9yKCdZb3UgcHJvdmlkZWQgYSBgdmFsdWVgIHByb3AgdG8gYSBmb3JtIGZpZWxkIHdpdGhvdXQgYW4gJyArICdgb25DaGFuZ2VgIGhhbmRsZXIuIFRoaXMgd2lsbCByZW5kZXIgYSByZWFkLW9ubHkgZmllbGQuIElmICcgKyAndGhlIGZpZWxkIHNob3VsZCBiZSBtdXRhYmxlIHVzZSBgZGVmYXVsdFZhbHVlYC4gT3RoZXJ3aXNlLCAnICsgJ3NldCBlaXRoZXIgYG9uQ2hhbmdlYCBvciBgcmVhZE9ubHlgLicpO1xuICAgIH0sXG4gICAgY2hlY2tlZDogZnVuY3Rpb24gKHByb3BzLCBwcm9wTmFtZSwgY29tcG9uZW50TmFtZSkge1xuICAgICAgaWYgKHByb3BzLm9uQ2hhbmdlIHx8IHByb3BzLnJlYWRPbmx5IHx8IHByb3BzLmRpc2FibGVkIHx8IHByb3BzW3Byb3BOYW1lXSA9PSBudWxsKSB7XG4gICAgICAgIHJldHVybiBudWxsO1xuICAgICAgfVxuICAgICAgcmV0dXJuIG5ldyBFcnJvcignWW91IHByb3ZpZGVkIGEgYGNoZWNrZWRgIHByb3AgdG8gYSBmb3JtIGZpZWxkIHdpdGhvdXQgYW4gJyArICdgb25DaGFuZ2VgIGhhbmRsZXIuIFRoaXMgd2lsbCByZW5kZXIgYSByZWFkLW9ubHkgZmllbGQuIElmICcgKyAndGhlIGZpZWxkIHNob3VsZCBiZSBtdXRhYmxlIHVzZSBgZGVmYXVsdENoZWNrZWRgLiBPdGhlcndpc2UsICcgKyAnc2V0IGVpdGhlciBgb25DaGFuZ2VgIG9yIGByZWFkT25seWAuJyk7XG4gICAgfVxuICB9O1xuXG4gIC8qKlxuICAgKiBQcm92aWRlIGEgbGlua2VkIGB2YWx1ZWAgYXR0cmlidXRlIGZvciBjb250cm9sbGVkIGZvcm1zLiBZb3Ugc2hvdWxkIG5vdCB1c2VcbiAgICogdGhpcyBvdXRzaWRlIG9mIHRoZSBSZWFjdERPTSBjb250cm9sbGVkIGZvcm0gY29tcG9uZW50cy5cbiAgICovXG4gIFJlYWN0Q29udHJvbGxlZFZhbHVlUHJvcFR5cGVzLmNoZWNrUHJvcFR5cGVzID0gZnVuY3Rpb24gKHRhZ05hbWUsIHByb3BzKSB7XG4gICAgY2hlY2tQcm9wVHlwZXMocHJvcFR5cGVzLCBwcm9wcywgJ3Byb3AnLCB0YWdOYW1lLCBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDIuZ2V0U3RhY2tBZGRlbmR1bSk7XG4gIH07XG59XG5cbi8vIEZvciBIVE1MLCBjZXJ0YWluIHRhZ3Mgc2hvdWxkIG9taXQgdGhlaXIgY2xvc2UgdGFnLiBXZSBrZWVwIGEgd2hpdGVsaXN0IGZvclxuLy8gdGhvc2Ugc3BlY2lhbC1jYXNlIHRhZ3MuXG5cbnZhciBvbWl0dGVkQ2xvc2VUYWdzID0ge1xuICBhcmVhOiB0cnVlLFxuICBiYXNlOiB0cnVlLFxuICBicjogdHJ1ZSxcbiAgY29sOiB0cnVlLFxuICBlbWJlZDogdHJ1ZSxcbiAgaHI6IHRydWUsXG4gIGltZzogdHJ1ZSxcbiAgaW5wdXQ6IHRydWUsXG4gIGtleWdlbjogdHJ1ZSxcbiAgbGluazogdHJ1ZSxcbiAgbWV0YTogdHJ1ZSxcbiAgcGFyYW06IHRydWUsXG4gIHNvdXJjZTogdHJ1ZSxcbiAgdHJhY2s6IHRydWUsXG4gIHdicjogdHJ1ZVxuICAvLyBOT1RFOiBtZW51aXRlbSdzIGNsb3NlIHRhZyBzaG91bGQgYmUgb21pdHRlZCwgYnV0IHRoYXQgY2F1c2VzIHByb2JsZW1zLlxufTtcblxuLy8gRm9yIEhUTUwsIGNlcnRhaW4gdGFncyBjYW5ub3QgaGF2ZSBjaGlsZHJlbi4gVGhpcyBoYXMgdGhlIHNhbWUgcHVycG9zZSBhc1xuLy8gYG9taXR0ZWRDbG9zZVRhZ3NgIGV4Y2VwdCB0aGF0IGBtZW51aXRlbWAgc2hvdWxkIHN0aWxsIGhhdmUgaXRzIGNsb3NpbmcgdGFnLlxuXG52YXIgdm9pZEVsZW1lbnRUYWdzID0gX2Fzc2lnbih7XG4gIG1lbnVpdGVtOiB0cnVlXG59LCBvbWl0dGVkQ2xvc2VUYWdzKTtcblxuLy8gVE9ETzogV2UgY2FuIHJlbW92ZSB0aGlzIGlmIHdlIGFkZCBpbnZhcmlhbnRXaXRoU3RhY2soKVxuLy8gb3IgYWRkIHN0YWNrIGJ5IGRlZmF1bHQgdG8gaW52YXJpYW50cyB3aGVyZSBwb3NzaWJsZS5cbnZhciBIVE1MID0gJ19faHRtbCc7XG5cbnZhciBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDMgPSBudWxsO1xue1xuICBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDMgPSBSZWFjdFNoYXJlZEludGVybmFscy5SZWFjdERlYnVnQ3VycmVudEZyYW1lO1xufVxuXG5mdW5jdGlvbiBhc3NlcnRWYWxpZFByb3BzKHRhZywgcHJvcHMpIHtcbiAgaWYgKCFwcm9wcykge1xuICAgIHJldHVybjtcbiAgfVxuICAvLyBOb3RlIHRoZSB1c2Ugb2YgYD09YCB3aGljaCBjaGVja3MgZm9yIG51bGwgb3IgdW5kZWZpbmVkLlxuICBpZiAodm9pZEVsZW1lbnRUYWdzW3RhZ10pIHtcbiAgICAhKHByb3BzLmNoaWxkcmVuID09IG51bGwgJiYgcHJvcHMuZGFuZ2Vyb3VzbHlTZXRJbm5lckhUTUwgPT0gbnVsbCkgPyBpbnZhcmlhbnQoZmFsc2UsICclcyBpcyBhIHZvaWQgZWxlbWVudCB0YWcgYW5kIG11c3QgbmVpdGhlciBoYXZlIGBjaGlsZHJlbmAgbm9yIHVzZSBgZGFuZ2Vyb3VzbHlTZXRJbm5lckhUTUxgLiVzJywgdGFnLCBSZWFjdERlYnVnQ3VycmVudEZyYW1lJDMuZ2V0U3RhY2tBZGRlbmR1bSgpKSA6IHZvaWQgMDtcbiAgfVxuICBpZiAocHJvcHMuZGFuZ2Vyb3VzbHlTZXRJbm5lckhUTUwgIT0gbnVsbCkge1xuICAgICEocHJvcHMuY2hpbGRyZW4gPT0gbnVsbCkgPyBpbnZhcmlhbnQoZmFsc2UsICdDYW4gb25seSBzZXQgb25lIG9mIGBjaGlsZHJlbmAgb3IgYHByb3BzLmRhbmdlcm91c2x5U2V0SW5uZXJIVE1MYC4nKSA6IHZvaWQgMDtcbiAgICAhKHR5cGVvZiBwcm9wcy5kYW5nZXJvdXNseVNldElubmVySFRNTCA9PT0gJ29iamVjdCcgJiYgSFRNTCBpbiBwcm9wcy5kYW5nZXJvdXNseVNldElubmVySFRNTCkgPyBpbnZhcmlhbnQoZmFsc2UsICdgcHJvcHMuZGFuZ2Vyb3VzbHlTZXRJbm5lckhUTUxgIG11c3QgYmUgaW4gdGhlIGZvcm0gYHtfX2h0bWw6IC4uLn1gLiBQbGVhc2UgdmlzaXQgaHR0cHM6Ly9mYi5tZS9yZWFjdC1pbnZhcmlhbnQtZGFuZ2Vyb3VzbHktc2V0LWlubmVyLWh0bWwgZm9yIG1vcmUgaW5mb3JtYXRpb24uJykgOiB2b2lkIDA7XG4gIH1cbiAge1xuICAgICEocHJvcHMuc3VwcHJlc3NDb250ZW50RWRpdGFibGVXYXJuaW5nIHx8ICFwcm9wcy5jb250ZW50RWRpdGFibGUgfHwgcHJvcHMuY2hpbGRyZW4gPT0gbnVsbCkgPyB3YXJuaW5nJDEoZmFsc2UsICdBIGNvbXBvbmVudCBpcyBgY29udGVudEVkaXRhYmxlYCBhbmQgY29udGFpbnMgYGNoaWxkcmVuYCBtYW5hZ2VkIGJ5ICcgKyAnUmVhY3QuIEl0IGlzIG5vdyB5b3VyIHJlc3BvbnNpYmlsaXR5IHRvIGd1YXJhbnRlZSB0aGF0IG5vbmUgb2YgJyArICd0aG9zZSBub2RlcyBhcmUgdW5leHBlY3RlZGx5IG1vZGlmaWVkIG9yIGR1cGxpY2F0ZWQuIFRoaXMgaXMgJyArICdwcm9iYWJseSBub3QgaW50ZW50aW9uYWwuJykgOiB2b2lkIDA7XG4gIH1cbiAgIShwcm9wcy5zdHlsZSA9PSBudWxsIHx8IHR5cGVvZiBwcm9wcy5zdHlsZSA9PT0gJ29iamVjdCcpID8gaW52YXJpYW50KGZhbHNlLCAnVGhlIGBzdHlsZWAgcHJvcCBleHBlY3RzIGEgbWFwcGluZyBmcm9tIHN0eWxlIHByb3BlcnRpZXMgdG8gdmFsdWVzLCBub3QgYSBzdHJpbmcuIEZvciBleGFtcGxlLCBzdHlsZT17e21hcmdpblJpZ2h0OiBzcGFjaW5nICsgXFwnZW1cXCd9fSB3aGVuIHVzaW5nIEpTWC4lcycsIFJlYWN0RGVidWdDdXJyZW50RnJhbWUkMy5nZXRTdGFja0FkZGVuZHVtKCkpIDogdm9pZCAwO1xufVxuXG4vKipcbiAqIENTUyBwcm9wZXJ0aWVzIHdoaWNoIGFjY2VwdCBudW1iZXJzIGJ1dCBhcmUgbm90IGluIHVuaXRzIG9mIFwicHhcIi5cbiAqL1xudmFyIGlzVW5pdGxlc3NOdW1iZXIgPSB7XG4gIGFuaW1hdGlvbkl0ZXJhdGlvbkNvdW50OiB0cnVlLFxuICBib3JkZXJJbWFnZU91dHNldDogdHJ1ZSxcbiAgYm9yZGVySW1hZ2VTbGljZTogdHJ1ZSxcbiAgYm9yZGVySW1hZ2VXaWR0aDogdHJ1ZSxcbiAgYm94RmxleDogdHJ1ZSxcbiAgYm94RmxleEdyb3VwOiB0cnVlLFxuICBib3hPcmRpbmFsR3JvdXA6IHRydWUsXG4gIGNvbHVtbkNvdW50OiB0cnVlLFxuICBjb2x1bW5zOiB0cnVlLFxuICBmbGV4OiB0cnVlLFxuICBmbGV4R3JvdzogdHJ1ZSxcbiAgZmxleFBvc2l0aXZlOiB0cnVlLFxuICBmbGV4U2hyaW5rOiB0cnVlLFxuICBmbGV4TmVnYXRpdmU6IHRydWUsXG4gIGZsZXhPcmRlcjogdHJ1ZSxcbiAgZ3JpZEFyZWE6IHRydWUsXG4gIGdyaWRSb3c6IHRydWUsXG4gIGdyaWRSb3dFbmQ6IHRydWUsXG4gIGdyaWRSb3dTcGFuOiB0cnVlLFxuICBncmlkUm93U3RhcnQ6IHRydWUsXG4gIGdyaWRDb2x1bW46IHRydWUsXG4gIGdyaWRDb2x1bW5FbmQ6IHRydWUsXG4gIGdyaWRDb2x1bW5TcGFuOiB0cnVlLFxuICBncmlkQ29sdW1uU3RhcnQ6IHRydWUsXG4gIGZvbnRXZWlnaHQ6IHRydWUsXG4gIGxpbmVDbGFtcDogdHJ1ZSxcbiAgbGluZUhlaWdodDogdHJ1ZSxcbiAgb3BhY2l0eTogdHJ1ZSxcbiAgb3JkZXI6IHRydWUsXG4gIG9ycGhhbnM6IHRydWUsXG4gIHRhYlNpemU6IHRydWUsXG4gIHdpZG93czogdHJ1ZSxcbiAgekluZGV4OiB0cnVlLFxuICB6b29tOiB0cnVlLFxuXG4gIC8vIFNWRy1yZWxhdGVkIHByb3BlcnRpZXNcbiAgZmlsbE9wYWNpdHk6IHRydWUsXG4gIGZsb29kT3BhY2l0eTogdHJ1ZSxcbiAgc3RvcE9wYWNpdHk6IHRydWUsXG4gIHN0cm9rZURhc2hhcnJheTogdHJ1ZSxcbiAgc3Ryb2tlRGFzaG9mZnNldDogdHJ1ZSxcbiAgc3Ryb2tlTWl0ZXJsaW1pdDogdHJ1ZSxcbiAgc3Ryb2tlT3BhY2l0eTogdHJ1ZSxcbiAgc3Ryb2tlV2lkdGg6IHRydWVcbn07XG5cbi8qKlxuICogQHBhcmFtIHtzdHJpbmd9IHByZWZpeCB2ZW5kb3Itc3BlY2lmaWMgcHJlZml4LCBlZzogV2Via2l0XG4gKiBAcGFyYW0ge3N0cmluZ30ga2V5IHN0eWxlIG5hbWUsIGVnOiB0cmFuc2l0aW9uRHVyYXRpb25cbiAqIEByZXR1cm4ge3N0cmluZ30gc3R5bGUgbmFtZSBwcmVmaXhlZCB3aXRoIGBwcmVmaXhgLCBwcm9wZXJseSBjYW1lbENhc2VkLCBlZzpcbiAqIFdlYmtpdFRyYW5zaXRpb25EdXJhdGlvblxuICovXG5mdW5jdGlvbiBwcmVmaXhLZXkocHJlZml4LCBrZXkpIHtcbiAgcmV0dXJuIHByZWZpeCArIGtleS5jaGFyQXQoMCkudG9VcHBlckNhc2UoKSArIGtleS5zdWJzdHJpbmcoMSk7XG59XG5cbi8qKlxuICogU3VwcG9ydCBzdHlsZSBuYW1lcyB0aGF0IG1heSBjb21lIHBhc3NlZCBpbiBwcmVmaXhlZCBieSBhZGRpbmcgcGVybXV0YXRpb25zXG4gKiBvZiB2ZW5kb3IgcHJlZml4ZXMuXG4gKi9cbnZhciBwcmVmaXhlcyA9IFsnV2Via2l0JywgJ21zJywgJ01veicsICdPJ107XG5cbi8vIFVzaW5nIE9iamVjdC5rZXlzIGhlcmUsIG9yIGVsc2UgdGhlIHZhbmlsbGEgZm9yLWluIGxvb3AgbWFrZXMgSUU4IGdvIGludG8gYW5cbi8vIGluZmluaXRlIGxvb3AsIGJlY2F1c2UgaXQgaXRlcmF0ZXMgb3ZlciB0aGUgbmV3bHkgYWRkZWQgcHJvcHMgdG9vLlxuT2JqZWN0LmtleXMoaXNVbml0bGVzc051bWJlcikuZm9yRWFjaChmdW5jdGlvbiAocHJvcCkge1xuICBwcmVmaXhlcy5mb3JFYWNoKGZ1bmN0aW9uIChwcmVmaXgpIHtcbiAgICBpc1VuaXRsZXNzTnVtYmVyW3ByZWZpeEtleShwcmVmaXgsIHByb3ApXSA9IGlzVW5pdGxlc3NOdW1iZXJbcHJvcF07XG4gIH0pO1xufSk7XG5cbi8qKlxuICogQ29udmVydCBhIHZhbHVlIGludG8gdGhlIHByb3BlciBjc3Mgd3JpdGFibGUgdmFsdWUuIFRoZSBzdHlsZSBuYW1lIGBuYW1lYFxuICogc2hvdWxkIGJlIGxvZ2ljYWwgKG5vIGh5cGhlbnMpLCBhcyBzcGVjaWZpZWRcbiAqIGluIGBDU1NQcm9wZXJ0eS5pc1VuaXRsZXNzTnVtYmVyYC5cbiAqXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZSBDU1MgcHJvcGVydHkgbmFtZSBzdWNoIGFzIGB0b3BNYXJnaW5gLlxuICogQHBhcmFtIHsqfSB2YWx1ZSBDU1MgcHJvcGVydHkgdmFsdWUgc3VjaCBhcyBgMTBweGAuXG4gKiBAcmV0dXJuIHtzdHJpbmd9IE5vcm1hbGl6ZWQgc3R5bGUgdmFsdWUgd2l0aCBkaW1lbnNpb25zIGFwcGxpZWQuXG4gKi9cbmZ1bmN0aW9uIGRhbmdlcm91c1N0eWxlVmFsdWUobmFtZSwgdmFsdWUsIGlzQ3VzdG9tUHJvcGVydHkpIHtcbiAgLy8gTm90ZSB0aGF0IHdlJ3ZlIHJlbW92ZWQgZXNjYXBlVGV4dEZvckJyb3dzZXIoKSBjYWxscyBoZXJlIHNpbmNlIHRoZVxuICAvLyB3aG9sZSBzdHJpbmcgd2lsbCBiZSBlc2NhcGVkIHdoZW4gdGhlIGF0dHJpYnV0ZSBpcyBpbmplY3RlZCBpbnRvXG4gIC8vIHRoZSBtYXJrdXAuIElmIHlvdSBwcm92aWRlIHVuc2FmZSB1c2VyIGRhdGEgaGVyZSB0aGV5IGNhbiBpbmplY3RcbiAgLy8gYXJiaXRyYXJ5IENTUyB3aGljaCBtYXkgYmUgcHJvYmxlbWF0aWMgKEkgY291bGRuJ3QgcmVwcm8gdGhpcyk6XG4gIC8vIGh0dHBzOi8vd3d3Lm93YXNwLm9yZy9pbmRleC5waHAvWFNTX0ZpbHRlcl9FdmFzaW9uX0NoZWF0X1NoZWV0XG4gIC8vIGh0dHA6Ly93d3cudGhlc3Bhbm5lci5jby51ay8yMDA3LzExLzI2L3VsdGltYXRlLXhzcy1jc3MtaW5qZWN0aW9uL1xuICAvLyBUaGlzIGlzIG5vdCBhbiBYU1MgaG9sZSBidXQgaW5zdGVhZCBhIHBvdGVudGlhbCBDU1MgaW5qZWN0aW9uIGlzc3VlXG4gIC8vIHdoaWNoIGhhcyBsZWFkIHRvIGEgZ3JlYXRlciBkaXNjdXNzaW9uIGFib3V0IGhvdyB3ZSdyZSBnb2luZyB0b1xuICAvLyB0cnVzdCBVUkxzIG1vdmluZyBmb3J3YXJkLiBTZWUgIzIxMTU5MDFcblxuICB2YXIgaXNFbXB0eSA9IHZhbHVlID09IG51bGwgfHwgdHlwZW9mIHZhbHVlID09PSAnYm9vbGVhbicgfHwgdmFsdWUgPT09ICcnO1xuICBpZiAoaXNFbXB0eSkge1xuICAgIHJldHVybiAnJztcbiAgfVxuXG4gIGlmICghaXNDdXN0b21Qcm9wZXJ0eSAmJiB0eXBlb2YgdmFsdWUgPT09ICdudW1iZXInICYmIHZhbHVlICE9PSAwICYmICEoaXNVbml0bGVzc051bWJlci5oYXNPd25Qcm9wZXJ0eShuYW1lKSAmJiBpc1VuaXRsZXNzTnVtYmVyW25hbWVdKSkge1xuICAgIHJldHVybiB2YWx1ZSArICdweCc7IC8vIFByZXN1bWVzIGltcGxpY2l0ICdweCcgc3VmZml4IGZvciB1bml0bGVzcyBudW1iZXJzXG4gIH1cblxuICByZXR1cm4gKCcnICsgdmFsdWUpLnRyaW0oKTtcbn1cblxudmFyIHVwcGVyY2FzZVBhdHRlcm4gPSAvKFtBLVpdKS9nO1xudmFyIG1zUGF0dGVybiA9IC9ebXMtLztcblxuLyoqXG4gKiBIeXBoZW5hdGVzIGEgY2FtZWxjYXNlZCBDU1MgcHJvcGVydHkgbmFtZSwgZm9yIGV4YW1wbGU6XG4gKlxuICogICA+IGh5cGhlbmF0ZVN0eWxlTmFtZSgnYmFja2dyb3VuZENvbG9yJylcbiAqICAgPCBcImJhY2tncm91bmQtY29sb3JcIlxuICogICA+IGh5cGhlbmF0ZVN0eWxlTmFtZSgnTW96VHJhbnNpdGlvbicpXG4gKiAgIDwgXCItbW96LXRyYW5zaXRpb25cIlxuICogICA+IGh5cGhlbmF0ZVN0eWxlTmFtZSgnbXNUcmFuc2l0aW9uJylcbiAqICAgPCBcIi1tcy10cmFuc2l0aW9uXCJcbiAqXG4gKiBBcyBNb2Rlcm5penIgc3VnZ2VzdHMgKGh0dHA6Ly9tb2Rlcm5penIuY29tL2RvY3MvI3ByZWZpeGVkKSwgYW4gYG1zYCBwcmVmaXhcbiAqIGlzIGNvbnZlcnRlZCB0byBgLW1zLWAuXG4gKi9cbmZ1bmN0aW9uIGh5cGhlbmF0ZVN0eWxlTmFtZShuYW1lKSB7XG4gIHJldHVybiBuYW1lLnJlcGxhY2UodXBwZXJjYXNlUGF0dGVybiwgJy0kMScpLnRvTG93ZXJDYXNlKCkucmVwbGFjZShtc1BhdHRlcm4sICctbXMtJyk7XG59XG5cbmZ1bmN0aW9uIGlzQ3VzdG9tQ29tcG9uZW50KHRhZ05hbWUsIHByb3BzKSB7XG4gIGlmICh0YWdOYW1lLmluZGV4T2YoJy0nKSA9PT0gLTEpIHtcbiAgICByZXR1cm4gdHlwZW9mIHByb3BzLmlzID09PSAnc3RyaW5nJztcbiAgfVxuICBzd2l0Y2ggKHRhZ05hbWUpIHtcbiAgICAvLyBUaGVzZSBhcmUgcmVzZXJ2ZWQgU1ZHIGFuZCBNYXRoTUwgZWxlbWVudHMuXG4gICAgLy8gV2UgZG9uJ3QgbWluZCB0aGlzIHdoaXRlbGlzdCB0b28gbXVjaCBiZWNhdXNlIHdlIGV4cGVjdCBpdCB0byBuZXZlciBncm93LlxuICAgIC8vIFRoZSBhbHRlcm5hdGl2ZSBpcyB0byB0cmFjayB0aGUgbmFtZXNwYWNlIGluIGEgZmV3IHBsYWNlcyB3aGljaCBpcyBjb252b2x1dGVkLlxuICAgIC8vIGh0dHBzOi8vdzNjLmdpdGh1Yi5pby93ZWJjb21wb25lbnRzL3NwZWMvY3VzdG9tLyNjdXN0b20tZWxlbWVudHMtY29yZS1jb25jZXB0c1xuICAgIGNhc2UgJ2Fubm90YXRpb24teG1sJzpcbiAgICBjYXNlICdjb2xvci1wcm9maWxlJzpcbiAgICBjYXNlICdmb250LWZhY2UnOlxuICAgIGNhc2UgJ2ZvbnQtZmFjZS1zcmMnOlxuICAgIGNhc2UgJ2ZvbnQtZmFjZS11cmknOlxuICAgIGNhc2UgJ2ZvbnQtZmFjZS1mb3JtYXQnOlxuICAgIGNhc2UgJ2ZvbnQtZmFjZS1uYW1lJzpcbiAgICBjYXNlICdtaXNzaW5nLWdseXBoJzpcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICBkZWZhdWx0OlxuICAgICAgcmV0dXJuIHRydWU7XG4gIH1cbn1cblxudmFyIHdhcm5WYWxpZFN0eWxlID0gZnVuY3Rpb24gKCkge307XG5cbntcbiAgLy8gJ21zVHJhbnNmb3JtJyBpcyBjb3JyZWN0LCBidXQgdGhlIG90aGVyIHByZWZpeGVzIHNob3VsZCBiZSBjYXBpdGFsaXplZFxuICB2YXIgYmFkVmVuZG9yZWRTdHlsZU5hbWVQYXR0ZXJuID0gL14oPzp3ZWJraXR8bW96fG8pW0EtWl0vO1xuICB2YXIgbXNQYXR0ZXJuJDEgPSAvXi1tcy0vO1xuICB2YXIgaHlwaGVuUGF0dGVybiA9IC8tKC4pL2c7XG5cbiAgLy8gc3R5bGUgdmFsdWVzIHNob3VsZG4ndCBjb250YWluIGEgc2VtaWNvbG9uXG4gIHZhciBiYWRTdHlsZVZhbHVlV2l0aFNlbWljb2xvblBhdHRlcm4gPSAvO1xccyokLztcblxuICB2YXIgd2FybmVkU3R5bGVOYW1lcyA9IHt9O1xuICB2YXIgd2FybmVkU3R5bGVWYWx1ZXMgPSB7fTtcbiAgdmFyIHdhcm5lZEZvck5hTlZhbHVlID0gZmFsc2U7XG4gIHZhciB3YXJuZWRGb3JJbmZpbml0eVZhbHVlID0gZmFsc2U7XG5cbiAgdmFyIGNhbWVsaXplID0gZnVuY3Rpb24gKHN0cmluZykge1xuICAgIHJldHVybiBzdHJpbmcucmVwbGFjZShoeXBoZW5QYXR0ZXJuLCBmdW5jdGlvbiAoXywgY2hhcmFjdGVyKSB7XG4gICAgICByZXR1cm4gY2hhcmFjdGVyLnRvVXBwZXJDYXNlKCk7XG4gICAgfSk7XG4gIH07XG5cbiAgdmFyIHdhcm5IeXBoZW5hdGVkU3R5bGVOYW1lID0gZnVuY3Rpb24gKG5hbWUpIHtcbiAgICBpZiAod2FybmVkU3R5bGVOYW1lcy5oYXNPd25Qcm9wZXJ0eShuYW1lKSAmJiB3YXJuZWRTdHlsZU5hbWVzW25hbWVdKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgd2FybmVkU3R5bGVOYW1lc1tuYW1lXSA9IHRydWU7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnVW5zdXBwb3J0ZWQgc3R5bGUgcHJvcGVydHkgJXMuIERpZCB5b3UgbWVhbiAlcz8nLCBuYW1lLFxuICAgIC8vIEFzIEFuZGkgU21pdGggc3VnZ2VzdHNcbiAgICAvLyAoaHR0cDovL3d3dy5hbmRpc21pdGguY29tL2Jsb2cvMjAxMi8wMi9tb2Rlcm5penItcHJlZml4ZWQvKSwgYW4gYC1tc2AgcHJlZml4XG4gICAgLy8gaXMgY29udmVydGVkIHRvIGxvd2VyY2FzZSBgbXNgLlxuICAgIGNhbWVsaXplKG5hbWUucmVwbGFjZShtc1BhdHRlcm4kMSwgJ21zLScpKSk7XG4gIH07XG5cbiAgdmFyIHdhcm5CYWRWZW5kb3JlZFN0eWxlTmFtZSA9IGZ1bmN0aW9uIChuYW1lKSB7XG4gICAgaWYgKHdhcm5lZFN0eWxlTmFtZXMuaGFzT3duUHJvcGVydHkobmFtZSkgJiYgd2FybmVkU3R5bGVOYW1lc1tuYW1lXSkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIHdhcm5lZFN0eWxlTmFtZXNbbmFtZV0gPSB0cnVlO1xuICAgIHdhcm5pbmckMShmYWxzZSwgJ1Vuc3VwcG9ydGVkIHZlbmRvci1wcmVmaXhlZCBzdHlsZSBwcm9wZXJ0eSAlcy4gRGlkIHlvdSBtZWFuICVzPycsIG5hbWUsIG5hbWUuY2hhckF0KDApLnRvVXBwZXJDYXNlKCkgKyBuYW1lLnNsaWNlKDEpKTtcbiAgfTtcblxuICB2YXIgd2FyblN0eWxlVmFsdWVXaXRoU2VtaWNvbG9uID0gZnVuY3Rpb24gKG5hbWUsIHZhbHVlKSB7XG4gICAgaWYgKHdhcm5lZFN0eWxlVmFsdWVzLmhhc093blByb3BlcnR5KHZhbHVlKSAmJiB3YXJuZWRTdHlsZVZhbHVlc1t2YWx1ZV0pIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICB3YXJuZWRTdHlsZVZhbHVlc1t2YWx1ZV0gPSB0cnVlO1xuICAgIHdhcm5pbmckMShmYWxzZSwgXCJTdHlsZSBwcm9wZXJ0eSB2YWx1ZXMgc2hvdWxkbid0IGNvbnRhaW4gYSBzZW1pY29sb24uIFwiICsgJ1RyeSBcIiVzOiAlc1wiIGluc3RlYWQuJywgbmFtZSwgdmFsdWUucmVwbGFjZShiYWRTdHlsZVZhbHVlV2l0aFNlbWljb2xvblBhdHRlcm4sICcnKSk7XG4gIH07XG5cbiAgdmFyIHdhcm5TdHlsZVZhbHVlSXNOYU4gPSBmdW5jdGlvbiAobmFtZSwgdmFsdWUpIHtcbiAgICBpZiAod2FybmVkRm9yTmFOVmFsdWUpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICB3YXJuZWRGb3JOYU5WYWx1ZSA9IHRydWU7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnYE5hTmAgaXMgYW4gaW52YWxpZCB2YWx1ZSBmb3IgdGhlIGAlc2AgY3NzIHN0eWxlIHByb3BlcnR5LicsIG5hbWUpO1xuICB9O1xuXG4gIHZhciB3YXJuU3R5bGVWYWx1ZUlzSW5maW5pdHkgPSBmdW5jdGlvbiAobmFtZSwgdmFsdWUpIHtcbiAgICBpZiAod2FybmVkRm9ySW5maW5pdHlWYWx1ZSkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIHdhcm5lZEZvckluZmluaXR5VmFsdWUgPSB0cnVlO1xuICAgIHdhcm5pbmckMShmYWxzZSwgJ2BJbmZpbml0eWAgaXMgYW4gaW52YWxpZCB2YWx1ZSBmb3IgdGhlIGAlc2AgY3NzIHN0eWxlIHByb3BlcnR5LicsIG5hbWUpO1xuICB9O1xuXG4gIHdhcm5WYWxpZFN0eWxlID0gZnVuY3Rpb24gKG5hbWUsIHZhbHVlKSB7XG4gICAgaWYgKG5hbWUuaW5kZXhPZignLScpID4gLTEpIHtcbiAgICAgIHdhcm5IeXBoZW5hdGVkU3R5bGVOYW1lKG5hbWUpO1xuICAgIH0gZWxzZSBpZiAoYmFkVmVuZG9yZWRTdHlsZU5hbWVQYXR0ZXJuLnRlc3QobmFtZSkpIHtcbiAgICAgIHdhcm5CYWRWZW5kb3JlZFN0eWxlTmFtZShuYW1lKTtcbiAgICB9IGVsc2UgaWYgKGJhZFN0eWxlVmFsdWVXaXRoU2VtaWNvbG9uUGF0dGVybi50ZXN0KHZhbHVlKSkge1xuICAgICAgd2FyblN0eWxlVmFsdWVXaXRoU2VtaWNvbG9uKG5hbWUsIHZhbHVlKTtcbiAgICB9XG5cbiAgICBpZiAodHlwZW9mIHZhbHVlID09PSAnbnVtYmVyJykge1xuICAgICAgaWYgKGlzTmFOKHZhbHVlKSkge1xuICAgICAgICB3YXJuU3R5bGVWYWx1ZUlzTmFOKG5hbWUsIHZhbHVlKTtcbiAgICAgIH0gZWxzZSBpZiAoIWlzRmluaXRlKHZhbHVlKSkge1xuICAgICAgICB3YXJuU3R5bGVWYWx1ZUlzSW5maW5pdHkobmFtZSwgdmFsdWUpO1xuICAgICAgfVxuICAgIH1cbiAgfTtcbn1cblxudmFyIHdhcm5WYWxpZFN0eWxlJDEgPSB3YXJuVmFsaWRTdHlsZTtcblxudmFyIGFyaWFQcm9wZXJ0aWVzID0ge1xuICAnYXJpYS1jdXJyZW50JzogMCwgLy8gc3RhdGVcbiAgJ2FyaWEtZGV0YWlscyc6IDAsXG4gICdhcmlhLWRpc2FibGVkJzogMCwgLy8gc3RhdGVcbiAgJ2FyaWEtaGlkZGVuJzogMCwgLy8gc3RhdGVcbiAgJ2FyaWEtaW52YWxpZCc6IDAsIC8vIHN0YXRlXG4gICdhcmlhLWtleXNob3J0Y3V0cyc6IDAsXG4gICdhcmlhLWxhYmVsJzogMCxcbiAgJ2FyaWEtcm9sZWRlc2NyaXB0aW9uJzogMCxcbiAgLy8gV2lkZ2V0IEF0dHJpYnV0ZXNcbiAgJ2FyaWEtYXV0b2NvbXBsZXRlJzogMCxcbiAgJ2FyaWEtY2hlY2tlZCc6IDAsXG4gICdhcmlhLWV4cGFuZGVkJzogMCxcbiAgJ2FyaWEtaGFzcG9wdXAnOiAwLFxuICAnYXJpYS1sZXZlbCc6IDAsXG4gICdhcmlhLW1vZGFsJzogMCxcbiAgJ2FyaWEtbXVsdGlsaW5lJzogMCxcbiAgJ2FyaWEtbXVsdGlzZWxlY3RhYmxlJzogMCxcbiAgJ2FyaWEtb3JpZW50YXRpb24nOiAwLFxuICAnYXJpYS1wbGFjZWhvbGRlcic6IDAsXG4gICdhcmlhLXByZXNzZWQnOiAwLFxuICAnYXJpYS1yZWFkb25seSc6IDAsXG4gICdhcmlhLXJlcXVpcmVkJzogMCxcbiAgJ2FyaWEtc2VsZWN0ZWQnOiAwLFxuICAnYXJpYS1zb3J0JzogMCxcbiAgJ2FyaWEtdmFsdWVtYXgnOiAwLFxuICAnYXJpYS12YWx1ZW1pbic6IDAsXG4gICdhcmlhLXZhbHVlbm93JzogMCxcbiAgJ2FyaWEtdmFsdWV0ZXh0JzogMCxcbiAgLy8gTGl2ZSBSZWdpb24gQXR0cmlidXRlc1xuICAnYXJpYS1hdG9taWMnOiAwLFxuICAnYXJpYS1idXN5JzogMCxcbiAgJ2FyaWEtbGl2ZSc6IDAsXG4gICdhcmlhLXJlbGV2YW50JzogMCxcbiAgLy8gRHJhZy1hbmQtRHJvcCBBdHRyaWJ1dGVzXG4gICdhcmlhLWRyb3BlZmZlY3QnOiAwLFxuICAnYXJpYS1ncmFiYmVkJzogMCxcbiAgLy8gUmVsYXRpb25zaGlwIEF0dHJpYnV0ZXNcbiAgJ2FyaWEtYWN0aXZlZGVzY2VuZGFudCc6IDAsXG4gICdhcmlhLWNvbGNvdW50JzogMCxcbiAgJ2FyaWEtY29saW5kZXgnOiAwLFxuICAnYXJpYS1jb2xzcGFuJzogMCxcbiAgJ2FyaWEtY29udHJvbHMnOiAwLFxuICAnYXJpYS1kZXNjcmliZWRieSc6IDAsXG4gICdhcmlhLWVycm9ybWVzc2FnZSc6IDAsXG4gICdhcmlhLWZsb3d0byc6IDAsXG4gICdhcmlhLWxhYmVsbGVkYnknOiAwLFxuICAnYXJpYS1vd25zJzogMCxcbiAgJ2FyaWEtcG9zaW5zZXQnOiAwLFxuICAnYXJpYS1yb3djb3VudCc6IDAsXG4gICdhcmlhLXJvd2luZGV4JzogMCxcbiAgJ2FyaWEtcm93c3Bhbic6IDAsXG4gICdhcmlhLXNldHNpemUnOiAwXG59O1xuXG52YXIgd2FybmVkUHJvcGVydGllcyA9IHt9O1xudmFyIHJBUklBID0gbmV3IFJlZ0V4cCgnXihhcmlhKS1bJyArIEFUVFJJQlVURV9OQU1FX0NIQVIgKyAnXSokJyk7XG52YXIgckFSSUFDYW1lbCA9IG5ldyBSZWdFeHAoJ14oYXJpYSlbQS1aXVsnICsgQVRUUklCVVRFX05BTUVfQ0hBUiArICddKiQnKTtcblxudmFyIGhhc093blByb3BlcnR5JDIgPSBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5O1xuXG5mdW5jdGlvbiB2YWxpZGF0ZVByb3BlcnR5KHRhZ05hbWUsIG5hbWUpIHtcbiAgaWYgKGhhc093blByb3BlcnR5JDIuY2FsbCh3YXJuZWRQcm9wZXJ0aWVzLCBuYW1lKSAmJiB3YXJuZWRQcm9wZXJ0aWVzW25hbWVdKSB7XG4gICAgcmV0dXJuIHRydWU7XG4gIH1cblxuICBpZiAockFSSUFDYW1lbC50ZXN0KG5hbWUpKSB7XG4gICAgdmFyIGFyaWFOYW1lID0gJ2FyaWEtJyArIG5hbWUuc2xpY2UoNCkudG9Mb3dlckNhc2UoKTtcbiAgICB2YXIgY29ycmVjdE5hbWUgPSBhcmlhUHJvcGVydGllcy5oYXNPd25Qcm9wZXJ0eShhcmlhTmFtZSkgPyBhcmlhTmFtZSA6IG51bGw7XG5cbiAgICAvLyBJZiB0aGlzIGlzIGFuIGFyaWEtKiBhdHRyaWJ1dGUsIGJ1dCBpcyBub3QgbGlzdGVkIGluIHRoZSBrbm93biBET01cbiAgICAvLyBET00gcHJvcGVydGllcywgdGhlbiBpdCBpcyBhbiBpbnZhbGlkIGFyaWEtKiBhdHRyaWJ1dGUuXG4gICAgaWYgKGNvcnJlY3ROYW1lID09IG51bGwpIHtcbiAgICAgIHdhcm5pbmckMShmYWxzZSwgJ0ludmFsaWQgQVJJQSBhdHRyaWJ1dGUgYCVzYC4gQVJJQSBhdHRyaWJ1dGVzIGZvbGxvdyB0aGUgcGF0dGVybiBhcmlhLSogYW5kIG11c3QgYmUgbG93ZXJjYXNlLicsIG5hbWUpO1xuICAgICAgd2FybmVkUHJvcGVydGllc1tuYW1lXSA9IHRydWU7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG4gICAgLy8gYXJpYS0qIGF0dHJpYnV0ZXMgc2hvdWxkIGJlIGxvd2VyY2FzZTsgc3VnZ2VzdCB0aGUgbG93ZXJjYXNlIHZlcnNpb24uXG4gICAgaWYgKG5hbWUgIT09IGNvcnJlY3ROYW1lKSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdJbnZhbGlkIEFSSUEgYXR0cmlidXRlIGAlc2AuIERpZCB5b3UgbWVhbiBgJXNgPycsIG5hbWUsIGNvcnJlY3ROYW1lKTtcbiAgICAgIHdhcm5lZFByb3BlcnRpZXNbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuICB9XG5cbiAgaWYgKHJBUklBLnRlc3QobmFtZSkpIHtcbiAgICB2YXIgbG93ZXJDYXNlZE5hbWUgPSBuYW1lLnRvTG93ZXJDYXNlKCk7XG4gICAgdmFyIHN0YW5kYXJkTmFtZSA9IGFyaWFQcm9wZXJ0aWVzLmhhc093blByb3BlcnR5KGxvd2VyQ2FzZWROYW1lKSA/IGxvd2VyQ2FzZWROYW1lIDogbnVsbDtcblxuICAgIC8vIElmIHRoaXMgaXMgYW4gYXJpYS0qIGF0dHJpYnV0ZSwgYnV0IGlzIG5vdCBsaXN0ZWQgaW4gdGhlIGtub3duIERPTVxuICAgIC8vIERPTSBwcm9wZXJ0aWVzLCB0aGVuIGl0IGlzIGFuIGludmFsaWQgYXJpYS0qIGF0dHJpYnV0ZS5cbiAgICBpZiAoc3RhbmRhcmROYW1lID09IG51bGwpIHtcbiAgICAgIHdhcm5lZFByb3BlcnRpZXNbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cbiAgICAvLyBhcmlhLSogYXR0cmlidXRlcyBzaG91bGQgYmUgbG93ZXJjYXNlOyBzdWdnZXN0IHRoZSBsb3dlcmNhc2UgdmVyc2lvbi5cbiAgICBpZiAobmFtZSAhPT0gc3RhbmRhcmROYW1lKSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdVbmtub3duIEFSSUEgYXR0cmlidXRlIGAlc2AuIERpZCB5b3UgbWVhbiBgJXNgPycsIG5hbWUsIHN0YW5kYXJkTmFtZSk7XG4gICAgICB3YXJuZWRQcm9wZXJ0aWVzW25hbWVdID0gdHJ1ZTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiB0cnVlO1xufVxuXG5mdW5jdGlvbiB3YXJuSW52YWxpZEFSSUFQcm9wcyh0eXBlLCBwcm9wcykge1xuICB2YXIgaW52YWxpZFByb3BzID0gW107XG5cbiAgZm9yICh2YXIga2V5IGluIHByb3BzKSB7XG4gICAgdmFyIGlzVmFsaWQgPSB2YWxpZGF0ZVByb3BlcnR5KHR5cGUsIGtleSk7XG4gICAgaWYgKCFpc1ZhbGlkKSB7XG4gICAgICBpbnZhbGlkUHJvcHMucHVzaChrZXkpO1xuICAgIH1cbiAgfVxuXG4gIHZhciB1bmtub3duUHJvcFN0cmluZyA9IGludmFsaWRQcm9wcy5tYXAoZnVuY3Rpb24gKHByb3ApIHtcbiAgICByZXR1cm4gJ2AnICsgcHJvcCArICdgJztcbiAgfSkuam9pbignLCAnKTtcblxuICBpZiAoaW52YWxpZFByb3BzLmxlbmd0aCA9PT0gMSkge1xuICAgIHdhcm5pbmckMShmYWxzZSwgJ0ludmFsaWQgYXJpYSBwcm9wICVzIG9uIDwlcz4gdGFnLiAnICsgJ0ZvciBkZXRhaWxzLCBzZWUgaHR0cHM6Ly9mYi5tZS9pbnZhbGlkLWFyaWEtcHJvcCcsIHVua25vd25Qcm9wU3RyaW5nLCB0eXBlKTtcbiAgfSBlbHNlIGlmIChpbnZhbGlkUHJvcHMubGVuZ3RoID4gMSkge1xuICAgIHdhcm5pbmckMShmYWxzZSwgJ0ludmFsaWQgYXJpYSBwcm9wcyAlcyBvbiA8JXM+IHRhZy4gJyArICdGb3IgZGV0YWlscywgc2VlIGh0dHBzOi8vZmIubWUvaW52YWxpZC1hcmlhLXByb3AnLCB1bmtub3duUHJvcFN0cmluZywgdHlwZSk7XG4gIH1cbn1cblxuZnVuY3Rpb24gdmFsaWRhdGVQcm9wZXJ0aWVzKHR5cGUsIHByb3BzKSB7XG4gIGlmIChpc0N1c3RvbUNvbXBvbmVudCh0eXBlLCBwcm9wcykpIHtcbiAgICByZXR1cm47XG4gIH1cbiAgd2FybkludmFsaWRBUklBUHJvcHModHlwZSwgcHJvcHMpO1xufVxuXG52YXIgZGlkV2FyblZhbHVlTnVsbCA9IGZhbHNlO1xuXG5mdW5jdGlvbiB2YWxpZGF0ZVByb3BlcnRpZXMkMSh0eXBlLCBwcm9wcykge1xuICBpZiAodHlwZSAhPT0gJ2lucHV0JyAmJiB0eXBlICE9PSAndGV4dGFyZWEnICYmIHR5cGUgIT09ICdzZWxlY3QnKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgaWYgKHByb3BzICE9IG51bGwgJiYgcHJvcHMudmFsdWUgPT09IG51bGwgJiYgIWRpZFdhcm5WYWx1ZU51bGwpIHtcbiAgICBkaWRXYXJuVmFsdWVOdWxsID0gdHJ1ZTtcbiAgICBpZiAodHlwZSA9PT0gJ3NlbGVjdCcgJiYgcHJvcHMubXVsdGlwbGUpIHtcbiAgICAgIHdhcm5pbmckMShmYWxzZSwgJ2B2YWx1ZWAgcHJvcCBvbiBgJXNgIHNob3VsZCBub3QgYmUgbnVsbC4gJyArICdDb25zaWRlciB1c2luZyBhbiBlbXB0eSBhcnJheSB3aGVuIGBtdWx0aXBsZWAgaXMgc2V0IHRvIGB0cnVlYCAnICsgJ3RvIGNsZWFyIHRoZSBjb21wb25lbnQgb3IgYHVuZGVmaW5lZGAgZm9yIHVuY29udHJvbGxlZCBjb21wb25lbnRzLicsIHR5cGUpO1xuICAgIH0gZWxzZSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdgdmFsdWVgIHByb3Agb24gYCVzYCBzaG91bGQgbm90IGJlIG51bGwuICcgKyAnQ29uc2lkZXIgdXNpbmcgYW4gZW1wdHkgc3RyaW5nIHRvIGNsZWFyIHRoZSBjb21wb25lbnQgb3IgYHVuZGVmaW5lZGAgJyArICdmb3IgdW5jb250cm9sbGVkIGNvbXBvbmVudHMuJywgdHlwZSk7XG4gICAgfVxuICB9XG59XG5cbi8qKlxuICogUmVnaXN0ZXJzIHBsdWdpbnMgc28gdGhhdCB0aGV5IGNhbiBleHRyYWN0IGFuZCBkaXNwYXRjaCBldmVudHMuXG4gKlxuICogQHNlZSB7RXZlbnRQbHVnaW5IdWJ9XG4gKi9cblxuLyoqXG4gKiBPcmRlcmVkIGxpc3Qgb2YgaW5qZWN0ZWQgcGx1Z2lucy5cbiAqL1xuXG5cbi8qKlxuICogTWFwcGluZyBmcm9tIGV2ZW50IG5hbWUgdG8gZGlzcGF0Y2ggY29uZmlnXG4gKi9cblxuXG4vKipcbiAqIE1hcHBpbmcgZnJvbSByZWdpc3RyYXRpb24gbmFtZSB0byBwbHVnaW4gbW9kdWxlXG4gKi9cbnZhciByZWdpc3RyYXRpb25OYW1lTW9kdWxlcyA9IHt9O1xuXG4vKipcbiAqIE1hcHBpbmcgZnJvbSByZWdpc3RyYXRpb24gbmFtZSB0byBldmVudCBuYW1lXG4gKi9cblxuXG4vKipcbiAqIE1hcHBpbmcgZnJvbSBsb3dlcmNhc2UgcmVnaXN0cmF0aW9uIG5hbWVzIHRvIHRoZSBwcm9wZXJseSBjYXNlZCB2ZXJzaW9uLFxuICogdXNlZCB0byB3YXJuIGluIHRoZSBjYXNlIG9mIG1pc3NpbmcgZXZlbnQgaGFuZGxlcnMuIEF2YWlsYWJsZVxuICogb25seSBpbiB0cnVlLlxuICogQHR5cGUge09iamVjdH1cbiAqL1xudmFyIHBvc3NpYmxlUmVnaXN0cmF0aW9uTmFtZXMgPSB7fTtcbi8vIFRydXN0IHRoZSBkZXZlbG9wZXIgdG8gb25seSB1c2UgcG9zc2libGVSZWdpc3RyYXRpb25OYW1lcyBpbiB0cnVlXG5cbi8qKlxuICogSW5qZWN0cyBhbiBvcmRlcmluZyBvZiBwbHVnaW5zIChieSBwbHVnaW4gbmFtZSkuIFRoaXMgYWxsb3dzIHRoZSBvcmRlcmluZ1xuICogdG8gYmUgZGVjb3VwbGVkIGZyb20gaW5qZWN0aW9uIG9mIHRoZSBhY3R1YWwgcGx1Z2lucyBzbyB0aGF0IG9yZGVyaW5nIGlzXG4gKiBhbHdheXMgZGV0ZXJtaW5pc3RpYyByZWdhcmRsZXNzIG9mIHBhY2thZ2luZywgb24tdGhlLWZseSBpbmplY3Rpb24sIGV0Yy5cbiAqXG4gKiBAcGFyYW0ge2FycmF5fSBJbmplY3RlZEV2ZW50UGx1Z2luT3JkZXJcbiAqIEBpbnRlcm5hbFxuICogQHNlZSB7RXZlbnRQbHVnaW5IdWIuaW5qZWN0aW9uLmluamVjdEV2ZW50UGx1Z2luT3JkZXJ9XG4gKi9cblxuXG4vKipcbiAqIEluamVjdHMgcGx1Z2lucyB0byBiZSB1c2VkIGJ5IGBFdmVudFBsdWdpbkh1YmAuIFRoZSBwbHVnaW4gbmFtZXMgbXVzdCBiZVxuICogaW4gdGhlIG9yZGVyaW5nIGluamVjdGVkIGJ5IGBpbmplY3RFdmVudFBsdWdpbk9yZGVyYC5cbiAqXG4gKiBQbHVnaW5zIGNhbiBiZSBpbmplY3RlZCBhcyBwYXJ0IG9mIHBhZ2UgaW5pdGlhbGl6YXRpb24gb3Igb24tdGhlLWZseS5cbiAqXG4gKiBAcGFyYW0ge29iamVjdH0gaW5qZWN0ZWROYW1lc1RvUGx1Z2lucyBNYXAgZnJvbSBuYW1lcyB0byBwbHVnaW4gbW9kdWxlcy5cbiAqIEBpbnRlcm5hbFxuICogQHNlZSB7RXZlbnRQbHVnaW5IdWIuaW5qZWN0aW9uLmluamVjdEV2ZW50UGx1Z2luc0J5TmFtZX1cbiAqL1xuXG4vLyBXaGVuIGFkZGluZyBhdHRyaWJ1dGVzIHRvIHRoZSBIVE1MIG9yIFNWRyB3aGl0ZWxpc3QsIGJlIHN1cmUgdG9cbi8vIGFsc28gYWRkIHRoZW0gdG8gdGhpcyBtb2R1bGUgdG8gZW5zdXJlIGNhc2luZyBhbmQgaW5jb3JyZWN0IG5hbWVcbi8vIHdhcm5pbmdzLlxudmFyIHBvc3NpYmxlU3RhbmRhcmROYW1lcyA9IHtcbiAgLy8gSFRNTFxuICBhY2NlcHQ6ICdhY2NlcHQnLFxuICBhY2NlcHRjaGFyc2V0OiAnYWNjZXB0Q2hhcnNldCcsXG4gICdhY2NlcHQtY2hhcnNldCc6ICdhY2NlcHRDaGFyc2V0JyxcbiAgYWNjZXNza2V5OiAnYWNjZXNzS2V5JyxcbiAgYWN0aW9uOiAnYWN0aW9uJyxcbiAgYWxsb3dmdWxsc2NyZWVuOiAnYWxsb3dGdWxsU2NyZWVuJyxcbiAgYWx0OiAnYWx0JyxcbiAgYXM6ICdhcycsXG4gIGFzeW5jOiAnYXN5bmMnLFxuICBhdXRvY2FwaXRhbGl6ZTogJ2F1dG9DYXBpdGFsaXplJyxcbiAgYXV0b2NvbXBsZXRlOiAnYXV0b0NvbXBsZXRlJyxcbiAgYXV0b2NvcnJlY3Q6ICdhdXRvQ29ycmVjdCcsXG4gIGF1dG9mb2N1czogJ2F1dG9Gb2N1cycsXG4gIGF1dG9wbGF5OiAnYXV0b1BsYXknLFxuICBhdXRvc2F2ZTogJ2F1dG9TYXZlJyxcbiAgY2FwdHVyZTogJ2NhcHR1cmUnLFxuICBjZWxscGFkZGluZzogJ2NlbGxQYWRkaW5nJyxcbiAgY2VsbHNwYWNpbmc6ICdjZWxsU3BhY2luZycsXG4gIGNoYWxsZW5nZTogJ2NoYWxsZW5nZScsXG4gIGNoYXJzZXQ6ICdjaGFyU2V0JyxcbiAgY2hlY2tlZDogJ2NoZWNrZWQnLFxuICBjaGlsZHJlbjogJ2NoaWxkcmVuJyxcbiAgY2l0ZTogJ2NpdGUnLFxuICBjbGFzczogJ2NsYXNzTmFtZScsXG4gIGNsYXNzaWQ6ICdjbGFzc0lEJyxcbiAgY2xhc3NuYW1lOiAnY2xhc3NOYW1lJyxcbiAgY29sczogJ2NvbHMnLFxuICBjb2xzcGFuOiAnY29sU3BhbicsXG4gIGNvbnRlbnQ6ICdjb250ZW50JyxcbiAgY29udGVudGVkaXRhYmxlOiAnY29udGVudEVkaXRhYmxlJyxcbiAgY29udGV4dG1lbnU6ICdjb250ZXh0TWVudScsXG4gIGNvbnRyb2xzOiAnY29udHJvbHMnLFxuICBjb250cm9sc2xpc3Q6ICdjb250cm9sc0xpc3QnLFxuICBjb29yZHM6ICdjb29yZHMnLFxuICBjcm9zc29yaWdpbjogJ2Nyb3NzT3JpZ2luJyxcbiAgZGFuZ2Vyb3VzbHlzZXRpbm5lcmh0bWw6ICdkYW5nZXJvdXNseVNldElubmVySFRNTCcsXG4gIGRhdGE6ICdkYXRhJyxcbiAgZGF0ZXRpbWU6ICdkYXRlVGltZScsXG4gIGRlZmF1bHQ6ICdkZWZhdWx0JyxcbiAgZGVmYXVsdGNoZWNrZWQ6ICdkZWZhdWx0Q2hlY2tlZCcsXG4gIGRlZmF1bHR2YWx1ZTogJ2RlZmF1bHRWYWx1ZScsXG4gIGRlZmVyOiAnZGVmZXInLFxuICBkaXI6ICdkaXInLFxuICBkaXNhYmxlZDogJ2Rpc2FibGVkJyxcbiAgZG93bmxvYWQ6ICdkb3dubG9hZCcsXG4gIGRyYWdnYWJsZTogJ2RyYWdnYWJsZScsXG4gIGVuY3R5cGU6ICdlbmNUeXBlJyxcbiAgZm9yOiAnaHRtbEZvcicsXG4gIGZvcm06ICdmb3JtJyxcbiAgZm9ybW1ldGhvZDogJ2Zvcm1NZXRob2QnLFxuICBmb3JtYWN0aW9uOiAnZm9ybUFjdGlvbicsXG4gIGZvcm1lbmN0eXBlOiAnZm9ybUVuY1R5cGUnLFxuICBmb3Jtbm92YWxpZGF0ZTogJ2Zvcm1Ob1ZhbGlkYXRlJyxcbiAgZm9ybXRhcmdldDogJ2Zvcm1UYXJnZXQnLFxuICBmcmFtZWJvcmRlcjogJ2ZyYW1lQm9yZGVyJyxcbiAgaGVhZGVyczogJ2hlYWRlcnMnLFxuICBoZWlnaHQ6ICdoZWlnaHQnLFxuICBoaWRkZW46ICdoaWRkZW4nLFxuICBoaWdoOiAnaGlnaCcsXG4gIGhyZWY6ICdocmVmJyxcbiAgaHJlZmxhbmc6ICdocmVmTGFuZycsXG4gIGh0bWxmb3I6ICdodG1sRm9yJyxcbiAgaHR0cGVxdWl2OiAnaHR0cEVxdWl2JyxcbiAgJ2h0dHAtZXF1aXYnOiAnaHR0cEVxdWl2JyxcbiAgaWNvbjogJ2ljb24nLFxuICBpZDogJ2lkJyxcbiAgaW5uZXJodG1sOiAnaW5uZXJIVE1MJyxcbiAgaW5wdXRtb2RlOiAnaW5wdXRNb2RlJyxcbiAgaW50ZWdyaXR5OiAnaW50ZWdyaXR5JyxcbiAgaXM6ICdpcycsXG4gIGl0ZW1pZDogJ2l0ZW1JRCcsXG4gIGl0ZW1wcm9wOiAnaXRlbVByb3AnLFxuICBpdGVtcmVmOiAnaXRlbVJlZicsXG4gIGl0ZW1zY29wZTogJ2l0ZW1TY29wZScsXG4gIGl0ZW10eXBlOiAnaXRlbVR5cGUnLFxuICBrZXlwYXJhbXM6ICdrZXlQYXJhbXMnLFxuICBrZXl0eXBlOiAna2V5VHlwZScsXG4gIGtpbmQ6ICdraW5kJyxcbiAgbGFiZWw6ICdsYWJlbCcsXG4gIGxhbmc6ICdsYW5nJyxcbiAgbGlzdDogJ2xpc3QnLFxuICBsb29wOiAnbG9vcCcsXG4gIGxvdzogJ2xvdycsXG4gIG1hbmlmZXN0OiAnbWFuaWZlc3QnLFxuICBtYXJnaW53aWR0aDogJ21hcmdpbldpZHRoJyxcbiAgbWFyZ2luaGVpZ2h0OiAnbWFyZ2luSGVpZ2h0JyxcbiAgbWF4OiAnbWF4JyxcbiAgbWF4bGVuZ3RoOiAnbWF4TGVuZ3RoJyxcbiAgbWVkaWE6ICdtZWRpYScsXG4gIG1lZGlhZ3JvdXA6ICdtZWRpYUdyb3VwJyxcbiAgbWV0aG9kOiAnbWV0aG9kJyxcbiAgbWluOiAnbWluJyxcbiAgbWlubGVuZ3RoOiAnbWluTGVuZ3RoJyxcbiAgbXVsdGlwbGU6ICdtdWx0aXBsZScsXG4gIG11dGVkOiAnbXV0ZWQnLFxuICBuYW1lOiAnbmFtZScsXG4gIG5vbW9kdWxlOiAnbm9Nb2R1bGUnLFxuICBub25jZTogJ25vbmNlJyxcbiAgbm92YWxpZGF0ZTogJ25vVmFsaWRhdGUnLFxuICBvcGVuOiAnb3BlbicsXG4gIG9wdGltdW06ICdvcHRpbXVtJyxcbiAgcGF0dGVybjogJ3BhdHRlcm4nLFxuICBwbGFjZWhvbGRlcjogJ3BsYWNlaG9sZGVyJyxcbiAgcGxheXNpbmxpbmU6ICdwbGF5c0lubGluZScsXG4gIHBvc3RlcjogJ3Bvc3RlcicsXG4gIHByZWxvYWQ6ICdwcmVsb2FkJyxcbiAgcHJvZmlsZTogJ3Byb2ZpbGUnLFxuICByYWRpb2dyb3VwOiAncmFkaW9Hcm91cCcsXG4gIHJlYWRvbmx5OiAncmVhZE9ubHknLFxuICByZWZlcnJlcnBvbGljeTogJ3JlZmVycmVyUG9saWN5JyxcbiAgcmVsOiAncmVsJyxcbiAgcmVxdWlyZWQ6ICdyZXF1aXJlZCcsXG4gIHJldmVyc2VkOiAncmV2ZXJzZWQnLFxuICByb2xlOiAncm9sZScsXG4gIHJvd3M6ICdyb3dzJyxcbiAgcm93c3BhbjogJ3Jvd1NwYW4nLFxuICBzYW5kYm94OiAnc2FuZGJveCcsXG4gIHNjb3BlOiAnc2NvcGUnLFxuICBzY29wZWQ6ICdzY29wZWQnLFxuICBzY3JvbGxpbmc6ICdzY3JvbGxpbmcnLFxuICBzZWFtbGVzczogJ3NlYW1sZXNzJyxcbiAgc2VsZWN0ZWQ6ICdzZWxlY3RlZCcsXG4gIHNoYXBlOiAnc2hhcGUnLFxuICBzaXplOiAnc2l6ZScsXG4gIHNpemVzOiAnc2l6ZXMnLFxuICBzcGFuOiAnc3BhbicsXG4gIHNwZWxsY2hlY2s6ICdzcGVsbENoZWNrJyxcbiAgc3JjOiAnc3JjJyxcbiAgc3JjZG9jOiAnc3JjRG9jJyxcbiAgc3JjbGFuZzogJ3NyY0xhbmcnLFxuICBzcmNzZXQ6ICdzcmNTZXQnLFxuICBzdGFydDogJ3N0YXJ0JyxcbiAgc3RlcDogJ3N0ZXAnLFxuICBzdHlsZTogJ3N0eWxlJyxcbiAgc3VtbWFyeTogJ3N1bW1hcnknLFxuICB0YWJpbmRleDogJ3RhYkluZGV4JyxcbiAgdGFyZ2V0OiAndGFyZ2V0JyxcbiAgdGl0bGU6ICd0aXRsZScsXG4gIHR5cGU6ICd0eXBlJyxcbiAgdXNlbWFwOiAndXNlTWFwJyxcbiAgdmFsdWU6ICd2YWx1ZScsXG4gIHdpZHRoOiAnd2lkdGgnLFxuICB3bW9kZTogJ3dtb2RlJyxcbiAgd3JhcDogJ3dyYXAnLFxuXG4gIC8vIFNWR1xuICBhYm91dDogJ2Fib3V0JyxcbiAgYWNjZW50aGVpZ2h0OiAnYWNjZW50SGVpZ2h0JyxcbiAgJ2FjY2VudC1oZWlnaHQnOiAnYWNjZW50SGVpZ2h0JyxcbiAgYWNjdW11bGF0ZTogJ2FjY3VtdWxhdGUnLFxuICBhZGRpdGl2ZTogJ2FkZGl0aXZlJyxcbiAgYWxpZ25tZW50YmFzZWxpbmU6ICdhbGlnbm1lbnRCYXNlbGluZScsXG4gICdhbGlnbm1lbnQtYmFzZWxpbmUnOiAnYWxpZ25tZW50QmFzZWxpbmUnLFxuICBhbGxvd3Jlb3JkZXI6ICdhbGxvd1Jlb3JkZXInLFxuICBhbHBoYWJldGljOiAnYWxwaGFiZXRpYycsXG4gIGFtcGxpdHVkZTogJ2FtcGxpdHVkZScsXG4gIGFyYWJpY2Zvcm06ICdhcmFiaWNGb3JtJyxcbiAgJ2FyYWJpYy1mb3JtJzogJ2FyYWJpY0Zvcm0nLFxuICBhc2NlbnQ6ICdhc2NlbnQnLFxuICBhdHRyaWJ1dGVuYW1lOiAnYXR0cmlidXRlTmFtZScsXG4gIGF0dHJpYnV0ZXR5cGU6ICdhdHRyaWJ1dGVUeXBlJyxcbiAgYXV0b3JldmVyc2U6ICdhdXRvUmV2ZXJzZScsXG4gIGF6aW11dGg6ICdhemltdXRoJyxcbiAgYmFzZWZyZXF1ZW5jeTogJ2Jhc2VGcmVxdWVuY3knLFxuICBiYXNlbGluZXNoaWZ0OiAnYmFzZWxpbmVTaGlmdCcsXG4gICdiYXNlbGluZS1zaGlmdCc6ICdiYXNlbGluZVNoaWZ0JyxcbiAgYmFzZXByb2ZpbGU6ICdiYXNlUHJvZmlsZScsXG4gIGJib3g6ICdiYm94JyxcbiAgYmVnaW46ICdiZWdpbicsXG4gIGJpYXM6ICdiaWFzJyxcbiAgYnk6ICdieScsXG4gIGNhbGNtb2RlOiAnY2FsY01vZGUnLFxuICBjYXBoZWlnaHQ6ICdjYXBIZWlnaHQnLFxuICAnY2FwLWhlaWdodCc6ICdjYXBIZWlnaHQnLFxuICBjbGlwOiAnY2xpcCcsXG4gIGNsaXBwYXRoOiAnY2xpcFBhdGgnLFxuICAnY2xpcC1wYXRoJzogJ2NsaXBQYXRoJyxcbiAgY2xpcHBhdGh1bml0czogJ2NsaXBQYXRoVW5pdHMnLFxuICBjbGlwcnVsZTogJ2NsaXBSdWxlJyxcbiAgJ2NsaXAtcnVsZSc6ICdjbGlwUnVsZScsXG4gIGNvbG9yOiAnY29sb3InLFxuICBjb2xvcmludGVycG9sYXRpb246ICdjb2xvckludGVycG9sYXRpb24nLFxuICAnY29sb3ItaW50ZXJwb2xhdGlvbic6ICdjb2xvckludGVycG9sYXRpb24nLFxuICBjb2xvcmludGVycG9sYXRpb25maWx0ZXJzOiAnY29sb3JJbnRlcnBvbGF0aW9uRmlsdGVycycsXG4gICdjb2xvci1pbnRlcnBvbGF0aW9uLWZpbHRlcnMnOiAnY29sb3JJbnRlcnBvbGF0aW9uRmlsdGVycycsXG4gIGNvbG9ycHJvZmlsZTogJ2NvbG9yUHJvZmlsZScsXG4gICdjb2xvci1wcm9maWxlJzogJ2NvbG9yUHJvZmlsZScsXG4gIGNvbG9ycmVuZGVyaW5nOiAnY29sb3JSZW5kZXJpbmcnLFxuICAnY29sb3ItcmVuZGVyaW5nJzogJ2NvbG9yUmVuZGVyaW5nJyxcbiAgY29udGVudHNjcmlwdHR5cGU6ICdjb250ZW50U2NyaXB0VHlwZScsXG4gIGNvbnRlbnRzdHlsZXR5cGU6ICdjb250ZW50U3R5bGVUeXBlJyxcbiAgY3Vyc29yOiAnY3Vyc29yJyxcbiAgY3g6ICdjeCcsXG4gIGN5OiAnY3knLFxuICBkOiAnZCcsXG4gIGRhdGF0eXBlOiAnZGF0YXR5cGUnLFxuICBkZWNlbGVyYXRlOiAnZGVjZWxlcmF0ZScsXG4gIGRlc2NlbnQ6ICdkZXNjZW50JyxcbiAgZGlmZnVzZWNvbnN0YW50OiAnZGlmZnVzZUNvbnN0YW50JyxcbiAgZGlyZWN0aW9uOiAnZGlyZWN0aW9uJyxcbiAgZGlzcGxheTogJ2Rpc3BsYXknLFxuICBkaXZpc29yOiAnZGl2aXNvcicsXG4gIGRvbWluYW50YmFzZWxpbmU6ICdkb21pbmFudEJhc2VsaW5lJyxcbiAgJ2RvbWluYW50LWJhc2VsaW5lJzogJ2RvbWluYW50QmFzZWxpbmUnLFxuICBkdXI6ICdkdXInLFxuICBkeDogJ2R4JyxcbiAgZHk6ICdkeScsXG4gIGVkZ2Vtb2RlOiAnZWRnZU1vZGUnLFxuICBlbGV2YXRpb246ICdlbGV2YXRpb24nLFxuICBlbmFibGViYWNrZ3JvdW5kOiAnZW5hYmxlQmFja2dyb3VuZCcsXG4gICdlbmFibGUtYmFja2dyb3VuZCc6ICdlbmFibGVCYWNrZ3JvdW5kJyxcbiAgZW5kOiAnZW5kJyxcbiAgZXhwb25lbnQ6ICdleHBvbmVudCcsXG4gIGV4dGVybmFscmVzb3VyY2VzcmVxdWlyZWQ6ICdleHRlcm5hbFJlc291cmNlc1JlcXVpcmVkJyxcbiAgZmlsbDogJ2ZpbGwnLFxuICBmaWxsb3BhY2l0eTogJ2ZpbGxPcGFjaXR5JyxcbiAgJ2ZpbGwtb3BhY2l0eSc6ICdmaWxsT3BhY2l0eScsXG4gIGZpbGxydWxlOiAnZmlsbFJ1bGUnLFxuICAnZmlsbC1ydWxlJzogJ2ZpbGxSdWxlJyxcbiAgZmlsdGVyOiAnZmlsdGVyJyxcbiAgZmlsdGVycmVzOiAnZmlsdGVyUmVzJyxcbiAgZmlsdGVydW5pdHM6ICdmaWx0ZXJVbml0cycsXG4gIGZsb29kb3BhY2l0eTogJ2Zsb29kT3BhY2l0eScsXG4gICdmbG9vZC1vcGFjaXR5JzogJ2Zsb29kT3BhY2l0eScsXG4gIGZsb29kY29sb3I6ICdmbG9vZENvbG9yJyxcbiAgJ2Zsb29kLWNvbG9yJzogJ2Zsb29kQ29sb3InLFxuICBmb2N1c2FibGU6ICdmb2N1c2FibGUnLFxuICBmb250ZmFtaWx5OiAnZm9udEZhbWlseScsXG4gICdmb250LWZhbWlseSc6ICdmb250RmFtaWx5JyxcbiAgZm9udHNpemU6ICdmb250U2l6ZScsXG4gICdmb250LXNpemUnOiAnZm9udFNpemUnLFxuICBmb250c2l6ZWFkanVzdDogJ2ZvbnRTaXplQWRqdXN0JyxcbiAgJ2ZvbnQtc2l6ZS1hZGp1c3QnOiAnZm9udFNpemVBZGp1c3QnLFxuICBmb250c3RyZXRjaDogJ2ZvbnRTdHJldGNoJyxcbiAgJ2ZvbnQtc3RyZXRjaCc6ICdmb250U3RyZXRjaCcsXG4gIGZvbnRzdHlsZTogJ2ZvbnRTdHlsZScsXG4gICdmb250LXN0eWxlJzogJ2ZvbnRTdHlsZScsXG4gIGZvbnR2YXJpYW50OiAnZm9udFZhcmlhbnQnLFxuICAnZm9udC12YXJpYW50JzogJ2ZvbnRWYXJpYW50JyxcbiAgZm9udHdlaWdodDogJ2ZvbnRXZWlnaHQnLFxuICAnZm9udC13ZWlnaHQnOiAnZm9udFdlaWdodCcsXG4gIGZvcm1hdDogJ2Zvcm1hdCcsXG4gIGZyb206ICdmcm9tJyxcbiAgZng6ICdmeCcsXG4gIGZ5OiAnZnknLFxuICBnMTogJ2cxJyxcbiAgZzI6ICdnMicsXG4gIGdseXBobmFtZTogJ2dseXBoTmFtZScsXG4gICdnbHlwaC1uYW1lJzogJ2dseXBoTmFtZScsXG4gIGdseXBob3JpZW50YXRpb25ob3Jpem9udGFsOiAnZ2x5cGhPcmllbnRhdGlvbkhvcml6b250YWwnLFxuICAnZ2x5cGgtb3JpZW50YXRpb24taG9yaXpvbnRhbCc6ICdnbHlwaE9yaWVudGF0aW9uSG9yaXpvbnRhbCcsXG4gIGdseXBob3JpZW50YXRpb252ZXJ0aWNhbDogJ2dseXBoT3JpZW50YXRpb25WZXJ0aWNhbCcsXG4gICdnbHlwaC1vcmllbnRhdGlvbi12ZXJ0aWNhbCc6ICdnbHlwaE9yaWVudGF0aW9uVmVydGljYWwnLFxuICBnbHlwaHJlZjogJ2dseXBoUmVmJyxcbiAgZ3JhZGllbnR0cmFuc2Zvcm06ICdncmFkaWVudFRyYW5zZm9ybScsXG4gIGdyYWRpZW50dW5pdHM6ICdncmFkaWVudFVuaXRzJyxcbiAgaGFuZ2luZzogJ2hhbmdpbmcnLFxuICBob3JpemFkdng6ICdob3JpekFkdlgnLFxuICAnaG9yaXotYWR2LXgnOiAnaG9yaXpBZHZYJyxcbiAgaG9yaXpvcmlnaW54OiAnaG9yaXpPcmlnaW5YJyxcbiAgJ2hvcml6LW9yaWdpbi14JzogJ2hvcml6T3JpZ2luWCcsXG4gIGlkZW9ncmFwaGljOiAnaWRlb2dyYXBoaWMnLFxuICBpbWFnZXJlbmRlcmluZzogJ2ltYWdlUmVuZGVyaW5nJyxcbiAgJ2ltYWdlLXJlbmRlcmluZyc6ICdpbWFnZVJlbmRlcmluZycsXG4gIGluMjogJ2luMicsXG4gIGluOiAnaW4nLFxuICBpbmxpc3Q6ICdpbmxpc3QnLFxuICBpbnRlcmNlcHQ6ICdpbnRlcmNlcHQnLFxuICBrMTogJ2sxJyxcbiAgazI6ICdrMicsXG4gIGszOiAnazMnLFxuICBrNDogJ2s0JyxcbiAgazogJ2snLFxuICBrZXJuZWxtYXRyaXg6ICdrZXJuZWxNYXRyaXgnLFxuICBrZXJuZWx1bml0bGVuZ3RoOiAna2VybmVsVW5pdExlbmd0aCcsXG4gIGtlcm5pbmc6ICdrZXJuaW5nJyxcbiAga2V5cG9pbnRzOiAna2V5UG9pbnRzJyxcbiAga2V5c3BsaW5lczogJ2tleVNwbGluZXMnLFxuICBrZXl0aW1lczogJ2tleVRpbWVzJyxcbiAgbGVuZ3RoYWRqdXN0OiAnbGVuZ3RoQWRqdXN0JyxcbiAgbGV0dGVyc3BhY2luZzogJ2xldHRlclNwYWNpbmcnLFxuICAnbGV0dGVyLXNwYWNpbmcnOiAnbGV0dGVyU3BhY2luZycsXG4gIGxpZ2h0aW5nY29sb3I6ICdsaWdodGluZ0NvbG9yJyxcbiAgJ2xpZ2h0aW5nLWNvbG9yJzogJ2xpZ2h0aW5nQ29sb3InLFxuICBsaW1pdGluZ2NvbmVhbmdsZTogJ2xpbWl0aW5nQ29uZUFuZ2xlJyxcbiAgbG9jYWw6ICdsb2NhbCcsXG4gIG1hcmtlcmVuZDogJ21hcmtlckVuZCcsXG4gICdtYXJrZXItZW5kJzogJ21hcmtlckVuZCcsXG4gIG1hcmtlcmhlaWdodDogJ21hcmtlckhlaWdodCcsXG4gIG1hcmtlcm1pZDogJ21hcmtlck1pZCcsXG4gICdtYXJrZXItbWlkJzogJ21hcmtlck1pZCcsXG4gIG1hcmtlcnN0YXJ0OiAnbWFya2VyU3RhcnQnLFxuICAnbWFya2VyLXN0YXJ0JzogJ21hcmtlclN0YXJ0JyxcbiAgbWFya2VydW5pdHM6ICdtYXJrZXJVbml0cycsXG4gIG1hcmtlcndpZHRoOiAnbWFya2VyV2lkdGgnLFxuICBtYXNrOiAnbWFzaycsXG4gIG1hc2tjb250ZW50dW5pdHM6ICdtYXNrQ29udGVudFVuaXRzJyxcbiAgbWFza3VuaXRzOiAnbWFza1VuaXRzJyxcbiAgbWF0aGVtYXRpY2FsOiAnbWF0aGVtYXRpY2FsJyxcbiAgbW9kZTogJ21vZGUnLFxuICBudW1vY3RhdmVzOiAnbnVtT2N0YXZlcycsXG4gIG9mZnNldDogJ29mZnNldCcsXG4gIG9wYWNpdHk6ICdvcGFjaXR5JyxcbiAgb3BlcmF0b3I6ICdvcGVyYXRvcicsXG4gIG9yZGVyOiAnb3JkZXInLFxuICBvcmllbnQ6ICdvcmllbnQnLFxuICBvcmllbnRhdGlvbjogJ29yaWVudGF0aW9uJyxcbiAgb3JpZ2luOiAnb3JpZ2luJyxcbiAgb3ZlcmZsb3c6ICdvdmVyZmxvdycsXG4gIG92ZXJsaW5lcG9zaXRpb246ICdvdmVybGluZVBvc2l0aW9uJyxcbiAgJ292ZXJsaW5lLXBvc2l0aW9uJzogJ292ZXJsaW5lUG9zaXRpb24nLFxuICBvdmVybGluZXRoaWNrbmVzczogJ292ZXJsaW5lVGhpY2tuZXNzJyxcbiAgJ292ZXJsaW5lLXRoaWNrbmVzcyc6ICdvdmVybGluZVRoaWNrbmVzcycsXG4gIHBhaW50b3JkZXI6ICdwYWludE9yZGVyJyxcbiAgJ3BhaW50LW9yZGVyJzogJ3BhaW50T3JkZXInLFxuICBwYW5vc2UxOiAncGFub3NlMScsXG4gICdwYW5vc2UtMSc6ICdwYW5vc2UxJyxcbiAgcGF0aGxlbmd0aDogJ3BhdGhMZW5ndGgnLFxuICBwYXR0ZXJuY29udGVudHVuaXRzOiAncGF0dGVybkNvbnRlbnRVbml0cycsXG4gIHBhdHRlcm50cmFuc2Zvcm06ICdwYXR0ZXJuVHJhbnNmb3JtJyxcbiAgcGF0dGVybnVuaXRzOiAncGF0dGVyblVuaXRzJyxcbiAgcG9pbnRlcmV2ZW50czogJ3BvaW50ZXJFdmVudHMnLFxuICAncG9pbnRlci1ldmVudHMnOiAncG9pbnRlckV2ZW50cycsXG4gIHBvaW50czogJ3BvaW50cycsXG4gIHBvaW50c2F0eDogJ3BvaW50c0F0WCcsXG4gIHBvaW50c2F0eTogJ3BvaW50c0F0WScsXG4gIHBvaW50c2F0ejogJ3BvaW50c0F0WicsXG4gIHByZWZpeDogJ3ByZWZpeCcsXG4gIHByZXNlcnZlYWxwaGE6ICdwcmVzZXJ2ZUFscGhhJyxcbiAgcHJlc2VydmVhc3BlY3RyYXRpbzogJ3ByZXNlcnZlQXNwZWN0UmF0aW8nLFxuICBwcmltaXRpdmV1bml0czogJ3ByaW1pdGl2ZVVuaXRzJyxcbiAgcHJvcGVydHk6ICdwcm9wZXJ0eScsXG4gIHI6ICdyJyxcbiAgcmFkaXVzOiAncmFkaXVzJyxcbiAgcmVmeDogJ3JlZlgnLFxuICByZWZ5OiAncmVmWScsXG4gIHJlbmRlcmluZ2ludGVudDogJ3JlbmRlcmluZ0ludGVudCcsXG4gICdyZW5kZXJpbmctaW50ZW50JzogJ3JlbmRlcmluZ0ludGVudCcsXG4gIHJlcGVhdGNvdW50OiAncmVwZWF0Q291bnQnLFxuICByZXBlYXRkdXI6ICdyZXBlYXREdXInLFxuICByZXF1aXJlZGV4dGVuc2lvbnM6ICdyZXF1aXJlZEV4dGVuc2lvbnMnLFxuICByZXF1aXJlZGZlYXR1cmVzOiAncmVxdWlyZWRGZWF0dXJlcycsXG4gIHJlc291cmNlOiAncmVzb3VyY2UnLFxuICByZXN0YXJ0OiAncmVzdGFydCcsXG4gIHJlc3VsdDogJ3Jlc3VsdCcsXG4gIHJlc3VsdHM6ICdyZXN1bHRzJyxcbiAgcm90YXRlOiAncm90YXRlJyxcbiAgcng6ICdyeCcsXG4gIHJ5OiAncnknLFxuICBzY2FsZTogJ3NjYWxlJyxcbiAgc2VjdXJpdHk6ICdzZWN1cml0eScsXG4gIHNlZWQ6ICdzZWVkJyxcbiAgc2hhcGVyZW5kZXJpbmc6ICdzaGFwZVJlbmRlcmluZycsXG4gICdzaGFwZS1yZW5kZXJpbmcnOiAnc2hhcGVSZW5kZXJpbmcnLFxuICBzbG9wZTogJ3Nsb3BlJyxcbiAgc3BhY2luZzogJ3NwYWNpbmcnLFxuICBzcGVjdWxhcmNvbnN0YW50OiAnc3BlY3VsYXJDb25zdGFudCcsXG4gIHNwZWN1bGFyZXhwb25lbnQ6ICdzcGVjdWxhckV4cG9uZW50JyxcbiAgc3BlZWQ6ICdzcGVlZCcsXG4gIHNwcmVhZG1ldGhvZDogJ3NwcmVhZE1ldGhvZCcsXG4gIHN0YXJ0b2Zmc2V0OiAnc3RhcnRPZmZzZXQnLFxuICBzdGRkZXZpYXRpb246ICdzdGREZXZpYXRpb24nLFxuICBzdGVtaDogJ3N0ZW1oJyxcbiAgc3RlbXY6ICdzdGVtdicsXG4gIHN0aXRjaHRpbGVzOiAnc3RpdGNoVGlsZXMnLFxuICBzdG9wY29sb3I6ICdzdG9wQ29sb3InLFxuICAnc3RvcC1jb2xvcic6ICdzdG9wQ29sb3InLFxuICBzdG9wb3BhY2l0eTogJ3N0b3BPcGFjaXR5JyxcbiAgJ3N0b3Atb3BhY2l0eSc6ICdzdG9wT3BhY2l0eScsXG4gIHN0cmlrZXRocm91Z2hwb3NpdGlvbjogJ3N0cmlrZXRocm91Z2hQb3NpdGlvbicsXG4gICdzdHJpa2V0aHJvdWdoLXBvc2l0aW9uJzogJ3N0cmlrZXRocm91Z2hQb3NpdGlvbicsXG4gIHN0cmlrZXRocm91Z2h0aGlja25lc3M6ICdzdHJpa2V0aHJvdWdoVGhpY2tuZXNzJyxcbiAgJ3N0cmlrZXRocm91Z2gtdGhpY2tuZXNzJzogJ3N0cmlrZXRocm91Z2hUaGlja25lc3MnLFxuICBzdHJpbmc6ICdzdHJpbmcnLFxuICBzdHJva2U6ICdzdHJva2UnLFxuICBzdHJva2VkYXNoYXJyYXk6ICdzdHJva2VEYXNoYXJyYXknLFxuICAnc3Ryb2tlLWRhc2hhcnJheSc6ICdzdHJva2VEYXNoYXJyYXknLFxuICBzdHJva2VkYXNob2Zmc2V0OiAnc3Ryb2tlRGFzaG9mZnNldCcsXG4gICdzdHJva2UtZGFzaG9mZnNldCc6ICdzdHJva2VEYXNob2Zmc2V0JyxcbiAgc3Ryb2tlbGluZWNhcDogJ3N0cm9rZUxpbmVjYXAnLFxuICAnc3Ryb2tlLWxpbmVjYXAnOiAnc3Ryb2tlTGluZWNhcCcsXG4gIHN0cm9rZWxpbmVqb2luOiAnc3Ryb2tlTGluZWpvaW4nLFxuICAnc3Ryb2tlLWxpbmVqb2luJzogJ3N0cm9rZUxpbmVqb2luJyxcbiAgc3Ryb2tlbWl0ZXJsaW1pdDogJ3N0cm9rZU1pdGVybGltaXQnLFxuICAnc3Ryb2tlLW1pdGVybGltaXQnOiAnc3Ryb2tlTWl0ZXJsaW1pdCcsXG4gIHN0cm9rZXdpZHRoOiAnc3Ryb2tlV2lkdGgnLFxuICAnc3Ryb2tlLXdpZHRoJzogJ3N0cm9rZVdpZHRoJyxcbiAgc3Ryb2tlb3BhY2l0eTogJ3N0cm9rZU9wYWNpdHknLFxuICAnc3Ryb2tlLW9wYWNpdHknOiAnc3Ryb2tlT3BhY2l0eScsXG4gIHN1cHByZXNzY29udGVudGVkaXRhYmxld2FybmluZzogJ3N1cHByZXNzQ29udGVudEVkaXRhYmxlV2FybmluZycsXG4gIHN1cHByZXNzaHlkcmF0aW9ud2FybmluZzogJ3N1cHByZXNzSHlkcmF0aW9uV2FybmluZycsXG4gIHN1cmZhY2VzY2FsZTogJ3N1cmZhY2VTY2FsZScsXG4gIHN5c3RlbWxhbmd1YWdlOiAnc3lzdGVtTGFuZ3VhZ2UnLFxuICB0YWJsZXZhbHVlczogJ3RhYmxlVmFsdWVzJyxcbiAgdGFyZ2V0eDogJ3RhcmdldFgnLFxuICB0YXJnZXR5OiAndGFyZ2V0WScsXG4gIHRleHRhbmNob3I6ICd0ZXh0QW5jaG9yJyxcbiAgJ3RleHQtYW5jaG9yJzogJ3RleHRBbmNob3InLFxuICB0ZXh0ZGVjb3JhdGlvbjogJ3RleHREZWNvcmF0aW9uJyxcbiAgJ3RleHQtZGVjb3JhdGlvbic6ICd0ZXh0RGVjb3JhdGlvbicsXG4gIHRleHRsZW5ndGg6ICd0ZXh0TGVuZ3RoJyxcbiAgdGV4dHJlbmRlcmluZzogJ3RleHRSZW5kZXJpbmcnLFxuICAndGV4dC1yZW5kZXJpbmcnOiAndGV4dFJlbmRlcmluZycsXG4gIHRvOiAndG8nLFxuICB0cmFuc2Zvcm06ICd0cmFuc2Zvcm0nLFxuICB0eXBlb2Y6ICd0eXBlb2YnLFxuICB1MTogJ3UxJyxcbiAgdTI6ICd1MicsXG4gIHVuZGVybGluZXBvc2l0aW9uOiAndW5kZXJsaW5lUG9zaXRpb24nLFxuICAndW5kZXJsaW5lLXBvc2l0aW9uJzogJ3VuZGVybGluZVBvc2l0aW9uJyxcbiAgdW5kZXJsaW5ldGhpY2tuZXNzOiAndW5kZXJsaW5lVGhpY2tuZXNzJyxcbiAgJ3VuZGVybGluZS10aGlja25lc3MnOiAndW5kZXJsaW5lVGhpY2tuZXNzJyxcbiAgdW5pY29kZTogJ3VuaWNvZGUnLFxuICB1bmljb2RlYmlkaTogJ3VuaWNvZGVCaWRpJyxcbiAgJ3VuaWNvZGUtYmlkaSc6ICd1bmljb2RlQmlkaScsXG4gIHVuaWNvZGVyYW5nZTogJ3VuaWNvZGVSYW5nZScsXG4gICd1bmljb2RlLXJhbmdlJzogJ3VuaWNvZGVSYW5nZScsXG4gIHVuaXRzcGVyZW06ICd1bml0c1BlckVtJyxcbiAgJ3VuaXRzLXBlci1lbSc6ICd1bml0c1BlckVtJyxcbiAgdW5zZWxlY3RhYmxlOiAndW5zZWxlY3RhYmxlJyxcbiAgdmFscGhhYmV0aWM6ICd2QWxwaGFiZXRpYycsXG4gICd2LWFscGhhYmV0aWMnOiAndkFscGhhYmV0aWMnLFxuICB2YWx1ZXM6ICd2YWx1ZXMnLFxuICB2ZWN0b3JlZmZlY3Q6ICd2ZWN0b3JFZmZlY3QnLFxuICAndmVjdG9yLWVmZmVjdCc6ICd2ZWN0b3JFZmZlY3QnLFxuICB2ZXJzaW9uOiAndmVyc2lvbicsXG4gIHZlcnRhZHZ5OiAndmVydEFkdlknLFxuICAndmVydC1hZHYteSc6ICd2ZXJ0QWR2WScsXG4gIHZlcnRvcmlnaW54OiAndmVydE9yaWdpblgnLFxuICAndmVydC1vcmlnaW4teCc6ICd2ZXJ0T3JpZ2luWCcsXG4gIHZlcnRvcmlnaW55OiAndmVydE9yaWdpblknLFxuICAndmVydC1vcmlnaW4teSc6ICd2ZXJ0T3JpZ2luWScsXG4gIHZoYW5naW5nOiAndkhhbmdpbmcnLFxuICAndi1oYW5naW5nJzogJ3ZIYW5naW5nJyxcbiAgdmlkZW9ncmFwaGljOiAndklkZW9ncmFwaGljJyxcbiAgJ3YtaWRlb2dyYXBoaWMnOiAndklkZW9ncmFwaGljJyxcbiAgdmlld2JveDogJ3ZpZXdCb3gnLFxuICB2aWV3dGFyZ2V0OiAndmlld1RhcmdldCcsXG4gIHZpc2liaWxpdHk6ICd2aXNpYmlsaXR5JyxcbiAgdm1hdGhlbWF0aWNhbDogJ3ZNYXRoZW1hdGljYWwnLFxuICAndi1tYXRoZW1hdGljYWwnOiAndk1hdGhlbWF0aWNhbCcsXG4gIHZvY2FiOiAndm9jYWInLFxuICB3aWR0aHM6ICd3aWR0aHMnLFxuICB3b3Jkc3BhY2luZzogJ3dvcmRTcGFjaW5nJyxcbiAgJ3dvcmQtc3BhY2luZyc6ICd3b3JkU3BhY2luZycsXG4gIHdyaXRpbmdtb2RlOiAnd3JpdGluZ01vZGUnLFxuICAnd3JpdGluZy1tb2RlJzogJ3dyaXRpbmdNb2RlJyxcbiAgeDE6ICd4MScsXG4gIHgyOiAneDInLFxuICB4OiAneCcsXG4gIHhjaGFubmVsc2VsZWN0b3I6ICd4Q2hhbm5lbFNlbGVjdG9yJyxcbiAgeGhlaWdodDogJ3hIZWlnaHQnLFxuICAneC1oZWlnaHQnOiAneEhlaWdodCcsXG4gIHhsaW5rYWN0dWF0ZTogJ3hsaW5rQWN0dWF0ZScsXG4gICd4bGluazphY3R1YXRlJzogJ3hsaW5rQWN0dWF0ZScsXG4gIHhsaW5rYXJjcm9sZTogJ3hsaW5rQXJjcm9sZScsXG4gICd4bGluazphcmNyb2xlJzogJ3hsaW5rQXJjcm9sZScsXG4gIHhsaW5raHJlZjogJ3hsaW5rSHJlZicsXG4gICd4bGluazpocmVmJzogJ3hsaW5rSHJlZicsXG4gIHhsaW5rcm9sZTogJ3hsaW5rUm9sZScsXG4gICd4bGluazpyb2xlJzogJ3hsaW5rUm9sZScsXG4gIHhsaW5rc2hvdzogJ3hsaW5rU2hvdycsXG4gICd4bGluazpzaG93JzogJ3hsaW5rU2hvdycsXG4gIHhsaW5rdGl0bGU6ICd4bGlua1RpdGxlJyxcbiAgJ3hsaW5rOnRpdGxlJzogJ3hsaW5rVGl0bGUnLFxuICB4bGlua3R5cGU6ICd4bGlua1R5cGUnLFxuICAneGxpbms6dHlwZSc6ICd4bGlua1R5cGUnLFxuICB4bWxiYXNlOiAneG1sQmFzZScsXG4gICd4bWw6YmFzZSc6ICd4bWxCYXNlJyxcbiAgeG1sbGFuZzogJ3htbExhbmcnLFxuICAneG1sOmxhbmcnOiAneG1sTGFuZycsXG4gIHhtbG5zOiAneG1sbnMnLFxuICAneG1sOnNwYWNlJzogJ3htbFNwYWNlJyxcbiAgeG1sbnN4bGluazogJ3htbG5zWGxpbmsnLFxuICAneG1sbnM6eGxpbmsnOiAneG1sbnNYbGluaycsXG4gIHhtbHNwYWNlOiAneG1sU3BhY2UnLFxuICB5MTogJ3kxJyxcbiAgeTI6ICd5MicsXG4gIHk6ICd5JyxcbiAgeWNoYW5uZWxzZWxlY3RvcjogJ3lDaGFubmVsU2VsZWN0b3InLFxuICB6OiAneicsXG4gIHpvb21hbmRwYW46ICd6b29tQW5kUGFuJ1xufTtcblxudmFyIHZhbGlkYXRlUHJvcGVydHkkMSA9IGZ1bmN0aW9uICgpIHt9O1xuXG57XG4gIHZhciB3YXJuZWRQcm9wZXJ0aWVzJDEgPSB7fTtcbiAgdmFyIF9oYXNPd25Qcm9wZXJ0eSA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHk7XG4gIHZhciBFVkVOVF9OQU1FX1JFR0VYID0gL15vbi4vO1xuICB2YXIgSU5WQUxJRF9FVkVOVF9OQU1FX1JFR0VYID0gL15vblteQS1aXS87XG4gIHZhciByQVJJQSQxID0gbmV3IFJlZ0V4cCgnXihhcmlhKS1bJyArIEFUVFJJQlVURV9OQU1FX0NIQVIgKyAnXSokJyk7XG4gIHZhciByQVJJQUNhbWVsJDEgPSBuZXcgUmVnRXhwKCdeKGFyaWEpW0EtWl1bJyArIEFUVFJJQlVURV9OQU1FX0NIQVIgKyAnXSokJyk7XG5cbiAgdmFsaWRhdGVQcm9wZXJ0eSQxID0gZnVuY3Rpb24gKHRhZ05hbWUsIG5hbWUsIHZhbHVlLCBjYW5Vc2VFdmVudFN5c3RlbSkge1xuICAgIGlmIChfaGFzT3duUHJvcGVydHkuY2FsbCh3YXJuZWRQcm9wZXJ0aWVzJDEsIG5hbWUpICYmIHdhcm5lZFByb3BlcnRpZXMkMVtuYW1lXSkge1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgdmFyIGxvd2VyQ2FzZWROYW1lID0gbmFtZS50b0xvd2VyQ2FzZSgpO1xuICAgIGlmIChsb3dlckNhc2VkTmFtZSA9PT0gJ29uZm9jdXNpbicgfHwgbG93ZXJDYXNlZE5hbWUgPT09ICdvbmZvY3Vzb3V0Jykge1xuICAgICAgd2FybmluZyQxKGZhbHNlLCAnUmVhY3QgdXNlcyBvbkZvY3VzIGFuZCBvbkJsdXIgaW5zdGVhZCBvZiBvbkZvY3VzSW4gYW5kIG9uRm9jdXNPdXQuICcgKyAnQWxsIFJlYWN0IGV2ZW50cyBhcmUgbm9ybWFsaXplZCB0byBidWJibGUsIHNvIG9uRm9jdXNJbiBhbmQgb25Gb2N1c091dCAnICsgJ2FyZSBub3QgbmVlZGVkL3N1cHBvcnRlZCBieSBSZWFjdC4nKTtcbiAgICAgIHdhcm5lZFByb3BlcnRpZXMkMVtuYW1lXSA9IHRydWU7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG5cbiAgICAvLyBXZSBjYW4ndCByZWx5IG9uIHRoZSBldmVudCBzeXN0ZW0gYmVpbmcgaW5qZWN0ZWQgb24gdGhlIHNlcnZlci5cbiAgICBpZiAoY2FuVXNlRXZlbnRTeXN0ZW0pIHtcbiAgICAgIGlmIChyZWdpc3RyYXRpb25OYW1lTW9kdWxlcy5oYXNPd25Qcm9wZXJ0eShuYW1lKSkge1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH1cbiAgICAgIHZhciByZWdpc3RyYXRpb25OYW1lID0gcG9zc2libGVSZWdpc3RyYXRpb25OYW1lcy5oYXNPd25Qcm9wZXJ0eShsb3dlckNhc2VkTmFtZSkgPyBwb3NzaWJsZVJlZ2lzdHJhdGlvbk5hbWVzW2xvd2VyQ2FzZWROYW1lXSA6IG51bGw7XG4gICAgICBpZiAocmVnaXN0cmF0aW9uTmFtZSAhPSBudWxsKSB7XG4gICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ0ludmFsaWQgZXZlbnQgaGFuZGxlciBwcm9wZXJ0eSBgJXNgLiBEaWQgeW91IG1lYW4gYCVzYD8nLCBuYW1lLCByZWdpc3RyYXRpb25OYW1lKTtcbiAgICAgICAgd2FybmVkUHJvcGVydGllcyQxW25hbWVdID0gdHJ1ZTtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9XG4gICAgICBpZiAoRVZFTlRfTkFNRV9SRUdFWC50ZXN0KG5hbWUpKSB7XG4gICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1Vua25vd24gZXZlbnQgaGFuZGxlciBwcm9wZXJ0eSBgJXNgLiBJdCB3aWxsIGJlIGlnbm9yZWQuJywgbmFtZSk7XG4gICAgICAgIHdhcm5lZFByb3BlcnRpZXMkMVtuYW1lXSA9IHRydWU7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfVxuICAgIH0gZWxzZSBpZiAoRVZFTlRfTkFNRV9SRUdFWC50ZXN0KG5hbWUpKSB7XG4gICAgICAvLyBJZiBubyBldmVudCBwbHVnaW5zIGhhdmUgYmVlbiBpbmplY3RlZCwgd2UgYXJlIGluIGEgc2VydmVyIGVudmlyb25tZW50LlxuICAgICAgLy8gU28gd2UgY2FuJ3QgdGVsbCBpZiB0aGUgZXZlbnQgbmFtZSBpcyBjb3JyZWN0IGZvciBzdXJlLCBidXQgd2UgY2FuIGZpbHRlclxuICAgICAgLy8gb3V0IGtub3duIGJhZCBvbmVzIGxpa2UgYG9uY2xpY2tgLiBXZSBjYW4ndCBzdWdnZXN0IGEgc3BlY2lmaWMgcmVwbGFjZW1lbnQgdGhvdWdoLlxuICAgICAgaWYgKElOVkFMSURfRVZFTlRfTkFNRV9SRUdFWC50ZXN0KG5hbWUpKSB7XG4gICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ0ludmFsaWQgZXZlbnQgaGFuZGxlciBwcm9wZXJ0eSBgJXNgLiAnICsgJ1JlYWN0IGV2ZW50cyB1c2UgdGhlIGNhbWVsQ2FzZSBuYW1pbmcgY29udmVudGlvbiwgZm9yIGV4YW1wbGUgYG9uQ2xpY2tgLicsIG5hbWUpO1xuICAgICAgfVxuICAgICAgd2FybmVkUHJvcGVydGllcyQxW25hbWVdID0gdHJ1ZTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cblxuICAgIC8vIExldCB0aGUgQVJJQSBhdHRyaWJ1dGUgaG9vayB2YWxpZGF0ZSBBUklBIGF0dHJpYnV0ZXNcbiAgICBpZiAockFSSUEkMS50ZXN0KG5hbWUpIHx8IHJBUklBQ2FtZWwkMS50ZXN0KG5hbWUpKSB7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG5cbiAgICBpZiAobG93ZXJDYXNlZE5hbWUgPT09ICdpbm5lcmh0bWwnKSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdEaXJlY3RseSBzZXR0aW5nIHByb3BlcnR5IGBpbm5lckhUTUxgIGlzIG5vdCBwZXJtaXR0ZWQuICcgKyAnRm9yIG1vcmUgaW5mb3JtYXRpb24sIGxvb2t1cCBkb2N1bWVudGF0aW9uIG9uIGBkYW5nZXJvdXNseVNldElubmVySFRNTGAuJyk7XG4gICAgICB3YXJuZWRQcm9wZXJ0aWVzJDFbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgaWYgKGxvd2VyQ2FzZWROYW1lID09PSAnYXJpYScpIHtcbiAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1RoZSBgYXJpYWAgYXR0cmlidXRlIGlzIHJlc2VydmVkIGZvciBmdXR1cmUgdXNlIGluIFJlYWN0LiAnICsgJ1Bhc3MgaW5kaXZpZHVhbCBgYXJpYS1gIGF0dHJpYnV0ZXMgaW5zdGVhZC4nKTtcbiAgICAgIHdhcm5lZFByb3BlcnRpZXMkMVtuYW1lXSA9IHRydWU7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG5cbiAgICBpZiAobG93ZXJDYXNlZE5hbWUgPT09ICdpcycgJiYgdmFsdWUgIT09IG51bGwgJiYgdmFsdWUgIT09IHVuZGVmaW5lZCAmJiB0eXBlb2YgdmFsdWUgIT09ICdzdHJpbmcnKSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdSZWNlaXZlZCBhIGAlc2AgZm9yIGEgc3RyaW5nIGF0dHJpYnV0ZSBgaXNgLiBJZiB0aGlzIGlzIGV4cGVjdGVkLCBjYXN0ICcgKyAndGhlIHZhbHVlIHRvIGEgc3RyaW5nLicsIHR5cGVvZiB2YWx1ZSk7XG4gICAgICB3YXJuZWRQcm9wZXJ0aWVzJDFbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gJ251bWJlcicgJiYgaXNOYU4odmFsdWUpKSB7XG4gICAgICB3YXJuaW5nJDEoZmFsc2UsICdSZWNlaXZlZCBOYU4gZm9yIHRoZSBgJXNgIGF0dHJpYnV0ZS4gSWYgdGhpcyBpcyBleHBlY3RlZCwgY2FzdCAnICsgJ3RoZSB2YWx1ZSB0byBhIHN0cmluZy4nLCBuYW1lKTtcbiAgICAgIHdhcm5lZFByb3BlcnRpZXMkMVtuYW1lXSA9IHRydWU7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG5cbiAgICB2YXIgcHJvcGVydHlJbmZvID0gZ2V0UHJvcGVydHlJbmZvKG5hbWUpO1xuICAgIHZhciBpc1Jlc2VydmVkID0gcHJvcGVydHlJbmZvICE9PSBudWxsICYmIHByb3BlcnR5SW5mby50eXBlID09PSBSRVNFUlZFRDtcblxuICAgIC8vIEtub3duIGF0dHJpYnV0ZXMgc2hvdWxkIG1hdGNoIHRoZSBjYXNpbmcgc3BlY2lmaWVkIGluIHRoZSBwcm9wZXJ0eSBjb25maWcuXG4gICAgaWYgKHBvc3NpYmxlU3RhbmRhcmROYW1lcy5oYXNPd25Qcm9wZXJ0eShsb3dlckNhc2VkTmFtZSkpIHtcbiAgICAgIHZhciBzdGFuZGFyZE5hbWUgPSBwb3NzaWJsZVN0YW5kYXJkTmFtZXNbbG93ZXJDYXNlZE5hbWVdO1xuICAgICAgaWYgKHN0YW5kYXJkTmFtZSAhPT0gbmFtZSkge1xuICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICdJbnZhbGlkIERPTSBwcm9wZXJ0eSBgJXNgLiBEaWQgeW91IG1lYW4gYCVzYD8nLCBuYW1lLCBzdGFuZGFyZE5hbWUpO1xuICAgICAgICB3YXJuZWRQcm9wZXJ0aWVzJDFbbmFtZV0gPSB0cnVlO1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH1cbiAgICB9IGVsc2UgaWYgKCFpc1Jlc2VydmVkICYmIG5hbWUgIT09IGxvd2VyQ2FzZWROYW1lKSB7XG4gICAgICAvLyBVbmtub3duIGF0dHJpYnV0ZXMgc2hvdWxkIGhhdmUgbG93ZXJjYXNlIGNhc2luZyBzaW5jZSB0aGF0J3MgaG93IHRoZXlcbiAgICAgIC8vIHdpbGwgYmUgY2FzZWQgYW55d2F5IHdpdGggc2VydmVyIHJlbmRlcmluZy5cbiAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlYWN0IGRvZXMgbm90IHJlY29nbml6ZSB0aGUgYCVzYCBwcm9wIG9uIGEgRE9NIGVsZW1lbnQuIElmIHlvdSAnICsgJ2ludGVudGlvbmFsbHkgd2FudCBpdCB0byBhcHBlYXIgaW4gdGhlIERPTSBhcyBhIGN1c3RvbSAnICsgJ2F0dHJpYnV0ZSwgc3BlbGwgaXQgYXMgbG93ZXJjYXNlIGAlc2AgaW5zdGVhZC4gJyArICdJZiB5b3UgYWNjaWRlbnRhbGx5IHBhc3NlZCBpdCBmcm9tIGEgcGFyZW50IGNvbXBvbmVudCwgcmVtb3ZlICcgKyAnaXQgZnJvbSB0aGUgRE9NIGVsZW1lbnQuJywgbmFtZSwgbG93ZXJDYXNlZE5hbWUpO1xuICAgICAgd2FybmVkUHJvcGVydGllcyQxW25hbWVdID0gdHJ1ZTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cblxuICAgIGlmICh0eXBlb2YgdmFsdWUgPT09ICdib29sZWFuJyAmJiBzaG91bGRSZW1vdmVBdHRyaWJ1dGVXaXRoV2FybmluZyhuYW1lLCB2YWx1ZSwgcHJvcGVydHlJbmZvLCBmYWxzZSkpIHtcbiAgICAgIGlmICh2YWx1ZSkge1xuICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICdSZWNlaXZlZCBgJXNgIGZvciBhIG5vbi1ib29sZWFuIGF0dHJpYnV0ZSBgJXNgLlxcblxcbicgKyAnSWYgeW91IHdhbnQgdG8gd3JpdGUgaXQgdG8gdGhlIERPTSwgcGFzcyBhIHN0cmluZyBpbnN0ZWFkOiAnICsgJyVzPVwiJXNcIiBvciAlcz17dmFsdWUudG9TdHJpbmcoKX0uJywgdmFsdWUsIG5hbWUsIG5hbWUsIHZhbHVlLCBuYW1lKTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlY2VpdmVkIGAlc2AgZm9yIGEgbm9uLWJvb2xlYW4gYXR0cmlidXRlIGAlc2AuXFxuXFxuJyArICdJZiB5b3Ugd2FudCB0byB3cml0ZSBpdCB0byB0aGUgRE9NLCBwYXNzIGEgc3RyaW5nIGluc3RlYWQ6ICcgKyAnJXM9XCIlc1wiIG9yICVzPXt2YWx1ZS50b1N0cmluZygpfS5cXG5cXG4nICsgJ0lmIHlvdSB1c2VkIHRvIGNvbmRpdGlvbmFsbHkgb21pdCBpdCB3aXRoICVzPXtjb25kaXRpb24gJiYgdmFsdWV9LCAnICsgJ3Bhc3MgJXM9e2NvbmRpdGlvbiA/IHZhbHVlIDogdW5kZWZpbmVkfSBpbnN0ZWFkLicsIHZhbHVlLCBuYW1lLCBuYW1lLCB2YWx1ZSwgbmFtZSwgbmFtZSwgbmFtZSk7XG4gICAgICB9XG4gICAgICB3YXJuZWRQcm9wZXJ0aWVzJDFbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgLy8gTm93IHRoYXQgd2UndmUgdmFsaWRhdGVkIGNhc2luZywgZG8gbm90IHZhbGlkYXRlXG4gICAgLy8gZGF0YSB0eXBlcyBmb3IgcmVzZXJ2ZWQgcHJvcHNcbiAgICBpZiAoaXNSZXNlcnZlZCkge1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgLy8gV2FybiB3aGVuIGEga25vd24gYXR0cmlidXRlIGlzIGEgYmFkIHR5cGVcbiAgICBpZiAoc2hvdWxkUmVtb3ZlQXR0cmlidXRlV2l0aFdhcm5pbmcobmFtZSwgdmFsdWUsIHByb3BlcnR5SW5mbywgZmFsc2UpKSB7XG4gICAgICB3YXJuZWRQcm9wZXJ0aWVzJDFbbmFtZV0gPSB0cnVlO1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIC8vIFdhcm4gd2hlbiBwYXNzaW5nIHRoZSBzdHJpbmdzICdmYWxzZScgb3IgJ3RydWUnIGludG8gYSBib29sZWFuIHByb3BcbiAgICBpZiAoKHZhbHVlID09PSAnZmFsc2UnIHx8IHZhbHVlID09PSAndHJ1ZScpICYmIHByb3BlcnR5SW5mbyAhPT0gbnVsbCAmJiBwcm9wZXJ0eUluZm8udHlwZSA9PT0gQk9PTEVBTikge1xuICAgICAgd2FybmluZyQxKGZhbHNlLCAnUmVjZWl2ZWQgdGhlIHN0cmluZyBgJXNgIGZvciB0aGUgYm9vbGVhbiBhdHRyaWJ1dGUgYCVzYC4gJyArICclcyAnICsgJ0RpZCB5b3UgbWVhbiAlcz17JXN9PycsIHZhbHVlLCBuYW1lLCB2YWx1ZSA9PT0gJ2ZhbHNlJyA/ICdUaGUgYnJvd3NlciB3aWxsIGludGVycHJldCBpdCBhcyBhIHRydXRoeSB2YWx1ZS4nIDogJ0FsdGhvdWdoIHRoaXMgd29ya3MsIGl0IHdpbGwgbm90IHdvcmsgYXMgZXhwZWN0ZWQgaWYgeW91IHBhc3MgdGhlIHN0cmluZyBcImZhbHNlXCIuJywgbmFtZSwgdmFsdWUpO1xuICAgICAgd2FybmVkUHJvcGVydGllcyQxW25hbWVdID0gdHJ1ZTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH1cblxuICAgIHJldHVybiB0cnVlO1xuICB9O1xufVxuXG52YXIgd2FyblVua25vd25Qcm9wZXJ0aWVzID0gZnVuY3Rpb24gKHR5cGUsIHByb3BzLCBjYW5Vc2VFdmVudFN5c3RlbSkge1xuICB2YXIgdW5rbm93blByb3BzID0gW107XG4gIGZvciAodmFyIGtleSBpbiBwcm9wcykge1xuICAgIHZhciBpc1ZhbGlkID0gdmFsaWRhdGVQcm9wZXJ0eSQxKHR5cGUsIGtleSwgcHJvcHNba2V5XSwgY2FuVXNlRXZlbnRTeXN0ZW0pO1xuICAgIGlmICghaXNWYWxpZCkge1xuICAgICAgdW5rbm93blByb3BzLnB1c2goa2V5KTtcbiAgICB9XG4gIH1cblxuICB2YXIgdW5rbm93blByb3BTdHJpbmcgPSB1bmtub3duUHJvcHMubWFwKGZ1bmN0aW9uIChwcm9wKSB7XG4gICAgcmV0dXJuICdgJyArIHByb3AgKyAnYCc7XG4gIH0pLmpvaW4oJywgJyk7XG4gIGlmICh1bmtub3duUHJvcHMubGVuZ3RoID09PSAxKSB7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnSW52YWxpZCB2YWx1ZSBmb3IgcHJvcCAlcyBvbiA8JXM+IHRhZy4gRWl0aGVyIHJlbW92ZSBpdCBmcm9tIHRoZSBlbGVtZW50LCAnICsgJ29yIHBhc3MgYSBzdHJpbmcgb3IgbnVtYmVyIHZhbHVlIHRvIGtlZXAgaXQgaW4gdGhlIERPTS4gJyArICdGb3IgZGV0YWlscywgc2VlIGh0dHBzOi8vZmIubWUvcmVhY3QtYXR0cmlidXRlLWJlaGF2aW9yJywgdW5rbm93blByb3BTdHJpbmcsIHR5cGUpO1xuICB9IGVsc2UgaWYgKHVua25vd25Qcm9wcy5sZW5ndGggPiAxKSB7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnSW52YWxpZCB2YWx1ZXMgZm9yIHByb3BzICVzIG9uIDwlcz4gdGFnLiBFaXRoZXIgcmVtb3ZlIHRoZW0gZnJvbSB0aGUgZWxlbWVudCwgJyArICdvciBwYXNzIGEgc3RyaW5nIG9yIG51bWJlciB2YWx1ZSB0byBrZWVwIHRoZW0gaW4gdGhlIERPTS4gJyArICdGb3IgZGV0YWlscywgc2VlIGh0dHBzOi8vZmIubWUvcmVhY3QtYXR0cmlidXRlLWJlaGF2aW9yJywgdW5rbm93blByb3BTdHJpbmcsIHR5cGUpO1xuICB9XG59O1xuXG5mdW5jdGlvbiB2YWxpZGF0ZVByb3BlcnRpZXMkMih0eXBlLCBwcm9wcywgY2FuVXNlRXZlbnRTeXN0ZW0pIHtcbiAgaWYgKGlzQ3VzdG9tQ29tcG9uZW50KHR5cGUsIHByb3BzKSkge1xuICAgIHJldHVybjtcbiAgfVxuICB3YXJuVW5rbm93blByb3BlcnRpZXModHlwZSwgcHJvcHMsIGNhblVzZUV2ZW50U3lzdGVtKTtcbn1cblxuZnVuY3Rpb24gX2NsYXNzQ2FsbENoZWNrKGluc3RhbmNlLCBDb25zdHJ1Y3RvcikgeyBpZiAoIShpbnN0YW5jZSBpbnN0YW5jZW9mIENvbnN0cnVjdG9yKSkgeyB0aHJvdyBuZXcgVHlwZUVycm9yKFwiQ2Fubm90IGNhbGwgYSBjbGFzcyBhcyBhIGZ1bmN0aW9uXCIpOyB9IH1cblxuLy8gQmFzZWQgb24gcmVhZGluZyB0aGUgUmVhY3QuQ2hpbGRyZW4gaW1wbGVtZW50YXRpb24uIFRPRE86IHR5cGUgdGhpcyBzb21ld2hlcmU/XG5cbnZhciB0b0FycmF5ID0gUmVhY3QuQ2hpbGRyZW4udG9BcnJheTtcblxuLy8gVGhpcyBpcyBvbmx5IHVzZWQgaW4gREVWLlxuLy8gRWFjaCBlbnRyeSBpcyBgdGhpcy5zdGFja2AgZnJvbSBhIGN1cnJlbnRseSBleGVjdXRpbmcgcmVuZGVyZXIgaW5zdGFuY2UuXG4vLyAoVGhlcmUgbWF5IGJlIG1vcmUgdGhhbiBvbmUgYmVjYXVzZSBSZWFjdERPTVNlcnZlciBpcyByZWVudHJhbnQpLlxuLy8gRWFjaCBzdGFjayBpcyBhbiBhcnJheSBvZiBmcmFtZXMgd2hpY2ggbWF5IGNvbnRhaW4gbmVzdGVkIHN0YWNrcyBvZiBlbGVtZW50cy5cbnZhciBjdXJyZW50RGVidWdTdGFja3MgPSBbXTtcblxudmFyIFJlYWN0Q3VycmVudERpc3BhdGNoZXIgPSBSZWFjdFNoYXJlZEludGVybmFscy5SZWFjdEN1cnJlbnREaXNwYXRjaGVyO1xudmFyIFJlYWN0RGVidWdDdXJyZW50RnJhbWUgPSB2b2lkIDA7XG52YXIgcHJldkdldEN1cnJlbnRTdGFja0ltcGwgPSBudWxsO1xudmFyIGdldEN1cnJlbnRTZXJ2ZXJTdGFja0ltcGwgPSBmdW5jdGlvbiAoKSB7XG4gIHJldHVybiAnJztcbn07XG52YXIgZGVzY3JpYmVTdGFja0ZyYW1lID0gZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgcmV0dXJuICcnO1xufTtcblxudmFyIHZhbGlkYXRlUHJvcGVydGllc0luRGV2ZWxvcG1lbnQgPSBmdW5jdGlvbiAodHlwZSwgcHJvcHMpIHt9O1xudmFyIHB1c2hDdXJyZW50RGVidWdTdGFjayA9IGZ1bmN0aW9uIChzdGFjaykge307XG52YXIgcHVzaEVsZW1lbnRUb0RlYnVnU3RhY2sgPSBmdW5jdGlvbiAoZWxlbWVudCkge307XG52YXIgcG9wQ3VycmVudERlYnVnU3RhY2sgPSBmdW5jdGlvbiAoKSB7fTtcbnZhciBoYXNXYXJuZWRBYm91dFVzaW5nQ29udGV4dEFzQ29uc3VtZXIgPSBmYWxzZTtcblxue1xuICBSZWFjdERlYnVnQ3VycmVudEZyYW1lID0gUmVhY3RTaGFyZWRJbnRlcm5hbHMuUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZTtcblxuICB2YWxpZGF0ZVByb3BlcnRpZXNJbkRldmVsb3BtZW50ID0gZnVuY3Rpb24gKHR5cGUsIHByb3BzKSB7XG4gICAgdmFsaWRhdGVQcm9wZXJ0aWVzKHR5cGUsIHByb3BzKTtcbiAgICB2YWxpZGF0ZVByb3BlcnRpZXMkMSh0eXBlLCBwcm9wcyk7XG4gICAgdmFsaWRhdGVQcm9wZXJ0aWVzJDIodHlwZSwgcHJvcHMsIC8qIGNhblVzZUV2ZW50U3lzdGVtICovZmFsc2UpO1xuICB9O1xuXG4gIGRlc2NyaWJlU3RhY2tGcmFtZSA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgdmFyIHNvdXJjZSA9IGVsZW1lbnQuX3NvdXJjZTtcbiAgICB2YXIgdHlwZSA9IGVsZW1lbnQudHlwZTtcbiAgICB2YXIgbmFtZSA9IGdldENvbXBvbmVudE5hbWUodHlwZSk7XG4gICAgdmFyIG93bmVyTmFtZSA9IG51bGw7XG4gICAgcmV0dXJuIGRlc2NyaWJlQ29tcG9uZW50RnJhbWUobmFtZSwgc291cmNlLCBvd25lck5hbWUpO1xuICB9O1xuXG4gIHB1c2hDdXJyZW50RGVidWdTdGFjayA9IGZ1bmN0aW9uIChzdGFjaykge1xuICAgIGN1cnJlbnREZWJ1Z1N0YWNrcy5wdXNoKHN0YWNrKTtcblxuICAgIGlmIChjdXJyZW50RGVidWdTdGFja3MubGVuZ3RoID09PSAxKSB7XG4gICAgICAvLyBXZSBhcmUgZW50ZXJpbmcgYSBzZXJ2ZXIgcmVuZGVyZXIuXG4gICAgICAvLyBSZW1lbWJlciB0aGUgcHJldmlvdXMgKGUuZy4gY2xpZW50KSBnbG9iYWwgc3RhY2sgaW1wbGVtZW50YXRpb24uXG4gICAgICBwcmV2R2V0Q3VycmVudFN0YWNrSW1wbCA9IFJlYWN0RGVidWdDdXJyZW50RnJhbWUuZ2V0Q3VycmVudFN0YWNrO1xuICAgICAgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZS5nZXRDdXJyZW50U3RhY2sgPSBnZXRDdXJyZW50U2VydmVyU3RhY2tJbXBsO1xuICAgIH1cbiAgfTtcblxuICBwdXNoRWxlbWVudFRvRGVidWdTdGFjayA9IGZ1bmN0aW9uIChlbGVtZW50KSB7XG4gICAgLy8gRm9yIHRoZSBpbm5lcm1vc3QgZXhlY3V0aW5nIFJlYWN0RE9NU2VydmVyIGNhbGwsXG4gICAgdmFyIHN0YWNrID0gY3VycmVudERlYnVnU3RhY2tzW2N1cnJlbnREZWJ1Z1N0YWNrcy5sZW5ndGggLSAxXTtcbiAgICAvLyBUYWtlIHRoZSBpbm5lcm1vc3QgZXhlY3V0aW5nIGZyYW1lIChlLmcuIDxGb28+KSxcbiAgICB2YXIgZnJhbWUgPSBzdGFja1tzdGFjay5sZW5ndGggLSAxXTtcbiAgICAvLyBhbmQgcmVjb3JkIHRoYXQgaXQgaGFzIG9uZSBtb3JlIGVsZW1lbnQgYXNzb2NpYXRlZCB3aXRoIGl0LlxuICAgIGZyYW1lLmRlYnVnRWxlbWVudFN0YWNrLnB1c2goZWxlbWVudCk7XG4gICAgLy8gV2Ugb25seSBuZWVkIHRoaXMgYmVjYXVzZSB3ZSB0YWlsLW9wdGltaXplIHNpbmdsZS1lbGVtZW50XG4gICAgLy8gY2hpbGRyZW4gYW5kIGRpcmVjdGx5IGhhbmRsZSB0aGVtIGluIGFuIGlubmVyIGxvb3AgaW5zdGVhZCBvZlxuICAgIC8vIGNyZWF0aW5nIHNlcGFyYXRlIGZyYW1lcyBmb3IgdGhlbS5cbiAgfTtcblxuICBwb3BDdXJyZW50RGVidWdTdGFjayA9IGZ1bmN0aW9uICgpIHtcbiAgICBjdXJyZW50RGVidWdTdGFja3MucG9wKCk7XG5cbiAgICBpZiAoY3VycmVudERlYnVnU3RhY2tzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgLy8gV2UgYXJlIGV4aXRpbmcgdGhlIHNlcnZlciByZW5kZXJlci5cbiAgICAgIC8vIFJlc3RvcmUgdGhlIHByZXZpb3VzIChlLmcuIGNsaWVudCkgZ2xvYmFsIHN0YWNrIGltcGxlbWVudGF0aW9uLlxuICAgICAgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZS5nZXRDdXJyZW50U3RhY2sgPSBwcmV2R2V0Q3VycmVudFN0YWNrSW1wbDtcbiAgICAgIHByZXZHZXRDdXJyZW50U3RhY2tJbXBsID0gbnVsbDtcbiAgICB9XG4gIH07XG5cbiAgZ2V0Q3VycmVudFNlcnZlclN0YWNrSW1wbCA9IGZ1bmN0aW9uICgpIHtcbiAgICBpZiAoY3VycmVudERlYnVnU3RhY2tzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgLy8gTm90aGluZyBpcyBjdXJyZW50bHkgcmVuZGVyaW5nLlxuICAgICAgcmV0dXJuICcnO1xuICAgIH1cbiAgICAvLyBSZWFjdERPTVNlcnZlciBpcyByZWVudHJhbnQgc28gdGhlcmUgbWF5IGJlIG11bHRpcGxlIGNhbGxzIGF0IHRoZSBzYW1lIHRpbWUuXG4gICAgLy8gVGFrZSB0aGUgZnJhbWVzIGZyb20gdGhlIGlubmVybW9zdCBjYWxsIHdoaWNoIGlzIHRoZSBsYXN0IGluIHRoZSBhcnJheS5cbiAgICB2YXIgZnJhbWVzID0gY3VycmVudERlYnVnU3RhY2tzW2N1cnJlbnREZWJ1Z1N0YWNrcy5sZW5ndGggLSAxXTtcbiAgICB2YXIgc3RhY2sgPSAnJztcbiAgICAvLyBHbyB0aHJvdWdoIGV2ZXJ5IGZyYW1lIGluIHRoZSBzdGFjayBmcm9tIHRoZSBpbm5lcm1vc3Qgb25lLlxuICAgIGZvciAodmFyIGkgPSBmcmFtZXMubGVuZ3RoIC0gMTsgaSA+PSAwOyBpLS0pIHtcbiAgICAgIHZhciBmcmFtZSA9IGZyYW1lc1tpXTtcbiAgICAgIC8vIEV2ZXJ5IGZyYW1lIG1pZ2h0IGhhdmUgbW9yZSB0aGFuIG9uZSBkZWJ1ZyBlbGVtZW50IHN0YWNrIGVudHJ5IGFzc29jaWF0ZWQgd2l0aCBpdC5cbiAgICAgIC8vIFRoaXMgaXMgYmVjYXVzZSBzaW5nbGUtY2hpbGQgbmVzdGluZyBkb2Vzbid0IGNyZWF0ZSBtYXRlcmlhbGl6ZWQgZnJhbWVzLlxuICAgICAgLy8gSW5zdGVhZCBpdCB3b3VsZCBwdXNoIHRoZW0gdGhyb3VnaCBgcHVzaEVsZW1lbnRUb0RlYnVnU3RhY2soKWAuXG4gICAgICB2YXIgX2RlYnVnRWxlbWVudFN0YWNrID0gZnJhbWUuZGVidWdFbGVtZW50U3RhY2s7XG4gICAgICBmb3IgKHZhciBpaSA9IF9kZWJ1Z0VsZW1lbnRTdGFjay5sZW5ndGggLSAxOyBpaSA+PSAwOyBpaS0tKSB7XG4gICAgICAgIHN0YWNrICs9IGRlc2NyaWJlU3RhY2tGcmFtZShfZGVidWdFbGVtZW50U3RhY2tbaWldKTtcbiAgICAgIH1cbiAgICB9XG4gICAgcmV0dXJuIHN0YWNrO1xuICB9O1xufVxuXG52YXIgZGlkV2FybkRlZmF1bHRJbnB1dFZhbHVlID0gZmFsc2U7XG52YXIgZGlkV2FybkRlZmF1bHRDaGVja2VkID0gZmFsc2U7XG52YXIgZGlkV2FybkRlZmF1bHRTZWxlY3RWYWx1ZSA9IGZhbHNlO1xudmFyIGRpZFdhcm5EZWZhdWx0VGV4dGFyZWFWYWx1ZSA9IGZhbHNlO1xudmFyIGRpZFdhcm5JbnZhbGlkT3B0aW9uQ2hpbGRyZW4gPSBmYWxzZTtcbnZhciBkaWRXYXJuQWJvdXROb29wVXBkYXRlRm9yQ29tcG9uZW50ID0ge307XG52YXIgZGlkV2FybkFib3V0QmFkQ2xhc3MgPSB7fTtcbnZhciBkaWRXYXJuQWJvdXREZXByZWNhdGVkV2lsbE1vdW50ID0ge307XG52YXIgZGlkV2FybkFib3V0VW5kZWZpbmVkRGVyaXZlZFN0YXRlID0ge307XG52YXIgZGlkV2FybkFib3V0VW5pbml0aWFsaXplZFN0YXRlID0ge307XG52YXIgdmFsdWVQcm9wTmFtZXMgPSBbJ3ZhbHVlJywgJ2RlZmF1bHRWYWx1ZSddO1xudmFyIG5ld2xpbmVFYXRpbmdUYWdzID0ge1xuICBsaXN0aW5nOiB0cnVlLFxuICBwcmU6IHRydWUsXG4gIHRleHRhcmVhOiB0cnVlXG59O1xuXG4vLyBXZSBhY2NlcHQgYW55IHRhZyB0byBiZSByZW5kZXJlZCBidXQgc2luY2UgdGhpcyBnZXRzIGluamVjdGVkIGludG8gYXJiaXRyYXJ5XG4vLyBIVE1MLCB3ZSB3YW50IHRvIG1ha2Ugc3VyZSB0aGF0IGl0J3MgYSBzYWZlIHRhZy5cbi8vIGh0dHA6Ly93d3cudzMub3JnL1RSL1JFQy14bWwvI05ULU5hbWVcbnZhciBWQUxJRF9UQUdfUkVHRVggPSAvXlthLXpBLVpdW2EtekEtWjpfXFwuXFwtXFxkXSokLzsgLy8gU2ltcGxpZmllZCBzdWJzZXRcbnZhciB2YWxpZGF0ZWRUYWdDYWNoZSA9IHt9O1xuZnVuY3Rpb24gdmFsaWRhdGVEYW5nZXJvdXNUYWcodGFnKSB7XG4gIGlmICghdmFsaWRhdGVkVGFnQ2FjaGUuaGFzT3duUHJvcGVydHkodGFnKSkge1xuICAgICFWQUxJRF9UQUdfUkVHRVgudGVzdCh0YWcpID8gaW52YXJpYW50KGZhbHNlLCAnSW52YWxpZCB0YWc6ICVzJywgdGFnKSA6IHZvaWQgMDtcbiAgICB2YWxpZGF0ZWRUYWdDYWNoZVt0YWddID0gdHJ1ZTtcbiAgfVxufVxuXG52YXIgc3R5bGVOYW1lQ2FjaGUgPSB7fTtcbnZhciBwcm9jZXNzU3R5bGVOYW1lID0gZnVuY3Rpb24gKHN0eWxlTmFtZSkge1xuICBpZiAoc3R5bGVOYW1lQ2FjaGUuaGFzT3duUHJvcGVydHkoc3R5bGVOYW1lKSkge1xuICAgIHJldHVybiBzdHlsZU5hbWVDYWNoZVtzdHlsZU5hbWVdO1xuICB9XG4gIHZhciByZXN1bHQgPSBoeXBoZW5hdGVTdHlsZU5hbWUoc3R5bGVOYW1lKTtcbiAgc3R5bGVOYW1lQ2FjaGVbc3R5bGVOYW1lXSA9IHJlc3VsdDtcbiAgcmV0dXJuIHJlc3VsdDtcbn07XG5cbmZ1bmN0aW9uIGNyZWF0ZU1hcmt1cEZvclN0eWxlcyhzdHlsZXMpIHtcbiAgdmFyIHNlcmlhbGl6ZWQgPSAnJztcbiAgdmFyIGRlbGltaXRlciA9ICcnO1xuICBmb3IgKHZhciBzdHlsZU5hbWUgaW4gc3R5bGVzKSB7XG4gICAgaWYgKCFzdHlsZXMuaGFzT3duUHJvcGVydHkoc3R5bGVOYW1lKSkge1xuICAgICAgY29udGludWU7XG4gICAgfVxuICAgIHZhciBpc0N1c3RvbVByb3BlcnR5ID0gc3R5bGVOYW1lLmluZGV4T2YoJy0tJykgPT09IDA7XG4gICAgdmFyIHN0eWxlVmFsdWUgPSBzdHlsZXNbc3R5bGVOYW1lXTtcbiAgICB7XG4gICAgICBpZiAoIWlzQ3VzdG9tUHJvcGVydHkpIHtcbiAgICAgICAgd2FyblZhbGlkU3R5bGUkMShzdHlsZU5hbWUsIHN0eWxlVmFsdWUpO1xuICAgICAgfVxuICAgIH1cbiAgICBpZiAoc3R5bGVWYWx1ZSAhPSBudWxsKSB7XG4gICAgICBzZXJpYWxpemVkICs9IGRlbGltaXRlciArIHByb2Nlc3NTdHlsZU5hbWUoc3R5bGVOYW1lKSArICc6JztcbiAgICAgIHNlcmlhbGl6ZWQgKz0gZGFuZ2Vyb3VzU3R5bGVWYWx1ZShzdHlsZU5hbWUsIHN0eWxlVmFsdWUsIGlzQ3VzdG9tUHJvcGVydHkpO1xuXG4gICAgICBkZWxpbWl0ZXIgPSAnOyc7XG4gICAgfVxuICB9XG4gIHJldHVybiBzZXJpYWxpemVkIHx8IG51bGw7XG59XG5cbmZ1bmN0aW9uIHdhcm5Ob29wKHB1YmxpY0luc3RhbmNlLCBjYWxsZXJOYW1lKSB7XG4gIHtcbiAgICB2YXIgX2NvbnN0cnVjdG9yID0gcHVibGljSW5zdGFuY2UuY29uc3RydWN0b3I7XG4gICAgdmFyIGNvbXBvbmVudE5hbWUgPSBfY29uc3RydWN0b3IgJiYgZ2V0Q29tcG9uZW50TmFtZShfY29uc3RydWN0b3IpIHx8ICdSZWFjdENsYXNzJztcbiAgICB2YXIgd2FybmluZ0tleSA9IGNvbXBvbmVudE5hbWUgKyAnLicgKyBjYWxsZXJOYW1lO1xuICAgIGlmIChkaWRXYXJuQWJvdXROb29wVXBkYXRlRm9yQ29tcG9uZW50W3dhcm5pbmdLZXldKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnJXMoLi4uKTogQ2FuIG9ubHkgdXBkYXRlIGEgbW91bnRpbmcgY29tcG9uZW50LiAnICsgJ1RoaXMgdXN1YWxseSBtZWFucyB5b3UgY2FsbGVkICVzKCkgb3V0c2lkZSBjb21wb25lbnRXaWxsTW91bnQoKSBvbiB0aGUgc2VydmVyLiAnICsgJ1RoaXMgaXMgYSBuby1vcC5cXG5cXG5QbGVhc2UgY2hlY2sgdGhlIGNvZGUgZm9yIHRoZSAlcyBjb21wb25lbnQuJywgY2FsbGVyTmFtZSwgY2FsbGVyTmFtZSwgY29tcG9uZW50TmFtZSk7XG4gICAgZGlkV2FybkFib3V0Tm9vcFVwZGF0ZUZvckNvbXBvbmVudFt3YXJuaW5nS2V5XSA9IHRydWU7XG4gIH1cbn1cblxuZnVuY3Rpb24gc2hvdWxkQ29uc3RydWN0KENvbXBvbmVudCkge1xuICByZXR1cm4gQ29tcG9uZW50LnByb3RvdHlwZSAmJiBDb21wb25lbnQucHJvdG90eXBlLmlzUmVhY3RDb21wb25lbnQ7XG59XG5cbmZ1bmN0aW9uIGdldE5vbkNoaWxkcmVuSW5uZXJNYXJrdXAocHJvcHMpIHtcbiAgdmFyIGlubmVySFRNTCA9IHByb3BzLmRhbmdlcm91c2x5U2V0SW5uZXJIVE1MO1xuICBpZiAoaW5uZXJIVE1MICE9IG51bGwpIHtcbiAgICBpZiAoaW5uZXJIVE1MLl9faHRtbCAhPSBudWxsKSB7XG4gICAgICByZXR1cm4gaW5uZXJIVE1MLl9faHRtbDtcbiAgICB9XG4gIH0gZWxzZSB7XG4gICAgdmFyIGNvbnRlbnQgPSBwcm9wcy5jaGlsZHJlbjtcbiAgICBpZiAodHlwZW9mIGNvbnRlbnQgPT09ICdzdHJpbmcnIHx8IHR5cGVvZiBjb250ZW50ID09PSAnbnVtYmVyJykge1xuICAgICAgcmV0dXJuIGVzY2FwZVRleHRGb3JCcm93c2VyKGNvbnRlbnQpO1xuICAgIH1cbiAgfVxuICByZXR1cm4gbnVsbDtcbn1cblxuZnVuY3Rpb24gZmxhdHRlblRvcExldmVsQ2hpbGRyZW4oY2hpbGRyZW4pIHtcbiAgaWYgKCFSZWFjdC5pc1ZhbGlkRWxlbWVudChjaGlsZHJlbikpIHtcbiAgICByZXR1cm4gdG9BcnJheShjaGlsZHJlbik7XG4gIH1cbiAgdmFyIGVsZW1lbnQgPSBjaGlsZHJlbjtcbiAgaWYgKGVsZW1lbnQudHlwZSAhPT0gUkVBQ1RfRlJBR01FTlRfVFlQRSkge1xuICAgIHJldHVybiBbZWxlbWVudF07XG4gIH1cbiAgdmFyIGZyYWdtZW50Q2hpbGRyZW4gPSBlbGVtZW50LnByb3BzLmNoaWxkcmVuO1xuICBpZiAoIVJlYWN0LmlzVmFsaWRFbGVtZW50KGZyYWdtZW50Q2hpbGRyZW4pKSB7XG4gICAgcmV0dXJuIHRvQXJyYXkoZnJhZ21lbnRDaGlsZHJlbik7XG4gIH1cbiAgdmFyIGZyYWdtZW50Q2hpbGRFbGVtZW50ID0gZnJhZ21lbnRDaGlsZHJlbjtcbiAgcmV0dXJuIFtmcmFnbWVudENoaWxkRWxlbWVudF07XG59XG5cbmZ1bmN0aW9uIGZsYXR0ZW5PcHRpb25DaGlsZHJlbihjaGlsZHJlbikge1xuICBpZiAoY2hpbGRyZW4gPT09IHVuZGVmaW5lZCB8fCBjaGlsZHJlbiA9PT0gbnVsbCkge1xuICAgIHJldHVybiBjaGlsZHJlbjtcbiAgfVxuICB2YXIgY29udGVudCA9ICcnO1xuICAvLyBGbGF0dGVuIGNoaWxkcmVuIGFuZCB3YXJuIGlmIHRoZXkgYXJlbid0IHN0cmluZ3Mgb3IgbnVtYmVycztcbiAgLy8gaW52YWxpZCB0eXBlcyBhcmUgaWdub3JlZC5cbiAgUmVhY3QuQ2hpbGRyZW4uZm9yRWFjaChjaGlsZHJlbiwgZnVuY3Rpb24gKGNoaWxkKSB7XG4gICAgaWYgKGNoaWxkID09IG51bGwpIHtcbiAgICAgIHJldHVybjtcbiAgICB9XG4gICAgY29udGVudCArPSBjaGlsZDtcbiAgICB7XG4gICAgICBpZiAoIWRpZFdhcm5JbnZhbGlkT3B0aW9uQ2hpbGRyZW4gJiYgdHlwZW9mIGNoaWxkICE9PSAnc3RyaW5nJyAmJiB0eXBlb2YgY2hpbGQgIT09ICdudW1iZXInKSB7XG4gICAgICAgIGRpZFdhcm5JbnZhbGlkT3B0aW9uQ2hpbGRyZW4gPSB0cnVlO1xuICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICdPbmx5IHN0cmluZ3MgYW5kIG51bWJlcnMgYXJlIHN1cHBvcnRlZCBhcyA8b3B0aW9uPiBjaGlsZHJlbi4nKTtcbiAgICAgIH1cbiAgICB9XG4gIH0pO1xuICByZXR1cm4gY29udGVudDtcbn1cblxudmFyIGhhc093blByb3BlcnR5ID0gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eTtcbnZhciBTVFlMRSA9ICdzdHlsZSc7XG52YXIgUkVTRVJWRURfUFJPUFMgPSB7XG4gIGNoaWxkcmVuOiBudWxsLFxuICBkYW5nZXJvdXNseVNldElubmVySFRNTDogbnVsbCxcbiAgc3VwcHJlc3NDb250ZW50RWRpdGFibGVXYXJuaW5nOiBudWxsLFxuICBzdXBwcmVzc0h5ZHJhdGlvbldhcm5pbmc6IG51bGxcbn07XG5cbmZ1bmN0aW9uIGNyZWF0ZU9wZW5UYWdNYXJrdXAodGFnVmVyYmF0aW0sIHRhZ0xvd2VyY2FzZSwgcHJvcHMsIG5hbWVzcGFjZSwgbWFrZVN0YXRpY01hcmt1cCwgaXNSb290RWxlbWVudCkge1xuICB2YXIgcmV0ID0gJzwnICsgdGFnVmVyYmF0aW07XG5cbiAgZm9yICh2YXIgcHJvcEtleSBpbiBwcm9wcykge1xuICAgIGlmICghaGFzT3duUHJvcGVydHkuY2FsbChwcm9wcywgcHJvcEtleSkpIHtcbiAgICAgIGNvbnRpbnVlO1xuICAgIH1cbiAgICB2YXIgcHJvcFZhbHVlID0gcHJvcHNbcHJvcEtleV07XG4gICAgaWYgKHByb3BWYWx1ZSA9PSBudWxsKSB7XG4gICAgICBjb250aW51ZTtcbiAgICB9XG4gICAgaWYgKHByb3BLZXkgPT09IFNUWUxFKSB7XG4gICAgICBwcm9wVmFsdWUgPSBjcmVhdGVNYXJrdXBGb3JTdHlsZXMocHJvcFZhbHVlKTtcbiAgICB9XG4gICAgdmFyIG1hcmt1cCA9IG51bGw7XG4gICAgaWYgKGlzQ3VzdG9tQ29tcG9uZW50KHRhZ0xvd2VyY2FzZSwgcHJvcHMpKSB7XG4gICAgICBpZiAoIVJFU0VSVkVEX1BST1BTLmhhc093blByb3BlcnR5KHByb3BLZXkpKSB7XG4gICAgICAgIG1hcmt1cCA9IGNyZWF0ZU1hcmt1cEZvckN1c3RvbUF0dHJpYnV0ZShwcm9wS2V5LCBwcm9wVmFsdWUpO1xuICAgICAgfVxuICAgIH0gZWxzZSB7XG4gICAgICBtYXJrdXAgPSBjcmVhdGVNYXJrdXBGb3JQcm9wZXJ0eShwcm9wS2V5LCBwcm9wVmFsdWUpO1xuICAgIH1cbiAgICBpZiAobWFya3VwKSB7XG4gICAgICByZXQgKz0gJyAnICsgbWFya3VwO1xuICAgIH1cbiAgfVxuXG4gIC8vIEZvciBzdGF0aWMgcGFnZXMsIG5vIG5lZWQgdG8gcHV0IFJlYWN0IElEIGFuZCBjaGVja3N1bS4gU2F2ZXMgbG90cyBvZlxuICAvLyBieXRlcy5cbiAgaWYgKG1ha2VTdGF0aWNNYXJrdXApIHtcbiAgICByZXR1cm4gcmV0O1xuICB9XG5cbiAgaWYgKGlzUm9vdEVsZW1lbnQpIHtcbiAgICByZXQgKz0gJyAnICsgY3JlYXRlTWFya3VwRm9yUm9vdCgpO1xuICB9XG4gIHJldHVybiByZXQ7XG59XG5cbmZ1bmN0aW9uIHZhbGlkYXRlUmVuZGVyUmVzdWx0KGNoaWxkLCB0eXBlKSB7XG4gIGlmIChjaGlsZCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgaW52YXJpYW50KGZhbHNlLCAnJXMoLi4uKTogTm90aGluZyB3YXMgcmV0dXJuZWQgZnJvbSByZW5kZXIuIFRoaXMgdXN1YWxseSBtZWFucyBhIHJldHVybiBzdGF0ZW1lbnQgaXMgbWlzc2luZy4gT3IsIHRvIHJlbmRlciBub3RoaW5nLCByZXR1cm4gbnVsbC4nLCBnZXRDb21wb25lbnROYW1lKHR5cGUpIHx8ICdDb21wb25lbnQnKTtcbiAgfVxufVxuXG5mdW5jdGlvbiByZXNvbHZlKGNoaWxkLCBjb250ZXh0LCB0aHJlYWRJRCkge1xuICB3aGlsZSAoUmVhY3QuaXNWYWxpZEVsZW1lbnQoY2hpbGQpKSB7XG4gICAgLy8gU2FmZSBiZWNhdXNlIHdlIGp1c3QgY2hlY2tlZCBpdCdzIGFuIGVsZW1lbnQuXG4gICAgdmFyIGVsZW1lbnQgPSBjaGlsZDtcbiAgICB2YXIgQ29tcG9uZW50ID0gZWxlbWVudC50eXBlO1xuICAgIHtcbiAgICAgIHB1c2hFbGVtZW50VG9EZWJ1Z1N0YWNrKGVsZW1lbnQpO1xuICAgIH1cbiAgICBpZiAodHlwZW9mIENvbXBvbmVudCAhPT0gJ2Z1bmN0aW9uJykge1xuICAgICAgYnJlYWs7XG4gICAgfVxuICAgIHByb2Nlc3NDaGlsZChlbGVtZW50LCBDb21wb25lbnQpO1xuICB9XG5cbiAgLy8gRXh0cmEgY2xvc3VyZSBzbyBxdWV1ZSBhbmQgcmVwbGFjZSBjYW4gYmUgY2FwdHVyZWQgcHJvcGVybHlcbiAgZnVuY3Rpb24gcHJvY2Vzc0NoaWxkKGVsZW1lbnQsIENvbXBvbmVudCkge1xuICAgIHZhciBwdWJsaWNDb250ZXh0ID0gcHJvY2Vzc0NvbnRleHQoQ29tcG9uZW50LCBjb250ZXh0LCB0aHJlYWRJRCk7XG5cbiAgICB2YXIgcXVldWUgPSBbXTtcbiAgICB2YXIgcmVwbGFjZSA9IGZhbHNlO1xuICAgIHZhciB1cGRhdGVyID0ge1xuICAgICAgaXNNb3VudGVkOiBmdW5jdGlvbiAocHVibGljSW5zdGFuY2UpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfSxcbiAgICAgIGVucXVldWVGb3JjZVVwZGF0ZTogZnVuY3Rpb24gKHB1YmxpY0luc3RhbmNlKSB7XG4gICAgICAgIGlmIChxdWV1ZSA9PT0gbnVsbCkge1xuICAgICAgICAgIHdhcm5Ob29wKHB1YmxpY0luc3RhbmNlLCAnZm9yY2VVcGRhdGUnKTtcbiAgICAgICAgICByZXR1cm4gbnVsbDtcbiAgICAgICAgfVxuICAgICAgfSxcbiAgICAgIGVucXVldWVSZXBsYWNlU3RhdGU6IGZ1bmN0aW9uIChwdWJsaWNJbnN0YW5jZSwgY29tcGxldGVTdGF0ZSkge1xuICAgICAgICByZXBsYWNlID0gdHJ1ZTtcbiAgICAgICAgcXVldWUgPSBbY29tcGxldGVTdGF0ZV07XG4gICAgICB9LFxuICAgICAgZW5xdWV1ZVNldFN0YXRlOiBmdW5jdGlvbiAocHVibGljSW5zdGFuY2UsIGN1cnJlbnRQYXJ0aWFsU3RhdGUpIHtcbiAgICAgICAgaWYgKHF1ZXVlID09PSBudWxsKSB7XG4gICAgICAgICAgd2Fybk5vb3AocHVibGljSW5zdGFuY2UsICdzZXRTdGF0ZScpO1xuICAgICAgICAgIHJldHVybiBudWxsO1xuICAgICAgICB9XG4gICAgICAgIHF1ZXVlLnB1c2goY3VycmVudFBhcnRpYWxTdGF0ZSk7XG4gICAgICB9XG4gICAgfTtcblxuICAgIHZhciBpbnN0ID0gdm9pZCAwO1xuICAgIGlmIChzaG91bGRDb25zdHJ1Y3QoQ29tcG9uZW50KSkge1xuICAgICAgaW5zdCA9IG5ldyBDb21wb25lbnQoZWxlbWVudC5wcm9wcywgcHVibGljQ29udGV4dCwgdXBkYXRlcik7XG5cbiAgICAgIGlmICh0eXBlb2YgQ29tcG9uZW50LmdldERlcml2ZWRTdGF0ZUZyb21Qcm9wcyA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICAgICB7XG4gICAgICAgICAgaWYgKGluc3Quc3RhdGUgPT09IG51bGwgfHwgaW5zdC5zdGF0ZSA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgICB2YXIgY29tcG9uZW50TmFtZSA9IGdldENvbXBvbmVudE5hbWUoQ29tcG9uZW50KSB8fCAnVW5rbm93bic7XG4gICAgICAgICAgICBpZiAoIWRpZFdhcm5BYm91dFVuaW5pdGlhbGl6ZWRTdGF0ZVtjb21wb25lbnROYW1lXSkge1xuICAgICAgICAgICAgICB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdgJXNgIHVzZXMgYGdldERlcml2ZWRTdGF0ZUZyb21Qcm9wc2AgYnV0IGl0cyBpbml0aWFsIHN0YXRlIGlzICcgKyAnJXMuIFRoaXMgaXMgbm90IHJlY29tbWVuZGVkLiBJbnN0ZWFkLCBkZWZpbmUgdGhlIGluaXRpYWwgc3RhdGUgYnkgJyArICdhc3NpZ25pbmcgYW4gb2JqZWN0IHRvIGB0aGlzLnN0YXRlYCBpbiB0aGUgY29uc3RydWN0b3Igb2YgYCVzYC4gJyArICdUaGlzIGVuc3VyZXMgdGhhdCBgZ2V0RGVyaXZlZFN0YXRlRnJvbVByb3BzYCBhcmd1bWVudHMgaGF2ZSBhIGNvbnNpc3RlbnQgc2hhcGUuJywgY29tcG9uZW50TmFtZSwgaW5zdC5zdGF0ZSA9PT0gbnVsbCA/ICdudWxsJyA6ICd1bmRlZmluZWQnLCBjb21wb25lbnROYW1lKTtcbiAgICAgICAgICAgICAgZGlkV2FybkFib3V0VW5pbml0aWFsaXplZFN0YXRlW2NvbXBvbmVudE5hbWVdID0gdHJ1ZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICB2YXIgcGFydGlhbFN0YXRlID0gQ29tcG9uZW50LmdldERlcml2ZWRTdGF0ZUZyb21Qcm9wcy5jYWxsKG51bGwsIGVsZW1lbnQucHJvcHMsIGluc3Quc3RhdGUpO1xuXG4gICAgICAgIHtcbiAgICAgICAgICBpZiAocGFydGlhbFN0YXRlID09PSB1bmRlZmluZWQpIHtcbiAgICAgICAgICAgIHZhciBfY29tcG9uZW50TmFtZSA9IGdldENvbXBvbmVudE5hbWUoQ29tcG9uZW50KSB8fCAnVW5rbm93bic7XG4gICAgICAgICAgICBpZiAoIWRpZFdhcm5BYm91dFVuZGVmaW5lZERlcml2ZWRTdGF0ZVtfY29tcG9uZW50TmFtZV0pIHtcbiAgICAgICAgICAgICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnJXMuZ2V0RGVyaXZlZFN0YXRlRnJvbVByb3BzKCk6IEEgdmFsaWQgc3RhdGUgb2JqZWN0IChvciBudWxsKSBtdXN0IGJlIHJldHVybmVkLiAnICsgJ1lvdSBoYXZlIHJldHVybmVkIHVuZGVmaW5lZC4nLCBfY29tcG9uZW50TmFtZSk7XG4gICAgICAgICAgICAgIGRpZFdhcm5BYm91dFVuZGVmaW5lZERlcml2ZWRTdGF0ZVtfY29tcG9uZW50TmFtZV0gPSB0cnVlO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChwYXJ0aWFsU3RhdGUgIT0gbnVsbCkge1xuICAgICAgICAgIGluc3Quc3RhdGUgPSBfYXNzaWduKHt9LCBpbnN0LnN0YXRlLCBwYXJ0aWFsU3RhdGUpO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfSBlbHNlIHtcbiAgICAgIHtcbiAgICAgICAgaWYgKENvbXBvbmVudC5wcm90b3R5cGUgJiYgdHlwZW9mIENvbXBvbmVudC5wcm90b3R5cGUucmVuZGVyID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICAgICAgdmFyIF9jb21wb25lbnROYW1lMiA9IGdldENvbXBvbmVudE5hbWUoQ29tcG9uZW50KSB8fCAnVW5rbm93bic7XG5cbiAgICAgICAgICBpZiAoIWRpZFdhcm5BYm91dEJhZENsYXNzW19jb21wb25lbnROYW1lMl0pIHtcbiAgICAgICAgICAgIHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgXCJUaGUgPCVzIC8+IGNvbXBvbmVudCBhcHBlYXJzIHRvIGhhdmUgYSByZW5kZXIgbWV0aG9kLCBidXQgZG9lc24ndCBleHRlbmQgUmVhY3QuQ29tcG9uZW50LiBcIiArICdUaGlzIGlzIGxpa2VseSB0byBjYXVzZSBlcnJvcnMuIENoYW5nZSAlcyB0byBleHRlbmQgUmVhY3QuQ29tcG9uZW50IGluc3RlYWQuJywgX2NvbXBvbmVudE5hbWUyLCBfY29tcG9uZW50TmFtZTIpO1xuICAgICAgICAgICAgZGlkV2FybkFib3V0QmFkQ2xhc3NbX2NvbXBvbmVudE5hbWUyXSA9IHRydWU7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgICB2YXIgY29tcG9uZW50SWRlbnRpdHkgPSB7fTtcbiAgICAgIHByZXBhcmVUb1VzZUhvb2tzKGNvbXBvbmVudElkZW50aXR5KTtcbiAgICAgIGluc3QgPSBDb21wb25lbnQoZWxlbWVudC5wcm9wcywgcHVibGljQ29udGV4dCwgdXBkYXRlcik7XG4gICAgICBpbnN0ID0gZmluaXNoSG9va3MoQ29tcG9uZW50LCBlbGVtZW50LnByb3BzLCBpbnN0LCBwdWJsaWNDb250ZXh0KTtcblxuICAgICAgaWYgKGluc3QgPT0gbnVsbCB8fCBpbnN0LnJlbmRlciA9PSBudWxsKSB7XG4gICAgICAgIGNoaWxkID0gaW5zdDtcbiAgICAgICAgdmFsaWRhdGVSZW5kZXJSZXN1bHQoY2hpbGQsIENvbXBvbmVudCk7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICB9XG5cbiAgICBpbnN0LnByb3BzID0gZWxlbWVudC5wcm9wcztcbiAgICBpbnN0LmNvbnRleHQgPSBwdWJsaWNDb250ZXh0O1xuICAgIGluc3QudXBkYXRlciA9IHVwZGF0ZXI7XG5cbiAgICB2YXIgaW5pdGlhbFN0YXRlID0gaW5zdC5zdGF0ZTtcbiAgICBpZiAoaW5pdGlhbFN0YXRlID09PSB1bmRlZmluZWQpIHtcbiAgICAgIGluc3Quc3RhdGUgPSBpbml0aWFsU3RhdGUgPSBudWxsO1xuICAgIH1cbiAgICBpZiAodHlwZW9mIGluc3QuVU5TQUZFX2NvbXBvbmVudFdpbGxNb3VudCA9PT0gJ2Z1bmN0aW9uJyB8fCB0eXBlb2YgaW5zdC5jb21wb25lbnRXaWxsTW91bnQgPT09ICdmdW5jdGlvbicpIHtcbiAgICAgIGlmICh0eXBlb2YgaW5zdC5jb21wb25lbnRXaWxsTW91bnQgPT09ICdmdW5jdGlvbicpIHtcbiAgICAgICAge1xuICAgICAgICAgIGlmICh3YXJuQWJvdXREZXByZWNhdGVkTGlmZWN5Y2xlcyAmJiBpbnN0LmNvbXBvbmVudFdpbGxNb3VudC5fX3N1cHByZXNzRGVwcmVjYXRpb25XYXJuaW5nICE9PSB0cnVlKSB7XG4gICAgICAgICAgICB2YXIgX2NvbXBvbmVudE5hbWUzID0gZ2V0Q29tcG9uZW50TmFtZShDb21wb25lbnQpIHx8ICdVbmtub3duJztcblxuICAgICAgICAgICAgaWYgKCFkaWRXYXJuQWJvdXREZXByZWNhdGVkV2lsbE1vdW50W19jb21wb25lbnROYW1lM10pIHtcbiAgICAgICAgICAgICAgbG93UHJpb3JpdHlXYXJuaW5nJDEoZmFsc2UsICclczogY29tcG9uZW50V2lsbE1vdW50KCkgaXMgZGVwcmVjYXRlZCBhbmQgd2lsbCBiZSAnICsgJ3JlbW92ZWQgaW4gdGhlIG5leHQgbWFqb3IgdmVyc2lvbi4gUmVhZCBhYm91dCB0aGUgbW90aXZhdGlvbnMgJyArICdiZWhpbmQgdGhpcyBjaGFuZ2U6ICcgKyAnaHR0cHM6Ly9mYi5tZS9yZWFjdC1hc3luYy1jb21wb25lbnQtbGlmZWN5Y2xlLWhvb2tzJyArICdcXG5cXG4nICsgJ0FzIGEgdGVtcG9yYXJ5IHdvcmthcm91bmQsIHlvdSBjYW4gcmVuYW1lIHRvICcgKyAnVU5TQUZFX2NvbXBvbmVudFdpbGxNb3VudCBpbnN0ZWFkLicsIF9jb21wb25lbnROYW1lMyk7XG4gICAgICAgICAgICAgIGRpZFdhcm5BYm91dERlcHJlY2F0ZWRXaWxsTW91bnRbX2NvbXBvbmVudE5hbWUzXSA9IHRydWU7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgLy8gSW4gb3JkZXIgdG8gc3VwcG9ydCByZWFjdC1saWZlY3ljbGVzLWNvbXBhdCBwb2x5ZmlsbGVkIGNvbXBvbmVudHMsXG4gICAgICAgIC8vIFVuc2FmZSBsaWZlY3ljbGVzIHNob3VsZCBub3QgYmUgaW52b2tlZCBmb3IgYW55IGNvbXBvbmVudCB3aXRoIHRoZSBuZXcgZ0RTRlAuXG4gICAgICAgIGlmICh0eXBlb2YgQ29tcG9uZW50LmdldERlcml2ZWRTdGF0ZUZyb21Qcm9wcyAhPT0gJ2Z1bmN0aW9uJykge1xuICAgICAgICAgIGluc3QuY29tcG9uZW50V2lsbE1vdW50KCk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIGlmICh0eXBlb2YgaW5zdC5VTlNBRkVfY29tcG9uZW50V2lsbE1vdW50ID09PSAnZnVuY3Rpb24nICYmIHR5cGVvZiBDb21wb25lbnQuZ2V0RGVyaXZlZFN0YXRlRnJvbVByb3BzICE9PSAnZnVuY3Rpb24nKSB7XG4gICAgICAgIC8vIEluIG9yZGVyIHRvIHN1cHBvcnQgcmVhY3QtbGlmZWN5Y2xlcy1jb21wYXQgcG9seWZpbGxlZCBjb21wb25lbnRzLFxuICAgICAgICAvLyBVbnNhZmUgbGlmZWN5Y2xlcyBzaG91bGQgbm90IGJlIGludm9rZWQgZm9yIGFueSBjb21wb25lbnQgd2l0aCB0aGUgbmV3IGdEU0ZQLlxuICAgICAgICBpbnN0LlVOU0FGRV9jb21wb25lbnRXaWxsTW91bnQoKTtcbiAgICAgIH1cbiAgICAgIGlmIChxdWV1ZS5sZW5ndGgpIHtcbiAgICAgICAgdmFyIG9sZFF1ZXVlID0gcXVldWU7XG4gICAgICAgIHZhciBvbGRSZXBsYWNlID0gcmVwbGFjZTtcbiAgICAgICAgcXVldWUgPSBudWxsO1xuICAgICAgICByZXBsYWNlID0gZmFsc2U7XG5cbiAgICAgICAgaWYgKG9sZFJlcGxhY2UgJiYgb2xkUXVldWUubGVuZ3RoID09PSAxKSB7XG4gICAgICAgICAgaW5zdC5zdGF0ZSA9IG9sZFF1ZXVlWzBdO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHZhciBuZXh0U3RhdGUgPSBvbGRSZXBsYWNlID8gb2xkUXVldWVbMF0gOiBpbnN0LnN0YXRlO1xuICAgICAgICAgIHZhciBkb250TXV0YXRlID0gdHJ1ZTtcbiAgICAgICAgICBmb3IgKHZhciBpID0gb2xkUmVwbGFjZSA/IDEgOiAwOyBpIDwgb2xkUXVldWUubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgICAgIHZhciBwYXJ0aWFsID0gb2xkUXVldWVbaV07XG4gICAgICAgICAgICB2YXIgX3BhcnRpYWxTdGF0ZSA9IHR5cGVvZiBwYXJ0aWFsID09PSAnZnVuY3Rpb24nID8gcGFydGlhbC5jYWxsKGluc3QsIG5leHRTdGF0ZSwgZWxlbWVudC5wcm9wcywgcHVibGljQ29udGV4dCkgOiBwYXJ0aWFsO1xuICAgICAgICAgICAgaWYgKF9wYXJ0aWFsU3RhdGUgIT0gbnVsbCkge1xuICAgICAgICAgICAgICBpZiAoZG9udE11dGF0ZSkge1xuICAgICAgICAgICAgICAgIGRvbnRNdXRhdGUgPSBmYWxzZTtcbiAgICAgICAgICAgICAgICBuZXh0U3RhdGUgPSBfYXNzaWduKHt9LCBuZXh0U3RhdGUsIF9wYXJ0aWFsU3RhdGUpO1xuICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIF9hc3NpZ24obmV4dFN0YXRlLCBfcGFydGlhbFN0YXRlKTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgICBpbnN0LnN0YXRlID0gbmV4dFN0YXRlO1xuICAgICAgICB9XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBxdWV1ZSA9IG51bGw7XG4gICAgICB9XG4gICAgfVxuICAgIGNoaWxkID0gaW5zdC5yZW5kZXIoKTtcblxuICAgIHtcbiAgICAgIGlmIChjaGlsZCA9PT0gdW5kZWZpbmVkICYmIGluc3QucmVuZGVyLl9pc01vY2tGdW5jdGlvbikge1xuICAgICAgICAvLyBUaGlzIGlzIHByb2JhYmx5IGJhZCBwcmFjdGljZS4gQ29uc2lkZXIgd2FybmluZyBoZXJlIGFuZFxuICAgICAgICAvLyBkZXByZWNhdGluZyB0aGlzIGNvbnZlbmllbmNlLlxuICAgICAgICBjaGlsZCA9IG51bGw7XG4gICAgICB9XG4gICAgfVxuICAgIHZhbGlkYXRlUmVuZGVyUmVzdWx0KGNoaWxkLCBDb21wb25lbnQpO1xuXG4gICAgdmFyIGNoaWxkQ29udGV4dCA9IHZvaWQgMDtcbiAgICBpZiAodHlwZW9mIGluc3QuZ2V0Q2hpbGRDb250ZXh0ID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICB2YXIgY2hpbGRDb250ZXh0VHlwZXMgPSBDb21wb25lbnQuY2hpbGRDb250ZXh0VHlwZXM7XG4gICAgICBpZiAodHlwZW9mIGNoaWxkQ29udGV4dFR5cGVzID09PSAnb2JqZWN0Jykge1xuICAgICAgICBjaGlsZENvbnRleHQgPSBpbnN0LmdldENoaWxkQ29udGV4dCgpO1xuICAgICAgICBmb3IgKHZhciBjb250ZXh0S2V5IGluIGNoaWxkQ29udGV4dCkge1xuICAgICAgICAgICEoY29udGV4dEtleSBpbiBjaGlsZENvbnRleHRUeXBlcykgPyBpbnZhcmlhbnQoZmFsc2UsICclcy5nZXRDaGlsZENvbnRleHQoKToga2V5IFwiJXNcIiBpcyBub3QgZGVmaW5lZCBpbiBjaGlsZENvbnRleHRUeXBlcy4nLCBnZXRDb21wb25lbnROYW1lKENvbXBvbmVudCkgfHwgJ1Vua25vd24nLCBjb250ZXh0S2V5KSA6IHZvaWQgMDtcbiAgICAgICAgfVxuICAgICAgfSBlbHNlIHtcbiAgICAgICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnJXMuZ2V0Q2hpbGRDb250ZXh0KCk6IGNoaWxkQ29udGV4dFR5cGVzIG11c3QgYmUgZGVmaW5lZCBpbiBvcmRlciB0byAnICsgJ3VzZSBnZXRDaGlsZENvbnRleHQoKS4nLCBnZXRDb21wb25lbnROYW1lKENvbXBvbmVudCkgfHwgJ1Vua25vd24nKTtcbiAgICAgIH1cbiAgICB9XG4gICAgaWYgKGNoaWxkQ29udGV4dCkge1xuICAgICAgY29udGV4dCA9IF9hc3NpZ24oe30sIGNvbnRleHQsIGNoaWxkQ29udGV4dCk7XG4gICAgfVxuICB9XG4gIHJldHVybiB7IGNoaWxkOiBjaGlsZCwgY29udGV4dDogY29udGV4dCB9O1xufVxuXG52YXIgUmVhY3RET01TZXJ2ZXJSZW5kZXJlciA9IGZ1bmN0aW9uICgpIHtcbiAgLy8gREVWLW9ubHlcblxuICAvLyBUT0RPOiB0eXBlIHRoaXMgbW9yZSBzdHJpY3RseTpcbiAgZnVuY3Rpb24gUmVhY3RET01TZXJ2ZXJSZW5kZXJlcihjaGlsZHJlbiwgbWFrZVN0YXRpY01hcmt1cCkge1xuICAgIF9jbGFzc0NhbGxDaGVjayh0aGlzLCBSZWFjdERPTVNlcnZlclJlbmRlcmVyKTtcblxuICAgIHZhciBmbGF0Q2hpbGRyZW4gPSBmbGF0dGVuVG9wTGV2ZWxDaGlsZHJlbihjaGlsZHJlbik7XG5cbiAgICB2YXIgdG9wRnJhbWUgPSB7XG4gICAgICB0eXBlOiBudWxsLFxuICAgICAgLy8gQXNzdW1lIGFsbCB0cmVlcyBzdGFydCBpbiB0aGUgSFRNTCBuYW1lc3BhY2UgKG5vdCB0b3RhbGx5IHRydWUsIGJ1dFxuICAgICAgLy8gdGhpcyBpcyB3aGF0IHdlIGRpZCBoaXN0b3JpY2FsbHkpXG4gICAgICBkb21OYW1lc3BhY2U6IE5hbWVzcGFjZXMuaHRtbCxcbiAgICAgIGNoaWxkcmVuOiBmbGF0Q2hpbGRyZW4sXG4gICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgY29udGV4dDogZW1wdHlPYmplY3QsXG4gICAgICBmb290ZXI6ICcnXG4gICAgfTtcbiAgICB7XG4gICAgICB0b3BGcmFtZS5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgIH1cbiAgICB0aGlzLnRocmVhZElEID0gYWxsb2NUaHJlYWRJRCgpO1xuICAgIHRoaXMuc3RhY2sgPSBbdG9wRnJhbWVdO1xuICAgIHRoaXMuZXhoYXVzdGVkID0gZmFsc2U7XG4gICAgdGhpcy5jdXJyZW50U2VsZWN0VmFsdWUgPSBudWxsO1xuICAgIHRoaXMucHJldmlvdXNXYXNUZXh0Tm9kZSA9IGZhbHNlO1xuICAgIHRoaXMubWFrZVN0YXRpY01hcmt1cCA9IG1ha2VTdGF0aWNNYXJrdXA7XG4gICAgdGhpcy5zdXNwZW5zZURlcHRoID0gMDtcblxuICAgIC8vIENvbnRleHQgKG5ldyBBUEkpXG4gICAgdGhpcy5jb250ZXh0SW5kZXggPSAtMTtcbiAgICB0aGlzLmNvbnRleHRTdGFjayA9IFtdO1xuICAgIHRoaXMuY29udGV4dFZhbHVlU3RhY2sgPSBbXTtcbiAgICB7XG4gICAgICB0aGlzLmNvbnRleHRQcm92aWRlclN0YWNrID0gW107XG4gICAgfVxuICB9XG5cbiAgUmVhY3RET01TZXJ2ZXJSZW5kZXJlci5wcm90b3R5cGUuZGVzdHJveSA9IGZ1bmN0aW9uIGRlc3Ryb3koKSB7XG4gICAgaWYgKCF0aGlzLmV4aGF1c3RlZCkge1xuICAgICAgdGhpcy5leGhhdXN0ZWQgPSB0cnVlO1xuICAgICAgZnJlZVRocmVhZElEKHRoaXMudGhyZWFkSUQpO1xuICAgIH1cbiAgfTtcblxuICAvKipcbiAgICogTm90ZTogV2UgdXNlIGp1c3QgdHdvIHN0YWNrcyByZWdhcmRsZXNzIG9mIGhvdyBtYW55IGNvbnRleHQgcHJvdmlkZXJzIHlvdSBoYXZlLlxuICAgKiBQcm92aWRlcnMgYXJlIGFsd2F5cyBwb3BwZWQgaW4gdGhlIHJldmVyc2Ugb3JkZXIgdG8gaG93IHRoZXkgd2VyZSBwdXNoZWRcbiAgICogc28gd2UgYWx3YXlzIGtub3cgb24gdGhlIHdheSBkb3duIHdoaWNoIHByb3ZpZGVyIHlvdSdsbCBlbmNvdW50ZXIgbmV4dCBvbiB0aGUgd2F5IHVwLlxuICAgKiBPbiB0aGUgd2F5IGRvd24sIHdlIHB1c2ggdGhlIGN1cnJlbnQgcHJvdmlkZXIsIGFuZCBpdHMgY29udGV4dCB2YWx1ZSAqYmVmb3JlKlxuICAgKiB3ZSBtdXRhdGVkIGl0LCBvbnRvIHRoZSBzdGFja3MuIFRoZXJlZm9yZSwgb24gdGhlIHdheSB1cCwgd2UgYWx3YXlzIGtub3cgd2hpY2hcbiAgICogcHJvdmlkZXIgbmVlZHMgdG8gYmUgXCJyZXN0b3JlZFwiIHRvIHdoaWNoIHZhbHVlLlxuICAgKiBodHRwczovL2dpdGh1Yi5jb20vZmFjZWJvb2svcmVhY3QvcHVsbC8xMjk4NSNpc3N1ZWNvbW1lbnQtMzk2MzAxMjQ4XG4gICAqL1xuXG4gIFJlYWN0RE9NU2VydmVyUmVuZGVyZXIucHJvdG90eXBlLnB1c2hQcm92aWRlciA9IGZ1bmN0aW9uIHB1c2hQcm92aWRlcihwcm92aWRlcikge1xuICAgIHZhciBpbmRleCA9ICsrdGhpcy5jb250ZXh0SW5kZXg7XG4gICAgdmFyIGNvbnRleHQgPSBwcm92aWRlci50eXBlLl9jb250ZXh0O1xuICAgIHZhciB0aHJlYWRJRCA9IHRoaXMudGhyZWFkSUQ7XG4gICAgdmFsaWRhdGVDb250ZXh0Qm91bmRzKGNvbnRleHQsIHRocmVhZElEKTtcbiAgICB2YXIgcHJldmlvdXNWYWx1ZSA9IGNvbnRleHRbdGhyZWFkSURdO1xuXG4gICAgLy8gUmVtZW1iZXIgd2hpY2ggdmFsdWUgdG8gcmVzdG9yZSB0aGlzIGNvbnRleHQgdG8gb24gb3VyIHdheSB1cC5cbiAgICB0aGlzLmNvbnRleHRTdGFja1tpbmRleF0gPSBjb250ZXh0O1xuICAgIHRoaXMuY29udGV4dFZhbHVlU3RhY2tbaW5kZXhdID0gcHJldmlvdXNWYWx1ZTtcbiAgICB7XG4gICAgICAvLyBPbmx5IHVzZWQgZm9yIHB1c2gvcG9wIG1pc21hdGNoIHdhcm5pbmdzLlxuICAgICAgdGhpcy5jb250ZXh0UHJvdmlkZXJTdGFja1tpbmRleF0gPSBwcm92aWRlcjtcbiAgICB9XG5cbiAgICAvLyBNdXRhdGUgdGhlIGN1cnJlbnQgdmFsdWUuXG4gICAgY29udGV4dFt0aHJlYWRJRF0gPSBwcm92aWRlci5wcm9wcy52YWx1ZTtcbiAgfTtcblxuICBSZWFjdERPTVNlcnZlclJlbmRlcmVyLnByb3RvdHlwZS5wb3BQcm92aWRlciA9IGZ1bmN0aW9uIHBvcFByb3ZpZGVyKHByb3ZpZGVyKSB7XG4gICAgdmFyIGluZGV4ID0gdGhpcy5jb250ZXh0SW5kZXg7XG4gICAge1xuICAgICAgIShpbmRleCA+IC0xICYmIHByb3ZpZGVyID09PSB0aGlzLmNvbnRleHRQcm92aWRlclN0YWNrW2luZGV4XSkgPyB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdVbmV4cGVjdGVkIHBvcC4nKSA6IHZvaWQgMDtcbiAgICB9XG5cbiAgICB2YXIgY29udGV4dCA9IHRoaXMuY29udGV4dFN0YWNrW2luZGV4XTtcbiAgICB2YXIgcHJldmlvdXNWYWx1ZSA9IHRoaXMuY29udGV4dFZhbHVlU3RhY2tbaW5kZXhdO1xuXG4gICAgLy8gXCJIaWRlXCIgdGhlc2UgbnVsbCBhc3NpZ25tZW50cyBmcm9tIEZsb3cgYnkgdXNpbmcgYGFueWBcbiAgICAvLyBiZWNhdXNlIGNvbmNlcHR1YWxseSB0aGV5IGFyZSBkZWxldGlvbnMtLWFzIGxvbmcgYXMgd2VcbiAgICAvLyBwcm9taXNlIHRvIG5ldmVyIGFjY2VzcyB2YWx1ZXMgYmV5b25kIGB0aGlzLmNvbnRleHRJbmRleGAuXG4gICAgdGhpcy5jb250ZXh0U3RhY2tbaW5kZXhdID0gbnVsbDtcbiAgICB0aGlzLmNvbnRleHRWYWx1ZVN0YWNrW2luZGV4XSA9IG51bGw7XG4gICAge1xuICAgICAgdGhpcy5jb250ZXh0UHJvdmlkZXJTdGFja1tpbmRleF0gPSBudWxsO1xuICAgIH1cbiAgICB0aGlzLmNvbnRleHRJbmRleC0tO1xuXG4gICAgLy8gUmVzdG9yZSB0byB0aGUgcHJldmlvdXMgdmFsdWUgd2Ugc3RvcmVkIGFzIHdlIHdlcmUgd2Fsa2luZyBkb3duLlxuICAgIC8vIFdlJ3ZlIGFscmVhZHkgdmVyaWZpZWQgdGhhdCB0aGlzIGNvbnRleHQgaGFzIGJlZW4gZXhwYW5kZWQgdG8gYWNjb21tb2RhdGVcbiAgICAvLyB0aGlzIHRocmVhZCBpZCwgc28gd2UgZG9uJ3QgbmVlZCB0byBkbyBpdCBhZ2Fpbi5cbiAgICBjb250ZXh0W3RoaXMudGhyZWFkSURdID0gcHJldmlvdXNWYWx1ZTtcbiAgfTtcblxuICBSZWFjdERPTVNlcnZlclJlbmRlcmVyLnByb3RvdHlwZS5yZWFkID0gZnVuY3Rpb24gcmVhZChieXRlcykge1xuICAgIGlmICh0aGlzLmV4aGF1c3RlZCkge1xuICAgICAgcmV0dXJuIG51bGw7XG4gICAgfVxuXG4gICAgdmFyIHByZXZUaHJlYWRJRCA9IGN1cnJlbnRUaHJlYWRJRDtcbiAgICBzZXRDdXJyZW50VGhyZWFkSUQodGhpcy50aHJlYWRJRCk7XG4gICAgdmFyIHByZXZEaXNwYXRjaGVyID0gUmVhY3RDdXJyZW50RGlzcGF0Y2hlci5jdXJyZW50O1xuICAgIFJlYWN0Q3VycmVudERpc3BhdGNoZXIuY3VycmVudCA9IERpc3BhdGNoZXI7XG4gICAgdHJ5IHtcbiAgICAgIC8vIE1hcmt1cCBnZW5lcmF0ZWQgd2l0aGluIDxTdXNwZW5zZT4gZW5kcyB1cCBidWZmZXJlZCB1bnRpbCB3ZSBrbm93XG4gICAgICAvLyBub3RoaW5nIGluIHRoYXQgYm91bmRhcnkgc3VzcGVuZGVkXG4gICAgICB2YXIgb3V0ID0gWycnXTtcbiAgICAgIHZhciBzdXNwZW5kZWQgPSBmYWxzZTtcbiAgICAgIHdoaWxlIChvdXRbMF0ubGVuZ3RoIDwgYnl0ZXMpIHtcbiAgICAgICAgaWYgKHRoaXMuc3RhY2subGVuZ3RoID09PSAwKSB7XG4gICAgICAgICAgdGhpcy5leGhhdXN0ZWQgPSB0cnVlO1xuICAgICAgICAgIGZyZWVUaHJlYWRJRCh0aGlzLnRocmVhZElEKTtcbiAgICAgICAgICBicmVhaztcbiAgICAgICAgfVxuICAgICAgICB2YXIgZnJhbWUgPSB0aGlzLnN0YWNrW3RoaXMuc3RhY2subGVuZ3RoIC0gMV07XG4gICAgICAgIGlmIChzdXNwZW5kZWQgfHwgZnJhbWUuY2hpbGRJbmRleCA+PSBmcmFtZS5jaGlsZHJlbi5sZW5ndGgpIHtcbiAgICAgICAgICB2YXIgX2Zvb3RlciA9IGZyYW1lLmZvb3RlcjtcbiAgICAgICAgICBpZiAoX2Zvb3RlciAhPT0gJycpIHtcbiAgICAgICAgICAgIHRoaXMucHJldmlvdXNXYXNUZXh0Tm9kZSA9IGZhbHNlO1xuICAgICAgICAgIH1cbiAgICAgICAgICB0aGlzLnN0YWNrLnBvcCgpO1xuICAgICAgICAgIGlmIChmcmFtZS50eXBlID09PSAnc2VsZWN0Jykge1xuICAgICAgICAgICAgdGhpcy5jdXJyZW50U2VsZWN0VmFsdWUgPSBudWxsO1xuICAgICAgICAgIH0gZWxzZSBpZiAoZnJhbWUudHlwZSAhPSBudWxsICYmIGZyYW1lLnR5cGUudHlwZSAhPSBudWxsICYmIGZyYW1lLnR5cGUudHlwZS4kJHR5cGVvZiA9PT0gUkVBQ1RfUFJPVklERVJfVFlQRSkge1xuICAgICAgICAgICAgdmFyIHByb3ZpZGVyID0gZnJhbWUudHlwZTtcbiAgICAgICAgICAgIHRoaXMucG9wUHJvdmlkZXIocHJvdmlkZXIpO1xuICAgICAgICAgIH0gZWxzZSBpZiAoZnJhbWUudHlwZSA9PT0gUkVBQ1RfU1VTUEVOU0VfVFlQRSkge1xuICAgICAgICAgICAgdGhpcy5zdXNwZW5zZURlcHRoLS07XG4gICAgICAgICAgICB2YXIgYnVmZmVyZWQgPSBvdXQucG9wKCk7XG5cbiAgICAgICAgICAgIGlmIChzdXNwZW5kZWQpIHtcbiAgICAgICAgICAgICAgc3VzcGVuZGVkID0gZmFsc2U7XG4gICAgICAgICAgICAgIC8vIElmIHJlbmRlcmluZyB3YXMgc3VzcGVuZGVkIGF0IHRoaXMgYm91bmRhcnksIHJlbmRlciB0aGUgZmFsbGJhY2tGcmFtZVxuICAgICAgICAgICAgICB2YXIgX2ZhbGxiYWNrRnJhbWUgPSBmcmFtZS5mYWxsYmFja0ZyYW1lO1xuICAgICAgICAgICAgICAhX2ZhbGxiYWNrRnJhbWUgPyBpbnZhcmlhbnQoZmFsc2UsICdzdXNwZW5zZSBmYWxsYmFjayBub3QgZm91bmQsIHNvbWV0aGluZyBpcyBicm9rZW4nKSA6IHZvaWQgMDtcbiAgICAgICAgICAgICAgdGhpcy5zdGFjay5wdXNoKF9mYWxsYmFja0ZyYW1lKTtcbiAgICAgICAgICAgICAgLy8gU2tpcCBmbHVzaGluZyBvdXRwdXQgc2luY2Ugd2UncmUgc3dpdGNoaW5nIHRvIHRoZSBmYWxsYmFja1xuICAgICAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIG91dFt0aGlzLnN1c3BlbnNlRGVwdGhdICs9IGJ1ZmZlcmVkO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cblxuICAgICAgICAgIC8vIEZsdXNoIG91dHB1dFxuICAgICAgICAgIG91dFt0aGlzLnN1c3BlbnNlRGVwdGhdICs9IF9mb290ZXI7XG4gICAgICAgICAgY29udGludWU7XG4gICAgICAgIH1cbiAgICAgICAgdmFyIGNoaWxkID0gZnJhbWUuY2hpbGRyZW5bZnJhbWUuY2hpbGRJbmRleCsrXTtcblxuICAgICAgICB2YXIgb3V0QnVmZmVyID0gJyc7XG4gICAgICAgIHtcbiAgICAgICAgICBwdXNoQ3VycmVudERlYnVnU3RhY2sodGhpcy5zdGFjayk7XG4gICAgICAgICAgLy8gV2UncmUgc3RhcnRpbmcgd29yayBvbiB0aGlzIGZyYW1lLCBzbyByZXNldCBpdHMgaW5uZXIgc3RhY2suXG4gICAgICAgICAgZnJhbWUuZGVidWdFbGVtZW50U3RhY2subGVuZ3RoID0gMDtcbiAgICAgICAgfVxuICAgICAgICB0cnkge1xuICAgICAgICAgIG91dEJ1ZmZlciArPSB0aGlzLnJlbmRlcihjaGlsZCwgZnJhbWUuY29udGV4dCwgZnJhbWUuZG9tTmFtZXNwYWNlKTtcbiAgICAgICAgfSBjYXRjaCAoZXJyKSB7XG4gICAgICAgICAgaWYgKGVuYWJsZVN1c3BlbnNlU2VydmVyUmVuZGVyZXIgJiYgdHlwZW9mIGVyci50aGVuID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICAgICAgICBzdXNwZW5kZWQgPSB0cnVlO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICB0aHJvdyBlcnI7XG4gICAgICAgICAgfVxuICAgICAgICB9IGZpbmFsbHkge1xuICAgICAgICAgIHtcbiAgICAgICAgICAgIHBvcEN1cnJlbnREZWJ1Z1N0YWNrKCk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIGlmIChvdXQubGVuZ3RoIDw9IHRoaXMuc3VzcGVuc2VEZXB0aCkge1xuICAgICAgICAgIG91dC5wdXNoKCcnKTtcbiAgICAgICAgfVxuICAgICAgICBvdXRbdGhpcy5zdXNwZW5zZURlcHRoXSArPSBvdXRCdWZmZXI7XG4gICAgICB9XG4gICAgICByZXR1cm4gb3V0WzBdO1xuICAgIH0gZmluYWxseSB7XG4gICAgICBSZWFjdEN1cnJlbnREaXNwYXRjaGVyLmN1cnJlbnQgPSBwcmV2RGlzcGF0Y2hlcjtcbiAgICAgIHNldEN1cnJlbnRUaHJlYWRJRChwcmV2VGhyZWFkSUQpO1xuICAgIH1cbiAgfTtcblxuICBSZWFjdERPTVNlcnZlclJlbmRlcmVyLnByb3RvdHlwZS5yZW5kZXIgPSBmdW5jdGlvbiByZW5kZXIoY2hpbGQsIGNvbnRleHQsIHBhcmVudE5hbWVzcGFjZSkge1xuICAgIGlmICh0eXBlb2YgY2hpbGQgPT09ICdzdHJpbmcnIHx8IHR5cGVvZiBjaGlsZCA9PT0gJ251bWJlcicpIHtcbiAgICAgIHZhciB0ZXh0ID0gJycgKyBjaGlsZDtcbiAgICAgIGlmICh0ZXh0ID09PSAnJykge1xuICAgICAgICByZXR1cm4gJyc7XG4gICAgICB9XG4gICAgICBpZiAodGhpcy5tYWtlU3RhdGljTWFya3VwKSB7XG4gICAgICAgIHJldHVybiBlc2NhcGVUZXh0Rm9yQnJvd3Nlcih0ZXh0KTtcbiAgICAgIH1cbiAgICAgIGlmICh0aGlzLnByZXZpb3VzV2FzVGV4dE5vZGUpIHtcbiAgICAgICAgcmV0dXJuICc8IS0tIC0tPicgKyBlc2NhcGVUZXh0Rm9yQnJvd3Nlcih0ZXh0KTtcbiAgICAgIH1cbiAgICAgIHRoaXMucHJldmlvdXNXYXNUZXh0Tm9kZSA9IHRydWU7XG4gICAgICByZXR1cm4gZXNjYXBlVGV4dEZvckJyb3dzZXIodGV4dCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHZhciBuZXh0Q2hpbGQgPSB2b2lkIDA7XG5cbiAgICAgIHZhciBfcmVzb2x2ZSA9IHJlc29sdmUoY2hpbGQsIGNvbnRleHQsIHRoaXMudGhyZWFkSUQpO1xuXG4gICAgICBuZXh0Q2hpbGQgPSBfcmVzb2x2ZS5jaGlsZDtcbiAgICAgIGNvbnRleHQgPSBfcmVzb2x2ZS5jb250ZXh0O1xuXG4gICAgICBpZiAobmV4dENoaWxkID09PSBudWxsIHx8IG5leHRDaGlsZCA9PT0gZmFsc2UpIHtcbiAgICAgICAgcmV0dXJuICcnO1xuICAgICAgfSBlbHNlIGlmICghUmVhY3QuaXNWYWxpZEVsZW1lbnQobmV4dENoaWxkKSkge1xuICAgICAgICBpZiAobmV4dENoaWxkICE9IG51bGwgJiYgbmV4dENoaWxkLiQkdHlwZW9mICE9IG51bGwpIHtcbiAgICAgICAgICAvLyBDYXRjaCB1bmV4cGVjdGVkIHNwZWNpYWwgdHlwZXMgZWFybHkuXG4gICAgICAgICAgdmFyICQkdHlwZW9mID0gbmV4dENoaWxkLiQkdHlwZW9mO1xuICAgICAgICAgICEoJCR0eXBlb2YgIT09IFJFQUNUX1BPUlRBTF9UWVBFKSA/IGludmFyaWFudChmYWxzZSwgJ1BvcnRhbHMgYXJlIG5vdCBjdXJyZW50bHkgc3VwcG9ydGVkIGJ5IHRoZSBzZXJ2ZXIgcmVuZGVyZXIuIFJlbmRlciB0aGVtIGNvbmRpdGlvbmFsbHkgc28gdGhhdCB0aGV5IG9ubHkgYXBwZWFyIG9uIHRoZSBjbGllbnQgcmVuZGVyLicpIDogdm9pZCAwO1xuICAgICAgICAgIC8vIENhdGNoLWFsbCB0byBwcmV2ZW50IGFuIGluZmluaXRlIGxvb3AgaWYgUmVhY3QuQ2hpbGRyZW4udG9BcnJheSgpIHN1cHBvcnRzIHNvbWUgbmV3IHR5cGUuXG4gICAgICAgICAgaW52YXJpYW50KGZhbHNlLCAnVW5rbm93biBlbGVtZW50LWxpa2Ugb2JqZWN0IHR5cGU6ICVzLiBUaGlzIGlzIGxpa2VseSBhIGJ1ZyBpbiBSZWFjdC4gUGxlYXNlIGZpbGUgYW4gaXNzdWUuJywgJCR0eXBlb2YudG9TdHJpbmcoKSk7XG4gICAgICAgIH1cbiAgICAgICAgdmFyIG5leHRDaGlsZHJlbiA9IHRvQXJyYXkobmV4dENoaWxkKTtcbiAgICAgICAgdmFyIGZyYW1lID0ge1xuICAgICAgICAgIHR5cGU6IG51bGwsXG4gICAgICAgICAgZG9tTmFtZXNwYWNlOiBwYXJlbnROYW1lc3BhY2UsXG4gICAgICAgICAgY2hpbGRyZW46IG5leHRDaGlsZHJlbixcbiAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgZm9vdGVyOiAnJ1xuICAgICAgICB9O1xuICAgICAgICB7XG4gICAgICAgICAgZnJhbWUuZGVidWdFbGVtZW50U3RhY2sgPSBbXTtcbiAgICAgICAgfVxuICAgICAgICB0aGlzLnN0YWNrLnB1c2goZnJhbWUpO1xuICAgICAgICByZXR1cm4gJyc7XG4gICAgICB9XG4gICAgICAvLyBTYWZlIGJlY2F1c2Ugd2UganVzdCBjaGVja2VkIGl0J3MgYW4gZWxlbWVudC5cbiAgICAgIHZhciBuZXh0RWxlbWVudCA9IG5leHRDaGlsZDtcbiAgICAgIHZhciBlbGVtZW50VHlwZSA9IG5leHRFbGVtZW50LnR5cGU7XG5cbiAgICAgIGlmICh0eXBlb2YgZWxlbWVudFR5cGUgPT09ICdzdHJpbmcnKSB7XG4gICAgICAgIHJldHVybiB0aGlzLnJlbmRlckRPTShuZXh0RWxlbWVudCwgY29udGV4dCwgcGFyZW50TmFtZXNwYWNlKTtcbiAgICAgIH1cblxuICAgICAgc3dpdGNoIChlbGVtZW50VHlwZSkge1xuICAgICAgICBjYXNlIFJFQUNUX1NUUklDVF9NT0RFX1RZUEU6XG4gICAgICAgIGNhc2UgUkVBQ1RfQ09OQ1VSUkVOVF9NT0RFX1RZUEU6XG4gICAgICAgIGNhc2UgUkVBQ1RfUFJPRklMRVJfVFlQRTpcbiAgICAgICAgY2FzZSBSRUFDVF9GUkFHTUVOVF9UWVBFOlxuICAgICAgICAgIHtcbiAgICAgICAgICAgIHZhciBfbmV4dENoaWxkcmVuID0gdG9BcnJheShuZXh0Q2hpbGQucHJvcHMuY2hpbGRyZW4pO1xuICAgICAgICAgICAgdmFyIF9mcmFtZSA9IHtcbiAgICAgICAgICAgICAgdHlwZTogbnVsbCxcbiAgICAgICAgICAgICAgZG9tTmFtZXNwYWNlOiBwYXJlbnROYW1lc3BhY2UsXG4gICAgICAgICAgICAgIGNoaWxkcmVuOiBfbmV4dENoaWxkcmVuLFxuICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICBjb250ZXh0OiBjb250ZXh0LFxuICAgICAgICAgICAgICBmb290ZXI6ICcnXG4gICAgICAgICAgICB9O1xuICAgICAgICAgICAge1xuICAgICAgICAgICAgICBfZnJhbWUuZGVidWdFbGVtZW50U3RhY2sgPSBbXTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHRoaXMuc3RhY2sucHVzaChfZnJhbWUpO1xuICAgICAgICAgICAgcmV0dXJuICcnO1xuICAgICAgICAgIH1cbiAgICAgICAgY2FzZSBSRUFDVF9TVVNQRU5TRV9UWVBFOlxuICAgICAgICAgIHtcbiAgICAgICAgICAgIGlmIChlbmFibGVTdXNwZW5zZVNlcnZlclJlbmRlcmVyKSB7XG4gICAgICAgICAgICAgIHZhciBmYWxsYmFja0NoaWxkcmVuID0gdG9BcnJheShuZXh0Q2hpbGQucHJvcHMuZmFsbGJhY2spO1xuICAgICAgICAgICAgICB2YXIgX25leHRDaGlsZHJlbjIgPSB0b0FycmF5KG5leHRDaGlsZC5wcm9wcy5jaGlsZHJlbik7XG4gICAgICAgICAgICAgIHZhciBfZmFsbGJhY2tGcmFtZTIgPSB7XG4gICAgICAgICAgICAgICAgdHlwZTogbnVsbCxcbiAgICAgICAgICAgICAgICBkb21OYW1lc3BhY2U6IHBhcmVudE5hbWVzcGFjZSxcbiAgICAgICAgICAgICAgICBjaGlsZHJlbjogZmFsbGJhY2tDaGlsZHJlbixcbiAgICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgICAgICAgZm9vdGVyOiAnJyxcbiAgICAgICAgICAgICAgICBvdXQ6ICcnXG4gICAgICAgICAgICAgIH07XG4gICAgICAgICAgICAgIHZhciBfZnJhbWUyID0ge1xuICAgICAgICAgICAgICAgIGZhbGxiYWNrRnJhbWU6IF9mYWxsYmFja0ZyYW1lMixcbiAgICAgICAgICAgICAgICB0eXBlOiBSRUFDVF9TVVNQRU5TRV9UWVBFLFxuICAgICAgICAgICAgICAgIGRvbU5hbWVzcGFjZTogcGFyZW50TmFtZXNwYWNlLFxuICAgICAgICAgICAgICAgIGNoaWxkcmVuOiBfbmV4dENoaWxkcmVuMixcbiAgICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgICAgICAgZm9vdGVyOiAnJ1xuICAgICAgICAgICAgICB9O1xuICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgX2ZyYW1lMi5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgICAgICAgICAgICAgIF9mYWxsYmFja0ZyYW1lMi5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIHRoaXMuc3RhY2sucHVzaChfZnJhbWUyKTtcbiAgICAgICAgICAgICAgdGhpcy5zdXNwZW5zZURlcHRoKys7XG4gICAgICAgICAgICAgIHJldHVybiAnJztcbiAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgIGludmFyaWFudChmYWxzZSwgJ1JlYWN0RE9NU2VydmVyIGRvZXMgbm90IHlldCBzdXBwb3J0IFN1c3BlbnNlLicpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lLW5vLWZhbGx0aHJvdWdoXG4gICAgICAgIGRlZmF1bHQ6XG4gICAgICAgICAgYnJlYWs7XG4gICAgICB9XG4gICAgICBpZiAodHlwZW9mIGVsZW1lbnRUeXBlID09PSAnb2JqZWN0JyAmJiBlbGVtZW50VHlwZSAhPT0gbnVsbCkge1xuICAgICAgICBzd2l0Y2ggKGVsZW1lbnRUeXBlLiQkdHlwZW9mKSB7XG4gICAgICAgICAgY2FzZSBSRUFDVF9GT1JXQVJEX1JFRl9UWVBFOlxuICAgICAgICAgICAge1xuICAgICAgICAgICAgICB2YXIgZWxlbWVudCA9IG5leHRDaGlsZDtcbiAgICAgICAgICAgICAgdmFyIF9uZXh0Q2hpbGRyZW4zID0gdm9pZCAwO1xuICAgICAgICAgICAgICB2YXIgY29tcG9uZW50SWRlbnRpdHkgPSB7fTtcbiAgICAgICAgICAgICAgcHJlcGFyZVRvVXNlSG9va3MoY29tcG9uZW50SWRlbnRpdHkpO1xuICAgICAgICAgICAgICBfbmV4dENoaWxkcmVuMyA9IGVsZW1lbnRUeXBlLnJlbmRlcihlbGVtZW50LnByb3BzLCBlbGVtZW50LnJlZik7XG4gICAgICAgICAgICAgIF9uZXh0Q2hpbGRyZW4zID0gZmluaXNoSG9va3MoZWxlbWVudFR5cGUucmVuZGVyLCBlbGVtZW50LnByb3BzLCBfbmV4dENoaWxkcmVuMywgZWxlbWVudC5yZWYpO1xuICAgICAgICAgICAgICBfbmV4dENoaWxkcmVuMyA9IHRvQXJyYXkoX25leHRDaGlsZHJlbjMpO1xuICAgICAgICAgICAgICB2YXIgX2ZyYW1lMyA9IHtcbiAgICAgICAgICAgICAgICB0eXBlOiBudWxsLFxuICAgICAgICAgICAgICAgIGRvbU5hbWVzcGFjZTogcGFyZW50TmFtZXNwYWNlLFxuICAgICAgICAgICAgICAgIGNoaWxkcmVuOiBfbmV4dENoaWxkcmVuMyxcbiAgICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgICAgICAgZm9vdGVyOiAnJ1xuICAgICAgICAgICAgICB9O1xuICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgX2ZyYW1lMy5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIHRoaXMuc3RhY2sucHVzaChfZnJhbWUzKTtcbiAgICAgICAgICAgICAgcmV0dXJuICcnO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIGNhc2UgUkVBQ1RfTUVNT19UWVBFOlxuICAgICAgICAgICAge1xuICAgICAgICAgICAgICB2YXIgX2VsZW1lbnQgPSBuZXh0Q2hpbGQ7XG4gICAgICAgICAgICAgIHZhciBfbmV4dENoaWxkcmVuNCA9IFtSZWFjdC5jcmVhdGVFbGVtZW50KGVsZW1lbnRUeXBlLnR5cGUsIF9hc3NpZ24oeyByZWY6IF9lbGVtZW50LnJlZiB9LCBfZWxlbWVudC5wcm9wcykpXTtcbiAgICAgICAgICAgICAgdmFyIF9mcmFtZTQgPSB7XG4gICAgICAgICAgICAgICAgdHlwZTogbnVsbCxcbiAgICAgICAgICAgICAgICBkb21OYW1lc3BhY2U6IHBhcmVudE5hbWVzcGFjZSxcbiAgICAgICAgICAgICAgICBjaGlsZHJlbjogX25leHRDaGlsZHJlbjQsXG4gICAgICAgICAgICAgICAgY2hpbGRJbmRleDogMCxcbiAgICAgICAgICAgICAgICBjb250ZXh0OiBjb250ZXh0LFxuICAgICAgICAgICAgICAgIGZvb3RlcjogJydcbiAgICAgICAgICAgICAgfTtcbiAgICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgIF9mcmFtZTQuZGVidWdFbGVtZW50U3RhY2sgPSBbXTtcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB0aGlzLnN0YWNrLnB1c2goX2ZyYW1lNCk7XG4gICAgICAgICAgICAgIHJldHVybiAnJztcbiAgICAgICAgICAgIH1cbiAgICAgICAgICBjYXNlIFJFQUNUX1BST1ZJREVSX1RZUEU6XG4gICAgICAgICAgICB7XG4gICAgICAgICAgICAgIHZhciBwcm92aWRlciA9IG5leHRDaGlsZDtcbiAgICAgICAgICAgICAgdmFyIG5leHRQcm9wcyA9IHByb3ZpZGVyLnByb3BzO1xuICAgICAgICAgICAgICB2YXIgX25leHRDaGlsZHJlbjUgPSB0b0FycmF5KG5leHRQcm9wcy5jaGlsZHJlbik7XG4gICAgICAgICAgICAgIHZhciBfZnJhbWU1ID0ge1xuICAgICAgICAgICAgICAgIHR5cGU6IHByb3ZpZGVyLFxuICAgICAgICAgICAgICAgIGRvbU5hbWVzcGFjZTogcGFyZW50TmFtZXNwYWNlLFxuICAgICAgICAgICAgICAgIGNoaWxkcmVuOiBfbmV4dENoaWxkcmVuNSxcbiAgICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgICAgICAgZm9vdGVyOiAnJ1xuICAgICAgICAgICAgICB9O1xuICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgX2ZyYW1lNS5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgdGhpcy5wdXNoUHJvdmlkZXIocHJvdmlkZXIpO1xuXG4gICAgICAgICAgICAgIHRoaXMuc3RhY2sucHVzaChfZnJhbWU1KTtcbiAgICAgICAgICAgICAgcmV0dXJuICcnO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIGNhc2UgUkVBQ1RfQ09OVEVYVF9UWVBFOlxuICAgICAgICAgICAge1xuICAgICAgICAgICAgICB2YXIgcmVhY3RDb250ZXh0ID0gbmV4dENoaWxkLnR5cGU7XG4gICAgICAgICAgICAgIC8vIFRoZSBsb2dpYyBiZWxvdyBmb3IgQ29udGV4dCBkaWZmZXJzIGRlcGVuZGluZyBvbiBQUk9EIG9yIERFViBtb2RlLiBJblxuICAgICAgICAgICAgICAvLyBERVYgbW9kZSwgd2UgY3JlYXRlIGEgc2VwYXJhdGUgb2JqZWN0IGZvciBDb250ZXh0LkNvbnN1bWVyIHRoYXQgYWN0c1xuICAgICAgICAgICAgICAvLyBsaWtlIGEgcHJveHkgdG8gQ29udGV4dC4gVGhpcyBwcm94eSBvYmplY3QgYWRkcyB1bm5lY2Vzc2FyeSBjb2RlIGluIFBST0RcbiAgICAgICAgICAgICAgLy8gc28gd2UgdXNlIHRoZSBvbGQgYmVoYXZpb3VyIChDb250ZXh0LkNvbnN1bWVyIHJlZmVyZW5jZXMgQ29udGV4dCkgdG9cbiAgICAgICAgICAgICAgLy8gcmVkdWNlIHNpemUgYW5kIG92ZXJoZWFkLiBUaGUgc2VwYXJhdGUgb2JqZWN0IHJlZmVyZW5jZXMgY29udGV4dCB2aWFcbiAgICAgICAgICAgICAgLy8gYSBwcm9wZXJ0eSBjYWxsZWQgXCJfY29udGV4dFwiLCB3aGljaCBhbHNvIGdpdmVzIHVzIHRoZSBhYmlsaXR5IHRvIGNoZWNrXG4gICAgICAgICAgICAgIC8vIGluIERFViBtb2RlIGlmIHRoaXMgcHJvcGVydHkgZXhpc3RzIG9yIG5vdCBhbmQgd2FybiBpZiBpdCBkb2VzIG5vdC5cbiAgICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgIGlmIChyZWFjdENvbnRleHQuX2NvbnRleHQgPT09IHVuZGVmaW5lZCkge1xuICAgICAgICAgICAgICAgICAgLy8gVGhpcyBtYXkgYmUgYmVjYXVzZSBpdCdzIGEgQ29udGV4dCAocmF0aGVyIHRoYW4gYSBDb25zdW1lcikuXG4gICAgICAgICAgICAgICAgICAvLyBPciBpdCBtYXkgYmUgYmVjYXVzZSBpdCdzIG9sZGVyIFJlYWN0IHdoZXJlIHRoZXkncmUgdGhlIHNhbWUgdGhpbmcuXG4gICAgICAgICAgICAgICAgICAvLyBXZSBvbmx5IHdhbnQgdG8gd2FybiBpZiB3ZSdyZSBzdXJlIGl0J3MgYSBuZXcgUmVhY3QuXG4gICAgICAgICAgICAgICAgICBpZiAocmVhY3RDb250ZXh0ICE9PSByZWFjdENvbnRleHQuQ29uc3VtZXIpIHtcbiAgICAgICAgICAgICAgICAgICAgaWYgKCFoYXNXYXJuZWRBYm91dFVzaW5nQ29udGV4dEFzQ29uc3VtZXIpIHtcbiAgICAgICAgICAgICAgICAgICAgICBoYXNXYXJuZWRBYm91dFVzaW5nQ29udGV4dEFzQ29uc3VtZXIgPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlbmRlcmluZyA8Q29udGV4dD4gZGlyZWN0bHkgaXMgbm90IHN1cHBvcnRlZCBhbmQgd2lsbCBiZSByZW1vdmVkIGluICcgKyAnYSBmdXR1cmUgbWFqb3IgcmVsZWFzZS4gRGlkIHlvdSBtZWFuIHRvIHJlbmRlciA8Q29udGV4dC5Db25zdW1lcj4gaW5zdGVhZD8nKTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICByZWFjdENvbnRleHQgPSByZWFjdENvbnRleHQuX2NvbnRleHQ7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIHZhciBfbmV4dFByb3BzID0gbmV4dENoaWxkLnByb3BzO1xuICAgICAgICAgICAgICB2YXIgdGhyZWFkSUQgPSB0aGlzLnRocmVhZElEO1xuICAgICAgICAgICAgICB2YWxpZGF0ZUNvbnRleHRCb3VuZHMocmVhY3RDb250ZXh0LCB0aHJlYWRJRCk7XG4gICAgICAgICAgICAgIHZhciBuZXh0VmFsdWUgPSByZWFjdENvbnRleHRbdGhyZWFkSURdO1xuXG4gICAgICAgICAgICAgIHZhciBfbmV4dENoaWxkcmVuNiA9IHRvQXJyYXkoX25leHRQcm9wcy5jaGlsZHJlbihuZXh0VmFsdWUpKTtcbiAgICAgICAgICAgICAgdmFyIF9mcmFtZTYgPSB7XG4gICAgICAgICAgICAgICAgdHlwZTogbmV4dENoaWxkLFxuICAgICAgICAgICAgICAgIGRvbU5hbWVzcGFjZTogcGFyZW50TmFtZXNwYWNlLFxuICAgICAgICAgICAgICAgIGNoaWxkcmVuOiBfbmV4dENoaWxkcmVuNixcbiAgICAgICAgICAgICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgICAgICAgICAgIGNvbnRleHQ6IGNvbnRleHQsXG4gICAgICAgICAgICAgICAgZm9vdGVyOiAnJ1xuICAgICAgICAgICAgICB9O1xuICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgX2ZyYW1lNi5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIHRoaXMuc3RhY2sucHVzaChfZnJhbWU2KTtcbiAgICAgICAgICAgICAgcmV0dXJuICcnO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIGNhc2UgUkVBQ1RfTEFaWV9UWVBFOlxuICAgICAgICAgICAgaW52YXJpYW50KGZhbHNlLCAnUmVhY3RET01TZXJ2ZXIgZG9lcyBub3QgeWV0IHN1cHBvcnQgbGF6eS1sb2FkZWQgY29tcG9uZW50cy4nKTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICB2YXIgaW5mbyA9ICcnO1xuICAgICAge1xuICAgICAgICB2YXIgb3duZXIgPSBuZXh0RWxlbWVudC5fb3duZXI7XG4gICAgICAgIGlmIChlbGVtZW50VHlwZSA9PT0gdW5kZWZpbmVkIHx8IHR5cGVvZiBlbGVtZW50VHlwZSA9PT0gJ29iamVjdCcgJiYgZWxlbWVudFR5cGUgIT09IG51bGwgJiYgT2JqZWN0LmtleXMoZWxlbWVudFR5cGUpLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgIGluZm8gKz0gJyBZb3UgbGlrZWx5IGZvcmdvdCB0byBleHBvcnQgeW91ciBjb21wb25lbnQgZnJvbSB0aGUgZmlsZSAnICsgXCJpdCdzIGRlZmluZWQgaW4sIG9yIHlvdSBtaWdodCBoYXZlIG1peGVkIHVwIGRlZmF1bHQgYW5kIFwiICsgJ25hbWVkIGltcG9ydHMuJztcbiAgICAgICAgfVxuICAgICAgICB2YXIgb3duZXJOYW1lID0gb3duZXIgPyBnZXRDb21wb25lbnROYW1lKG93bmVyKSA6IG51bGw7XG4gICAgICAgIGlmIChvd25lck5hbWUpIHtcbiAgICAgICAgICBpbmZvICs9ICdcXG5cXG5DaGVjayB0aGUgcmVuZGVyIG1ldGhvZCBvZiBgJyArIG93bmVyTmFtZSArICdgLic7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIGludmFyaWFudChmYWxzZSwgJ0VsZW1lbnQgdHlwZSBpcyBpbnZhbGlkOiBleHBlY3RlZCBhIHN0cmluZyAoZm9yIGJ1aWx0LWluIGNvbXBvbmVudHMpIG9yIGEgY2xhc3MvZnVuY3Rpb24gKGZvciBjb21wb3NpdGUgY29tcG9uZW50cykgYnV0IGdvdDogJXMuJXMnLCBlbGVtZW50VHlwZSA9PSBudWxsID8gZWxlbWVudFR5cGUgOiB0eXBlb2YgZWxlbWVudFR5cGUsIGluZm8pO1xuICAgIH1cbiAgfTtcblxuICBSZWFjdERPTVNlcnZlclJlbmRlcmVyLnByb3RvdHlwZS5yZW5kZXJET00gPSBmdW5jdGlvbiByZW5kZXJET00oZWxlbWVudCwgY29udGV4dCwgcGFyZW50TmFtZXNwYWNlKSB7XG4gICAgdmFyIHRhZyA9IGVsZW1lbnQudHlwZS50b0xvd2VyQ2FzZSgpO1xuXG4gICAgdmFyIG5hbWVzcGFjZSA9IHBhcmVudE5hbWVzcGFjZTtcbiAgICBpZiAocGFyZW50TmFtZXNwYWNlID09PSBOYW1lc3BhY2VzLmh0bWwpIHtcbiAgICAgIG5hbWVzcGFjZSA9IGdldEludHJpbnNpY05hbWVzcGFjZSh0YWcpO1xuICAgIH1cblxuICAgIHtcbiAgICAgIGlmIChuYW1lc3BhY2UgPT09IE5hbWVzcGFjZXMuaHRtbCkge1xuICAgICAgICAvLyBTaG91bGQgdGhpcyBjaGVjayBiZSBnYXRlZCBieSBwYXJlbnQgbmFtZXNwYWNlPyBOb3Qgc3VyZSB3ZSB3YW50IHRvXG4gICAgICAgIC8vIGFsbG93IDxTVkc+IG9yIDxtQVRIPi5cbiAgICAgICAgISh0YWcgPT09IGVsZW1lbnQudHlwZSkgPyB3YXJuaW5nJDEoZmFsc2UsICc8JXMgLz4gaXMgdXNpbmcgaW5jb3JyZWN0IGNhc2luZy4gJyArICdVc2UgUGFzY2FsQ2FzZSBmb3IgUmVhY3QgY29tcG9uZW50cywgJyArICdvciBsb3dlcmNhc2UgZm9yIEhUTUwgZWxlbWVudHMuJywgZWxlbWVudC50eXBlKSA6IHZvaWQgMDtcbiAgICAgIH1cbiAgICB9XG5cbiAgICB2YWxpZGF0ZURhbmdlcm91c1RhZyh0YWcpO1xuXG4gICAgdmFyIHByb3BzID0gZWxlbWVudC5wcm9wcztcbiAgICBpZiAodGFnID09PSAnaW5wdXQnKSB7XG4gICAgICB7XG4gICAgICAgIFJlYWN0Q29udHJvbGxlZFZhbHVlUHJvcFR5cGVzLmNoZWNrUHJvcFR5cGVzKCdpbnB1dCcsIHByb3BzKTtcblxuICAgICAgICBpZiAocHJvcHMuY2hlY2tlZCAhPT0gdW5kZWZpbmVkICYmIHByb3BzLmRlZmF1bHRDaGVja2VkICE9PSB1bmRlZmluZWQgJiYgIWRpZFdhcm5EZWZhdWx0Q2hlY2tlZCkge1xuICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJyVzIGNvbnRhaW5zIGFuIGlucHV0IG9mIHR5cGUgJXMgd2l0aCBib3RoIGNoZWNrZWQgYW5kIGRlZmF1bHRDaGVja2VkIHByb3BzLiAnICsgJ0lucHV0IGVsZW1lbnRzIG11c3QgYmUgZWl0aGVyIGNvbnRyb2xsZWQgb3IgdW5jb250cm9sbGVkICcgKyAnKHNwZWNpZnkgZWl0aGVyIHRoZSBjaGVja2VkIHByb3AsIG9yIHRoZSBkZWZhdWx0Q2hlY2tlZCBwcm9wLCBidXQgbm90ICcgKyAnYm90aCkuIERlY2lkZSBiZXR3ZWVuIHVzaW5nIGEgY29udHJvbGxlZCBvciB1bmNvbnRyb2xsZWQgaW5wdXQgJyArICdlbGVtZW50IGFuZCByZW1vdmUgb25lIG9mIHRoZXNlIHByb3BzLiBNb3JlIGluZm86ICcgKyAnaHR0cHM6Ly9mYi5tZS9yZWFjdC1jb250cm9sbGVkLWNvbXBvbmVudHMnLCAnQSBjb21wb25lbnQnLCBwcm9wcy50eXBlKTtcbiAgICAgICAgICBkaWRXYXJuRGVmYXVsdENoZWNrZWQgPSB0cnVlO1xuICAgICAgICB9XG4gICAgICAgIGlmIChwcm9wcy52YWx1ZSAhPT0gdW5kZWZpbmVkICYmIHByb3BzLmRlZmF1bHRWYWx1ZSAhPT0gdW5kZWZpbmVkICYmICFkaWRXYXJuRGVmYXVsdElucHV0VmFsdWUpIHtcbiAgICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICclcyBjb250YWlucyBhbiBpbnB1dCBvZiB0eXBlICVzIHdpdGggYm90aCB2YWx1ZSBhbmQgZGVmYXVsdFZhbHVlIHByb3BzLiAnICsgJ0lucHV0IGVsZW1lbnRzIG11c3QgYmUgZWl0aGVyIGNvbnRyb2xsZWQgb3IgdW5jb250cm9sbGVkICcgKyAnKHNwZWNpZnkgZWl0aGVyIHRoZSB2YWx1ZSBwcm9wLCBvciB0aGUgZGVmYXVsdFZhbHVlIHByb3AsIGJ1dCBub3QgJyArICdib3RoKS4gRGVjaWRlIGJldHdlZW4gdXNpbmcgYSBjb250cm9sbGVkIG9yIHVuY29udHJvbGxlZCBpbnB1dCAnICsgJ2VsZW1lbnQgYW5kIHJlbW92ZSBvbmUgb2YgdGhlc2UgcHJvcHMuIE1vcmUgaW5mbzogJyArICdodHRwczovL2ZiLm1lL3JlYWN0LWNvbnRyb2xsZWQtY29tcG9uZW50cycsICdBIGNvbXBvbmVudCcsIHByb3BzLnR5cGUpO1xuICAgICAgICAgIGRpZFdhcm5EZWZhdWx0SW5wdXRWYWx1ZSA9IHRydWU7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgcHJvcHMgPSBfYXNzaWduKHtcbiAgICAgICAgdHlwZTogdW5kZWZpbmVkXG4gICAgICB9LCBwcm9wcywge1xuICAgICAgICBkZWZhdWx0Q2hlY2tlZDogdW5kZWZpbmVkLFxuICAgICAgICBkZWZhdWx0VmFsdWU6IHVuZGVmaW5lZCxcbiAgICAgICAgdmFsdWU6IHByb3BzLnZhbHVlICE9IG51bGwgPyBwcm9wcy52YWx1ZSA6IHByb3BzLmRlZmF1bHRWYWx1ZSxcbiAgICAgICAgY2hlY2tlZDogcHJvcHMuY2hlY2tlZCAhPSBudWxsID8gcHJvcHMuY2hlY2tlZCA6IHByb3BzLmRlZmF1bHRDaGVja2VkXG4gICAgICB9KTtcbiAgICB9IGVsc2UgaWYgKHRhZyA9PT0gJ3RleHRhcmVhJykge1xuICAgICAge1xuICAgICAgICBSZWFjdENvbnRyb2xsZWRWYWx1ZVByb3BUeXBlcy5jaGVja1Byb3BUeXBlcygndGV4dGFyZWEnLCBwcm9wcyk7XG4gICAgICAgIGlmIChwcm9wcy52YWx1ZSAhPT0gdW5kZWZpbmVkICYmIHByb3BzLmRlZmF1bHRWYWx1ZSAhPT0gdW5kZWZpbmVkICYmICFkaWRXYXJuRGVmYXVsdFRleHRhcmVhVmFsdWUpIHtcbiAgICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICdUZXh0YXJlYSBlbGVtZW50cyBtdXN0IGJlIGVpdGhlciBjb250cm9sbGVkIG9yIHVuY29udHJvbGxlZCAnICsgJyhzcGVjaWZ5IGVpdGhlciB0aGUgdmFsdWUgcHJvcCwgb3IgdGhlIGRlZmF1bHRWYWx1ZSBwcm9wLCBidXQgbm90ICcgKyAnYm90aCkuIERlY2lkZSBiZXR3ZWVuIHVzaW5nIGEgY29udHJvbGxlZCBvciB1bmNvbnRyb2xsZWQgdGV4dGFyZWEgJyArICdhbmQgcmVtb3ZlIG9uZSBvZiB0aGVzZSBwcm9wcy4gTW9yZSBpbmZvOiAnICsgJ2h0dHBzOi8vZmIubWUvcmVhY3QtY29udHJvbGxlZC1jb21wb25lbnRzJyk7XG4gICAgICAgICAgZGlkV2FybkRlZmF1bHRUZXh0YXJlYVZhbHVlID0gdHJ1ZTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICB2YXIgaW5pdGlhbFZhbHVlID0gcHJvcHMudmFsdWU7XG4gICAgICBpZiAoaW5pdGlhbFZhbHVlID09IG51bGwpIHtcbiAgICAgICAgdmFyIGRlZmF1bHRWYWx1ZSA9IHByb3BzLmRlZmF1bHRWYWx1ZTtcbiAgICAgICAgLy8gVE9ETyAoeXVuZ3N0ZXJzKTogUmVtb3ZlIHN1cHBvcnQgZm9yIGNoaWxkcmVuIGNvbnRlbnQgaW4gPHRleHRhcmVhPi5cbiAgICAgICAgdmFyIHRleHRhcmVhQ2hpbGRyZW4gPSBwcm9wcy5jaGlsZHJlbjtcbiAgICAgICAgaWYgKHRleHRhcmVhQ2hpbGRyZW4gIT0gbnVsbCkge1xuICAgICAgICAgIHtcbiAgICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1VzZSB0aGUgYGRlZmF1bHRWYWx1ZWAgb3IgYHZhbHVlYCBwcm9wcyBpbnN0ZWFkIG9mIHNldHRpbmcgJyArICdjaGlsZHJlbiBvbiA8dGV4dGFyZWE+LicpO1xuICAgICAgICAgIH1cbiAgICAgICAgICAhKGRlZmF1bHRWYWx1ZSA9PSBudWxsKSA/IGludmFyaWFudChmYWxzZSwgJ0lmIHlvdSBzdXBwbHkgYGRlZmF1bHRWYWx1ZWAgb24gYSA8dGV4dGFyZWE+LCBkbyBub3QgcGFzcyBjaGlsZHJlbi4nKSA6IHZvaWQgMDtcbiAgICAgICAgICBpZiAoQXJyYXkuaXNBcnJheSh0ZXh0YXJlYUNoaWxkcmVuKSkge1xuICAgICAgICAgICAgISh0ZXh0YXJlYUNoaWxkcmVuLmxlbmd0aCA8PSAxKSA/IGludmFyaWFudChmYWxzZSwgJzx0ZXh0YXJlYT4gY2FuIG9ubHkgaGF2ZSBhdCBtb3N0IG9uZSBjaGlsZC4nKSA6IHZvaWQgMDtcbiAgICAgICAgICAgIHRleHRhcmVhQ2hpbGRyZW4gPSB0ZXh0YXJlYUNoaWxkcmVuWzBdO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGRlZmF1bHRWYWx1ZSA9ICcnICsgdGV4dGFyZWFDaGlsZHJlbjtcbiAgICAgICAgfVxuICAgICAgICBpZiAoZGVmYXVsdFZhbHVlID09IG51bGwpIHtcbiAgICAgICAgICBkZWZhdWx0VmFsdWUgPSAnJztcbiAgICAgICAgfVxuICAgICAgICBpbml0aWFsVmFsdWUgPSBkZWZhdWx0VmFsdWU7XG4gICAgICB9XG5cbiAgICAgIHByb3BzID0gX2Fzc2lnbih7fSwgcHJvcHMsIHtcbiAgICAgICAgdmFsdWU6IHVuZGVmaW5lZCxcbiAgICAgICAgY2hpbGRyZW46ICcnICsgaW5pdGlhbFZhbHVlXG4gICAgICB9KTtcbiAgICB9IGVsc2UgaWYgKHRhZyA9PT0gJ3NlbGVjdCcpIHtcbiAgICAgIHtcbiAgICAgICAgUmVhY3RDb250cm9sbGVkVmFsdWVQcm9wVHlwZXMuY2hlY2tQcm9wVHlwZXMoJ3NlbGVjdCcsIHByb3BzKTtcblxuICAgICAgICBmb3IgKHZhciBpID0gMDsgaSA8IHZhbHVlUHJvcE5hbWVzLmxlbmd0aDsgaSsrKSB7XG4gICAgICAgICAgdmFyIHByb3BOYW1lID0gdmFsdWVQcm9wTmFtZXNbaV07XG4gICAgICAgICAgaWYgKHByb3BzW3Byb3BOYW1lXSA9PSBudWxsKSB7XG4gICAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgICB9XG4gICAgICAgICAgdmFyIGlzQXJyYXkgPSBBcnJheS5pc0FycmF5KHByb3BzW3Byb3BOYW1lXSk7XG4gICAgICAgICAgaWYgKHByb3BzLm11bHRpcGxlICYmICFpc0FycmF5KSB7XG4gICAgICAgICAgICB3YXJuaW5nJDEoZmFsc2UsICdUaGUgYCVzYCBwcm9wIHN1cHBsaWVkIHRvIDxzZWxlY3Q+IG11c3QgYmUgYW4gYXJyYXkgaWYgJyArICdgbXVsdGlwbGVgIGlzIHRydWUuJywgcHJvcE5hbWUpO1xuICAgICAgICAgIH0gZWxzZSBpZiAoIXByb3BzLm11bHRpcGxlICYmIGlzQXJyYXkpIHtcbiAgICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1RoZSBgJXNgIHByb3Agc3VwcGxpZWQgdG8gPHNlbGVjdD4gbXVzdCBiZSBhIHNjYWxhciAnICsgJ3ZhbHVlIGlmIGBtdWx0aXBsZWAgaXMgZmFsc2UuJywgcHJvcE5hbWUpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChwcm9wcy52YWx1ZSAhPT0gdW5kZWZpbmVkICYmIHByb3BzLmRlZmF1bHRWYWx1ZSAhPT0gdW5kZWZpbmVkICYmICFkaWRXYXJuRGVmYXVsdFNlbGVjdFZhbHVlKSB7XG4gICAgICAgICAgd2FybmluZyQxKGZhbHNlLCAnU2VsZWN0IGVsZW1lbnRzIG11c3QgYmUgZWl0aGVyIGNvbnRyb2xsZWQgb3IgdW5jb250cm9sbGVkICcgKyAnKHNwZWNpZnkgZWl0aGVyIHRoZSB2YWx1ZSBwcm9wLCBvciB0aGUgZGVmYXVsdFZhbHVlIHByb3AsIGJ1dCBub3QgJyArICdib3RoKS4gRGVjaWRlIGJldHdlZW4gdXNpbmcgYSBjb250cm9sbGVkIG9yIHVuY29udHJvbGxlZCBzZWxlY3QgJyArICdlbGVtZW50IGFuZCByZW1vdmUgb25lIG9mIHRoZXNlIHByb3BzLiBNb3JlIGluZm86ICcgKyAnaHR0cHM6Ly9mYi5tZS9yZWFjdC1jb250cm9sbGVkLWNvbXBvbmVudHMnKTtcbiAgICAgICAgICBkaWRXYXJuRGVmYXVsdFNlbGVjdFZhbHVlID0gdHJ1ZTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgdGhpcy5jdXJyZW50U2VsZWN0VmFsdWUgPSBwcm9wcy52YWx1ZSAhPSBudWxsID8gcHJvcHMudmFsdWUgOiBwcm9wcy5kZWZhdWx0VmFsdWU7XG4gICAgICBwcm9wcyA9IF9hc3NpZ24oe30sIHByb3BzLCB7XG4gICAgICAgIHZhbHVlOiB1bmRlZmluZWRcbiAgICAgIH0pO1xuICAgIH0gZWxzZSBpZiAodGFnID09PSAnb3B0aW9uJykge1xuICAgICAgdmFyIHNlbGVjdGVkID0gbnVsbDtcbiAgICAgIHZhciBzZWxlY3RWYWx1ZSA9IHRoaXMuY3VycmVudFNlbGVjdFZhbHVlO1xuICAgICAgdmFyIG9wdGlvbkNoaWxkcmVuID0gZmxhdHRlbk9wdGlvbkNoaWxkcmVuKHByb3BzLmNoaWxkcmVuKTtcbiAgICAgIGlmIChzZWxlY3RWYWx1ZSAhPSBudWxsKSB7XG4gICAgICAgIHZhciB2YWx1ZSA9IHZvaWQgMDtcbiAgICAgICAgaWYgKHByb3BzLnZhbHVlICE9IG51bGwpIHtcbiAgICAgICAgICB2YWx1ZSA9IHByb3BzLnZhbHVlICsgJyc7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgdmFsdWUgPSBvcHRpb25DaGlsZHJlbjtcbiAgICAgICAgfVxuICAgICAgICBzZWxlY3RlZCA9IGZhbHNlO1xuICAgICAgICBpZiAoQXJyYXkuaXNBcnJheShzZWxlY3RWYWx1ZSkpIHtcbiAgICAgICAgICAvLyBtdWx0aXBsZVxuICAgICAgICAgIGZvciAodmFyIGogPSAwOyBqIDwgc2VsZWN0VmFsdWUubGVuZ3RoOyBqKyspIHtcbiAgICAgICAgICAgIGlmICgnJyArIHNlbGVjdFZhbHVlW2pdID09PSB2YWx1ZSkge1xuICAgICAgICAgICAgICBzZWxlY3RlZCA9IHRydWU7XG4gICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICBzZWxlY3RlZCA9ICcnICsgc2VsZWN0VmFsdWUgPT09IHZhbHVlO1xuICAgICAgICB9XG5cbiAgICAgICAgcHJvcHMgPSBfYXNzaWduKHtcbiAgICAgICAgICBzZWxlY3RlZDogdW5kZWZpbmVkLFxuICAgICAgICAgIGNoaWxkcmVuOiB1bmRlZmluZWRcbiAgICAgICAgfSwgcHJvcHMsIHtcbiAgICAgICAgICBzZWxlY3RlZDogc2VsZWN0ZWQsXG4gICAgICAgICAgY2hpbGRyZW46IG9wdGlvbkNoaWxkcmVuXG4gICAgICAgIH0pO1xuICAgICAgfVxuICAgIH1cblxuICAgIHtcbiAgICAgIHZhbGlkYXRlUHJvcGVydGllc0luRGV2ZWxvcG1lbnQodGFnLCBwcm9wcyk7XG4gICAgfVxuXG4gICAgYXNzZXJ0VmFsaWRQcm9wcyh0YWcsIHByb3BzKTtcblxuICAgIHZhciBvdXQgPSBjcmVhdGVPcGVuVGFnTWFya3VwKGVsZW1lbnQudHlwZSwgdGFnLCBwcm9wcywgbmFtZXNwYWNlLCB0aGlzLm1ha2VTdGF0aWNNYXJrdXAsIHRoaXMuc3RhY2subGVuZ3RoID09PSAxKTtcbiAgICB2YXIgZm9vdGVyID0gJyc7XG4gICAgaWYgKG9taXR0ZWRDbG9zZVRhZ3MuaGFzT3duUHJvcGVydHkodGFnKSkge1xuICAgICAgb3V0ICs9ICcvPic7XG4gICAgfSBlbHNlIHtcbiAgICAgIG91dCArPSAnPic7XG4gICAgICBmb290ZXIgPSAnPC8nICsgZWxlbWVudC50eXBlICsgJz4nO1xuICAgIH1cbiAgICB2YXIgY2hpbGRyZW4gPSB2b2lkIDA7XG4gICAgdmFyIGlubmVyTWFya3VwID0gZ2V0Tm9uQ2hpbGRyZW5Jbm5lck1hcmt1cChwcm9wcyk7XG4gICAgaWYgKGlubmVyTWFya3VwICE9IG51bGwpIHtcbiAgICAgIGNoaWxkcmVuID0gW107XG4gICAgICBpZiAobmV3bGluZUVhdGluZ1RhZ3NbdGFnXSAmJiBpbm5lck1hcmt1cC5jaGFyQXQoMCkgPT09ICdcXG4nKSB7XG4gICAgICAgIC8vIHRleHQvaHRtbCBpZ25vcmVzIHRoZSBmaXJzdCBjaGFyYWN0ZXIgaW4gdGhlc2UgdGFncyBpZiBpdCdzIGEgbmV3bGluZVxuICAgICAgICAvLyBQcmVmZXIgdG8gYnJlYWsgYXBwbGljYXRpb24veG1sIG92ZXIgdGV4dC9odG1sIChmb3Igbm93KSBieSBhZGRpbmdcbiAgICAgICAgLy8gYSBuZXdsaW5lIHNwZWNpZmljYWxseSB0byBnZXQgZWF0ZW4gYnkgdGhlIHBhcnNlci4gKEFsdGVybmF0ZWx5IGZvclxuICAgICAgICAvLyB0ZXh0YXJlYXMsIHJlcGxhY2luZyBcIl5cXG5cIiB3aXRoIFwiXFxyXFxuXCIgZG9lc24ndCBnZXQgZWF0ZW4sIGFuZCB0aGUgZmlyc3RcbiAgICAgICAgLy8gXFxyIGlzIG5vcm1hbGl6ZWQgb3V0IGJ5IEhUTUxUZXh0QXJlYUVsZW1lbnQjdmFsdWUuKVxuICAgICAgICAvLyBTZWU6IDxodHRwOi8vd3d3LnczLm9yZy9UUi9odG1sLXBvbHlnbG90LyNuZXdsaW5lcy1pbi10ZXh0YXJlYS1hbmQtcHJlPlxuICAgICAgICAvLyBTZWU6IDxodHRwOi8vd3d3LnczLm9yZy9UUi9odG1sNS9zeW50YXguaHRtbCNlbGVtZW50LXJlc3RyaWN0aW9ucz5cbiAgICAgICAgLy8gU2VlOiA8aHR0cDovL3d3dy53My5vcmcvVFIvaHRtbDUvc3ludGF4Lmh0bWwjbmV3bGluZXM+XG4gICAgICAgIC8vIFNlZTogUGFyc2luZyBvZiBcInRleHRhcmVhXCIgXCJsaXN0aW5nXCIgYW5kIFwicHJlXCIgZWxlbWVudHNcbiAgICAgICAgLy8gIGZyb20gPGh0dHA6Ly93d3cudzMub3JnL1RSL2h0bWw1L3N5bnRheC5odG1sI3BhcnNpbmctbWFpbi1pbmJvZHk+XG4gICAgICAgIG91dCArPSAnXFxuJztcbiAgICAgIH1cbiAgICAgIG91dCArPSBpbm5lck1hcmt1cDtcbiAgICB9IGVsc2Uge1xuICAgICAgY2hpbGRyZW4gPSB0b0FycmF5KHByb3BzLmNoaWxkcmVuKTtcbiAgICB9XG4gICAgdmFyIGZyYW1lID0ge1xuICAgICAgZG9tTmFtZXNwYWNlOiBnZXRDaGlsZE5hbWVzcGFjZShwYXJlbnROYW1lc3BhY2UsIGVsZW1lbnQudHlwZSksXG4gICAgICB0eXBlOiB0YWcsXG4gICAgICBjaGlsZHJlbjogY2hpbGRyZW4sXG4gICAgICBjaGlsZEluZGV4OiAwLFxuICAgICAgY29udGV4dDogY29udGV4dCxcbiAgICAgIGZvb3RlcjogZm9vdGVyXG4gICAgfTtcbiAgICB7XG4gICAgICBmcmFtZS5kZWJ1Z0VsZW1lbnRTdGFjayA9IFtdO1xuICAgIH1cbiAgICB0aGlzLnN0YWNrLnB1c2goZnJhbWUpO1xuICAgIHRoaXMucHJldmlvdXNXYXNUZXh0Tm9kZSA9IGZhbHNlO1xuICAgIHJldHVybiBvdXQ7XG4gIH07XG5cbiAgcmV0dXJuIFJlYWN0RE9NU2VydmVyUmVuZGVyZXI7XG59KCk7XG5cbi8qKlxuICogUmVuZGVyIGEgUmVhY3RFbGVtZW50IHRvIGl0cyBpbml0aWFsIEhUTUwuIFRoaXMgc2hvdWxkIG9ubHkgYmUgdXNlZCBvbiB0aGVcbiAqIHNlcnZlci5cbiAqIFNlZSBodHRwczovL3JlYWN0anMub3JnL2RvY3MvcmVhY3QtZG9tLXNlcnZlci5odG1sI3JlbmRlcnRvc3RyaW5nXG4gKi9cbmZ1bmN0aW9uIHJlbmRlclRvU3RyaW5nKGVsZW1lbnQpIHtcbiAgdmFyIHJlbmRlcmVyID0gbmV3IFJlYWN0RE9NU2VydmVyUmVuZGVyZXIoZWxlbWVudCwgZmFsc2UpO1xuICB0cnkge1xuICAgIHZhciBtYXJrdXAgPSByZW5kZXJlci5yZWFkKEluZmluaXR5KTtcbiAgICByZXR1cm4gbWFya3VwO1xuICB9IGZpbmFsbHkge1xuICAgIHJlbmRlcmVyLmRlc3Ryb3koKTtcbiAgfVxufVxuXG4vKipcbiAqIFNpbWlsYXIgdG8gcmVuZGVyVG9TdHJpbmcsIGV4Y2VwdCB0aGlzIGRvZXNuJ3QgY3JlYXRlIGV4dHJhIERPTSBhdHRyaWJ1dGVzXG4gKiBzdWNoIGFzIGRhdGEtcmVhY3QtaWQgdGhhdCBSZWFjdCB1c2VzIGludGVybmFsbHkuXG4gKiBTZWUgaHR0cHM6Ly9yZWFjdGpzLm9yZy9kb2NzL3JlYWN0LWRvbS1zZXJ2ZXIuaHRtbCNyZW5kZXJ0b3N0YXRpY21hcmt1cFxuICovXG5mdW5jdGlvbiByZW5kZXJUb1N0YXRpY01hcmt1cChlbGVtZW50KSB7XG4gIHZhciByZW5kZXJlciA9IG5ldyBSZWFjdERPTVNlcnZlclJlbmRlcmVyKGVsZW1lbnQsIHRydWUpO1xuICB0cnkge1xuICAgIHZhciBtYXJrdXAgPSByZW5kZXJlci5yZWFkKEluZmluaXR5KTtcbiAgICByZXR1cm4gbWFya3VwO1xuICB9IGZpbmFsbHkge1xuICAgIHJlbmRlcmVyLmRlc3Ryb3koKTtcbiAgfVxufVxuXG5mdW5jdGlvbiByZW5kZXJUb05vZGVTdHJlYW0oKSB7XG4gIGludmFyaWFudChmYWxzZSwgJ1JlYWN0RE9NU2VydmVyLnJlbmRlclRvTm9kZVN0cmVhbSgpOiBUaGUgc3RyZWFtaW5nIEFQSSBpcyBub3QgYXZhaWxhYmxlIGluIHRoZSBicm93c2VyLiBVc2UgUmVhY3RET01TZXJ2ZXIucmVuZGVyVG9TdHJpbmcoKSBpbnN0ZWFkLicpO1xufVxuXG5mdW5jdGlvbiByZW5kZXJUb1N0YXRpY05vZGVTdHJlYW0oKSB7XG4gIGludmFyaWFudChmYWxzZSwgJ1JlYWN0RE9NU2VydmVyLnJlbmRlclRvU3RhdGljTm9kZVN0cmVhbSgpOiBUaGUgc3RyZWFtaW5nIEFQSSBpcyBub3QgYXZhaWxhYmxlIGluIHRoZSBicm93c2VyLiBVc2UgUmVhY3RET01TZXJ2ZXIucmVuZGVyVG9TdGF0aWNNYXJrdXAoKSBpbnN0ZWFkLicpO1xufVxuXG4vLyBOb3RlOiB3aGVuIGNoYW5naW5nIHRoaXMsIGFsc28gY29uc2lkZXIgaHR0cHM6Ly9naXRodWIuY29tL2ZhY2Vib29rL3JlYWN0L2lzc3Vlcy8xMTUyNlxudmFyIFJlYWN0RE9NU2VydmVyQnJvd3NlciA9IHtcbiAgcmVuZGVyVG9TdHJpbmc6IHJlbmRlclRvU3RyaW5nLFxuICByZW5kZXJUb1N0YXRpY01hcmt1cDogcmVuZGVyVG9TdGF0aWNNYXJrdXAsXG4gIHJlbmRlclRvTm9kZVN0cmVhbTogcmVuZGVyVG9Ob2RlU3RyZWFtLFxuICByZW5kZXJUb1N0YXRpY05vZGVTdHJlYW06IHJlbmRlclRvU3RhdGljTm9kZVN0cmVhbSxcbiAgdmVyc2lvbjogUmVhY3RWZXJzaW9uXG59O1xuXG52YXIgUmVhY3RET01TZXJ2ZXJCcm93c2VyJDEgPSBPYmplY3QuZnJlZXplKHtcblx0ZGVmYXVsdDogUmVhY3RET01TZXJ2ZXJCcm93c2VyXG59KTtcblxudmFyIFJlYWN0RE9NU2VydmVyID0gKCBSZWFjdERPTVNlcnZlckJyb3dzZXIkMSAmJiBSZWFjdERPTVNlcnZlckJyb3dzZXIgKSB8fCBSZWFjdERPTVNlcnZlckJyb3dzZXIkMTtcblxuLy8gVE9ETzogZGVjaWRlIG9uIHRoZSB0b3AtbGV2ZWwgZXhwb3J0IGZvcm0uXG4vLyBUaGlzIGlzIGhhY2t5IGJ1dCBtYWtlcyBpdCB3b3JrIHdpdGggYm90aCBSb2xsdXAgYW5kIEplc3RcbnZhciBzZXJ2ZXJfYnJvd3NlciA9IFJlYWN0RE9NU2VydmVyLmRlZmF1bHQgfHwgUmVhY3RET01TZXJ2ZXI7XG5cbm1vZHVsZS5leHBvcnRzID0gc2VydmVyX2Jyb3dzZXI7XG4gIH0pKCk7XG59XG4iLCIndXNlIHN0cmljdCc7XG5cbmlmIChwcm9jZXNzLmVudi5OT0RFX0VOViA9PT0gJ3Byb2R1Y3Rpb24nKSB7XG4gIG1vZHVsZS5leHBvcnRzID0gcmVxdWlyZSgnLi9janMvcmVhY3QtZG9tLXNlcnZlci5icm93c2VyLnByb2R1Y3Rpb24ubWluLmpzJyk7XG59IGVsc2Uge1xuICBtb2R1bGUuZXhwb3J0cyA9IHJlcXVpcmUoJy4vY2pzL3JlYWN0LWRvbS1zZXJ2ZXIuYnJvd3Nlci5kZXZlbG9wbWVudC5qcycpO1xufVxuIiwiLyoqIEBsaWNlbnNlIFJlYWN0IHYxNi44LjFcbiAqIHJlYWN0LmRldmVsb3BtZW50LmpzXG4gKlxuICogQ29weXJpZ2h0IChjKSBGYWNlYm9vaywgSW5jLiBhbmQgaXRzIGFmZmlsaWF0ZXMuXG4gKlxuICogVGhpcyBzb3VyY2UgY29kZSBpcyBsaWNlbnNlZCB1bmRlciB0aGUgTUlUIGxpY2Vuc2UgZm91bmQgaW4gdGhlXG4gKiBMSUNFTlNFIGZpbGUgaW4gdGhlIHJvb3QgZGlyZWN0b3J5IG9mIHRoaXMgc291cmNlIHRyZWUuXG4gKi9cblxuJ3VzZSBzdHJpY3QnO1xuXG5cblxuaWYgKHByb2Nlc3MuZW52Lk5PREVfRU5WICE9PSBcInByb2R1Y3Rpb25cIikge1xuICAoZnVuY3Rpb24oKSB7XG4ndXNlIHN0cmljdCc7XG5cbnZhciBfYXNzaWduID0gcmVxdWlyZSgnb2JqZWN0LWFzc2lnbicpO1xudmFyIGNoZWNrUHJvcFR5cGVzID0gcmVxdWlyZSgncHJvcC10eXBlcy9jaGVja1Byb3BUeXBlcycpO1xuXG4vLyBUT0RPOiB0aGlzIGlzIHNwZWNpYWwgYmVjYXVzZSBpdCBnZXRzIGltcG9ydGVkIGR1cmluZyBidWlsZC5cblxudmFyIFJlYWN0VmVyc2lvbiA9ICcxNi44LjEnO1xuXG4vLyBUaGUgU3ltYm9sIHVzZWQgdG8gdGFnIHRoZSBSZWFjdEVsZW1lbnQtbGlrZSB0eXBlcy4gSWYgdGhlcmUgaXMgbm8gbmF0aXZlIFN5bWJvbFxuLy8gbm9yIHBvbHlmaWxsLCB0aGVuIGEgcGxhaW4gbnVtYmVyIGlzIHVzZWQgZm9yIHBlcmZvcm1hbmNlLlxudmFyIGhhc1N5bWJvbCA9IHR5cGVvZiBTeW1ib2wgPT09ICdmdW5jdGlvbicgJiYgU3ltYm9sLmZvcjtcblxudmFyIFJFQUNUX0VMRU1FTlRfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LmVsZW1lbnQnKSA6IDB4ZWFjNztcbnZhciBSRUFDVF9QT1JUQUxfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LnBvcnRhbCcpIDogMHhlYWNhO1xudmFyIFJFQUNUX0ZSQUdNRU5UX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5mcmFnbWVudCcpIDogMHhlYWNiO1xudmFyIFJFQUNUX1NUUklDVF9NT0RFX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5zdHJpY3RfbW9kZScpIDogMHhlYWNjO1xudmFyIFJFQUNUX1BST0ZJTEVSX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5wcm9maWxlcicpIDogMHhlYWQyO1xudmFyIFJFQUNUX1BST1ZJREVSX1RZUEUgPSBoYXNTeW1ib2wgPyBTeW1ib2wuZm9yKCdyZWFjdC5wcm92aWRlcicpIDogMHhlYWNkO1xudmFyIFJFQUNUX0NPTlRFWFRfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LmNvbnRleHQnKSA6IDB4ZWFjZTtcblxudmFyIFJFQUNUX0NPTkNVUlJFTlRfTU9ERV9UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3QuY29uY3VycmVudF9tb2RlJykgOiAweGVhY2Y7XG52YXIgUkVBQ1RfRk9SV0FSRF9SRUZfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LmZvcndhcmRfcmVmJykgOiAweGVhZDA7XG52YXIgUkVBQ1RfU1VTUEVOU0VfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LnN1c3BlbnNlJykgOiAweGVhZDE7XG52YXIgUkVBQ1RfTUVNT19UWVBFID0gaGFzU3ltYm9sID8gU3ltYm9sLmZvcigncmVhY3QubWVtbycpIDogMHhlYWQzO1xudmFyIFJFQUNUX0xBWllfVFlQRSA9IGhhc1N5bWJvbCA/IFN5bWJvbC5mb3IoJ3JlYWN0LmxhenknKSA6IDB4ZWFkNDtcblxudmFyIE1BWUJFX0lURVJBVE9SX1NZTUJPTCA9IHR5cGVvZiBTeW1ib2wgPT09ICdmdW5jdGlvbicgJiYgU3ltYm9sLml0ZXJhdG9yO1xudmFyIEZBVVhfSVRFUkFUT1JfU1lNQk9MID0gJ0BAaXRlcmF0b3InO1xuXG5mdW5jdGlvbiBnZXRJdGVyYXRvckZuKG1heWJlSXRlcmFibGUpIHtcbiAgaWYgKG1heWJlSXRlcmFibGUgPT09IG51bGwgfHwgdHlwZW9mIG1heWJlSXRlcmFibGUgIT09ICdvYmplY3QnKSB7XG4gICAgcmV0dXJuIG51bGw7XG4gIH1cbiAgdmFyIG1heWJlSXRlcmF0b3IgPSBNQVlCRV9JVEVSQVRPUl9TWU1CT0wgJiYgbWF5YmVJdGVyYWJsZVtNQVlCRV9JVEVSQVRPUl9TWU1CT0xdIHx8IG1heWJlSXRlcmFibGVbRkFVWF9JVEVSQVRPUl9TWU1CT0xdO1xuICBpZiAodHlwZW9mIG1heWJlSXRlcmF0b3IgPT09ICdmdW5jdGlvbicpIHtcbiAgICByZXR1cm4gbWF5YmVJdGVyYXRvcjtcbiAgfVxuICByZXR1cm4gbnVsbDtcbn1cblxuLyoqXG4gKiBVc2UgaW52YXJpYW50KCkgdG8gYXNzZXJ0IHN0YXRlIHdoaWNoIHlvdXIgcHJvZ3JhbSBhc3N1bWVzIHRvIGJlIHRydWUuXG4gKlxuICogUHJvdmlkZSBzcHJpbnRmLXN0eWxlIGZvcm1hdCAob25seSAlcyBpcyBzdXBwb3J0ZWQpIGFuZCBhcmd1bWVudHNcbiAqIHRvIHByb3ZpZGUgaW5mb3JtYXRpb24gYWJvdXQgd2hhdCBicm9rZSBhbmQgd2hhdCB5b3Ugd2VyZVxuICogZXhwZWN0aW5nLlxuICpcbiAqIFRoZSBpbnZhcmlhbnQgbWVzc2FnZSB3aWxsIGJlIHN0cmlwcGVkIGluIHByb2R1Y3Rpb24sIGJ1dCB0aGUgaW52YXJpYW50XG4gKiB3aWxsIHJlbWFpbiB0byBlbnN1cmUgbG9naWMgZG9lcyBub3QgZGlmZmVyIGluIHByb2R1Y3Rpb24uXG4gKi9cblxudmFyIHZhbGlkYXRlRm9ybWF0ID0gZnVuY3Rpb24gKCkge307XG5cbntcbiAgdmFsaWRhdGVGb3JtYXQgPSBmdW5jdGlvbiAoZm9ybWF0KSB7XG4gICAgaWYgKGZvcm1hdCA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ2ludmFyaWFudCByZXF1aXJlcyBhbiBlcnJvciBtZXNzYWdlIGFyZ3VtZW50Jyk7XG4gICAgfVxuICB9O1xufVxuXG5mdW5jdGlvbiBpbnZhcmlhbnQoY29uZGl0aW9uLCBmb3JtYXQsIGEsIGIsIGMsIGQsIGUsIGYpIHtcbiAgdmFsaWRhdGVGb3JtYXQoZm9ybWF0KTtcblxuICBpZiAoIWNvbmRpdGlvbikge1xuICAgIHZhciBlcnJvciA9IHZvaWQgMDtcbiAgICBpZiAoZm9ybWF0ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIGVycm9yID0gbmV3IEVycm9yKCdNaW5pZmllZCBleGNlcHRpb24gb2NjdXJyZWQ7IHVzZSB0aGUgbm9uLW1pbmlmaWVkIGRldiBlbnZpcm9ubWVudCAnICsgJ2ZvciB0aGUgZnVsbCBlcnJvciBtZXNzYWdlIGFuZCBhZGRpdGlvbmFsIGhlbHBmdWwgd2FybmluZ3MuJyk7XG4gICAgfSBlbHNlIHtcbiAgICAgIHZhciBhcmdzID0gW2EsIGIsIGMsIGQsIGUsIGZdO1xuICAgICAgdmFyIGFyZ0luZGV4ID0gMDtcbiAgICAgIGVycm9yID0gbmV3IEVycm9yKGZvcm1hdC5yZXBsYWNlKC8lcy9nLCBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiBhcmdzW2FyZ0luZGV4KytdO1xuICAgICAgfSkpO1xuICAgICAgZXJyb3IubmFtZSA9ICdJbnZhcmlhbnQgVmlvbGF0aW9uJztcbiAgICB9XG5cbiAgICBlcnJvci5mcmFtZXNUb1BvcCA9IDE7IC8vIHdlIGRvbid0IGNhcmUgYWJvdXQgaW52YXJpYW50J3Mgb3duIGZyYW1lXG4gICAgdGhyb3cgZXJyb3I7XG4gIH1cbn1cblxuLy8gUmVseWluZyBvbiB0aGUgYGludmFyaWFudCgpYCBpbXBsZW1lbnRhdGlvbiBsZXRzIHVzXG4vLyBwcmVzZXJ2ZSB0aGUgZm9ybWF0IGFuZCBwYXJhbXMgaW4gdGhlIHd3dyBidWlsZHMuXG5cbi8qKlxuICogRm9ya2VkIGZyb20gZmJqcy93YXJuaW5nOlxuICogaHR0cHM6Ly9naXRodWIuY29tL2ZhY2Vib29rL2ZianMvYmxvYi9lNjZiYTIwYWQ1YmU0MzNlYjU0NDIzZjJiMDk3ZDgyOTMyNGQ5ZGU2L3BhY2thZ2VzL2ZianMvc3JjL19fZm9ya3NfXy93YXJuaW5nLmpzXG4gKlxuICogT25seSBjaGFuZ2UgaXMgd2UgdXNlIGNvbnNvbGUud2FybiBpbnN0ZWFkIG9mIGNvbnNvbGUuZXJyb3IsXG4gKiBhbmQgZG8gbm90aGluZyB3aGVuICdjb25zb2xlJyBpcyBub3Qgc3VwcG9ydGVkLlxuICogVGhpcyByZWFsbHkgc2ltcGxpZmllcyB0aGUgY29kZS5cbiAqIC0tLVxuICogU2ltaWxhciB0byBpbnZhcmlhbnQgYnV0IG9ubHkgbG9ncyBhIHdhcm5pbmcgaWYgdGhlIGNvbmRpdGlvbiBpcyBub3QgbWV0LlxuICogVGhpcyBjYW4gYmUgdXNlZCB0byBsb2cgaXNzdWVzIGluIGRldmVsb3BtZW50IGVudmlyb25tZW50cyBpbiBjcml0aWNhbFxuICogcGF0aHMuIFJlbW92aW5nIHRoZSBsb2dnaW5nIGNvZGUgZm9yIHByb2R1Y3Rpb24gZW52aXJvbm1lbnRzIHdpbGwga2VlcCB0aGVcbiAqIHNhbWUgbG9naWMgYW5kIGZvbGxvdyB0aGUgc2FtZSBjb2RlIHBhdGhzLlxuICovXG5cbnZhciBsb3dQcmlvcml0eVdhcm5pbmcgPSBmdW5jdGlvbiAoKSB7fTtcblxue1xuICB2YXIgcHJpbnRXYXJuaW5nID0gZnVuY3Rpb24gKGZvcm1hdCkge1xuICAgIGZvciAodmFyIF9sZW4gPSBhcmd1bWVudHMubGVuZ3RoLCBhcmdzID0gQXJyYXkoX2xlbiA+IDEgPyBfbGVuIC0gMSA6IDApLCBfa2V5ID0gMTsgX2tleSA8IF9sZW47IF9rZXkrKykge1xuICAgICAgYXJnc1tfa2V5IC0gMV0gPSBhcmd1bWVudHNbX2tleV07XG4gICAgfVxuXG4gICAgdmFyIGFyZ0luZGV4ID0gMDtcbiAgICB2YXIgbWVzc2FnZSA9ICdXYXJuaW5nOiAnICsgZm9ybWF0LnJlcGxhY2UoLyVzL2csIGZ1bmN0aW9uICgpIHtcbiAgICAgIHJldHVybiBhcmdzW2FyZ0luZGV4KytdO1xuICAgIH0pO1xuICAgIGlmICh0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgIGNvbnNvbGUud2FybihtZXNzYWdlKTtcbiAgICB9XG4gICAgdHJ5IHtcbiAgICAgIC8vIC0tLSBXZWxjb21lIHRvIGRlYnVnZ2luZyBSZWFjdCAtLS1cbiAgICAgIC8vIFRoaXMgZXJyb3Igd2FzIHRocm93biBhcyBhIGNvbnZlbmllbmNlIHNvIHRoYXQgeW91IGNhbiB1c2UgdGhpcyBzdGFja1xuICAgICAgLy8gdG8gZmluZCB0aGUgY2FsbHNpdGUgdGhhdCBjYXVzZWQgdGhpcyB3YXJuaW5nIHRvIGZpcmUuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IobWVzc2FnZSk7XG4gICAgfSBjYXRjaCAoeCkge31cbiAgfTtcblxuICBsb3dQcmlvcml0eVdhcm5pbmcgPSBmdW5jdGlvbiAoY29uZGl0aW9uLCBmb3JtYXQpIHtcbiAgICBpZiAoZm9ybWF0ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignYGxvd1ByaW9yaXR5V2FybmluZyhjb25kaXRpb24sIGZvcm1hdCwgLi4uYXJncylgIHJlcXVpcmVzIGEgd2FybmluZyAnICsgJ21lc3NhZ2UgYXJndW1lbnQnKTtcbiAgICB9XG4gICAgaWYgKCFjb25kaXRpb24pIHtcbiAgICAgIGZvciAodmFyIF9sZW4yID0gYXJndW1lbnRzLmxlbmd0aCwgYXJncyA9IEFycmF5KF9sZW4yID4gMiA/IF9sZW4yIC0gMiA6IDApLCBfa2V5MiA9IDI7IF9rZXkyIDwgX2xlbjI7IF9rZXkyKyspIHtcbiAgICAgICAgYXJnc1tfa2V5MiAtIDJdID0gYXJndW1lbnRzW19rZXkyXTtcbiAgICAgIH1cblxuICAgICAgcHJpbnRXYXJuaW5nLmFwcGx5KHVuZGVmaW5lZCwgW2Zvcm1hdF0uY29uY2F0KGFyZ3MpKTtcbiAgICB9XG4gIH07XG59XG5cbnZhciBsb3dQcmlvcml0eVdhcm5pbmckMSA9IGxvd1ByaW9yaXR5V2FybmluZztcblxuLyoqXG4gKiBTaW1pbGFyIHRvIGludmFyaWFudCBidXQgb25seSBsb2dzIGEgd2FybmluZyBpZiB0aGUgY29uZGl0aW9uIGlzIG5vdCBtZXQuXG4gKiBUaGlzIGNhbiBiZSB1c2VkIHRvIGxvZyBpc3N1ZXMgaW4gZGV2ZWxvcG1lbnQgZW52aXJvbm1lbnRzIGluIGNyaXRpY2FsXG4gKiBwYXRocy4gUmVtb3ZpbmcgdGhlIGxvZ2dpbmcgY29kZSBmb3IgcHJvZHVjdGlvbiBlbnZpcm9ubWVudHMgd2lsbCBrZWVwIHRoZVxuICogc2FtZSBsb2dpYyBhbmQgZm9sbG93IHRoZSBzYW1lIGNvZGUgcGF0aHMuXG4gKi9cblxudmFyIHdhcm5pbmdXaXRob3V0U3RhY2sgPSBmdW5jdGlvbiAoKSB7fTtcblxue1xuICB3YXJuaW5nV2l0aG91dFN0YWNrID0gZnVuY3Rpb24gKGNvbmRpdGlvbiwgZm9ybWF0KSB7XG4gICAgZm9yICh2YXIgX2xlbiA9IGFyZ3VtZW50cy5sZW5ndGgsIGFyZ3MgPSBBcnJheShfbGVuID4gMiA/IF9sZW4gLSAyIDogMCksIF9rZXkgPSAyOyBfa2V5IDwgX2xlbjsgX2tleSsrKSB7XG4gICAgICBhcmdzW19rZXkgLSAyXSA9IGFyZ3VtZW50c1tfa2V5XTtcbiAgICB9XG5cbiAgICBpZiAoZm9ybWF0ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignYHdhcm5pbmdXaXRob3V0U3RhY2soY29uZGl0aW9uLCBmb3JtYXQsIC4uLmFyZ3MpYCByZXF1aXJlcyBhIHdhcm5pbmcgJyArICdtZXNzYWdlIGFyZ3VtZW50Jyk7XG4gICAgfVxuICAgIGlmIChhcmdzLmxlbmd0aCA+IDgpIHtcbiAgICAgIC8vIENoZWNrIGJlZm9yZSB0aGUgY29uZGl0aW9uIHRvIGNhdGNoIHZpb2xhdGlvbnMgZWFybHkuXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ3dhcm5pbmdXaXRob3V0U3RhY2soKSBjdXJyZW50bHkgc3VwcG9ydHMgYXQgbW9zdCA4IGFyZ3VtZW50cy4nKTtcbiAgICB9XG4gICAgaWYgKGNvbmRpdGlvbikge1xuICAgICAgcmV0dXJuO1xuICAgIH1cbiAgICBpZiAodHlwZW9mIGNvbnNvbGUgIT09ICd1bmRlZmluZWQnKSB7XG4gICAgICB2YXIgYXJnc1dpdGhGb3JtYXQgPSBhcmdzLm1hcChmdW5jdGlvbiAoaXRlbSkge1xuICAgICAgICByZXR1cm4gJycgKyBpdGVtO1xuICAgICAgfSk7XG4gICAgICBhcmdzV2l0aEZvcm1hdC51bnNoaWZ0KCdXYXJuaW5nOiAnICsgZm9ybWF0KTtcblxuICAgICAgLy8gV2UgaW50ZW50aW9uYWxseSBkb24ndCB1c2Ugc3ByZWFkIChvciAuYXBwbHkpIGRpcmVjdGx5IGJlY2F1c2UgaXRcbiAgICAgIC8vIGJyZWFrcyBJRTk6IGh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9vay9yZWFjdC9pc3N1ZXMvMTM2MTBcbiAgICAgIEZ1bmN0aW9uLnByb3RvdHlwZS5hcHBseS5jYWxsKGNvbnNvbGUuZXJyb3IsIGNvbnNvbGUsIGFyZ3NXaXRoRm9ybWF0KTtcbiAgICB9XG4gICAgdHJ5IHtcbiAgICAgIC8vIC0tLSBXZWxjb21lIHRvIGRlYnVnZ2luZyBSZWFjdCAtLS1cbiAgICAgIC8vIFRoaXMgZXJyb3Igd2FzIHRocm93biBhcyBhIGNvbnZlbmllbmNlIHNvIHRoYXQgeW91IGNhbiB1c2UgdGhpcyBzdGFja1xuICAgICAgLy8gdG8gZmluZCB0aGUgY2FsbHNpdGUgdGhhdCBjYXVzZWQgdGhpcyB3YXJuaW5nIHRvIGZpcmUuXG4gICAgICB2YXIgYXJnSW5kZXggPSAwO1xuICAgICAgdmFyIG1lc3NhZ2UgPSAnV2FybmluZzogJyArIGZvcm1hdC5yZXBsYWNlKC8lcy9nLCBmdW5jdGlvbiAoKSB7XG4gICAgICAgIHJldHVybiBhcmdzW2FyZ0luZGV4KytdO1xuICAgICAgfSk7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IobWVzc2FnZSk7XG4gICAgfSBjYXRjaCAoeCkge31cbiAgfTtcbn1cblxudmFyIHdhcm5pbmdXaXRob3V0U3RhY2skMSA9IHdhcm5pbmdXaXRob3V0U3RhY2s7XG5cbnZhciBkaWRXYXJuU3RhdGVVcGRhdGVGb3JVbm1vdW50ZWRDb21wb25lbnQgPSB7fTtcblxuZnVuY3Rpb24gd2Fybk5vb3AocHVibGljSW5zdGFuY2UsIGNhbGxlck5hbWUpIHtcbiAge1xuICAgIHZhciBfY29uc3RydWN0b3IgPSBwdWJsaWNJbnN0YW5jZS5jb25zdHJ1Y3RvcjtcbiAgICB2YXIgY29tcG9uZW50TmFtZSA9IF9jb25zdHJ1Y3RvciAmJiAoX2NvbnN0cnVjdG9yLmRpc3BsYXlOYW1lIHx8IF9jb25zdHJ1Y3Rvci5uYW1lKSB8fCAnUmVhY3RDbGFzcyc7XG4gICAgdmFyIHdhcm5pbmdLZXkgPSBjb21wb25lbnROYW1lICsgJy4nICsgY2FsbGVyTmFtZTtcbiAgICBpZiAoZGlkV2FyblN0YXRlVXBkYXRlRm9yVW5tb3VudGVkQ29tcG9uZW50W3dhcm5pbmdLZXldKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuICAgIHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgXCJDYW4ndCBjYWxsICVzIG9uIGEgY29tcG9uZW50IHRoYXQgaXMgbm90IHlldCBtb3VudGVkLiBcIiArICdUaGlzIGlzIGEgbm8tb3AsIGJ1dCBpdCBtaWdodCBpbmRpY2F0ZSBhIGJ1ZyBpbiB5b3VyIGFwcGxpY2F0aW9uLiAnICsgJ0luc3RlYWQsIGFzc2lnbiB0byBgdGhpcy5zdGF0ZWAgZGlyZWN0bHkgb3IgZGVmaW5lIGEgYHN0YXRlID0ge307YCAnICsgJ2NsYXNzIHByb3BlcnR5IHdpdGggdGhlIGRlc2lyZWQgc3RhdGUgaW4gdGhlICVzIGNvbXBvbmVudC4nLCBjYWxsZXJOYW1lLCBjb21wb25lbnROYW1lKTtcbiAgICBkaWRXYXJuU3RhdGVVcGRhdGVGb3JVbm1vdW50ZWRDb21wb25lbnRbd2FybmluZ0tleV0gPSB0cnVlO1xuICB9XG59XG5cbi8qKlxuICogVGhpcyBpcyB0aGUgYWJzdHJhY3QgQVBJIGZvciBhbiB1cGRhdGUgcXVldWUuXG4gKi9cbnZhciBSZWFjdE5vb3BVcGRhdGVRdWV1ZSA9IHtcbiAgLyoqXG4gICAqIENoZWNrcyB3aGV0aGVyIG9yIG5vdCB0aGlzIGNvbXBvc2l0ZSBjb21wb25lbnQgaXMgbW91bnRlZC5cbiAgICogQHBhcmFtIHtSZWFjdENsYXNzfSBwdWJsaWNJbnN0YW5jZSBUaGUgaW5zdGFuY2Ugd2Ugd2FudCB0byB0ZXN0LlxuICAgKiBAcmV0dXJuIHtib29sZWFufSBUcnVlIGlmIG1vdW50ZWQsIGZhbHNlIG90aGVyd2lzZS5cbiAgICogQHByb3RlY3RlZFxuICAgKiBAZmluYWxcbiAgICovXG4gIGlzTW91bnRlZDogZnVuY3Rpb24gKHB1YmxpY0luc3RhbmNlKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9LFxuXG4gIC8qKlxuICAgKiBGb3JjZXMgYW4gdXBkYXRlLiBUaGlzIHNob3VsZCBvbmx5IGJlIGludm9rZWQgd2hlbiBpdCBpcyBrbm93biB3aXRoXG4gICAqIGNlcnRhaW50eSB0aGF0IHdlIGFyZSAqKm5vdCoqIGluIGEgRE9NIHRyYW5zYWN0aW9uLlxuICAgKlxuICAgKiBZb3UgbWF5IHdhbnQgdG8gY2FsbCB0aGlzIHdoZW4geW91IGtub3cgdGhhdCBzb21lIGRlZXBlciBhc3BlY3Qgb2YgdGhlXG4gICAqIGNvbXBvbmVudCdzIHN0YXRlIGhhcyBjaGFuZ2VkIGJ1dCBgc2V0U3RhdGVgIHdhcyBub3QgY2FsbGVkLlxuICAgKlxuICAgKiBUaGlzIHdpbGwgbm90IGludm9rZSBgc2hvdWxkQ29tcG9uZW50VXBkYXRlYCwgYnV0IGl0IHdpbGwgaW52b2tlXG4gICAqIGBjb21wb25lbnRXaWxsVXBkYXRlYCBhbmQgYGNvbXBvbmVudERpZFVwZGF0ZWAuXG4gICAqXG4gICAqIEBwYXJhbSB7UmVhY3RDbGFzc30gcHVibGljSW5zdGFuY2UgVGhlIGluc3RhbmNlIHRoYXQgc2hvdWxkIHJlcmVuZGVyLlxuICAgKiBAcGFyYW0gez9mdW5jdGlvbn0gY2FsbGJhY2sgQ2FsbGVkIGFmdGVyIGNvbXBvbmVudCBpcyB1cGRhdGVkLlxuICAgKiBAcGFyYW0gez9zdHJpbmd9IGNhbGxlck5hbWUgbmFtZSBvZiB0aGUgY2FsbGluZyBmdW5jdGlvbiBpbiB0aGUgcHVibGljIEFQSS5cbiAgICogQGludGVybmFsXG4gICAqL1xuICBlbnF1ZXVlRm9yY2VVcGRhdGU6IGZ1bmN0aW9uIChwdWJsaWNJbnN0YW5jZSwgY2FsbGJhY2ssIGNhbGxlck5hbWUpIHtcbiAgICB3YXJuTm9vcChwdWJsaWNJbnN0YW5jZSwgJ2ZvcmNlVXBkYXRlJyk7XG4gIH0sXG5cbiAgLyoqXG4gICAqIFJlcGxhY2VzIGFsbCBvZiB0aGUgc3RhdGUuIEFsd2F5cyB1c2UgdGhpcyBvciBgc2V0U3RhdGVgIHRvIG11dGF0ZSBzdGF0ZS5cbiAgICogWW91IHNob3VsZCB0cmVhdCBgdGhpcy5zdGF0ZWAgYXMgaW1tdXRhYmxlLlxuICAgKlxuICAgKiBUaGVyZSBpcyBubyBndWFyYW50ZWUgdGhhdCBgdGhpcy5zdGF0ZWAgd2lsbCBiZSBpbW1lZGlhdGVseSB1cGRhdGVkLCBzb1xuICAgKiBhY2Nlc3NpbmcgYHRoaXMuc3RhdGVgIGFmdGVyIGNhbGxpbmcgdGhpcyBtZXRob2QgbWF5IHJldHVybiB0aGUgb2xkIHZhbHVlLlxuICAgKlxuICAgKiBAcGFyYW0ge1JlYWN0Q2xhc3N9IHB1YmxpY0luc3RhbmNlIFRoZSBpbnN0YW5jZSB0aGF0IHNob3VsZCByZXJlbmRlci5cbiAgICogQHBhcmFtIHtvYmplY3R9IGNvbXBsZXRlU3RhdGUgTmV4dCBzdGF0ZS5cbiAgICogQHBhcmFtIHs/ZnVuY3Rpb259IGNhbGxiYWNrIENhbGxlZCBhZnRlciBjb21wb25lbnQgaXMgdXBkYXRlZC5cbiAgICogQHBhcmFtIHs/c3RyaW5nfSBjYWxsZXJOYW1lIG5hbWUgb2YgdGhlIGNhbGxpbmcgZnVuY3Rpb24gaW4gdGhlIHB1YmxpYyBBUEkuXG4gICAqIEBpbnRlcm5hbFxuICAgKi9cbiAgZW5xdWV1ZVJlcGxhY2VTdGF0ZTogZnVuY3Rpb24gKHB1YmxpY0luc3RhbmNlLCBjb21wbGV0ZVN0YXRlLCBjYWxsYmFjaywgY2FsbGVyTmFtZSkge1xuICAgIHdhcm5Ob29wKHB1YmxpY0luc3RhbmNlLCAncmVwbGFjZVN0YXRlJyk7XG4gIH0sXG5cbiAgLyoqXG4gICAqIFNldHMgYSBzdWJzZXQgb2YgdGhlIHN0YXRlLiBUaGlzIG9ubHkgZXhpc3RzIGJlY2F1c2UgX3BlbmRpbmdTdGF0ZSBpc1xuICAgKiBpbnRlcm5hbC4gVGhpcyBwcm92aWRlcyBhIG1lcmdpbmcgc3RyYXRlZ3kgdGhhdCBpcyBub3QgYXZhaWxhYmxlIHRvIGRlZXBcbiAgICogcHJvcGVydGllcyB3aGljaCBpcyBjb25mdXNpbmcuIFRPRE86IEV4cG9zZSBwZW5kaW5nU3RhdGUgb3IgZG9uJ3QgdXNlIGl0XG4gICAqIGR1cmluZyB0aGUgbWVyZ2UuXG4gICAqXG4gICAqIEBwYXJhbSB7UmVhY3RDbGFzc30gcHVibGljSW5zdGFuY2UgVGhlIGluc3RhbmNlIHRoYXQgc2hvdWxkIHJlcmVuZGVyLlxuICAgKiBAcGFyYW0ge29iamVjdH0gcGFydGlhbFN0YXRlIE5leHQgcGFydGlhbCBzdGF0ZSB0byBiZSBtZXJnZWQgd2l0aCBzdGF0ZS5cbiAgICogQHBhcmFtIHs/ZnVuY3Rpb259IGNhbGxiYWNrIENhbGxlZCBhZnRlciBjb21wb25lbnQgaXMgdXBkYXRlZC5cbiAgICogQHBhcmFtIHs/c3RyaW5nfSBOYW1lIG9mIHRoZSBjYWxsaW5nIGZ1bmN0aW9uIGluIHRoZSBwdWJsaWMgQVBJLlxuICAgKiBAaW50ZXJuYWxcbiAgICovXG4gIGVucXVldWVTZXRTdGF0ZTogZnVuY3Rpb24gKHB1YmxpY0luc3RhbmNlLCBwYXJ0aWFsU3RhdGUsIGNhbGxiYWNrLCBjYWxsZXJOYW1lKSB7XG4gICAgd2Fybk5vb3AocHVibGljSW5zdGFuY2UsICdzZXRTdGF0ZScpO1xuICB9XG59O1xuXG52YXIgZW1wdHlPYmplY3QgPSB7fTtcbntcbiAgT2JqZWN0LmZyZWV6ZShlbXB0eU9iamVjdCk7XG59XG5cbi8qKlxuICogQmFzZSBjbGFzcyBoZWxwZXJzIGZvciB0aGUgdXBkYXRpbmcgc3RhdGUgb2YgYSBjb21wb25lbnQuXG4gKi9cbmZ1bmN0aW9uIENvbXBvbmVudChwcm9wcywgY29udGV4dCwgdXBkYXRlcikge1xuICB0aGlzLnByb3BzID0gcHJvcHM7XG4gIHRoaXMuY29udGV4dCA9IGNvbnRleHQ7XG4gIC8vIElmIGEgY29tcG9uZW50IGhhcyBzdHJpbmcgcmVmcywgd2Ugd2lsbCBhc3NpZ24gYSBkaWZmZXJlbnQgb2JqZWN0IGxhdGVyLlxuICB0aGlzLnJlZnMgPSBlbXB0eU9iamVjdDtcbiAgLy8gV2UgaW5pdGlhbGl6ZSB0aGUgZGVmYXVsdCB1cGRhdGVyIGJ1dCB0aGUgcmVhbCBvbmUgZ2V0cyBpbmplY3RlZCBieSB0aGVcbiAgLy8gcmVuZGVyZXIuXG4gIHRoaXMudXBkYXRlciA9IHVwZGF0ZXIgfHwgUmVhY3ROb29wVXBkYXRlUXVldWU7XG59XG5cbkNvbXBvbmVudC5wcm90b3R5cGUuaXNSZWFjdENvbXBvbmVudCA9IHt9O1xuXG4vKipcbiAqIFNldHMgYSBzdWJzZXQgb2YgdGhlIHN0YXRlLiBBbHdheXMgdXNlIHRoaXMgdG8gbXV0YXRlXG4gKiBzdGF0ZS4gWW91IHNob3VsZCB0cmVhdCBgdGhpcy5zdGF0ZWAgYXMgaW1tdXRhYmxlLlxuICpcbiAqIFRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0IGB0aGlzLnN0YXRlYCB3aWxsIGJlIGltbWVkaWF0ZWx5IHVwZGF0ZWQsIHNvXG4gKiBhY2Nlc3NpbmcgYHRoaXMuc3RhdGVgIGFmdGVyIGNhbGxpbmcgdGhpcyBtZXRob2QgbWF5IHJldHVybiB0aGUgb2xkIHZhbHVlLlxuICpcbiAqIFRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0IGNhbGxzIHRvIGBzZXRTdGF0ZWAgd2lsbCBydW4gc3luY2hyb25vdXNseSxcbiAqIGFzIHRoZXkgbWF5IGV2ZW50dWFsbHkgYmUgYmF0Y2hlZCB0b2dldGhlci4gIFlvdSBjYW4gcHJvdmlkZSBhbiBvcHRpb25hbFxuICogY2FsbGJhY2sgdGhhdCB3aWxsIGJlIGV4ZWN1dGVkIHdoZW4gdGhlIGNhbGwgdG8gc2V0U3RhdGUgaXMgYWN0dWFsbHlcbiAqIGNvbXBsZXRlZC5cbiAqXG4gKiBXaGVuIGEgZnVuY3Rpb24gaXMgcHJvdmlkZWQgdG8gc2V0U3RhdGUsIGl0IHdpbGwgYmUgY2FsbGVkIGF0IHNvbWUgcG9pbnQgaW5cbiAqIHRoZSBmdXR1cmUgKG5vdCBzeW5jaHJvbm91c2x5KS4gSXQgd2lsbCBiZSBjYWxsZWQgd2l0aCB0aGUgdXAgdG8gZGF0ZVxuICogY29tcG9uZW50IGFyZ3VtZW50cyAoc3RhdGUsIHByb3BzLCBjb250ZXh0KS4gVGhlc2UgdmFsdWVzIGNhbiBiZSBkaWZmZXJlbnRcbiAqIGZyb20gdGhpcy4qIGJlY2F1c2UgeW91ciBmdW5jdGlvbiBtYXkgYmUgY2FsbGVkIGFmdGVyIHJlY2VpdmVQcm9wcyBidXQgYmVmb3JlXG4gKiBzaG91bGRDb21wb25lbnRVcGRhdGUsIGFuZCB0aGlzIG5ldyBzdGF0ZSwgcHJvcHMsIGFuZCBjb250ZXh0IHdpbGwgbm90IHlldCBiZVxuICogYXNzaWduZWQgdG8gdGhpcy5cbiAqXG4gKiBAcGFyYW0ge29iamVjdHxmdW5jdGlvbn0gcGFydGlhbFN0YXRlIE5leHQgcGFydGlhbCBzdGF0ZSBvciBmdW5jdGlvbiB0b1xuICogICAgICAgIHByb2R1Y2UgbmV4dCBwYXJ0aWFsIHN0YXRlIHRvIGJlIG1lcmdlZCB3aXRoIGN1cnJlbnQgc3RhdGUuXG4gKiBAcGFyYW0gez9mdW5jdGlvbn0gY2FsbGJhY2sgQ2FsbGVkIGFmdGVyIHN0YXRlIGlzIHVwZGF0ZWQuXG4gKiBAZmluYWxcbiAqIEBwcm90ZWN0ZWRcbiAqL1xuQ29tcG9uZW50LnByb3RvdHlwZS5zZXRTdGF0ZSA9IGZ1bmN0aW9uIChwYXJ0aWFsU3RhdGUsIGNhbGxiYWNrKSB7XG4gICEodHlwZW9mIHBhcnRpYWxTdGF0ZSA9PT0gJ29iamVjdCcgfHwgdHlwZW9mIHBhcnRpYWxTdGF0ZSA9PT0gJ2Z1bmN0aW9uJyB8fCBwYXJ0aWFsU3RhdGUgPT0gbnVsbCkgPyBpbnZhcmlhbnQoZmFsc2UsICdzZXRTdGF0ZSguLi4pOiB0YWtlcyBhbiBvYmplY3Qgb2Ygc3RhdGUgdmFyaWFibGVzIHRvIHVwZGF0ZSBvciBhIGZ1bmN0aW9uIHdoaWNoIHJldHVybnMgYW4gb2JqZWN0IG9mIHN0YXRlIHZhcmlhYmxlcy4nKSA6IHZvaWQgMDtcbiAgdGhpcy51cGRhdGVyLmVucXVldWVTZXRTdGF0ZSh0aGlzLCBwYXJ0aWFsU3RhdGUsIGNhbGxiYWNrLCAnc2V0U3RhdGUnKTtcbn07XG5cbi8qKlxuICogRm9yY2VzIGFuIHVwZGF0ZS4gVGhpcyBzaG91bGQgb25seSBiZSBpbnZva2VkIHdoZW4gaXQgaXMga25vd24gd2l0aFxuICogY2VydGFpbnR5IHRoYXQgd2UgYXJlICoqbm90KiogaW4gYSBET00gdHJhbnNhY3Rpb24uXG4gKlxuICogWW91IG1heSB3YW50IHRvIGNhbGwgdGhpcyB3aGVuIHlvdSBrbm93IHRoYXQgc29tZSBkZWVwZXIgYXNwZWN0IG9mIHRoZVxuICogY29tcG9uZW50J3Mgc3RhdGUgaGFzIGNoYW5nZWQgYnV0IGBzZXRTdGF0ZWAgd2FzIG5vdCBjYWxsZWQuXG4gKlxuICogVGhpcyB3aWxsIG5vdCBpbnZva2UgYHNob3VsZENvbXBvbmVudFVwZGF0ZWAsIGJ1dCBpdCB3aWxsIGludm9rZVxuICogYGNvbXBvbmVudFdpbGxVcGRhdGVgIGFuZCBgY29tcG9uZW50RGlkVXBkYXRlYC5cbiAqXG4gKiBAcGFyYW0gez9mdW5jdGlvbn0gY2FsbGJhY2sgQ2FsbGVkIGFmdGVyIHVwZGF0ZSBpcyBjb21wbGV0ZS5cbiAqIEBmaW5hbFxuICogQHByb3RlY3RlZFxuICovXG5Db21wb25lbnQucHJvdG90eXBlLmZvcmNlVXBkYXRlID0gZnVuY3Rpb24gKGNhbGxiYWNrKSB7XG4gIHRoaXMudXBkYXRlci5lbnF1ZXVlRm9yY2VVcGRhdGUodGhpcywgY2FsbGJhY2ssICdmb3JjZVVwZGF0ZScpO1xufTtcblxuLyoqXG4gKiBEZXByZWNhdGVkIEFQSXMuIFRoZXNlIEFQSXMgdXNlZCB0byBleGlzdCBvbiBjbGFzc2ljIFJlYWN0IGNsYXNzZXMgYnV0IHNpbmNlXG4gKiB3ZSB3b3VsZCBsaWtlIHRvIGRlcHJlY2F0ZSB0aGVtLCB3ZSdyZSBub3QgZ29pbmcgdG8gbW92ZSB0aGVtIG92ZXIgdG8gdGhpc1xuICogbW9kZXJuIGJhc2UgY2xhc3MuIEluc3RlYWQsIHdlIGRlZmluZSBhIGdldHRlciB0aGF0IHdhcm5zIGlmIGl0J3MgYWNjZXNzZWQuXG4gKi9cbntcbiAgdmFyIGRlcHJlY2F0ZWRBUElzID0ge1xuICAgIGlzTW91bnRlZDogWydpc01vdW50ZWQnLCAnSW5zdGVhZCwgbWFrZSBzdXJlIHRvIGNsZWFuIHVwIHN1YnNjcmlwdGlvbnMgYW5kIHBlbmRpbmcgcmVxdWVzdHMgaW4gJyArICdjb21wb25lbnRXaWxsVW5tb3VudCB0byBwcmV2ZW50IG1lbW9yeSBsZWFrcy4nXSxcbiAgICByZXBsYWNlU3RhdGU6IFsncmVwbGFjZVN0YXRlJywgJ1JlZmFjdG9yIHlvdXIgY29kZSB0byB1c2Ugc2V0U3RhdGUgaW5zdGVhZCAoc2VlICcgKyAnaHR0cHM6Ly9naXRodWIuY29tL2ZhY2Vib29rL3JlYWN0L2lzc3Vlcy8zMjM2KS4nXVxuICB9O1xuICB2YXIgZGVmaW5lRGVwcmVjYXRpb25XYXJuaW5nID0gZnVuY3Rpb24gKG1ldGhvZE5hbWUsIGluZm8pIHtcbiAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkoQ29tcG9uZW50LnByb3RvdHlwZSwgbWV0aG9kTmFtZSwge1xuICAgICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICAgIGxvd1ByaW9yaXR5V2FybmluZyQxKGZhbHNlLCAnJXMoLi4uKSBpcyBkZXByZWNhdGVkIGluIHBsYWluIEphdmFTY3JpcHQgUmVhY3QgY2xhc3Nlcy4gJXMnLCBpbmZvWzBdLCBpbmZvWzFdKTtcbiAgICAgICAgcmV0dXJuIHVuZGVmaW5lZDtcbiAgICAgIH1cbiAgICB9KTtcbiAgfTtcbiAgZm9yICh2YXIgZm5OYW1lIGluIGRlcHJlY2F0ZWRBUElzKSB7XG4gICAgaWYgKGRlcHJlY2F0ZWRBUElzLmhhc093blByb3BlcnR5KGZuTmFtZSkpIHtcbiAgICAgIGRlZmluZURlcHJlY2F0aW9uV2FybmluZyhmbk5hbWUsIGRlcHJlY2F0ZWRBUElzW2ZuTmFtZV0pO1xuICAgIH1cbiAgfVxufVxuXG5mdW5jdGlvbiBDb21wb25lbnREdW1teSgpIHt9XG5Db21wb25lbnREdW1teS5wcm90b3R5cGUgPSBDb21wb25lbnQucHJvdG90eXBlO1xuXG4vKipcbiAqIENvbnZlbmllbmNlIGNvbXBvbmVudCB3aXRoIGRlZmF1bHQgc2hhbGxvdyBlcXVhbGl0eSBjaGVjayBmb3Igc0NVLlxuICovXG5mdW5jdGlvbiBQdXJlQ29tcG9uZW50KHByb3BzLCBjb250ZXh0LCB1cGRhdGVyKSB7XG4gIHRoaXMucHJvcHMgPSBwcm9wcztcbiAgdGhpcy5jb250ZXh0ID0gY29udGV4dDtcbiAgLy8gSWYgYSBjb21wb25lbnQgaGFzIHN0cmluZyByZWZzLCB3ZSB3aWxsIGFzc2lnbiBhIGRpZmZlcmVudCBvYmplY3QgbGF0ZXIuXG4gIHRoaXMucmVmcyA9IGVtcHR5T2JqZWN0O1xuICB0aGlzLnVwZGF0ZXIgPSB1cGRhdGVyIHx8IFJlYWN0Tm9vcFVwZGF0ZVF1ZXVlO1xufVxuXG52YXIgcHVyZUNvbXBvbmVudFByb3RvdHlwZSA9IFB1cmVDb21wb25lbnQucHJvdG90eXBlID0gbmV3IENvbXBvbmVudER1bW15KCk7XG5wdXJlQ29tcG9uZW50UHJvdG90eXBlLmNvbnN0cnVjdG9yID0gUHVyZUNvbXBvbmVudDtcbi8vIEF2b2lkIGFuIGV4dHJhIHByb3RvdHlwZSBqdW1wIGZvciB0aGVzZSBtZXRob2RzLlxuX2Fzc2lnbihwdXJlQ29tcG9uZW50UHJvdG90eXBlLCBDb21wb25lbnQucHJvdG90eXBlKTtcbnB1cmVDb21wb25lbnRQcm90b3R5cGUuaXNQdXJlUmVhY3RDb21wb25lbnQgPSB0cnVlO1xuXG4vLyBhbiBpbW11dGFibGUgb2JqZWN0IHdpdGggYSBzaW5nbGUgbXV0YWJsZSB2YWx1ZVxuZnVuY3Rpb24gY3JlYXRlUmVmKCkge1xuICB2YXIgcmVmT2JqZWN0ID0ge1xuICAgIGN1cnJlbnQ6IG51bGxcbiAgfTtcbiAge1xuICAgIE9iamVjdC5zZWFsKHJlZk9iamVjdCk7XG4gIH1cbiAgcmV0dXJuIHJlZk9iamVjdDtcbn1cblxuLyoqXG4gKiBLZWVwcyB0cmFjayBvZiB0aGUgY3VycmVudCBkaXNwYXRjaGVyLlxuICovXG52YXIgUmVhY3RDdXJyZW50RGlzcGF0Y2hlciA9IHtcbiAgLyoqXG4gICAqIEBpbnRlcm5hbFxuICAgKiBAdHlwZSB7UmVhY3RDb21wb25lbnR9XG4gICAqL1xuICBjdXJyZW50OiBudWxsXG59O1xuXG4vKipcbiAqIEtlZXBzIHRyYWNrIG9mIHRoZSBjdXJyZW50IG93bmVyLlxuICpcbiAqIFRoZSBjdXJyZW50IG93bmVyIGlzIHRoZSBjb21wb25lbnQgd2hvIHNob3VsZCBvd24gYW55IGNvbXBvbmVudHMgdGhhdCBhcmVcbiAqIGN1cnJlbnRseSBiZWluZyBjb25zdHJ1Y3RlZC5cbiAqL1xudmFyIFJlYWN0Q3VycmVudE93bmVyID0ge1xuICAvKipcbiAgICogQGludGVybmFsXG4gICAqIEB0eXBlIHtSZWFjdENvbXBvbmVudH1cbiAgICovXG4gIGN1cnJlbnQ6IG51bGxcbn07XG5cbnZhciBCRUZPUkVfU0xBU0hfUkUgPSAvXiguKilbXFxcXFxcL10vO1xuXG52YXIgZGVzY3JpYmVDb21wb25lbnRGcmFtZSA9IGZ1bmN0aW9uIChuYW1lLCBzb3VyY2UsIG93bmVyTmFtZSkge1xuICB2YXIgc291cmNlSW5mbyA9ICcnO1xuICBpZiAoc291cmNlKSB7XG4gICAgdmFyIHBhdGggPSBzb3VyY2UuZmlsZU5hbWU7XG4gICAgdmFyIGZpbGVOYW1lID0gcGF0aC5yZXBsYWNlKEJFRk9SRV9TTEFTSF9SRSwgJycpO1xuICAgIHtcbiAgICAgIC8vIEluIERFViwgaW5jbHVkZSBjb2RlIGZvciBhIGNvbW1vbiBzcGVjaWFsIGNhc2U6XG4gICAgICAvLyBwcmVmZXIgXCJmb2xkZXIvaW5kZXguanNcIiBpbnN0ZWFkIG9mIGp1c3QgXCJpbmRleC5qc1wiLlxuICAgICAgaWYgKC9eaW5kZXhcXC4vLnRlc3QoZmlsZU5hbWUpKSB7XG4gICAgICAgIHZhciBtYXRjaCA9IHBhdGgubWF0Y2goQkVGT1JFX1NMQVNIX1JFKTtcbiAgICAgICAgaWYgKG1hdGNoKSB7XG4gICAgICAgICAgdmFyIHBhdGhCZWZvcmVTbGFzaCA9IG1hdGNoWzFdO1xuICAgICAgICAgIGlmIChwYXRoQmVmb3JlU2xhc2gpIHtcbiAgICAgICAgICAgIHZhciBmb2xkZXJOYW1lID0gcGF0aEJlZm9yZVNsYXNoLnJlcGxhY2UoQkVGT1JFX1NMQVNIX1JFLCAnJyk7XG4gICAgICAgICAgICBmaWxlTmFtZSA9IGZvbGRlck5hbWUgKyAnLycgKyBmaWxlTmFtZTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG4gICAgc291cmNlSW5mbyA9ICcgKGF0ICcgKyBmaWxlTmFtZSArICc6JyArIHNvdXJjZS5saW5lTnVtYmVyICsgJyknO1xuICB9IGVsc2UgaWYgKG93bmVyTmFtZSkge1xuICAgIHNvdXJjZUluZm8gPSAnIChjcmVhdGVkIGJ5ICcgKyBvd25lck5hbWUgKyAnKSc7XG4gIH1cbiAgcmV0dXJuICdcXG4gICAgaW4gJyArIChuYW1lIHx8ICdVbmtub3duJykgKyBzb3VyY2VJbmZvO1xufTtcblxudmFyIFJlc29sdmVkID0gMTtcblxuXG5mdW5jdGlvbiByZWZpbmVSZXNvbHZlZExhenlDb21wb25lbnQobGF6eUNvbXBvbmVudCkge1xuICByZXR1cm4gbGF6eUNvbXBvbmVudC5fc3RhdHVzID09PSBSZXNvbHZlZCA/IGxhenlDb21wb25lbnQuX3Jlc3VsdCA6IG51bGw7XG59XG5cbmZ1bmN0aW9uIGdldFdyYXBwZWROYW1lKG91dGVyVHlwZSwgaW5uZXJUeXBlLCB3cmFwcGVyTmFtZSkge1xuICB2YXIgZnVuY3Rpb25OYW1lID0gaW5uZXJUeXBlLmRpc3BsYXlOYW1lIHx8IGlubmVyVHlwZS5uYW1lIHx8ICcnO1xuICByZXR1cm4gb3V0ZXJUeXBlLmRpc3BsYXlOYW1lIHx8IChmdW5jdGlvbk5hbWUgIT09ICcnID8gd3JhcHBlck5hbWUgKyAnKCcgKyBmdW5jdGlvbk5hbWUgKyAnKScgOiB3cmFwcGVyTmFtZSk7XG59XG5cbmZ1bmN0aW9uIGdldENvbXBvbmVudE5hbWUodHlwZSkge1xuICBpZiAodHlwZSA9PSBudWxsKSB7XG4gICAgLy8gSG9zdCByb290LCB0ZXh0IG5vZGUgb3IganVzdCBpbnZhbGlkIHR5cGUuXG4gICAgcmV0dXJuIG51bGw7XG4gIH1cbiAge1xuICAgIGlmICh0eXBlb2YgdHlwZS50YWcgPT09ICdudW1iZXInKSB7XG4gICAgICB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdSZWNlaXZlZCBhbiB1bmV4cGVjdGVkIG9iamVjdCBpbiBnZXRDb21wb25lbnROYW1lKCkuICcgKyAnVGhpcyBpcyBsaWtlbHkgYSBidWcgaW4gUmVhY3QuIFBsZWFzZSBmaWxlIGFuIGlzc3VlLicpO1xuICAgIH1cbiAgfVxuICBpZiAodHlwZW9mIHR5cGUgPT09ICdmdW5jdGlvbicpIHtcbiAgICByZXR1cm4gdHlwZS5kaXNwbGF5TmFtZSB8fCB0eXBlLm5hbWUgfHwgbnVsbDtcbiAgfVxuICBpZiAodHlwZW9mIHR5cGUgPT09ICdzdHJpbmcnKSB7XG4gICAgcmV0dXJuIHR5cGU7XG4gIH1cbiAgc3dpdGNoICh0eXBlKSB7XG4gICAgY2FzZSBSRUFDVF9DT05DVVJSRU5UX01PREVfVFlQRTpcbiAgICAgIHJldHVybiAnQ29uY3VycmVudE1vZGUnO1xuICAgIGNhc2UgUkVBQ1RfRlJBR01FTlRfVFlQRTpcbiAgICAgIHJldHVybiAnRnJhZ21lbnQnO1xuICAgIGNhc2UgUkVBQ1RfUE9SVEFMX1RZUEU6XG4gICAgICByZXR1cm4gJ1BvcnRhbCc7XG4gICAgY2FzZSBSRUFDVF9QUk9GSUxFUl9UWVBFOlxuICAgICAgcmV0dXJuICdQcm9maWxlcic7XG4gICAgY2FzZSBSRUFDVF9TVFJJQ1RfTU9ERV9UWVBFOlxuICAgICAgcmV0dXJuICdTdHJpY3RNb2RlJztcbiAgICBjYXNlIFJFQUNUX1NVU1BFTlNFX1RZUEU6XG4gICAgICByZXR1cm4gJ1N1c3BlbnNlJztcbiAgfVxuICBpZiAodHlwZW9mIHR5cGUgPT09ICdvYmplY3QnKSB7XG4gICAgc3dpdGNoICh0eXBlLiQkdHlwZW9mKSB7XG4gICAgICBjYXNlIFJFQUNUX0NPTlRFWFRfVFlQRTpcbiAgICAgICAgcmV0dXJuICdDb250ZXh0LkNvbnN1bWVyJztcbiAgICAgIGNhc2UgUkVBQ1RfUFJPVklERVJfVFlQRTpcbiAgICAgICAgcmV0dXJuICdDb250ZXh0LlByb3ZpZGVyJztcbiAgICAgIGNhc2UgUkVBQ1RfRk9SV0FSRF9SRUZfVFlQRTpcbiAgICAgICAgcmV0dXJuIGdldFdyYXBwZWROYW1lKHR5cGUsIHR5cGUucmVuZGVyLCAnRm9yd2FyZFJlZicpO1xuICAgICAgY2FzZSBSRUFDVF9NRU1PX1RZUEU6XG4gICAgICAgIHJldHVybiBnZXRDb21wb25lbnROYW1lKHR5cGUudHlwZSk7XG4gICAgICBjYXNlIFJFQUNUX0xBWllfVFlQRTpcbiAgICAgICAge1xuICAgICAgICAgIHZhciB0aGVuYWJsZSA9IHR5cGU7XG4gICAgICAgICAgdmFyIHJlc29sdmVkVGhlbmFibGUgPSByZWZpbmVSZXNvbHZlZExhenlDb21wb25lbnQodGhlbmFibGUpO1xuICAgICAgICAgIGlmIChyZXNvbHZlZFRoZW5hYmxlKSB7XG4gICAgICAgICAgICByZXR1cm4gZ2V0Q29tcG9uZW50TmFtZShyZXNvbHZlZFRoZW5hYmxlKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9XG4gIH1cbiAgcmV0dXJuIG51bGw7XG59XG5cbnZhciBSZWFjdERlYnVnQ3VycmVudEZyYW1lID0ge307XG5cbnZhciBjdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudCA9IG51bGw7XG5cbmZ1bmN0aW9uIHNldEN1cnJlbnRseVZhbGlkYXRpbmdFbGVtZW50KGVsZW1lbnQpIHtcbiAge1xuICAgIGN1cnJlbnRseVZhbGlkYXRpbmdFbGVtZW50ID0gZWxlbWVudDtcbiAgfVxufVxuXG57XG4gIC8vIFN0YWNrIGltcGxlbWVudGF0aW9uIGluamVjdGVkIGJ5IHRoZSBjdXJyZW50IHJlbmRlcmVyLlxuICBSZWFjdERlYnVnQ3VycmVudEZyYW1lLmdldEN1cnJlbnRTdGFjayA9IG51bGw7XG5cbiAgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZS5nZXRTdGFja0FkZGVuZHVtID0gZnVuY3Rpb24gKCkge1xuICAgIHZhciBzdGFjayA9ICcnO1xuXG4gICAgLy8gQWRkIGFuIGV4dHJhIHRvcCBmcmFtZSB3aGlsZSBhbiBlbGVtZW50IGlzIGJlaW5nIHZhbGlkYXRlZFxuICAgIGlmIChjdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudCkge1xuICAgICAgdmFyIG5hbWUgPSBnZXRDb21wb25lbnROYW1lKGN1cnJlbnRseVZhbGlkYXRpbmdFbGVtZW50LnR5cGUpO1xuICAgICAgdmFyIG93bmVyID0gY3VycmVudGx5VmFsaWRhdGluZ0VsZW1lbnQuX293bmVyO1xuICAgICAgc3RhY2sgKz0gZGVzY3JpYmVDb21wb25lbnRGcmFtZShuYW1lLCBjdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudC5fc291cmNlLCBvd25lciAmJiBnZXRDb21wb25lbnROYW1lKG93bmVyLnR5cGUpKTtcbiAgICB9XG5cbiAgICAvLyBEZWxlZ2F0ZSB0byB0aGUgaW5qZWN0ZWQgcmVuZGVyZXItc3BlY2lmaWMgaW1wbGVtZW50YXRpb25cbiAgICB2YXIgaW1wbCA9IFJlYWN0RGVidWdDdXJyZW50RnJhbWUuZ2V0Q3VycmVudFN0YWNrO1xuICAgIGlmIChpbXBsKSB7XG4gICAgICBzdGFjayArPSBpbXBsKCkgfHwgJyc7XG4gICAgfVxuXG4gICAgcmV0dXJuIHN0YWNrO1xuICB9O1xufVxuXG52YXIgUmVhY3RTaGFyZWRJbnRlcm5hbHMgPSB7XG4gIFJlYWN0Q3VycmVudERpc3BhdGNoZXI6IFJlYWN0Q3VycmVudERpc3BhdGNoZXIsXG4gIFJlYWN0Q3VycmVudE93bmVyOiBSZWFjdEN1cnJlbnRPd25lcixcbiAgLy8gVXNlZCBieSByZW5kZXJlcnMgdG8gYXZvaWQgYnVuZGxpbmcgb2JqZWN0LWFzc2lnbiB0d2ljZSBpbiBVTUQgYnVuZGxlczpcbiAgYXNzaWduOiBfYXNzaWduXG59O1xuXG57XG4gIF9hc3NpZ24oUmVhY3RTaGFyZWRJbnRlcm5hbHMsIHtcbiAgICAvLyBUaGVzZSBzaG91bGQgbm90IGJlIGluY2x1ZGVkIGluIHByb2R1Y3Rpb24uXG4gICAgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZTogUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZSxcbiAgICAvLyBTaGltIGZvciBSZWFjdCBET00gMTYuMC4wIHdoaWNoIHN0aWxsIGRlc3RydWN0dXJlZCAoYnV0IG5vdCB1c2VkKSB0aGlzLlxuICAgIC8vIFRPRE86IHJlbW92ZSBpbiBSZWFjdCAxNy4wLlxuICAgIFJlYWN0Q29tcG9uZW50VHJlZUhvb2s6IHt9XG4gIH0pO1xufVxuXG4vKipcbiAqIFNpbWlsYXIgdG8gaW52YXJpYW50IGJ1dCBvbmx5IGxvZ3MgYSB3YXJuaW5nIGlmIHRoZSBjb25kaXRpb24gaXMgbm90IG1ldC5cbiAqIFRoaXMgY2FuIGJlIHVzZWQgdG8gbG9nIGlzc3VlcyBpbiBkZXZlbG9wbWVudCBlbnZpcm9ubWVudHMgaW4gY3JpdGljYWxcbiAqIHBhdGhzLiBSZW1vdmluZyB0aGUgbG9nZ2luZyBjb2RlIGZvciBwcm9kdWN0aW9uIGVudmlyb25tZW50cyB3aWxsIGtlZXAgdGhlXG4gKiBzYW1lIGxvZ2ljIGFuZCBmb2xsb3cgdGhlIHNhbWUgY29kZSBwYXRocy5cbiAqL1xuXG52YXIgd2FybmluZyA9IHdhcm5pbmdXaXRob3V0U3RhY2skMTtcblxue1xuICB3YXJuaW5nID0gZnVuY3Rpb24gKGNvbmRpdGlvbiwgZm9ybWF0KSB7XG4gICAgaWYgKGNvbmRpdGlvbikge1xuICAgICAgcmV0dXJuO1xuICAgIH1cbiAgICB2YXIgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZSA9IFJlYWN0U2hhcmVkSW50ZXJuYWxzLlJlYWN0RGVidWdDdXJyZW50RnJhbWU7XG4gICAgdmFyIHN0YWNrID0gUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZS5nZXRTdGFja0FkZGVuZHVtKCk7XG4gICAgLy8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIHJlYWN0LWludGVybmFsL3dhcm5pbmctYW5kLWludmFyaWFudC1hcmdzXG5cbiAgICBmb3IgKHZhciBfbGVuID0gYXJndW1lbnRzLmxlbmd0aCwgYXJncyA9IEFycmF5KF9sZW4gPiAyID8gX2xlbiAtIDIgOiAwKSwgX2tleSA9IDI7IF9rZXkgPCBfbGVuOyBfa2V5KyspIHtcbiAgICAgIGFyZ3NbX2tleSAtIDJdID0gYXJndW1lbnRzW19rZXldO1xuICAgIH1cblxuICAgIHdhcm5pbmdXaXRob3V0U3RhY2skMS5hcHBseSh1bmRlZmluZWQsIFtmYWxzZSwgZm9ybWF0ICsgJyVzJ10uY29uY2F0KGFyZ3MsIFtzdGFja10pKTtcbiAgfTtcbn1cblxudmFyIHdhcm5pbmckMSA9IHdhcm5pbmc7XG5cbnZhciBoYXNPd25Qcm9wZXJ0eSA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHk7XG5cbnZhciBSRVNFUlZFRF9QUk9QUyA9IHtcbiAga2V5OiB0cnVlLFxuICByZWY6IHRydWUsXG4gIF9fc2VsZjogdHJ1ZSxcbiAgX19zb3VyY2U6IHRydWVcbn07XG5cbnZhciBzcGVjaWFsUHJvcEtleVdhcm5pbmdTaG93biA9IHZvaWQgMDtcbnZhciBzcGVjaWFsUHJvcFJlZldhcm5pbmdTaG93biA9IHZvaWQgMDtcblxuZnVuY3Rpb24gaGFzVmFsaWRSZWYoY29uZmlnKSB7XG4gIHtcbiAgICBpZiAoaGFzT3duUHJvcGVydHkuY2FsbChjb25maWcsICdyZWYnKSkge1xuICAgICAgdmFyIGdldHRlciA9IE9iamVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3IoY29uZmlnLCAncmVmJykuZ2V0O1xuICAgICAgaWYgKGdldHRlciAmJiBnZXR0ZXIuaXNSZWFjdFdhcm5pbmcpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuICAgIH1cbiAgfVxuICByZXR1cm4gY29uZmlnLnJlZiAhPT0gdW5kZWZpbmVkO1xufVxuXG5mdW5jdGlvbiBoYXNWYWxpZEtleShjb25maWcpIHtcbiAge1xuICAgIGlmIChoYXNPd25Qcm9wZXJ0eS5jYWxsKGNvbmZpZywgJ2tleScpKSB7XG4gICAgICB2YXIgZ2V0dGVyID0gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcihjb25maWcsICdrZXknKS5nZXQ7XG4gICAgICBpZiAoZ2V0dGVyICYmIGdldHRlci5pc1JlYWN0V2FybmluZykge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG4gICAgfVxuICB9XG4gIHJldHVybiBjb25maWcua2V5ICE9PSB1bmRlZmluZWQ7XG59XG5cbmZ1bmN0aW9uIGRlZmluZUtleVByb3BXYXJuaW5nR2V0dGVyKHByb3BzLCBkaXNwbGF5TmFtZSkge1xuICB2YXIgd2FybkFib3V0QWNjZXNzaW5nS2V5ID0gZnVuY3Rpb24gKCkge1xuICAgIGlmICghc3BlY2lhbFByb3BLZXlXYXJuaW5nU2hvd24pIHtcbiAgICAgIHNwZWNpYWxQcm9wS2V5V2FybmluZ1Nob3duID0gdHJ1ZTtcbiAgICAgIHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgJyVzOiBga2V5YCBpcyBub3QgYSBwcm9wLiBUcnlpbmcgdG8gYWNjZXNzIGl0IHdpbGwgcmVzdWx0ICcgKyAnaW4gYHVuZGVmaW5lZGAgYmVpbmcgcmV0dXJuZWQuIElmIHlvdSBuZWVkIHRvIGFjY2VzcyB0aGUgc2FtZSAnICsgJ3ZhbHVlIHdpdGhpbiB0aGUgY2hpbGQgY29tcG9uZW50LCB5b3Ugc2hvdWxkIHBhc3MgaXQgYXMgYSBkaWZmZXJlbnQgJyArICdwcm9wLiAoaHR0cHM6Ly9mYi5tZS9yZWFjdC1zcGVjaWFsLXByb3BzKScsIGRpc3BsYXlOYW1lKTtcbiAgICB9XG4gIH07XG4gIHdhcm5BYm91dEFjY2Vzc2luZ0tleS5pc1JlYWN0V2FybmluZyA9IHRydWU7XG4gIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShwcm9wcywgJ2tleScsIHtcbiAgICBnZXQ6IHdhcm5BYm91dEFjY2Vzc2luZ0tleSxcbiAgICBjb25maWd1cmFibGU6IHRydWVcbiAgfSk7XG59XG5cbmZ1bmN0aW9uIGRlZmluZVJlZlByb3BXYXJuaW5nR2V0dGVyKHByb3BzLCBkaXNwbGF5TmFtZSkge1xuICB2YXIgd2FybkFib3V0QWNjZXNzaW5nUmVmID0gZnVuY3Rpb24gKCkge1xuICAgIGlmICghc3BlY2lhbFByb3BSZWZXYXJuaW5nU2hvd24pIHtcbiAgICAgIHNwZWNpYWxQcm9wUmVmV2FybmluZ1Nob3duID0gdHJ1ZTtcbiAgICAgIHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgJyVzOiBgcmVmYCBpcyBub3QgYSBwcm9wLiBUcnlpbmcgdG8gYWNjZXNzIGl0IHdpbGwgcmVzdWx0ICcgKyAnaW4gYHVuZGVmaW5lZGAgYmVpbmcgcmV0dXJuZWQuIElmIHlvdSBuZWVkIHRvIGFjY2VzcyB0aGUgc2FtZSAnICsgJ3ZhbHVlIHdpdGhpbiB0aGUgY2hpbGQgY29tcG9uZW50LCB5b3Ugc2hvdWxkIHBhc3MgaXQgYXMgYSBkaWZmZXJlbnQgJyArICdwcm9wLiAoaHR0cHM6Ly9mYi5tZS9yZWFjdC1zcGVjaWFsLXByb3BzKScsIGRpc3BsYXlOYW1lKTtcbiAgICB9XG4gIH07XG4gIHdhcm5BYm91dEFjY2Vzc2luZ1JlZi5pc1JlYWN0V2FybmluZyA9IHRydWU7XG4gIE9iamVjdC5kZWZpbmVQcm9wZXJ0eShwcm9wcywgJ3JlZicsIHtcbiAgICBnZXQ6IHdhcm5BYm91dEFjY2Vzc2luZ1JlZixcbiAgICBjb25maWd1cmFibGU6IHRydWVcbiAgfSk7XG59XG5cbi8qKlxuICogRmFjdG9yeSBtZXRob2QgdG8gY3JlYXRlIGEgbmV3IFJlYWN0IGVsZW1lbnQuIFRoaXMgbm8gbG9uZ2VyIGFkaGVyZXMgdG9cbiAqIHRoZSBjbGFzcyBwYXR0ZXJuLCBzbyBkbyBub3QgdXNlIG5ldyB0byBjYWxsIGl0LiBBbHNvLCBubyBpbnN0YW5jZW9mIGNoZWNrXG4gKiB3aWxsIHdvcmsuIEluc3RlYWQgdGVzdCAkJHR5cGVvZiBmaWVsZCBhZ2FpbnN0IFN5bWJvbC5mb3IoJ3JlYWN0LmVsZW1lbnQnKSB0byBjaGVja1xuICogaWYgc29tZXRoaW5nIGlzIGEgUmVhY3QgRWxlbWVudC5cbiAqXG4gKiBAcGFyYW0geyp9IHR5cGVcbiAqIEBwYXJhbSB7Kn0ga2V5XG4gKiBAcGFyYW0ge3N0cmluZ3xvYmplY3R9IHJlZlxuICogQHBhcmFtIHsqfSBzZWxmIEEgKnRlbXBvcmFyeSogaGVscGVyIHRvIGRldGVjdCBwbGFjZXMgd2hlcmUgYHRoaXNgIGlzXG4gKiBkaWZmZXJlbnQgZnJvbSB0aGUgYG93bmVyYCB3aGVuIFJlYWN0LmNyZWF0ZUVsZW1lbnQgaXMgY2FsbGVkLCBzbyB0aGF0IHdlXG4gKiBjYW4gd2Fybi4gV2Ugd2FudCB0byBnZXQgcmlkIG9mIG93bmVyIGFuZCByZXBsYWNlIHN0cmluZyBgcmVmYHMgd2l0aCBhcnJvd1xuICogZnVuY3Rpb25zLCBhbmQgYXMgbG9uZyBhcyBgdGhpc2AgYW5kIG93bmVyIGFyZSB0aGUgc2FtZSwgdGhlcmUgd2lsbCBiZSBub1xuICogY2hhbmdlIGluIGJlaGF2aW9yLlxuICogQHBhcmFtIHsqfSBzb3VyY2UgQW4gYW5ub3RhdGlvbiBvYmplY3QgKGFkZGVkIGJ5IGEgdHJhbnNwaWxlciBvciBvdGhlcndpc2UpXG4gKiBpbmRpY2F0aW5nIGZpbGVuYW1lLCBsaW5lIG51bWJlciwgYW5kL29yIG90aGVyIGluZm9ybWF0aW9uLlxuICogQHBhcmFtIHsqfSBvd25lclxuICogQHBhcmFtIHsqfSBwcm9wc1xuICogQGludGVybmFsXG4gKi9cbnZhciBSZWFjdEVsZW1lbnQgPSBmdW5jdGlvbiAodHlwZSwga2V5LCByZWYsIHNlbGYsIHNvdXJjZSwgb3duZXIsIHByb3BzKSB7XG4gIHZhciBlbGVtZW50ID0ge1xuICAgIC8vIFRoaXMgdGFnIGFsbG93cyB1cyB0byB1bmlxdWVseSBpZGVudGlmeSB0aGlzIGFzIGEgUmVhY3QgRWxlbWVudFxuICAgICQkdHlwZW9mOiBSRUFDVF9FTEVNRU5UX1RZUEUsXG5cbiAgICAvLyBCdWlsdC1pbiBwcm9wZXJ0aWVzIHRoYXQgYmVsb25nIG9uIHRoZSBlbGVtZW50XG4gICAgdHlwZTogdHlwZSxcbiAgICBrZXk6IGtleSxcbiAgICByZWY6IHJlZixcbiAgICBwcm9wczogcHJvcHMsXG5cbiAgICAvLyBSZWNvcmQgdGhlIGNvbXBvbmVudCByZXNwb25zaWJsZSBmb3IgY3JlYXRpbmcgdGhpcyBlbGVtZW50LlxuICAgIF9vd25lcjogb3duZXJcbiAgfTtcblxuICB7XG4gICAgLy8gVGhlIHZhbGlkYXRpb24gZmxhZyBpcyBjdXJyZW50bHkgbXV0YXRpdmUuIFdlIHB1dCBpdCBvblxuICAgIC8vIGFuIGV4dGVybmFsIGJhY2tpbmcgc3RvcmUgc28gdGhhdCB3ZSBjYW4gZnJlZXplIHRoZSB3aG9sZSBvYmplY3QuXG4gICAgLy8gVGhpcyBjYW4gYmUgcmVwbGFjZWQgd2l0aCBhIFdlYWtNYXAgb25jZSB0aGV5IGFyZSBpbXBsZW1lbnRlZCBpblxuICAgIC8vIGNvbW1vbmx5IHVzZWQgZGV2ZWxvcG1lbnQgZW52aXJvbm1lbnRzLlxuICAgIGVsZW1lbnQuX3N0b3JlID0ge307XG5cbiAgICAvLyBUbyBtYWtlIGNvbXBhcmluZyBSZWFjdEVsZW1lbnRzIGVhc2llciBmb3IgdGVzdGluZyBwdXJwb3Nlcywgd2UgbWFrZVxuICAgIC8vIHRoZSB2YWxpZGF0aW9uIGZsYWcgbm9uLWVudW1lcmFibGUgKHdoZXJlIHBvc3NpYmxlLCB3aGljaCBzaG91bGRcbiAgICAvLyBpbmNsdWRlIGV2ZXJ5IGVudmlyb25tZW50IHdlIHJ1biB0ZXN0cyBpbiksIHNvIHRoZSB0ZXN0IGZyYW1ld29ya1xuICAgIC8vIGlnbm9yZXMgaXQuXG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KGVsZW1lbnQuX3N0b3JlLCAndmFsaWRhdGVkJywge1xuICAgICAgY29uZmlndXJhYmxlOiBmYWxzZSxcbiAgICAgIGVudW1lcmFibGU6IGZhbHNlLFxuICAgICAgd3JpdGFibGU6IHRydWUsXG4gICAgICB2YWx1ZTogZmFsc2VcbiAgICB9KTtcbiAgICAvLyBzZWxmIGFuZCBzb3VyY2UgYXJlIERFViBvbmx5IHByb3BlcnRpZXMuXG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KGVsZW1lbnQsICdfc2VsZicsIHtcbiAgICAgIGNvbmZpZ3VyYWJsZTogZmFsc2UsXG4gICAgICBlbnVtZXJhYmxlOiBmYWxzZSxcbiAgICAgIHdyaXRhYmxlOiBmYWxzZSxcbiAgICAgIHZhbHVlOiBzZWxmXG4gICAgfSk7XG4gICAgLy8gVHdvIGVsZW1lbnRzIGNyZWF0ZWQgaW4gdHdvIGRpZmZlcmVudCBwbGFjZXMgc2hvdWxkIGJlIGNvbnNpZGVyZWRcbiAgICAvLyBlcXVhbCBmb3IgdGVzdGluZyBwdXJwb3NlcyBhbmQgdGhlcmVmb3JlIHdlIGhpZGUgaXQgZnJvbSBlbnVtZXJhdGlvbi5cbiAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkoZWxlbWVudCwgJ19zb3VyY2UnLCB7XG4gICAgICBjb25maWd1cmFibGU6IGZhbHNlLFxuICAgICAgZW51bWVyYWJsZTogZmFsc2UsXG4gICAgICB3cml0YWJsZTogZmFsc2UsXG4gICAgICB2YWx1ZTogc291cmNlXG4gICAgfSk7XG4gICAgaWYgKE9iamVjdC5mcmVlemUpIHtcbiAgICAgIE9iamVjdC5mcmVlemUoZWxlbWVudC5wcm9wcyk7XG4gICAgICBPYmplY3QuZnJlZXplKGVsZW1lbnQpO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBlbGVtZW50O1xufTtcblxuLyoqXG4gKiBDcmVhdGUgYW5kIHJldHVybiBhIG5ldyBSZWFjdEVsZW1lbnQgb2YgdGhlIGdpdmVuIHR5cGUuXG4gKiBTZWUgaHR0cHM6Ly9yZWFjdGpzLm9yZy9kb2NzL3JlYWN0LWFwaS5odG1sI2NyZWF0ZWVsZW1lbnRcbiAqL1xuZnVuY3Rpb24gY3JlYXRlRWxlbWVudCh0eXBlLCBjb25maWcsIGNoaWxkcmVuKSB7XG4gIHZhciBwcm9wTmFtZSA9IHZvaWQgMDtcblxuICAvLyBSZXNlcnZlZCBuYW1lcyBhcmUgZXh0cmFjdGVkXG4gIHZhciBwcm9wcyA9IHt9O1xuXG4gIHZhciBrZXkgPSBudWxsO1xuICB2YXIgcmVmID0gbnVsbDtcbiAgdmFyIHNlbGYgPSBudWxsO1xuICB2YXIgc291cmNlID0gbnVsbDtcblxuICBpZiAoY29uZmlnICE9IG51bGwpIHtcbiAgICBpZiAoaGFzVmFsaWRSZWYoY29uZmlnKSkge1xuICAgICAgcmVmID0gY29uZmlnLnJlZjtcbiAgICB9XG4gICAgaWYgKGhhc1ZhbGlkS2V5KGNvbmZpZykpIHtcbiAgICAgIGtleSA9ICcnICsgY29uZmlnLmtleTtcbiAgICB9XG5cbiAgICBzZWxmID0gY29uZmlnLl9fc2VsZiA9PT0gdW5kZWZpbmVkID8gbnVsbCA6IGNvbmZpZy5fX3NlbGY7XG4gICAgc291cmNlID0gY29uZmlnLl9fc291cmNlID09PSB1bmRlZmluZWQgPyBudWxsIDogY29uZmlnLl9fc291cmNlO1xuICAgIC8vIFJlbWFpbmluZyBwcm9wZXJ0aWVzIGFyZSBhZGRlZCB0byBhIG5ldyBwcm9wcyBvYmplY3RcbiAgICBmb3IgKHByb3BOYW1lIGluIGNvbmZpZykge1xuICAgICAgaWYgKGhhc093blByb3BlcnR5LmNhbGwoY29uZmlnLCBwcm9wTmFtZSkgJiYgIVJFU0VSVkVEX1BST1BTLmhhc093blByb3BlcnR5KHByb3BOYW1lKSkge1xuICAgICAgICBwcm9wc1twcm9wTmFtZV0gPSBjb25maWdbcHJvcE5hbWVdO1xuICAgICAgfVxuICAgIH1cbiAgfVxuXG4gIC8vIENoaWxkcmVuIGNhbiBiZSBtb3JlIHRoYW4gb25lIGFyZ3VtZW50LCBhbmQgdGhvc2UgYXJlIHRyYW5zZmVycmVkIG9udG9cbiAgLy8gdGhlIG5ld2x5IGFsbG9jYXRlZCBwcm9wcyBvYmplY3QuXG4gIHZhciBjaGlsZHJlbkxlbmd0aCA9IGFyZ3VtZW50cy5sZW5ndGggLSAyO1xuICBpZiAoY2hpbGRyZW5MZW5ndGggPT09IDEpIHtcbiAgICBwcm9wcy5jaGlsZHJlbiA9IGNoaWxkcmVuO1xuICB9IGVsc2UgaWYgKGNoaWxkcmVuTGVuZ3RoID4gMSkge1xuICAgIHZhciBjaGlsZEFycmF5ID0gQXJyYXkoY2hpbGRyZW5MZW5ndGgpO1xuICAgIGZvciAodmFyIGkgPSAwOyBpIDwgY2hpbGRyZW5MZW5ndGg7IGkrKykge1xuICAgICAgY2hpbGRBcnJheVtpXSA9IGFyZ3VtZW50c1tpICsgMl07XG4gICAgfVxuICAgIHtcbiAgICAgIGlmIChPYmplY3QuZnJlZXplKSB7XG4gICAgICAgIE9iamVjdC5mcmVlemUoY2hpbGRBcnJheSk7XG4gICAgICB9XG4gICAgfVxuICAgIHByb3BzLmNoaWxkcmVuID0gY2hpbGRBcnJheTtcbiAgfVxuXG4gIC8vIFJlc29sdmUgZGVmYXVsdCBwcm9wc1xuICBpZiAodHlwZSAmJiB0eXBlLmRlZmF1bHRQcm9wcykge1xuICAgIHZhciBkZWZhdWx0UHJvcHMgPSB0eXBlLmRlZmF1bHRQcm9wcztcbiAgICBmb3IgKHByb3BOYW1lIGluIGRlZmF1bHRQcm9wcykge1xuICAgICAgaWYgKHByb3BzW3Byb3BOYW1lXSA9PT0gdW5kZWZpbmVkKSB7XG4gICAgICAgIHByb3BzW3Byb3BOYW1lXSA9IGRlZmF1bHRQcm9wc1twcm9wTmFtZV07XG4gICAgICB9XG4gICAgfVxuICB9XG4gIHtcbiAgICBpZiAoa2V5IHx8IHJlZikge1xuICAgICAgdmFyIGRpc3BsYXlOYW1lID0gdHlwZW9mIHR5cGUgPT09ICdmdW5jdGlvbicgPyB0eXBlLmRpc3BsYXlOYW1lIHx8IHR5cGUubmFtZSB8fCAnVW5rbm93bicgOiB0eXBlO1xuICAgICAgaWYgKGtleSkge1xuICAgICAgICBkZWZpbmVLZXlQcm9wV2FybmluZ0dldHRlcihwcm9wcywgZGlzcGxheU5hbWUpO1xuICAgICAgfVxuICAgICAgaWYgKHJlZikge1xuICAgICAgICBkZWZpbmVSZWZQcm9wV2FybmluZ0dldHRlcihwcm9wcywgZGlzcGxheU5hbWUpO1xuICAgICAgfVxuICAgIH1cbiAgfVxuICByZXR1cm4gUmVhY3RFbGVtZW50KHR5cGUsIGtleSwgcmVmLCBzZWxmLCBzb3VyY2UsIFJlYWN0Q3VycmVudE93bmVyLmN1cnJlbnQsIHByb3BzKTtcbn1cblxuLyoqXG4gKiBSZXR1cm4gYSBmdW5jdGlvbiB0aGF0IHByb2R1Y2VzIFJlYWN0RWxlbWVudHMgb2YgYSBnaXZlbiB0eXBlLlxuICogU2VlIGh0dHBzOi8vcmVhY3Rqcy5vcmcvZG9jcy9yZWFjdC1hcGkuaHRtbCNjcmVhdGVmYWN0b3J5XG4gKi9cblxuXG5mdW5jdGlvbiBjbG9uZUFuZFJlcGxhY2VLZXkob2xkRWxlbWVudCwgbmV3S2V5KSB7XG4gIHZhciBuZXdFbGVtZW50ID0gUmVhY3RFbGVtZW50KG9sZEVsZW1lbnQudHlwZSwgbmV3S2V5LCBvbGRFbGVtZW50LnJlZiwgb2xkRWxlbWVudC5fc2VsZiwgb2xkRWxlbWVudC5fc291cmNlLCBvbGRFbGVtZW50Ll9vd25lciwgb2xkRWxlbWVudC5wcm9wcyk7XG5cbiAgcmV0dXJuIG5ld0VsZW1lbnQ7XG59XG5cbi8qKlxuICogQ2xvbmUgYW5kIHJldHVybiBhIG5ldyBSZWFjdEVsZW1lbnQgdXNpbmcgZWxlbWVudCBhcyB0aGUgc3RhcnRpbmcgcG9pbnQuXG4gKiBTZWUgaHR0cHM6Ly9yZWFjdGpzLm9yZy9kb2NzL3JlYWN0LWFwaS5odG1sI2Nsb25lZWxlbWVudFxuICovXG5mdW5jdGlvbiBjbG9uZUVsZW1lbnQoZWxlbWVudCwgY29uZmlnLCBjaGlsZHJlbikge1xuICAhIShlbGVtZW50ID09PSBudWxsIHx8IGVsZW1lbnQgPT09IHVuZGVmaW5lZCkgPyBpbnZhcmlhbnQoZmFsc2UsICdSZWFjdC5jbG9uZUVsZW1lbnQoLi4uKTogVGhlIGFyZ3VtZW50IG11c3QgYmUgYSBSZWFjdCBlbGVtZW50LCBidXQgeW91IHBhc3NlZCAlcy4nLCBlbGVtZW50KSA6IHZvaWQgMDtcblxuICB2YXIgcHJvcE5hbWUgPSB2b2lkIDA7XG5cbiAgLy8gT3JpZ2luYWwgcHJvcHMgYXJlIGNvcGllZFxuICB2YXIgcHJvcHMgPSBfYXNzaWduKHt9LCBlbGVtZW50LnByb3BzKTtcblxuICAvLyBSZXNlcnZlZCBuYW1lcyBhcmUgZXh0cmFjdGVkXG4gIHZhciBrZXkgPSBlbGVtZW50LmtleTtcbiAgdmFyIHJlZiA9IGVsZW1lbnQucmVmO1xuICAvLyBTZWxmIGlzIHByZXNlcnZlZCBzaW5jZSB0aGUgb3duZXIgaXMgcHJlc2VydmVkLlxuICB2YXIgc2VsZiA9IGVsZW1lbnQuX3NlbGY7XG4gIC8vIFNvdXJjZSBpcyBwcmVzZXJ2ZWQgc2luY2UgY2xvbmVFbGVtZW50IGlzIHVubGlrZWx5IHRvIGJlIHRhcmdldGVkIGJ5IGFcbiAgLy8gdHJhbnNwaWxlciwgYW5kIHRoZSBvcmlnaW5hbCBzb3VyY2UgaXMgcHJvYmFibHkgYSBiZXR0ZXIgaW5kaWNhdG9yIG9mIHRoZVxuICAvLyB0cnVlIG93bmVyLlxuICB2YXIgc291cmNlID0gZWxlbWVudC5fc291cmNlO1xuXG4gIC8vIE93bmVyIHdpbGwgYmUgcHJlc2VydmVkLCB1bmxlc3MgcmVmIGlzIG92ZXJyaWRkZW5cbiAgdmFyIG93bmVyID0gZWxlbWVudC5fb3duZXI7XG5cbiAgaWYgKGNvbmZpZyAhPSBudWxsKSB7XG4gICAgaWYgKGhhc1ZhbGlkUmVmKGNvbmZpZykpIHtcbiAgICAgIC8vIFNpbGVudGx5IHN0ZWFsIHRoZSByZWYgZnJvbSB0aGUgcGFyZW50LlxuICAgICAgcmVmID0gY29uZmlnLnJlZjtcbiAgICAgIG93bmVyID0gUmVhY3RDdXJyZW50T3duZXIuY3VycmVudDtcbiAgICB9XG4gICAgaWYgKGhhc1ZhbGlkS2V5KGNvbmZpZykpIHtcbiAgICAgIGtleSA9ICcnICsgY29uZmlnLmtleTtcbiAgICB9XG5cbiAgICAvLyBSZW1haW5pbmcgcHJvcGVydGllcyBvdmVycmlkZSBleGlzdGluZyBwcm9wc1xuICAgIHZhciBkZWZhdWx0UHJvcHMgPSB2b2lkIDA7XG4gICAgaWYgKGVsZW1lbnQudHlwZSAmJiBlbGVtZW50LnR5cGUuZGVmYXVsdFByb3BzKSB7XG4gICAgICBkZWZhdWx0UHJvcHMgPSBlbGVtZW50LnR5cGUuZGVmYXVsdFByb3BzO1xuICAgIH1cbiAgICBmb3IgKHByb3BOYW1lIGluIGNvbmZpZykge1xuICAgICAgaWYgKGhhc093blByb3BlcnR5LmNhbGwoY29uZmlnLCBwcm9wTmFtZSkgJiYgIVJFU0VSVkVEX1BST1BTLmhhc093blByb3BlcnR5KHByb3BOYW1lKSkge1xuICAgICAgICBpZiAoY29uZmlnW3Byb3BOYW1lXSA9PT0gdW5kZWZpbmVkICYmIGRlZmF1bHRQcm9wcyAhPT0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgLy8gUmVzb2x2ZSBkZWZhdWx0IHByb3BzXG4gICAgICAgICAgcHJvcHNbcHJvcE5hbWVdID0gZGVmYXVsdFByb3BzW3Byb3BOYW1lXTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICBwcm9wc1twcm9wTmFtZV0gPSBjb25maWdbcHJvcE5hbWVdO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuICB9XG5cbiAgLy8gQ2hpbGRyZW4gY2FuIGJlIG1vcmUgdGhhbiBvbmUgYXJndW1lbnQsIGFuZCB0aG9zZSBhcmUgdHJhbnNmZXJyZWQgb250b1xuICAvLyB0aGUgbmV3bHkgYWxsb2NhdGVkIHByb3BzIG9iamVjdC5cbiAgdmFyIGNoaWxkcmVuTGVuZ3RoID0gYXJndW1lbnRzLmxlbmd0aCAtIDI7XG4gIGlmIChjaGlsZHJlbkxlbmd0aCA9PT0gMSkge1xuICAgIHByb3BzLmNoaWxkcmVuID0gY2hpbGRyZW47XG4gIH0gZWxzZSBpZiAoY2hpbGRyZW5MZW5ndGggPiAxKSB7XG4gICAgdmFyIGNoaWxkQXJyYXkgPSBBcnJheShjaGlsZHJlbkxlbmd0aCk7XG4gICAgZm9yICh2YXIgaSA9IDA7IGkgPCBjaGlsZHJlbkxlbmd0aDsgaSsrKSB7XG4gICAgICBjaGlsZEFycmF5W2ldID0gYXJndW1lbnRzW2kgKyAyXTtcbiAgICB9XG4gICAgcHJvcHMuY2hpbGRyZW4gPSBjaGlsZEFycmF5O1xuICB9XG5cbiAgcmV0dXJuIFJlYWN0RWxlbWVudChlbGVtZW50LnR5cGUsIGtleSwgcmVmLCBzZWxmLCBzb3VyY2UsIG93bmVyLCBwcm9wcyk7XG59XG5cbi8qKlxuICogVmVyaWZpZXMgdGhlIG9iamVjdCBpcyBhIFJlYWN0RWxlbWVudC5cbiAqIFNlZSBodHRwczovL3JlYWN0anMub3JnL2RvY3MvcmVhY3QtYXBpLmh0bWwjaXN2YWxpZGVsZW1lbnRcbiAqIEBwYXJhbSB7P29iamVjdH0gb2JqZWN0XG4gKiBAcmV0dXJuIHtib29sZWFufSBUcnVlIGlmIGBvYmplY3RgIGlzIGEgUmVhY3RFbGVtZW50LlxuICogQGZpbmFsXG4gKi9cbmZ1bmN0aW9uIGlzVmFsaWRFbGVtZW50KG9iamVjdCkge1xuICByZXR1cm4gdHlwZW9mIG9iamVjdCA9PT0gJ29iamVjdCcgJiYgb2JqZWN0ICE9PSBudWxsICYmIG9iamVjdC4kJHR5cGVvZiA9PT0gUkVBQ1RfRUxFTUVOVF9UWVBFO1xufVxuXG52YXIgU0VQQVJBVE9SID0gJy4nO1xudmFyIFNVQlNFUEFSQVRPUiA9ICc6JztcblxuLyoqXG4gKiBFc2NhcGUgYW5kIHdyYXAga2V5IHNvIGl0IGlzIHNhZmUgdG8gdXNlIGFzIGEgcmVhY3RpZFxuICpcbiAqIEBwYXJhbSB7c3RyaW5nfSBrZXkgdG8gYmUgZXNjYXBlZC5cbiAqIEByZXR1cm4ge3N0cmluZ30gdGhlIGVzY2FwZWQga2V5LlxuICovXG5mdW5jdGlvbiBlc2NhcGUoa2V5KSB7XG4gIHZhciBlc2NhcGVSZWdleCA9IC9bPTpdL2c7XG4gIHZhciBlc2NhcGVyTG9va3VwID0ge1xuICAgICc9JzogJz0wJyxcbiAgICAnOic6ICc9MidcbiAgfTtcbiAgdmFyIGVzY2FwZWRTdHJpbmcgPSAoJycgKyBrZXkpLnJlcGxhY2UoZXNjYXBlUmVnZXgsIGZ1bmN0aW9uIChtYXRjaCkge1xuICAgIHJldHVybiBlc2NhcGVyTG9va3VwW21hdGNoXTtcbiAgfSk7XG5cbiAgcmV0dXJuICckJyArIGVzY2FwZWRTdHJpbmc7XG59XG5cbi8qKlxuICogVE9ETzogVGVzdCB0aGF0IGEgc2luZ2xlIGNoaWxkIGFuZCBhbiBhcnJheSB3aXRoIG9uZSBpdGVtIGhhdmUgdGhlIHNhbWUga2V5XG4gKiBwYXR0ZXJuLlxuICovXG5cbnZhciBkaWRXYXJuQWJvdXRNYXBzID0gZmFsc2U7XG5cbnZhciB1c2VyUHJvdmlkZWRLZXlFc2NhcGVSZWdleCA9IC9cXC8rL2c7XG5mdW5jdGlvbiBlc2NhcGVVc2VyUHJvdmlkZWRLZXkodGV4dCkge1xuICByZXR1cm4gKCcnICsgdGV4dCkucmVwbGFjZSh1c2VyUHJvdmlkZWRLZXlFc2NhcGVSZWdleCwgJyQmLycpO1xufVxuXG52YXIgUE9PTF9TSVpFID0gMTA7XG52YXIgdHJhdmVyc2VDb250ZXh0UG9vbCA9IFtdO1xuZnVuY3Rpb24gZ2V0UG9vbGVkVHJhdmVyc2VDb250ZXh0KG1hcFJlc3VsdCwga2V5UHJlZml4LCBtYXBGdW5jdGlvbiwgbWFwQ29udGV4dCkge1xuICBpZiAodHJhdmVyc2VDb250ZXh0UG9vbC5sZW5ndGgpIHtcbiAgICB2YXIgdHJhdmVyc2VDb250ZXh0ID0gdHJhdmVyc2VDb250ZXh0UG9vbC5wb3AoKTtcbiAgICB0cmF2ZXJzZUNvbnRleHQucmVzdWx0ID0gbWFwUmVzdWx0O1xuICAgIHRyYXZlcnNlQ29udGV4dC5rZXlQcmVmaXggPSBrZXlQcmVmaXg7XG4gICAgdHJhdmVyc2VDb250ZXh0LmZ1bmMgPSBtYXBGdW5jdGlvbjtcbiAgICB0cmF2ZXJzZUNvbnRleHQuY29udGV4dCA9IG1hcENvbnRleHQ7XG4gICAgdHJhdmVyc2VDb250ZXh0LmNvdW50ID0gMDtcbiAgICByZXR1cm4gdHJhdmVyc2VDb250ZXh0O1xuICB9IGVsc2Uge1xuICAgIHJldHVybiB7XG4gICAgICByZXN1bHQ6IG1hcFJlc3VsdCxcbiAgICAgIGtleVByZWZpeDoga2V5UHJlZml4LFxuICAgICAgZnVuYzogbWFwRnVuY3Rpb24sXG4gICAgICBjb250ZXh0OiBtYXBDb250ZXh0LFxuICAgICAgY291bnQ6IDBcbiAgICB9O1xuICB9XG59XG5cbmZ1bmN0aW9uIHJlbGVhc2VUcmF2ZXJzZUNvbnRleHQodHJhdmVyc2VDb250ZXh0KSB7XG4gIHRyYXZlcnNlQ29udGV4dC5yZXN1bHQgPSBudWxsO1xuICB0cmF2ZXJzZUNvbnRleHQua2V5UHJlZml4ID0gbnVsbDtcbiAgdHJhdmVyc2VDb250ZXh0LmZ1bmMgPSBudWxsO1xuICB0cmF2ZXJzZUNvbnRleHQuY29udGV4dCA9IG51bGw7XG4gIHRyYXZlcnNlQ29udGV4dC5jb3VudCA9IDA7XG4gIGlmICh0cmF2ZXJzZUNvbnRleHRQb29sLmxlbmd0aCA8IFBPT0xfU0laRSkge1xuICAgIHRyYXZlcnNlQ29udGV4dFBvb2wucHVzaCh0cmF2ZXJzZUNvbnRleHQpO1xuICB9XG59XG5cbi8qKlxuICogQHBhcmFtIHs/Kn0gY2hpbGRyZW4gQ2hpbGRyZW4gdHJlZSBjb250YWluZXIuXG4gKiBAcGFyYW0geyFzdHJpbmd9IG5hbWVTb0ZhciBOYW1lIG9mIHRoZSBrZXkgcGF0aCBzbyBmYXIuXG4gKiBAcGFyYW0geyFmdW5jdGlvbn0gY2FsbGJhY2sgQ2FsbGJhY2sgdG8gaW52b2tlIHdpdGggZWFjaCBjaGlsZCBmb3VuZC5cbiAqIEBwYXJhbSB7Pyp9IHRyYXZlcnNlQ29udGV4dCBVc2VkIHRvIHBhc3MgaW5mb3JtYXRpb24gdGhyb3VnaG91dCB0aGUgdHJhdmVyc2FsXG4gKiBwcm9jZXNzLlxuICogQHJldHVybiB7IW51bWJlcn0gVGhlIG51bWJlciBvZiBjaGlsZHJlbiBpbiB0aGlzIHN1YnRyZWUuXG4gKi9cbmZ1bmN0aW9uIHRyYXZlcnNlQWxsQ2hpbGRyZW5JbXBsKGNoaWxkcmVuLCBuYW1lU29GYXIsIGNhbGxiYWNrLCB0cmF2ZXJzZUNvbnRleHQpIHtcbiAgdmFyIHR5cGUgPSB0eXBlb2YgY2hpbGRyZW47XG5cbiAgaWYgKHR5cGUgPT09ICd1bmRlZmluZWQnIHx8IHR5cGUgPT09ICdib29sZWFuJykge1xuICAgIC8vIEFsbCBvZiB0aGUgYWJvdmUgYXJlIHBlcmNlaXZlZCBhcyBudWxsLlxuICAgIGNoaWxkcmVuID0gbnVsbDtcbiAgfVxuXG4gIHZhciBpbnZva2VDYWxsYmFjayA9IGZhbHNlO1xuXG4gIGlmIChjaGlsZHJlbiA9PT0gbnVsbCkge1xuICAgIGludm9rZUNhbGxiYWNrID0gdHJ1ZTtcbiAgfSBlbHNlIHtcbiAgICBzd2l0Y2ggKHR5cGUpIHtcbiAgICAgIGNhc2UgJ3N0cmluZyc6XG4gICAgICBjYXNlICdudW1iZXInOlxuICAgICAgICBpbnZva2VDYWxsYmFjayA9IHRydWU7XG4gICAgICAgIGJyZWFrO1xuICAgICAgY2FzZSAnb2JqZWN0JzpcbiAgICAgICAgc3dpdGNoIChjaGlsZHJlbi4kJHR5cGVvZikge1xuICAgICAgICAgIGNhc2UgUkVBQ1RfRUxFTUVOVF9UWVBFOlxuICAgICAgICAgIGNhc2UgUkVBQ1RfUE9SVEFMX1RZUEU6XG4gICAgICAgICAgICBpbnZva2VDYWxsYmFjayA9IHRydWU7XG4gICAgICAgIH1cbiAgICB9XG4gIH1cblxuICBpZiAoaW52b2tlQ2FsbGJhY2spIHtcbiAgICBjYWxsYmFjayh0cmF2ZXJzZUNvbnRleHQsIGNoaWxkcmVuLFxuICAgIC8vIElmIGl0J3MgdGhlIG9ubHkgY2hpbGQsIHRyZWF0IHRoZSBuYW1lIGFzIGlmIGl0IHdhcyB3cmFwcGVkIGluIGFuIGFycmF5XG4gICAgLy8gc28gdGhhdCBpdCdzIGNvbnNpc3RlbnQgaWYgdGhlIG51bWJlciBvZiBjaGlsZHJlbiBncm93cy5cbiAgICBuYW1lU29GYXIgPT09ICcnID8gU0VQQVJBVE9SICsgZ2V0Q29tcG9uZW50S2V5KGNoaWxkcmVuLCAwKSA6IG5hbWVTb0Zhcik7XG4gICAgcmV0dXJuIDE7XG4gIH1cblxuICB2YXIgY2hpbGQgPSB2b2lkIDA7XG4gIHZhciBuZXh0TmFtZSA9IHZvaWQgMDtcbiAgdmFyIHN1YnRyZWVDb3VudCA9IDA7IC8vIENvdW50IG9mIGNoaWxkcmVuIGZvdW5kIGluIHRoZSBjdXJyZW50IHN1YnRyZWUuXG4gIHZhciBuZXh0TmFtZVByZWZpeCA9IG5hbWVTb0ZhciA9PT0gJycgPyBTRVBBUkFUT1IgOiBuYW1lU29GYXIgKyBTVUJTRVBBUkFUT1I7XG5cbiAgaWYgKEFycmF5LmlzQXJyYXkoY2hpbGRyZW4pKSB7XG4gICAgZm9yICh2YXIgaSA9IDA7IGkgPCBjaGlsZHJlbi5sZW5ndGg7IGkrKykge1xuICAgICAgY2hpbGQgPSBjaGlsZHJlbltpXTtcbiAgICAgIG5leHROYW1lID0gbmV4dE5hbWVQcmVmaXggKyBnZXRDb21wb25lbnRLZXkoY2hpbGQsIGkpO1xuICAgICAgc3VidHJlZUNvdW50ICs9IHRyYXZlcnNlQWxsQ2hpbGRyZW5JbXBsKGNoaWxkLCBuZXh0TmFtZSwgY2FsbGJhY2ssIHRyYXZlcnNlQ29udGV4dCk7XG4gICAgfVxuICB9IGVsc2Uge1xuICAgIHZhciBpdGVyYXRvckZuID0gZ2V0SXRlcmF0b3JGbihjaGlsZHJlbik7XG4gICAgaWYgKHR5cGVvZiBpdGVyYXRvckZuID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICB7XG4gICAgICAgIC8vIFdhcm4gYWJvdXQgdXNpbmcgTWFwcyBhcyBjaGlsZHJlblxuICAgICAgICBpZiAoaXRlcmF0b3JGbiA9PT0gY2hpbGRyZW4uZW50cmllcykge1xuICAgICAgICAgICFkaWRXYXJuQWJvdXRNYXBzID8gd2FybmluZyQxKGZhbHNlLCAnVXNpbmcgTWFwcyBhcyBjaGlsZHJlbiBpcyB1bnN1cHBvcnRlZCBhbmQgd2lsbCBsaWtlbHkgeWllbGQgJyArICd1bmV4cGVjdGVkIHJlc3VsdHMuIENvbnZlcnQgaXQgdG8gYSBzZXF1ZW5jZS9pdGVyYWJsZSBvZiBrZXllZCAnICsgJ1JlYWN0RWxlbWVudHMgaW5zdGVhZC4nKSA6IHZvaWQgMDtcbiAgICAgICAgICBkaWRXYXJuQWJvdXRNYXBzID0gdHJ1ZTtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICB2YXIgaXRlcmF0b3IgPSBpdGVyYXRvckZuLmNhbGwoY2hpbGRyZW4pO1xuICAgICAgdmFyIHN0ZXAgPSB2b2lkIDA7XG4gICAgICB2YXIgaWkgPSAwO1xuICAgICAgd2hpbGUgKCEoc3RlcCA9IGl0ZXJhdG9yLm5leHQoKSkuZG9uZSkge1xuICAgICAgICBjaGlsZCA9IHN0ZXAudmFsdWU7XG4gICAgICAgIG5leHROYW1lID0gbmV4dE5hbWVQcmVmaXggKyBnZXRDb21wb25lbnRLZXkoY2hpbGQsIGlpKyspO1xuICAgICAgICBzdWJ0cmVlQ291bnQgKz0gdHJhdmVyc2VBbGxDaGlsZHJlbkltcGwoY2hpbGQsIG5leHROYW1lLCBjYWxsYmFjaywgdHJhdmVyc2VDb250ZXh0KTtcbiAgICAgIH1cbiAgICB9IGVsc2UgaWYgKHR5cGUgPT09ICdvYmplY3QnKSB7XG4gICAgICB2YXIgYWRkZW5kdW0gPSAnJztcbiAgICAgIHtcbiAgICAgICAgYWRkZW5kdW0gPSAnIElmIHlvdSBtZWFudCB0byByZW5kZXIgYSBjb2xsZWN0aW9uIG9mIGNoaWxkcmVuLCB1c2UgYW4gYXJyYXkgJyArICdpbnN0ZWFkLicgKyBSZWFjdERlYnVnQ3VycmVudEZyYW1lLmdldFN0YWNrQWRkZW5kdW0oKTtcbiAgICAgIH1cbiAgICAgIHZhciBjaGlsZHJlblN0cmluZyA9ICcnICsgY2hpbGRyZW47XG4gICAgICBpbnZhcmlhbnQoZmFsc2UsICdPYmplY3RzIGFyZSBub3QgdmFsaWQgYXMgYSBSZWFjdCBjaGlsZCAoZm91bmQ6ICVzKS4lcycsIGNoaWxkcmVuU3RyaW5nID09PSAnW29iamVjdCBPYmplY3RdJyA/ICdvYmplY3Qgd2l0aCBrZXlzIHsnICsgT2JqZWN0LmtleXMoY2hpbGRyZW4pLmpvaW4oJywgJykgKyAnfScgOiBjaGlsZHJlblN0cmluZywgYWRkZW5kdW0pO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBzdWJ0cmVlQ291bnQ7XG59XG5cbi8qKlxuICogVHJhdmVyc2VzIGNoaWxkcmVuIHRoYXQgYXJlIHR5cGljYWxseSBzcGVjaWZpZWQgYXMgYHByb3BzLmNoaWxkcmVuYCwgYnV0XG4gKiBtaWdodCBhbHNvIGJlIHNwZWNpZmllZCB0aHJvdWdoIGF0dHJpYnV0ZXM6XG4gKlxuICogLSBgdHJhdmVyc2VBbGxDaGlsZHJlbih0aGlzLnByb3BzLmNoaWxkcmVuLCAuLi4pYFxuICogLSBgdHJhdmVyc2VBbGxDaGlsZHJlbih0aGlzLnByb3BzLmxlZnRQYW5lbENoaWxkcmVuLCAuLi4pYFxuICpcbiAqIFRoZSBgdHJhdmVyc2VDb250ZXh0YCBpcyBhbiBvcHRpb25hbCBhcmd1bWVudCB0aGF0IGlzIHBhc3NlZCB0aHJvdWdoIHRoZVxuICogZW50aXJlIHRyYXZlcnNhbC4gSXQgY2FuIGJlIHVzZWQgdG8gc3RvcmUgYWNjdW11bGF0aW9ucyBvciBhbnl0aGluZyBlbHNlIHRoYXRcbiAqIHRoZSBjYWxsYmFjayBtaWdodCBmaW5kIHJlbGV2YW50LlxuICpcbiAqIEBwYXJhbSB7Pyp9IGNoaWxkcmVuIENoaWxkcmVuIHRyZWUgb2JqZWN0LlxuICogQHBhcmFtIHshZnVuY3Rpb259IGNhbGxiYWNrIFRvIGludm9rZSB1cG9uIHRyYXZlcnNpbmcgZWFjaCBjaGlsZC5cbiAqIEBwYXJhbSB7Pyp9IHRyYXZlcnNlQ29udGV4dCBDb250ZXh0IGZvciB0cmF2ZXJzYWwuXG4gKiBAcmV0dXJuIHshbnVtYmVyfSBUaGUgbnVtYmVyIG9mIGNoaWxkcmVuIGluIHRoaXMgc3VidHJlZS5cbiAqL1xuZnVuY3Rpb24gdHJhdmVyc2VBbGxDaGlsZHJlbihjaGlsZHJlbiwgY2FsbGJhY2ssIHRyYXZlcnNlQ29udGV4dCkge1xuICBpZiAoY2hpbGRyZW4gPT0gbnVsbCkge1xuICAgIHJldHVybiAwO1xuICB9XG5cbiAgcmV0dXJuIHRyYXZlcnNlQWxsQ2hpbGRyZW5JbXBsKGNoaWxkcmVuLCAnJywgY2FsbGJhY2ssIHRyYXZlcnNlQ29udGV4dCk7XG59XG5cbi8qKlxuICogR2VuZXJhdGUgYSBrZXkgc3RyaW5nIHRoYXQgaWRlbnRpZmllcyBhIGNvbXBvbmVudCB3aXRoaW4gYSBzZXQuXG4gKlxuICogQHBhcmFtIHsqfSBjb21wb25lbnQgQSBjb21wb25lbnQgdGhhdCBjb3VsZCBjb250YWluIGEgbWFudWFsIGtleS5cbiAqIEBwYXJhbSB7bnVtYmVyfSBpbmRleCBJbmRleCB0aGF0IGlzIHVzZWQgaWYgYSBtYW51YWwga2V5IGlzIG5vdCBwcm92aWRlZC5cbiAqIEByZXR1cm4ge3N0cmluZ31cbiAqL1xuZnVuY3Rpb24gZ2V0Q29tcG9uZW50S2V5KGNvbXBvbmVudCwgaW5kZXgpIHtcbiAgLy8gRG8gc29tZSB0eXBlY2hlY2tpbmcgaGVyZSBzaW5jZSB3ZSBjYWxsIHRoaXMgYmxpbmRseS4gV2Ugd2FudCB0byBlbnN1cmVcbiAgLy8gdGhhdCB3ZSBkb24ndCBibG9jayBwb3RlbnRpYWwgZnV0dXJlIEVTIEFQSXMuXG4gIGlmICh0eXBlb2YgY29tcG9uZW50ID09PSAnb2JqZWN0JyAmJiBjb21wb25lbnQgIT09IG51bGwgJiYgY29tcG9uZW50LmtleSAhPSBudWxsKSB7XG4gICAgLy8gRXhwbGljaXQga2V5XG4gICAgcmV0dXJuIGVzY2FwZShjb21wb25lbnQua2V5KTtcbiAgfVxuICAvLyBJbXBsaWNpdCBrZXkgZGV0ZXJtaW5lZCBieSB0aGUgaW5kZXggaW4gdGhlIHNldFxuICByZXR1cm4gaW5kZXgudG9TdHJpbmcoMzYpO1xufVxuXG5mdW5jdGlvbiBmb3JFYWNoU2luZ2xlQ2hpbGQoYm9va0tlZXBpbmcsIGNoaWxkLCBuYW1lKSB7XG4gIHZhciBmdW5jID0gYm9va0tlZXBpbmcuZnVuYyxcbiAgICAgIGNvbnRleHQgPSBib29rS2VlcGluZy5jb250ZXh0O1xuXG4gIGZ1bmMuY2FsbChjb250ZXh0LCBjaGlsZCwgYm9va0tlZXBpbmcuY291bnQrKyk7XG59XG5cbi8qKlxuICogSXRlcmF0ZXMgdGhyb3VnaCBjaGlsZHJlbiB0aGF0IGFyZSB0eXBpY2FsbHkgc3BlY2lmaWVkIGFzIGBwcm9wcy5jaGlsZHJlbmAuXG4gKlxuICogU2VlIGh0dHBzOi8vcmVhY3Rqcy5vcmcvZG9jcy9yZWFjdC1hcGkuaHRtbCNyZWFjdGNoaWxkcmVuZm9yZWFjaFxuICpcbiAqIFRoZSBwcm92aWRlZCBmb3JFYWNoRnVuYyhjaGlsZCwgaW5kZXgpIHdpbGwgYmUgY2FsbGVkIGZvciBlYWNoXG4gKiBsZWFmIGNoaWxkLlxuICpcbiAqIEBwYXJhbSB7Pyp9IGNoaWxkcmVuIENoaWxkcmVuIHRyZWUgY29udGFpbmVyLlxuICogQHBhcmFtIHtmdW5jdGlvbigqLCBpbnQpfSBmb3JFYWNoRnVuY1xuICogQHBhcmFtIHsqfSBmb3JFYWNoQ29udGV4dCBDb250ZXh0IGZvciBmb3JFYWNoQ29udGV4dC5cbiAqL1xuZnVuY3Rpb24gZm9yRWFjaENoaWxkcmVuKGNoaWxkcmVuLCBmb3JFYWNoRnVuYywgZm9yRWFjaENvbnRleHQpIHtcbiAgaWYgKGNoaWxkcmVuID09IG51bGwpIHtcbiAgICByZXR1cm4gY2hpbGRyZW47XG4gIH1cbiAgdmFyIHRyYXZlcnNlQ29udGV4dCA9IGdldFBvb2xlZFRyYXZlcnNlQ29udGV4dChudWxsLCBudWxsLCBmb3JFYWNoRnVuYywgZm9yRWFjaENvbnRleHQpO1xuICB0cmF2ZXJzZUFsbENoaWxkcmVuKGNoaWxkcmVuLCBmb3JFYWNoU2luZ2xlQ2hpbGQsIHRyYXZlcnNlQ29udGV4dCk7XG4gIHJlbGVhc2VUcmF2ZXJzZUNvbnRleHQodHJhdmVyc2VDb250ZXh0KTtcbn1cblxuZnVuY3Rpb24gbWFwU2luZ2xlQ2hpbGRJbnRvQ29udGV4dChib29rS2VlcGluZywgY2hpbGQsIGNoaWxkS2V5KSB7XG4gIHZhciByZXN1bHQgPSBib29rS2VlcGluZy5yZXN1bHQsXG4gICAgICBrZXlQcmVmaXggPSBib29rS2VlcGluZy5rZXlQcmVmaXgsXG4gICAgICBmdW5jID0gYm9va0tlZXBpbmcuZnVuYyxcbiAgICAgIGNvbnRleHQgPSBib29rS2VlcGluZy5jb250ZXh0O1xuXG5cbiAgdmFyIG1hcHBlZENoaWxkID0gZnVuYy5jYWxsKGNvbnRleHQsIGNoaWxkLCBib29rS2VlcGluZy5jb3VudCsrKTtcbiAgaWYgKEFycmF5LmlzQXJyYXkobWFwcGVkQ2hpbGQpKSB7XG4gICAgbWFwSW50b1dpdGhLZXlQcmVmaXhJbnRlcm5hbChtYXBwZWRDaGlsZCwgcmVzdWx0LCBjaGlsZEtleSwgZnVuY3Rpb24gKGMpIHtcbiAgICAgIHJldHVybiBjO1xuICAgIH0pO1xuICB9IGVsc2UgaWYgKG1hcHBlZENoaWxkICE9IG51bGwpIHtcbiAgICBpZiAoaXNWYWxpZEVsZW1lbnQobWFwcGVkQ2hpbGQpKSB7XG4gICAgICBtYXBwZWRDaGlsZCA9IGNsb25lQW5kUmVwbGFjZUtleShtYXBwZWRDaGlsZCxcbiAgICAgIC8vIEtlZXAgYm90aCB0aGUgKG1hcHBlZCkgYW5kIG9sZCBrZXlzIGlmIHRoZXkgZGlmZmVyLCBqdXN0IGFzXG4gICAgICAvLyB0cmF2ZXJzZUFsbENoaWxkcmVuIHVzZWQgdG8gZG8gZm9yIG9iamVjdHMgYXMgY2hpbGRyZW5cbiAgICAgIGtleVByZWZpeCArIChtYXBwZWRDaGlsZC5rZXkgJiYgKCFjaGlsZCB8fCBjaGlsZC5rZXkgIT09IG1hcHBlZENoaWxkLmtleSkgPyBlc2NhcGVVc2VyUHJvdmlkZWRLZXkobWFwcGVkQ2hpbGQua2V5KSArICcvJyA6ICcnKSArIGNoaWxkS2V5KTtcbiAgICB9XG4gICAgcmVzdWx0LnB1c2gobWFwcGVkQ2hpbGQpO1xuICB9XG59XG5cbmZ1bmN0aW9uIG1hcEludG9XaXRoS2V5UHJlZml4SW50ZXJuYWwoY2hpbGRyZW4sIGFycmF5LCBwcmVmaXgsIGZ1bmMsIGNvbnRleHQpIHtcbiAgdmFyIGVzY2FwZWRQcmVmaXggPSAnJztcbiAgaWYgKHByZWZpeCAhPSBudWxsKSB7XG4gICAgZXNjYXBlZFByZWZpeCA9IGVzY2FwZVVzZXJQcm92aWRlZEtleShwcmVmaXgpICsgJy8nO1xuICB9XG4gIHZhciB0cmF2ZXJzZUNvbnRleHQgPSBnZXRQb29sZWRUcmF2ZXJzZUNvbnRleHQoYXJyYXksIGVzY2FwZWRQcmVmaXgsIGZ1bmMsIGNvbnRleHQpO1xuICB0cmF2ZXJzZUFsbENoaWxkcmVuKGNoaWxkcmVuLCBtYXBTaW5nbGVDaGlsZEludG9Db250ZXh0LCB0cmF2ZXJzZUNvbnRleHQpO1xuICByZWxlYXNlVHJhdmVyc2VDb250ZXh0KHRyYXZlcnNlQ29udGV4dCk7XG59XG5cbi8qKlxuICogTWFwcyBjaGlsZHJlbiB0aGF0IGFyZSB0eXBpY2FsbHkgc3BlY2lmaWVkIGFzIGBwcm9wcy5jaGlsZHJlbmAuXG4gKlxuICogU2VlIGh0dHBzOi8vcmVhY3Rqcy5vcmcvZG9jcy9yZWFjdC1hcGkuaHRtbCNyZWFjdGNoaWxkcmVubWFwXG4gKlxuICogVGhlIHByb3ZpZGVkIG1hcEZ1bmN0aW9uKGNoaWxkLCBrZXksIGluZGV4KSB3aWxsIGJlIGNhbGxlZCBmb3IgZWFjaFxuICogbGVhZiBjaGlsZC5cbiAqXG4gKiBAcGFyYW0gez8qfSBjaGlsZHJlbiBDaGlsZHJlbiB0cmVlIGNvbnRhaW5lci5cbiAqIEBwYXJhbSB7ZnVuY3Rpb24oKiwgaW50KX0gZnVuYyBUaGUgbWFwIGZ1bmN0aW9uLlxuICogQHBhcmFtIHsqfSBjb250ZXh0IENvbnRleHQgZm9yIG1hcEZ1bmN0aW9uLlxuICogQHJldHVybiB7b2JqZWN0fSBPYmplY3QgY29udGFpbmluZyB0aGUgb3JkZXJlZCBtYXAgb2YgcmVzdWx0cy5cbiAqL1xuZnVuY3Rpb24gbWFwQ2hpbGRyZW4oY2hpbGRyZW4sIGZ1bmMsIGNvbnRleHQpIHtcbiAgaWYgKGNoaWxkcmVuID09IG51bGwpIHtcbiAgICByZXR1cm4gY2hpbGRyZW47XG4gIH1cbiAgdmFyIHJlc3VsdCA9IFtdO1xuICBtYXBJbnRvV2l0aEtleVByZWZpeEludGVybmFsKGNoaWxkcmVuLCByZXN1bHQsIG51bGwsIGZ1bmMsIGNvbnRleHQpO1xuICByZXR1cm4gcmVzdWx0O1xufVxuXG4vKipcbiAqIENvdW50IHRoZSBudW1iZXIgb2YgY2hpbGRyZW4gdGhhdCBhcmUgdHlwaWNhbGx5IHNwZWNpZmllZCBhc1xuICogYHByb3BzLmNoaWxkcmVuYC5cbiAqXG4gKiBTZWUgaHR0cHM6Ly9yZWFjdGpzLm9yZy9kb2NzL3JlYWN0LWFwaS5odG1sI3JlYWN0Y2hpbGRyZW5jb3VudFxuICpcbiAqIEBwYXJhbSB7Pyp9IGNoaWxkcmVuIENoaWxkcmVuIHRyZWUgY29udGFpbmVyLlxuICogQHJldHVybiB7bnVtYmVyfSBUaGUgbnVtYmVyIG9mIGNoaWxkcmVuLlxuICovXG5mdW5jdGlvbiBjb3VudENoaWxkcmVuKGNoaWxkcmVuKSB7XG4gIHJldHVybiB0cmF2ZXJzZUFsbENoaWxkcmVuKGNoaWxkcmVuLCBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIG51bGw7XG4gIH0sIG51bGwpO1xufVxuXG4vKipcbiAqIEZsYXR0ZW4gYSBjaGlsZHJlbiBvYmplY3QgKHR5cGljYWxseSBzcGVjaWZpZWQgYXMgYHByb3BzLmNoaWxkcmVuYCkgYW5kXG4gKiByZXR1cm4gYW4gYXJyYXkgd2l0aCBhcHByb3ByaWF0ZWx5IHJlLWtleWVkIGNoaWxkcmVuLlxuICpcbiAqIFNlZSBodHRwczovL3JlYWN0anMub3JnL2RvY3MvcmVhY3QtYXBpLmh0bWwjcmVhY3RjaGlsZHJlbnRvYXJyYXlcbiAqL1xuZnVuY3Rpb24gdG9BcnJheShjaGlsZHJlbikge1xuICB2YXIgcmVzdWx0ID0gW107XG4gIG1hcEludG9XaXRoS2V5UHJlZml4SW50ZXJuYWwoY2hpbGRyZW4sIHJlc3VsdCwgbnVsbCwgZnVuY3Rpb24gKGNoaWxkKSB7XG4gICAgcmV0dXJuIGNoaWxkO1xuICB9KTtcbiAgcmV0dXJuIHJlc3VsdDtcbn1cblxuLyoqXG4gKiBSZXR1cm5zIHRoZSBmaXJzdCBjaGlsZCBpbiBhIGNvbGxlY3Rpb24gb2YgY2hpbGRyZW4gYW5kIHZlcmlmaWVzIHRoYXQgdGhlcmVcbiAqIGlzIG9ubHkgb25lIGNoaWxkIGluIHRoZSBjb2xsZWN0aW9uLlxuICpcbiAqIFNlZSBodHRwczovL3JlYWN0anMub3JnL2RvY3MvcmVhY3QtYXBpLmh0bWwjcmVhY3RjaGlsZHJlbm9ubHlcbiAqXG4gKiBUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBvZiB0aGlzIGZ1bmN0aW9uIGFzc3VtZXMgdGhhdCBhIHNpbmdsZSBjaGlsZCBnZXRzXG4gKiBwYXNzZWQgd2l0aG91dCBhIHdyYXBwZXIsIGJ1dCB0aGUgcHVycG9zZSBvZiB0aGlzIGhlbHBlciBmdW5jdGlvbiBpcyB0b1xuICogYWJzdHJhY3QgYXdheSB0aGUgcGFydGljdWxhciBzdHJ1Y3R1cmUgb2YgY2hpbGRyZW4uXG4gKlxuICogQHBhcmFtIHs/b2JqZWN0fSBjaGlsZHJlbiBDaGlsZCBjb2xsZWN0aW9uIHN0cnVjdHVyZS5cbiAqIEByZXR1cm4ge1JlYWN0RWxlbWVudH0gVGhlIGZpcnN0IGFuZCBvbmx5IGBSZWFjdEVsZW1lbnRgIGNvbnRhaW5lZCBpbiB0aGVcbiAqIHN0cnVjdHVyZS5cbiAqL1xuZnVuY3Rpb24gb25seUNoaWxkKGNoaWxkcmVuKSB7XG4gICFpc1ZhbGlkRWxlbWVudChjaGlsZHJlbikgPyBpbnZhcmlhbnQoZmFsc2UsICdSZWFjdC5DaGlsZHJlbi5vbmx5IGV4cGVjdGVkIHRvIHJlY2VpdmUgYSBzaW5nbGUgUmVhY3QgZWxlbWVudCBjaGlsZC4nKSA6IHZvaWQgMDtcbiAgcmV0dXJuIGNoaWxkcmVuO1xufVxuXG5mdW5jdGlvbiBjcmVhdGVDb250ZXh0KGRlZmF1bHRWYWx1ZSwgY2FsY3VsYXRlQ2hhbmdlZEJpdHMpIHtcbiAgaWYgKGNhbGN1bGF0ZUNoYW5nZWRCaXRzID09PSB1bmRlZmluZWQpIHtcbiAgICBjYWxjdWxhdGVDaGFuZ2VkQml0cyA9IG51bGw7XG4gIH0gZWxzZSB7XG4gICAge1xuICAgICAgIShjYWxjdWxhdGVDaGFuZ2VkQml0cyA9PT0gbnVsbCB8fCB0eXBlb2YgY2FsY3VsYXRlQ2hhbmdlZEJpdHMgPT09ICdmdW5jdGlvbicpID8gd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnY3JlYXRlQ29udGV4dDogRXhwZWN0ZWQgdGhlIG9wdGlvbmFsIHNlY29uZCBhcmd1bWVudCB0byBiZSBhICcgKyAnZnVuY3Rpb24uIEluc3RlYWQgcmVjZWl2ZWQ6ICVzJywgY2FsY3VsYXRlQ2hhbmdlZEJpdHMpIDogdm9pZCAwO1xuICAgIH1cbiAgfVxuXG4gIHZhciBjb250ZXh0ID0ge1xuICAgICQkdHlwZW9mOiBSRUFDVF9DT05URVhUX1RZUEUsXG4gICAgX2NhbGN1bGF0ZUNoYW5nZWRCaXRzOiBjYWxjdWxhdGVDaGFuZ2VkQml0cyxcbiAgICAvLyBBcyBhIHdvcmthcm91bmQgdG8gc3VwcG9ydCBtdWx0aXBsZSBjb25jdXJyZW50IHJlbmRlcmVycywgd2UgY2F0ZWdvcml6ZVxuICAgIC8vIHNvbWUgcmVuZGVyZXJzIGFzIHByaW1hcnkgYW5kIG90aGVycyBhcyBzZWNvbmRhcnkuIFdlIG9ubHkgZXhwZWN0XG4gICAgLy8gdGhlcmUgdG8gYmUgdHdvIGNvbmN1cnJlbnQgcmVuZGVyZXJzIGF0IG1vc3Q6IFJlYWN0IE5hdGl2ZSAocHJpbWFyeSkgYW5kXG4gICAgLy8gRmFicmljIChzZWNvbmRhcnkpOyBSZWFjdCBET00gKHByaW1hcnkpIGFuZCBSZWFjdCBBUlQgKHNlY29uZGFyeSkuXG4gICAgLy8gU2Vjb25kYXJ5IHJlbmRlcmVycyBzdG9yZSB0aGVpciBjb250ZXh0IHZhbHVlcyBvbiBzZXBhcmF0ZSBmaWVsZHMuXG4gICAgX2N1cnJlbnRWYWx1ZTogZGVmYXVsdFZhbHVlLFxuICAgIF9jdXJyZW50VmFsdWUyOiBkZWZhdWx0VmFsdWUsXG4gICAgLy8gVXNlZCB0byB0cmFjayBob3cgbWFueSBjb25jdXJyZW50IHJlbmRlcmVycyB0aGlzIGNvbnRleHQgY3VycmVudGx5XG4gICAgLy8gc3VwcG9ydHMgd2l0aGluIGluIGEgc2luZ2xlIHJlbmRlcmVyLiBTdWNoIGFzIHBhcmFsbGVsIHNlcnZlciByZW5kZXJpbmcuXG4gICAgX3RocmVhZENvdW50OiAwLFxuICAgIC8vIFRoZXNlIGFyZSBjaXJjdWxhclxuICAgIFByb3ZpZGVyOiBudWxsLFxuICAgIENvbnN1bWVyOiBudWxsXG4gIH07XG5cbiAgY29udGV4dC5Qcm92aWRlciA9IHtcbiAgICAkJHR5cGVvZjogUkVBQ1RfUFJPVklERVJfVFlQRSxcbiAgICBfY29udGV4dDogY29udGV4dFxuICB9O1xuXG4gIHZhciBoYXNXYXJuZWRBYm91dFVzaW5nTmVzdGVkQ29udGV4dENvbnN1bWVycyA9IGZhbHNlO1xuICB2YXIgaGFzV2FybmVkQWJvdXRVc2luZ0NvbnN1bWVyUHJvdmlkZXIgPSBmYWxzZTtcblxuICB7XG4gICAgLy8gQSBzZXBhcmF0ZSBvYmplY3QsIGJ1dCBwcm94aWVzIGJhY2sgdG8gdGhlIG9yaWdpbmFsIGNvbnRleHQgb2JqZWN0IGZvclxuICAgIC8vIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5LiBJdCBoYXMgYSBkaWZmZXJlbnQgJCR0eXBlb2YsIHNvIHdlIGNhbiBwcm9wZXJseVxuICAgIC8vIHdhcm4gZm9yIHRoZSBpbmNvcnJlY3QgdXNhZ2Ugb2YgQ29udGV4dCBhcyBhIENvbnN1bWVyLlxuICAgIHZhciBDb25zdW1lciA9IHtcbiAgICAgICQkdHlwZW9mOiBSRUFDVF9DT05URVhUX1RZUEUsXG4gICAgICBfY29udGV4dDogY29udGV4dCxcbiAgICAgIF9jYWxjdWxhdGVDaGFuZ2VkQml0czogY29udGV4dC5fY2FsY3VsYXRlQ2hhbmdlZEJpdHNcbiAgICB9O1xuICAgIC8vICRGbG93Rml4TWU6IEZsb3cgY29tcGxhaW5zIGFib3V0IG5vdCBzZXR0aW5nIGEgdmFsdWUsIHdoaWNoIGlzIGludGVudGlvbmFsIGhlcmVcbiAgICBPYmplY3QuZGVmaW5lUHJvcGVydGllcyhDb25zdW1lciwge1xuICAgICAgUHJvdmlkZXI6IHtcbiAgICAgICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgaWYgKCFoYXNXYXJuZWRBYm91dFVzaW5nQ29uc3VtZXJQcm92aWRlcikge1xuICAgICAgICAgICAgaGFzV2FybmVkQWJvdXRVc2luZ0NvbnN1bWVyUHJvdmlkZXIgPSB0cnVlO1xuICAgICAgICAgICAgd2FybmluZyQxKGZhbHNlLCAnUmVuZGVyaW5nIDxDb250ZXh0LkNvbnN1bWVyLlByb3ZpZGVyPiBpcyBub3Qgc3VwcG9ydGVkIGFuZCB3aWxsIGJlIHJlbW92ZWQgaW4gJyArICdhIGZ1dHVyZSBtYWpvciByZWxlYXNlLiBEaWQgeW91IG1lYW4gdG8gcmVuZGVyIDxDb250ZXh0LlByb3ZpZGVyPiBpbnN0ZWFkPycpO1xuICAgICAgICAgIH1cbiAgICAgICAgICByZXR1cm4gY29udGV4dC5Qcm92aWRlcjtcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiBmdW5jdGlvbiAoX1Byb3ZpZGVyKSB7XG4gICAgICAgICAgY29udGV4dC5Qcm92aWRlciA9IF9Qcm92aWRlcjtcbiAgICAgICAgfVxuICAgICAgfSxcbiAgICAgIF9jdXJyZW50VmFsdWU6IHtcbiAgICAgICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgcmV0dXJuIGNvbnRleHQuX2N1cnJlbnRWYWx1ZTtcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiBmdW5jdGlvbiAoX2N1cnJlbnRWYWx1ZSkge1xuICAgICAgICAgIGNvbnRleHQuX2N1cnJlbnRWYWx1ZSA9IF9jdXJyZW50VmFsdWU7XG4gICAgICAgIH1cbiAgICAgIH0sXG4gICAgICBfY3VycmVudFZhbHVlMjoge1xuICAgICAgICBnZXQ6IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgICByZXR1cm4gY29udGV4dC5fY3VycmVudFZhbHVlMjtcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiBmdW5jdGlvbiAoX2N1cnJlbnRWYWx1ZTIpIHtcbiAgICAgICAgICBjb250ZXh0Ll9jdXJyZW50VmFsdWUyID0gX2N1cnJlbnRWYWx1ZTI7XG4gICAgICAgIH1cbiAgICAgIH0sXG4gICAgICBfdGhyZWFkQ291bnQ6IHtcbiAgICAgICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgcmV0dXJuIGNvbnRleHQuX3RocmVhZENvdW50O1xuICAgICAgICB9LFxuICAgICAgICBzZXQ6IGZ1bmN0aW9uIChfdGhyZWFkQ291bnQpIHtcbiAgICAgICAgICBjb250ZXh0Ll90aHJlYWRDb3VudCA9IF90aHJlYWRDb3VudDtcbiAgICAgICAgfVxuICAgICAgfSxcbiAgICAgIENvbnN1bWVyOiB7XG4gICAgICAgIGdldDogZnVuY3Rpb24gKCkge1xuICAgICAgICAgIGlmICghaGFzV2FybmVkQWJvdXRVc2luZ05lc3RlZENvbnRleHRDb25zdW1lcnMpIHtcbiAgICAgICAgICAgIGhhc1dhcm5lZEFib3V0VXNpbmdOZXN0ZWRDb250ZXh0Q29uc3VtZXJzID0gdHJ1ZTtcbiAgICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlbmRlcmluZyA8Q29udGV4dC5Db25zdW1lci5Db25zdW1lcj4gaXMgbm90IHN1cHBvcnRlZCBhbmQgd2lsbCBiZSByZW1vdmVkIGluICcgKyAnYSBmdXR1cmUgbWFqb3IgcmVsZWFzZS4gRGlkIHlvdSBtZWFuIHRvIHJlbmRlciA8Q29udGV4dC5Db25zdW1lcj4gaW5zdGVhZD8nKTtcbiAgICAgICAgICB9XG4gICAgICAgICAgcmV0dXJuIGNvbnRleHQuQ29uc3VtZXI7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9KTtcbiAgICAvLyAkRmxvd0ZpeE1lOiBGbG93IGNvbXBsYWlucyBhYm91dCBtaXNzaW5nIHByb3BlcnRpZXMgYmVjYXVzZSBpdCBkb2Vzbid0IHVuZGVyc3RhbmQgZGVmaW5lUHJvcGVydHlcbiAgICBjb250ZXh0LkNvbnN1bWVyID0gQ29uc3VtZXI7XG4gIH1cblxuICB7XG4gICAgY29udGV4dC5fY3VycmVudFJlbmRlcmVyID0gbnVsbDtcbiAgICBjb250ZXh0Ll9jdXJyZW50UmVuZGVyZXIyID0gbnVsbDtcbiAgfVxuXG4gIHJldHVybiBjb250ZXh0O1xufVxuXG5mdW5jdGlvbiBsYXp5KGN0b3IpIHtcbiAgdmFyIGxhenlUeXBlID0ge1xuICAgICQkdHlwZW9mOiBSRUFDVF9MQVpZX1RZUEUsXG4gICAgX2N0b3I6IGN0b3IsXG4gICAgLy8gUmVhY3QgdXNlcyB0aGVzZSBmaWVsZHMgdG8gc3RvcmUgdGhlIHJlc3VsdC5cbiAgICBfc3RhdHVzOiAtMSxcbiAgICBfcmVzdWx0OiBudWxsXG4gIH07XG5cbiAge1xuICAgIC8vIEluIHByb2R1Y3Rpb24sIHRoaXMgd291bGQganVzdCBzZXQgaXQgb24gdGhlIG9iamVjdC5cbiAgICB2YXIgZGVmYXVsdFByb3BzID0gdm9pZCAwO1xuICAgIHZhciBwcm9wVHlwZXMgPSB2b2lkIDA7XG4gICAgT2JqZWN0LmRlZmluZVByb3BlcnRpZXMobGF6eVR5cGUsIHtcbiAgICAgIGRlZmF1bHRQcm9wczoge1xuICAgICAgICBjb25maWd1cmFibGU6IHRydWUsXG4gICAgICAgIGdldDogZnVuY3Rpb24gKCkge1xuICAgICAgICAgIHJldHVybiBkZWZhdWx0UHJvcHM7XG4gICAgICAgIH0sXG4gICAgICAgIHNldDogZnVuY3Rpb24gKG5ld0RlZmF1bHRQcm9wcykge1xuICAgICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlYWN0LmxhenkoLi4uKTogSXQgaXMgbm90IHN1cHBvcnRlZCB0byBhc3NpZ24gYGRlZmF1bHRQcm9wc2AgdG8gJyArICdhIGxhenkgY29tcG9uZW50IGltcG9ydC4gRWl0aGVyIHNwZWNpZnkgdGhlbSB3aGVyZSB0aGUgY29tcG9uZW50ICcgKyAnaXMgZGVmaW5lZCwgb3IgY3JlYXRlIGEgd3JhcHBpbmcgY29tcG9uZW50IGFyb3VuZCBpdC4nKTtcbiAgICAgICAgICBkZWZhdWx0UHJvcHMgPSBuZXdEZWZhdWx0UHJvcHM7XG4gICAgICAgICAgLy8gTWF0Y2ggcHJvZHVjdGlvbiBiZWhhdmlvciBtb3JlIGNsb3NlbHk6XG4gICAgICAgICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KGxhenlUeXBlLCAnZGVmYXVsdFByb3BzJywge1xuICAgICAgICAgICAgZW51bWVyYWJsZTogdHJ1ZVxuICAgICAgICAgIH0pO1xuICAgICAgICB9XG4gICAgICB9LFxuICAgICAgcHJvcFR5cGVzOiB7XG4gICAgICAgIGNvbmZpZ3VyYWJsZTogdHJ1ZSxcbiAgICAgICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgcmV0dXJuIHByb3BUeXBlcztcbiAgICAgICAgfSxcbiAgICAgICAgc2V0OiBmdW5jdGlvbiAobmV3UHJvcFR5cGVzKSB7XG4gICAgICAgICAgd2FybmluZyQxKGZhbHNlLCAnUmVhY3QubGF6eSguLi4pOiBJdCBpcyBub3Qgc3VwcG9ydGVkIHRvIGFzc2lnbiBgcHJvcFR5cGVzYCB0byAnICsgJ2EgbGF6eSBjb21wb25lbnQgaW1wb3J0LiBFaXRoZXIgc3BlY2lmeSB0aGVtIHdoZXJlIHRoZSBjb21wb25lbnQgJyArICdpcyBkZWZpbmVkLCBvciBjcmVhdGUgYSB3cmFwcGluZyBjb21wb25lbnQgYXJvdW5kIGl0LicpO1xuICAgICAgICAgIHByb3BUeXBlcyA9IG5ld1Byb3BUeXBlcztcbiAgICAgICAgICAvLyBNYXRjaCBwcm9kdWN0aW9uIGJlaGF2aW9yIG1vcmUgY2xvc2VseTpcbiAgICAgICAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkobGF6eVR5cGUsICdwcm9wVHlwZXMnLCB7XG4gICAgICAgICAgICBlbnVtZXJhYmxlOiB0cnVlXG4gICAgICAgICAgfSk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuXG4gIHJldHVybiBsYXp5VHlwZTtcbn1cblxuZnVuY3Rpb24gZm9yd2FyZFJlZihyZW5kZXIpIHtcbiAge1xuICAgIGlmIChyZW5kZXIgIT0gbnVsbCAmJiByZW5kZXIuJCR0eXBlb2YgPT09IFJFQUNUX01FTU9fVFlQRSkge1xuICAgICAgd2FybmluZ1dpdGhvdXRTdGFjayQxKGZhbHNlLCAnZm9yd2FyZFJlZiByZXF1aXJlcyBhIHJlbmRlciBmdW5jdGlvbiBidXQgcmVjZWl2ZWQgYSBgbWVtb2AgJyArICdjb21wb25lbnQuIEluc3RlYWQgb2YgZm9yd2FyZFJlZihtZW1vKC4uLikpLCB1c2UgJyArICdtZW1vKGZvcndhcmRSZWYoLi4uKSkuJyk7XG4gICAgfSBlbHNlIGlmICh0eXBlb2YgcmVuZGVyICE9PSAnZnVuY3Rpb24nKSB7XG4gICAgICB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdmb3J3YXJkUmVmIHJlcXVpcmVzIGEgcmVuZGVyIGZ1bmN0aW9uIGJ1dCB3YXMgZ2l2ZW4gJXMuJywgcmVuZGVyID09PSBudWxsID8gJ251bGwnIDogdHlwZW9mIHJlbmRlcik7XG4gICAgfSBlbHNlIHtcbiAgICAgICEoXG4gICAgICAvLyBEbyBub3Qgd2FybiBmb3IgMCBhcmd1bWVudHMgYmVjYXVzZSBpdCBjb3VsZCBiZSBkdWUgdG8gdXNhZ2Ugb2YgdGhlICdhcmd1bWVudHMnIG9iamVjdFxuICAgICAgcmVuZGVyLmxlbmd0aCA9PT0gMCB8fCByZW5kZXIubGVuZ3RoID09PSAyKSA/IHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgJ2ZvcndhcmRSZWYgcmVuZGVyIGZ1bmN0aW9ucyBhY2NlcHQgZXhhY3RseSB0d28gcGFyYW1ldGVyczogcHJvcHMgYW5kIHJlZi4gJXMnLCByZW5kZXIubGVuZ3RoID09PSAxID8gJ0RpZCB5b3UgZm9yZ2V0IHRvIHVzZSB0aGUgcmVmIHBhcmFtZXRlcj8nIDogJ0FueSBhZGRpdGlvbmFsIHBhcmFtZXRlciB3aWxsIGJlIHVuZGVmaW5lZC4nKSA6IHZvaWQgMDtcbiAgICB9XG5cbiAgICBpZiAocmVuZGVyICE9IG51bGwpIHtcbiAgICAgICEocmVuZGVyLmRlZmF1bHRQcm9wcyA9PSBudWxsICYmIHJlbmRlci5wcm9wVHlwZXMgPT0gbnVsbCkgPyB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdmb3J3YXJkUmVmIHJlbmRlciBmdW5jdGlvbnMgZG8gbm90IHN1cHBvcnQgcHJvcFR5cGVzIG9yIGRlZmF1bHRQcm9wcy4gJyArICdEaWQgeW91IGFjY2lkZW50YWxseSBwYXNzIGEgUmVhY3QgY29tcG9uZW50PycpIDogdm9pZCAwO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiB7XG4gICAgJCR0eXBlb2Y6IFJFQUNUX0ZPUldBUkRfUkVGX1RZUEUsXG4gICAgcmVuZGVyOiByZW5kZXJcbiAgfTtcbn1cblxuZnVuY3Rpb24gaXNWYWxpZEVsZW1lbnRUeXBlKHR5cGUpIHtcbiAgcmV0dXJuIHR5cGVvZiB0eXBlID09PSAnc3RyaW5nJyB8fCB0eXBlb2YgdHlwZSA9PT0gJ2Z1bmN0aW9uJyB8fFxuICAvLyBOb3RlOiBpdHMgdHlwZW9mIG1pZ2h0IGJlIG90aGVyIHRoYW4gJ3N5bWJvbCcgb3IgJ251bWJlcicgaWYgaXQncyBhIHBvbHlmaWxsLlxuICB0eXBlID09PSBSRUFDVF9GUkFHTUVOVF9UWVBFIHx8IHR5cGUgPT09IFJFQUNUX0NPTkNVUlJFTlRfTU9ERV9UWVBFIHx8IHR5cGUgPT09IFJFQUNUX1BST0ZJTEVSX1RZUEUgfHwgdHlwZSA9PT0gUkVBQ1RfU1RSSUNUX01PREVfVFlQRSB8fCB0eXBlID09PSBSRUFDVF9TVVNQRU5TRV9UWVBFIHx8IHR5cGVvZiB0eXBlID09PSAnb2JqZWN0JyAmJiB0eXBlICE9PSBudWxsICYmICh0eXBlLiQkdHlwZW9mID09PSBSRUFDVF9MQVpZX1RZUEUgfHwgdHlwZS4kJHR5cGVvZiA9PT0gUkVBQ1RfTUVNT19UWVBFIHx8IHR5cGUuJCR0eXBlb2YgPT09IFJFQUNUX1BST1ZJREVSX1RZUEUgfHwgdHlwZS4kJHR5cGVvZiA9PT0gUkVBQ1RfQ09OVEVYVF9UWVBFIHx8IHR5cGUuJCR0eXBlb2YgPT09IFJFQUNUX0ZPUldBUkRfUkVGX1RZUEUpO1xufVxuXG5mdW5jdGlvbiBtZW1vKHR5cGUsIGNvbXBhcmUpIHtcbiAge1xuICAgIGlmICghaXNWYWxpZEVsZW1lbnRUeXBlKHR5cGUpKSB7XG4gICAgICB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdtZW1vOiBUaGUgZmlyc3QgYXJndW1lbnQgbXVzdCBiZSBhIGNvbXBvbmVudC4gSW5zdGVhZCAnICsgJ3JlY2VpdmVkOiAlcycsIHR5cGUgPT09IG51bGwgPyAnbnVsbCcgOiB0eXBlb2YgdHlwZSk7XG4gICAgfVxuICB9XG4gIHJldHVybiB7XG4gICAgJCR0eXBlb2Y6IFJFQUNUX01FTU9fVFlQRSxcbiAgICB0eXBlOiB0eXBlLFxuICAgIGNvbXBhcmU6IGNvbXBhcmUgPT09IHVuZGVmaW5lZCA/IG51bGwgOiBjb21wYXJlXG4gIH07XG59XG5cbmZ1bmN0aW9uIHJlc29sdmVEaXNwYXRjaGVyKCkge1xuICB2YXIgZGlzcGF0Y2hlciA9IFJlYWN0Q3VycmVudERpc3BhdGNoZXIuY3VycmVudDtcbiAgIShkaXNwYXRjaGVyICE9PSBudWxsKSA/IGludmFyaWFudChmYWxzZSwgJ0hvb2tzIGNhbiBvbmx5IGJlIGNhbGxlZCBpbnNpZGUgdGhlIGJvZHkgb2YgYSBmdW5jdGlvbiBjb21wb25lbnQuIChodHRwczovL2ZiLm1lL3JlYWN0LWludmFsaWQtaG9vay1jYWxsKScpIDogdm9pZCAwO1xuICByZXR1cm4gZGlzcGF0Y2hlcjtcbn1cblxuZnVuY3Rpb24gdXNlQ29udGV4dChDb250ZXh0LCB1bnN0YWJsZV9vYnNlcnZlZEJpdHMpIHtcbiAgdmFyIGRpc3BhdGNoZXIgPSByZXNvbHZlRGlzcGF0Y2hlcigpO1xuICB7XG4gICAgISh1bnN0YWJsZV9vYnNlcnZlZEJpdHMgPT09IHVuZGVmaW5lZCkgPyB3YXJuaW5nJDEoZmFsc2UsICd1c2VDb250ZXh0KCkgc2Vjb25kIGFyZ3VtZW50IGlzIHJlc2VydmVkIGZvciBmdXR1cmUgJyArICd1c2UgaW4gUmVhY3QuIFBhc3NpbmcgaXQgaXMgbm90IHN1cHBvcnRlZC4gJyArICdZb3UgcGFzc2VkOiAlcy4lcycsIHVuc3RhYmxlX29ic2VydmVkQml0cywgdHlwZW9mIHVuc3RhYmxlX29ic2VydmVkQml0cyA9PT0gJ251bWJlcicgJiYgQXJyYXkuaXNBcnJheShhcmd1bWVudHNbMl0pID8gJ1xcblxcbkRpZCB5b3UgY2FsbCBhcnJheS5tYXAodXNlQ29udGV4dCk/ICcgKyAnQ2FsbGluZyBIb29rcyBpbnNpZGUgYSBsb29wIGlzIG5vdCBzdXBwb3J0ZWQuICcgKyAnTGVhcm4gbW9yZSBhdCBodHRwczovL2ZiLm1lL3J1bGVzLW9mLWhvb2tzJyA6ICcnKSA6IHZvaWQgMDtcblxuICAgIC8vIFRPRE86IGFkZCBhIG1vcmUgZ2VuZXJpYyB3YXJuaW5nIGZvciBpbnZhbGlkIHZhbHVlcy5cbiAgICBpZiAoQ29udGV4dC5fY29udGV4dCAhPT0gdW5kZWZpbmVkKSB7XG4gICAgICB2YXIgcmVhbENvbnRleHQgPSBDb250ZXh0Ll9jb250ZXh0O1xuICAgICAgLy8gRG9uJ3QgZGVkdXBsaWNhdGUgYmVjYXVzZSB0aGlzIGxlZ2l0aW1hdGVseSBjYXVzZXMgYnVnc1xuICAgICAgLy8gYW5kIG5vYm9keSBzaG91bGQgYmUgdXNpbmcgdGhpcyBpbiBleGlzdGluZyBjb2RlLlxuICAgICAgaWYgKHJlYWxDb250ZXh0LkNvbnN1bWVyID09PSBDb250ZXh0KSB7XG4gICAgICAgIHdhcm5pbmckMShmYWxzZSwgJ0NhbGxpbmcgdXNlQ29udGV4dChDb250ZXh0LkNvbnN1bWVyKSBpcyBub3Qgc3VwcG9ydGVkLCBtYXkgY2F1c2UgYnVncywgYW5kIHdpbGwgYmUgJyArICdyZW1vdmVkIGluIGEgZnV0dXJlIG1ham9yIHJlbGVhc2UuIERpZCB5b3UgbWVhbiB0byBjYWxsIHVzZUNvbnRleHQoQ29udGV4dCkgaW5zdGVhZD8nKTtcbiAgICAgIH0gZWxzZSBpZiAocmVhbENvbnRleHQuUHJvdmlkZXIgPT09IENvbnRleHQpIHtcbiAgICAgICAgd2FybmluZyQxKGZhbHNlLCAnQ2FsbGluZyB1c2VDb250ZXh0KENvbnRleHQuUHJvdmlkZXIpIGlzIG5vdCBzdXBwb3J0ZWQuICcgKyAnRGlkIHlvdSBtZWFuIHRvIGNhbGwgdXNlQ29udGV4dChDb250ZXh0KSBpbnN0ZWFkPycpO1xuICAgICAgfVxuICAgIH1cbiAgfVxuICByZXR1cm4gZGlzcGF0Y2hlci51c2VDb250ZXh0KENvbnRleHQsIHVuc3RhYmxlX29ic2VydmVkQml0cyk7XG59XG5cbmZ1bmN0aW9uIHVzZVN0YXRlKGluaXRpYWxTdGF0ZSkge1xuICB2YXIgZGlzcGF0Y2hlciA9IHJlc29sdmVEaXNwYXRjaGVyKCk7XG4gIHJldHVybiBkaXNwYXRjaGVyLnVzZVN0YXRlKGluaXRpYWxTdGF0ZSk7XG59XG5cbmZ1bmN0aW9uIHVzZVJlZHVjZXIocmVkdWNlciwgaW5pdGlhbEFyZywgaW5pdCkge1xuICB2YXIgZGlzcGF0Y2hlciA9IHJlc29sdmVEaXNwYXRjaGVyKCk7XG4gIHJldHVybiBkaXNwYXRjaGVyLnVzZVJlZHVjZXIocmVkdWNlciwgaW5pdGlhbEFyZywgaW5pdCk7XG59XG5cbmZ1bmN0aW9uIHVzZVJlZihpbml0aWFsVmFsdWUpIHtcbiAgdmFyIGRpc3BhdGNoZXIgPSByZXNvbHZlRGlzcGF0Y2hlcigpO1xuICByZXR1cm4gZGlzcGF0Y2hlci51c2VSZWYoaW5pdGlhbFZhbHVlKTtcbn1cblxuZnVuY3Rpb24gdXNlRWZmZWN0KGNyZWF0ZSwgaW5wdXRzKSB7XG4gIHZhciBkaXNwYXRjaGVyID0gcmVzb2x2ZURpc3BhdGNoZXIoKTtcbiAgcmV0dXJuIGRpc3BhdGNoZXIudXNlRWZmZWN0KGNyZWF0ZSwgaW5wdXRzKTtcbn1cblxuZnVuY3Rpb24gdXNlTGF5b3V0RWZmZWN0KGNyZWF0ZSwgaW5wdXRzKSB7XG4gIHZhciBkaXNwYXRjaGVyID0gcmVzb2x2ZURpc3BhdGNoZXIoKTtcbiAgcmV0dXJuIGRpc3BhdGNoZXIudXNlTGF5b3V0RWZmZWN0KGNyZWF0ZSwgaW5wdXRzKTtcbn1cblxuZnVuY3Rpb24gdXNlQ2FsbGJhY2soY2FsbGJhY2ssIGlucHV0cykge1xuICB2YXIgZGlzcGF0Y2hlciA9IHJlc29sdmVEaXNwYXRjaGVyKCk7XG4gIHJldHVybiBkaXNwYXRjaGVyLnVzZUNhbGxiYWNrKGNhbGxiYWNrLCBpbnB1dHMpO1xufVxuXG5mdW5jdGlvbiB1c2VNZW1vKGNyZWF0ZSwgaW5wdXRzKSB7XG4gIHZhciBkaXNwYXRjaGVyID0gcmVzb2x2ZURpc3BhdGNoZXIoKTtcbiAgcmV0dXJuIGRpc3BhdGNoZXIudXNlTWVtbyhjcmVhdGUsIGlucHV0cyk7XG59XG5cbmZ1bmN0aW9uIHVzZUltcGVyYXRpdmVIYW5kbGUocmVmLCBjcmVhdGUsIGlucHV0cykge1xuICB2YXIgZGlzcGF0Y2hlciA9IHJlc29sdmVEaXNwYXRjaGVyKCk7XG4gIHJldHVybiBkaXNwYXRjaGVyLnVzZUltcGVyYXRpdmVIYW5kbGUocmVmLCBjcmVhdGUsIGlucHV0cyk7XG59XG5cbmZ1bmN0aW9uIHVzZURlYnVnVmFsdWUodmFsdWUsIGZvcm1hdHRlckZuKSB7XG4gIHtcbiAgICB2YXIgZGlzcGF0Y2hlciA9IHJlc29sdmVEaXNwYXRjaGVyKCk7XG4gICAgcmV0dXJuIGRpc3BhdGNoZXIudXNlRGVidWdWYWx1ZSh2YWx1ZSwgZm9ybWF0dGVyRm4pO1xuICB9XG59XG5cbi8qKlxuICogUmVhY3RFbGVtZW50VmFsaWRhdG9yIHByb3ZpZGVzIGEgd3JhcHBlciBhcm91bmQgYSBlbGVtZW50IGZhY3RvcnlcbiAqIHdoaWNoIHZhbGlkYXRlcyB0aGUgcHJvcHMgcGFzc2VkIHRvIHRoZSBlbGVtZW50LiBUaGlzIGlzIGludGVuZGVkIHRvIGJlXG4gKiB1c2VkIG9ubHkgaW4gREVWIGFuZCBjb3VsZCBiZSByZXBsYWNlZCBieSBhIHN0YXRpYyB0eXBlIGNoZWNrZXIgZm9yIGxhbmd1YWdlc1xuICogdGhhdCBzdXBwb3J0IGl0LlxuICovXG5cbnZhciBwcm9wVHlwZXNNaXNzcGVsbFdhcm5pbmdTaG93biA9IHZvaWQgMDtcblxue1xuICBwcm9wVHlwZXNNaXNzcGVsbFdhcm5pbmdTaG93biA9IGZhbHNlO1xufVxuXG5mdW5jdGlvbiBnZXREZWNsYXJhdGlvbkVycm9yQWRkZW5kdW0oKSB7XG4gIGlmIChSZWFjdEN1cnJlbnRPd25lci5jdXJyZW50KSB7XG4gICAgdmFyIG5hbWUgPSBnZXRDb21wb25lbnROYW1lKFJlYWN0Q3VycmVudE93bmVyLmN1cnJlbnQudHlwZSk7XG4gICAgaWYgKG5hbWUpIHtcbiAgICAgIHJldHVybiAnXFxuXFxuQ2hlY2sgdGhlIHJlbmRlciBtZXRob2Qgb2YgYCcgKyBuYW1lICsgJ2AuJztcbiAgICB9XG4gIH1cbiAgcmV0dXJuICcnO1xufVxuXG5mdW5jdGlvbiBnZXRTb3VyY2VJbmZvRXJyb3JBZGRlbmR1bShlbGVtZW50UHJvcHMpIHtcbiAgaWYgKGVsZW1lbnRQcm9wcyAhPT0gbnVsbCAmJiBlbGVtZW50UHJvcHMgIT09IHVuZGVmaW5lZCAmJiBlbGVtZW50UHJvcHMuX19zb3VyY2UgIT09IHVuZGVmaW5lZCkge1xuICAgIHZhciBzb3VyY2UgPSBlbGVtZW50UHJvcHMuX19zb3VyY2U7XG4gICAgdmFyIGZpbGVOYW1lID0gc291cmNlLmZpbGVOYW1lLnJlcGxhY2UoL14uKltcXFxcXFwvXS8sICcnKTtcbiAgICB2YXIgbGluZU51bWJlciA9IHNvdXJjZS5saW5lTnVtYmVyO1xuICAgIHJldHVybiAnXFxuXFxuQ2hlY2sgeW91ciBjb2RlIGF0ICcgKyBmaWxlTmFtZSArICc6JyArIGxpbmVOdW1iZXIgKyAnLic7XG4gIH1cbiAgcmV0dXJuICcnO1xufVxuXG4vKipcbiAqIFdhcm4gaWYgdGhlcmUncyBubyBrZXkgZXhwbGljaXRseSBzZXQgb24gZHluYW1pYyBhcnJheXMgb2YgY2hpbGRyZW4gb3JcbiAqIG9iamVjdCBrZXlzIGFyZSBub3QgdmFsaWQuIFRoaXMgYWxsb3dzIHVzIHRvIGtlZXAgdHJhY2sgb2YgY2hpbGRyZW4gYmV0d2VlblxuICogdXBkYXRlcy5cbiAqL1xudmFyIG93bmVySGFzS2V5VXNlV2FybmluZyA9IHt9O1xuXG5mdW5jdGlvbiBnZXRDdXJyZW50Q29tcG9uZW50RXJyb3JJbmZvKHBhcmVudFR5cGUpIHtcbiAgdmFyIGluZm8gPSBnZXREZWNsYXJhdGlvbkVycm9yQWRkZW5kdW0oKTtcblxuICBpZiAoIWluZm8pIHtcbiAgICB2YXIgcGFyZW50TmFtZSA9IHR5cGVvZiBwYXJlbnRUeXBlID09PSAnc3RyaW5nJyA/IHBhcmVudFR5cGUgOiBwYXJlbnRUeXBlLmRpc3BsYXlOYW1lIHx8IHBhcmVudFR5cGUubmFtZTtcbiAgICBpZiAocGFyZW50TmFtZSkge1xuICAgICAgaW5mbyA9ICdcXG5cXG5DaGVjayB0aGUgdG9wLWxldmVsIHJlbmRlciBjYWxsIHVzaW5nIDwnICsgcGFyZW50TmFtZSArICc+Lic7XG4gICAgfVxuICB9XG4gIHJldHVybiBpbmZvO1xufVxuXG4vKipcbiAqIFdhcm4gaWYgdGhlIGVsZW1lbnQgZG9lc24ndCBoYXZlIGFuIGV4cGxpY2l0IGtleSBhc3NpZ25lZCB0byBpdC5cbiAqIFRoaXMgZWxlbWVudCBpcyBpbiBhbiBhcnJheS4gVGhlIGFycmF5IGNvdWxkIGdyb3cgYW5kIHNocmluayBvciBiZVxuICogcmVvcmRlcmVkLiBBbGwgY2hpbGRyZW4gdGhhdCBoYXZlbid0IGFscmVhZHkgYmVlbiB2YWxpZGF0ZWQgYXJlIHJlcXVpcmVkIHRvXG4gKiBoYXZlIGEgXCJrZXlcIiBwcm9wZXJ0eSBhc3NpZ25lZCB0byBpdC4gRXJyb3Igc3RhdHVzZXMgYXJlIGNhY2hlZCBzbyBhIHdhcm5pbmdcbiAqIHdpbGwgb25seSBiZSBzaG93biBvbmNlLlxuICpcbiAqIEBpbnRlcm5hbFxuICogQHBhcmFtIHtSZWFjdEVsZW1lbnR9IGVsZW1lbnQgRWxlbWVudCB0aGF0IHJlcXVpcmVzIGEga2V5LlxuICogQHBhcmFtIHsqfSBwYXJlbnRUeXBlIGVsZW1lbnQncyBwYXJlbnQncyB0eXBlLlxuICovXG5mdW5jdGlvbiB2YWxpZGF0ZUV4cGxpY2l0S2V5KGVsZW1lbnQsIHBhcmVudFR5cGUpIHtcbiAgaWYgKCFlbGVtZW50Ll9zdG9yZSB8fCBlbGVtZW50Ll9zdG9yZS52YWxpZGF0ZWQgfHwgZWxlbWVudC5rZXkgIT0gbnVsbCkge1xuICAgIHJldHVybjtcbiAgfVxuICBlbGVtZW50Ll9zdG9yZS52YWxpZGF0ZWQgPSB0cnVlO1xuXG4gIHZhciBjdXJyZW50Q29tcG9uZW50RXJyb3JJbmZvID0gZ2V0Q3VycmVudENvbXBvbmVudEVycm9ySW5mbyhwYXJlbnRUeXBlKTtcbiAgaWYgKG93bmVySGFzS2V5VXNlV2FybmluZ1tjdXJyZW50Q29tcG9uZW50RXJyb3JJbmZvXSkge1xuICAgIHJldHVybjtcbiAgfVxuICBvd25lckhhc0tleVVzZVdhcm5pbmdbY3VycmVudENvbXBvbmVudEVycm9ySW5mb10gPSB0cnVlO1xuXG4gIC8vIFVzdWFsbHkgdGhlIGN1cnJlbnQgb3duZXIgaXMgdGhlIG9mZmVuZGVyLCBidXQgaWYgaXQgYWNjZXB0cyBjaGlsZHJlbiBhcyBhXG4gIC8vIHByb3BlcnR5LCBpdCBtYXkgYmUgdGhlIGNyZWF0b3Igb2YgdGhlIGNoaWxkIHRoYXQncyByZXNwb25zaWJsZSBmb3JcbiAgLy8gYXNzaWduaW5nIGl0IGEga2V5LlxuICB2YXIgY2hpbGRPd25lciA9ICcnO1xuICBpZiAoZWxlbWVudCAmJiBlbGVtZW50Ll9vd25lciAmJiBlbGVtZW50Ll9vd25lciAhPT0gUmVhY3RDdXJyZW50T3duZXIuY3VycmVudCkge1xuICAgIC8vIEdpdmUgdGhlIGNvbXBvbmVudCB0aGF0IG9yaWdpbmFsbHkgY3JlYXRlZCB0aGlzIGNoaWxkLlxuICAgIGNoaWxkT3duZXIgPSAnIEl0IHdhcyBwYXNzZWQgYSBjaGlsZCBmcm9tICcgKyBnZXRDb21wb25lbnROYW1lKGVsZW1lbnQuX293bmVyLnR5cGUpICsgJy4nO1xuICB9XG5cbiAgc2V0Q3VycmVudGx5VmFsaWRhdGluZ0VsZW1lbnQoZWxlbWVudCk7XG4gIHtcbiAgICB3YXJuaW5nJDEoZmFsc2UsICdFYWNoIGNoaWxkIGluIGEgbGlzdCBzaG91bGQgaGF2ZSBhIHVuaXF1ZSBcImtleVwiIHByb3AuJyArICclcyVzIFNlZSBodHRwczovL2ZiLm1lL3JlYWN0LXdhcm5pbmcta2V5cyBmb3IgbW9yZSBpbmZvcm1hdGlvbi4nLCBjdXJyZW50Q29tcG9uZW50RXJyb3JJbmZvLCBjaGlsZE93bmVyKTtcbiAgfVxuICBzZXRDdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudChudWxsKTtcbn1cblxuLyoqXG4gKiBFbnN1cmUgdGhhdCBldmVyeSBlbGVtZW50IGVpdGhlciBpcyBwYXNzZWQgaW4gYSBzdGF0aWMgbG9jYXRpb24sIGluIGFuXG4gKiBhcnJheSB3aXRoIGFuIGV4cGxpY2l0IGtleXMgcHJvcGVydHkgZGVmaW5lZCwgb3IgaW4gYW4gb2JqZWN0IGxpdGVyYWxcbiAqIHdpdGggdmFsaWQga2V5IHByb3BlcnR5LlxuICpcbiAqIEBpbnRlcm5hbFxuICogQHBhcmFtIHtSZWFjdE5vZGV9IG5vZGUgU3RhdGljYWxseSBwYXNzZWQgY2hpbGQgb2YgYW55IHR5cGUuXG4gKiBAcGFyYW0geyp9IHBhcmVudFR5cGUgbm9kZSdzIHBhcmVudCdzIHR5cGUuXG4gKi9cbmZ1bmN0aW9uIHZhbGlkYXRlQ2hpbGRLZXlzKG5vZGUsIHBhcmVudFR5cGUpIHtcbiAgaWYgKHR5cGVvZiBub2RlICE9PSAnb2JqZWN0Jykge1xuICAgIHJldHVybjtcbiAgfVxuICBpZiAoQXJyYXkuaXNBcnJheShub2RlKSkge1xuICAgIGZvciAodmFyIGkgPSAwOyBpIDwgbm9kZS5sZW5ndGg7IGkrKykge1xuICAgICAgdmFyIGNoaWxkID0gbm9kZVtpXTtcbiAgICAgIGlmIChpc1ZhbGlkRWxlbWVudChjaGlsZCkpIHtcbiAgICAgICAgdmFsaWRhdGVFeHBsaWNpdEtleShjaGlsZCwgcGFyZW50VHlwZSk7XG4gICAgICB9XG4gICAgfVxuICB9IGVsc2UgaWYgKGlzVmFsaWRFbGVtZW50KG5vZGUpKSB7XG4gICAgLy8gVGhpcyBlbGVtZW50IHdhcyBwYXNzZWQgaW4gYSB2YWxpZCBsb2NhdGlvbi5cbiAgICBpZiAobm9kZS5fc3RvcmUpIHtcbiAgICAgIG5vZGUuX3N0b3JlLnZhbGlkYXRlZCA9IHRydWU7XG4gICAgfVxuICB9IGVsc2UgaWYgKG5vZGUpIHtcbiAgICB2YXIgaXRlcmF0b3JGbiA9IGdldEl0ZXJhdG9yRm4obm9kZSk7XG4gICAgaWYgKHR5cGVvZiBpdGVyYXRvckZuID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICAvLyBFbnRyeSBpdGVyYXRvcnMgdXNlZCB0byBwcm92aWRlIGltcGxpY2l0IGtleXMsXG4gICAgICAvLyBidXQgbm93IHdlIHByaW50IGEgc2VwYXJhdGUgd2FybmluZyBmb3IgdGhlbSBsYXRlci5cbiAgICAgIGlmIChpdGVyYXRvckZuICE9PSBub2RlLmVudHJpZXMpIHtcbiAgICAgICAgdmFyIGl0ZXJhdG9yID0gaXRlcmF0b3JGbi5jYWxsKG5vZGUpO1xuICAgICAgICB2YXIgc3RlcCA9IHZvaWQgMDtcbiAgICAgICAgd2hpbGUgKCEoc3RlcCA9IGl0ZXJhdG9yLm5leHQoKSkuZG9uZSkge1xuICAgICAgICAgIGlmIChpc1ZhbGlkRWxlbWVudChzdGVwLnZhbHVlKSkge1xuICAgICAgICAgICAgdmFsaWRhdGVFeHBsaWNpdEtleShzdGVwLnZhbHVlLCBwYXJlbnRUeXBlKTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG4gIH1cbn1cblxuLyoqXG4gKiBHaXZlbiBhbiBlbGVtZW50LCB2YWxpZGF0ZSB0aGF0IGl0cyBwcm9wcyBmb2xsb3cgdGhlIHByb3BUeXBlcyBkZWZpbml0aW9uLFxuICogcHJvdmlkZWQgYnkgdGhlIHR5cGUuXG4gKlxuICogQHBhcmFtIHtSZWFjdEVsZW1lbnR9IGVsZW1lbnRcbiAqL1xuZnVuY3Rpb24gdmFsaWRhdGVQcm9wVHlwZXMoZWxlbWVudCkge1xuICB2YXIgdHlwZSA9IGVsZW1lbnQudHlwZTtcbiAgaWYgKHR5cGUgPT09IG51bGwgfHwgdHlwZSA9PT0gdW5kZWZpbmVkIHx8IHR5cGVvZiB0eXBlID09PSAnc3RyaW5nJykge1xuICAgIHJldHVybjtcbiAgfVxuICB2YXIgbmFtZSA9IGdldENvbXBvbmVudE5hbWUodHlwZSk7XG4gIHZhciBwcm9wVHlwZXMgPSB2b2lkIDA7XG4gIGlmICh0eXBlb2YgdHlwZSA9PT0gJ2Z1bmN0aW9uJykge1xuICAgIHByb3BUeXBlcyA9IHR5cGUucHJvcFR5cGVzO1xuICB9IGVsc2UgaWYgKHR5cGVvZiB0eXBlID09PSAnb2JqZWN0JyAmJiAodHlwZS4kJHR5cGVvZiA9PT0gUkVBQ1RfRk9SV0FSRF9SRUZfVFlQRSB8fFxuICAvLyBOb3RlOiBNZW1vIG9ubHkgY2hlY2tzIG91dGVyIHByb3BzIGhlcmUuXG4gIC8vIElubmVyIHByb3BzIGFyZSBjaGVja2VkIGluIHRoZSByZWNvbmNpbGVyLlxuICB0eXBlLiQkdHlwZW9mID09PSBSRUFDVF9NRU1PX1RZUEUpKSB7XG4gICAgcHJvcFR5cGVzID0gdHlwZS5wcm9wVHlwZXM7XG4gIH0gZWxzZSB7XG4gICAgcmV0dXJuO1xuICB9XG4gIGlmIChwcm9wVHlwZXMpIHtcbiAgICBzZXRDdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudChlbGVtZW50KTtcbiAgICBjaGVja1Byb3BUeXBlcyhwcm9wVHlwZXMsIGVsZW1lbnQucHJvcHMsICdwcm9wJywgbmFtZSwgUmVhY3REZWJ1Z0N1cnJlbnRGcmFtZS5nZXRTdGFja0FkZGVuZHVtKTtcbiAgICBzZXRDdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudChudWxsKTtcbiAgfSBlbHNlIGlmICh0eXBlLlByb3BUeXBlcyAhPT0gdW5kZWZpbmVkICYmICFwcm9wVHlwZXNNaXNzcGVsbFdhcm5pbmdTaG93bikge1xuICAgIHByb3BUeXBlc01pc3NwZWxsV2FybmluZ1Nob3duID0gdHJ1ZTtcbiAgICB3YXJuaW5nV2l0aG91dFN0YWNrJDEoZmFsc2UsICdDb21wb25lbnQgJXMgZGVjbGFyZWQgYFByb3BUeXBlc2AgaW5zdGVhZCBvZiBgcHJvcFR5cGVzYC4gRGlkIHlvdSBtaXNzcGVsbCB0aGUgcHJvcGVydHkgYXNzaWdubWVudD8nLCBuYW1lIHx8ICdVbmtub3duJyk7XG4gIH1cbiAgaWYgKHR5cGVvZiB0eXBlLmdldERlZmF1bHRQcm9wcyA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICF0eXBlLmdldERlZmF1bHRQcm9wcy5pc1JlYWN0Q2xhc3NBcHByb3ZlZCA/IHdhcm5pbmdXaXRob3V0U3RhY2skMShmYWxzZSwgJ2dldERlZmF1bHRQcm9wcyBpcyBvbmx5IHVzZWQgb24gY2xhc3NpYyBSZWFjdC5jcmVhdGVDbGFzcyAnICsgJ2RlZmluaXRpb25zLiBVc2UgYSBzdGF0aWMgcHJvcGVydHkgbmFtZWQgYGRlZmF1bHRQcm9wc2AgaW5zdGVhZC4nKSA6IHZvaWQgMDtcbiAgfVxufVxuXG4vKipcbiAqIEdpdmVuIGEgZnJhZ21lbnQsIHZhbGlkYXRlIHRoYXQgaXQgY2FuIG9ubHkgYmUgcHJvdmlkZWQgd2l0aCBmcmFnbWVudCBwcm9wc1xuICogQHBhcmFtIHtSZWFjdEVsZW1lbnR9IGZyYWdtZW50XG4gKi9cbmZ1bmN0aW9uIHZhbGlkYXRlRnJhZ21lbnRQcm9wcyhmcmFnbWVudCkge1xuICBzZXRDdXJyZW50bHlWYWxpZGF0aW5nRWxlbWVudChmcmFnbWVudCk7XG5cbiAgdmFyIGtleXMgPSBPYmplY3Qua2V5cyhmcmFnbWVudC5wcm9wcyk7XG4gIGZvciAodmFyIGkgPSAwOyBpIDwga2V5cy5sZW5ndGg7IGkrKykge1xuICAgIHZhciBrZXkgPSBrZXlzW2ldO1xuICAgIGlmIChrZXkgIT09ICdjaGlsZHJlbicgJiYga2V5ICE9PSAna2V5Jykge1xuICAgICAgd2FybmluZyQxKGZhbHNlLCAnSW52YWxpZCBwcm9wIGAlc2Agc3VwcGxpZWQgdG8gYFJlYWN0LkZyYWdtZW50YC4gJyArICdSZWFjdC5GcmFnbWVudCBjYW4gb25seSBoYXZlIGBrZXlgIGFuZCBgY2hpbGRyZW5gIHByb3BzLicsIGtleSk7XG4gICAgICBicmVhaztcbiAgICB9XG4gIH1cblxuICBpZiAoZnJhZ21lbnQucmVmICE9PSBudWxsKSB7XG4gICAgd2FybmluZyQxKGZhbHNlLCAnSW52YWxpZCBhdHRyaWJ1dGUgYHJlZmAgc3VwcGxpZWQgdG8gYFJlYWN0LkZyYWdtZW50YC4nKTtcbiAgfVxuXG4gIHNldEN1cnJlbnRseVZhbGlkYXRpbmdFbGVtZW50KG51bGwpO1xufVxuXG5mdW5jdGlvbiBjcmVhdGVFbGVtZW50V2l0aFZhbGlkYXRpb24odHlwZSwgcHJvcHMsIGNoaWxkcmVuKSB7XG4gIHZhciB2YWxpZFR5cGUgPSBpc1ZhbGlkRWxlbWVudFR5cGUodHlwZSk7XG5cbiAgLy8gV2Ugd2FybiBpbiB0aGlzIGNhc2UgYnV0IGRvbid0IHRocm93LiBXZSBleHBlY3QgdGhlIGVsZW1lbnQgY3JlYXRpb24gdG9cbiAgLy8gc3VjY2VlZCBhbmQgdGhlcmUgd2lsbCBsaWtlbHkgYmUgZXJyb3JzIGluIHJlbmRlci5cbiAgaWYgKCF2YWxpZFR5cGUpIHtcbiAgICB2YXIgaW5mbyA9ICcnO1xuICAgIGlmICh0eXBlID09PSB1bmRlZmluZWQgfHwgdHlwZW9mIHR5cGUgPT09ICdvYmplY3QnICYmIHR5cGUgIT09IG51bGwgJiYgT2JqZWN0LmtleXModHlwZSkubGVuZ3RoID09PSAwKSB7XG4gICAgICBpbmZvICs9ICcgWW91IGxpa2VseSBmb3Jnb3QgdG8gZXhwb3J0IHlvdXIgY29tcG9uZW50IGZyb20gdGhlIGZpbGUgJyArIFwiaXQncyBkZWZpbmVkIGluLCBvciB5b3UgbWlnaHQgaGF2ZSBtaXhlZCB1cCBkZWZhdWx0IGFuZCBuYW1lZCBpbXBvcnRzLlwiO1xuICAgIH1cblxuICAgIHZhciBzb3VyY2VJbmZvID0gZ2V0U291cmNlSW5mb0Vycm9yQWRkZW5kdW0ocHJvcHMpO1xuICAgIGlmIChzb3VyY2VJbmZvKSB7XG4gICAgICBpbmZvICs9IHNvdXJjZUluZm87XG4gICAgfSBlbHNlIHtcbiAgICAgIGluZm8gKz0gZ2V0RGVjbGFyYXRpb25FcnJvckFkZGVuZHVtKCk7XG4gICAgfVxuXG4gICAgdmFyIHR5cGVTdHJpbmcgPSB2b2lkIDA7XG4gICAgaWYgKHR5cGUgPT09IG51bGwpIHtcbiAgICAgIHR5cGVTdHJpbmcgPSAnbnVsbCc7XG4gICAgfSBlbHNlIGlmIChBcnJheS5pc0FycmF5KHR5cGUpKSB7XG4gICAgICB0eXBlU3RyaW5nID0gJ2FycmF5JztcbiAgICB9IGVsc2UgaWYgKHR5cGUgIT09IHVuZGVmaW5lZCAmJiB0eXBlLiQkdHlwZW9mID09PSBSRUFDVF9FTEVNRU5UX1RZUEUpIHtcbiAgICAgIHR5cGVTdHJpbmcgPSAnPCcgKyAoZ2V0Q29tcG9uZW50TmFtZSh0eXBlLnR5cGUpIHx8ICdVbmtub3duJykgKyAnIC8+JztcbiAgICAgIGluZm8gPSAnIERpZCB5b3UgYWNjaWRlbnRhbGx5IGV4cG9ydCBhIEpTWCBsaXRlcmFsIGluc3RlYWQgb2YgYSBjb21wb25lbnQ/JztcbiAgICB9IGVsc2Uge1xuICAgICAgdHlwZVN0cmluZyA9IHR5cGVvZiB0eXBlO1xuICAgIH1cblxuICAgIHdhcm5pbmckMShmYWxzZSwgJ1JlYWN0LmNyZWF0ZUVsZW1lbnQ6IHR5cGUgaXMgaW52YWxpZCAtLSBleHBlY3RlZCBhIHN0cmluZyAoZm9yICcgKyAnYnVpbHQtaW4gY29tcG9uZW50cykgb3IgYSBjbGFzcy9mdW5jdGlvbiAoZm9yIGNvbXBvc2l0ZSAnICsgJ2NvbXBvbmVudHMpIGJ1dCBnb3Q6ICVzLiVzJywgdHlwZVN0cmluZywgaW5mbyk7XG4gIH1cblxuICB2YXIgZWxlbWVudCA9IGNyZWF0ZUVsZW1lbnQuYXBwbHkodGhpcywgYXJndW1lbnRzKTtcblxuICAvLyBUaGUgcmVzdWx0IGNhbiBiZSBudWxsaXNoIGlmIGEgbW9jayBvciBhIGN1c3RvbSBmdW5jdGlvbiBpcyB1c2VkLlxuICAvLyBUT0RPOiBEcm9wIHRoaXMgd2hlbiB0aGVzZSBhcmUgbm8gbG9uZ2VyIGFsbG93ZWQgYXMgdGhlIHR5cGUgYXJndW1lbnQuXG4gIGlmIChlbGVtZW50ID09IG51bGwpIHtcbiAgICByZXR1cm4gZWxlbWVudDtcbiAgfVxuXG4gIC8vIFNraXAga2V5IHdhcm5pbmcgaWYgdGhlIHR5cGUgaXNuJ3QgdmFsaWQgc2luY2Ugb3VyIGtleSB2YWxpZGF0aW9uIGxvZ2ljXG4gIC8vIGRvZXNuJ3QgZXhwZWN0IGEgbm9uLXN0cmluZy9mdW5jdGlvbiB0eXBlIGFuZCBjYW4gdGhyb3cgY29uZnVzaW5nIGVycm9ycy5cbiAgLy8gV2UgZG9uJ3Qgd2FudCBleGNlcHRpb24gYmVoYXZpb3IgdG8gZGlmZmVyIGJldHdlZW4gZGV2IGFuZCBwcm9kLlxuICAvLyAoUmVuZGVyaW5nIHdpbGwgdGhyb3cgd2l0aCBhIGhlbHBmdWwgbWVzc2FnZSBhbmQgYXMgc29vbiBhcyB0aGUgdHlwZSBpc1xuICAvLyBmaXhlZCwgdGhlIGtleSB3YXJuaW5ncyB3aWxsIGFwcGVhci4pXG4gIGlmICh2YWxpZFR5cGUpIHtcbiAgICBmb3IgKHZhciBpID0gMjsgaSA8IGFyZ3VtZW50cy5sZW5ndGg7IGkrKykge1xuICAgICAgdmFsaWRhdGVDaGlsZEtleXMoYXJndW1lbnRzW2ldLCB0eXBlKTtcbiAgICB9XG4gIH1cblxuICBpZiAodHlwZSA9PT0gUkVBQ1RfRlJBR01FTlRfVFlQRSkge1xuICAgIHZhbGlkYXRlRnJhZ21lbnRQcm9wcyhlbGVtZW50KTtcbiAgfSBlbHNlIHtcbiAgICB2YWxpZGF0ZVByb3BUeXBlcyhlbGVtZW50KTtcbiAgfVxuXG4gIHJldHVybiBlbGVtZW50O1xufVxuXG5mdW5jdGlvbiBjcmVhdGVGYWN0b3J5V2l0aFZhbGlkYXRpb24odHlwZSkge1xuICB2YXIgdmFsaWRhdGVkRmFjdG9yeSA9IGNyZWF0ZUVsZW1lbnRXaXRoVmFsaWRhdGlvbi5iaW5kKG51bGwsIHR5cGUpO1xuICB2YWxpZGF0ZWRGYWN0b3J5LnR5cGUgPSB0eXBlO1xuICAvLyBMZWdhY3kgaG9vazogcmVtb3ZlIGl0XG4gIHtcbiAgICBPYmplY3QuZGVmaW5lUHJvcGVydHkodmFsaWRhdGVkRmFjdG9yeSwgJ3R5cGUnLCB7XG4gICAgICBlbnVtZXJhYmxlOiBmYWxzZSxcbiAgICAgIGdldDogZnVuY3Rpb24gKCkge1xuICAgICAgICBsb3dQcmlvcml0eVdhcm5pbmckMShmYWxzZSwgJ0ZhY3RvcnkudHlwZSBpcyBkZXByZWNhdGVkLiBBY2Nlc3MgdGhlIGNsYXNzIGRpcmVjdGx5ICcgKyAnYmVmb3JlIHBhc3NpbmcgaXQgdG8gY3JlYXRlRmFjdG9yeS4nKTtcbiAgICAgICAgT2JqZWN0LmRlZmluZVByb3BlcnR5KHRoaXMsICd0eXBlJywge1xuICAgICAgICAgIHZhbHVlOiB0eXBlXG4gICAgICAgIH0pO1xuICAgICAgICByZXR1cm4gdHlwZTtcbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuXG4gIHJldHVybiB2YWxpZGF0ZWRGYWN0b3J5O1xufVxuXG5mdW5jdGlvbiBjbG9uZUVsZW1lbnRXaXRoVmFsaWRhdGlvbihlbGVtZW50LCBwcm9wcywgY2hpbGRyZW4pIHtcbiAgdmFyIG5ld0VsZW1lbnQgPSBjbG9uZUVsZW1lbnQuYXBwbHkodGhpcywgYXJndW1lbnRzKTtcbiAgZm9yICh2YXIgaSA9IDI7IGkgPCBhcmd1bWVudHMubGVuZ3RoOyBpKyspIHtcbiAgICB2YWxpZGF0ZUNoaWxkS2V5cyhhcmd1bWVudHNbaV0sIG5ld0VsZW1lbnQudHlwZSk7XG4gIH1cbiAgdmFsaWRhdGVQcm9wVHlwZXMobmV3RWxlbWVudCk7XG4gIHJldHVybiBuZXdFbGVtZW50O1xufVxuXG4vLyBIZWxwcyBpZGVudGlmeSBzaWRlIGVmZmVjdHMgaW4gYmVnaW4tcGhhc2UgbGlmZWN5Y2xlIGhvb2tzIGFuZCBzZXRTdGF0ZSByZWR1Y2VyczpcblxuXG4vLyBJbiBzb21lIGNhc2VzLCBTdHJpY3RNb2RlIHNob3VsZCBhbHNvIGRvdWJsZS1yZW5kZXIgbGlmZWN5Y2xlcy5cbi8vIFRoaXMgY2FuIGJlIGNvbmZ1c2luZyBmb3IgdGVzdHMgdGhvdWdoLFxuLy8gQW5kIGl0IGNhbiBiZSBiYWQgZm9yIHBlcmZvcm1hbmNlIGluIHByb2R1Y3Rpb24uXG4vLyBUaGlzIGZlYXR1cmUgZmxhZyBjYW4gYmUgdXNlZCB0byBjb250cm9sIHRoZSBiZWhhdmlvcjpcblxuXG4vLyBUbyBwcmVzZXJ2ZSB0aGUgXCJQYXVzZSBvbiBjYXVnaHQgZXhjZXB0aW9uc1wiIGJlaGF2aW9yIG9mIHRoZSBkZWJ1Z2dlciwgd2Vcbi8vIHJlcGxheSB0aGUgYmVnaW4gcGhhc2Ugb2YgYSBmYWlsZWQgY29tcG9uZW50IGluc2lkZSBpbnZva2VHdWFyZGVkQ2FsbGJhY2suXG5cblxuLy8gV2FybiBhYm91dCBkZXByZWNhdGVkLCBhc3luYy11bnNhZmUgbGlmZWN5Y2xlczsgcmVsYXRlcyB0byBSRkMgIzY6XG5cblxuLy8gR2F0aGVyIGFkdmFuY2VkIHRpbWluZyBtZXRyaWNzIGZvciBQcm9maWxlciBzdWJ0cmVlcy5cblxuXG4vLyBUcmFjZSB3aGljaCBpbnRlcmFjdGlvbnMgdHJpZ2dlciBlYWNoIGNvbW1pdC5cblxuXG4vLyBPbmx5IHVzZWQgaW4gd3d3IGJ1aWxkcy5cbiAvLyBUT0RPOiB0cnVlPyBIZXJlIGl0IG1pZ2h0IGp1c3QgYmUgZmFsc2UuXG5cbi8vIE9ubHkgdXNlZCBpbiB3d3cgYnVpbGRzLlxuXG5cbi8vIE9ubHkgdXNlZCBpbiB3d3cgYnVpbGRzLlxuXG5cbi8vIFJlYWN0IEZpcmU6IHByZXZlbnQgdGhlIHZhbHVlIGFuZCBjaGVja2VkIGF0dHJpYnV0ZXMgZnJvbSBzeW5jaW5nXG4vLyB3aXRoIHRoZWlyIHJlbGF0ZWQgRE9NIHByb3BlcnRpZXNcblxuXG4vLyBUaGVzZSBBUElzIHdpbGwgbm8gbG9uZ2VyIGJlIFwidW5zdGFibGVcIiBpbiB0aGUgdXBjb21pbmcgMTYuNyByZWxlYXNlLFxuLy8gQ29udHJvbCB0aGlzIGJlaGF2aW9yIHdpdGggYSBmbGFnIHRvIHN1cHBvcnQgMTYuNiBtaW5vciByZWxlYXNlcyBpbiB0aGUgbWVhbndoaWxlLlxudmFyIGVuYWJsZVN0YWJsZUNvbmN1cnJlbnRNb2RlQVBJcyA9IGZhbHNlO1xuXG52YXIgUmVhY3QgPSB7XG4gIENoaWxkcmVuOiB7XG4gICAgbWFwOiBtYXBDaGlsZHJlbixcbiAgICBmb3JFYWNoOiBmb3JFYWNoQ2hpbGRyZW4sXG4gICAgY291bnQ6IGNvdW50Q2hpbGRyZW4sXG4gICAgdG9BcnJheTogdG9BcnJheSxcbiAgICBvbmx5OiBvbmx5Q2hpbGRcbiAgfSxcblxuICBjcmVhdGVSZWY6IGNyZWF0ZVJlZixcbiAgQ29tcG9uZW50OiBDb21wb25lbnQsXG4gIFB1cmVDb21wb25lbnQ6IFB1cmVDb21wb25lbnQsXG5cbiAgY3JlYXRlQ29udGV4dDogY3JlYXRlQ29udGV4dCxcbiAgZm9yd2FyZFJlZjogZm9yd2FyZFJlZixcbiAgbGF6eTogbGF6eSxcbiAgbWVtbzogbWVtbyxcblxuICB1c2VDYWxsYmFjazogdXNlQ2FsbGJhY2ssXG4gIHVzZUNvbnRleHQ6IHVzZUNvbnRleHQsXG4gIHVzZUVmZmVjdDogdXNlRWZmZWN0LFxuICB1c2VJbXBlcmF0aXZlSGFuZGxlOiB1c2VJbXBlcmF0aXZlSGFuZGxlLFxuICB1c2VEZWJ1Z1ZhbHVlOiB1c2VEZWJ1Z1ZhbHVlLFxuICB1c2VMYXlvdXRFZmZlY3Q6IHVzZUxheW91dEVmZmVjdCxcbiAgdXNlTWVtbzogdXNlTWVtbyxcbiAgdXNlUmVkdWNlcjogdXNlUmVkdWNlcixcbiAgdXNlUmVmOiB1c2VSZWYsXG4gIHVzZVN0YXRlOiB1c2VTdGF0ZSxcblxuICBGcmFnbWVudDogUkVBQ1RfRlJBR01FTlRfVFlQRSxcbiAgU3RyaWN0TW9kZTogUkVBQ1RfU1RSSUNUX01PREVfVFlQRSxcbiAgU3VzcGVuc2U6IFJFQUNUX1NVU1BFTlNFX1RZUEUsXG5cbiAgY3JlYXRlRWxlbWVudDogY3JlYXRlRWxlbWVudFdpdGhWYWxpZGF0aW9uLFxuICBjbG9uZUVsZW1lbnQ6IGNsb25lRWxlbWVudFdpdGhWYWxpZGF0aW9uLFxuICBjcmVhdGVGYWN0b3J5OiBjcmVhdGVGYWN0b3J5V2l0aFZhbGlkYXRpb24sXG4gIGlzVmFsaWRFbGVtZW50OiBpc1ZhbGlkRWxlbWVudCxcblxuICB2ZXJzaW9uOiBSZWFjdFZlcnNpb24sXG5cbiAgdW5zdGFibGVfQ29uY3VycmVudE1vZGU6IFJFQUNUX0NPTkNVUlJFTlRfTU9ERV9UWVBFLFxuICB1bnN0YWJsZV9Qcm9maWxlcjogUkVBQ1RfUFJPRklMRVJfVFlQRSxcblxuICBfX1NFQ1JFVF9JTlRFUk5BTFNfRE9fTk9UX1VTRV9PUl9ZT1VfV0lMTF9CRV9GSVJFRDogUmVhY3RTaGFyZWRJbnRlcm5hbHNcbn07XG5cbi8vIE5vdGU6IHNvbWUgQVBJcyBhcmUgYWRkZWQgd2l0aCBmZWF0dXJlIGZsYWdzLlxuLy8gTWFrZSBzdXJlIHRoYXQgc3RhYmxlIGJ1aWxkcyBmb3Igb3BlbiBzb3VyY2Vcbi8vIGRvbid0IG1vZGlmeSB0aGUgUmVhY3Qgb2JqZWN0IHRvIGF2b2lkIGRlb3B0cy5cbi8vIEFsc28gbGV0J3Mgbm90IGV4cG9zZSB0aGVpciBuYW1lcyBpbiBzdGFibGUgYnVpbGRzLlxuXG5pZiAoZW5hYmxlU3RhYmxlQ29uY3VycmVudE1vZGVBUElzKSB7XG4gIFJlYWN0LkNvbmN1cnJlbnRNb2RlID0gUkVBQ1RfQ09OQ1VSUkVOVF9NT0RFX1RZUEU7XG4gIFJlYWN0LlByb2ZpbGVyID0gUkVBQ1RfUFJPRklMRVJfVFlQRTtcbiAgUmVhY3QudW5zdGFibGVfQ29uY3VycmVudE1vZGUgPSB1bmRlZmluZWQ7XG4gIFJlYWN0LnVuc3RhYmxlX1Byb2ZpbGVyID0gdW5kZWZpbmVkO1xufVxuXG5cblxudmFyIFJlYWN0JDIgPSBPYmplY3QuZnJlZXplKHtcblx0ZGVmYXVsdDogUmVhY3Rcbn0pO1xuXG52YXIgUmVhY3QkMyA9ICggUmVhY3QkMiAmJiBSZWFjdCApIHx8IFJlYWN0JDI7XG5cbi8vIFRPRE86IGRlY2lkZSBvbiB0aGUgdG9wLWxldmVsIGV4cG9ydCBmb3JtLlxuLy8gVGhpcyBpcyBoYWNreSBidXQgbWFrZXMgaXQgd29yayB3aXRoIGJvdGggUm9sbHVwIGFuZCBKZXN0LlxudmFyIHJlYWN0ID0gUmVhY3QkMy5kZWZhdWx0IHx8IFJlYWN0JDM7XG5cbm1vZHVsZS5leHBvcnRzID0gcmVhY3Q7XG4gIH0pKCk7XG59XG4iLCIndXNlIHN0cmljdCc7XG5cbmlmIChwcm9jZXNzLmVudi5OT0RFX0VOViA9PT0gJ3Byb2R1Y3Rpb24nKSB7XG4gIG1vZHVsZS5leHBvcnRzID0gcmVxdWlyZSgnLi9janMvcmVhY3QucHJvZHVjdGlvbi5taW4uanMnKTtcbn0gZWxzZSB7XG4gIG1vZHVsZS5leHBvcnRzID0gcmVxdWlyZSgnLi9janMvcmVhY3QuZGV2ZWxvcG1lbnQuanMnKTtcbn1cbiJdLCJzb3VyY2VSb290IjoiIn0=