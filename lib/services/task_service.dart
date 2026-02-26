import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tasks.dart';

class TaskService {
  final _client = Supabase.instance.client;

  Future<List<Task>> fetchTask() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) throw Exception("User not authenticated.");

    try {
      final response = await _client
          .from("tasks")
          .select()
          .eq("user_id", user.id)
          .order("created_at", ascending: false);

      return response.map<Task>((json) => Task.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Unable to display tasks: $e");
      rethrow;
    }
  }

  Future<void> addTask(String title, String description) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception("Not authenticated");
    try {
      await _client.from("tasks").insert({
        "title": title,
        "description": description,
        "user_id": user.id,
      });
    } catch (e) {
      debugPrint("Add operation failed: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _client.from("tasks").delete().eq("id", id);
    } catch (e) {
      debugPrint("Delete operation failed: $e");
      rethrow;
    }
  }

  Future<void> updateTask(int id, String title, String description) async {
    try {
      await _client
          .from("tasks")
          .update({"title": title, "description": description})
          .eq("id", id);
    } catch (e) {
      debugPrint("update operation failed: $e");
      rethrow;
    }
  }
}
