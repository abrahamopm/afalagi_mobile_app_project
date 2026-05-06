import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        ListTile(title: Text('Name'), subtitle: Text('Admin User')),
        ListTile(title: Text('Email'), subtitle: Text('admin@afalagi.com')),
      ],
    );
  }
}
