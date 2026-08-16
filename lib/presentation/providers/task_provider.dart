
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/data/models/task.dart';


final taskProvider = AsyncNotifierProvider < TaskNotifier , List <Task>>(TaskNotifier.new); 

class TaskNotifier extends AsyncNotifier<List<Task>>{
@override

Future<List<Task>> build() async {
  return await fetchTask();
}


Future<void> addTask (Task task) async{
  await Supabase.instance.client
  .from('tasks')
  .insert({
    'title' : task.title,
    'status' : task.status,
    'duedate' : task.duedate.toIso8601String(),
  });

  state = AsyncValue.data(await fetchTask());
}

Future <void> deleteTask  (Task task) async {
  await Supabase.instance.client
  .from('tasks')
  .delete()
  .eq('id', task.id);

  state = AsyncValue.data(await fetchTask());
}

Future <List<Task>> fetchTask () async{
final response =  await Supabase.instance.client
  .from('tasks')
  .select();

  return response.map((item) => Task.fromJson(item)).toList();

}

Future <void> updateTask (Task task) async {
  await Supabase.instance.client
  .from('tasks')
  .update({
    'title' : task.title,
    'status' : task.status,
    'duedate' : task.duedate.toIso8601String(),
  })
  .eq('id',task.id);

  state = AsyncValue.data(await fetchTask());
}


}