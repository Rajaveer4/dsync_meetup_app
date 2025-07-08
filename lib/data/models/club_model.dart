class ClubModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category; // Category of the club, e.g., "Sports", "Tech"
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;

  ClubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.members,
    required this.admins,
    required this.createdAt,
    required this.category,
  });

  /// Create ClubModel from map (e.g., Firebase/REST response)
  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '', // <-- Added here
      members: map['members'] != null
          ? List<String>.from(map['members'])
          : <String>[],
      admins: map['admins'] != null
          ? List<String>.from(map['admins'])
          : <String>[],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert ClubModel to map (for Firebase or APIs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category, // <-- Added here
      'members': members,
      'admins': admins,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Empty Club instance (used in Cubit fallback)
  factory ClubModel.empty() {
    return ClubModel(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      category: '', // <-- Added here
      members: [],
      admins: [],
      createdAt: DateTime.now(),
    );
  }

  /// Debugging utility
  @override
  String toString() {
    return 'ClubModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, category: $category, members: $members, admins: $admins, createdAt: $createdAt)';
  }

  /// Compare equality between ClubModel instances
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClubModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.category == category && // <-- Added here
        _listEquals(other.members, members) &&
        _listEquals(other.admins, admins) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        category.hashCode ^ // <-- Added here
        members.hashCode ^
        admins.hashCode ^
        createdAt.hashCode;
  }

  /// Helper for comparing list values
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
