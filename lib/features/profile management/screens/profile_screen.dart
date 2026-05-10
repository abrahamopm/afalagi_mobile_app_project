import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/image.dart';
import 'package:afalagi/core/widgets/logout_dialog.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        children: [

              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CustomImages.resilientImage(
                        'assets/images/agent_profile.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B385E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name and Badge
              Text(
                'Dawit Gebremedhin',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'VERIFIED AGENT',
                  style: TextStyle(color: Color(0xFF065F46), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard('Managed', '24', 'units')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Closings', '128', 'total')),
                ],
              ),
              const SizedBox(height: 16),

              // Rating Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Average Rating', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const [
                            Text('4.9', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                            Text(' / 5.0', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.white, size: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Account Settings List
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'ACCOUNT SETTINGS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(Icons.person_outline, 'Personal Information', false, () {
                context.push('/personal-info');
              }),
              _buildMenuItem(Icons.business_outlined, 'Agency Details', false, () {
                context.push('/agency-details');
              }),
              _buildMenuItem(Icons.label_outline, 'Tag Management', false, () {
                context.push('/tag-management');
              }),
              _buildMenuItem(Icons.history_outlined, 'Viewing History', false, () {
                context.push('/viewing-history');
              }),
              _buildMenuItem(Icons.help_outline, 'Help & Support', false, () {}),
              _buildMenuItem(Icons.delete_outline, 'Delete Account', true, () {
                context.push('/delete-account');
              }),
              const SizedBox(height: 32),

              // Logout Button
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LogoutDialog(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: Color(0xFFE53E3E), size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Logout Account',
                        style: TextStyle(color: Color(0xFFE53E3E), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor)),
              const SizedBox(width: 4),
              Text(unit,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, bool isDestructive, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: isDestructive
                  ? const Color(0xFFE53E3E)
                  : const Color(0xFF1B385E),
              size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDestructive
                ? const Color(0xFFE53E3E)
                : const Color(0xFF1B385E),
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            color: isDestructive ? const Color(0xFFE53E3E) : Colors.grey,
            size: 20),
        onTap: onTap,
      ),
    );
  }
}

