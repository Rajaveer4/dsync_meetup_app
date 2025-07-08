import 'package:flutter/material.dart';

class ClubMemberSearchScreen extends StatelessWidget {
  final String clubId;

  const ClubMemberSearchScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Members'),
      ),
      body: const Center(
        child: Text('Member Search Functionality'),
      ),
    );
  }
}