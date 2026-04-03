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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gram Panchayat Portal",
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.news,
      routes: AppRoutes.routes,
    );
  }
}
