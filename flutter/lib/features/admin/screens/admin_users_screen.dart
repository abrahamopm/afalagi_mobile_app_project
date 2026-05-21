import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/generic_avatar.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textHeading,
                        ),
                      ),
                      const Text(
                        'agent@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: AppColors.success,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
