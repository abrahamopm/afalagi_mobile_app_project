import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/features/viewing/models/viewing_model.dart';
import 'package:afalagi/features/viewing/viewing_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogViewingScreen extends StatefulWidget {
  final String? propertyId;
  final String? clientId;
  final Viewing? viewing;

  const LogViewingScreen({super.key, this.propertyId, this.clientId, this.viewing});

  @override
  State<LogViewingScreen> createState() => _LogViewingScreenState();
}

class _LogViewingScreenState extends State<LogViewingScreen> {
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  late String _propertyId;
  late String _clientId;
  late String _propertyTitle;
  late String _clientName;
  late String _imageUrl;
  late String _price;
  late String _status;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.viewing?.date ?? '');
    _notesController = TextEditingController(text: widget.viewing?.notes ?? '');
    _propertyId = widget.viewing?.propertyId ?? widget.propertyId ?? 'p1';
    _clientId = widget.viewing?.clientId ?? widget.clientId ?? 'c1';
    _propertyTitle = widget.viewing?.propertyTitle ?? 'Bole High-Rise Penthouse';
    _clientName = widget.viewing?.clientName ?? 'Almaz Abraham';
    _imageUrl = widget.viewing?.imageUrl ?? 'assets/images/bole_penthouse.png';
    _price = widget.viewing?.price ?? '18.9M';
    _status = widget.viewing?.status ?? 'Recent';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveViewing() {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a date')),
      );
      return;
    }

    if (widget.viewing != null) {
      // Update existing
      final updatedViewing = widget.viewing!.copyWith(
        date: _dateController.text,
        notes: _notesController.text,
      );
      ViewingService.updateViewing(updatedViewing);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Viewing log updated')),
      );
    } else {
      // Add new
      final newViewing = Viewing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        propertyId: _propertyId,
        clientId: _clientId,
        propertyTitle: _propertyTitle,
        clientName: _clientName,
        imageUrl: _imageUrl,
        date: _dateController.text,
        status: _status,
        price: _price,
        notes: _notesController.text,
      );
      ViewingService.addViewing(newViewing);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Viewing log saved')),
      );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.viewing != null ? 'Edit Viewing Log' : 'Log New Viewing',
          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryColor, size: 20),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Property Information', _propertyTitle, Icons.apartment),
            const SizedBox(height: 16),
            _buildInfoCard('Client Information', _clientName, Icons.person_outline),
            const SizedBox(height: 32),
            Text(
              'VIEWING DETAILS',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _dateController,
              label: 'Date & Time',
              icon: Icons.calendar_today_outlined,
              hint: 'Select date',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              label: 'Notes',
              icon: Icons.notes,
              hint: 'Add some details about the viewing...',
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveViewing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                widget.viewing != null ? 'Update Viewing Log' : 'Save Viewing Log',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
