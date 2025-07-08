import 'package:flutter/material.dart';
import 'package:dsync_meetup_app/core/constants/app_colors.dart';

class GamificationDashboard extends StatelessWidget {
  const GamificationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Achievements')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLevelIndicator(),
            const SizedBox(height: 20),
            _buildBadgesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Current Level', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('5', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            const Text('70% to next level'),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: const Icon(Icons.star, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text('Badge ${index + 1}', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}