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
          _buildStatsCards(),
          const SizedBox(height: 32),
          _buildSectionHeader('Quick Actions'),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildSectionHeader('Recent Activity', onActionTap: () => context.push('/viewing-history')),
          const SizedBox(height: 16),
          _buildRecentActivityList(),
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Column(
      children: [
        StatCard(
          title: 'Total Properties',
          value: '42',
          icon: Icons.business_center,
          iconBgColor: Color(0xFFE0F2F1),
          iconColor: Color(0xFF005A6E),
          badgeText: '+12%',
        ),
        const SizedBox(height: 16),
        StatCard(
          title: 'Active Clients',
          value: '128',
          icon: Icons.people_outline,
          iconBgColor: Color(0xFFF3F4F6),
          iconColor: AppTheme.primaryColor,
          badgeText: 'ACTIVE',
          badgeBgColor: Color(0xFFE8F5E9),
          badgeTextColor: Colors.green,
          showAvatars: true,
        ),
        const SizedBox(height: 16),
        StatCard(
          title: "Today's Viewings",
          value: '6',
          icon: Icons.calendar_today_outlined,
          iconBgColor: Color(0xFFFFF9C4),
          iconColor: Color(0xFFB8860B),
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

  Widget _buildRecentActivityList() {
    return Column(
      children: [
        _buildActivityTile(
          'Koye Feche Penthouse',
          'Listing updated to ETB 12,500,000',
          '3h ago',
          Icons.apartment,
          const Color(0xFFB8860B),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          'Abebe Kebede',
          'Inquired about Bole High-Rise',
          '5h ago',
          Icons.person_outline,
          const Color(0xFFE0F2F1),
          iconColor: const Color(0xFF005A6E),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          'Bole Apartment',
          'New viewing scheduled for 2:00 PM',
          '1d ago',
          Icons.calendar_month_outlined,
          const Color(0xFFE3F2FD),
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildActivityTile(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color iconBg, {
    Color iconColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
