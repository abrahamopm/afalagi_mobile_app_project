import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1E3A5F); // VariableID:38:93
  static const Color accent = Color(0xFFC9A962); // VariableID:67:901
  static const Color secondary = Color(0xFF2B3234); // VariableID:38:242 (Cancel / Dark Charcoal)
  static const Color componentLib = Color(0xFFE6E8EA); // VariableID:38:663

  // Background colors
  static const Color loginBackground = Color(0xFFF4FAFD);
  static const Color signUpBackground = Color(0xFFF7F9FB);
  static const Color scaffoldBackground = Colors.white;

  // Input & surfaces
  static const Color inputBackground = Color(0xFFF2F4F6); // Surface Container Low
  static const Color inputField = Color(0xFFE2E9EC); // Input
  static const Color border = Color(0xFFC4C6CF);
  static const Color horizontalBorder = Color(0x19C4C6CF);

  // States & Alerts
  static const Color danger = Color(0xFFB40101);
  static const Color success = Color(0xFF3AD365);
  static const Color warning = Color(0xFFEC923F);

  // Text & Labels
  static const Color textDark = Color(0xFF001124); // Form labels
  static const Color textGray = Color(0xFF6B7280); // Placeholders
  static const Color textHeading = Color(0xFF191C1D); // Confirmation Dialog title
  static const Color textBody = Color(0xFF3F484C); // Confirmation Dialog body
}

class AppTheme {
  static const Color primaryColor = AppColors.primary;
  static const Color accentColor = AppColors.accent;

  static const double _dialogRadius = 30;
  static const double _compactDialogRadius = 20;
  static const double _bottomSheetRadius = 20;
  static const double _buttonRadius = 100;

  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    surface: AppColors.scaffoldBackground,
    onSurface: AppColors.textHeading,
    onSurfaceVariant: AppColors.textBody,
    error: AppColors.danger,
    onError: Colors.white,
    outline: AppColors.border,
    surfaceContainerHighest: AppColors.inputBackground,
    surfaceContainerHigh: AppColors.inputField,
  );

  static ThemeData get lightTheme {
    final colorScheme = _lightColorScheme;

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: 'Figtree',
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.primary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.scaffoldBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGray,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.scaffoldBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_dialogRadius),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Figtree',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textHeading,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Figtree',
          fontSize: 16,
          height: 1.5,
          color: AppColors.textBody,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondary,
        contentTextStyle: const TextStyle(
          fontFamily: 'Figtree',
          fontSize: 14,
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.all(16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.scaffoldBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_bottomSheetRadius),
          ),
        ),
      ),
    );
  }

  /// Compact radius for form-style alert dialogs (e.g. tag create).
  static RoundedRectangleBorder get compactDialogShape =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_compactDialogRadius),
      );
}
