import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/client_model.dart';

class ClientListScreen extends StatelessWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clients = [
      Client(id: 'c1', name: 'John Doe', phone: '123456789'),
      Client(id: 'c2', name: 'Jane Smith', phone: '987654321'),
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return ListTile(
            title: Text(client.name),
            subtitle: Text(client.phone),
            onTap: () => context.push('/client-detail', extra: client),
          );
        },
      ),
    );
  }
}
