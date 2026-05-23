import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/features/admin/domain/entities/admin_stats.dart';
import 'package:flutter/material.dart';

class AdminActivityTile extends StatelessWidget {
  final AdminActivity activity;
  final VoidCallback? onTap;

  const AdminActivityTile({super.key, required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (activity.type) {
      case 'user':
        icon = Icons.person_outline;
        color = AppColors.accent;
        break;
      case 'property':
        icon = Icons.apartment;
        color = AppColors.primary;
        break;
      default:
        icon = Icons.calendar_month_outlined;
        color = AppColors.success;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              activity.time.toUpperCase(),
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
