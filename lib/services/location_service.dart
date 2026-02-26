import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bucket_locations.dart';

class BucketLocationService {
  final _client = Supabase.instance.client;

  Future<List<BucketLocation>> fetchLocations() async {
    final user = _client.auth.currentUser!;
    try {
      final data = await _client
          .from("bucket_locations")
          .select()
          .eq("user_id", user.id);

      return data
          .map<BucketLocation>((e) => BucketLocation.fromJson(e))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (_) {
      throw Exception("error while fetching data");
    }
  }

  Future<void> addLocation(
    String name,
    double lat,
    double lng,
    String address,
  ) async {
    final user = _client.auth.currentUser!;

    try {
      await _client.from("bucket_locations").insert({
        'name': name,
        "lat": lat,
        "lng": lng,
        "address": address,
        "user_id": user.id,
      });
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (_) {
      throw Exception("Error whlie adding location");
    }
  }

  Future<void> deleteLocation(int id) async {
    try {
      await _client.from("bucket_locations").delete().eq("id", id);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (_) {
      throw Exception("Error while deleting message");
    }
  }
}
