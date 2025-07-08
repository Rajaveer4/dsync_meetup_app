import 'package:flutter/material.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String? selectedLocation;
  final void Function(String) onLocationChanged;

  const LocationSelectionScreen({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? _currentSelection;

  final List<String> primePuneLocations = [
    'Shivaji Nagar',
    'Kothrud',
    'Baner',
    'Viman Nagar',
    'Hadapsar',
    'Kharadi',
    'Wakad',
  ];

  final Map<String, List<String>> nearbyLocations = {
    'Shivaji Nagar': ['Model Colony', 'Deccan', 'JM Road'],
    'Kothrud': ['Paud Road', 'Karve Nagar', 'Erandwane'],
    'Baner': ['Balewadi', 'Pashan', 'Aundh'],
    'Viman Nagar': ['Yerwada', 'Kalyani Nagar', 'Mundhwa'],
    'Hadapsar': ['Magarpatta', 'Fursungi', 'Amanora'],
    'Kharadi': ['Chandan Nagar', 'EON IT Park', 'Vitthalwadi'],
    'Wakad': ['Hinjewadi', 'Pimple Saudagar', 'Thergaon'],
  };

  void _showNearbyAreas(String mainLocation) {
    final List<String> areas = nearbyLocations[mainLocation] ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nearby ${mainLocation}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...areas.map((area) => ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(area),
                    onTap: () {
                      setState(() {
                        _currentSelection = area;
                        widget.onLocationChanged(area);
                      });
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              const SizedBox(height: 8),
              const Text(
                "Where are you located?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Set your location so that you have access to events & people nearby",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Search bar (visual only)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "City, State or ZIP",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Icon(Icons.clear),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Location list
              ...primePuneLocations.map((location) {
                final isSelected = _currentSelection == location;
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(location),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    setState(() {
                      _currentSelection = location;
                      widget.onLocationChanged(location);
                    });
                    _showNearbyAreas(location);
                  },
                  selected: isSelected,
                );
              }),

              const Spacer(),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentSelection != null ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
