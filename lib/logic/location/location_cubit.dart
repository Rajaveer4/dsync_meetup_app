import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dsync_meetup_app/data/models/place_model.dart';
import 'package:dsync_meetup_app/data/services/location_service.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService locationService;

  Timer? _debounce;

  LocationCubit(this.locationService) : super(LocationInitial());

  /// Get the user's current geolocation and convert to address.
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      final position = await locationService.getCurrentPosition();
      final currentLocation = LatLng(position.latitude, position.longitude);
      final place = await locationService.getAddressFromCoordinates(currentLocation);
      
      emit(LocationLoaded(
        currentLocation: currentLocation,
        currentAddress: place,
      ));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  /// Debounced method for place search suggestions
  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length > 2) {
        searchPlaces(query);
      }
    });
  }

  /// Call Place API or similar service to fetch suggestions
  Future<void> searchPlaces(String query) async {
    emit(LocationLoading());
    try {
      final places = await locationService.getPlaceSuggestions(query);
      emit(LocationSearchResults(places));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  /// Reverse geocoding from coordinates
  Future<Place> getAddressFromLatLng(LatLng latLng) async {
    try {
      return await locationService.getAddressFromCoordinates(latLng);
    } catch (e) {
      emit(LocationError(e.toString()));
      rethrow;
    }
  }

  /// Emit the selected place
  void selectPlace(Place place) {
    emit(LocationSelected(place));
  }

  /// Calculate distance between two points
  Future<void> calculateDistance(LatLng start, LatLng end) async {
    emit(DistanceLoading());
    try {
      final distance = await locationService.calculateDistance(start, end);
      emit(DistanceCalculated(distance));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
