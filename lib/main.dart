import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'core/services/settings_service.dart';
import 'data/repositories/app_repository.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SettingsService.initialize();
  AppRepository.initialize();

  // Handle Anonymous Auth for Guest Users
  final authService = AuthService();
  try {
    if (authService.currentUser == null) {
      await authService.signInGuest();
    }
  } catch (e) {
    debugPrint("Auth initialization skipped or failed: $e");
    // App will continue, features like 'Like' will retry auth or show errors when used.
  }

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
          title: "Kagwad.in",
          theme: AppTheme.lightTheme,
          locale: SettingsService.instance.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('kn'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScaleFactor),
              ),
              child: child!,
            );
          },
          // Show onboarding if not complete, otherwise go to news
          initialRoute: SettingsService.instance.onboardingComplete 
              ? AppRoutes.news 
              : AppRoutes.onboarding,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
