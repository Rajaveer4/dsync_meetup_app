import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class ClubMembersScreen extends StatelessWidget {
  final String clubId;

  const ClubMembersScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Optional: Add search functionality
              context.pushNamed(
                RouteNames.clubMemberSearch,
                pathParameters: {'clubId': clubId},
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Member ${index + 1}'),
            subtitle: const Text('Joined 2 months ago'),
            trailing: index % 3 == 0
                ? const Chip(label: Text('Admin'), backgroundColor: Colors.blue)
                : null,
            onTap: () {
              // Navigate to member details using GoRouter
              context.pushNamed(
                RouteNames.memberDetails,
                pathParameters: {
                  'clubId': clubId,
                  'userId': 'member$index',
                },
              );
            },
          );
        },
      ),
    );
  }
}