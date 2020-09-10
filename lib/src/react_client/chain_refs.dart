import 'package:js/js_util.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart';

/// Returns a ref that updates both [ref1] and [ref2], effectively
/// allowing you to set multiple refs.
///
/// Useful when you're using ref forwarding and want to also set your own ref.
///
/// For more information on this problem, see https://github.com/facebook/react/issues/13029.
///
/// Inputs can be callback refs, [createRef]-based refs ([Ref]),
/// or raw JS `createRef` refs ([JsRef]).
///
/// If either [ref1] or [ref2] is null, the other ref will be passed through.
///
/// If both are null, null is returned.
///
/// ```dart
/// final Example = forwardRef((props, ref) {
///   final localRef = useRef<FooComponent>();
///   return Foo({
///     ...props,
///     'ref': chainRefs(localRef, ref),
///   });
/// });
/// ```
dynamic chainRefs(dynamic ref1, dynamic ref2) {
  return chainRefList([ref1, ref2]);
}

/// Like [chainRefs], but takes in a list of [refs].
dynamic chainRefList(List<dynamic> refs) {
  final nonNullRefs = refs.where((ref) => ref != null).toList(growable: false);

  // Wrap in an assert so iteration doesn't take place unnecessarily
  assert(() {
    nonNullRefs.forEach(_validateChainRefsArg);
    return true;
  }());

  // Return null if there are no refs to chain
  if (nonNullRefs.isEmpty) return null;

  // Pass through the ref if there's nothing to chain it with
  if (nonNullRefs.length == 1) return nonNullRefs[0];

  // Adapted from https://github.com/smooth-code/react-merge-refs/tree/v1.0.0
  //
  // Copyright 2019 Smooth Code
  //
  // Permission is hereby granted, free of charge, to any person obtaining a
  // copy of this software and associated documentation files (the 'Software'),
  // to deal in the Software without restriction, including without limitation
  // the rights to use, copy, modify, merge, publish, distribute, sublicense,
  // and/or sell copies of the Software, and to permit persons to whom the
  // Software is furnished to do so, subject to the following conditions:
  //
  // The above copyright notice and this permission notice shall be included in
  // all copies or substantial portions of the Software.
  //
  // THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  // THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  // FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  // DEALINGS IN THE SOFTWARE.
  void _chainedRef(value) {
    for (final ref in nonNullRefs) {
      if (ref is Function) {
        ref(value);
      } else if (ref is Ref) {
        // ignore: invalid_use_of_protected_member
        ref.current = value;
      } else {
        // ignore: invalid_use_of_protected_member, deprecated_member_use_from_same_package
        (ref as JsRef).current = value is react.Component ? value.jsThis : value;
      }
    }
  }

  return _chainedRef;
}

void _validateChainRefsArg(dynamic ref) {
  if (ref is Function(Null) ||
      ref is Ref ||
      // Need to duck-type since `is JsRef` will return true for most JS objects.
      (ref is JsRef && hasProperty(ref, 'current'))) {
    return;
  }

  if (ref is String) throw AssertionError('String refs cannot be chained');
  if (ref is Function) throw AssertionError('callback refs must take a single argument');

  throw AssertionError('Invalid ref type: $ref');
}
