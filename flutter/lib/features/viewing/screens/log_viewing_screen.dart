import 'package:afalagi/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/viewing/domain/entities/viewing_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/viewing_provider.dart';

class LogViewingScreen extends ConsumerStatefulWidget {
  final String? propertyId;
  final String? clientId;
  final ViewingEntity? viewing;

  const LogViewingScreen({
    super.key,
    this.propertyId,
    this.clientId,
    this.viewing,
  });

  @override
  ConsumerState<LogViewingScreen> createState() => _LogViewingScreenState();
}

class _LogViewingScreenState extends ConsumerState<LogViewingScreen> {
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  int _interestScore = 0;
  late String _propertyId;
  late String _clientId;
  late String _propertyTitle;
  late String _clientName;
  late String _imageUrl;
  late String _price;
  late String _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.viewing?.date ?? '');
    _notesController = TextEditingController(text: widget.viewing?.notes ?? '');
    _propertyId = widget.viewing?.propertyId ?? widget.propertyId ?? '';
    _clientId = widget.viewing?.clientId ?? widget.clientId ?? '';
    _propertyTitle =
        widget.viewing?.propertyTitle ?? 'Bole High-Rise Penthouse';
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

  Future<void> _saveViewing() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a date')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.viewing != null) {
        // Update existing
        final updatedViewing = widget.viewing!.copyWith(
          date: _dateController.text.trim(),
          notes: _notesController.text.trim(),
        );
        await ref.read(viewingListProvider.notifier).updateViewing(widget.viewing!.id, updatedViewing);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Viewing log updated')));
        }
      } else {
        // Add new
        final newViewing = ViewingEntity(
          id: '',
          propertyId: _propertyId,
          clientId: _clientId,
          propertyTitle: _propertyTitle,
          clientName: _clientName,
          imageUrl: _imageUrl,
          date: _dateController.text.trim(),
          status: _status,
          price: _price,
          notes: _notesController.text.trim(),
        );
        await ref.read(viewingListProvider.notifier).addViewing(newViewing);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Viewing log saved')));
        }
      }
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.viewing != null ? 'Edit Viewing Log' : 'Log New Viewing',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'Property Information',
                    _propertyTitle,
                    Icons.apartment,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Client Information',
                    _clientName,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'VIEWING DETAILS',
                    style: const TextStyle(
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
                  const SizedBox(height: 32),
                  Text(
                    'INTEREST LEVEL',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      return IconButton(
                        onPressed: () => setState(() => _interestScore = i + 1),
                        icon: Icon(
                          i < _interestScore ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _saveViewing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.viewing != null
                          ? 'Update Viewing Log'
                          : 'Save Viewing Log',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
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
