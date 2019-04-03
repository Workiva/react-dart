// Reflect.deleteProperty polyfill for IE11
if (typeof Reflect === 'undefined') {
  Reflect = {};
}
if (typeof Reflect.deleteProperty !== 'function') {
  Object.defineProperty(Reflect, 'deleteProperty', {
    value: function deleteProperty(target, propertyKey) {
      return (delete target[propertyKey]);
    }
  });
}

