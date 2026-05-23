import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/core/widgets/button.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF25A5A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B385E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to log out of your Afalagi agent account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: isLoading ? 'Logging out...' : 'Log out',
              onPressed: isLoading
                  ? () {}
                  : () async {
                      try {
                        await ref.read(authStateProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.go('/login');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout failed: $e')),
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Cancel',
              onPressed: isLoading ? () {} : () => Navigator.pop(context),
              color: const Color(0xFFE9ECEF),
              textColor: const Color(0xFF495057),
            ),
          ],
        ),
      ),
    );
  }
}
