import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color.fromARGB(255, 3, 23, 40);
  static const Color accentColor = Color(0xFFB8860B);
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
      appBarTheme: const AppBarTheme(elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
