import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/stat_card.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../domain/entities/dashboard_stats.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final authState = ref.watch(authStateProvider);
    final agentName = authState.value?.name ?? 'Agent';

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardStatsProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(agentName),
            const SizedBox(height: 24),
            
            statsAsync.when(
              data: (stats) => _buildStatsCards(context, stats),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'Error: ${error.toString()}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('Quick Actions'),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            
            _buildSectionHeader(
              'Recent Activity',
              onActionTap: () => context.push('/viewings'),
            ),
            const SizedBox(height: 16),

            statsAsync.when(
              data: (stats) => _buildRecentActivityList(context, stats.recentActivity),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Morning, $name',
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

  Widget _buildStatsCards(BuildContext context, DashboardStats stats) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/properties'),
          child: StatCard(
            title: 'Total Properties',
            value: stats.propertyCount.toString(),
            icon: Icons.business_center,
            iconBgColor: AppColors.primary.withValues(alpha: 0.1),
            iconColor: AppColors.primary,
            badgeText: 'VIEW',
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.push('/clients'),
          child: StatCard(
            title: 'Active Clients',
            value: stats.clientCount.toString(),
            icon: Icons.people_outline,
            iconBgColor: AppColors.success.withValues(alpha: 0.1),
            iconColor: AppColors.success,
            badgeText: 'ACTIVE',
            badgeBgColor: AppColors.success.withValues(alpha: 0.1),
            badgeTextColor: AppColors.success,
            showAvatars: true,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.push('/viewings'),
          child: StatCard(
            title: "Today's Viewings",
            value: stats.todayViewingCount.toString(),
            icon: Icons.calendar_today_outlined,
            iconBgColor: AppColors.accent.withValues(alpha: 0.1),
            iconColor: AppColors.accent,
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

  Widget _buildRecentActivityList(BuildContext context, List<DashboardActivity> activities) {
    if (activities.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: const Text(
          'No recent activity to show.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        IconData icon;
        Color color;
        if (activity.type == 'property') {
          icon = Icons.apartment;
          color = AppColors.primary;
        } else if (activity.type == 'client') {
          icon = Icons.person_outline;
          color = AppColors.success;
        } else {
          icon = Icons.calendar_month_outlined;
          color = AppColors.accent;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildActivityTile(
            context,
            activity.title,
            activity.description,
            activity.time,
            icon,
            color.withValues(alpha: 0.1),
            iconColor: color,
            onTap: () {
              if (activity.type == 'property') {
                context.push('/properties');
              } else if (activity.type == 'client') {
                context.push('/clients');
              } else {
                context.push('/viewings');
              }
            },
          ),
        );
      }).toList(),
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
