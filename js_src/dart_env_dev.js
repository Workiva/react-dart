if (typeof window.MemoryInfo == "undefined") {
  if (typeof window.performance.memory != "undefined") {
    window.MemoryInfo = function () {};
    window.MemoryInfo.prototype = window.performance.memory.__proto__;
  }
}

// Intercept console.warn calls and prevent excessive warnings in DDC-compiled code
// when type-checking event handlers (function types that include SyntheticEvent classes).
//
// These warnings are a result of a workaround to https://github.com/dart-lang/sdk/issues/43939
const oldConsoleWarn = console.warn;
let hasWarned = false;
console.warn = function() {
  const firstArg = arguments[0];
  // Use startsWith instead of indexOf as a small optimization for when large strings are logged.
  if (typeof firstArg === 'string' && firstArg.startsWith('Cannot find native JavaScript type (Synthetic')) {
    if (!hasWarned) {
      hasWarned = true;
      oldConsoleWarn.apply(console, arguments);
      oldConsoleWarn('The above warning is expected and is the result of a workaround to https://github.com/dart-lang/sdk/issues/43939');
    }
  } else {
    oldConsoleWarn.apply(console, arguments);
  }
}
