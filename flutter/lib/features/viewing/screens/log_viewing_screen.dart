import 'package:afalagi/core/theme/Theme.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/providers/client_provider.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/providers/property_provider.dart';
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
  String? _selectedPropertyId;
  String? _selectedClientId;
  bool _isLoading = false;

  bool get _isEditing => widget.viewing != null;
  bool get _needsPropertyPicker =>
      !_isEditing && (widget.propertyId == null || widget.propertyId!.isEmpty);
  bool get _needsClientPicker =>
      !_isEditing && (widget.clientId == null || widget.clientId!.isEmpty);

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.viewing?.date ?? '');
    _notesController = TextEditingController(text: widget.viewing?.notes ?? '');
    _interestScore = widget.viewing?.interestScore ?? 0;
    _selectedPropertyId = widget.viewing?.propertyId;
    if (_selectedPropertyId == null &&
        widget.propertyId != null &&
        widget.propertyId!.isNotEmpty) {
      _selectedPropertyId = widget.propertyId;
    }
    _selectedClientId = widget.viewing?.clientId;
    if (_selectedClientId == null &&
        widget.clientId != null &&
        widget.clientId!.isNotEmpty) {
      _selectedClientId = widget.clientId;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  PropertyEntity? _findProperty(List<PropertyEntity> properties, String? id) {
    if (id == null || id.isEmpty) return null;
    for (final p in properties) {
      if (p.id == id) return p;
    }
    return null;
  }

  ClientEntity? _findClient(List<ClientEntity> clients, String? id) {
    if (id == null || id.isEmpty) return null;
    for (final c in clients) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> _saveViewing() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a date')),
      );
      return;
    }

    final propertyId = _isEditing
        ? widget.viewing!.propertyId
        : _selectedPropertyId;
    final clientId =
        _isEditing ? widget.viewing!.clientId : _selectedClientId;

    if (propertyId == null ||
        propertyId.isEmpty ||
        clientId == null ||
        clientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both a property and a client'),
        ),
      );
      return;
    }

    if (_interestScore < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set an interest level (1–5 stars)')),
      );
      return;
    }

    final properties = ref.read(propertyListProvider).value ?? [];
    final clients = ref.read(clientListProvider).value ?? [];
    final property = _findProperty(properties, propertyId);
    final client = _findClient(clients, clientId);

    if (property == null || client == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid property or client selection')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        final updatedViewing = widget.viewing!.copyWith(
          date: _dateController.text.trim(),
          notes: _notesController.text.trim(),
          interestScore: _interestScore,
        );
        await ref
            .read(viewingListProvider.notifier)
            .updateViewing(widget.viewing!.id, updatedViewing);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing log updated')),
          );
        }
      } else {
        final newViewing = ViewingEntity(
          id: '',
          propertyId: property.id,
          clientId: client.id,
          propertyTitle: property.title,
          clientName: client.name,
          imageUrl: property.imageUrl,
          date: _dateController.text.trim(),
          status: 'Recent',
          price: property.formattedPrice,
          notes: _notesController.text.trim(),
          interestScore: _interestScore,
        );
        await ref.read(viewingListProvider.notifier).addViewing(newViewing);

        await ref.read(clientListProvider.notifier).updateClient(
              client.id,
              client.copyWith(interest: _interestScore),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing log saved')),
          );
        }
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertyListProvider);
    final clientsAsync = ref.watch(clientListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Viewing Log' : 'Log New Viewing',
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
      body: propertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading properties: $e')),
        data: (properties) => clientsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading clients: $e')),
          data: (clients) {
            final property = _isEditing
                ? PropertyEntity(
                    id: widget.viewing!.propertyId,
                    title: widget.viewing!.propertyTitle,
                    description: '',
                    location: '',
                    imageUrl: widget.viewing!.imageUrl,
                    price: 0,
                    beds: 0,
                    baths: 0,
                    sqft: 0,
                  )
                : _findProperty(properties, _selectedPropertyId);
            final client = _isEditing
                ? ClientEntity(
                    id: widget.viewing!.clientId,
                    name: widget.viewing!.clientName,
                    phone: '',
                  )
                : _findClient(clients, _selectedClientId);

            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_needsPropertyPicker) ...[
                          _buildPickerLabel('SELECT PROPERTY'),
                          _buildPropertyDropdown(properties),
                          const SizedBox(height: 16),
                        ] else if (property != null)
                          _buildInfoCard(
                            'Property Information',
                            property.title,
                            Icons.apartment,
                          ),
                        if (_needsClientPicker) ...[
                          const SizedBox(height: 16),
                          _buildPickerLabel('SELECT CLIENT'),
                          _buildClientDropdown(clients),
                        ] else if (client != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            'Client Information',
                            client.name,
                            Icons.person_outline,
                          ),
                        ],
                        if (properties.isEmpty && _needsPropertyPicker)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Add a property first to log a viewing.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        if (clients.isEmpty && _needsClientPicker)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Add a client first to log a viewing.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        const SizedBox(height: 32),
                        const Text(
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
                          hint: 'YYYY-MM-DD or date/time',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _notesController,
                          label: 'Notes / Feedback',
                          icon: Icons.notes,
                          hint: 'Client feedback and viewing details...',
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
                              onPressed: () =>
                                  setState(() => _interestScore = i + 1),
                              icon: Icon(
                                i < _interestScore
                                    ? Icons.star
                                    : Icons.star_border,
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
                            _isEditing
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
                  );
          },
        ),
      ),
    );
  }

  Widget _buildPickerLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPropertyDropdown(List<PropertyEntity> properties) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPropertyId,
          isExpanded: true,
          hint: const Text('Choose a property'),
          items: properties
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.title, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: properties.isEmpty
              ? null
              : (val) => setState(() => _selectedPropertyId = val),
        ),
      ),
    );
  }

  Widget _buildClientDropdown(List<ClientEntity> clients) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClientId,
          isExpanded: true,
          hint: const Text('Choose a client'),
          items: clients
              .map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: clients.isEmpty
              ? null
              : (val) => setState(() => _selectedClientId = val),
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
