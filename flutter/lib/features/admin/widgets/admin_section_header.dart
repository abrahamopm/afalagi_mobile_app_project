import 'package:afalagi/Core/theme/theme.dart';
import 'package:flutter/material.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const AdminSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: onActionTap != null ? 18 : 12,
            fontWeight: FontWeight.bold,
            color: onActionTap != null ? AppTheme.primaryColor : Colors.grey,
            letterSpacing: onActionTap != null ? 0 : 0.5,
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
