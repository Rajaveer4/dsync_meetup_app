import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class ClubSettingsScreen extends StatelessWidget {
  final String clubId;

  const ClubSettingsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Additional settings if needed
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Club Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Club Info'),
            onTap: () {
              context.pushNamed(
                RouteNames.editClub,
                pathParameters: {'clubId': clubId},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Manage Members'),
            onTap: () {
              context.pushNamed(
                RouteNames.clubMembers,
                pathParameters: {'clubId': clubId},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Manage Admins'),
            onTap: () {
              context.pushNamed(
                RouteNames.clubAdmins,
                pathParameters: {'clubId': clubId},
              );
            },
          ),
          const Divider(),
          const Text(
            'Danger Zone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Leave Club', style: TextStyle(color: Colors.red)),
            onTap: () => _showLeaveClubDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Club', style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteClubDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLeaveClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Club?'),
        content: const Text('Are you sure you want to leave this club?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle leave club logic
              context.pop();
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Club?'),
        content: const Text('This action cannot be undone. All club data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle delete club logic
              context.pop();
              context.pop(); // Close settings screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}