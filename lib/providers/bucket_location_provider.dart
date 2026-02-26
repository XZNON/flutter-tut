import 'package:flutter/material.dart';
import '../models/bucket_locations.dart';
import '../services/location_service.dart';

class BucketLocationProvider extends ChangeNotifier {
  final _service = BucketLocationService();

  List<BucketLocation> locations = [];

  Future<void> load() async {
    try {
      locations = await _service.fetchLocations();
      notifyListeners();
    } catch (e) {
      throw Exception("Error in provider: $e");
    }
  }

  Future<void> add(String name, double lat, double lng, String address) async {
    try {
      await _service.addLocation(name, lat, lng, address);
      await load();
    } catch (e) {
      throw Exception("Error while adding: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await _service.deleteLocation(id);
      await load();
    } catch (e) {
      throw Exception("Error while deleting: $e");
    }
  }
}
