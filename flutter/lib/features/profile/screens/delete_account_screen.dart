import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final TextEditingController _confirmController = TextEditingController();
  bool _canDelete = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(() {
      setState(() {
        _canDelete = _confirmController.text.trim().toUpperCase() == 'DELETE';
      });
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);
    try {
      await ref.read(authStateProvider.notifier).deleteAccount();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Figtree',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
                fontFamily: 'Figtree',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "We're sorry to see you go. Please understand that this action is permanent and cannot be undone.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildWarningCard(
              icon: Icons.home_work_outlined,
              title: 'Property Portfolio',
              description:
                  'All your property listings will be permanently removed from the Afalagi ecosystem.',
            ),
            const SizedBox(height: 16),
            _buildWarningCard(
              icon: Icons.people_outline,
              title: 'Leads & Buyers',
              description:
                  'Your entire client database and lead history will be scrubbed from our servers.',
            ),
            const SizedBox(height: 16),
            _buildWarningCard(
              icon: Icons.analytics_outlined,
              title: 'Analytics & Viewings',
              description:
                  'All viewing logs, interest scores, and performance metrics will be lost.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Type DELETE to confirm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              decoration: InputDecoration(
                hintText: 'DELETE',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.danger, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: _isDeleting ? 'Deleting...' : 'Delete My Account',
              color: AppColors.danger,
              onPressed: (_canDelete && !_isDeleting) ? _handleDelete : () {},
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Go back',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.danger, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
