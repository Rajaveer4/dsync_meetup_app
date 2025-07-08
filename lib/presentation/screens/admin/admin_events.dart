import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminEvents extends StatelessWidget {
  const AdminEvents({super.key});

  final List<Map<String, String>> dummyEvents = const [
    {
      'id': '1',
      'title': 'DSync Launch Meetup',
      'date': '2025-06-20',
    },
    {
      'id': '2',
      'title': 'Flutter Firebase Workshop',
      'date': '2025-07-10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Events')),
      body: ListView.builder(
        itemCount: dummyEvents.length,
        itemBuilder: (context, index) {
          final event = dummyEvents[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(event['title']!),
              subtitle: Text('Date: ${event['date']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.go('/events/edit/${event['id']}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      context.go('/events/details/${event['id']}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/events/create'),
        tooltip: 'Create New Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
