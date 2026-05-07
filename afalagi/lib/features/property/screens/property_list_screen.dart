import 'package:afalagi/core/widgets/propery_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/property_model.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = [
      Property(
        id: '1',
        title: 'Luxury Villa',
        location: 'Beachfront',
        imageUrl:
            'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&q=80&w=1200',
        description: 'A beautiful beachfront villa with stunning views.',
        price: 1000000,
        beds: 4,
        baths: 3,
        sqft: 2500,
      ),
      Property(
        id: '2',
        title: 'Modern Apartment',
        location: 'City Center',
        imageUrl:
            'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&q=80&w=1200',
        description: 'A modern apartment in the heart of the city.',
        price: 500000,
        beds: 2,
        baths: 2,
        sqft: 1200,
      ),
    ];

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
              onDelete: () {},
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
