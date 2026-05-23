import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  // Use http://10.0.2.2:5000/api/v1 for Android emulator to reference localhost backend
  // Use http://localhost:5000/api/v1 for desktop/web
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/v1';
    }
    return 'http://localhost:5000/api/v1';
  }

  // Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authMe = '/auth/me';

  static const String properties = '/properties';
  static const String clients = '/clients';
  static const String viewings = '/viewings';
  static const String tags = '/tags';
  static const String dashboardStats = '/dashboard/stats';
}
