import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A lightweight debug logger for FlutterFlow custom actions and widgets.
///
/// All output is suppressed in release builds — zero performance overhead
/// in production. Internally uses [kDebugMode] to gate all output.
///
/// Example:
/// ```dart
/// FFLogger.log(response, label: 'API Response');
/// FFLogger.warn('Coin count was null, using fallback');
/// FFLogger.error('Failed to parse user', e);
/// ```
class FFLogger {
  FFLogger._(); // prevent instantiation

  /// Pretty-prints [data] to the console in debug mode only.
  ///
  /// If [data] is a [Map] or [List], it is formatted as indented JSON.
  /// Otherwise, [toString()] is called on the value.
  ///
  /// Supply an optional [label] to identify the log source.
  ///
  /// ```dart
  /// FFLogger.log(response);
  /// FFLogger.log(userData, label: 'User Profile');
  /// ```
  static void log(dynamic data, {String? label}) {
    if (!kDebugMode) return;
    final tag = label != null ? '[$label]' : '[FFLogger]';
    String output;
    try {
      if (data is Map || data is List) {
        output = const JsonEncoder.withIndent('  ').convert(data);
      } else {
        output = data?.toString() ?? 'null';
      }
    } catch (_) {
      output = data?.toString() ?? 'null';
    }
    // ignore: avoid_print
    print('$tag\n$output');
  }

  /// Logs a warning message in debug mode only.
  ///
  /// ```dart
  /// FFLogger.warn('Price field was null, defaulting to 0.0');
  /// ```
  static void warn(String message) {
    if (!kDebugMode) return;
    // ignore: avoid_print
    print('[FFLogger ⚠️ WARNING] $message');
  }

  /// Logs an error message and optional error object in debug mode only.
  ///
  /// ```dart
  /// FFLogger.error('Failed to parse response', e);
  /// ```
  static void error(String message, [Object? error]) {
    if (!kDebugMode) return;
    final suffix = error != null ? '\n  Error: $error' : '';
    // ignore: avoid_print
    print('[FFLogger ❌ ERROR] $message$suffix');
  }
}
