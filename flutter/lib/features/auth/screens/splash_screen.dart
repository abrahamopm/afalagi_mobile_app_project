import 'dart:async';

import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Spacer(),

            CustomImages.appLogo(height: 75),
            const SizedBox(height: 20),
            const Text(
              'Your Real Estate Success, Simplified.',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.inputField,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _navigate() {
    Timer(const Duration(seconds: 3), () {
      if (mounted && GoRouterState.of(context).uri.path == '/') {
        final authState = ref.read(authStateProvider);
        if (authState.value != null) {
          final role = authState.value!.role;
          context.go(role == 'admin' ? '/admin/dashboard' : '/dashboard');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }
}
