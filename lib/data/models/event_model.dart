import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String category;
  final int? capacity;
  final List<String> participantIds;
  final String imageUrl;
  final String coverImageUrl;

  Event({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.category,
    this.capacity,
    this.participantIds = const [],
    required this.imageUrl,
    this.coverImageUrl = '', // Default value for coverImageUrl
  }) {
    if (endTime.isBefore(startTime)) {
      throw ArgumentError('End time cannot be before start time');
    }
  }

  Duration get duration => endTime.difference(startTime);

  String get formattedDate {
    if (startTime.year == endTime.year &&
        startTime.month == endTime.month &&
        startTime.day == endTime.day) {
      return '${DateFormat.yMMMd().format(startTime)}, '
          '${DateFormat.jm().format(startTime)} - '
          '${DateFormat.jm().format(endTime)}';
    }
    return '${DateFormat.yMMMd().format(startTime)} - '
        '${DateFormat.yMMMd().format(endTime)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'category': category,
      'capacity': capacity,
      'participantIds': participantIds,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      clubId: map['clubId'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      location: map['location'],
      category: map['category'],
      capacity: map['capacity'],
      participantIds: List<String>.from(map['participantIds'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  static Event fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      clubId: data['clubId'],
      title: data['title'],
      description: data['description'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      location: data['location'],
      category: data['category'],
      capacity: data['capacity'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Event copyWith({
    String? id,
    String? clubId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? category,
    int? capacity,
    List<String>? participantIds,
    String? imageUrl,
  }) {
    return Event(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      category: category ?? this.category,
      capacity: capacity ?? this.capacity,
      participantIds: participantIds ?? this.participantIds,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
