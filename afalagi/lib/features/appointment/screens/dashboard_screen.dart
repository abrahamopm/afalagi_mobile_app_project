import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(context, 'Properties', Icons.home, '/properties'),
        _buildCard(context, 'Clients', Icons.people, '/clients'),
        _buildCard(context, 'Appointments', Icons.calendar_today, '/appointments'),
        _buildCard(context, 'History', Icons.history, '/viewing-history'),
        _buildCard(context, 'Profile', Icons.person, '/profile'),
        _buildCard(context, 'Settings', Icons.settings, '/settings'),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => context.push(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
