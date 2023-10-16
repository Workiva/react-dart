// This file generates a mockito.mocks.dart, containing mock classes that
// can be imported by other tests.

library react.test.mockito_gen_entrypoint;

import 'dart:html';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<KeyboardEvent>(),
  MockSpec<DataTransfer>(),
  MockSpec<MouseEvent>(),
])
main() {}
