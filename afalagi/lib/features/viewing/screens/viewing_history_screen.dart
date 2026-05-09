import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/features/viewing/widgets/viewing_cards.dart';
import 'package:flutter/material.dart';

class ViewingHistoryScreen extends StatelessWidget {
  final String? propertyId;
  final String? clientId;

  const ViewingHistoryScreen({super.key, this.propertyId, this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MARKET INSIGHTS',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Activity Log',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (propertyId != null || clientId != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (propertyId != null)
                          _buildFilterChip('Property: $propertyId', Icons.apartment),
                        if (clientId != null) ...[
                          const SizedBox(width: 8),
                          _buildFilterChip('Client: $clientId', Icons.person_outline),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  RecentViewingCard(
                    imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&q=80&w=2071',
                    title: 'Bole High-Rise Penthouse',
                    date: 'Oct 24, 2023 - 10:30 AM',
                    clientName: 'Almaz Abraham',
                    clientInitials: 'AA',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  CompactViewingCard(
                    imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&q=80&w=2070',
                    title: 'CMC Estate Villa 42',
                    clientName: 'Dawit Getachew',
                    price: '12.5M',
                    date: 'OCT 22',
                    status: 'Completed',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  CompactViewingCard(
                    imageUrl: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&q=80&w=2070',
                    title: 'Old Airport Apartment',
                    clientName: 'Sara Tekle',
                    price: '8.2M',
                    date: 'OCT 18',
                    status: 'Second Viewing',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  CompactViewingCard(
                    imageUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=2070',
                    title: 'Kazanchis Office Space',
                    clientName: 'Tewodros Kassahun',
                    price: '15k',
                    date: 'OCT 12',
                    status: 'Cancelled',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
