/// Safe list access extensions for [List] and nullable lists.
///
/// These extensions prevent `RangeError` and null crashes when working with
/// lists returned from FlutterFlow API responses.
///
/// Example:
/// ```dart
/// final users = <Map<String, dynamic>>[];
///
/// users.safeFirst;          // null (no crash)
/// users.safeElementAt(5);   // null (no crash)
/// users.isNullOrEmpty;      // true
/// ```
extension ListExtensions<T> on List<T> {
  /// Returns the first element, or `null` if the list is empty.
  ///
  /// Unlike [List.first], this never throws a [StateError].
  ///
  /// ```dart
  /// [1, 2, 3].safeFirst; // 1
  /// [].safeFirst;         // null
  /// ```
  T? get safeFirst => isEmpty ? null : first;

  /// Returns the last element, or `null` if the list is empty.
  ///
  /// Unlike [List.last], this never throws a [StateError].
  ///
  /// ```dart
  /// [1, 2, 3].safeLast; // 3
  /// [].safeLast;         // null
  /// ```
  T? get safeLast => isEmpty ? null : last;

  /// Returns `true` if the list is empty.
  ///
  /// Mirrors [isNullOrEmpty] on the nullable variant for consistent API usage
  /// across both nullable and non-nullable contexts.
  ///
  /// ```dart
  /// [].isNullOrEmpty;        // true
  /// [1, 2].isNullOrEmpty;    // false
  /// ```
  bool get isNullOrEmpty => isEmpty;

  /// Returns the element at [index], or `null` if the index is out of range.
  ///
  /// Unlike [List.operator[]], this never throws a [RangeError].
  ///
  /// ```dart
  /// [10, 20, 30].safeElementAt(1);  // 20
  /// [10, 20, 30].safeElementAt(10); // null
  /// [].safeElementAt(0);             // null
  /// ```
  T? safeElementAt(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}

/// Safe list access extensions for nullable [List]s.
///
/// ```dart
/// List<String>? names;
/// names.isNullOrEmpty; // true
/// names.safeFirst;     // null
/// ```
extension NullableListExtensions<T> on List<T>? {
  /// Returns `true` if the list is null or empty.
  ///
  /// ```dart
  /// List<String>? names;
  /// names.isNullOrEmpty; // true
  ///
  /// names = [];
  /// names.isNullOrEmpty; // true
  ///
  /// names = ['Vansh'];
  /// names.isNullOrEmpty; // false
  /// ```
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns the first element, or `null` if the list is null or empty.
  ///
  /// ```dart
  /// List<int>? nums = [1, 2, 3];
  /// nums.safeFirst; // 1
  ///
  /// List<int>? empty;
  /// empty.safeFirst; // null
  /// ```
  T? get safeFirst => isNullOrEmpty ? null : this!.first;

  /// Returns the last element, or `null` if the list is null or empty.
  T? get safeLast => isNullOrEmpty ? null : this!.last;

  /// Returns the element at [index], or `null` if null or out of range.
  T? safeElementAt(int index) {
    if (this == null || index < 0 || index >= this!.length) return null;
    return this![index];
  }
}
