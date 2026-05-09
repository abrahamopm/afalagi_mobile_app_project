import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:flutter/material.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _editTagController = TextEditingController();

  Color _selectedColor = const Color(0xFF1B385E);
  String _filterQuery = '';

  final List<Color> _availableColors = [
    const Color(0xFF1B385E), // Dark Blue
    const Color(0xFF2E6B4F), // Forest Green
    const Color(0xFF6B3E0C), // Deep Ochre
    const Color(0xFF006D8E), // Teal
    const Color(0xFFA6EBC9), // Mint (Accent)
  ];

  final List<Map<String, dynamic>> _tags = [
    {'name': 'Luxury', 'properties': 124, 'color': const Color(0xFF1B385E)},
    {'name': 'Villa', 'properties': 86, 'color': const Color(0xFF2E6B4F)},
    {'name': 'Bole', 'properties': 312, 'color': const Color(0xFF6B3E0C)},
    {'name': 'Under Construction', 'properties': 42, 'color': const Color(0xFF006D8E)},
  ];

  @override
  void dispose() {
    _tagController.dispose();
    _filterController.dispose();
    _editTagController.dispose();
    super.dispose();
  }

  void _createTag() {
    if (_tagController.text.trim().isEmpty) return;
    setState(() {
      _tags.insert(0, {
        'name': _tagController.text.trim(),
        'properties': 0,
        'color': _selectedColor,
      });
      _tagController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tag created successfully')),
    );
  }

  void _deleteTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _editTag(int index) {
    final tag = _tags[index];
    _editTagController.text = tag['name'];
    Color tempColor = tag['color'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Tag', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTagController,
                decoration: InputDecoration(
                  labelText: 'Tag Name',
                  filled: true,
                  fillColor: const Color(0xFFF1F4F9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _availableColors.map((color) {
                  return GestureDetector(
                    onTap: () => setDialogState(() => tempColor = color),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: color,
                      child: tempColor == color ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() {
                  _tags[index] = {
                    ...tag,
                    'name': _editTagController.text.trim(),
                    'color': tempColor,
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredTags {
    if (_filterQuery.isEmpty) return _tags;
    return _tags.where((tag) => tag['name'].toLowerCase().contains(_filterQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tag Management',
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
            const Text(
              'Organize and curate your property portfolio labels for Ethiopia\'s elite market.',
              style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Create Tag Card
            _buildCreateSection(),
            const SizedBox(height: 40),

            // Active Tags Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Tags',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B385E)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TOTAL ${_tags.length} MANAGED LABELS',
                      style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Filter
            CustomTextField(
              label: "",
              hintText: 'Filter tags...',
              controller: _filterController,
              onChanged: (value) => setState(() => _filterQuery = value),
              prefixIcon: const Icon(Icons.search, size: 20),
            ),
            const SizedBox(height: 24),

            // Tag List
            ..._filteredTags.asMap().entries.map((entry) {
              return _buildTagCard(entry.value, entry.key);
            }).toList(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Tag',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B385E)),
          ),
          const Text(
            'DEFINE A BRAND CATEGORY',
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(height: 24),
          
          CustomTextField(
            label: "Tag Name",
            hintText: 'e.g. Waterfront',
            controller: _tagController,
          ),
          const SizedBox(height: 20),
          
          const Text('Category Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: _availableColors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 1.5) : null,
                  ),
                  child: CircleAvatar(radius: 14, backgroundColor: color),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: "Create Tag",
            onPressed: _createTag,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildTagCard(Map<String, dynamic> tag, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: tag['color'],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B385E)),
                ),
                Text(
                  '${tag['properties']} PROPERTIES',
                  style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          SecondaryButton(icon: Icons.edit_outlined, label: "Edit", onTap: () => _editTag(index)),
          const SizedBox(width: 8),
          SecondaryButton(icon: Icons.delete_outline, label: "Delete", onTap: () => _deleteTag(index), isDestructive: true),
        ],
      ),
    );
  }
}
