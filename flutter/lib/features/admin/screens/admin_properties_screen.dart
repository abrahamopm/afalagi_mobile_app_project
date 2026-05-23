import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/afalagi_dialog.dart';
import 'package:afalagi/features/admin/domain/entities/admin_property_item.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';
import 'package:afalagi/features/admin/widgets/admin_property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPropertiesScreen extends ConsumerStatefulWidget {
  const AdminPropertiesScreen({super.key});

  @override
  ConsumerState<AdminPropertiesScreen> createState() => _AdminPropertiesScreenState();
}

class _AdminPropertiesScreenState extends ConsumerState<AdminPropertiesScreen> {
  String _statusFilter = 'all';

  List<AdminPropertyItem> _filterProperties(List<AdminPropertyItem> items) {
    switch (_statusFilter) {
      case 'active':
        return items.where((p) => p.isAvailable).toList();
      case 'hidden':
        return items.where((p) => !p.isAvailable).toList();
      default:
        return items;
    }
  }

  Future<void> _toggleVisibility(AdminPropertyItem property) async {
    final hide = property.isAvailable;
    if (hide) {
      final confirmed = await AfalagiDialog.showConfirm(
        context,
        title: 'Hide Listing',
        content: 'Hide "${property.title}" from the platform?',
        confirmLabel: 'Hide',
        isDestructive: true,
      );
      if (confirmed != true) return;
    }

    try {
      await ref
          .read(adminPropertiesProvider.notifier)
          .setAvailability(property.id, !hide);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hide ? 'Listing hidden' : 'Listing restored')),
      );
      ref.invalidate(adminStatsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteProperty(AdminPropertyItem property) async {
    final confirmed = await AfalagiDialog.showConfirm(
      context,
      title: 'Delete Property',
      content: 'Permanently delete "${property.title}"? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed != true) return;

    try {
      await ref.read(adminPropertiesProvider.notifier).deleteProperty(property.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Property deleted')));
      ref.invalidate(adminStatsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(adminPropertiesProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _StatusChip(
                label: 'All',
                selected: _statusFilter == 'all',
                onSelected: () => setState(() => _statusFilter = 'all'),
              ),
              _StatusChip(
                label: 'Active',
                selected: _statusFilter == 'active',
                onSelected: () => setState(() => _statusFilter = 'active'),
              ),
              _StatusChip(
                label: 'Hidden',
                selected: _statusFilter == 'hidden',
                onSelected: () => setState(() => _statusFilter = 'hidden'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: propertiesAsync.when(
            data: (properties) {
              final filtered = _filterProperties(properties);
              if (filtered.isEmpty) {
                return const Center(
                  child: Text('No properties in this view.', style: TextStyle(color: Colors.grey)),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(adminPropertiesProvider.notifier).refresh(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    if (isWide) {
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildCard(filtered[index]),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildCard(filtered[index]),
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
                    onPressed: () => ref.read(adminPropertiesProvider.notifier).refresh(),
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

  Widget _buildCard(AdminPropertyItem property) {
    return AdminPropertyCard(
      property: property,
      onToggleVisibility: () => _toggleVisibility(property),
      onDelete: () => _deleteProperty(property),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _StatusChip({
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
