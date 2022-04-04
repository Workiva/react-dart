@TestOn('browser')
import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react_testing_library/matchers.dart';
import 'package:react_testing_library/react_testing_library.dart' as rtl;
import 'package:react_testing_library/user_event.dart' as rtl;
import 'package:test/test.dart';

main() {
  group('Suspense', () {
    ReactElement fallback;

    setUp(() {
      fallback = react.div({}, 'fallback');
    });

    // FIXME: How is this supposed to work?
    // test('renders fallback', () {
    //   rtl.render(
    //     react.Suspense({'fallback': fallback}, SuspenseTest({})),
    //   );
    //
    //   expect(rtl.screen.getByText('fallback'), isInTheDocument);
    // });

    test('renders children eventually', () {
      rtl.render(
        react.Suspense({'fallback': fallback}, SuspenseTest({})),
      );

      expect(rtl.screen.getByText('children'), isInTheDocument);
    });
  });
}

final SuspenseTest = react.registerFunctionComponent((Map props) {
  final state = useState(0);
  final transition = useTransition();

  useEffect(() {
    transition.startTransition(() {
      state.setWithUpdater((oldValue) => oldValue++);
    });
  }, const []);

  return react.div({}, state.value);
});
