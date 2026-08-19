

import 'package:task_tracker/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/presentation/providers/task_provider.dart';

class TaskEditScreen extends ConsumerStatefulWidget{
  final Task task;
  const TaskEditScreen ({super.key, required this.task});
  @override
ConsumerState<TaskEditScreen> createState() => _TaskEditScreenState();
}


class _TaskEditScreenState extends ConsumerState<TaskEditScreen>{

  late TextEditingController titleController;

  @override
void initState() {
  super.initState();
  titleController = TextEditingController(text: widget.task.title);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          const SizedBox(height: 40),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              label: Text('Task Title')
               
            ),
          ),

          IconButton(onPressed: (){
            final updatedTask = Task(
              id: widget.task.id,
              title: titleController.text,
              status: widget.task.status,
              duedate: widget.task.duedate,
            );
            ref.read(taskProvider.notifier).updateTask(updatedTask);
            Navigator.pop(context);
          }, icon: const Icon(Icons.save , color: Colors.blue,) )
        ],
      ),
      ),
      
    );
  }
}