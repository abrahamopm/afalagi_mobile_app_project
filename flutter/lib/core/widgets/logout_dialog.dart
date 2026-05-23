import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:afalagi/Core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/Core/widgets/button.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;
    final dialogTheme = Theme.of(context).dialogTheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Logout',
              style: dialogTheme.titleTextStyle?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to log out of your Afalagi agent account?',
              textAlign: TextAlign.center,
              style: dialogTheme.contentTextStyle?.copyWith(fontSize: 14),
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
              color: AppColors.componentLib,
              textColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
