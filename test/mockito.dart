// This file generates a mockito.mocks.dart, containing mock classes that
// can be imported by other tests.

library react.test.mockito_gen_entrypoint;

import 'dart:html';
import 'package:mockito/annotations.dart';
import 'package:react/src/react_client/synthetic_event_wrappers.dart';

@GenerateNiceMocks([
  MockSpec<KeyboardEvent>(),
  MockSpec<DataTransfer>(),
  MockSpec<MouseEvent>(),
  MockSpec<SyntheticEvent>(),
])
main() {}
