import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? selected;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.6139, 77.2090),
          zoom: 12,
        ),
        onTap: (pos) async {
          final places = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );

          final place = places.first;

          navigator.pop({
            "name": "My dream Place",
            "lat": pos.latitude,
            "lng": pos.longitude,
            "address": "${place.street}, ${place.locality}",
          });
        },
      ),
    );
  }
}
