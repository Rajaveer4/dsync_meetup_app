// lib/data/models/announcement_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final String id;
  final String clubId;
  final String title;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AnnouncementModel({
    required this.id,
    required this.clubId,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] as String,
      clubId: map['clubId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      authorId: map['authorId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clubId': clubId,
      'title': title,
      'content': content,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  @override
  List<Object?> get props => [
        id,
        clubId,
        title,
        content,
        authorId,
        createdAt,
        updatedAt,
      ];
}