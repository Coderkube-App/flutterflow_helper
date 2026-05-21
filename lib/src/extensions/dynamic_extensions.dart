/// Safe type conversion extensions for [dynamic] values.
///
/// These extensions are useful when you have a raw `dynamic` value from a
/// FlutterFlow API response and need to convert it safely without crashes.
///
/// Example:
/// ```dart
/// dynamic coins = '42';
/// coins.toSafeInt();    // 42
///
/// dynamic flag = 'true';
/// flag.toSafeBool();    // true
///
/// dynamic price = null;
/// price.toSafeDouble(); // 0.0
/// ```
extension DynamicExtensions on Object? {
  /// Converts this dynamic value to an [int] safely.
  ///
  /// Handles: `int`, `double`, `String`, `bool`.
  /// Returns [fallback] (default `0`) if conversion fails or value is null.
  ///
  /// ```dart
  /// (42).toSafeInt()     // 42
  /// ('42').toSafeInt()   // 42
  /// (3.9).toSafeInt()    // 3
  /// (true).toSafeInt()   // 1
  /// (null).toSafeInt()   // 0
  /// ('abc').toSafeInt()  // 0
  /// ```
  int toSafeInt({int fallback = 0}) {
    if (this == null) return fallback;
    if (this is int) return this as int;
    if (this is double) return (this as double).toInt();
    if (this is bool) return (this as bool) ? 1 : 0;

    final str = toString().trim();
    final parsedInt = int.tryParse(str);
    if (parsedInt != null) return parsedInt;

    final parsedDouble = double.tryParse(str);
    if (parsedDouble != null) return parsedDouble.toInt();

    return fallback;
  }

  /// Converts this dynamic value to a [double] safely.
  ///
  /// Handles: `double`, `int`, `String`.
  /// Returns [fallback] (default `0.0`) if conversion fails or value is null.
  ///
  /// ```dart
  /// (3.14).toSafeDouble()   // 3.14
  /// ('3.14').toSafeDouble() // 3.14
  /// (42).toSafeDouble()     // 42.0
  /// (null).toSafeDouble()   // 0.0
  /// ```
  double toSafeDouble({double fallback = 0.0}) {
    if (this == null) return fallback;
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();

    final parsed = double.tryParse(toString().trim());
    return parsed ?? fallback;
  }

  /// Converts this dynamic value to a [bool] safely.
  ///
  /// Handles:
  /// - `bool` → returned as-is
  /// - `int`/`double` → `0` is `false`, any other number is `true`
  /// - `String` → `'true'`/`'1'`/`'yes'`/`'y'` → `true` (case-insensitive)
  ///
  /// Returns [fallback] (default `false`) if value is null or unrecognized.
  ///
  /// ```dart
  /// (true).toSafeBool()    // true
  /// (1).toSafeBool()       // true
  /// ('true').toSafeBool()  // true
  /// ('FALSE').toSafeBool() // false
  /// (null).toSafeBool()    // false
  /// ```
  bool toSafeBool({bool fallback = false}) {
    if (this == null) return fallback;
    if (this is bool) return this as bool;
    if (this is num) return (this as num).toInt() != 0;

    final str = toString().trim().toLowerCase();
    if (str == 'true' || str == '1' || str == 'yes' || str == 'y') return true;
    if (str == 'false' || str == '0' || str == 'no' || str == 'n') return false;

    return fallback;
  }

  /// Converts this dynamic value to a [String] safely.
  ///
  /// Calls `toString()` on any non-null value.
  /// Returns [fallback] (default `''`) if value is null.
  ///
  /// ```dart
  /// (42).toSafeString()       // '42'
  /// (true).toSafeString()     // 'true'
  /// ('hello').toSafeString()  // 'hello'
  /// (null).toSafeString()     // ''
  /// ```
  String toSafeString({String fallback = ''}) {
    if (this == null) return fallback;
    final str = toString().trim();
    return str.isEmpty ? fallback : str;
  }
}
