import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng center = const LatLng(51.03, -0.2133); //london
  final Set<Marker> markers = {};

  void onTap(LatLng pos) {
    setState(() {
      markers.clear();
      markers.add(Marker(markerId: const MarkerId("selected"), position: pos));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("pick location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 12),
        markers: markers,
        onTap: onTap,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
