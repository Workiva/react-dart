React.__isDevelopment = true;

if (typeof window.MemoryInfo == "undefined") {
  if (typeof window.performance.memory != "undefined") {
    window.MemoryInfo = function () {};
    window.MemoryInfo.prototype = window.performance.memory.__proto__;
  }
}
