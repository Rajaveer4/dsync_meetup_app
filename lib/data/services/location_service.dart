import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/place_model.dart';

class LocationService {
  // Replace with your actual Google API key or load from environment
  final String googleApiKey = const String.fromEnvironment('GOOGLE_API_KEY', 
    defaultValue: 'YOUR_GOOGLE_API_KEY');

  /// Gets the user's current location using Geolocator
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Converts a LatLng to a Place using Google Geocoding API
  Future<Place> getAddressFromCoordinates(LatLng latLng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleApiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final result = data['results'][0];
      return Place(
        id: result['place_id'] ?? '',
        name: result['address_components'][0]['long_name'] ?? '',
        address: result['formatted_address'] ?? '',
        location: GeoPoint(latLng.latitude, latLng.longitude),
        lastUpdated: DateTime.now(),
      );
    } else {
      throw Exception('Failed to reverse geocode coordinates');
    }
  }

  /// Returns a list of Place suggestions based on the search query
  Future<List<Place>> getPlaceSuggestions(String query) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final predictions = data['predictions'] as List;
      return predictions.map((prediction) {
        return Place(
          id: prediction['place_id'] ?? '',
          name: prediction['structured_formatting']?['main_text'] ?? '',
          address: prediction['description'] ?? '',
          location: const GeoPoint(0, 0), // To be fetched in detail if needed
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch place suggestions');
    }
  }

  /// Fetches full place details including coordinates using placeId
  Future<Place> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final result = data['result'];
      final location = result['geometry']['location'];

      return Place(
        id: result['place_id'] ?? '',
        name: result['name'] ?? '',
        address: result['formatted_address'] ?? '',
        location: GeoPoint(location['lat'], location['lng']),
        phoneNumber: result['formatted_phone_number'],
        website: result['website'],
        types: result['types']?.cast<String>(),
        imageUrl: result['photos'] != null
            ? _getimageUrl(result['photos'][0]['photo_reference'])
            : null,
        lastUpdated: DateTime.now(),
      );
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  /// Calculates distance in meters between two locations
  Future<double> calculateDistance(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Helper to build static map photo URL
  String _getimageUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleApiKey';
  }
}
