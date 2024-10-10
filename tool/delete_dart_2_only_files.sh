#!/usr/bin/env bash

#
# This script deletes files that can only be run in Dart 2 (ones not using null-safety),
# and need to be deleted for analysis and compilation to work in Dart 3.
#

set -e

rm test/nullable_callback_detection/non_null_safe_refs.dart
rm test/nullable_callback_detection/nullable_callback_detection_unsound_test.dart