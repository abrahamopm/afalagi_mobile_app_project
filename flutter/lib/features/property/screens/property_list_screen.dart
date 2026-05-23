import 'package:afalagi/core/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../tags/providers/tag_provider.dart';
import '../providers/property_provider.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final List<String> _selectedTags = [];

  void _deleteProperty(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              try {
                await ref.read(propertyListProvider.notifier).deleteProperty(id);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Property deleted successfully')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTagFilterChips() {
    final tagsAsync = ref.watch(tagListProvider);

    return tagsAsync.when(
      data: (tags) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: const Text('All Properties'),
                  selected: _selectedTags.isEmpty,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTags.clear();
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                  labelStyle: TextStyle(
                    color: _selectedTags.isEmpty ? Theme.of(context).primaryColor : Colors.black87,
                    fontWeight: _selectedTags.isEmpty ? FontWeight.bold : null,
                  ),
                ),
              ),
              ...tags.map((tag) {
                final name = tag.name;
                final isSelected = _selectedTags.contains(name);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(name);
                        } else {
                          _selectedTags.remove(name);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                    checkmarkColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                    backgroundColor: Colors.white,
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertyListProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(propertyListProvider.notifier).refresh(),
        child: propertiesAsync.when(
          data: (properties) {
            // Apply filtering logic locally based on _selectedTags
            final filteredProperties = _selectedTags.isEmpty
                ? properties
                : properties.where((p) {
                    return p.tags.any((t) => _selectedTags.contains(t));
                  }).toList();

            if (filteredProperties.isEmpty && _selectedTags.isNotEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 8),
                  _buildTagFilterChips(),
                  const SizedBox(height: 80),
                  const Center(
                    child: Text(
                      'No properties found matching selected tags.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              );
            }

            if (properties.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No properties listed yet.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => context.push('/add-property'),
                          child: const Text('Add Your First Listing'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: filteredProperties.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildTagFilterChips(),
                      const SizedBox(height: 16),
                    ],
                  );
                }

                final property = filteredProperties[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PropertyCard(
                    property: property,
                    onDelete: () => _deleteProperty(property.id),
                    onEdit: () {
                      context.push('/edit-property', extra: property);
                    },
                    onTap: () {
                      context.push('/property-detail', extra: property);
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Error: ${error.toString()}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-property'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
