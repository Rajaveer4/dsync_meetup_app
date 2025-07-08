import 'package:flutter/material.dart';

class PollDetailsScreen extends StatelessWidget {
  final String pollId;
  final String clubId;

  const PollDetailsScreen({
    super.key,
    required this.pollId,
    required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poll Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which day works best for our next meetup?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Created by Admin • Ends in 2 days'),
            const Divider(height: 32),
            const Text(
              'Total Votes: 24',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPollOption('Saturday, June 10', 12, 24),
            _buildPollOption('Sunday, June 11', 8, 24),
            _buildPollOption('Friday, June 9', 4, 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Vote in poll
                },
                child: const Text('Vote in Poll'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollOption(String option, int votes, int totalVotes) {
    final percentage = (votes / totalVotes * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(option),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: votes / totalVotes,
            backgroundColor: Colors.grey[200],
            color: Colors.blue,
          ),
          const SizedBox(height: 4),
          Text('$votes votes ($percentage%)'),
        ],
      ),
    );
  }
}