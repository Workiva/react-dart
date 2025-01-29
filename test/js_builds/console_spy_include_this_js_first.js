"use strict";

// This script must be included before react.js is so that it happens before
// the wrapping of console.error that we'll be testing.

(function() {
  window.consoleErrorCalls = [];

  const originalConsoleError = console.error;
  console.error = function spyingConsoleError() {
    originalConsoleError.apply(console, arguments);

    // Convert args to Array object so it interops nicely with Dart.
    const argsArray = [...arguments];
    consoleErrorCalls.push(argsArray);
  };
})();
