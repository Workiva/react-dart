@TestOn('browser')
library react.event_helpers_test;

import 'dart:html';

import 'package:react/react.dart';
import 'package:react/src/react_client/event_helpers.dart';
import 'package:test/test.dart';

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
      expect(event.bubbles, isTrue);
      expect(event.cancelable, isTrue);
      expect(event.defaultPrevented, isFalse);
      expect(event.isTrusted, isTrue);

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
      expect(event.defaultPrevented, isTrue, reason: 'calling preventDefault sets the value to true.');
    }

    void testSyntheticEventBaseForMergeTests(SyntheticEvent event) {
      // Boolean defaults
      expect(event.bubbles, isFalse);
      expect(event.cancelable, isFalse);
      expect(event.defaultPrevented, isTrue);
      expect(event.isTrusted, isFalse);

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
      expect(event.defaultPrevented, isTrue, reason: 'calling preventDefault sets the value to true.');
    }

    void testSyntheticEventBaseAfterMerge(SyntheticEvent event) {
      // Boolean defaults
      expect(event.bubbles, isTrue);
      expect(event.cancelable, isTrue);
      expect(event.defaultPrevented, isFalse);
      expect(event.isTrusted, isTrue);

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

    group('createSyntheticEvent', () {
      test('returns normally when no parameters are provided', () {
        testSyntheticEventDefaults(createSyntheticEvent());
      });

      test('matches getEmptySyntheticEvent', () {
        testSyntheticEventDefaults(getEmptySyntheticEvent());
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
        );
        testSyntheticEventBaseForMergeTests(baseEvent);

        final newElement = DivElement();
        final newEvent = createSyntheticEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
      });
    });

    group('createSyntheticClipboardEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticClipboardEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.clipboardData, isNull);
      });

      test('matches getEmptyClipboardEvent', () {
        final e = getEmptyClipboardEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.clipboardData, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticClipboardEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
          clipboardData: 'initial data',
        );
        testSyntheticEventBaseForMergeTests(baseEvent); // Sanity check
        expect(baseEvent.clipboardData, 'initial data');

        final newElement = DivElement();
        final newEvent = createSyntheticClipboardEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
          clipboardData: 'new data',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
        expect(baseEvent.clipboardData, 'initial data');
      });
    });

    group('createSyntheticKeyboardEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticKeyboardEvent();

        testSyntheticEventDefaults(e);

        // keyboard event properties
        expect(e.altKey, isNull);
        expect(e.char, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.locale, isNull);
        expect(e.location, isNull);
        expect(e.key, isNull);
        expect(e.metaKey, isNull);
        expect(e.repeat, isNull);
        expect(e.shiftKey, isNull);
        expect(e.keyCode, isNull);
        expect(e.charCode, isNull);
      });

      test('matches getEmptyKeyboardEvent', () {
        final e = getEmptyKeyboardEvent();

        testSyntheticEventDefaults(e);

        // keyboard event properties
        expect(e.altKey, isNull);
        expect(e.char, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.locale, isNull);
        expect(e.location, isNull);
        expect(e.key, isNull);
        expect(e.metaKey, isNull);
        expect(e.repeat, isNull);
        expect(e.shiftKey, isNull);
        expect(e.keyCode, isNull);
        expect(e.charCode, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticKeyboardEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          shiftKey: false,
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
        expect(baseEvent.shiftKey, isFalse);
        expect(baseEvent.keyCode, 2);
        expect(baseEvent.charCode, 3);

        final newElement = DivElement();
        final newEvent = createSyntheticKeyboardEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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
          shiftKey: true,
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
        expect(newEvent.shiftKey, isTrue);
        expect(newEvent.keyCode, 3);
        expect(newEvent.charCode, 4);
      });
    });

    group('createSyntheticCompositionEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticCompositionEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.data, isNull);
      });

      test('matches getEmptyCompositionEvent', () {
        final e = getEmptyCompositionEvent();

        testSyntheticEventDefaults(e);

        // clipboard event properties
        expect(e.data, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticCompositionEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
          data: 'new data',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
        expect(newEvent.data, 'new data');
      });
    });

    group('createSyntheticFocusEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticFocusEvent();
        testSyntheticEventDefaults(e);
      });

      test('matches getEmptyFocusEvent', () {
        final e = getEmptyFocusEvent();
        testSyntheticEventDefaults(e);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticFocusEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
        );
        testSyntheticEventBaseForMergeTests(baseEvent);

        final newElement = DivElement();
        final newEvent = createSyntheticFocusEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
      });
    });

    group('createSyntheticFormEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticFormEvent();
        testSyntheticEventDefaults(e);
      });

      test('matches getEmptyFormEvent', () {
        final e = getEmptyFormEvent();
        testSyntheticEventDefaults(e);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticFormEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
        );
        testSyntheticEventBaseForMergeTests(baseEvent);

        final newElement = DivElement();
        final newEvent = createSyntheticFormEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
      });
    });

    group('createSyntheticMouseEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticMouseEvent();
        testSyntheticEventDefaults(e);

        expect(e.altKey, isNull);
        expect(e.button, isNull);
        expect(e.buttons, isNull);
        expect(e.clientX, isNull);
        expect(e.clientY, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.dataTransfer, isNull);
        expect(e.metaKey, isNull);
        expect(e.pageX, isNull);
        expect(e.pageY, isNull);
        expect(e.relatedTarget, isNull);
        expect(e.screenX, isNull);
        expect(e.screenY, isNull);
        expect(e.shiftKey, isNull);
      });

      test('matches getEmptyMouseEvent', () {
        final e = getEmptyMouseEvent();
        testSyntheticEventDefaults(e);

        expect(e.altKey, isNull);
        expect(e.button, isNull);
        expect(e.buttons, isNull);
        expect(e.clientX, isNull);
        expect(e.clientY, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.dataTransfer, isNull);
        expect(e.metaKey, isNull);
        expect(e.pageX, isNull);
        expect(e.pageY, isNull);
        expect(e.relatedTarget, isNull);
        expect(e.screenX, isNull);
        expect(e.screenY, isNull);
        expect(e.shiftKey, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticMouseEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
          altKey: false,
          button: 1,
          buttons: 2,
          clientX: 100,
          clientY: 200,
          ctrlKey: false,
          dataTransfer: SyntheticDataTransfer(testString, null, null, null),
          metaKey: false,
          pageX: 300,
          pageY: 400,
          relatedTarget: testString,
          screenX: 500,
          screenY: 600,
          shiftKey: true,
        );
        testSyntheticEventBaseForMergeTests(baseEvent);
        expect(baseEvent.altKey, isFalse);
        expect(baseEvent.button, 1);
        expect(baseEvent.buttons, 2);
        expect(baseEvent.clientX, 100);
        expect(baseEvent.clientY, 200);
        expect(baseEvent.ctrlKey, isFalse);
        expect(baseEvent.dataTransfer.dropEffect, testString);
        expect(baseEvent.metaKey, isFalse);
        expect(baseEvent.pageX, 300);
        expect(baseEvent.pageY, 400);
        expect(baseEvent.relatedTarget, testString);
        expect(baseEvent.screenX, 500);
        expect(baseEvent.screenY, 600);
        expect(baseEvent.shiftKey, isTrue);

        final newElement = DivElement();
        final newEvent = createSyntheticMouseEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
          altKey: true,
          button: 2,
          buttons: 3,
          clientX: 200,
          clientY: 300,
          ctrlKey: true,
          dataTransfer: SyntheticDataTransfer(updatedTestString, null, null, null),
          metaKey: true,
          pageX: 400,
          pageY: 500,
          relatedTarget: updatedTestString,
          screenX: 600,
          screenY: 700,
          shiftKey: false,
        );

        testSyntheticEventBaseAfterMerge(newEvent);
        expect(newEvent.altKey, isTrue);
        expect(newEvent.button, 2);
        expect(newEvent.buttons, 3);
        expect(newEvent.clientX, 200);
        expect(newEvent.clientY, 300);
        expect(newEvent.ctrlKey, isTrue);
        expect(newEvent.dataTransfer.dropEffect, updatedTestString);
        expect(newEvent.metaKey, isTrue);
        expect(newEvent.pageX, 400);
        expect(newEvent.pageY, 500);
        expect(newEvent.relatedTarget, updatedTestString);
        expect(newEvent.screenX, 600);
        expect(newEvent.screenY, 700);
        expect(newEvent.shiftKey, isFalse);
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

      test('matches getEmptyPointerEvent', () {
        final e = getEmptyPointerEvent();
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

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticPointerEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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
    });

    group('createSyntheticTouchEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticTouchEvent();
        testSyntheticEventDefaults(e);
        expect(e.altKey, isNull);
        expect(e.altKey, isNull);
        expect(e.changedTouches, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.metaKey, isNull);
        expect(e.shiftKey, isNull);
        expect(e.targetTouches, isNull);
        expect(e.touches, isNull);
      });

      test('matches getEmptyTouchEvent', () {
        final e = getEmptyTouchEvent();
        testSyntheticEventDefaults(e);
        expect(e.altKey, isNull);
        expect(e.altKey, isNull);
        expect(e.changedTouches, isNull);
        expect(e.ctrlKey, isNull);
        expect(e.metaKey, isNull);
        expect(e.shiftKey, isNull);
        expect(e.targetTouches, isNull);
        expect(e.touches, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticTouchEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
          nativeEvent: 'string',
          target: element,
          timeStamp: 100,
          type: 'non-default',
          altKey: false,
          changedTouches: testString + '1',
          ctrlKey: false,
          metaKey: false,
          shiftKey: false,
          targetTouches: testString + '2',
          touches: testString + '3',
        );
        testSyntheticEventBaseForMergeTests(baseEvent);
        expect(baseEvent.altKey, isFalse);
        expect(baseEvent.changedTouches, testString + '1');
        expect(baseEvent.ctrlKey, isFalse);
        expect(baseEvent.metaKey, isFalse);
        expect(baseEvent.shiftKey, isFalse);
        expect(baseEvent.targetTouches, testString + '2');
        expect(baseEvent.touches, testString + '3');

        final newElement = DivElement();
        final newEvent = createSyntheticTouchEvent(
          baseEvent: baseEvent,
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
          nativeEvent: 'updated string',
          target: newElement,
          timeStamp: 200,
          type: 'updated non-default',
          altKey: true,
          changedTouches: updatedTestString + '1',
          ctrlKey: true,
          metaKey: true,
          shiftKey: true,
          targetTouches: updatedTestString + '2',
          touches: updatedTestString + '3',
        );

        testSyntheticEventBaseAfterMerge(newEvent);
        expect(newEvent.altKey, isTrue);
        expect(newEvent.changedTouches, updatedTestString + '1');
        expect(newEvent.ctrlKey, isTrue);
        expect(newEvent.metaKey, isTrue);
        expect(newEvent.shiftKey, isTrue);
        expect(newEvent.targetTouches, updatedTestString + '2');
        expect(newEvent.touches, updatedTestString + '3');
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

      test('matches getEmptyTransitionEvent', () {
        final e = getEmptyTransitionEvent();
        testSyntheticEventDefaults(e);
        expect(e.propertyName, isNull);
        expect(e.elapsedTime, isNull);
        expect(e.pseudoElement, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticTransitionEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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
    });

    group('createSyntheticAnimationEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticAnimationEvent();
        testSyntheticEventDefaults(e);
        expect(e.animationName, isNull);
        expect(e.elapsedTime, isNull);
        expect(e.pseudoElement, isNull);
      });

      test('matches getEmptyAnimationEvent', () {
        final e = getEmptyAnimationEvent();
        testSyntheticEventDefaults(e);
        expect(e.animationName, isNull);
        expect(e.elapsedTime, isNull);
        expect(e.pseudoElement, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticAnimationEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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
    });

    group('createSyntheticUIEvent', () {
      test('returns normally when no parameters are provided', () {
        final e = createSyntheticUIEvent();
        testSyntheticEventDefaults(e);
        expect(e.detail, isNull);
        expect(e.view, isNull);
      });

      test('matches getEmptyUIEvent', () {
        final e = getEmptyUIEvent();
        testSyntheticEventDefaults(e);
        expect(e.detail, isNull);
        expect(e.view, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticUIEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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

      test('matches getEmptyWheelEvent', () {
        final e = getEmptyWheelEvent();
        testSyntheticEventDefaults(e);
        expect(e.deltaX, isNull);
        expect(e.deltaMode, isNull);
        expect(e.deltaY, isNull);
        expect(e.deltaZ, isNull);
      });

      test('merges values as expected', () {
        final element = InputElement()
          ..name = 'test'
          ..value = 'test value';
        final baseEvent = createSyntheticWheelEvent(
          bubbles: false,
          cancelable: false,
          currentTarget: element,
          defaultPrevented: true,
          preventDefault: null,
          stopPropagation: null,
          eventPhase: 0,
          isTrusted: false,
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
          bubbles: true,
          cancelable: true,
          currentTarget: newElement,
          defaultPrevented: false,
          preventDefault: () => mergeTestCounter++,
          stopPropagation: () => mergeTestCounter++,
          eventPhase: 2,
          isTrusted: true,
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
    });
  });
}
