import 'package:afalagi/core/theme/Theme.dart';
import 'package:afalagi/core/widgets/afalagi_dialog.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagManagementScreen extends ConsumerStatefulWidget {
  const TagManagementScreen({super.key});

  @override
  ConsumerState<TagManagementScreen> createState() =>
      _TagManagementScreenState();
}

class _TagManagementScreenState extends ConsumerState<TagManagementScreen> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _editTagController = TextEditingController();

  Color _selectedColor = AppColors.primary;
  String _filterQuery = '';

  final List<Color> _availableColors = [
    AppColors.primary,
    const Color(0xFF2E6B4F),
    const Color(0xFF6B3E0C),
    const Color(0xFF006D8E),
    const Color(0xFFA6EBC9),
  ];

  @override
  void dispose() {
    _tagController.dispose();
    _filterController.dispose();
    _editTagController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _colorFromHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return AppColors.primary;
  }

  Future<void> _createTag() async {
    if (_tagController.text.trim().isEmpty) return;

    final tag = TagEntity(
      id: '',
      name: _tagController.text.trim(),
      color: _colorToHex(_selectedColor),
    );

    try {
      await ref.read(tagListProvider.notifier).addTag(tag);
      _tagController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tag created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteTag(TagEntity tag) async {
    final confirmed = await AfalagiDialog.showConfirm(
      context,
      title: 'Delete Tag',
      content: 'Delete "${tag.name}"? It will be removed from properties.',
    );

    if (confirmed != true) return;

    try {
      await ref.read(tagListProvider.notifier).deleteTag(tag.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _editTag(TagEntity tag) {
    _editTagController.text = tag.name;
    Color tempColor = _colorFromHex(tag.color);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: AppTheme.compactDialogShape,
          title: const Text('Edit Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTagController,
                decoration: InputDecoration(
                  labelText: 'Tag Name',
                  filled: true,
                  fillColor: const Color(0xFFF1F4F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
                      child: tempColor == color
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);

                final updated = tag.copyWith(
                  name: _editTagController.text.trim(),
                  color: _colorToHex(tempColor),
                );

                try {
                  await ref
                      .read(tagListProvider.notifier)
                      .updateTag(tag.id, updated);
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  List<TagEntity> _filterTags(List<TagEntity> tags) {
    if (_filterQuery.isEmpty) return tags;
    return tags
        .where(
          (tag) =>
              tag.name.toLowerCase().contains(_filterQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: tagsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(tagListProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (tags) {
          final filtered = _filterTags(tags);

          return RefreshIndicator(
            onRefresh: () => ref.read(tagListProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organize and curate your property portfolio labels for Ethiopia\'s elite market.',
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildCreateSection(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Tags',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'TOTAL ${tags.length} MANAGED LABELS',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: '',
                    hintText: 'Filter tags...',
                    controller: _filterController,
                    onChanged: (value) => setState(() => _filterQuery = value),
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                  const SizedBox(height: 24),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No tags yet. Create one above.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((tag) => _buildTagCard(tag)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
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
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Tag',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Text(
            'DEFINE A BRAND CATEGORY',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: 'Tag Name',
            hintText: 'e.g. Waterfront',
            controller: _tagController,
          ),
          const SizedBox(height: 20),
          const Text(
            'Category Color',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
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
                    border: isSelected
                        ? Border.all(color: AppTheme.primaryColor, width: 1.5)
                        : null,
                  ),
                  child: CircleAvatar(radius: 14, backgroundColor: color),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Create Tag',
            onPressed: _createTag,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildTagCard(TagEntity tag) {
    final color = _colorFromHex(tag.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${tag.propertyCount} PROPERTIES',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SecondaryButton(
            icon: Icons.edit_outlined,
            label: 'Edit',
            onTap: () => _editTag(tag),
          ),
          const SizedBox(width: 8),
          SecondaryButton(
            icon: Icons.delete_outline,
            label: 'Delete',
            onTap: () => _deleteTag(tag),
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}
