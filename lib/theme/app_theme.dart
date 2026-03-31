import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.header,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.header,
      foregroundColor: Colors.white,
    ),
  );
}
