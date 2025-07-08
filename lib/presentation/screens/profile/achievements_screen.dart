// lib/presentation/screens/profile/achievements_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Achievements'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('achievements')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No achievements found.'));
          }

          final achievements = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final data = achievements[index].data() as Map<String, dynamic>;

              return AchievementCard(
                title: data['title'] ?? 'Unnamed Achievement',
                description: data['description'] ?? '',
                badge: data['badge'] ?? 'star',
                timestamp: data['timestamp'],
              ).animate().fade().scale(delay: 100.ms * index);
            },
          );
        },
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final String badge;
  final int? timestamp;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.badge,
    this.timestamp,
  });

  IconData _getBadgeIcon(String badge) {
    switch (badge.toLowerCase()) {
      case 'medal':
        return Icons.military_tech;
      case 'trophy':
        return Icons.emoji_events;
      case 'star':
        return Icons.star;
      case 'badge':
        return Icons.badge;
      default:
        return Icons.workspace_premium;
    }
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          _getBadgeIcon(badge),
          color: Colors.amber,
          size: 40,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$description\n${_formatDate(timestamp)}'),
        isThreeLine: true,
      ),
    );
  }
}
