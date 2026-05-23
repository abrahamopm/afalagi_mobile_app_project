import 'package:afalagi/Core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Shared confirmation dialog aligned with design.json Confirmation Dialog.
class AfalagiDialog {
  AfalagiDialog._();

  /// Shows a delete/destructive or neutral confirmation [AlertDialog].
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
    bool isDestructive = true,
    bool compact = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: compact ? AppTheme.compactDialogShape : null,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: isDestructive ? AppColors.danger : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
