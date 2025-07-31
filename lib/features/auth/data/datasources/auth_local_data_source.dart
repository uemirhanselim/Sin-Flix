import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;
  static const _tokenKey = 'auth_token';

  AuthLocalDataSource(this.storage);

  Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await storage.delete(key: _tokenKey);
  }
} 