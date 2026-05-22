import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/client_model.dart';

class ClientDetailScreen extends StatelessWidget {
  final Client client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(client.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${client.name}', style: const TextStyle(fontSize: 20)),
            Text('Phone: ${client.phone}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push(
                  '/log-viewing',
                  extra: {
                    'propertyId': 'dummy_property_id',
                    'clientId': client.id,
                  },
                );
              },
              child: const Text('Schedule Viewing'),
            ),
          ],
        ),
      ),
    );
  }
}
