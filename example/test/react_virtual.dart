import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_virtual.dart';

final RowVirtualizerFixed = react.registerFunctionComponent((Map props) {
  final parentRef = useRef<HtmlElement>();

  final rowVirtualizer = useVirtual(Options(
    size: 10000,
    parentRef: parentRef.jsRef,
    estimateSize: useCallback((_) => 35, []),
    overscan: 5,
  ));

  return react.Fragment(
    {},
    react.div(
      {
        'ref': parentRef,
        'className': "List",
        'style': {
          'height': '200px',
          'width': '400px',
          'overflow': 'auto',
        },
      },
      react.div(
        {
          'style': {
            'height': '${rowVirtualizer.totalSize}px',
            'width': '100%',
            'position': 'relative',
          },
        },
        rowVirtualizer.virtualItems.map(
          (virtualRow) {
            return (react.div(
              {
                'key': virtualRow.index,
                'className': virtualRow.index % 2 != 0 ? 'ListItemOdd' : 'ListItemEven',
                'style': {
                  'position': 'absolute',
                  'top': 0,
                  'left': 0,
                  'width': '100%',
                  'height': '${virtualRow.size}px',
                  'transform': 'translateY(${virtualRow.start}px)',
                }
              },
              'Row',
              virtualRow.index,
            ));
          },
        ),
      ),
    ),
  );
}, displayName: 'RowVirtualizerFixed');

void main() {
  render() {
    react_dom.render(react.Fragment({}, [RowVirtualizerFixed({})]), querySelector('#content'));
  }

  render();
}
