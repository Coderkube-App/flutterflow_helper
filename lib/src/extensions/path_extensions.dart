// Safe nested path access extensions for deeply nested JSON.
//
// This is the **signature feature** of `flutterflow_helpers`. It lets you
// access deeply nested values using a dot-separated path string, without
// any risk of null pointer exceptions or type crashes.
//
// **Before:**
// ```dart
// // This crashes if any level is null!
// final name = response['data']['user']['profile']['name'];
// ```
//
// **After:**
// ```dart
// // Always safe. Returns '' if any level is missing.
// final name = response.pathString('data.user.profile.name');
// ```
//
// Supports numeric indices for lists:
// ```dart
// response.pathString('data.users.0.name'); // first user's name
// ```

/// Internal traversal function — kept as a top-level function so it always
/// receives [root] as `dynamic`, avoiding extension resolution issues when
/// called on a statically-typed receiver like [Map<String, dynamic>].
dynamic _resolvePath(dynamic root, String dotPath) {
  if (root == null) return null;
  final segments = dotPath.split('.');
  dynamic current = root;

  for (final segment in segments) {
    if (current == null) return null;

    // List index access (numeric segment)
    final index = int.tryParse(segment);
    if (index != null) {
      if (current is List && index >= 0 && index < current.length) {
        current = current[index];
      } else {
        return null;
      }
      continue;
    }

    // Map key access
    if (current is Map) {
      current = current[segment];
    } else {
      return null;
    }
  }

  return current;
}

extension PathExtensions on Object? {
  /// Traverses the dot-separated [path] and returns the raw [dynamic] value.
  ///
  /// Returns `null` if any segment along the path is missing, null, or
  /// the wrong type. Never throws.
  ///
  /// Supports numeric indices for List access (e.g. `'users.0.name'`).
  ///
  /// ```dart
  /// response.path('data.user');       // Map or null
  /// response.path('data.users.0');    // first element or null
  /// ```
  dynamic path(String path) => _resolvePath(this, path);

  /// Traverses [path] and returns the value as a [String].
  ///
  /// Returns [fallback] (default `''`) if the path is invalid or value is null.
  ///
  /// ```dart
  /// response.pathString('data.user.name');           // 'Vansh'
  /// response.pathString('data.user.missing');        // ''
  /// response.pathString('data.user.name', fallback: 'Unknown'); // 'Unknown' if missing
  /// ```
  String pathString(String path, {String fallback = ''}) {
    final value = _resolvePath(this, path);
    if (value == null) return fallback;
    if (value is String) return value.isEmpty ? fallback : value;
    return value.toString();
  }

  /// Traverses [path] and returns the value as a [String] representing an image path.
  ///
  /// Automatically resolves [List] values by taking their first element.
  /// Returns [fallback] (default `''`) if the path is invalid, null, or empty.
  ///
  /// ```dart
  /// response.pathImage('data.user.avatar');           // 'https://secure.gravatar.com/...'
  /// response.pathImage('data.post.gallery');         // gets first image from list
  /// response.pathImage('data.missing');              // ''
  /// ```
  String pathImage(String path, {String fallback = ''}) {
    var value = _resolvePath(this, path);
    if (value == null) return fallback;

    // Smart List Handler: If the resolved value is a List, get the first item
    if (value is List) {
      if (value.isNotEmpty) {
        value = value.first;
      } else {
        return fallback;
      }
    }

    if (value is String) return value.isEmpty ? fallback : value;
    return value.toString();
  }

  /// Traverses [path] and returns the value as an [int].
  ///
  /// Returns [fallback] (default `0`) if the path is invalid, value is null,
  /// or value cannot be converted to int.
  ///
  /// ```dart
  /// response.pathInt('data.user.coins');  // 25
  /// response.pathInt('data.missing');     // 0
  /// ```
  int pathInt(String path, {int fallback = 0}) {
    final value = _resolvePath(this, path);
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    if (value is bool) return value ? 1 : 0;
    return fallback;
  }

  /// Traverses [path] and returns the value as a [double].
  ///
  /// Returns [fallback] (default `0.0`) if the path is invalid or value
  /// cannot be converted.
  ///
  /// ```dart
  /// response.pathDouble('data.product.price'); // 9.99
  /// response.pathDouble('data.missing');        // 0.0
  /// ```
  double pathDouble(String path, {double fallback = 0.0}) {
    final value = _resolvePath(this, path);
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  /// Traverses [path] and returns the value as a [bool].
  ///
  /// Handles `bool`, `int` (0/non-0), and `String` (`'true'`/`'false'`).
  /// Returns [fallback] (default `false`) if path is invalid or value is null.
  ///
  /// ```dart
  /// response.pathBool('data.user.active'); // true
  /// response.pathBool('data.missing');     // false
  /// ```
  bool pathBool(String path, {bool fallback = false}) {
    final value = _resolvePath(this, path);
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return fallback;
  }

  /// Traverses [path] and returns the value as a [List].
  ///
  /// Returns an empty list `[]` if the path is invalid, value is null,
  /// or value is not a List. Never throws.
  ///
  /// ```dart
  /// response.pathList('data.users');   // [{'name': 'Vansh'}, ...]
  /// response.pathList('data.missing'); // []
  /// ```
  List<dynamic> pathList(String path) {
    final value = _resolvePath(this, path);
    if (value == null) return [];
    if (value is List) return value;
    return [];
  }

  /// Traverses [path] and returns the value as a [Map<String, dynamic>].
  ///
  /// Returns an empty map `{}` if the path is invalid, value is null,
  /// or value is not a Map. Never throws.
  ///
  /// ```dart
  /// response.pathMap('data.user');    // {'name': 'Vansh', ...}
  /// response.pathMap('data.missing'); // {}
  /// ```
  Map<String, dynamic> pathMap(String path) {
    final value = _resolvePath(this, path);
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }
}

/// A static helper class to query nested JSON paths.
///
/// Designed specifically for FlutterFlow Custom Functions where the input parameters
/// are statically typed as [dynamic], preventing normal extension method resolution.
abstract class FFPath {
  /// Traverses the dot-separated [path] on a [json] object/list and returns a [String].
  static String getString(dynamic json, String path, {String fallback = ''}) {
    return (json as Object?).pathString(path, fallback: fallback);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns an image path [String].
  static String getImage(dynamic json, String path, {String fallback = ''}) {
    return (json as Object?).pathImage(path, fallback: fallback);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns an [int].
  static int getInt(dynamic json, String path, {int fallback = 0}) {
    return (json as Object?).pathInt(path, fallback: fallback);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns a [double].
  static double getDouble(dynamic json, String path, {double fallback = 0.0}) {
    return (json as Object?).pathDouble(path, fallback: fallback);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns a [bool].
  static bool getBool(dynamic json, String path, {bool fallback = false}) {
    return (json as Object?).pathBool(path, fallback: fallback);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns a [List].
  static List<dynamic> getList(dynamic json, String path) {
    return (json as Object?).pathList(path);
  }

  /// Traverses the dot-separated [path] on a [json] object/list and returns a [Map].
  static Map<String, dynamic> getMap(dynamic json, String path) {
    return (json as Object?).pathMap(path);
  }
}
