import 'package:flutter/material.dart';
import '../models/tasks.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Detail")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(task.description, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
                );
                if (result != null) {
                  navigator.pop(result);
                }
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
