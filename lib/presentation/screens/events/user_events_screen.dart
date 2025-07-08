import 'package:flutter/material.dart';

class UserEventsScreen extends StatelessWidget {
  final String userId;

  const UserEventsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: Center(child: Text('Events for user $userId')),
    );
  }
}
