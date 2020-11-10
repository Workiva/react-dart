@TestOn('browser')
library react.event_helpers_test;

import 'dart:html';

import 'package:react/react.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/src/react_client/event_helpers.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

main() {
  group('Synthetic event helpers', () {
    const testString = 'test';
    const updatedTestString = 'test updated';

    // A counter used to verify that callbacks work as expected.
    var mergeTestCounter = 0;

    setUp(() {
      mergeTestCounter = 0;
    });

    void testSyntheticEventDefaults(SyntheticEvent event) {
      // Boolean defaults
      expect(event.bubbles, isFalse);
      expect(event.cancelable, isTrue);
      expect(event.defaultPrevented, isFalse);
      expect(event.isTrusted, isFalse);

      // Other defaults
      expect(event.type, isNotNull,
          reason: 'The implementation (i.e. value) does not matter, but this should be a non-empty value');
      expect(event.timeStamp, 0);

      // Null defaults
      expect(event.currentTarget, isNull);
      expect(event.nativeEvent, isNull);
      expect(event.eventPhase, isNull);
      expect(event.target, isNull);

      // Function properties
      expect(() => event.stopPropagation(), returnsNormally);
      expect(() => event.preventDefault(), returnsNormally);
      // TODO should this still pass?
//      expect(event.defaultPrevented, isTrue, reason: 'calling preventDefault sets the value to true.');
    }

    void testSyntheticEventBaseForMergeTests(SyntheticEvent event) {
      // Boolean defaults
      expect(event.bubbles, isTrue);
      expect(event.cancelable, isFalse);
      expect(event.defaultPrevented, isTrue);
      expect(event.isTrusted, isTrue);

      // Other defaults
      expect(event.type, 'non-default');
      expect(event.timeStamp, 100);

      // Null defaults
      expect(event.currentTarget, isA<InputElement>());
      expect(event.nativeEvent, 'string');
      expect(event.eventPhase, 0);
      expect(event.target, isA<InputElement>());

      // Function properties
      expect(() => event.stopPropagation(), returnsNormally, reason: 'this defaults to an empty function');
      expect(() => event.preventDefault(), returnsNormally);
      // TODO should this still pass?
//      expect(event.defaultPrevented, isTrue, reason: 'calling preventDefault sets the value to true.');
    }

    void testSyntheticEventBaseAfterMerge(SyntheticEvent event) {
      // Boolean defaults
      expect(event.bubbles, isFalse);
      expect(event.cancelable, isTrue);
      expect(event.defaultPrevented, isFalse);
      expect(event.isTrusted, isFalse);

      // Other defaults
      expect(event.type, 'updated non-default');
      expect(event.timeStamp, 200);

      // Null defaults
      expect(event.currentTarget, isA<DivElement>());
      expect(event.nativeEvent, 'updated string');
      expect(event.eventPhase, 2);
      expect(event.target, isA<DivElement>());

      // Function properties
      expect(mergeTestCounter, 0, reason: 'test setup sanity check');

      event.stopPropagation();
      expect(mergeTestCounter, 1);

      event.preventDefault();
      expect(mergeTestCounter, 2);
    }

    test('wrapNativeKeyboardEvent', () {
      var nativeKeyboardEvent = MockKeyboardEvent();
      var currentTarget = DivElement();
      var target = DivElement();
      var calls = <String>[];

      when(nativeKeyboardEvent.bubbles).thenReturn(true);
      when(nativeKeyboardEvent.cancelable).thenReturn(true);
      when(nativeKeyboardEvent.currentTarget).thenReturn(currentTarget);
      when(nativeKeyboardEvent.defaultPrevented).thenReturn(false);
      when(nativeKeyboardEvent.preventDefault()).thenAnswer((_) => calls.add('preventDefault'));
      when(nativeKeyboardEvent.stopPropagation()).thenAnswer((_) => calls.add('stopPropagation'));
      when(nativeKeyboardEvent.eventPhase).thenReturn(0);
      when(nativeKeyboardEvent.target).thenReturn(target);
      when(nativeKeyboardEvent.timeStamp).thenReturn(0);
      when(nativeKeyboardEvent.type).thenReturn('type');
      when(nativeKeyboardEvent.altKey).thenReturn(false);
      when(nativeKeyboardEvent.charCode).thenReturn(0);
      when(nativeKeyboardEvent.ctrlKey).thenReturn(false);
      when(nativeKeyboardEvent.location).thenReturn(0);
      when(nativeKeyboardEvent.keyCode).thenReturn(0);
      when(nativeKeyboardEvent.metaKey).thenReturn(false);
      when(nativeKeyboardEvent.repeat).thenReturn(false);
      when(nativeKeyboardEvent.shiftKey).thenReturn(false);

      expect(nativeKeyboardEvent.defaultPrevented, isFalse);

      var syntheticKeyboardEvent = wrapNativeKeyboardEvent(nativeKeyboardEvent);

      expect(syntheticKeyboardEvent, isA<SyntheticKeyboardEvent>());

      expect(syntheticKeyboardEvent.bubbles, isTrue);
      expect(syntheticKeyboardEvent.cancelable, isTrue);
      expect(syntheticKeyboardEvent.currentTarget, currentTarget);
      expect(syntheticKeyboardEvent.defaultPrevented, isFalse);
      expect(() => syntheticKeyboardEvent.preventDefault(), returnsNormally);
      expect(calls, contains('preventDefault'));
      expect(() => syntheticKeyboardEvent.stopPropagation(), returnsNormally);
      expect(calls, contains('stopPropagation'));
      expect(syntheticKeyboardEvent.eventPhase, 0);
      expect(syntheticKeyboardEvent.isTrusted, isNull);
      expect(syntheticKeyboardEvent.nativeEvent, nativeKeyboardEvent);
      expect(syntheticKeyboardEvent.target, target);
      expect(syntheticKeyboardEvent.timeStamp, 0);
      expect(syntheticKeyboardEvent.type, 'type');
      expect(syntheticKeyboardEvent.altKey, isFalse);
      expect(syntheticKeyboardEvent.char, String.fromCharCode(0));
      expect(syntheticKeyboardEvent.charCode, 0);
      expect(syntheticKeyboardEvent.ctrlKey, isFalse);
      expect(syntheticKeyboardEvent.locale, isNull);
      expect(syntheticKeyboardEvent.location, 0);
      expect(syntheticKeyboardEvent.key, isNull);
      expect(syntheticKeyboardEvent.keyCode, 0);
      expect(syntheticKeyboardEvent.metaKey, isFalse);
      expect(syntheticKeyboardEvent.repeat, isFalse);
      expect(syntheticKeyboardEvent.shiftKey, isFalse);
    });

    test('wrapNativeMouseEvent', () {
      var nativeMouseEvent = MockMouseEvent();
      var currentTarget = DivElement();
      var target = DivElement();
      var relatedTarget = DivElement();
      var calls = <String>[];

      when(nativeMouseEvent.bubbles).thenReturn(true);
      when(nativeMouseEvent.cancelable).thenReturn(true);
      when(nativeMouseEvent.currentTarget).thenReturn(currentTarget);
      when(nativeMouseEvent.defaultPrevented).thenReturn(false);
      when(nativeMouseEvent.preventDefault()).thenAnswer((_) => calls.add('preventDefault'));
      when(nativeMouseEvent.stopPropagation()).thenAnswer((_) => calls.add('stopPropagation'));
      when(nativeMouseEvent.eventPhase).thenReturn(0);
      when(nativeMouseEvent.target).thenReturn(target);
      when(nativeMouseEvent.timeStamp).thenReturn(0);
      when(nativeMouseEvent.type).thenReturn('type');
      when(nativeMouseEvent.altKey).thenReturn(false);
      when(nativeMouseEvent.button).thenReturn(0);
      when(nativeMouseEvent.ctrlKey).thenReturn(false);
      when(nativeMouseEvent.metaKey).thenReturn(false);
      when(nativeMouseEvent.relatedTarget).thenReturn(relatedTarget);
      when(nativeMouseEvent.shiftKey).thenReturn(false);
      when(nativeMouseEvent.client).thenReturn(Point(1, 2));
      when(nativeMouseEvent.page).thenReturn(Point(3, 4));
      when(nativeMouseEvent.screen).thenReturn(Point(5, 6));

      var syntheticMouseEvent = wrapNativeMouseEvent(nativeMouseEvent);

      expect(syntheticMouseEvent, isA<SyntheticMouseEvent>());

      expect(syntheticMouseEvent.bubbles, isTrue);
      expect(syntheticMouseEvent.cancelable, isTrue);
      expect(syntheticMouseEvent.currentTarget, currentTarget);
      expect(syntheticMouseEvent.defaultPrevented, isFalse);
      expect(() => syntheticMouseEvent.preventDefault(), returnsNormally);
      expect(calls, contains('preventDefault'));
      expect(() => syntheticMouseEvent.stopPropagation(), returnsNormally);
      expect(calls, contains('stopPropagation'));
      expect(syntheticMouseEvent.eventPhase, 0);
      expect(syntheticMouseEvent.isTrusted, isNull);
      expect(syntheticMouseEvent.nativeEvent, nativeMouseEvent);
      expect(syntheticMouseEvent.target, target);
      expect(syntheticMouseEvent.timeStamp, 0);
      expect(syntheticMouseEvent.type, 'type');
      expect(syntheticMouseEvent.altKey, isFalse);
      expect(syntheticMouseEvent.button, 0);
      expect(syntheticMouseEvent.buttons, isNull);
      expect(syntheticMouseEvent.clientX, 1);
      expect(syntheticMouseEvent.clientY, 2);
      expect(syntheticMouseEvent.ctrlKey, isFalse);
      expect(syntheticMouseEvent.dataTransfer, isNull);
      expect(syntheticMouseEvent.metaKey, isFalse);
      expect(syntheticMouseEvent.pageX, 3);
      expect(syntheticMouseEvent.pageY, 4);
      expect(syntheticMouseEvent.relatedTarget, relatedTarget);
      expect(syntheticMouseEvent.screenX, 5);
      expect(syntheticMouseEvent.screenY, 6);
      expect(syntheticMouseEvent.shiftKey, isFalse);
    });

    test('fakeSyntheticFormEvent', () {
      var element = DivElement();
      var fakeEvent = fakeSyntheticFormEvent(element, 'change');

      expect(fakeEvent, isA<SyntheticFormEvent>());

      expect(fakeEvent.bubbles, isFalse);
      expect(fakeEvent.cancelable, isFalse);
      expect(fakeEvent.currentTarget, element);
      expect(fakeEvent.defaultPrevented, false);
      expect(() => fakeEvent.preventDefault(), returnsNormally);
      expect(() => fakeEvent.stopPropagation(), returnsNormally);
      expect(fakeEvent.eventPhase, Event.AT_TARGET);
      expect(fakeEvent.isTrusted, isFalse);
      expect(fakeEvent.nativeEvent, isNull);
      expect(fakeEvent.target, element);
      expect(fakeEvent.timeStamp, isA<int>());
      expect(fakeEvent.type, 'change');
    });

    group('createSyntheticEvent', () {
      test('returns normally when no parameters are provided', () {
        testSyntheticEventDefaults(createSyntheticEvent());
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newElement = DivElement();
          final newEvent = createSyntheticEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newEvent = createSyntheticEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
        });
      });
    });

    group('createSyntheticClipboardEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticClipboardEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.clipboardData, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticClipboardEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            clipboardData: 'initial data',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.clipboardData, 'initial data');

          final newElement = DivElement();
          final newEvent = createSyntheticClipboardEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            clipboardData: 'new data',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.clipboardData, 'new data');
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticClipboardEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            clipboardData: 'initial data',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.clipboardData, 'initial data');

          final newEvent = createSyntheticClipboardEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.clipboardData, 'initial data');
        });
      });
    });

    group('createSyntheticKeyboardEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticKeyboardEvent();

        testSyntheticEventDefaults(e);

        // keyboard event properties
        expect(e.altKey, isFalse);
        expect(e.char, isNull);
        expect(e.ctrlKey, isFalse);
        expect(e.locale, isNull);
        expect(e.location, isNull);
        expect(e.key, isNull);
        expect(e.metaKey, isFalse);
        expect(e.repeat, isNull);
        expect(e.shiftKey, isFalse);
        expect(e.keyCode, isNull);
        expect(e.charCode, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticKeyboardEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            char: testString + '1',
            ctrlKey: true,
            locale: testString + '2',
            location: 1,
            key: testString + '3',
            metaKey: true,
            repeat: true,
            shiftKey: true,
            keyCode: 2,
            charCode: 3,
          );

          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.char, testString + '1');
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.locale, testString + '2');
          expect(baseEvent.location, 1);
          expect(baseEvent.key, testString + '3');
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.repeat, isTrue);
          expect(baseEvent.shiftKey, isTrue);
          expect(baseEvent.keyCode, 2);
          expect(baseEvent.charCode, 3);

          final newElement = DivElement();
          final newEvent = createSyntheticKeyboardEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            altKey: false,
            char: updatedTestString + '1',
            ctrlKey: false,
            locale: updatedTestString + '2',
            location: 2,
            key: updatedTestString + '3',
            metaKey: false,
            repeat: false,
            shiftKey: false,
            keyCode: 3,
            charCode: 4,
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.altKey, isFalse);
          expect(newEvent.char, updatedTestString + '1');
          expect(newEvent.ctrlKey, isFalse);
          expect(newEvent.locale, updatedTestString + '2');
          expect(newEvent.location, 2);
          expect(newEvent.key, updatedTestString + '3');
          expect(newEvent.metaKey, isFalse);
          expect(newEvent.repeat, isFalse);
          expect(newEvent.shiftKey, isFalse);
          expect(newEvent.keyCode, 3);
          expect(newEvent.charCode, 4);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticKeyboardEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            char: testString + '1',
            ctrlKey: true,
            locale: testString + '2',
            location: 1,
            key: testString + '3',
            metaKey: true,
            repeat: true,
            shiftKey: true,
            keyCode: 2,
            charCode: 3,
          );

          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.char, testString + '1');
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.locale, testString + '2');
          expect(baseEvent.location, 1);
          expect(baseEvent.key, testString + '3');
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.repeat, isTrue);
          expect(baseEvent.shiftKey, isTrue);
          expect(baseEvent.keyCode, 2);
          expect(baseEvent.charCode, 3);

          final newEvent = createSyntheticKeyboardEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.altKey, isTrue);
          expect(newEvent.char, testString + '1');
          expect(newEvent.ctrlKey, isTrue);
          expect(newEvent.locale, testString + '2');
          expect(newEvent.location, 1);
          expect(newEvent.key, testString + '3');
          expect(newEvent.metaKey, isTrue);
          expect(newEvent.repeat, isTrue);
          expect(newEvent.shiftKey, isTrue);
          expect(newEvent.keyCode, 2);
          expect(newEvent.charCode, 3);
        });
      });
    });

    group('createSyntheticCompositionEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticCompositionEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.data, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticCompositionEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            data: 'initial data',
          );
          testSyntheticEventBaseForMergeTests(baseEvent); // Sanity check
          expect(baseEvent.data, 'initial data');

          final newElement = DivElement();
          final newEvent = createSyntheticCompositionEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            data: 'new data',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.data, 'new data');
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticCompositionEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            data: 'initial data',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.data, 'initial data');

          final newEvent = createSyntheticCompositionEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.data, 'initial data');
        });
      });
    });

    group('createSyntheticFocusEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticFocusEvent();
        testSyntheticEventDefaults(e);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticFocusEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newElement = DivElement();
          final newEvent = createSyntheticFocusEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticFocusEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newEvent = createSyntheticFocusEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
        });
      });
    });

    group('createSyntheticFormEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticFormEvent();
        testSyntheticEventDefaults(e);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticFormEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newElement = DivElement();
          final newEvent = createSyntheticFormEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticFormEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);

          final newEvent = createSyntheticFormEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
        });
      });
    });

    group('createSyntheticMouseEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticMouseEvent();
        testSyntheticEventDefaults(e);

        expect(e.altKey, isFalse);
        expect(e.button, isNull);
        expect(e.buttons, isNull);
        expect(e.clientX, isNull);
        expect(e.clientY, isNull);
        expect(e.ctrlKey, isFalse);
        expect(e.dataTransfer, isNull);
        expect(e.metaKey, isFalse);
        expect(e.pageX, isNull);
        expect(e.pageY, isNull);
        expect(e.relatedTarget, isNull);
        expect(e.screenX, isNull);
        expect(e.screenY, isNull);
        expect(e.shiftKey, isFalse);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticMouseEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            button: 1,
            buttons: 2,
            clientX: 100,
            clientY: 200,
            ctrlKey: true,
            dataTransfer: jsifyAndAllowInterop({'dropEffect': testString}) as NonNativeDataTransfer,
            metaKey: true,
            pageX: 300,
            pageY: 400,
            relatedTarget: testString,
            screenX: 500,
            screenY: 600,
            shiftKey: true,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.button, 1);
          expect(baseEvent.buttons, 2);
          expect(baseEvent.clientX, 100);
          expect(baseEvent.clientY, 200);
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.dataTransfer.dropEffect, testString);
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.pageX, 300);
          expect(baseEvent.pageY, 400);
          expect(baseEvent.relatedTarget, testString);
          expect(baseEvent.screenX, 500);
          expect(baseEvent.screenY, 600);
          expect(baseEvent.shiftKey, isTrue);

          final newElement = DivElement();
          final newEvent = createSyntheticMouseEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            altKey: false,
            button: 2,
            buttons: 3,
            clientX: 200,
            clientY: 300,
            ctrlKey: false,
            dataTransfer: jsifyAndAllowInterop({'dropEffect': updatedTestString}) as NonNativeDataTransfer,
            metaKey: false,
            pageX: 400,
            pageY: 500,
            relatedTarget: updatedTestString,
            screenX: 600,
            screenY: 700,
            shiftKey: false,
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.altKey, isFalse);
          expect(newEvent.button, 2);
          expect(newEvent.buttons, 3);
          expect(newEvent.clientX, 200);
          expect(newEvent.clientY, 300);
          expect(newEvent.ctrlKey, isFalse);
          expect(newEvent.dataTransfer.dropEffect, updatedTestString);
          expect(newEvent.metaKey, isFalse);
          expect(newEvent.pageX, 400);
          expect(newEvent.pageY, 500);
          expect(newEvent.relatedTarget, updatedTestString);
          expect(newEvent.screenX, 600);
          expect(newEvent.screenY, 700);
          expect(newEvent.shiftKey, isFalse);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticMouseEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            button: 1,
            buttons: 2,
            clientX: 100,
            clientY: 200,
            ctrlKey: true,
            dataTransfer: jsifyAndAllowInterop({'dropEffect': testString}) as NonNativeDataTransfer,
            metaKey: true,
            pageX: 300,
            pageY: 400,
            relatedTarget: testString,
            screenX: 500,
            screenY: 600,
            shiftKey: true,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.button, 1);
          expect(baseEvent.buttons, 2);
          expect(baseEvent.clientX, 100);
          expect(baseEvent.clientY, 200);
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.dataTransfer.dropEffect, testString);
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.pageX, 300);
          expect(baseEvent.pageY, 400);
          expect(baseEvent.relatedTarget, testString);
          expect(baseEvent.screenX, 500);
          expect(baseEvent.screenY, 600);
          expect(baseEvent.shiftKey, isTrue);

          final newEvent = createSyntheticMouseEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.altKey, isTrue);
          expect(newEvent.button, 1);
          expect(newEvent.buttons, 2);
          expect(newEvent.clientX, 100);
          expect(newEvent.clientY, 200);
          expect(newEvent.ctrlKey, isTrue);
          expect(newEvent.dataTransfer.dropEffect, testString);
          expect(newEvent.metaKey, isTrue);
          expect(newEvent.pageX, 300);
          expect(newEvent.pageY, 400);
          expect(newEvent.relatedTarget, testString);
          expect(newEvent.screenX, 500);
          expect(newEvent.screenY, 600);
          expect(newEvent.shiftKey, isTrue);
        });
      });
    });

    group('createSyntheticPointerEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticPointerEvent();
        testSyntheticEventDefaults(e);

        expect(e.pointerId, isNull);
        expect(e.width, isNull);
        expect(e.height, isNull);
        expect(e.pressure, isNull);
        expect(e.tangentialPressure, isNull);
        expect(e.tiltX, isNull);
        expect(e.tiltY, isNull);
        expect(e.twist, isNull);
        expect(e.pointerType, isNull);
        expect(e.isPrimary, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticPointerEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            pointerId: 1,
            width: 2,
            height: 3,
            pressure: 4,
            tangentialPressure: 5,
            tiltX: 6,
            tiltY: 7,
            twist: 8,
            pointerType: testString,
            isPrimary: false,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.pointerId, 1);
          expect(baseEvent.width, 2);
          expect(baseEvent.height, 3);
          expect(baseEvent.pressure, 4);
          expect(baseEvent.tangentialPressure, 5);
          expect(baseEvent.tiltX, 6);
          expect(baseEvent.tiltY, 7);
          expect(baseEvent.twist, 8);
          expect(baseEvent.pointerType, testString);
          expect(baseEvent.isPrimary, isFalse);

          final newElement = DivElement();
          final newEvent = createSyntheticPointerEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            pointerId: 2,
            width: 3,
            height: 4,
            pressure: 5,
            tangentialPressure: 6,
            tiltX: 7,
            tiltY: 8,
            twist: 9,
            pointerType: updatedTestString,
            isPrimary: true,
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.pointerId, 2);
          expect(newEvent.width, 3);
          expect(newEvent.height, 4);
          expect(newEvent.pressure, 5);
          expect(newEvent.tangentialPressure, 6);
          expect(newEvent.tiltX, 7);
          expect(newEvent.tiltY, 8);
          expect(newEvent.twist, 9);
          expect(newEvent.pointerType, updatedTestString);
          expect(newEvent.isPrimary, isTrue);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticPointerEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            pointerId: 1,
            width: 2,
            height: 3,
            pressure: 4,
            tangentialPressure: 5,
            tiltX: 6,
            tiltY: 7,
            twist: 8,
            pointerType: testString,
            isPrimary: false,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.pointerId, 1);
          expect(baseEvent.width, 2);
          expect(baseEvent.height, 3);
          expect(baseEvent.pressure, 4);
          expect(baseEvent.tangentialPressure, 5);
          expect(baseEvent.tiltX, 6);
          expect(baseEvent.tiltY, 7);
          expect(baseEvent.twist, 8);
          expect(baseEvent.pointerType, testString);
          expect(baseEvent.isPrimary, isFalse);

          final newEvent = createSyntheticPointerEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.pointerId, 1);
          expect(newEvent.width, 2);
          expect(newEvent.height, 3);
          expect(newEvent.pressure, 4);
          expect(newEvent.tangentialPressure, 5);
          expect(newEvent.tiltX, 6);
          expect(newEvent.tiltY, 7);
          expect(newEvent.twist, 8);
          expect(newEvent.pointerType, testString);
          expect(newEvent.isPrimary, isFalse);
        });
      });
    });

    group('createSyntheticTouchEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticTouchEvent();
        testSyntheticEventDefaults(e);
        expect(e.altKey, isFalse);
        expect(e.altKey, isFalse);
        expect(e.changedTouches, isNull);
        expect(e.ctrlKey, isFalse);
        expect(e.metaKey, isFalse);
        expect(e.shiftKey, isFalse);
        expect(e.targetTouches, isNull);
        expect(e.touches, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticTouchEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            changedTouches: testString + '1',
            ctrlKey: true,
            metaKey: true,
            shiftKey: true,
            targetTouches: testString + '2',
            touches: testString + '3',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.changedTouches, testString + '1');
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.shiftKey, isTrue);
          expect(baseEvent.targetTouches, testString + '2');
          expect(baseEvent.touches, testString + '3');

          final newElement = DivElement();
          final newEvent = createSyntheticTouchEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            altKey: false,
            changedTouches: updatedTestString + '1',
            ctrlKey: false,
            metaKey: false,
            shiftKey: false,
            targetTouches: updatedTestString + '2',
            touches: updatedTestString + '3',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.altKey, isFalse);
          expect(newEvent.changedTouches, updatedTestString + '1');
          expect(newEvent.ctrlKey, isFalse);
          expect(newEvent.metaKey, isFalse);
          expect(newEvent.shiftKey, isFalse);
          expect(newEvent.targetTouches, updatedTestString + '2');
          expect(newEvent.touches, updatedTestString + '3');
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticTouchEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            altKey: true,
            changedTouches: testString + '1',
            ctrlKey: true,
            metaKey: true,
            shiftKey: true,
            targetTouches: testString + '2',
            touches: testString + '3',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.altKey, isTrue);
          expect(baseEvent.changedTouches, testString + '1');
          expect(baseEvent.ctrlKey, isTrue);
          expect(baseEvent.metaKey, isTrue);
          expect(baseEvent.shiftKey, isTrue);
          expect(baseEvent.targetTouches, testString + '2');
          expect(baseEvent.touches, testString + '3');

          final newEvent = createSyntheticTouchEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.altKey, isTrue);
          expect(newEvent.changedTouches, testString + '1');
          expect(newEvent.ctrlKey, isTrue);
          expect(newEvent.metaKey, isTrue);
          expect(newEvent.shiftKey, isTrue);
          expect(newEvent.targetTouches, testString + '2');
          expect(newEvent.touches, testString + '3');
        });
      });
    });

    group('createSyntheticTransitionEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticTransitionEvent();
        testSyntheticEventDefaults(e);
        expect(e.propertyName, isNull);
        expect(e.elapsedTime, isNull);
        expect(e.pseudoElement, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticTransitionEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            propertyName: testString + '1',
            elapsedTime: 200,
            pseudoElement: testString + '2',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.propertyName, testString + '1');
          expect(baseEvent.elapsedTime, 200);
          expect(baseEvent.pseudoElement, testString + '2');

          final newElement = DivElement();
          final newEvent = createSyntheticTransitionEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            propertyName: updatedTestString + '1',
            elapsedTime: 300,
            pseudoElement: updatedTestString + '2',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.propertyName, updatedTestString + '1');
          expect(newEvent.elapsedTime, 300);
          expect(newEvent.pseudoElement, updatedTestString + '2');
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticTransitionEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            propertyName: testString + '1',
            elapsedTime: 200,
            pseudoElement: testString + '2',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.propertyName, testString + '1');
          expect(baseEvent.elapsedTime, 200);
          expect(baseEvent.pseudoElement, testString + '2');

          final newEvent = createSyntheticTransitionEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.propertyName, testString + '1');
          expect(newEvent.elapsedTime, 200);
          expect(newEvent.pseudoElement, testString + '2');
        });
      });
    });

    group('createSyntheticAnimationEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticAnimationEvent();
        testSyntheticEventDefaults(e);
        expect(e.animationName, isNull);
        expect(e.elapsedTime, isNull);
        expect(e.pseudoElement, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticAnimationEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            animationName: testString + '1',
            elapsedTime: 200,
            pseudoElement: testString + '2',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.animationName, testString + '1');
          expect(baseEvent.elapsedTime, 200);
          expect(baseEvent.pseudoElement, testString + '2');

          final newElement = DivElement();
          final newEvent = createSyntheticAnimationEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            animationName: updatedTestString + '1',
            elapsedTime: 300,
            pseudoElement: updatedTestString + '2',
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.animationName, updatedTestString + '1');
          expect(newEvent.elapsedTime, 300);
          expect(newEvent.pseudoElement, updatedTestString + '2');
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticAnimationEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            animationName: testString + '1',
            elapsedTime: 200,
            pseudoElement: testString + '2',
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.animationName, testString + '1');
          expect(baseEvent.elapsedTime, 200);
          expect(baseEvent.pseudoElement, testString + '2');

          final newEvent = createSyntheticAnimationEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.animationName, testString + '1');
          expect(newEvent.elapsedTime, 200);
          expect(newEvent.pseudoElement, testString + '2');
        });
      });
    });

    group('createSyntheticUIEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticUIEvent();
        testSyntheticEventDefaults(e);
        expect(e.detail, isNull);
        expect(e.view, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticUIEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            detail: 1,
            view: testString,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.detail, 1);
          expect(baseEvent.view, testString);

          final newElement = DivElement();
          final newEvent = createSyntheticUIEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            detail: 2,
            view: updatedTestString,
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.detail, 2);
          expect(newEvent.view, updatedTestString);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticUIEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            detail: 1,
            view: testString,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.detail, 1);
          expect(baseEvent.view, testString);

          final newEvent = createSyntheticUIEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.detail, 1);
          expect(newEvent.view, testString);
        });
      });
    });

    group('createSyntheticWheelEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticWheelEvent();
        testSyntheticEventDefaults(e);
        expect(e.deltaX, isNull);
        expect(e.deltaMode, isNull);
        expect(e.deltaY, isNull);
        expect(e.deltaZ, isNull);
      });

      group('merges values as expected', () {
        test('', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticWheelEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            deltaX: 1,
            deltaMode: 2,
            deltaY: 3,
            deltaZ: 4,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.deltaX, 1);
          expect(baseEvent.deltaMode, 2);
          expect(baseEvent.deltaY, 3);
          expect(baseEvent.deltaZ, 4);

          final newElement = DivElement();
          final newEvent = createSyntheticWheelEvent(
            baseEvent: baseEvent,
            bubbles: false,
            cancelable: true,
            currentTarget: newElement,
            defaultPrevented: false,
            preventDefault: () => mergeTestCounter++,
            stopPropagation: () => mergeTestCounter++,
            eventPhase: 2,
            isTrusted: false,
            nativeEvent: 'updated string',
            target: newElement,
            timeStamp: 200,
            type: 'updated non-default',
            deltaX: 2,
            deltaMode: 3,
            deltaY: 4,
            deltaZ: 5,
          );

          testSyntheticEventBaseAfterMerge(newEvent);
          expect(newEvent.deltaX, 2);
          expect(newEvent.deltaMode, 3);
          expect(newEvent.deltaY, 4);
          expect(newEvent.deltaZ, 5);
        });

        test('when the named parameters are null', () {
          final element = InputElement()
            ..name = 'test'
            ..value = 'test value';
          final baseEvent = createSyntheticWheelEvent(
            bubbles: true,
            cancelable: false,
            currentTarget: element,
            defaultPrevented: true,
            preventDefault: null,
            stopPropagation: null,
            eventPhase: 0,
            isTrusted: true,
            nativeEvent: 'string',
            target: element,
            timeStamp: 100,
            type: 'non-default',
            deltaX: 1,
            deltaMode: 2,
            deltaY: 3,
            deltaZ: 4,
          );
          testSyntheticEventBaseForMergeTests(baseEvent);
          expect(baseEvent.deltaX, 1);
          expect(baseEvent.deltaMode, 2);
          expect(baseEvent.deltaY, 3);
          expect(baseEvent.deltaZ, 4);

          final newEvent = createSyntheticWheelEvent(baseEvent: baseEvent);
          testSyntheticEventBaseForMergeTests(newEvent);
          expect(newEvent.deltaX, 1);
          expect(newEvent.deltaMode, 2);
          expect(newEvent.deltaY, 3);
          expect(newEvent.deltaZ, 4);
        });
      });
    });

    group('SyntheticEventTypeHelpers', () {
      void commonFalseTests(SyntheticEvent Function() eventCreator, bool Function(SyntheticEvent) eventTester,
          {bool isEventAMouseEvent = false}) {
        group('common type helper false tests', () {
          test('when the event is a different type', () {
            final event = isEventAMouseEvent ? createSyntheticClipboardEvent() : createSyntheticMouseEvent();
            expect(eventTester(event), isFalse);
          });

          test('when the event does not have the correct properties set', () {
            expect(eventTester(eventCreator()), isFalse);
          });

          test('when the event is the base class', () {
            expect(eventTester(createSyntheticEvent()), isFalse);
          });
        });
      }

      group('isClipboardEvent', () {
        test('returns true when the event has a necessary field', () {
          final event = createSyntheticClipboardEvent(clipboardData: 'data');
          expect(event.isClipboardEvent, isTrue);
        });

        group('correctly returns false', () {
          commonFalseTests(createSyntheticClipboardEvent, (e) => e.isClipboardEvent);
        });
      });

      group('isKeyboardEvent', () {
        test('returns true when the event has a necessary field', () {
          final e2 = createSyntheticKeyboardEvent(char: 'char');
          expect(e2.isKeyboardEvent, isTrue);

          final e4 = createSyntheticKeyboardEvent(locale: 'local');
          expect(e4.isKeyboardEvent, isTrue);

          final e5 = createSyntheticKeyboardEvent(location: 1);
          expect(e5.isKeyboardEvent, isTrue);

          final e6 = createSyntheticKeyboardEvent(key: 'key');
          expect(e6.isKeyboardEvent, isTrue);

          final e8 = createSyntheticKeyboardEvent(repeat: true);
          expect(e8.isKeyboardEvent, isTrue);

          final e10 = createSyntheticKeyboardEvent(keyCode: 2);
          expect(e10.isKeyboardEvent, isTrue);

          final e11 = createSyntheticKeyboardEvent(charCode: 3);
          expect(e11.isKeyboardEvent, isTrue);
        });

        group('correctly returns false', () {
          commonFalseTests(createSyntheticKeyboardEvent, (e) => e.isKeyboardEvent);

          test('when a non-unique field is non-null', () {
            final e1 = createSyntheticKeyboardEvent(altKey: true);
            expect(e1.isKeyboardEvent, isFalse);

            final e2 = createSyntheticKeyboardEvent(ctrlKey: true);
            expect(e2.isKeyboardEvent, isFalse);

            final e3 = createSyntheticKeyboardEvent(metaKey: true);
            expect(e3.isKeyboardEvent, isFalse);

            final e4 = createSyntheticKeyboardEvent(shiftKey: true);
            expect(e4.isKeyboardEvent, isFalse);
          });
        });
      });

      group('isCompositionEvent', () {
        test('returns true when the event has a necessary field', () {
          final event = createSyntheticCompositionEvent(data: 'data');
          expect(event.isCompositionEvent, isTrue);
        });

        group('correctly returns false', () {
          commonFalseTests(createSyntheticCompositionEvent, (e) => e.isCompositionEvent);
        });
      });

      group('isFocusEvent', () {
        group('returns true', () {
          test('when the event is a synthetic focus event with a relatedTarget field', () {
            final event = createSyntheticFocusEvent(relatedTarget: 'data');
            expect(event.isFocusEvent, isTrue);
          });

          test('when the event is a synthetic mouse event with only relatedTarget field', () {
            final event = createSyntheticMouseEvent(relatedTarget: 'data');
            expect(event.isFocusEvent, isTrue);
          });

          test('when the event is a synthetic mouse event with the relatedTarget field and another field', () {
            final event = createSyntheticMouseEvent(relatedTarget: 'data', clientX: 10);
            expect(event.isFocusEvent, isTrue);
          });
        });

        group('correctly returns false', () {
          commonFalseTests(createSyntheticMouseEvent, (e) => e.isFocusEvent);
        });
      });

      group('isFormEvent', () {
        test('returns true for any synthetic event type', () {
          final e1 = createSyntheticEvent();
          expect(e1.isFormEvent, isTrue);

          final e2 = createSyntheticClipboardEvent();
          expect(e2.isFormEvent, isTrue);

          final e3 = createSyntheticKeyboardEvent();
          expect(e3.isFormEvent, isTrue);

          final e4 = createSyntheticCompositionEvent();
          expect(e4.isFormEvent, isTrue);

          final e5 = createSyntheticFocusEvent();
          expect(e5.isFormEvent, isTrue);

          final e6 = createSyntheticFormEvent();
          expect(e6.isFormEvent, isTrue);

          final e7 = createSyntheticMouseEvent();
          expect(e7.isFormEvent, isTrue);

          final e8 = createSyntheticPointerEvent();
          expect(e8.isFormEvent, isTrue);

          final e9 = createSyntheticTouchEvent();
          expect(e9.isFormEvent, isTrue);

          final e10 = createSyntheticTransitionEvent();
          expect(e10.isFormEvent, isTrue);

          final e11 = createSyntheticAnimationEvent();
          expect(e11.isFormEvent, isTrue);

          final e12 = createSyntheticUIEvent();
          expect(e12.isFormEvent, isTrue);

          final e13 = createSyntheticWheelEvent();
          expect(e13.isFormEvent, isTrue);
        });
      });

      group('isMouseEvent', () {
        test('returns true when the event has a necessary field', () {
          final e1 = createSyntheticMouseEvent(button: 10);
          expect(e1.isMouseEvent, isTrue);

          final e2 = createSyntheticMouseEvent(buttons: 10);
          expect(e2.isMouseEvent, isTrue);

          final e3 = createSyntheticMouseEvent(clientX: 10);
          expect(e3.isMouseEvent, isTrue);

          final e4 = createSyntheticMouseEvent(clientY: 10);
          expect(e4.isMouseEvent, isTrue);

          final e5 = createSyntheticMouseEvent(dataTransfer: jsifyAndAllowInterop({'dropEffect': 'data'}));
          expect(e5.isMouseEvent, isTrue);

          final e6 = createSyntheticMouseEvent(pageX: 10);
          expect(e6.isMouseEvent, isTrue);

          final e7 = createSyntheticMouseEvent(pageY: 10);
          expect(e7.isMouseEvent, isTrue);

          final e8 = createSyntheticMouseEvent(screenX: 10);
          expect(e8.isMouseEvent, isTrue);

          final e9 = createSyntheticMouseEvent(screenY: 10);
          expect(e9.isMouseEvent, isTrue);
        });

        group('correctly returns false', () {
          commonFalseTests(createSyntheticMouseEvent, (e) => e.isMouseEvent, isEventAMouseEvent: true);

          test('when a non-unique field is non-null', () {
            final e1 = createSyntheticMouseEvent(altKey: true);
            expect(e1.isKeyboardEvent, isFalse);

            final e2 = createSyntheticMouseEvent(ctrlKey: true);
            expect(e2.isKeyboardEvent, isFalse);

            final e3 = createSyntheticMouseEvent(metaKey: true);
            expect(e3.isKeyboardEvent, isFalse);

            final e4 = createSyntheticMouseEvent(shiftKey: true);
            expect(e4.isKeyboardEvent, isFalse);

            final e5 = createSyntheticMouseEvent(relatedTarget: 'target');
            expect(e5.isMouseEvent, isFalse);
          });
        });

        group('isPointerEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticPointerEvent(pointerId: 10);
            expect(e1.isPointerEvent, isTrue);

            final e2 = createSyntheticPointerEvent(width: 10);
            expect(e2.isPointerEvent, isTrue);

            final e3 = createSyntheticPointerEvent(height: 10);
            expect(e3.isPointerEvent, isTrue);

            final e4 = createSyntheticPointerEvent(pressure: 10);
            expect(e4.isPointerEvent, isTrue);

            final e5 = createSyntheticPointerEvent(tangentialPressure: 10);
            expect(e5.isPointerEvent, isTrue);

            final e6 = createSyntheticPointerEvent(tiltX: 10);
            expect(e6.isPointerEvent, isTrue);

            final e7 = createSyntheticPointerEvent(tiltY: 10);
            expect(e7.isPointerEvent, isTrue);

            final e8 = createSyntheticPointerEvent(twist: 10);
            expect(e8.isPointerEvent, isTrue);

            final e9 = createSyntheticPointerEvent(pointerType: 'type');
            expect(e9.isPointerEvent, isTrue);

            final e10 = createSyntheticPointerEvent(isPrimary: true);
            expect(e10.isPointerEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticPointerEvent, (e) => e.isPointerEvent);
          });
        });

        group('isTouchEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticTouchEvent(changedTouches: 10);
            expect(e1.isTouchEvent, isTrue);

            final e2 = createSyntheticTouchEvent(targetTouches: 10);
            expect(e2.isTouchEvent, isTrue);

            final e3 = createSyntheticTouchEvent(touches: 10);
            expect(e3.isTouchEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticTouchEvent, (e) => e.isTouchEvent);

            test('when a non-unique field is non-null', () {
              final e1 = createSyntheticTouchEvent(altKey: true);
              expect(e1.isKeyboardEvent, isFalse);

              final e2 = createSyntheticTouchEvent(ctrlKey: true);
              expect(e2.isKeyboardEvent, isFalse);

              final e3 = createSyntheticTouchEvent(metaKey: true);
              expect(e3.isKeyboardEvent, isFalse);

              final e4 = createSyntheticTouchEvent(shiftKey: true);
              expect(e4.isKeyboardEvent, isFalse);
            });
          });
        });

        group('isTransitionEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticTransitionEvent(propertyName: 'property');
            expect(e1.isTransitionEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticTransitionEvent, (e) => e.isTransitionEvent);

            test('when a non-unique field is non-null', () {
              final e1 = createSyntheticTransitionEvent(elapsedTime: 0);
              expect(e1.isKeyboardEvent, isFalse);

              final e2 = createSyntheticTransitionEvent(pseudoElement: 'el');
              expect(e2.isKeyboardEvent, isFalse);
            });
          });
        });

        group('isAnimationEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticAnimationEvent(animationName: 'name');
            expect(e1.isAnimationEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticAnimationEvent, (e) => e.isAnimationEvent);

            test('when a non-unique field is non-null', () {
              final e1 = createSyntheticAnimationEvent(elapsedTime: 0);
              expect(e1.isKeyboardEvent, isFalse);

              final e2 = createSyntheticAnimationEvent(pseudoElement: 'el');
              expect(e2.isKeyboardEvent, isFalse);
            });
          });
        });

        group('isUiEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticUIEvent(detail: 10);
            expect(e1.isUiEvent, isTrue);

            final e2 = createSyntheticUIEvent(view: 10);
            expect(e2.isUiEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticUIEvent, (e) => e.isUiEvent);
          });
        });

        group('isWheelEvent', () {
          test('returns true when the event has a necessary field', () {
            final e1 = createSyntheticWheelEvent(deltaX: 10);
            expect(e1.isWheelEvent, isTrue);

            final e2 = createSyntheticWheelEvent(deltaMode: 10);
            expect(e2.isWheelEvent, isTrue);

            final e3 = createSyntheticWheelEvent(deltaY: 10);
            expect(e3.isWheelEvent, isTrue);

            final e4 = createSyntheticWheelEvent(deltaZ: 10);
            expect(e4.isWheelEvent, isTrue);
          });

          group('correctly returns false', () {
            commonFalseTests(createSyntheticWheelEvent, (e) => e.isWheelEvent);
          });
        });
      });
    });
  });
}

// ignore: avoid_implementing_value_types
class MockKeyboardEvent extends Mock implements KeyboardEvent {}

// ignore: avoid_implementing_value_types
class MockMouseEvent extends Mock implements MouseEvent {}
