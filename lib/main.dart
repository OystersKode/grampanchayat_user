import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GramPanchayatApp());
}

class GramPanchayatApp extends StatelessWidget {
  const GramPanchayatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed MultiProvider with empty providers list to fix the 'children.isNotEmpty' assertion error.
    // You can re-add it once you have actual Providers/ViewModels to inject.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gram Panchayat Portal",
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.signup,
      routes: AppRoutes.routes,
    );
  }
}
