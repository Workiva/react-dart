/// JS interop classes for React synthetic events.
///
/// For use in `react_client.dart` and by advanced react-dart users.
@JS()
library react_client.synthetic_event_wrappers;

// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:html';
import 'package:js/js.dart';

/// A cross-browser wrapper around the browser's [nativeEvent].
///
/// It has the same interface as the browser's native event, including [stopPropagation] and [preventDefault], except
/// the events work identically across all browsers.
///
/// See: <https://reactjs.org/docs/events.html#syntheticevent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticEvent {
  /// [SyntheticEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticEvent` instead.
  external factory SyntheticEvent._();

  /// Indicates whether the [Event] bubbles up through the DOM or not.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/bubbles>
  external bool get bubbles;

  /// Indicates whether the [Event] is cancelable or not.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/cancelable>
  external bool get cancelable;

  /// Identifies the current target for the event, as the [Event] traverses the DOM.
  ///
  /// It always refers to the [Element] the [Event] handler has been attached to as opposed to [target] which identifies
  /// the [Element] on which the [Event] occurred.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/currentTarget>
  external get currentTarget;

  /// Indicates whether or not [preventDefault] was called on the event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/defaultPrevented>
  external bool get defaultPrevented;

  /// Indicates which phase of the [Event] flow is currently being evaluated.
  ///
  /// Possible values:
  ///
  /// > [Event.CAPTURING_PHASE] (1) - The [Event] is being propagated through the [target]'s ancestor objects. This
  /// process starts with the Window, then [HtmlDocument], then the [HtmlHtmlElement], and so on through the [Element]s
  /// until the [target]'s parent is reached. Event listeners registered for capture mode when
  /// [EventTarget.addEventListener] was called are triggered during this phase.
  ///
  /// > [Event.AT_TARGET] (2) - The [Event] has arrived at the [target]. Event listeners registered for this phase are
  /// called at this time. If [bubbles] is `false`, processing the [Event] is finished after this phase is complete.
  ///
  /// > [Event.BUBBLING_PHASE] (3) - The [Event] is propagating back up through the [target]'s ancestors in reverse
  /// order, starting with the parent, and eventually reaching the containing Window. This is known as bubbling, and
  /// occurs only if [bubbles] is `true`. [Event] listeners registered for this phase are triggered during this process.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/eventPhase>
  external num get eventPhase;

  /// Is `true` when the [Event] was generated by a user action, and `false` when the [Event] was created or modified
  /// by a script or dispatched via [EventTarget.dispatchEvent].
  ///
  /// __Read Only__
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/isTrusted>
  external bool get isTrusted;

  /// The native browser event this wraps.
  external /*DOMEvent*/ get nativeEvent;

  /// A reference to the object that dispatched the event. It is different from [currentTarget] when the [Event]
  /// handler is called when [eventPhase] is [Event.BUBBLING_PHASE] or [Event.CAPTURING_PHASE].
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/target>
  external /*DOMEventTarget*/ get target;

  /// Returns the time (in milliseconds) at which the [Event] was created.
  ///
  /// _Starting with Chrome 49, returns a high-resolution monotonic time instead of epoch time._
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/timeStamp>
  external num get timeStamp;

  /// Returns a string containing the type of event. It is set when the [Event] is constructed and is the name commonly
  /// used to refer to the specific event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/type>
  external String get type;

  /// Prevents further propagation of the current event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation>
  external dynamic get stopPropagation;

  /// Cancels the [Event] if it is [cancelable], without stopping further propagation of the event.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault>
  external void preventDefault();
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [ClipboardEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticClipboardEvent extends SyntheticEvent {
  /// [SyntheticClipboardEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticClipboardEvent` instead.
  external factory SyntheticClipboardEvent._();

  /// Holds a [DataTransfer] object, which can be used:
  ///
  /// - to specify what data should be put into the clipboard from the cut and copy event handlers, typically with a
  /// setData(format, data) call;
  /// - to obtain the data to be pasted from the paste event handler, typically with a getData(format) call.
  ///
  /// See: <https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData>
  external get clipboardData;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [KeyboardEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticKeyboardEvent extends SyntheticEvent {
  /// [SyntheticKeyboardEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticKeyboardEvent` instead.
  external factory SyntheticKeyboardEvent._();

  /// Whether the `Alt` (`Option` or `⌥` on OS X) key was active when this event was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/altKey>
  external bool get altKey;

  /// The character value of the key.
  ///
  /// If the key corresponds to a printable character, this value is a non-empty Unicode string containing that character.
  /// If the key doesn't have a printable representation, this is an empty string.
  external String get char;

  /// Whether the `Ctrl` key was active when this was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/ctrlKey>
  external bool get ctrlKey;

  /// A locale string indicating the locale the keyboard is configured for.
  ///
  /// This may be the empty string if the browser or device doesn't know the keyboard's locale.
  external String get locale;

  /// The location of the key on the keyboard or other input device.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/location>
  external num get location;

  /// The key value of the key represented by this event.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key>
  external String get key;

  /// Whether the `Meta` key (on Mac keyboards, the `⌘ Command key`; on Windows keyboards, the Windows key (`⊞`))
  /// was active when the key event was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/metaKey>
  external bool get metaKey;

  /// Whether the key is being held down such that it is automatically repeating.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/repeat>
  external bool get repeat;

  /// Whether the `Shift` key was active when the this event was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/shiftKey>
  external bool get shiftKey;

  /// A system and implementation dependent numerical code identifying the unmodified
  /// value of the pressed key.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode>
  external num get keyCode;

  /// The Unicode reference number of the key; this attribute is used only by the `keypress` event.
  ///
  /// For keys whose `char` attribute contains multiple characters, this is the Unicode value of the first character in
  /// that attribute. In Firefox 26 this returns codes for printable characters.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/charCode>
  external num get charCode;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [CompositionEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/CompositionEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticCompositionEvent extends SyntheticEvent {
  /// [SyntheticCompositionEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticCompositionEvent` instead.
  external factory SyntheticCompositionEvent._();

  /// The characters generated by the input method that raised this; its varies depending on the type of event
  /// that generated the this object.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/CompositionEvent/data>
  external String get data;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [FocusEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticFocusEvent extends SyntheticEvent {
  /// [SyntheticFocusEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticFocusEvent` instead.
  external factory SyntheticFocusEvent._();

  /// A secondary target for this event.
  ///
  /// In some cases (such as when tabbing in or out a page), this property may be set to `null` for security reasons.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent/relatedTarget>
  external dynamic get relatedTarget;
}

/// A [SyntheticEvent] wrapper that represents a form event.
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticFormEvent extends SyntheticEvent {
  /// [SyntheticFormEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticFormEvent` instead.
  external factory SyntheticFormEvent._();
}

/// A JS object that looks like a [DataTransfer] but isn't one.
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class NonNativeDataTransfer {
  /// The type of drag-and-drop operation currently selected or sets the operation to a new type.
  ///
  /// The value must be `none`, `copy`, `link` or `move`.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer/dropEffect>
  external String get dropEffect;

  /// All of the types of operations that are possible.
  ///
  /// Must be one of `none`, `copy`, `copyLink`, `copyMove`, `link`, `linkMove`, `move`, `all` or `uninitialized`.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer/effectAllowed>
  external String get effectAllowed;

  /// A list of all the local files available on the data transfer.
  ///
  /// If the drag operation doesn't involve dragging files, this property is an empty list.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer/files>
  external List<File> get files;

  /// The formats that were set in the `dragstart` event.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer/types>
  external List<String> get types;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [MouseEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticMouseEvent extends SyntheticEvent {
  /// [SyntheticMouseEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticMouseEvent` instead.
  external factory SyntheticMouseEvent._();

  /// Whether the `alt` key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/altKey>
  external bool get altKey;

  /// The button number that was pressed (if applicable) when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button>
  external num get button;

  /// The buttons being depressed (if any) when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons>
  external num get buttons;

  /// The X coordinate of the mouse pointer in local (DOM content) coordinates.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX>
  external num get clientX;

  /// The Y coordinate of the mouse pointer in local (DOM content) coordinates.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientY>
  external num get clientY;

  /// Whether the `Ctrl` key was active when this event was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/ctrlKey>
  external bool get ctrlKey;

  /// Whether the `meta` key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/metaKey>
  external bool get metaKey;

  /// The X coordinate of the mouse pointer relative to the whole document.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageX>
  external num get pageX;

  /// The Y coordinate of the mouse pointer relative to the whole document.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/pageY>
  external num get pageY;

  /// The secondary target for this event, if there is one.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/relatedTarget>
  external dynamic get relatedTarget;

  /// The X coordinate of the mouse pointer in global (screen) coordinates.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenX>
  external num get screenX;

  /// The Y coordinate of the mouse pointer in global (screen) coordinates.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/screenY>
  external num get screenY;

  /// Whether the `Shift` key was active when this event was generated.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/shiftKey>
  external bool get shiftKey;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [PointerEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticPointerEvent extends SyntheticEvent {
  /// [SyntheticPointerEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticPointerEvent` instead.
  external factory SyntheticPointerEvent._();

  /// A unique identifier for the pointer causing the event.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pointerId>
  external num get pointerId;

  /// The width (magnitude on the X axis), in CSS pixels, of the contact geometry of the pointer.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/width>
  external num get width;

  /// The height (magnitude on the Y axis), in CSS pixels, of the contact geometry of the pointer.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/height>
  external num get height;

  /// The normalized pressure of the pointer input in the range `0` to `1`, where `0` and `1` represent the minimum and maximum
  /// pressure the hardware is capable of detecting, respectively.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pressure>
  external num get pressure;

  /// The normalized tangential pressure of the pointer input (also known as barrel pressure or cylinder stress) in the
  /// range `-1` to `1`, where `0` is the neutral position of the control.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tangentialPressure>
  external num get tangentialPressure;

  /// The plane angle (in degrees, in the range of `-90` to `90`) between the Y–Z plane and the plane containing both the pointer
  /// (e.g. pen stylus) axis and the Y axis.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tiltX>
  external num get tiltX;

  /// The plane angle (in degrees, in the range of `-90` to `90`) between the X–Z plane and the plane containing both the
  /// pointer (e.g. pen stylus) axis and the X axis.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/tiltY>
  external num get tiltY;

  /// The clockwise rotation of the pointer (e.g. pen stylus) around its major axis in degrees, with a value in the range
  /// `0` to `359`.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/twist>
  external num get twist;

  /// Indicates the device type that caused this event (mouse, pen, touch, etc.)
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/pointerType>
  external String get pointerType;

  /// Indicates if the pointer represents the primary pointer of this pointer type.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent/isPrimary>
  external bool get isPrimary;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [TouchEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticTouchEvent extends SyntheticEvent {
  /// [SyntheticTouchEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticTouchEvent` instead.
  external factory SyntheticTouchEvent._();

  /// Whether the `alt` key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/altKey>
  external bool get altKey;

  /// All the `Touch` objects representing individual points of contact whose states changed between the
  /// previous touch event and this one.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/changedTouches>
  external List<Touch> get changedTouches;

  /// A value indicating whether or not the control key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/ctrlKey>
  external bool get ctrlKey;

  /// A value indicating whether or not the meta key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/metaKey>
  external bool get metaKey;

  /// A value indicating whether or not the shift key was down when this event was fired.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/shiftKey>
  external bool get shiftKey;

  /// All the `Touch` objects that are both currently in contact with the touch surface and were also
  /// started on the same element that is the target of this event.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/targetTouches>
  external List<Touch> get targetTouches;

  /// All the `Touch` objects representing all current points of contact with the surface, regardless
  /// of target or changed status.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent/touches>
  external List<Touch> get touches;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [TransitionEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticTransitionEvent extends SyntheticEvent {
  /// [SyntheticTransitionEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticTransitionEvent` instead.
  external factory SyntheticTransitionEvent._();

  /// Contains the name CSS property associated with the transition.
  external String get propertyName;

  /// Gives the amount of time the transition has been running, in seconds, when this event fired.
  ///
  /// This value is not affected by the transition-delay property.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent/elapsedTime>
  external num get elapsedTime;

  /// Contains the name of the pseudo-element the animation runs on.
  ///
  /// Starts with `::`. If the transition doesn't run on a pseudo-element but on the element, an empty string: `''`.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent/pseudoElement>
  external String get pseudoElement;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [AnimationEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticAnimationEvent extends SyntheticEvent {
  /// [SyntheticAnimationEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticAnimationEvent` instead.
  external factory SyntheticAnimationEvent._();

  /// The value of the animation-name that generated the animation.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent/animationName>
  external String get animationName;

  /// The amount of time the animation has been running, in seconds, when this event fired, excluding any time the
  /// animation was paused.
  ///
  /// For an animationstart event, elapsedTime is 0.0 unless there was a negative value for animation-delay, in which case
  /// the event will be fired with elapsedTime containing (-1 * delay).
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent/elapsedTime>
  external num get elapsedTime;

  /// Contains the name of the pseudo-element the animation runs on.
  ///
  /// Starts with `::`. If the animation doesn't run on a pseudo-element but on the element, an empty string: ''.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent/pseudoElement>
  external String get pseudoElement;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [UIEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/UIEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticUIEvent extends SyntheticEvent {
  /// [SyntheticUIEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticUIEvent` instead.
  external factory SyntheticUIEvent._();

  /// Details about the event, depending on the event type.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/UIEvent/detail>
  external num get detail;

  /// A `WindowProxy` that contains the view that generated the event.
  external get view;
}

/// A [SyntheticEvent] wrapper that is specifically backed by a [SyntheticWheelEvent].
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent>
@JS()
// TODO make @anonymous once https://github.com/dart-lang/sdk/issues/43939 is fixed
class SyntheticWheelEvent extends SyntheticEvent {
  /// [SyntheticWheelEvent]s cannot be manually instantiated.
  ///
  /// Use `createSyntheticWheelEvent` instead.
  external factory SyntheticWheelEvent._();

  /// The horizontal scroll amount.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent/deltaX>
  external num get deltaX;

  /// The unit of the `delta*` values' scroll amount.
  ///
  /// Permitted values are:
  /// - WheelEvent.DOM_DELTA_PIXEL
  /// - WheelEvent.DOM_DELTA_LINE
  /// - WheelEvent.DOM_DELTA_PAGE
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent/deltaMode>
  external num get deltaMode;

  /// The vertical scroll amount.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent/deltaY>
  external num get deltaY;

  /// The scroll amount for the z-axis.
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/WheelEvent/deltaZ>
  external num get deltaZ;
}
