import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateTime;
  final int attendees;
  final int? spotsLeft;
  final String clubName;
  final String emoji;
  final String imageUrl; // <-- Make sure this exists
  final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.attendees,
    this.spotsLeft,
    required this.clubName,
    required this.emoji,
    required this.imageUrl, // <-- Add this
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey.shade900,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club Name
              Text(
                clubName, 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 8),
              
              // Event Title with Emoji
              Row(
                children: [
                  Text(
                    '$emoji $title', 
                    style: const TextStyle(
                      fontSize: 18, 
                      color: Colors.white
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Date and Time
              Text(
                dateTime, 
                style: TextStyle(color: Colors.grey[400])
              ),
              const SizedBox(height: 4),
              
              // Location
              Text(
                subtitle, 
                style: TextStyle(color: Colors.grey[400])
              ),
              const SizedBox(height: 8),
              
              // Attendees and Spots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '👤 $attendees Joining', 
                    style: const TextStyle(color: Colors.white)
                  ),
                  Text(
                    spotsLeft != null 
                      ? '$spotsLeft spots left' 
                      : 'Unlimited spots',
                    style: const TextStyle(color: Colors.white)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}