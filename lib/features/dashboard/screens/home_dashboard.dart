import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/stat_card.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          _buildStatsCards(context),
          const SizedBox(height: 32),
          _buildSectionHeader('Quick Actions'),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Recent Activity',
            onActionTap: () => context.push('/viewing-history'),
          ),
          const SizedBox(height: 16),
          _buildRecentActivityList(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Morning, Dawit',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your portfolio overview for today in Addis Ababa.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/properties'),
          child: StatCard(
            title: 'Total Properties',
            value: '42',
            icon: Icons.business_center,
            iconBgColor: const Color(0xFFE0F2F1),
            iconColor: const Color(0xFF005A6E),
            badgeText: '+12%',
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.push('/clients'),
          child: StatCard(
            title: 'Active Clients',
            value: '128',
            icon: Icons.people_outline,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: AppTheme.primaryColor,
            badgeText: 'ACTIVE',
            badgeBgColor: const Color(0xFFE8F5E9),
            badgeTextColor: Colors.green,
            showAvatars: true,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.push('/viewing-history'),
          child: StatCard(
            title: "Today's Viewings",
            value: '6',
            icon: Icons.calendar_today_outlined,
            iconBgColor: const Color(0xFFFFF9C4),
            iconColor: const Color(0xFFB8860B),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        if (onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Add Property',
          icon: Icons.add_home_outlined,
          onPressed: () => context.push('/add-property'),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Add Client',
          icon: Icons.person_add_outlined,
          color: Colors.white,
          textColor: AppTheme.primaryColor,
          iconColor: AppTheme.primaryColor,
          onPressed: () => context.push('/clients'),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Log Viewing',
          icon: Icons.calendar_today_outlined,
          color: Colors.white,
          textColor: AppTheme.primaryColor,
          iconColor: AppTheme.primaryColor,
          onPressed: () => context.push('/log-viewing'),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Column(
      children: [
        _buildActivityTile(
          context,
          'Koye Feche Penthouse',
          'Listing updated to ETB 12,500,000',
          '3h ago',
          Icons.apartment,
          const Color(0xFFB8860B),
          onTap: () => context.push('/properties'),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          context,
          'Abebe Kebede',
          'Inquired about Bole High-Rise',
          '5h ago',
          Icons.person_outline,
          const Color(0xFFE0F2F1),
          iconColor: const Color(0xFF005A6E),
          onTap: () => context.push('/clients'),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          context,
          'Bole Apartment',
          'New viewing scheduled for 2:00 PM',
          '1d ago',
          Icons.calendar_month_outlined,
          const Color(0xFFE3F2FD),
          iconColor: Colors.blue,
          onTap: () => context.push('/viewing-history'),
        ),
      ],
    );
  }

  Widget _buildActivityTile(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color iconBg, {
    Color iconColor = Colors.white,
    VoidCallback? onTap,
  }) {
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
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  time.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
