import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/afalagi_dialog.dart';
import 'package:afalagi/features/admin/domain/entities/admin_user_summary.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';
import 'package:afalagi/features/admin/widgets/admin_section_header.dart';
import 'package:afalagi/features/admin/widgets/admin_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _roleFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminUserSummary> _filterUsers(List<AdminUserSummary> users) {
    return users.where((u) {
      final matchesSearch = _searchQuery.isEmpty ||
          u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _roleFilter == 'all' || u.role == _roleFilter;
      return matchesSearch && matchesRole;
    }).toList();
  }

  Future<void> _toggleActive(AdminUserSummary user, bool value) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(adminUsersProvider.notifier).setUserActive(user.id, value);
      messenger.showSnackBar(
        SnackBar(content: Text(value ? '${user.name} activated' : '${user.name} deactivated')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showUserDetail(AdminUserSummary user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _UserDetailSheet(
        user: user,
        onVerify: () async {
          Navigator.pop(context);
          try {
            await ref.read(adminUsersProvider.notifier).setUserVerified(user.id, true);
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(content: Text('${user.name} verified')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users by name or email',
              prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _RoleChipFilter(
                label: 'All',
                selected: _roleFilter == 'all',
                onSelected: () => setState(() => _roleFilter = 'all'),
              ),
              _RoleChipFilter(
                label: 'Agents',
                selected: _roleFilter == 'user',
                onSelected: () => setState(() => _roleFilter = 'user'),
              ),
              _RoleChipFilter(
                label: 'Admins',
                selected: _roleFilter == 'admin',
                onSelected: () => setState(() => _roleFilter = 'admin'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: usersAsync.when(
            data: (users) {
              final filtered = _filterUsers(users);
              if (filtered.isEmpty) {
                return const Center(
                  child: Text('No users match your filters.', style: TextStyle(color: Colors.grey)),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(adminUsersProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    return AdminUserTile(
                      user: user,
                      onTap: () => _showUserDetail(user),
                      onActiveChanged: (value) async {
                        if (!value) {
                          final confirmed = await AfalagiDialog.showConfirm(
                            context,
                            title: 'Deactivate User',
                            content: 'Deactivate ${user.name}? They will not be able to sign in.',
                            confirmLabel: 'Deactivate',
                            isDestructive: true,
                          );
                          if (confirmed != true) return;
                        }
                        await _toggleActive(user, value);
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error', style: const TextStyle(color: Colors.red)),
                  TextButton(
                    onPressed: () => ref.read(adminUsersProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleChipFilter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _RoleChipFilter({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : Colors.black87,
          fontWeight: selected ? FontWeight.bold : null,
        ),
      ),
    );
  }
}

class _UserDetailSheet extends StatelessWidget {
  final AdminUserSummary user;
  final VoidCallback onVerify;

  const _UserDetailSheet({required this.user, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(title: 'USER DETAILS'),
          const SizedBox(height: 16),
          Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(user.email, style: const TextStyle(color: AppColors.textGray)),
          const SizedBox(height: 8),
          Text('Role: ${user.role}', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('Agency: ${user.agencyName.isEmpty ? '—' : user.agencyName}'),
          const SizedBox(height: 8),
          Text('Status: ${user.isActive ? 'Active' : 'Inactive'}'),
          Text('Verified: ${user.isVerified ? 'Yes' : 'No'}'),
          if (!user.isVerified) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onVerify,
                child: const Text('Mark as Verified'),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
