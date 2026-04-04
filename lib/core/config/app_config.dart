class AppConfig {
  AppConfig._();

  // Override at runtime:
  // flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  // Link for sharing news (e.g. your web portal)
  static const String shareBaseUrl = 'https://kagwad-portal.web.app';

  static String get apiV1BaseUrl => '$apiBaseUrl/api/v1';
}
