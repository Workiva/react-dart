@TestOn('browser')
@JS()
library react_version_test;

import 'package:js/js.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

void main() {
  // This test helps us verify our test setup, ensuring
  // we're running on the React version we expect to be.

  test('Setup check: window.React is React 17', () {
    expect(React.version, startsWith('17.'));
  }, tags: 'react-17');
  test('Setup check: window.React is React 18', () {
    expect(React.version, startsWith('18.'));
  }, tags: 'react-18');
  // Then, when running tests:
  // - on React 17: `dart run build_runner test -- ... --exclude-tags=react-18`
  // - on React 18: `dart run build_runner test -- ... --exclude-tags=react-17`
}
