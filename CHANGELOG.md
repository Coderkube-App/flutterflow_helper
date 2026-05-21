## 1.0.2

### Improvements

- Enhanced package publishing configuration
- Improved pub.dev compatibility and validation support
- Updated repository and package metadata
- Refined documentation and package structure
- Minor internal optimizations and cleanup

### Notes

This release includes maintenance updates and publishing improvements with no breaking API changes.

## 1.0.1

### Updates

- Updated GitHub repository URL in `pubspec.yaml`
- Improved package metadata for better pub.dev visibility
- Minor documentation improvements

### Existing Features

- JSON Extensions
- Dynamic Extensions
- Path Extensions
- List Extensions
- API Extensions
- FFLogger

### Platform Support

Android, iOS, Web, macOS, Windows, Linux

## 1.0.0

**Initial release**

### New Features

- **JSON Extensions** (`json_extensions.dart`)
  - `safeString` — null-safe string with auto type conversion
  - `safeInt` — parses strings, doubles, bools to int
  - `safeDouble` — parses strings and ints to double
  - `safeBool` — handles bool, int (0/1), and string ("true"/"false")
  - `safeMap` — returns `{}` instead of null or crash
  - `safeList` — returns `[]` instead of null or crash

- **Dynamic Extensions** (`dynamic_extensions.dart`)
  - `toSafeInt` — safe int conversion from any dynamic value
  - `toSafeDouble` — safe double conversion
  - `toSafeBool` — safe bool conversion with string support
  - `toSafeString` — safe toString with null guard

- **Path Extensions** (`path_extensions.dart`) — *signature feature*
  - `path` — dot-separated nested traversal returning dynamic
  - `pathString` — nested path to String
  - `pathInt` — nested path to int
  - `pathDouble` — nested path to double
  - `pathBool` — nested path to bool
  - `pathList` — nested path to List
  - `pathMap` — nested path to Map
  - Supports numeric list indices (e.g. `'data.users.0.name'`)
  - Never throws on invalid paths

- **List Extensions** (`list_extensions.dart`)
  - `safeFirst` — null instead of StateError on empty list
  - `safeLast` — null instead of StateError on empty list
  - `safeElementAt` — null instead of RangeError on bad index
  - `isNullOrEmpty` — works on both `List<T>` and `List<T>?`
  - Full nullable list support via `NullableListExtensions`

- **API Extensions** (`api_extensions.dart`)
  - `isSuccess` — true for HTTP 200–299
  - `statusCodeSafe` — int with fallback 0
  - `safeData` — extracts `data` key safely
  - `safeBody` — extracts `body` key safely
  - `safeMessage` — extracts `message`/`error`/`msg` safely

- **FFLogger** (`ff_logger.dart`)
  - `FFLogger.log` — pretty JSON printing, debug mode only
  - `FFLogger.warn` — debug-only warnings
  - `FFLogger.error` — debug-only error logging
  - Zero output in release builds (uses `kDebugMode`)

### Platform Support

Android, iOS, Web, macOS, Windows, Linux
