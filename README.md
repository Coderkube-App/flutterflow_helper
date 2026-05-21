# Flutterflow Helpers

A lightweight utility toolkit for safer API and JSON handling in FlutterFlow. FlutterFlow APIs return dynamic, nullable values, inconsistent types, and deeply nested JSON. This package prevents the crashes that come from them — without adding complexity.

## Features

- **JSON Extensions**: Safe typed getters on `Map<String, dynamic>` that prevent crashes during data extraction.
- **Nested Path Access**: Dot-notation traversal (e.g., `data.user.profile.name`) that safely navigates Maps and Lists without throwing errors.
- **Dynamic Conversions**: Direct safety casting extensions for raw nullable variables (`Object?`).
- **List Extensions**: Null-safe list operations (`safeFirst`, `safeLast`, and `safeElementAt`) to prevent indexing range errors.
- **API Helpers**: Integrated status code, success state, and body extractors.
- **FFLogger**: A pretty debug logger that automatically silent in release/production builds.

## Getting started

Add `flutterflow_helpers` to your `pubspec.yaml`:

```yaml
dependencies:
  flutterflow_helpers: ^1.0.0
```

Then run:

```bash
flutter pub get
```
## FlutterFlow Integration Guide

Follow these step-by-step instructions to integrate this package directly inside the FlutterFlow builder interface:

### 1. Add the Pubspec Dependency
1. Open your project inside **FlutterFlow**.
2. Click on the **Settings and Integrations** icon (gear icon) in the left panel.
3. Select **Custom Code** under the **Project Setup** section.
4. Scroll down to the **Pubspec Dependencies** area.
5. Click **+ Add Dependency**.
6. Set the dependency name to `flutterflow_helpers` and the version to `^1.0.0`.
7. Click the green **Save** button.
8. Click the **Refresh** button on the panel to let FlutterFlow fetch the package from pub.dev.

### 2. Import the Package in Custom Code
When writing any Custom Action or Custom Widget, import the helper suite at the top of your code panel:

```dart
import 'package:flutterflow_helpers/flutterflow_helpers.dart';
```

### 3. Create Standalone Custom Functions for UI Bindings (Self-Contained Option)

If you prefer to write self-contained custom functions inside the FlutterFlow editor without importing external packages, you can copy and paste the complete implementation logic directly:

#### stringToInt
* **Argument**: `dynamicValue` (Type: `String`, Nullable: `Checked`)
* **Return Type**: `Integer` (Nullable: `Unchecked`)

```dart
int stringToInt(String? dynamicValue) {
  if (dynamicValue == null || dynamicValue.isEmpty) return 0;
  final trimmed = dynamicValue.trim();
  final parsed = int.tryParse(trimmed);
  if (parsed != null) return parsed;
  final parsedDouble = double.tryParse(trimmed);
  if (parsedDouble != null) return parsedDouble.toInt();
  return 0;
}
```

#### stringToDouble
* **Argument**: `dynamicValue` (Type: `String`, Nullable: `Checked`)
* **Return Type**: `Double` (Nullable: `Unchecked`)

```dart
double stringToDouble(String? dynamicValue) {
  if (dynamicValue == null || dynamicValue.isEmpty) return 0.0;
  return double.tryParse(dynamicValue.trim()) ?? 0.0;
}
```

#### stringToBool
* **Argument**: `dynamicValue` (Type: `String`, Nullable: `Checked`)
* **Return Type**: `Boolean` (Nullable: `Unchecked`)

```dart
bool stringToBool(String? dynamicValue) {
  if (dynamicValue == null || dynamicValue.isEmpty) return false;
  final str = dynamicValue.trim().toLowerCase();
  return str == 'true' || str == '1' || str == 'yes' || str == 'y';
}
```

#### getPathString (Nested Map & List Traversal)
* **Argument 1**: `jsonMap` (Type: `JSON`, Nullable: `Checked`)
* **Argument 2**: `path` (Type: `String`, Nullable: `Unchecked`)
* **Return Type**: `String` (Nullable: `Unchecked`)

```dart
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';

String getPathString(
  dynamic jsonMap,
  String path,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  if (jsonMap == null) return '';
  final segments = path.split('.');
  dynamic current = jsonMap;
  for (final segment in segments) {
    if (current == null) return '';
    if (current is Map) {
      current = current[segment];
    } else if (current is List) {
      final index = int.tryParse(segment);
      if (index == null || index < 0 || index >= current.length) return '';
      current = current[index];
    } else {
      return '';
    }
  }
  return current?.toString() ?? '';

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
```

