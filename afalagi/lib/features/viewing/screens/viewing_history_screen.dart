import 'package:flutter/material.dart';

class ViewingHistoryScreen extends StatelessWidget {
  const ViewingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ListTile(
          title: Text('Viewing #123'),
          subtitle: Text('2026-05-02'),
          trailing: Icon(Icons.chevron_right),
        );
      },
    );
  }
}
