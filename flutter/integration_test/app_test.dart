import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/auth/screens/splash_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app shows splash screen', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Your Real Estate Success, Simplified.'), findsOneWidget);
  });
}
