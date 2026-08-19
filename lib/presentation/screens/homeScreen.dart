import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/data/models/task.dart';
import 'package:task_tracker/presentation/providers/task_provider.dart';

class TaskHomeScreen extends ConsumerStatefulWidget {
  const TaskHomeScreen({super.key});

  @override
  ConsumerState<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends ConsumerState<TaskHomeScreen> {
  final titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final newTask = Task(
                  id: '',
                  title: titleController.text,
                  status: false,
                  duedate: selectedDate,
                );
                await ref.read(taskProvider.notifier).addTask(newTask);
                titleController.clear();
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tasksAsync.when(
                data: (tasks) => ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: task.status,
                          onChanged: (value) {
                            final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              status: value ?? false,
                              duedate: task.duedate,
                            );
                            ref.read(taskProvider.notifier).updateTask(updatedTask);
                          },
                        ),
                        title: Text(task.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(taskProvider.notifier).deleteTask(task);
                          },
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}