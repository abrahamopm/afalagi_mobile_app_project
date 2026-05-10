import 'package:afalagi/core/widgets/propery_card.dart';

import 'package:afalagi/features/property/property_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
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

  @override
  Widget build(BuildContext context) {
    final properties = PropertyService.getProperties();

    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
