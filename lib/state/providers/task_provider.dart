import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_objectbox/data/objectbox/objectbox.dart';
import 'package:flutter_todo_objectbox/data/models/task.dart';
import 'package:flutter_todo_objectbox/data/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(objectBox.store.box<Task>());
});

final taskListProvider = StreamProvider<List<Task>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.watchAllTasks();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;

  TaskNotifier(this._taskRepository) : super([]);

  Future<void> addTask(String title, String description) async {
    final newTask = Task(title: title, description: description);
    await _taskRepository.addTask(newTask);
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: !task.isCompleted,
    );
    await _taskRepository.updateTask(updatedTask);
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(taskRepository);
});