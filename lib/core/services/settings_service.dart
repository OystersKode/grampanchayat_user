import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static SettingsService? _instance;
  final SharedPreferences _prefs;

  SettingsService._(this._prefs);

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = SettingsService._(prefs);
  }

  static SettingsService get instance {
    if (_instance == null) {
      throw StateError('SettingsService.initialize() must be called first');
    }
    return _instance!;
  }

  double get fontSize => _prefs.getDouble('font_size') ?? 16.0;
  bool get notificationsEnabled => _prefs.getBool('notifications_enabled') ?? true;
  bool get onboardingComplete => _prefs.getBool('onboarding_complete') ?? false;
  String get languageCode => _prefs.getString('language_code') ?? 'en';
  String get lastReadAnnouncementId => _prefs.getString('last_read_announcement_id') ?? '';

  Locale get locale => Locale(languageCode);

  Future<void> setLastReadAnnouncementId(String id) async {
    await _prefs.setString('last_read_announcement_id', id);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final newCode = languageCode == 'en' ? 'kn' : 'en';
    await _prefs.setString('language_code', newCode);
    notifyListeners();
  }

  void clearCache() {
    // This is a placeholder for any cache clearing logic if needed
    // In our case, the UI will rebuild because of notifyListeners()
    // but the AppRepository also has an in-memory cache that needs clearing
    // to show translated content if it's fetched from Firestore.
    // However, the current AppRepository implementation seems to fetch 
    // data which might not be localized on the server side yet (titles/descs).
  }

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool('onboarding_complete', true);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    await _prefs.setDouble('font_size', size);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
    notifyListeners();
  }
}
