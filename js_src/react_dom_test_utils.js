const rtl = require('@testing-library/react');

const _buildTestingLibraryElementError = function(message) {
  const err = new Error(message);
  err.name = 'TestingLibraryElementError';
  return err;
}

const _handleGetElementError = function(message, container) {
  // With findBy* async queries, there is a race condition during which `originalMessage` will already
  // contain the prettyDOM-printed HTML of the `container`. This causes the prettyDOM-printed HTML to be
  // output twice in the error because of the call to `setEphemeralElementErrorMessage`,
  // which calls `buildCustomTestingLibraryElementJsError`, which assumes that the prettyDOM-printed output
  // is not already there. So we'll do an additional replace here to get rid of the prettyDOM-printed output
  // if found.
  const prettyDOMRegex = /(?<=[\s\S]*)\s*<\w+>[\s\S]+/gm;
  const newMessage = message?.replace(prettyDOMRegex, '') ?? '';
  const prettyDomOutput = rtl.prettyDOM(container);
  return _buildTestingLibraryElementError([newMessage, prettyDomOutput].filter(Boolean).join('\n\n'));
}

// Configure the test id to match what the Workiva ecosystem defaults to.
rtl.configure({
  testIdAttribute: 'data-test-id',
  getElementError: _handleGetElementError,
});

window.rtl = rtl;

window.buildJsGetElementError = _handleGetElementError;
window.buildTestingLibraryElementError = _buildTestingLibraryElementError;
