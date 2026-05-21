/// API response helper extensions for FlutterFlow map-based API responses.
///
/// FlutterFlow API responses arrive as `Map<String, dynamic>` in custom
/// actions. These extensions simplify status checks and data extraction.
///
/// Example:
/// ```dart
/// final json = response.jsonBody as Map<String, dynamic>;
///
/// if (json.isSuccess) {
///   final users = json.safeData.safeList('users');
/// }
/// ```
extension ApiExtensions on Map<String, dynamic> {
  /// Returns `true` if `statusCode` is in the 2xx success range (200–299).
  ///
  /// Returns `false` if the status code is missing, null, or outside range.
  ///
  /// ```dart
  /// {'statusCode': 200}.isSuccess; // true
  /// {'statusCode': 400}.isSuccess; // false
  /// {}.isSuccess;                  // false
  /// ```
  bool get isSuccess {
    final code = statusCodeSafe;
    return code >= 200 && code < 300;
  }

  /// Returns the `statusCode` as an [int], or `0` if missing or invalid.
  ///
  /// ```dart
  /// {'statusCode': 404}.statusCodeSafe; // 404
  /// {}.statusCodeSafe;                  // 0
  /// ```
  int get statusCodeSafe {
    final value = this['statusCode'];
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Returns the `data` field as a [Map<String, dynamic>], or `{}` if missing.
  ///
  /// ```dart
  /// final name = response.safeData.safeString('name');
  /// ```
  Map<String, dynamic> get safeData {
    final value = this['data'];
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }

  /// Returns the `body` field as [dynamic], or `null` if missing.
  dynamic get safeBody => this['body'];

  /// Returns the `message` or `error` field as a [String], or `''` if missing.
  ///
  /// ```dart
  /// final msg = response.safeMessage; // 'Not authorized'
  /// ```
  String get safeMessage {
    final msg = this['message'] ?? this['error'] ?? this['msg'];
    if (msg == null) return '';
    return msg.toString();
  }
}
