import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:app_daily_planner/models/add_task.dart';
import 'package:path_provider/path_provider.dart';

class TaskService extends ChangeNotifier {
  static const String _fileName = 'task.json';
  static const String _assetPath = 'assets/task.json';
  bool _isInitialized = false;
  List<Task> _tasks = [];

  // Get the local path to the application documents directory
  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print('Directory path: ${directory.path}');
      return directory.path;
    } catch (e) {
      print('Error getting local path: $e');
      throw Exception('Failed to get local path');
    }
  }

  // Get the local file reference
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  // Initialize the file if not exists
  Future<void> _initializeIfNeeded() async {
    if (!_isInitialized) {
      try {
        final file = await _localFile;
        if (!await file.exists()) {
          print('File does not exist, copying from assets...');
          String initialData = await rootBundle.loadString(_assetPath);
          await file.writeAsString(initialData);
        } else {
          print('File already exists.');
        }
        _isInitialized = true;
      } catch (e) {
        print('Error initializing task service: $e');
      }
    }
  }

  // Fetch the tasks from the file
  Future<List<Task>> getTasks() async {
    if (_tasks.isEmpty) {
      await _initializeIfNeeded();
      try {
        final file = await _localFile;
        if (await file.exists()) {
          String contents = await file.readAsString();
          List<dynamic> jsonList = jsonDecode(contents);
          _tasks = jsonList.map((json) => Task.fromJson(json)).toList();
        }
      } catch (e) {
        print('Error reading tasks: $e');
        throw Exception('Failed to load tasks');
      }
    }
    return _tasks;
  }

  // Save the tasks to the file
  Future<void> saveTasks(List<Task> tasks) async {
    await _initializeIfNeeded();
    try {
      final file = await _localFile;
      List<Map<String, dynamic>> jsonList =
          tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
      _tasks = tasks;
      notifyListeners();
    } catch (e) {
      print('Error saving tasks: $e');
      throw Exception('Failed to save tasks');
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    List<Task> tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  // Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    List<Task> tasks = await getTasks();
    int index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    } else {
      print('Task not found: ${updatedTask.id}');
      throw Exception('Task not found');
    }
  }

  // Delete a task by id
  Future<void> deleteTask(String id) async {
    List<Task> tasks = await getTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }
}
