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
                color: Color(0xFF1B385E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "License: ET-REA-2024-0812",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),

            // Statistics Grid
            Row(
              children: [
                _buildStatItem("124", "ACTIVE LISTINGS"),
                _buildStatItem("8.2B", "ETB PORTFOLIO"),
                _buildStatItem("12", "TOP AGENTS"),
              ],
            ),
            const SizedBox(height: 40),

            // Office Location
            _buildInfoSection(
              "Office Location",
              [
                "Bole, Addis Ababa",
                "Cape Verde St, Michael Bldg"
              ],
              Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),

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

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B385E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
              color: Color(0xFF1B385E),
            ),
          ),
        )),
      ],
    );
  }
}
