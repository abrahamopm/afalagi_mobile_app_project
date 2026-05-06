import 'package:afalagi/core/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/property_model.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final properties = [
      Property(
        id: '1',
        title: 'Luxury Villa',
        description: 'A beautiful villa',
        price: 1000000,
      ),
      Property(
        id: '2',
        title: 'Modern Apartment',
        description: 'City center apartment',
        price: 500000,
      ),
    ];

    return Scaffold(
      appBar: CustomScaffold.appBar(),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return ListTile(
            title: Text(property.title),
            subtitle: Text('\$${property.price}'),
            onTap: () => context.push('/property-detail', extra: property),
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
