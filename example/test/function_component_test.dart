import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var hookTestFunctionComponent = react.registerFunctionComponent(HookTestComponent, displayName: 'useStateTest');

HookTestComponent(Map props) {
  final count = useState(1);
  final evenOdd = useState('even');

  useEffect(() {
    if (count.value % 2 == 0) {
      print('count changed to ' + count.value.toString());
      evenOdd.set('even');
    } else {
      print('count changed to ' + count.value.toString());
      evenOdd.set('odd');
    }
    return () {
      print('count is changing...');
    };
  }, [count.value]);

  return react.div({}, [
    react.button({'onClick': (_) => count.set(1)}, ['Reset']),
    react.button({
      'onClick': (_) => count.setWithUpdater((prev) => prev + 1),
    }, [
      '+'
    ]),
    react.br({}),
    react.p({}, [count.value.toString() + ' is ' + evenOdd.value.toString()]),
  ]);
}

final ChatAPI = {
  'subscribeToFriendStatus': (int id, Function handleStatusChange) =>
      handleStatusChange({'isOnline': id % 2 == 0 ? true : false}),
  'unsubscribeFromFriendStatus': (int id, Function handleStatusChange) => handleStatusChange({'isOnline': false}),
};

StateHook useFriendStatus(friendID) {
  final isOnline = useState(false);

  void handleStatusChange(Map status) {
    isOnline.set(status['isOnline']);
  }

  useEffect(() {
    ChatAPI['subscribeToFriendStatus'](friendID, handleStatusChange);
    return () {
      ChatAPI['subscribeToFriendStatus'](friendID, handleStatusChange);
    };
  });

  useDebugValue(isOnline.value ? 'Online' : 'Not Online');

  return isOnline;
}

var FriendListItem = react.registerFunctionComponent(_friendListItem, displayName: 'FriendListItem');

_friendListItem(Map props) {
  final isOnline = useFriendStatus(props['friend']['id']);

  return react.li({
    'style': {'color': isOnline.value ? 'green' : 'black'}
  }, [
    props['friend']['name']
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState & useEffect Hook Test']),
          hookTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
          react.h2({'key': 'useDebugValueTestLabel'}, ['useDebugValue Hook Test']),
          FriendListItem({
            'friend': {'id': 1, 'name': 'user 1'}
          }, []),
          FriendListItem({
            'friend': {'id': 2, 'name': 'user 2'}
          }, []),
          FriendListItem({
            'friend': {'id': 3, 'name': 'user 3'}
          }, []),
          FriendListItem({
            'friend': {'id': 4, 'name': 'user 4'}
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
