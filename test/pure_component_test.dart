@TestOn('browser')
library pure_component_test;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:test/test.dart';

import 'util.dart';

main() {
  setClientConfiguration();

  group('PureComponent', () {
    Element mountNode;
    dynamic renderedInstance;
    const initialId = 'initial';
    Map initialProps;
    List initialChildren;
    List initialNestedChildren;
    bool componentDidUpdate;
    Map updatedProps;
    Map updatedState;

    setUp(() {
      mountNode = new DivElement();
      document.body.append(mountNode);
      componentDidUpdate = false;
      initialProps = {
        'id': initialId,
        'foo': {
          'bar': 'baz',
        },
        'bar': DartClassToUseAsPropValue('baz'),
        'onComponentDidUpdate': (Map newProps, Map newState) {
          componentDidUpdate = true;
          updatedProps = newProps;
          updatedState = newState;
        }
      };
      initialNestedChildren = [
        react.div({'key': '1'}),
        react.div({'key': '2'}),
      ];
      initialChildren = [
        'child1',
        'child2',
        react.div(
          {'key': '1'},
          react.div({}),
          react.div({}, initialNestedChildren),
        ),
      ];
      renderedInstance = react_dom.render(TestPureComponent(initialProps, initialChildren), mountNode);
      expect(querySelector('#$initialId'), isNotNull, reason: 'test setup sanity check');
    });

    tearDown(() {
      react_dom.unmountComponentAtNode(mountNode);
      mountNode.remove();
      mountNode = null;
      renderedInstance = null;
      initialProps = null;
      initialChildren = null;
      initialNestedChildren = null;
      updatedProps = null;
      updatedState = null;
    });

    group('does not update', () {
      test('when props, state and children remain identical', () {
        renderedInstance = react_dom.render(TestPureComponent(initialProps, initialChildren), mountNode);
        expect(componentDidUpdate, isFalse);
      });

      test('when a new list of the initial children is passed in', () {
        renderedInstance = react_dom.render(TestPureComponent(initialProps, List.of(initialChildren)), mountNode);
        expect(componentDidUpdate, isFalse);
      });

      test('when a ref is added or changed', () {
        dynamic _someRef;
        dynamic _someOtherRef;
        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'ref': (ref) {
                _someRef = ref;
              }
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isFalse);
        expect(_someRef, isA<_TestPureComponent>());

        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'ref': (ref) {
                _someOtherRef = ref;
              }
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isFalse);
        expect(_someOtherRef, isA<_TestPureComponent>());
      });
    });

    group('updates', () {
      test('when an existing state value changes', () {
        getDartComponent(renderedInstance).setState({'stateKey': 'updatedValue'});
        expect(componentDidUpdate, isTrue);
        expect(updatedState['stateKey'], 'updatedValue');
      });

      test('when a new state value is added', () {
        getDartComponent(renderedInstance).setState({'newStateKey': 'newValue'});
        expect(componentDidUpdate, isTrue);
        expect(updatedState['stateKey'], 'initialValue');
        expect(updatedState['newStateKey'], 'newValue');
      });

      test('when a primitive prop value changes', () {
        const updatedId = 'updated';
        expect(updatedId, isNot(initialId), reason: 'test setup sanity check');
        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'id': updatedId,
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isTrue);
        expect(updatedProps['id'], updatedId);
      });

      test('when a map prop value changes', () {
        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'foo': {
                'bar': 'bizzle',
              },
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isTrue);
        expect(updatedProps['foo']['bar'], 'bizzle');
      });

      test('when a Dart class prop value changes', () {
        final updatedDartClassValue = DartClassToUseAsPropValue('bizzle');
        expect(updatedDartClassValue.foo, isNot((initialProps['bar'] as DartClassToUseAsPropValue).foo),
            reason: 'test setup sanity check');
        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'bar': updatedDartClassValue,
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isTrue);
        expect((updatedProps['bar'] as DartClassToUseAsPropValue).foo, 'bizzle');
      });

      test('when a new prop value is added', () {
        renderedInstance = react_dom.render(
            TestPureComponent({
              ...initialProps,
              'className': 'foo',
            }, initialChildren),
            mountNode);
        expect(componentDidUpdate, isTrue);
        expect(updatedProps['className'], 'foo');
      });

      test('when a new list of the initial children\'s nested children are passed in', () {
        renderedInstance = react_dom.render(
            TestPureComponent(initialProps, [
              'child1',
              'child2',
              react.div(
                {'key': '1'},
                react.div({}),
                react.div({}, List.of(initialNestedChildren)),
              ),
            ]),
            mountNode);
        expect(componentDidUpdate, isTrue,
            reason:
                'PureComponent does only a shallow comparison of children. New instances of identical children will still cause a re-render.');
      });

      group('when a string child is', () {
        test('updated', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2 updated',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });

        test('added', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                'child3',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });
      });

      group('when a component child is', () {
        test('updated with different props', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1', 'id': 'child-updated'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
          expect(querySelector('#child-updated'), isNotNull);
        });

        test('is swapped out for a different element', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.span(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });

        test('has its key changed', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1a'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });

        test('added', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
                react.div({'key': '2'})
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });
      });

      group('when a deeply nested component child is', () {
        test('updated with different props', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1', 'id': 'nested-child-updated'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
          expect(querySelector('#nested-child-updated'), isNotNull);
        });

        test('is swapped out for a different element', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.span({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });

        test('has its key changed', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1a'}),
                    react.div({'key': '2'}),
                  ]),
                ),
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });

        test('added', () {
          renderedInstance = react_dom.render(
              TestPureComponent(initialProps, [
                'child1',
                'child2',
                react.div(
                  {'key': '1'},
                  react.div({}),
                  react.div({}, [
                    react.div({'key': '1'}),
                    react.div({'key': '2'}),
                  ]),
                ),
                react.div({'key': '2'})
              ]),
              mountNode);
          expect(componentDidUpdate, isTrue);
        });
      });
    });
  });
}

const initialTestState = {'stateKey': 'initialValue'};

class DartClassToUseAsPropValue {
  final String foo;
  DartClassToUseAsPropValue(this.foo);
}

final TestPureComponent = react.registerComponent2(() => new _TestPureComponent());

class _TestPureComponent extends react.PureComponent {
  @override
  get initialState => initialTestState;

  @override
  void componentDidUpdate(Map prevProps, Map prevState, [dynamic snapshot]) {
    props['onComponentDidUpdate'](props, state);
  }

  @override
  render() => react.div({
        'id': props['id'],
        'className': props['className'],
      }, props['children']);
}
