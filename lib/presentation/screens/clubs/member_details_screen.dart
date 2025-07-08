import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;
  final String clubId;
  final bool isAdmin;

  const MemberDetailsScreen({
    super.key,
    required this.memberId,
    required this.clubId,
    this.isAdmin = false,
  });

  void _messageMember(BuildContext context) {
    context.pushNamed(
      RouteNames.chat,
      queryParameters: {
        'userId': memberId,
        'userName': 'John Doe', // Replace with actual name from state
      },
    );
  }

  void _manageRole(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Role'),
        content: const Text('Change this member\'s role?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement role change logic
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Role updated successfully')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show additional admin options
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Member since ${DateTime.now().subtract(const Duration(days: 180)).toString().split(' ')[0]}'),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text('john.doe@example.com'),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text('(555) 123-4567'),
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Club Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.event),
              title: Text('Events Attended'),
              trailing: Text('12'),
            ),
            const ListTile(
              leading: Icon(Icons.chat),
              title: Text('Posts Created'),
              trailing: Text('5'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _messageMember(context),
                  child: const Text('Message'),
                ),
                if (isAdmin)
                  ElevatedButton(
                    onPressed: () => _manageRole(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text('Manage Role'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}