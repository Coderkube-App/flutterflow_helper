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