#### getPathImage (Nested Image Map & List Traversal with List Handler)
* **Argument 1**: `jsonMap` (Type: `JSON`, Nullable: `Checked`)
* **Argument 2**: `path` (Type: `String`, Nullable: `Unchecked`)
* **Return Type**: `Image Path` (Nullable: `Unchecked`)

```dart
String getPathImage(dynamic jsonMap, String path) {
  if (jsonMap == null) return '';
  final segments = path.split('.');
  dynamic current = jsonMap;

  for (final segment in segments) {
    if (current == null) return '';
    if (current is Map) {
      current = current[segment];
    } else if (current is List) {
      final index = int.tryParse(segment);
      if (index == null || index < 0 || index >= current.length) return '';
      current = current[index];
    } else {
      return '';
    }
  }

  // Smart List Handler: If the final value is a List, get the first item
  if (current is List) {
    if (current.isNotEmpty) {
      current = current.first;
    } else {
      return '';
    }
  }

  return current?.toString() ?? '';
}
```

#### safeGetElement (Safe List Index Access)
* **Argument 1**: `itemsList` (Type: `JSON`, Nullable: `Checked`, List: `Checked`)
* **Argument 2**: `index` (Type: `Integer`, Nullable: `Unchecked`)
* **Return Type**: `String` (Nullable: `Unchecked`)

```dart
String safeGetElement(List<dynamic>? itemsList, int index) {
  if (itemsList == null || itemsList.isEmpty) return '';
  if (index < 0 || index >= itemsList.length) return '';
  return itemsList[index]?.toString() ?? '';
}
```

---

### 4. Visual UI Bindings: 1-Line Wrapper Functions (Recommended Option)

If you are using the **`flutterflow_helpers`** package, you don't need to copy and paste the complex multi-line logic above! Because FlutterFlow compiles Custom Functions in isolated environments, they cannot access package methods unless they are imported.

**The Solution: 1-Line Wrapper Functions!**

Instead of having to copy and paste 20 lines of complex loop logic for every custom function, developers using **`flutterflow_helpers`** can just create a visual Custom Function in their panel and write a **single line of code** inside it by importing your package!

Here is what they write in their FlutterFlow editor:

#### 1. For `getPathString` (Only 1 Line!)
* **Return Type**: `String` (Nullable: `Unchecked`)
* **Argument 1**: `jsonMap` (Type: `JSON`, Nullable: `Checked`)
* **Argument 2**: `path` (Type: `String`, Nullable: `Unchecked`)

```dart
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

String getPathString(dynamic jsonMap, String path) {
  return FFPath.getString(jsonMap, path); // Safe, namespace-isolated call!
}
```

#### 2. For `getPathImage` (Smart Image & List Handler — Only 1 Line!)
* **Return Type**: `Image Path` (Nullable: `Unchecked`)
* **Argument 1**: `jsonMap` (Type: `JSON`, Nullable: `Checked`)
* **Argument 2**: `path` (Type: `String`, Nullable: `Unchecked`)

```dart
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

String getPathImage(dynamic jsonMap, String path) {
  return FFPath.getImage(jsonMap, path); // Safe, namespace-isolated call!
}
```

#### 3. For `stringToInt` (Only 1 Line!)
* **Return Type**: `Integer` (Nullable: `Unchecked`)
* **Argument**: `dynamicValue` (Type: `String`, Nullable: `Checked`)

```dart
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

int stringToInt(String? dynamicValue) {
  return dynamicValue.toSafeInt(); // Calls your package's safe conversion!
}
```

#### 4. For `safeGetElement` (Only 1 Line!)
* **Return Type**: `String` (Nullable: `Unchecked`)
* **Argument 1**: `itemsList` (Type: `JSON`, List: `Checked`, Nullable: `Checked`)
* **Argument 2**: `index` (Type: `Integer`, Nullable: `Unchecked`)

```dart
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

String safeGetElement(List<dynamic>? itemsList, int index) {
  return itemsList.safeElementAt(index)?.toString() ?? ''; 
}
```

---

### How to distribute this to your users:
To make it seamless for other developers using your package:
1. They add `flutterflow_helpers` to their **Pubspec Dependencies** in FlutterFlow settings.
2. They create the visual Custom Function in their panel (so they can select it in the UI bindings).
3. They copy-paste the **1-line code** above!

