import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ExpansionTile(
            title: Text('How do I join a club?'),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Navigate to the Clubs section, browse available clubs, and click the "Join" button on any club you\'re interested in.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I create an event?'),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Only club admins can create events. If you\'re an admin, go to your club page and click the "Create Event" button.',
                ),
              ),
            ],
          ),
          // Add more FAQs here
        ],
      ),
    );
  }
}