import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:afalagi/features/auth/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('SplashScreen displays app logo and tagline', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
        GoRoute(path: '/login', builder: (c, s) => const SizedBox()),
        GoRoute(path: '/dashboard', builder: (c, s) => const SizedBox()),
        GoRoute(path: '/admin/dashboard', builder: (c, s) => const SizedBox()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    // Allow timers in the splash screen to run and avoid pending timer errors
    await tester.pump(const Duration(seconds: 4));

    expect(find.text('Your Real Estate Success, Simplified.'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
