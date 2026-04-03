import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.defaultHeaders = const <String, String>{},
  });

  final String baseUrl;
  final Map<String, String> defaultHeaders;

  Future<Map<String, dynamic>> get(
    String path, {
    String? bearerToken,
    Map<String, String>? query,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final http.Response response = await http.get(
      uri,
      headers: _headers(bearerToken),
    );
    return _parseJson(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? bearerToken,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$path');
    final http.Response response = await http.post(
      uri,
      headers: _headers(bearerToken),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _parseJson(response);
  }

  Map<String, String> _headers(String? bearerToken) {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      ...defaultHeaders,
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    return headers;
  }

  Map<String, dynamic> _parseJson(http.Response response) {
    Map<String, dynamic> payload = <String, dynamic>{};
    if (response.body.isNotEmpty) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    final Object? message = payload['message'];
    throw Exception(
      'HTTP ${response.statusCode}: ${message is String ? message : 'Request failed'}',
    );
  }
}
