part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class DistanceLoading extends LocationState {}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);

  @override
  List<Object> get props => [message];
}

class LocationLoaded extends LocationState {
  final LatLng currentLocation;
  final Place currentAddress;
  const LocationLoaded({
    required this.currentLocation,
    required this.currentAddress,
  });

  @override
  List<Object> get props => [currentLocation, currentAddress];
}

class LocationSearchResults extends LocationState {
  final List<Place> places;
  const LocationSearchResults(this.places);

  @override
  List<Object> get props => [places];
}

class LocationSelected extends LocationState {
  final Place selectedPlace;
  const LocationSelected(this.selectedPlace);

  @override
  List<Object> get props => [selectedPlace];
}

class DistanceCalculated extends LocationState {
  final double distanceInMeters;
  const DistanceCalculated(this.distanceInMeters);

  @override
  List<Object> get props => [distanceInMeters];
}
