import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final Provider<SecureStorage> secureStorageProvider =
    Provider((ref) => SecureStorage.instance);

class SecureStorage {
  static final SecureStorage instance = SecureStorage._internal();

  factory SecureStorage() {
    return instance;
  }

  SecureStorage._internal();

  static const _storage = FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
