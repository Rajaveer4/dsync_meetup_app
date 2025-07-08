// club_selection_screen.dart
import 'package:flutter/material.dart';

// Clubs Page Component
class ClubSelectionScreen extends StatelessWidget {
  final List<String> selectedClubs;
  final ValueChanged<String> onClubToggled;

  const ClubSelectionScreen({
    super.key,
    required this.selectedClubs,
    required this.onClubToggled,
  });

  @override
  Widget build(BuildContext context) {
    final popularClubs = [
      'Dsync',
      'Futsal',
      'Jamming club',
      'Football club',
      'Gamers club',
      'Music club',
      'Streeters',
      'Nascent',
      'Riding club',
      'Sports club',
      'Runners',
      'Riders',
      'Running club',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Don\'t wanna be alone, select 3 clubs relevant to your interests.'),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: popularClubs.map((club) {
              final isSelected = selectedClubs.contains(club);
              return GestureDetector(
                onTap: () => onClubToggled(club),
                child: Card(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                  elevation: isSelected ? 4 : 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group,
                          size: 40,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          club,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedClubs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Selected Clubs:'),
            Wrap(
              children: selectedClubs
                  .map((club) => Chip(label: Text(club)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}