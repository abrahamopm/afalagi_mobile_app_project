import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/Core/theme/theme.dart';

class FeatureNavigationBar extends StatelessWidget {
  final String currentLocation;

  const FeatureNavigationBar({
    super.key,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildNavItem(context, 'Properties', '/properties', currentLocation.startsWith('/properties') || currentLocation.startsWith('/property-detail')),
            _buildNavItem(context, 'Viewings', '/viewings', currentLocation.startsWith('/viewings')),
            _buildNavItem(context, 'Tags', '/tag-management', currentLocation.startsWith('/tag-management')),
            _buildNavItem(context, 'Profile', '/profile', currentLocation.startsWith('/profile')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route, bool isActive) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Figtree',
            color: isActive ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.6),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
