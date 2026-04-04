import 'package:flutter/material.dart';
import 'core/services/settings_service.dart';
import 'data/repositories/app_repository.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.initialize();
  AppRepository.initialize();
  runApp(const GramPanchayatApp());
}

class GramPanchayatApp extends StatelessWidget {
  const GramPanchayatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) {
        final double baseFontSize = SettingsService.instance.fontSize;
        // Calculate a scale factor based on 16.0 being the default
        final double textScaleFactor = baseFontSize / 16.0;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Gram Panchayat Portal",
          theme: AppTheme.lightTheme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScaleFactor),
              ),
              child: child!,
            );
          },
          initialRoute: AppRoutes.news,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
