import "dart:html";

import 'package:react/react.dart';
import 'package:react/react_client/react_interop.dart';
import "package:react/react_dom.dart" as react_dom;
import "package:react/react_client.dart";

import "react_test_components.dart";

void main() {
  setClientConfiguration();
  ReactTracing.unstable_trace('inital render', window.performance.now(), () {
      return react_dom.render(
        Profiler({
            'id': 'ReactDartMain',
            'onRender': (id, phase, actualDuration, baseDuration, startTime, commitTime, interactions){
              print('id: $id');
              print('phase: $phase');
              print('actualDuration: $actualDuration');
              print('baseDuration: $baseDuration');
              print('startTime: $startTime');
              print('commitTime: $commitTime');
              window.console.log(interactions);
            }
          },
          mainComponent({}, [
            helloGreeter({'key': 'hello'}, []),
            listComponent({'key': 'list'}, []),
            component2TestComponent({'key': 'c2-list'}, []),
            component2ErrorTestComponent({'key': 'error-boundary'}, []),
            //clockComponent({"name": 'my-clock'}, []),
            checkBoxComponent({'key': 'checkbox'}, [])
          ])
        ),
        querySelector('#content'));
    }
  );
}
