import 'package:flutter/material.dart';
import 'package:flutter_tut/screens/bucket_list_screen.dart';
import 'package:flutter_tut/screens/map_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgtes/task_item.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> addTask() async {
    if (_titleController.text.isEmpty) return;

    await context.read<TaskProvider>().addTask(
      _titleController.text,
      _descriptionController.text,
    );

    _titleController.clear();
    _descriptionController.clear();
  }

  Future<void> deleteTask(int id) async {
    await context.read<TaskProvider>().deleteTask(id);
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.place),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BucketListScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter task",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Description",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: addTask, child: const Text("Add Task")),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return TaskItem(
                    task: task,
                    onDelete: () => deleteTask(task.id),
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final provider = context.read<TaskProvider>();

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      );

                      if (result != null) {
                        try {
                          await provider.updateTask(
                            task.id,
                            result["title"],
                            result["description"],
                          );
                        } catch (e) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text("Update failed")),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
              child: const Text("Open Map"),
            ),
          ],
        ),
      ),
    );
  }
}
