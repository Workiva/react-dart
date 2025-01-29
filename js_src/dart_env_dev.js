React.__isDevelopment = true;

if (typeof window.MemoryInfo == "undefined") {
  if (typeof window.performance.memory != "undefined") {
    window.MemoryInfo = function () {};
    window.MemoryInfo.prototype = window.performance.memory.__proto__;
  }
}

// Intercept console.error calls and silence warnings for each react_dom.render call,
// until at the very least createRoot is made available in react-dart and RTL.
const oldConsoleError = console.error;
console.error = function() {
  const firstArg = arguments[0];
  // Use startsWith instead of indexOf as a small optimization for when large strings are logged.
  if (typeof firstArg === 'string' && firstArg.startsWith('Warning: ReactDOM.render is no longer supported in React 18.')) {
    // Suppress the error.
  } else {
    oldConsoleError.apply(console, arguments);
  }
}
