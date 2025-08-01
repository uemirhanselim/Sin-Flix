
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');
  if (token != null) {
    print('Token exists in secure storage: $token');
  } else {
    print('No token found in secure storage.');
  }
}
