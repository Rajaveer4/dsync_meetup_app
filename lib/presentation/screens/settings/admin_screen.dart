import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('User Management'),
            leading: const Icon(Icons.people),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Event Moderation'),
            leading: const Icon(Icons.event),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Analytics Dashboard'),
            leading: const Icon(Icons.analytics),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}