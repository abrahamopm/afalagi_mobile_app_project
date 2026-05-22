import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AfalagiApp(),
    ),
  );
}

class AfalagiApp extends StatelessWidget {
  const AfalagiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Afalagi Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
