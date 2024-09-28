import 'package:app_daily_planner/models/add_task.dart';
import 'package:flutter/material.dart';

import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();

  String _content = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _location = '';
  String _organizer = '';
  String _notes = '';
  String _status = 'New';
  String _reviewer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Task Content',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task content';
                  }
                  return null;
                },
                onSaved: (value) => _content = value!,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Date: '),
                  TextButton(
                    child: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2025),
                      );
                      if (picked != null && picked != _selectedDate)
                        setState(() {
                          _selectedDate = picked;
                        });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time: '),
                  TextButton(
                    child: Text(
                        '${_startTime.format(context)} - ${_endTime.format(context)}'),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                      );
                      if (picked != null && picked != _startTime)
                        setState(() {
                          _startTime = picked;
                        });
                    },
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onSaved: (value) => _location = value!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Organizer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onSaved: (value) => _organizer = value!,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onSaved: (value) => _notes = value!,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                value: _status,
                items: ['New', 'In Progress', 'Completed', 'Ended']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Reviewer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onSaved: (value) => _reviewer = value!,
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  child: Text('Add Task',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Task newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        content: _content,
                        date: _selectedDate,
                        startTime: _startTime,
                        endTime: _endTime,
                        location: _location,
                        organizer: _organizer,
                        notes: _notes,
                        status: _status,
                        reviewer: _reviewer,
                      );
                      await _taskService.addTask(newTask);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('${newTask.content} added successfully')),
                      );
                      Navigator.pushNamed(context, '/tasks');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
