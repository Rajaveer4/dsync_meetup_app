import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class ClubEventsScreen extends StatelessWidget {
  final String clubId;

  const ClubEventsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Events')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create event using GoRouter
          context.pushNamed(
            RouteNames.createEvent,
            pathParameters: {'clubId': clubId},
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Event ${index + 1}'),
              subtitle: const Text('June 15, 2023 • 2:00 PM'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to event details using GoRouter
                context.pushNamed(
                  RouteNames.eventDetails,
                  pathParameters: {
                    'clubId': clubId,
                    'eventId': 'event$index',
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