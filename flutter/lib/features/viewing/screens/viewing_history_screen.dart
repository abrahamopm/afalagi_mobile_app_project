import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/features/viewing/models/viewing_model.dart';
import 'package:afalagi/features/viewing/viewing_service.dart';
import 'package:afalagi/features/viewing/widgets/viewing_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewingHistoryScreen extends StatefulWidget {
  final String? propertyId;
  final String? clientId;

  const ViewingHistoryScreen({super.key, this.propertyId, this.clientId});

  @override
  State<ViewingHistoryScreen> createState() => _ViewingHistoryScreenState();
}

class _ViewingHistoryScreenState extends State<ViewingHistoryScreen> {
  late List<Viewing> _viewings;

  @override
  void initState() {
    super.initState();
    _loadViewings();
  }

  void _loadViewings() {
    _viewings = ViewingService.getViewings();
    if (widget.propertyId != null) {
      _viewings = _viewings.where((v) => v.propertyId == widget.propertyId).toList();
    }
    if (widget.clientId != null) {
      _viewings = _viewings.where((v) => v.clientId == widget.clientId).toList();
    }
  }

  Future<void> _deleteViewing(String id) async {
    final confirmed = await _showPlatformConfirmation(
      title: 'Delete Viewing',
      content: 'Are you sure you want to delete this viewing log?',
    );

    if (confirmed == true) {
      setState(() {
        ViewingService.deleteViewing(id);
        _loadViewings();
      });
    }
  }

  Future<bool?> _showPlatformConfirmation({required String title, required String content}) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editViewing(Viewing viewing) {
    context.push('/log-viewing', extra: viewing).then((_) {
      setState(() {
        _loadViewings();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Viewings',
          style: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
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
                color: Color(0xFF1B385E),
              ),
            ),
            const SizedBox(height: 32),

            if (_viewings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text("No viewing activity found."),
                ),
              )
            else
              _buildBentoGrid(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoGrid() {
    // Featured Item (Recent)
    final featured = _viewings.first;
    final others = _viewings.skip(1).toList();

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
