import 'package:flutter_test/flutter_test.dart';
import 'package:flutterflow_helpers/flutterflow_helpers.dart';

void main() {
  // ---------------------------------------------------------------------------
  // JsonExtensions
  // ---------------------------------------------------------------------------
  group('JsonExtensions', () {
    late Map<String, dynamic> json;

    setUp(() {
      json = {
        'name': 'Vansh',
        'coins': 25,
        'coins_str': '25',
        'price': 9.99,
        'price_str': '9.99',
        'active_bool': true,
        'active_int': 1,
        'active_str': 'true',
        'inactive_str': 'false',
        'inactive_int': 0,
        'null_val': null,
        'empty_str': '',
        'user': {'id': 1, 'name': 'Vansh'},
        'users': [
          {'id': 1},
          {'id': 2},
        ],
        'not_a_map': 'string_value',
        'not_a_list': 42,
      };
    });

    // safeString
    test('safeString returns string value', () {
      expect(json.safeString('name'), 'Vansh');
    });

    test('safeString converts int to string', () {
      expect(json.safeString('coins'), '25');
    });

    test('safeString converts double to string', () {
      expect(json.safeString('price'), '9.99');
    });

    test('safeString converts bool to string', () {
      expect(json.safeString('active_bool'), 'true');
    });

    test('safeString returns fallback for null', () {
      expect(json.safeString('null_val'), '');
      expect(json.safeString('null_val', fallback: 'N/A'), 'N/A');
    });

    test('safeString returns fallback for missing key', () {
      expect(json.safeString('missing'), '');
    });

    test('safeString returns fallback for empty string', () {
      expect(json.safeString('empty_str', fallback: 'default'), 'default');
    });

    // safeInt
    test('safeInt returns int value', () {
      expect(json.safeInt('coins'), 25);
    });

    test('safeInt parses string int', () {
      expect(json.safeInt('coins_str'), 25);
    });

    test('safeInt converts double to int', () {
      expect(json.safeInt('price'), 9);
    });

    test('safeInt converts true bool to 1', () {
      expect(json.safeInt('active_bool'), 1);
    });

    test('safeInt returns fallback for null', () {
      expect(json.safeInt('null_val'), 0);
      expect(json.safeInt('null_val', fallback: -1), -1);
    });

    test('safeInt returns fallback for missing key', () {
      expect(json.safeInt('missing'), 0);
    });

    test('safeInt returns fallback for non-numeric string', () {
      expect(json.safeInt('name'), 0);
    });

    // safeDouble
    test('safeDouble returns double value', () {
      expect(json.safeDouble('price'), 9.99);
    });

    test('safeDouble parses string double', () {
      expect(json.safeDouble('price_str'), 9.99);
    });

    test('safeDouble converts int to double', () {
      expect(json.safeDouble('coins'), 25.0);
    });

    test('safeDouble returns fallback for null', () {
      expect(json.safeDouble('null_val'), 0.0);
    });

    test('safeDouble returns fallback for non-numeric string', () {
      expect(json.safeDouble('name'), 0.0);
    });

    // safeBool
    test('safeBool returns bool true', () {
      expect(json.safeBool('active_bool'), true);
    });

    test('safeBool converts int 1 to true', () {
      expect(json.safeBool('active_int'), true);
    });

    test('safeBool converts int 0 to false', () {
      expect(json.safeBool('inactive_int'), false);
    });

    test('safeBool converts string "true" to true', () {
      expect(json.safeBool('active_str'), true);
    });

    test('safeBool converts string "false" to false', () {
      expect(json.safeBool('inactive_str'), false);
    });

    test('safeBool returns fallback for null', () {
      expect(json.safeBool('null_val'), false);
    });

    test('safeBool returns fallback for missing key', () {
      expect(json.safeBool('missing'), false);
    });

    // safeMap
    test('safeMap returns map value', () {
      expect(json.safeMap('user'), {'id': 1, 'name': 'Vansh'});
    });

    test('safeMap returns empty map for null', () {
      expect(json.safeMap('null_val'), {});
    });

    test('safeMap returns empty map for missing key', () {
      expect(json.safeMap('missing'), {});
    });

    test('safeMap returns empty map for non-map value', () {
      expect(json.safeMap('not_a_map'), {});
    });

    // safeList
    test('safeList returns list value', () {
      expect(json.safeList('users').length, 2);
    });

    test('safeList returns empty list for null', () {
      expect(json.safeList('null_val'), []);
    });

    test('safeList returns empty list for missing key', () {
      expect(json.safeList('missing'), []);
    });

    test('safeList returns empty list for non-list value', () {
      expect(json.safeList('not_a_list'), []);
    });
  });

  // ---------------------------------------------------------------------------
  // DynamicExtensions
  // ---------------------------------------------------------------------------
  group('DynamicExtensions', () {
    // toSafeInt
    test('toSafeInt on int', () {
      expect((42 as Object?).toSafeInt(), 42);
    });

    test('toSafeInt on double', () {
      expect((3.9 as Object?).toSafeInt(), 3);
    });

    test('toSafeInt on numeric string', () {
      expect(('42' as Object?).toSafeInt(), 42);
    });

    test('toSafeInt on double-represented string parses safely', () {
      expect(('250.75' as Object?).toSafeInt(), 250);
    });

    test('toSafeInt on padded string trims correctly', () {
      expect(('  99  ' as Object?).toSafeInt(), 99);
    });

    test('toSafeInt on bool true', () {
      expect((true as Object?).toSafeInt(), 1);
    });

    test('toSafeInt on null', () {
      expect((null as Object?).toSafeInt(), 0);
    });

    test('toSafeInt on non-numeric string returns fallback', () {
      expect(('abc' as Object?).toSafeInt(fallback: -1), -1);
    });

    // toSafeDouble
    test('toSafeDouble on double', () {
      expect((3.14 as Object?).toSafeDouble(), 3.14);
    });

    test('toSafeDouble on int', () {
      expect((42 as Object?).toSafeDouble(), 42.0);
    });

    test('toSafeDouble on numeric string', () {
      expect(('3.14' as Object?).toSafeDouble(), 3.14);
    });

    test('toSafeDouble on null', () {
      expect((null as Object?).toSafeDouble(), 0.0);
    });

    // toSafeBool
    test('toSafeBool on bool', () {
      expect((true as Object?).toSafeBool(), true);
    });

    test('toSafeBool on int 1', () {
      expect((1 as Object?).toSafeBool(), true);
    });

    test('toSafeBool on int 0', () {
      expect((0 as Object?).toSafeBool(), false);
    });

    test('toSafeBool on string "true"', () {
      expect(('true' as Object?).toSafeBool(), true);
    });

    test('toSafeBool on string "FALSE"', () {
      expect(('FALSE' as Object?).toSafeBool(), false);
    });

    test('toSafeBool on string "1" is true', () {
      expect(('1' as Object?).toSafeBool(), true);
    });

    test('toSafeBool on string "yes" is true', () {
      expect(('yes' as Object?).toSafeBool(), true);
    });

    test('toSafeBool on string "y" is true', () {
      expect(('y' as Object?).toSafeBool(), true);
    });

    test('toSafeBool on string "no" is false', () {
      expect(('no' as Object?).toSafeBool(), false);
    });

    test('toSafeBool on string "n" is false', () {
      expect(('n' as Object?).toSafeBool(), false);
    });

    test('toSafeBool on null', () {
      expect((null as Object?).toSafeBool(), false);
    });

    // toSafeString
    test('toSafeString on string', () {
      expect(('hello' as Object?).toSafeString(), 'hello');
    });

    test('toSafeString on int', () {
      expect((42 as Object?).toSafeString(), '42');
    });

    test('toSafeString on null returns fallback', () {
      expect((null as Object?).toSafeString(fallback: 'N/A'), 'N/A');
    });
  });

  // ---------------------------------------------------------------------------
  // PathExtensions
  // ---------------------------------------------------------------------------
  group('PathExtensions', () {
    late Map<String, dynamic> response;

    setUp(() {
      response = {
        'data': {
          'user': {
            'name': 'Vansh',
            'coins': '25',
            'active': true,
            'profile': {
              'bio': 'Flutter dev',
            },
          },
          'users': [
            {'id': 1, 'name': 'Alice'},
            {'id': 2, 'name': 'Bob'},
          ],
          'price': 9.99,
        },
        'statusCode': 200,
      };
    });

    test('path returns nested value', () {
      expect(response.path('data.user.name'), 'Vansh');
    });

    test('path returns null for missing segment', () {
      expect(response.path('data.user.missing'), null);
    });

    test('path returns null for null root', () {
      expect((null as Object?).path('data.user'), null);
    });

    test('path returns null for invalid deep path', () {
      expect(response.path('data.user.name.deeper'), null);
    });

    test('path accesses list by index', () {
      expect(response.path('data.users.0.name'), 'Alice');
      expect(response.path('data.users.1.name'), 'Bob');
    });

    test('path returns null for out-of-range list index', () {
      expect(response.path('data.users.99.name'), null);
    });

    // pathString
    test('pathString returns nested string', () {
      expect(response.pathString('data.user.name'), 'Vansh');
    });

    test('pathString converts int to string', () {
      expect(response.pathString('statusCode'), '200');
    });

    test('pathString returns fallback for missing', () {
      expect(response.pathString('data.user.missing'), '');
      expect(
        response.pathString('data.user.missing', fallback: 'Unknown'),
        'Unknown',
      );
    });

    // pathImage
    test('pathImage returns single image string', () {
      final map = {
        'avatar': 'https://domain.com/avatar.png',
      };
      expect(map.pathImage('avatar'), 'https://domain.com/avatar.png');
    });

    test('pathImage automatically extracts first item from list', () {
      final map = {
        'gallery': [
          'https://domain.com/img1.png',
          'https://domain.com/img2.png',
        ],
      };
      expect(map.pathImage('gallery'), 'https://domain.com/img1.png');
    });

    test('pathImage returns fallback for empty list', () {
      final map = {
        'gallery': [],
      };
      expect(map.pathImage('gallery', fallback: 'placeholder.png'), 'placeholder.png');
    });

    test('pathImage returns fallback for missing path', () {
      final map = <String, dynamic>{};
      expect(map.pathImage('missing_avatar', fallback: 'placeholder.png'), 'placeholder.png');
    });

    // pathInt
    test('pathInt parses string coin value', () {
      expect(response.pathInt('data.user.coins'), 25);
    });

    test('pathInt returns fallback for missing', () {
      expect(response.pathInt('data.missing'), 0);
    });

    // pathDouble
    test('pathDouble returns double', () {
      expect(response.pathDouble('data.price'), 9.99);
    });

    test('pathDouble returns fallback for missing', () {
      expect(response.pathDouble('data.missing'), 0.0);
    });

    // pathBool
    test('pathBool returns bool', () {
      expect(response.pathBool('data.user.active'), true);
    });

    test('pathBool returns fallback for missing', () {
      expect(response.pathBool('data.missing'), false);
    });

    // pathList
    test('pathList returns list', () {
      expect(response.pathList('data.users').length, 2);
    });

    test('pathList returns empty list for missing', () {
      expect(response.pathList('data.missing'), []);
    });

    // pathMap
    test('pathMap returns nested map', () {
      expect(response.pathMap('data.user.profile'), {'bio': 'Flutter dev'});
    });

    test('pathMap returns empty map for missing', () {
      expect(response.pathMap('data.user.missing'), {});
    });

    // Deep invalid paths — must never throw
    test('invalid path with null in middle never throws', () {
      final nullMiddle = {'a': null};
      expect(() => nullMiddle.pathString('a.b.c'), returnsNormally);
      expect(nullMiddle.pathString('a.b.c'), '');
    });

    test('completely wrong path never throws', () {
      expect(() => response.pathString('x.y.z.w.v'), returnsNormally);
      expect(response.pathString('x.y.z.w.v'), '');
    });
  });

  // ---------------------------------------------------------------------------
  // ListExtensions
  // ---------------------------------------------------------------------------
  group('ListExtensions', () {
    test('safeFirst on non-empty list', () {
      expect([1, 2, 3].safeFirst, 1);
    });

    test('safeFirst on empty list returns null', () {
      expect([].safeFirst, null);
    });

    test('safeLast on non-empty list', () {
      expect([1, 2, 3].safeLast, 3);
    });

    test('safeLast on empty list returns null', () {
      expect([].safeLast, null);
    });

    test('isNullOrEmpty on empty list', () {
      expect([].isNullOrEmpty, true);
    });

    test('isNullOrEmpty on non-empty list', () {
      expect([1].isNullOrEmpty, false);
    });

    test('safeElementAt valid index', () {
      expect([10, 20, 30].safeElementAt(1), 20);
    });

    test('safeElementAt out-of-range returns null', () {
      expect([10, 20, 30].safeElementAt(99), null);
    });

    test('safeElementAt negative index returns null', () {
      expect([10, 20, 30].safeElementAt(-1), null);
    });

    test('safeElementAt on empty list returns null', () {
      expect([].safeElementAt(0), null);
    });
  });

  // ---------------------------------------------------------------------------
  // NullableListExtensions
  // ---------------------------------------------------------------------------
  group('NullableListExtensions', () {
    test('isNullOrEmpty on null', () {
      List<int>? list;
      expect(list.isNullOrEmpty, true);
    });

    test('isNullOrEmpty on empty', () {
      List<int>? list = [];
      expect(list.isNullOrEmpty, true);
    });

    test('isNullOrEmpty on non-empty', () {
      List<int>? list = [1, 2];
      expect(list.isNullOrEmpty, false);
    });

    test('safeFirst on null returns null', () {
      List<int>? list;
      expect(list.safeFirst, null);
    });

    test('safeFirst on non-empty', () {
      List<int>? list = [5, 10];
      expect(list.safeFirst, 5);
    });

    test('safeElementAt on null returns null', () {
      List<int>? list;
      expect(list.safeElementAt(0), null);
    });
  });

  // ---------------------------------------------------------------------------
  // ApiExtensions
  // ---------------------------------------------------------------------------
  group('ApiExtensions', () {
    test('isSuccess true for 200', () {
      expect({'statusCode': 200}.isSuccess, true);
    });

    test('isSuccess true for 201', () {
      expect({'statusCode': 201}.isSuccess, true);
    });

    test('isSuccess true for 299', () {
      expect({'statusCode': 299}.isSuccess, true);
    });

    test('isSuccess false for 400', () {
      expect({'statusCode': 400}.isSuccess, false);
    });

    test('isSuccess false for 500', () {
      expect({'statusCode': 500}.isSuccess, false);
    });

    test('isSuccess false for missing statusCode', () {
      expect(<String, dynamic>{}.isSuccess, false);
    });

    test('statusCodeSafe returns correct code', () {
      expect({'statusCode': 404}.statusCodeSafe, 404);
    });

    test('statusCodeSafe returns 0 for missing', () {
      expect(<String, dynamic>{}.statusCodeSafe, 0);
    });

    test('statusCodeSafe parses string code', () {
      expect({'statusCode': '201'}.statusCodeSafe, 201);
    });

    test('safeData returns data map', () {
      final r = {
        'statusCode': 200,
        'data': {'name': 'Vansh'},
      };
      expect(r.safeData, {'name': 'Vansh'});
    });

    test('safeData returns empty map for missing', () {
      expect({'statusCode': 200}.safeData, {});
    });

    test('safeMessage returns message', () {
      expect({'message': 'Not authorized'}.safeMessage, 'Not authorized');
    });

    test('safeMessage returns empty string for missing', () {
      expect(<String, dynamic>{}.safeMessage, '');
    });
  });

  // ---------------------------------------------------------------------------
  // FFLogger — smoke tests (must not throw in any mode)
  // ---------------------------------------------------------------------------
  group('FFLogger smoke tests', () {
    test('FFLogger.log does not throw on map', () {
      expect(
        () => FFLogger.log({'key': 'value'}, label: 'Test'),
        returnsNormally,
      );
    });

    test('FFLogger.log does not throw on null', () {
      expect(() => FFLogger.log(null), returnsNormally);
    });

    test('FFLogger.warn does not throw', () {
      expect(() => FFLogger.warn('test warning'), returnsNormally);
    });

    test('FFLogger.error does not throw', () {
      expect(
        () => FFLogger.error('test error', Exception('oops')),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // FFPath
  // ---------------------------------------------------------------------------
  group('FFPath tests', () {
    final Map<String, dynamic> data = {
      'user': {
        'name': 'Vansh',
        'age': 25,
        'rating': 4.8,
        'verified': true,
        'photos': ['avatar.png', 'cover.jpg'],
        'details': {'city': 'Surat'},
      }
    };

    test('FFPath.getString resolves nested string', () {
      expect(FFPath.getString(data, 'user.name'), 'Vansh');
      expect(FFPath.getString(data, 'user.missing', fallback: 'Guest'), 'Guest');
    });

    test('FFPath.getInt resolves nested int', () {
      expect(FFPath.getInt(data, 'user.age'), 25);
      expect(FFPath.getInt(data, 'user.missing', fallback: 18), 18);
    });

    test('FFPath.getDouble resolves nested double', () {
      expect(FFPath.getDouble(data, 'user.rating'), 4.8);
      expect(FFPath.getDouble(data, 'user.missing', fallback: 1.0), 1.0);
    });

    test('FFPath.getBool resolves nested bool', () {
      expect(FFPath.getBool(data, 'user.verified'), true);
      expect(FFPath.getBool(data, 'user.missing', fallback: false), false);
    });

    test('FFPath.getImage resolves first item of list or string path', () {
      expect(FFPath.getImage(data, 'user.photos'), 'avatar.png');
      expect(FFPath.getImage(data, 'user.photos.1'), 'cover.jpg');
    });

    test('FFPath.getList resolves nested list', () {
      expect(FFPath.getList(data, 'user.photos'), ['avatar.png', 'cover.jpg']);
      expect(FFPath.getList(data, 'user.missing'), []);
    });

    test('FFPath.getMap resolves nested map', () {
      expect(FFPath.getMap(data, 'user.details'), {'city': 'Surat'});
      expect(FFPath.getMap(data, 'user.missing'), {});
    });
  });
}
