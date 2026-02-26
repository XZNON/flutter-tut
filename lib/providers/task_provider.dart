import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tasks.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();
  late final RealtimeChannel _channel;
  List<Task> tasks = [];

  void startRealtime() {
    _channel = Supabase.instance.client
        .channel("tasks-channel")
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: "tasks",
          callback: (_) {
            if (hasListeners) {
              loadTasks();
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_channel);
    super.dispose();
  }

  void reset() {
    tasks = [];
    notifyListeners();
  }

  void listenToAuth() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (session == null) {
        //user has logged out
        reset();
      } else {
        //used logged in
        loadTasks();
      }
    });
  }

  Future<void> loadTasks() async {
    try {
      final result = await _service.fetchTask();

      if (!hasListeners) return; // 👈 CRITICAL LINE

      tasks = result;
      notifyListeners();
    } catch (e) {
      debugPrint("Error while loading tasks: $e");
    }
  }

  Future<void> addTask(String title, String description) async {
    try {
      await _service.addTask(title, description);
      await loadTasks();
    } catch (e) {
      debugPrint("Error while adding task: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _service.deleteTask(id);
      await loadTasks();
    } catch (e) {
      debugPrint("Error while deteting task: $e");
      rethrow;
    }
  }

  Future<void> updateTask(int id, String title, String description) async {
    try {
      await _service.updateTask(id, title, description);
      await loadTasks();
    } catch (e) {
      debugPrint("Error while updating task: $e");
      rethrow;
    }
  }
}
