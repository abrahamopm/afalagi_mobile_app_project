import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1E3A5F); // VariableID:38:93
  static const Color accent = Color(0xFFC9A962);  // VariableID:67:901
  static const Color secondary = Color(0xFF2B3234); // VariableID:38:242 (Cancel / Dark Charcoal)
  static const Color componentLib = Color(0xFFE6E8EA); // VariableID:38:663

  // Background colors
  static const Color loginBackground = Color(0xFFF4FAFD);
  static const Color signUpBackground = Color(0xFFF7F9FB);
  static const Color scaffoldBackground = Colors.white;

  // Input & surfaces
  static const Color inputBackground = Color(0xFFF2F4F6); // Surface Container Low
  static const Color inputField = Color(0xFFE2E9EC);      // Input
  static const Color border = Color(0xFFC4C6CF);
  static const Color horizontalBorder = Color(0x19C4C6CF);

  // States & Alerts
  static const Color danger = Color(0xFFB40101);
  static const Color success = Color(0xFF3AD365);
  static const Color warning = Color(0xFFEC923F);

  // Text & Labels
  static const Color textDark = Color(0xFF001124);
  static const Color textGray = Color(0xFF6B7280);
}

class AppTheme {
  static const Color primaryColor = AppColors.primary;
  static const Color accentColor = AppColors.accent;

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: MaterialColor(primaryColor.toARGB32(), {
        50: primaryColor.withValues(alpha: 0.1),
        100: primaryColor.withValues(alpha: 0.2),
        200: primaryColor.withValues(alpha: 0.3),
        300: primaryColor.withValues(alpha: 0.4),
        400: primaryColor.withValues(alpha: 0.5),
        500: primaryColor.withValues(alpha: 0.6),
        600: primaryColor.withValues(alpha: 0.7),
        700: primaryColor.withValues(alpha: 0.8),
        800: primaryColor.withValues(alpha: 0.9),
        900: primaryColor.withValues(alpha: 1.0),
      }),
      fontFamily: 'Figtree',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
