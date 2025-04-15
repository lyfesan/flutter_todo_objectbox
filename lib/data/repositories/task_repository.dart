import 'package:objectbox/objectbox.dart';
import 'package:flutter_todo_objectbox/data/objectbox/objectbox.dart';
import 'package:flutter_todo_objectbox/data/models/task.dart';

class TaskRepository {
  final Box<Task> _taskBox;

  TaskRepository(this._taskBox);

  Future<int> addTask(Task task) async {
    return _taskBox.put(task);
  }

  Future<void> updateTask(Task task) async {
    _taskBox.put(task);
  }

  Future<void> deleteTask(int id) async {
    _taskBox.remove(id);
  }

  Stream<List<Task>> watchAllTasks() {
    return _taskBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Future<List<Task>> getAllTasks() async {
    return _taskBox.query().build().find();
  }

  Future<Task?> getTaskById(int id) async {
    return _taskBox.get(id);
  }
}