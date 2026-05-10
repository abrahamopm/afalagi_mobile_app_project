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

  static Image resilientImage(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(logoImage);
        },
      );
    }
    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(logoImage);
      },
    );
  }
}
