import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';

class GuestSessionService {
  GuestSessionService(this._apiClient);

  static const String _tokenKey = 'guest_token';
  static const String _deviceIdKey = 'guest_device_id';
  final ApiClient _apiClient;

  Future<String> getOrCreateToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? existingToken = prefs.getString(_tokenKey);
    if (existingToken != null && existingToken.isNotEmpty) {
      return existingToken;
    }

    final String deviceId = prefs.getString(_deviceIdKey) ?? _createDeviceId();
    await prefs.setString(_deviceIdKey, deviceId);

    final Map<String, dynamic> payload = await _apiClient.post(
      '/guest-session',
      body: <String, dynamic>{'device_id': deviceId},
    );
    final Object? token = payload['token'];
    if (token is! String || token.isEmpty) {
      throw Exception('Failed to create guest session token');
    }

    await prefs.setString(_tokenKey, token);
    return token;
  }

  String _createDeviceId() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int randomSuffix = Random().nextInt(999999);
    return 'flutter-$timestamp-$randomSuffix';
  }
}
