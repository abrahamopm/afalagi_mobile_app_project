import 'dart:convert';
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
    if (path.startsWith('data:image') || (!path.startsWith('http') && !path.startsWith('assets/') && path.length > 100)) {
      final base64Str = path.contains(',') ? path.split(',').last : path;
      try {
        final decodedBytes = base64Decode(base64Str);
        return Image.memory(
          decodedBytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(logoImage);
          },
        );
      } catch (_) {
        return Image.asset(
          logoImage,
          width: width,
          height: height,
          fit: fit,
        );
      }
    }

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
