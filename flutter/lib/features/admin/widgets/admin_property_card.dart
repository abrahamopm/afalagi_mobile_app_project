import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/image.dart';
import 'package:afalagi/features/admin/domain/entities/admin_property_item.dart';
import 'package:flutter/material.dart';

class AdminPropertyCard extends StatelessWidget {
  final AdminPropertyItem property;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onDelete;

  const AdminPropertyCard({
    super.key,
    required this.property,
    this.onToggleVisibility,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomImages.resilientImage(
                property.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: property.isAvailable
                        ? AppColors.success.withValues(alpha: 0.9)
                        : AppColors.danger.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    property.isAvailable ? 'ACTIVE' : 'HIDDEN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (onDelete != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.textGray),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.agentName,
                        style: const TextStyle(fontSize: 13, color: AppColors.textGray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGray),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.location,
                        style: const TextStyle(fontSize: 13, color: AppColors.textGray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ETB ${property.formattedPrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    if (onToggleVisibility != null)
                      TextButton.icon(
                        onPressed: onToggleVisibility,
                        icon: Icon(
                          property.isAvailable ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 18,
                        ),
                        label: Text(property.isAvailable ? 'Hide' : 'Show'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
