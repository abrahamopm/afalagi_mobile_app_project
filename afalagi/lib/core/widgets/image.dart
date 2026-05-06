import 'package:flutter/material.dart';

class CustomImages {
  static const String logoImage = 'assets/images/logo.png';
  static Image appLogo({double? width, double? height}) {
    return Image.asset(
      logoImage,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(logoImage);
      },
    );
  }

  static Image reselientImage(String url, {double? width, double? height}) {
    return Image.network(
      url,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(logoImage);
      },
    );
  }
}
