import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String address;
  final double? averageRating;
  final int? ratingCount;
  final GeoPoint location;
  final String? imageUrl;
  final String? phoneNumber;
  final String? website;
  final List<String>? types;
  final DateTime? lastUpdated;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    this.averageRating,
    this.ratingCount,
    this.imageUrl,
    this.phoneNumber,
    this.website,
    this.types,
    this.lastUpdated,
  });

  factory Place.fromMap(Map<String, dynamic> map) {
    try {
      return Place(
        id: map['id'] as String,
        name: map['name'] as String,
        address: map['address'] as String,
        averageRating: _parseDouble(map['averageRating']),
        ratingCount: _parseInt(map['ratingCount']),
        location: _parseGeoPoint(map),
        imageUrl: map['imageUrl'] as String?,
        phoneNumber: map['phoneNumber'] as String?,
        website: map['website'] as String?,
        types: _parseStringList(map['types']),
        lastUpdated: _parseDateTime(map['lastUpdated']),
      );
    } catch (e) {
      throw FormatException('Failed to parse Place: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'location': location,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (website != null) 'website': website,
      if (types != null) 'types': types,
      if (lastUpdated != null) 'lastUpdated': lastUpdated,
    };
  }

  LatLng get latLng => LatLng(location.latitude, location.longitude);

  factory Place.fromLatLng({
    required String id,
    required LatLng latLng,
    required String name,
    required String address,
  }) {
    return Place(
      id: id,
      name: name,
      address: address,
      location: GeoPoint(latLng.latitude, latLng.longitude),
    );
  }

  // Helper methods
  static double? _parseDouble(dynamic value) => value?.toDouble();
  static int? _parseInt(dynamic value) => value?.toInt();
  static List<String>? _parseStringList(dynamic value) => 
      value is List ? value.cast<String>() : null;
  static DateTime? _parseDateTime(dynamic value) => 
      value is Timestamp ? value.toDate() : null;
  
  static GeoPoint _parseGeoPoint(Map<String, dynamic> map) {
    if (map['location'] is GeoPoint) return map['location'];
    if (map['lat'] != null && map['lng'] != null) {
      return GeoPoint(
        (map['lat'] as num).toDouble(),
        (map['lng'] as num).toDouble(),
      );
    }
    throw ArgumentError('Invalid location data');
  }

  Place copyWith({
    String? id,
    String? name,
    String? address,
    double? averageRating,
    int? ratingCount,
    GeoPoint? location,
    String? imageUrl,
    String? phoneNumber,
    String? website,
    List<String>? types,
    DateTime? lastUpdated,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      types: types ?? this.types,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    id, name, address, location, 
    averageRating, ratingCount, lastUpdated,
  ];
}