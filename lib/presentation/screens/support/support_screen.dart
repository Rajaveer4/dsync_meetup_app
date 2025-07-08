import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Us'),
                subtitle: const Text('support@dsyncmeetup.com'),
                onTap: () {
                  // Open email client
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Us'),
                subtitle: const Text('+1 (555) 123-4567'),
                onTap: () {
                  // Open phone dialer
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Live Chat'),
                subtitle: const Text('Available 9am-5pm EST'),
                onTap: () {
                  // Open chat interface
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Common Issues',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextButton(
                  onPressed: () {
                    // Navigate to help section
                  },
                  child: Text(
                    'How to ${['reset password', 'update profile', 'join a club'][index]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}