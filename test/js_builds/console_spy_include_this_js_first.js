"use strict";

// This script must be included before react.js is so that it happens before
// the wrapping of console.warn that we'll be testing.

(function() {
  window.consoleWarnCalls = [];

  var originalConsoleWarn = console.warn;
  console.warn = function spyingConsoleWarn() {
    originalConsoleWarn.apply(console, arguments);

    // Convert args to Array object so it interops nicely with Dart.
    var argsArray = Array.prototype.slice.apply(arguments);
    consoleWarnCalls.push(argsArray);
  };
})();
