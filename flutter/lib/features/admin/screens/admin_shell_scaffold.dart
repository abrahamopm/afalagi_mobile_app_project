import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/image.dart';
import 'package:afalagi/Core/widgets/offline_banner.dart';
import 'package:afalagi/Core/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShellScaffold extends StatelessWidget {
  final Widget child;
  const AdminShellScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/dashboard')) return 0;
    if (location.startsWith('/admin/users')) return 1;
    if (location.startsWith('/admin/properties')) return 2;
    if (location.startsWith('/admin/profile') ||
        location.startsWith('/admin/personal-info') ||
        location.startsWith('/admin/delete-account') ||
        location.startsWith('/admin/tag-management')) {
      return 3;
    }
    return 0;
  }

  String _titleForLocation(String location) {
    if (location.startsWith('/admin/users')) return 'Users';
    if (location.startsWith('/admin/properties')) return 'Properties';
    if (location.startsWith('/admin/profile')) return 'Profile';
    if (location.startsWith('/admin/personal-info')) return 'Personal Info';
    if (location.startsWith('/admin/delete-account')) return 'Delete Account';
    if (location.startsWith('/admin/tag-management')) return 'Tag Management';
    return 'Dashboard';
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
      case 1:
        context.go('/admin/users');
      case 2:
        context.go('/admin/properties');
      case 3:
        context.go('/admin/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final title = _titleForLocation(location);
    final isDashboard = location.startsWith('/admin/dashboard');

    return Scaffold(
      appBar: CustomScaffold.appBar(
        context,
        title: isDashboard
            ? InkWell(
                onTap: () => context.go('/admin/dashboard'),
                child: CustomImages.appLogo(height: 36),
              )
            : Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.primaryColor.withValues(alpha: 0.5),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