This gives your package an extremely clean, premium, and professional feel. It shows that you built a truly optimized helper toolkit! ## Usage

To build pure, modular code with `flutterflow_helpers`, use it inside **Custom Actions**, **Custom Widgets**, or **Custom Functions** with visual panel definitions that align with standard Flutter Flow configurations.

### 1. Custom Actions

For Custom Actions, write straightforward asynchronous or synchronous Dart functions. Define parameters and types visually in the FlutterFlow panel so they easily map to your package.

#### Example A: Parse User Data from API
* **Action Name**: `parseUserData`
* **Return Type**: `String` (Nullable: `Unchecked`)
* **Define Arguments / Parameters**:
  * `apiResponse` (Type: `JSON`, Nullable: `Checked`)

##### Boilerplate Wrap Code (Copy & Paste):
```dart
// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

Future<String> parseUserData(dynamic responseBody) async {
  try {
    // 1. If responseBody is already null, return early
    if (responseBody == null) {
      return 'No data received (Null Response).';
    }

    Map<String, dynamic> jsonMap = {};

    // 2. Safely handle if input is a String or Map
    if (responseBody is Map) {
      jsonMap = Map<String, dynamic>.from(responseBody);
    } else if (responseBody is String) {
      // If it's a direct String, try to decode it as JSON
      try {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map) {
          jsonMap = Map<String, dynamic>.from(decoded);
        } else {
          // If it's a normal string, return directly
          return 'Response is a plain string: "$responseBody"';
        }
      } catch (_) {
        // Not a JSON string, just plain text
        return 'Response text: "$responseBody"';
      }
    }

    // 3. Extract data safely using flutterflow_helpers extensions!
    // safeMap guarantees we get a valid map instead of null or crashes
    final data = jsonMap.safeMap('data');
    if (data.isEmpty) {
      return 'Data inside JSON is missing. Full response: ${jsonMap.toString()}';
    }

    // Use path extensions to easily retrieve nested values with fallbacks
    String title = jsonMap.pathString('data.title', fallback: 'No Title');
    String authorName = jsonMap.pathString('data.user.name', fallback: 'Anonymous');
    int likes = jsonMap.pathInt('data.likes', fallback: 0);

    // Pretty-print to the console using the built-in logger (auto-silenced in release)
    FFLogger.log(jsonMap, label: 'Parsed Post Data');

    // 4. Return clean message
    return 'Success! Post: "$title" by $authorName with $likes likes.';
  } catch (e) {
    // In case of any unexpected errors
    FFLogger.error('Parsing error', e);
    return 'Parsing Error: ${e.toString()}';
  }
}
```

---

### 2. Custom Widgets

For Custom Widgets, ensure your custom UI elements take standard parameters (like `width`, `height`, or `JSON` objects) so a FlutterFlow user can map their app states directly to the widget parameters in the visual builder.

#### Visual Panel Settings in FlutterFlow:
* **Widget Name**: `UserCard`
* **Define Arguments / Parameters**:
  * `width` (Type: `Double`, Nullable: `Checked`)
  * `height` (Type: `Double`, Nullable: `Checked`)
  * `userData` (Type: `JSON`, Nullable: `Checked`)

#### Boilerplate Wrap Code (Copy & Paste):
```dart
// Automatic Generation Action code ...
// Define arguments in the right panel: width (Double), height (Double), userData (JSON)
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    super.key,
    this.width,
    this.height,
    this.userData,
  });

  final double? width;
  final double? height;
  final dynamic userData;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    // 1. Cast incoming parameter safely using the toolkit
    final Map<String, dynamic> data = (widget.userData as Map<String, dynamic>? ?? {});

    // 2. Safely extract values using JsonExtensions and PathExtensions
    final name = data.safeString('name', fallback: 'Guest User');
    final coins = data.safeInt('coins', fallback: 0);
    final isActive = data.safeBool('active');
    final bio = data.pathString('profile.bio', fallback: 'No biography provided.');

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 150.0,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Premium Dark Slate background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive ? const Color(0xFFA7F3D0) : const Color(0xFFFCA5A5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            bio,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Balance:',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
              ),
              Text(
                '🪙 $coins Coins',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

### 3. Custom Functions

For Custom Functions inside FlutterFlow where external imports are isolated, define the standard parameters in the panel, and use our lightweight logic directly inside the editor:

#### Visual Panel Settings in FlutterFlow:
* **Function Name**: `stringToInt`
* **Return Type**: `Integer` (Nullable: `Unchecked`)
* **Define Arguments / Parameters**:
  * `dynamicValue` (Type: `String`, Nullable: `Checked`)

#### Code (Copy & Paste):
```dart
int stringToInt(String? dynamicValue) {
  if (dynamicValue == null || dynamicValue.isEmpty) return 0;
  final trimmed = dynamicValue.trim();
  final parsed = int.tryParse(trimmed);
  if (parsed != null) return parsed;
  final parsedDouble = double.tryParse(trimmed);
  if (parsedDouble != null) return parsedDouble.toInt();
  return 0;
}
```
---
---

## API Reference

### JSON Extensions
Direct utility extensions on `Map<String, dynamic>` for safe type casting:

```dart
final Map<String, dynamic> json = {'name': 'Vansh', 'coins': '25', 'active': 1};

