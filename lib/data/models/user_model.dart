import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String? email;
  final String? photoURL;
  final String? provider;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? photoUrl;
  final String? username;
  final String? bio;
  final String? interests;

  User({
    required this.id,
    required this.name,
    this.email,
    this.photoURL,
    this.provider,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.username,
    this.bio,
    this.interests,
  });

  // Add this copyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoURL,
    String? provider,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
    String? username,
    String? bio,
    String? interests,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      provider: provider ?? this.provider,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'provider': provider,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'photoUrl': photoUrl,
      'username': username,
      'bio': bio,
      'interests': interests,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      photoURL: json['photoURL'] as String?,
      provider: json['provider'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      photoUrl: json['photoUrl'] as String?,
      username: json['username'] as String?,
      bio: json['bio'] as String?,
      interests: json['interests'] as String?,
    );
  }

  // Add this static method to create a User from Firestore DocumentSnapshot
  static User fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      bio: data['bio'] ?? '',
      photoUrl: data['photoUrl'] ?? '', // <-- Use 'photoUrl' for consistency
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      email: data['email'] as String?,
      photoURL: data['photoURL'] as String?,
      provider: data['provider'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      interests: data['interests'] as String?,
    );
  }
}