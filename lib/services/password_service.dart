import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';

class PasswordService {
  static const String _passwordFileName = '.printoo_password';
  static const String _defaultPassword = '123';
  static const String _masterPassword = 'Password.printoo.2006';
  static PasswordService? _instance;

  PasswordService._();

  static PasswordService get instance {
    _instance ??= PasswordService._();
    return _instance!;
  }

  String get _passwordFilePath {
    final documentsPath = Platform.environment['USERPROFILE'] ?? '';
    return path.join(documentsPath, 'Documents', _passwordFileName);
  }

  Future<void> initialize() async {
    final file = File(_passwordFilePath);
    if (!await file.exists()) {
      // If no password file exists, create one with default password
      await _savePassword(_defaultPassword);
    }
  }

  Future<void> _savePassword(String password) async {
    final file = File(_passwordFilePath);
    final hashedPassword = _hashPassword(password);
    await file.writeAsString(hashedPassword);
  }

  Future<bool> verifyPassword(String inputPassword) async {
    final file = File(_passwordFilePath);
    if (!await file.exists()) {
      await initialize();
    }

    final storedHash = await file.readAsString();
    final inputHash = _hashPassword(inputPassword);

    // Check if input is master password
    if (inputPassword == _masterPassword) {
      return true;
    }

    return storedHash == inputHash;
  }

  Future<void> changePassword(String newPassword) async {
    await _savePassword(newPassword);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
