import 'package:flutter/material.dart';
import 'package:nothing_note/components/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  // Add new task
  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  // Toggle task completion
  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    saveTasks();
    notifyListeners();
  }

  // Delete task
  void deleteTask(Task task) {
    _tasks.remove(task);
    saveTasks();
    notifyListeners();
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = _tasks.map((task) => json.encode(task.toMap())).toList();
    prefs.setStringList('tasks', taskStrings);
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks');
    if (taskStrings != null) {
      _tasks = taskStrings.map((taskString) => Task.fromMap(json.decode(taskString))).toList();
      notifyListeners();
    }
  }
}
