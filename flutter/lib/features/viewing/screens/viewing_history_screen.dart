import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/features/viewing/domain/entities/viewing_entity.dart';
import 'package:afalagi/features/viewing/widgets/viewing_cards.dart';
import 'package:afalagi/Core/widgets/afalagi_dialog.dart';
import 'package:go_router/go_router.dart';
import '../providers/viewing_provider.dart';

class ViewingHistoryScreen extends ConsumerStatefulWidget {
  final String? propertyId;
  final String? clientId;

  const ViewingHistoryScreen({super.key, this.propertyId, this.clientId});

  @override
  ConsumerState<ViewingHistoryScreen> createState() => _ViewingHistoryScreenState();
}

class _ViewingHistoryScreenState extends ConsumerState<ViewingHistoryScreen> {

  Future<void> _deleteViewing(String id) async {
    final confirmed = await _showPlatformConfirmation(
      title: 'Delete Viewing',
      content: 'Are you sure you want to delete this viewing log?',
    );

    if (confirmed == true) {
      try {
        await ref.read(viewingListProvider.notifier).deleteViewing(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing log deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<bool?> _showPlatformConfirmation({required String title, required String content}) {
    return AfalagiDialog.showConfirm(
      context,
      title: title,
      content: content,
    );
  }

  void _editViewing(ViewingEntity viewing) {
    context.push('/log-viewing', extra: viewing);
  }

  @override
  Widget build(BuildContext context) {
    final viewingsAsync = ref.watch(viewingListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.read(viewingListProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MARKET INSIGHTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Activity Log',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Figtree',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              viewingsAsync.when(
                data: (viewings) {
                  var filtered = viewings;
                  if (widget.propertyId != null) {
                    filtered = filtered.where((v) => v.propertyId == widget.propertyId).toList();
                  }
                  if (widget.clientId != null) {
                    filtered = filtered.where((v) => v.clientId == widget.clientId).toList();
                  }

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text(
                          "No viewing activity found.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return _buildBentoGrid(filtered);
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoGrid(List<ViewingEntity> viewings) {
    // Featured Item (Recent)
    final featured = viewings.first;
    final others = viewings.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        
        // Large Featured Card
        RecentViewingCard(
          imageUrl: featured.imageUrl,
          title: featured.propertyTitle,
          date: featured.date,
          clientName: featured.clientName,
          clientInitials: _getInitials(featured.clientName),
          onEdit: () => _editViewing(featured),
          onDelete: () => _deleteViewing(featured.id),
        ),

        if (others.isNotEmpty) ...[
          const SizedBox(height: 32),
          const Text(
            'HISTORY',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),

          // Bento Style List/Grid
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: others.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final viewing = others[index];
              return CompactViewingCard(
                imageUrl: viewing.imageUrl,
                title: viewing.propertyTitle,
                clientName: viewing.clientName,
                price: viewing.price,
                date: viewing.date,
                status: viewing.status,
                onEdit: () => _editViewing(viewing),
                onDelete: () => _deleteViewing(viewing.id),
              );
            },
          ),
        ],
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "??";
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
