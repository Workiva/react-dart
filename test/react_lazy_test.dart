@TestOn('browser')
library react.react_lazy_test;

import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'factory/common_factory_tests.dart';

main() {
  group('lazy', () {
    group('- common factory behavior -', () {
      final LazyTest = react.lazy(() async => react.registerFunctionComponent((props) {
        props['onDartRender']?.call(props);
        return react.div({...props});
      }));

      commonFactoryTests(
        LazyTest,
        // ignore: invalid_use_of_protected_member
        dartComponentVersion: ReactDartComponentVersion.component2,
        renderWrapper: (child) => react.Suspense({'fallback': 'Loading...'}, child),
      );
    });
  });
}
