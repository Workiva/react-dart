const objectAssign = require('object-assign');

if (!Object.assign) {
  Object.assign = objectAssign
}
