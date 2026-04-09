import 'package:flutter/material.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _fontSize;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _fontSize = SettingsService.instance.fontSize;
    _notificationsEnabled = SettingsService.instance.notificationsEnabled;
  }

  Future<void> _saveSettings() async {
    await SettingsService.instance.setFontSize(_fontSize);
    await SettingsService.instance.setNotificationsEnabled(_notificationsEnabled);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('settings_updated'.tr(context)),
          backgroundColor: const Color(0xFF5E0006),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'settings'.tr(context),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'accessibility'.tr(context),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Color(0xFF8A7171),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'font_size'.tr(context),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF370002),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('A', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        Text('A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _fontSize,
                      min: 14,
                      max: 24,
                      divisions: 5,
                      activeColor: const Color(0xFF5E0006),
                      inactiveColor: const Color(0xFFDEC0BC),
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8EF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDEC0BC)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'preview'.tr(context),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xFF8A7171),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'preview_text'.tr(context),
                            style: TextStyle(
                              fontSize: _fontSize,
                              color: const Color(0xFF370002),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'alerts'.tr(context),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Color(0xFF8A7171),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'notifications'.tr(context),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF370002),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          activeColor: const Color(0xFF5E0006),
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text('save_changes'.tr(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E0006),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'App Version 1.0.0',
                style: TextStyle(color: Color(0xFF8A7171), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
