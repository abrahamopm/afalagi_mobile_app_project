import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/main.dart';
import 'package:afalagi/features/auth/screens/splash_screen.dart';
import 'package:afalagi/features/auth/screens/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app flow: splash screen redirects to login screen', (tester) async {
    // 1. Pump the real application widget
    await tester.pumpWidget(
      const ProviderScope(
        child: AfalagiApp(),
      ),
    );

    // 2. Verify that splash screen is shown initially
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Your Real Estate Success, Simplified.'), findsOneWidget);

    // 3. Wait for the splash screen's timer (3 seconds) and transitions to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // 4. Verify that the app automatically redirects to the login screen
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
