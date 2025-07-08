import 'package:flutter/material.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final String announcementId;
  final String clubId;

  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementId,
    required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcement Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Club Update',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Posted by Admin • 2 days ago'),
            const Divider(height: 32),
            const Text(
              'We are excited to announce our upcoming annual meetup event! '
              'All members are invited to participate in this gathering '
              'where we will discuss the future of our club.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Event Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Date: June 25, 2023'),
            const Text('Time: 2:00 PM - 5:00 PM'),
            const Text('Location: Club Headquarters'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // RSVP to event
                },
                child: const Text('RSVP to Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}