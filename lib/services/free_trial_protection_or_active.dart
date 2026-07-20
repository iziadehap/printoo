import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:path_provider/path_provider.dart';


class LicenseHelper {
  static const String secretKey = 'Password.Printoo.2006';
  static const String licenseFileName = 'license.json';
  static const int freeDays = 3;

  static bool isFirstTime = true;

  // ✅ تشفير الحقول
  static String encryptField(String data) {
    final key = utf8.encode(secretKey);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    final encoded = base64Url.encode([...bytes, ...digest.bytes.take(4)]);
    return encoded;
  }

  // ✅ فك التشفير والتحقق
  static String decryptField(String encoded) {
    try {
      final allBytes = base64Url.decode(encoded);
      final dataBytes = allBytes.sublist(0, allBytes.length - 4);
      final hashBytes = allBytes.sublist(allBytes.length - 4);

      final key = utf8.encode(secretKey);
      final hmac = Hmac(sha256, key);
      final expectedHash = hmac.convert(dataBytes).bytes.take(4);

      if (!ListEquality().equals(expectedHash.toList(), hashBytes)) {
        throw Exception("Invalid HMAC signature");
      }

      return utf8.decode(dataBytes);
    } catch (_) {
      return '';
    }
  }

  // تعديل هنا: id لازم يكون 10 حروف فقط
  static Future<String> _getCpuId() async {
    try {
      final result = await Process.run('wmic', [
        'cpu',
        'get',
        'ProcessorId',
      ], runInShell: true);

      final lines = result.stdout.toString().split('\n');
      if (lines.length > 1) {
        final rawId = lines[1].trim().toUpperCase();
        // لو أطول من 10 ناخد أول 10، لو أقل نعبي بـ 0
        return rawId.length >= 10
            ? rawId.substring(0, 10)
            : rawId.padRight(10, '0');
      } else {
        throw Exception("Failed to read CPU ID");
      }
    } catch (e) {
      print("❌ Error getting CPU ID: $e");
      return "UNKNOWNCPU".padRight(10, '0'); // 10 حروف
    }
  }

  // static Future<String> _getAppDataPath() async {
  //   final directory = Directory.current;
  //   return directory.path;
  // }

static Future<String> _getAppDataPath() async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}


  static Future<File> _getLicenseFile() async {
    final path = await _getAppDataPath();
    print('path: $path/$licenseFileName');
    return File('$path/$licenseFileName');
  }

  static Future<bool> _checkSameId(String id) async {
    final idFromCpu = await _getCpuId();
    if (id != idFromCpu) {
      final file = await _getLicenseFile();
      await file.delete();
      // Create new license file immediately after deletion
      final newId = await _getCpuId();
      final createdAt = encryptField(DateTime.now().toIso8601String());
      final isActivated = encryptField("false");

      final license = {
        'id': newId,
        'createdAt': createdAt,
        'isActivated': isActivated,
      };

      try {
        await file.writeAsString(jsonEncode(license));
        isFirstTime = true; // Set first time to true for new file
        Get.snackbar(
          'تنبيه',
          'تم إنشاء ملف ترخيص جديد',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } catch (e) {
        print("❌ Error creating new license file: $e");
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إنشاء ملف الترخيص',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return false;
    }
    return true;
  }

  static Future<Map<String, dynamic>?> _loadLicenseData() async {
    try {
      final file = await _getLicenseFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final isSameId = await _checkSameId(jsonDecode(content)['id']);
        if (!isSameId) {
          // If ID check failed, read the newly created file
          if (await file.exists()) {
            final newContent = await file.readAsString();
            return jsonDecode(newContent);
          }
          return null;
        }
        isFirstTime = false;
        return jsonDecode(content);
      } else {
        // Create new license file with default values
        isFirstTime = true;
        final id = await _getCpuId();
        final createdAt = encryptField(DateTime.now().toIso8601String());
        final isActivated = encryptField("false");

        final license = {
          'id': id,
          'createdAt': createdAt,
          'isActivated': isActivated,
        };

        try {
          await file.writeAsString(jsonEncode(license));
          return license;
        } catch (e) {
          print("❌ Error creating license file: $e");
          Get.snackbar(
            'Error',
            'Error creating license file',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return license;
        }
      }
    } catch (e) {
      print("❌ Error loading license data: $e");
      Get.snackbar(
        'Error',
        'Error loading license data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  static bool checkFirstTime() {
    return isFirstTime;
  }

  static String _generateShortActivationCode(String id) {
    final raw = id.toUpperCase() + secretKey;
    final hash = sha256.convert(utf8.encode(raw)).bytes; // bytes مش hex
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final codeLength = 10;

    // نحول أول 10 bytes من الـ hash لأحرف وأرقام فقط
    String code = '';
    for (int i = 0; i < codeLength; i++) {
      code += chars[hash[i] % chars.length];
    }
    return code;
  }

  static Future<int> checkFreeTrialStatus() async {
    final data = await _loadLicenseData();
    if (data == null) return 0;
    final decryptedDate = decryptField(data['createdAt']);
    // if (decryptedDate.isEmpty) return 0;

    final createdAt = DateTime.parse(decryptedDate);
    final daysPassed = DateTime.now().difference(createdAt).inDays;

    final isActive = decryptField(data['isActivated']) == 'true';

    if (isActive) return 999;
    if (daysPassed >= freeDays) return 0;
    return freeDays - daysPassed;
  }

  static Future<bool> verifyActivationCode(String code) async {
    final data = await _loadLicenseData();
    if (data == null) return false;
    final id = data['id'];
    final expected = _generateShortActivationCode(id);
    // print('expected: $expected');

    final isValid =
        code.toUpperCase() == expected || code == secretKey.toUpperCase();

    if (isValid) {
      final file = await _getLicenseFile();
      data['isActivated'] = encryptField("true");
      await file.writeAsString(jsonEncode(data));
      // isFirstTime = false;
    }

    return isValid;
  }

  static Future<String> getId() async {
    final data = await _loadLicenseData();
    if (data == null) return '';
    return data['id'].toUpperCase();
  }

  static Future<bool> isActivated() async {
    final data = await _loadLicenseData();
    if (data == null) return false;
    return decryptField(data['isActivated']) == 'true';
  }

  static Future<void> deactivateLicense() async {
    final file = await _getLicenseFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      data['isActivated'] = encryptField("false");
      await file.writeAsString(jsonEncode(data));
    }
  }
}

// للمقارنة بين الـ List<byte>
class ListEquality {
  const ListEquality();

  bool equals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
