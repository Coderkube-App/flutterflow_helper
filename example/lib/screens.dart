import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

/// Screen 1: Interactive JSON Playground & Dynamic Path Tester.
class SafeParsingScreen extends StatefulWidget {
  const SafeParsingScreen({super.key});

  @override
  State<SafeParsingScreen> createState() => _SafeParsingScreenState();
}

class _SafeParsingScreenState extends State<SafeParsingScreen> {
  late TextEditingController _jsonController;
  late TextEditingController _pathController;
  Map<String, dynamic> _parsedJson = {};
  String? _jsonError;
  dynamic _queryResult;

  static const String _defaultJson = '''{
  "statusCode": 200,
  "message": "User profile retrieved successfully",
  "data": {
    "user": {
      "name": "Vansh Jariwala",
      "coins": "250",
      "isPremium": 1,
      "rating": "4.92",
      "tags": ["flutter", "flutterflow", "dart"],
      "profile": {
        "bio": "Building high-performance utilities",
        "location": "India"
      }
    },
    "meta": {
      "request_id": "req-ff-9842"
    }
  }
}''';

  @override
  void initState() {
    super.initState();
    _jsonController = TextEditingController(text: _defaultJson);
    _pathController = TextEditingController(text: 'data.user.name');
    _parseJson(_jsonController.text);
    _evaluatePath();
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _parseJson(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        _parsedJson = {};
        _jsonError = 'JSON is empty';
      });
      return;
    }

    try {
      final decoded = json.decode(text);
      if (decoded is Map<String, dynamic>) {
        setState(() {
          _parsedJson = decoded;
          _jsonError = null;
        });
      } else {
        setState(() {
          _parsedJson = {};
          _jsonError = 'Root element must be a JSON Object (Map)';
        });
      }
    } catch (e) {
      setState(() {
        _parsedJson = {};
        _jsonError = e.toString();
      });
    }
  }

  void _evaluatePath() {
    if (_jsonError != null || _parsedJson.isEmpty) {
      setState(() {
        _queryResult = null;
      });
      return;
    }

    final pathStr = _pathController.text.trim();
    if (pathStr.isEmpty) {
      setState(() {
        _queryResult = null;
      });
      return;
    }

    setState(() {
      _queryResult = _parsedJson.path(pathStr);
    });
  }

  List<String> _getJsonPaths(Map<String, dynamic> jsonMap) {
    final List<String> paths = [];

    void traverse(dynamic value, String currentPath) {
      if (paths.length >= 25) return; // Cap at 25 to keep the UI clean

      if (value is Map<String, dynamic>) {
        for (final key in value.keys) {
          final nextPath = currentPath.isEmpty ? key : '$currentPath.$key';
          paths.add(nextPath);
          traverse(value[key], nextPath);
        }
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          if (i >= 2) break; // Limit list item traversal
          final nextPath = '$currentPath.$i';
          paths.add(nextPath);
          traverse(value[i], nextPath);
        }
      }
    }

    traverse(jsonMap, '');
    return paths.toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final response = _parsedJson;
    final isSuccess = response.isSuccess;
    final statusCode = response.statusCodeSafe;
    final discoveredPaths = _getJsonPaths(_parsedJson);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Welcome Header
        const Text(
          'INSTRUCTIONS',
          style: TextStyle(
            color: Color(0xFF818CF8),
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Interactive Developer Playground',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paste any raw API JSON response below, modify values, and test paths dynamically. Watch how the safe parsers automatically prevent crashes and convert mismatched types on-the-fly.',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // Section 1: Raw JSON Editor Input
        const _SectionHeader('1. Paste Raw JSON Response'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _jsonError == null
                  ? const Color(0xFF334155)
                  : const Color(0xFFEF4444),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar of JSON Box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _jsonError == null
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'JSON PAYLOAD EDITOR',
                      style: TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Spacer(),
                    if (_jsonError == null)
                      const Text(
                        'VALID JSON',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        'INVALID JSON',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _jsonController,
                  maxLines: 8,
                  style: const TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontSize: 13,
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your JSON object here...',
                    hintStyle: TextStyle(color: Color(0xFF475569)),
                  ),
                  onChanged: (text) {
                    _parseJson(text);
                    _evaluatePath();
                  },
                ),
              ),
            ],
          ),
        ),

        // Error message if any
        if (_jsonError != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF451A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEF4444)),
            ),
            child: Text(
              '⚠️ Parser Warning:\n$_jsonError',
              style: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.3,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Section 2: Dynamic Path Evaluator
        const _SectionHeader('2. Query Deep JSON Path Dynamically'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (discoveredPaths.isNotEmpty) ...[
                const Text(
                  '💡 DISCOVERED PATHS IN YOUR JSON (TAP TO INSPECT):',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: discoveredPaths.length,
                    itemBuilder: (context, index) {
                      final path = discoveredPaths[index];
                      final isSelected = _pathController.text.trim() == path;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            path,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFCBD5E1),
                              fontSize: 11,
                              fontFamily: 'monospace',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF4F46E5),
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF818CF8)
                                  : const Color(0xFF334155),
                              width: 1,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _pathController.text = path;
                                _evaluatePath();
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Or enter a custom dot-separated path manually:',
                style: TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF475569)),
                      ),
                      child: TextField(
                        controller: _pathController,
                        style: const TextStyle(
                          color: Color(0xFFF1F5F9),
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'e.g. data.user.profile.location',
                          hintStyle: TextStyle(color: Color(0xFF475569)),
                        ),
                        onChanged: (text) => _evaluatePath(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _evaluatePath,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      'Run Query',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Query Evaluation Results Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Raw Resolution:',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _queryResult == null
                                ? 'Null / Missing'
                                : _queryResult.runtimeType.toString(),
                            style: const TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 9,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _queryResult == null ? 'null' : '$_queryResult',
                      style: TextStyle(
                        color: _queryResult == null
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF38BDF8),
                        fontSize: 14,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section 3: Safe Types Extraction Dashboard
        const _SectionHeader('3. Real-Time Conversion Output'),
        const SizedBox(height: 4),
        const Text(
          'See how our safe path accessors convert the result above dynamically into your desired types without throwing errors:',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.3),
        ),
        const SizedBox(height: 12),

        _ResultCard(
          method: "response.pathString('${_pathController.text}')",
          result: response.pathString(_pathController.text, fallback: 'N/A'),
          note: 'Safely converts value to a String',
        ),
        _ResultCard(
          method: "response.pathInt('${_pathController.text}')",
          result: '${response.pathInt(_pathController.text)}',
          note:
              'Safely converts value to an int (even if it was a String numeric)',
        ),
        _ResultCard(
          method: "response.pathDouble('${_pathController.text}')",
          result: '${response.pathDouble(_pathController.text)}',
          note: 'Safely parses numeric String/double',
        ),
        _ResultCard(
          method: "response.pathBool('${_pathController.text}')",
          result: '${response.pathBool(_pathController.text)}',
          note: 'Converts 1/0, "true"/"false" safely to bool',
        ),
        _ResultCard(
          method: "response.pathList('${_pathController.text}')",
          result: '${response.pathList(_pathController.text)}',
          note: 'Ensures a valid list is returned, otherwise empty list []',
        ),
        _ResultCard(
          method: "response.pathMap('${_pathController.text}')",
          result: '${response.pathMap(_pathController.text)}',
          note: 'Ensures a valid map is returned, otherwise empty map {}',
        ),

        const SizedBox(height: 24),

        // Section 4: General API Metadata Panel
        const _SectionHeader('4. API Utilities Status'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155), width: 1.5),
          ),
          child: Column(
            children: [
              _MetaRow(
                label: 'response.statusCodeSafe',
                value: '$statusCode',
                desc: 'Safely gets status code as int (even if null/missing)',
              ),
              const Divider(color: Color(0xFF334155), height: 20),
              _MetaRow(
                label: 'response.isSuccess',
                value: '$isSuccess',
                desc: 'True if status code is in the range 200–299',
                useColorIndicator: true,
                indicatorVal: isSuccess,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 2 — Interactive Crash Simulator
// ---------------------------------------------------------------------------

class CrashPreventionScreen extends StatelessWidget {
  const CrashPreventionScreen({super.key});

  static const Map<String, dynamic> _brokenResponse = {
    'statusCode': null,
    'data': null,
  };

  static const Map<String, dynamic> _emptyUser = {};

  @override
  Widget build(BuildContext context) {
    const response = _brokenResponse;
    const user = _emptyUser;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Welcome Header
        const Text(
          'SAFETY ENGINE',
          style: TextStyle(
            color: Color(0xFFF43F5E),
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Crash Simulator & Safe Casts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Compare how standard Dart lookup methods instantly crash your app vs. how flutterflow_helpers resolves them smoothly with elegant fallback support.',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // Developer Alert Box regarding dynamic variables
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B4B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4338CA), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF818CF8), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PRO TIP: Dynamic Extensions in Dart',
                    style: TextStyle(
                      color: Color(0xFFC7D2FE),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'In Dart, extension methods cannot be called directly on variables statically typed as "dynamic" because Dart uses dynamic instance dispatch. Always cast your dynamic variable to "Object?" or "Map" first so Dart resolves the extensions properly!',
                style: TextStyle(
                  color: Color(0xFFA5B4FC),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '// CRASHES: dynamicVal.toSafeInt();\n// SAFE: (dynamicVal as Object?).toSafeInt();',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const _SectionHeader('Side-By-Side Battle Arena'),
        const SizedBox(height: 8),

        _CrashCard(
          crashCode: "response['data']['user']['name']",
          safeCode: "response.pathString('data.user.name')",
          result: response.pathString('data.user.name', fallback: 'Not Found'),
          note:
              'Nested lookup inside a null container "data". Safe lookup returns "Not Found" without crashing.',
        ),
        _CrashCard(
          crashCode: "response['statusCode'] as int",
          safeCode: "response.statusCodeSafe",
          result: '${response.statusCodeSafe}',
          note:
              'Directly casting a null statusCode to int crashes. Safe mapping returns 0.',
        ),
        _CrashCard(
          crashCode: "user['coins'] as int",
          safeCode: "user.safeInt('coins')",
          result: '${user.safeInt('coins')}',
          note:
              'Accessing a missing key inside an empty map as int crashes. Safe access returns 0.',
        ),
        _CrashCard(
          crashCode: "user['active'] as bool",
          safeCode: "user.safeBool('active')",
          result: '${user.safeBool('active')}',
          note:
              'Accessing a missing key as bool crashes. Safe access returns false.',
        ),
        _CrashCard(
          crashCode: "[].first",
          safeCode: "[].safeFirst",
          result: '${[].safeFirst}',
          note:
              'Calling .first on an empty list throws a StateError. .safeFirst returns null.',
        ),
        _CrashCard(
          crashCode: "[1,2,3][99]",
          safeCode: "[1,2,3].safeElementAt(99)",
          result: '${[1, 2, 3].safeElementAt(99)}',
          note:
              'Indices out of bounds throw RangeError. .safeElementAt returns null.',
        ),

        const SizedBox(height: 24),
        const _SectionHeader('Safe Casts for dynamic/Object? values'),
        const SizedBox(height: 8),

        _ResultCard(
          method: "(null as Object?).toSafeInt()",
          result: '${(null as Object?).toSafeInt()}',
          note: 'Gracefully converts null to 0',
        ),
        _ResultCard(
          method: "('abc' as Object?).toSafeInt(fallback: -1)",
          result: "${('abc' as Object?).toSafeInt(fallback: -1)}",
          note: 'Non-numeric string returns user-configured fallback of -1',
        ),
        _ResultCard(
          method: "('TRUE' as Object?).toSafeBool()",
          result: "${('TRUE' as Object?).toSafeBool()}",
          note: 'Converts "TRUE" string case-insensitively to true',
        ),
        _ResultCard(
          method: "(null as Object?).toSafeString(fallback: 'N/A')",
          result: (null as Object?).toSafeString(fallback: 'N/A'),
          note: 'Converts null securely to "N/A"',
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared High-Contrast Components
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF818CF8),
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String method;
  final String result;
  final String? note;

  const _ResultCard({required this.method, required this.result, this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            method,
            style: const TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Result: ',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: SelectableText(
                  result,
                  style: const TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 6),
            Text(
              note!,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CrashCard extends StatelessWidget {
  final String crashCode;
  final String safeCode;
  final String result;
  final String note;

  const _CrashCard({
    required this.crashCode,
    required this.safeCode,
    required this.result,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CRASH CODE HEADER (Vivid high-contrast red)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF881337), // Gorgeous Dark Burgundy
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('💥 STANDARD DART (CRASHES)',
                        style: TextStyle(
                            color: Color(0xFFFECDD3),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBE123C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Fatal',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  crashCode,
                  style: const TextStyle(
                    color: Color(0xFFFDA4AF),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // SAFE CODE SECTION (Clean high-contrast dark with emerald result)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🛡️ SAFE PARSING ALTERNATIVE',
                    style: TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const SizedBox(height: 6),
                SelectableText(
                  safeCode,
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Output: ',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    Expanded(
                      child: SelectableText(
                        result,
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  note,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final String desc;
  final bool useColorIndicator;
  final bool indicatorVal;

  const _MetaRow({
    required this.label,
    required this.value,
    required this.desc,
    this.useColorIndicator = false,
    this.indicatorVal = false,
  });

  @override
  Widget build(BuildContext context) {
    Color valColor = const Color(0xFF38BDF8);
    if (useColorIndicator) {
      valColor =
          indicatorVal ? const Color(0xFF34D399) : const Color(0xFFEF4444);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                label,
                style: const TextStyle(
                  color: Color(0xFF818CF8),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SelectableText(
              value,
              style: TextStyle(
                color: valColor,
                fontSize: 13,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
