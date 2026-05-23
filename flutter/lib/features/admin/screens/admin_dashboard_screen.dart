import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/button.dart';
import 'package:afalagi/Core/widgets/stat_card.dart';
import 'package:afalagi/features/admin/domain/entities/admin_stats.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';
import 'package:afalagi/features/admin/widgets/admin_activity_tile.dart';
import 'package:afalagi/features/admin/widgets/admin_section_header.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final adminName = ref.watch(authStateProvider).value?.name ?? 'Admin';

    return RefreshIndicator(
      onRefresh: () => ref.read(adminStatsProvider.notifier).refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(adminName),
                const SizedBox(height: 24),
                statsAsync.when(
                  data: (stats) => _buildStatsSection(context, stats, isWide),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => _buildErrorState(context, ref, error.toString()),
                ),
                const SizedBox(height: 32),
                const AdminSectionHeader(title: 'QUICK ACTIONS'),
                const SizedBox(height: 16),
                _buildQuickActions(context, statsAsync.asData?.value),
                const SizedBox(height: 32),
                AdminSectionHeader(
                  title: 'Recent Activity',
                  actionLabel: 'View Users',
                  onActionTap: () => context.go('/admin/users'),
                ),
                const SizedBox(height: 16),
                statsAsync.when(
                  data: (stats) => _buildActivityList(context, stats.recentActivity),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $name',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Platform overview across all agents in Addis Ababa.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, AdminStats stats, bool isWide) {
    final cards = [
      GestureDetector(
        onTap: () => context.go('/admin/users'),
        child: StatCard(
          title: 'Total Users',
          value: stats.userCount.toString(),
          icon: Icons.people_alt_rounded,
          iconBgColor: AppColors.primary.withValues(alpha: 0.1),
          iconColor: AppColors.primary,
          badgeText: stats.pendingUsers > 0 ? '${stats.pendingUsers} PENDING' : null,
          badgeBgColor: AppColors.warning.withValues(alpha: 0.12),
          badgeTextColor: AppColors.warning,
        ),
      ),
      GestureDetector(
        onTap: () => context.go('/admin/properties'),
        child: StatCard(
          title: 'Active Properties',
          value: stats.propertyCount.toString(),
          icon: Icons.apartment_rounded,
          iconBgColor: AppColors.success.withValues(alpha: 0.1),
          iconColor: AppColors.success,
          badgeText: stats.hiddenProperties > 0 ? '${stats.hiddenProperties} HIDDEN' : 'LIVE',
        ),
      ),
      StatCard(
        title: 'Total Viewings',
        value: stats.viewingCount.toString(),
        icon: Icons.calendar_today_rounded,
        iconBgColor: AppColors.accent.withValues(alpha: 0.1),
        iconColor: AppColors.accent,
        badgeText: 'PLATFORM',
      ),
    ];

    if (!isWide) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            cards[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < cards.length - 1 ? 12 : 0),
              child: cards[i],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AdminStats? stats) {
    return Column(
      children: [
        CustomButton(
          text: 'Review Pending Users',
          icon: Icons.verified_user_outlined,
          onPressed: () => context.go('/admin/users'),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Moderate Properties',
          icon: Icons.home_work_outlined,
          color: Colors.white,
          textColor: AppTheme.primaryColor,
          iconColor: AppTheme.primaryColor,
          onPressed: () => context.go('/admin/properties'),
        ),
        if (stats != null && stats.hiddenProperties > 0) ...[
          const SizedBox(height: 12),
          CustomButton(
            text: '${stats.hiddenProperties} Hidden Listings',
            icon: Icons.visibility_off_outlined,
            color: AppColors.warning.withValues(alpha: 0.08),
            textColor: AppColors.warning,
            iconColor: AppColors.warning,
            onPressed: () => context.go('/admin/properties'),
          ),
        ],
      ],
    );
  }

  Widget _buildActivityList(BuildContext context, List<AdminActivity> activities) {
    if (activities.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: const Text(
          'No recent platform activity.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AdminActivityTile(
            activity: activity,
            onTap: () {
              if (activity.type == 'user') {
                context.go('/admin/users');
              } else if (activity.type == 'property') {
                context.go('/admin/properties');
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(adminStatsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