json.safeString('name');                        // 'Vansh'
json.safeString('missing', fallback: 'Guest'); // 'Guest'
json.safeInt('coins');                          // 25  (automatically parsed from "25")
json.safeDouble('price');                       // 0.0 (returns fallback for missing keys)
json.safeBool('active');                        // true (int 1 converted to true)
json.safeMap('profile');                        // {}  (returns empty map instead of null or crash)
json.safeList('tags');                          // []  (returns empty list instead of null or crash)
```

### Path Extensions
Signature traversal utilities on `Object?` allowing nested dot-notation access across Maps and Lists:

```dart
final Map<String, dynamic> response = {
  'data': {
    'user': {
      'name': 'Vansh',
      'coins': '25',
      'tags': ['flutter', 'dart'],
    }
  }
};

response.pathString('data.user.name');          // 'Vansh'
response.pathInt('data.user.coins');            // 25
response.pathBool('data.user.active');          // false
response.pathString('data.user.tags.0');        // 'flutter' (list index access)
response.pathImage('data.post.gallery');        // gets first image from list (smart list handler)
response.pathString('x.y.z.missing');           // '' (never throws an error)
```

### FFPath (Static Path Helpers)
Namespace-isolated static utilities to extract nested paths without extension dispatch limitations on `dynamic` inputs (perfect for FlutterFlow Custom Functions):

```dart
dynamic payload = {
  'data': {'title': 'Hello World'}
};

FFPath.getString(payload, 'data.title'); // 'Hello World' (no casting required!)
FFPath.getInt(payload, 'data.views');    // 0
```

### Dynamic Extensions
Safe type casting extensions on nullable `Object?` variables:

```dart
Object? coins = '42';
coins.toSafeInt();    // 42

Object? flag = 'TRUE';
flag.toSafeBool();    // true

Object? price = null;
price.toSafeDouble(); // 0.0

Object? val = null;
val.toSafeString(fallback: 'N/A'); // 'N/A'
```

### List Extensions
Safety operations on standard Lists to prevent index and state exceptions:

```dart
final users = ['Alice', 'Bob'];

users.safeFirst;           // 'Alice'
users.safeLast;            // 'Bob'
users.safeElementAt(5);    // null (no RangeError is thrown)
users.isNullOrEmpty;       // false

final emptyList = <String>[];
emptyList.safeFirst;       // null (no StateError is thrown)

List<String>? nullList;
nullList.isNullOrEmpty;    // true
nullList.safeFirst;        // null
```

### API Extensions
Helper methods on `Map<String, dynamic>` payloads representing HTTP JSON responses:

```dart
final response = {
  'statusCode': 200,
  'data': {'id': 1},
  'message': 'OK',
};

response.isSuccess;        // true (checks if status code is in 200-299 range)
response.statusCodeSafe;   // 200
response.safeData;         // {'id': 1}
response.safeMessage;      // 'OK'
```

### FFLogger
Debug logging tool that automatically strips and suppresses all console print streams in release mode.

```dart
// Pretty-prints maps and lists in debug mode
FFLogger.log(response, label: 'API Response');

// Prints warnings and error reports
FFLogger.warn('Coins field missing, utilizing fallback');
FFLogger.error('Failed to parse response payload', exception);
```

---

## Platform Support

Pure Dart implementation containing zero native codes or platform channels.

- **Android** (Fully Supported)
- **iOS** (Fully Supported)
- **Web** (Fully Supported)
- **macOS** (Fully Supported)
- **Windows** (Fully Supported)
- **Linux** (Fully Supported)

---

## License

Please see the [LICENSE](LICENSE) file for licensing details and configuration guidelines.
