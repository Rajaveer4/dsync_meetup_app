import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class ClubPollsScreen extends StatelessWidget {
  final String clubId;

  const ClubPollsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Polls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add refresh functionality here
              // Example: context.read<PollCubit>().fetchPolls(clubId);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create poll using GoRouter
          context.pushNamed(
            RouteNames.createPoll,
            pathParameters: {'clubId': clubId},
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Poll ${index + 1}'),
              subtitle: const Text('Ends in 2 days • 15 votes'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to poll details using GoRouter
                context.pushNamed(
                  RouteNames.pollDetails,
                  pathParameters: {
                    'clubId': clubId,
                    'pollId': 'poll$index',
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}