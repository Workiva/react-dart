@JS()
library react_virtual;

// type ScrollAlignment = 'start' | 'center' | 'end' | 'auto';

import 'dart:html';

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'react_client/react_interop.dart';

@JS()
@anonymous
class ScrollToOptions {
  external factory ScrollToOptions({
    String align,
  });

  external String /* ScrollAlignment */ get align;

  external set align(String value);
}

@JS()
@anonymous
class ScrollToOffsetOptions extends ScrollToOptions {
  external factory ScrollToOffsetOptions({
    String align,
  });
}

@JS()
@anonymous
class ScrollToIndexOptions extends ScrollToOptions {
  external factory ScrollToIndexOptions({
    String align,
  });
}

// type Key = number | string

@JS()
@anonymous
class VirtualItem {
  external /*Key*/ dynamic get key;

  external num get index;

  external num get start;

  external num get end;

  external num get size;

  external void Function(HtmlElement) get measureRef;
}

@JS()
@anonymous
class Range {
  external num get start;

  external num get end;

  external num get overscan;

  external num get size;
}

@JS('defaultRangeExtractor')
external List<dynamic> _defaultRangeExtractor(Range range);

// FIXME find better way to update the type of this list?
// https://github.com/dart-lang/sdk/issues/37676
List<int> defaultRangeExtractor(Range range) => _defaultRangeExtractor(range).cast();

@JS()
@anonymous
class Rect {
  external num get width;

  external num get height;
}

@JS()
@anonymous
class Options<T> {
  external factory Options({
    @required num size,
    // FIXME figure out if we should accept Dart refs
    // FIXME should we have a type parameter here?
    @required JsRef/*<T>*/ parentRef,
    num Function(num index) estimateSize,
    num overscan,
    bool horizontal,
    void Function(num offset, [void Function(num offset) defaultScrollToFn]) scrollToFn,
    num paddingStart,
    num paddingEnd,
    Rect Function(JsRef/*<T>*/ ref, [Rect initialRect]) useObserver,
    Rect initialRect,
    /*Key*/ dynamic Function(num index) keyExtractor,
    JsRef/*<HTMLElement>*/ onScrollElement,
    num Function([Event event]) scrollOffsetFn,
    List<num> Function(Range range) rangeExtractor,
  });
}

@JS('useVirtual')
external JsVirtualHook _useVirtual(Options options);

VirtualHook useVirtual<T>(Options<T> options) => VirtualHook._(_useVirtual(options));

@JS()
@anonymous
class JsVirtualHook {
  external List< /*VirtualItem*/ dynamic> get virtualItems;

  external num get totalSize;

  external void Function(num index, [ScrollToOffsetOptions options]) get scrollToOffset;

  external void Function(num index, [ScrollToIndexOptions options]) get scrollToIndex;

  external void Function() get measure;
}

class VirtualHook {
  final JsVirtualHook _jsHook;

  VirtualHook._(this._jsHook);

  // FIXME find better way to update the type of this list?
  // https://github.com/dart-lang/sdk/issues/37676
  List<VirtualItem> get virtualItems => _jsHook.virtualItems.cast();

  num get totalSize => _jsHook.totalSize;

  void Function(num index, [ScrollToOffsetOptions options]) get scrollToOffset => _jsHook.scrollToOffset;

  void Function(num index, [ScrollToIndexOptions options]) get scrollToIndex => _jsHook.scrollToIndex;

  void Function() get measure => _jsHook.measure;
}
