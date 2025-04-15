import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_objectbox/state/providers/task_provider.dart';
import 'package:flutter_todo_objectbox/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:flutter_todo_objectbox/data/models/task.dart';
import 'package:flutter_todo_objectbox/presentation/widgets/edit_task_bottom_sheet.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsyncValue = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Center(child: Text('Tasks')),
      ),
      body: taskListAsyncValue.when(
        data: (tasks) => tasks.isEmpty
            ? const Center(child: Text('No tasks yet. Add some!'))
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell( // Make the ListTile tappable
                onTap: () {
                  _showEditTaskBottomSheet(context, ref, task);
                },
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(taskProvider.notifier).toggleTaskCompletion(task);
                      }
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: task.description.isNotEmpty
                      ? Text(
                    task.description,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        _showDeleteConfirmationDialog(context, ref, task.id, task.title),
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) => const AddTaskBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditTaskBottomSheet(BuildContext context, WidgetRef ref, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => EditTaskBottomSheet(task: task),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context,
      WidgetRef ref,
      int taskId,
      String taskTitle,
      ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the task "$taskTitle"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                ref.read(taskProvider.notifier).deleteTask(taskId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}