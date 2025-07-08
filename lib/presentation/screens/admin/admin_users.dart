import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class AdminUsers extends StatelessWidget {
  const AdminUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final userId = 'user${index + 1}';

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('User ${index + 1}'),
            subtitle: Text('$userId@example.com'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to AdminSettings with userId
              context.goNamed(
                RouteNames.adminSettings, // ⚠️ make sure the constant name matches
                pathParameters: {'userId': userId},
              );
            },
          );
        },
      ),
    );
  }
}
