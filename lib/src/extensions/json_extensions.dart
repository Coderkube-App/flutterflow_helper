/// Safe JSON parsing extensions for [Map<String, dynamic>].
///
/// These extensions prevent the most common FlutterFlow crashes caused by
/// null values, wrong types, and missing keys in API responses.
///
/// Example:
/// ```dart
/// final response = {'name': 'Vansh', 'coins': '25', 'active': 1};
///
/// response.safeString('name');    // 'Vansh'
/// response.safeInt('coins');      // 25
/// response.safeBool('active');    // true
/// response.safeString('missing'); // ''
/// ```
extension JsonExtensions on Map<String, dynamic> {
  /// Returns the value at [key] as a [String].
  ///
  /// Safely converts [int], [double], and [bool] values to their string
  /// representation. Returns [fallback] if the key is missing or the value
  /// is null.
  ///
  /// ```dart
  /// json.safeString('name');             // 'Vansh'
  /// json.safeString('count');            // '42' (if count is int)
  /// json.safeString('missing');          // ''
  /// json.safeString('missing', fallback: 'N/A'); // 'N/A'
  /// ```
  String safeString(String key, {String fallback = ''}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is String) return value.isEmpty ? fallback : value;
    return value.toString();
  }

  /// Returns the value at [key] as an [int].
  ///
  /// Parses string representations of integers. Returns [fallback] if the
  /// key is missing, the value is null, or the value cannot be converted.
  ///
  /// ```dart
  /// json.safeInt('coins');          // 25
  /// json.safeInt('coins_str');      // 25 (if value is '25')
  /// json.safeInt('missing');        // 0
  /// json.safeInt('missing', fallback: -1); // -1
  /// ```
  int safeInt(String key, {int fallback = 0}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    if (value is bool) return value ? 1 : 0;
    return fallback;
  }

  /// Returns the value at [key] as a [double].
  ///
  /// Parses string representations of numbers. Returns [fallback] if the
  /// key is missing, the value is null, or the value cannot be converted.
  ///
  /// ```dart
  /// json.safeDouble('price');       // 9.99
  /// json.safeDouble('price_str');   // 9.99 (if value is '9.99')
  /// json.safeDouble('missing');     // 0.0
  /// ```
  double safeDouble(String key, {double fallback = 0.0}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  /// Returns the value at [key] as a [bool].
  ///
  /// Handles multiple truthy/falsy representations:
  /// - `true` / `false` (bool)
  /// - `'true'` / `'false'` (string, case-insensitive)
  /// - `1` / `0` (int)
  ///
  /// Returns [fallback] if the key is missing or value cannot be determined.
  ///
  /// ```dart
  /// json.safeBool('active');         // true (if value is true/1/'true')
  /// json.safeBool('active');         // false (if value is false/0/'false')
  /// json.safeBool('missing');        // false
  /// ```
  bool safeBool(String key, {bool fallback = false}) {
    final value = this[key];
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

  /// Returns the value at [key] as a [Map<String, dynamic>].
  ///
  /// Returns an empty map `{}` if the key is missing, the value is null,
  /// or the value is not a Map. Never throws.
  ///
  /// ```dart
  /// json.safeMap('user');    // {'name': 'Vansh', ...}
  /// json.safeMap('missing'); // {}
  /// ```
  Map<String, dynamic> safeMap(String key) {
    final value = this[key];
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map(
        (k, v) => MapEntry(k.toString(), v),
      );
    }
    return {};
  }

  /// Returns the value at [key] as a [List].
  ///
  /// Returns an empty list `[]` if the key is missing, the value is null,
  /// or the value is not a List. Never throws.
  ///
  /// ```dart
  /// json.safeList('users');    // [{'name': 'Vansh'}, ...]
  /// json.safeList('missing'); // []
  /// ```
  List<dynamic> safeList(String key) {
    final value = this[key];
    if (value == null) return [];
    if (value is List) return value;
    return [];
  }
}
