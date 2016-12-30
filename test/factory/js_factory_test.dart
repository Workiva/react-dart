@TestOn('browser')
import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'common_factory_tests.dart';

main() {
  setClientConfiguration();

  group('ReactJsComponentFactoryProxy', () {
    test('has a type corresponding to the backing JS class', () {
      expect(jsFactoryProxy.type, equals(jsClass));
    });

    group('- common factory behavior -', () {
      commonFactoryTests(jsFactoryProxy);
    });
  });
}

final jsClass = React.createClass(new ReactClassConfig(
    render: allowInterop(() => react.div({}))
));
final jsFactoryProxy = new ReactJsComponentFactoryProxy(jsClass);
