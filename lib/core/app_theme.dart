import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 64, 157, 250); // azul bajito
  static const Color secondary = Color(0xFFF7B84F); // naranja suave complementario
  static const Color background = Color(0xFFF5F5F5);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      useMaterial3: true,
    );
  }
}
