import 'package:flutter/material.dart';

// Interests Page Component
class PreferencesScreen extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<String> onInterestToggled;

  const PreferencesScreen({
    super.key,
    required this.selectedInterests,
    required this.onInterestToggled,
  });

  @override
  Widget build(BuildContext context) {
    final popularInterests = [
      'Dancing',
      'Social',
      'Fun Times',
      'Self Help & Self Improvement',
      'Social Networking',
      'Social Activities',
      'Jamming',
      'Happy Hour',
      'Making New Friends',
      'Nightlife',
      'Bars & Pubs',
      'Hobbies & Passion',
      'Reading',
      'Literature',
      'Wine',
      'Geeks & Nerds',
      'Arts',
      'Performing Artists',
      'Poetry',
      'Singing',
      'Cultural Activities',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Select Any Three interests'),
          const SizedBox(height: 24),
          const Text(
            'Popular Interests',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularInterests.map((interest) {
              final isSelected = selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (_) => onInterestToggled(interest),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              );
            }).toList(),
          ),
          if (selectedInterests.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Selected Interests:'),
            Wrap(
              children: selectedInterests
                  .map((interest) => Chip(label: Text(interest)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}