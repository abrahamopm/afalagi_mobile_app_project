import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:flutter/material.dart';

class AgencyDetailsScreen extends StatelessWidget {
  const AgencyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Agency Details',
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
            // Agency Brand Header
            const Text(
              "Abyssinia Modern",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Figtree',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "License: ET-REA-2024-0812",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),

            // Office Location with Map Placeholder
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  "Office Location",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text("Map Preview Placeholder", 
                            style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: AppTheme.primaryColor),
                            const SizedBox(width: 4),
                            const Text("Bole, Addis Ababa", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bole, Addis Ababa",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  const Text(
                    "Cape Verde St, Michael Bldg",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Statistics Grid
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildStatItem("124", "ACTIVE LISTINGS", color: Colors.white),
                  _buildStatItem("8.2B", "ETB PORTFOLIO", color: Colors.white),
                  _buildStatItem("12", "TOP AGENTS", color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Primary Operation
            _buildInfoSection(
              "Primary Operation",
              [
                "Bole District",
                "CMC",
                "Old Airport"
              ],
              Icons.business_outlined,
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              "Specializing in premium residential estates and high-rise commercial acquisitions across East Addis.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 48),
            CustomButton(
              text: "Contact Agency",
              onPressed: () {
                // TODO: Launch dialer or email
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {Color color = AppColors.primary}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.7), fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 26, bottom: 4),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        )),
      ],
    );
  }
}
