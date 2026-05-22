import 'package:afalagi/core/widgets/propery_card.dart';

import 'package:afalagi/features/property/property_service.dart';
import 'package:afalagi/features/tags/tags_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<String> _selectedTags = [];
  late List properties;
  late List filteredProperties;

  @override
  void initState() {
    super.initState();
    properties = PropertyService.getProperties();
    filteredProperties = List.from(properties);
  }

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
            onPressed: () {
              setState(() {
                PropertyService.deleteProperty(id);
                properties = PropertyService.getProperties();
                _applyFilters();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (_selectedTags.isEmpty) {
      filteredProperties = List.from(properties);
    } else {
      filteredProperties = properties.where((p) {
        final tags = (p.tags ?? []);
        return tags.any((t) => _selectedTags.contains(t));
      }).toList();
    }
  }

  Widget _buildTagFilterChips() {
    final tags = TagsService.getTags();

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
                  _applyFilters();
                });
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.12),
              labelStyle: TextStyle(
                color: _selectedTags.isEmpty ? Theme.of(context).primaryColor : Colors.black87,
                fontWeight: _selectedTags.isEmpty ? FontWeight.bold : null,
              ),
            ),
          ),
          ...tags.map((tag) {
            final name = tag['name'] as String;
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
                    _applyFilters();
                  });
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.12),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                backgroundColor: Colors.white,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
              onTap: () {
                context.go('/property-detail', extra: property);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-property'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
