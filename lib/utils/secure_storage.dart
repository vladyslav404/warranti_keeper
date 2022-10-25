import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _secureStorage = SecureStorage._internal();

  factory SecureStorage() {
    return _secureStorage;
  }

  SecureStorage._internal() {
    _storage = const FlutterSecureStorage();
  }

  late FlutterSecureStorage _storage;

  FlutterSecureStorage get storage => _storage;

  Future write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future delete(String key) async {
    await _storage.delete(key: key);
  }
}
