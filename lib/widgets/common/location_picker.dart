import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dsync_meetup_app/logic/location/location_cubit.dart';
import 'package:dsync_meetup_app/data/models/place_model.dart';
import 'package:dsync_meetup_app/core/constants/app_colors.dart';
import 'package:dsync_meetup_app/core/constants/app_styles.dart';

class LocationPicker extends StatefulWidget {
  final ValueChanged<Place> onPlaceSelected;
  final String? initialValue;

  const LocationPicker({
    required this.onPlaceSelected,
    this.initialValue,
    super.key,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialValue ?? '';
    context.read<LocationCubit>().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Location',
            prefixIcon: const Icon(Icons.search, color: AppColors.primaryLight),
            suffixIcon: const _CurrentLocationButton(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: AppTextStyles.bodyMedium,
          onChanged: (value) {
            context.read<LocationCubit>().onSearchQueryChanged(value);
          },
        ),
        const SizedBox(height: 16),
        BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationSelected) {
              widget.onPlaceSelected(state.selectedPlace);
            }
          },
          builder: (context, state) {
            if (state is LocationLoaded) {
              _selectedLocation = state.currentLocation;
              return _buildMap(_selectedLocation!);
            } else if (state is LocationSearchResults) {
              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        final place = state.places[index];
                        return ListTile(
                          title: Text(place.name, style: AppTextStyles.bodyMedium),
                          subtitle: Text(place.address, style: AppTextStyles.bodySmall),
                          onTap: () {
                            _searchController.text = place.address;
                            context.read<LocationCubit>().selectPlace(place);
                          },
                        );
                      },
                    ),
                  ),
                  if (_selectedLocation != null)
                    _buildMap(_selectedLocation!),
                ],
              );
            } else if (state is LocationSelected) {
              _selectedLocation = state.selectedPlace.latLng;
              return _buildMap(_selectedLocation!);
            } else if (state is LocationError) {
              return Text(state.message, style: AppTextStyles.bodyMedium);
            }
            return const CircularProgressIndicator(color: AppColors.primaryLight);
          },
        ),
      ],
    );
  }

  Widget _buildMap(LatLng location) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
          ),
        },
        onMapCreated: (controller) => _mapController = controller,
        onTap: (latLng) async {
          if (!mounted) return;
          try {
            final place = await context.read<LocationCubit>().getAddressFromLatLng(latLng);
            _searchController.text = place.address;
            if (mounted) {
              context.read<LocationCubit>().selectPlace(place);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to get address: ${e.toString()}'),
                  backgroundColor: AppColors.errorLight,
                ),
              );
            }
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _CurrentLocationButton extends StatelessWidget {
  const _CurrentLocationButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.my_location, color: AppColors.primaryLight),
      onPressed: () => context.read<LocationCubit>().getCurrentLocation(),
    );
  }
}
