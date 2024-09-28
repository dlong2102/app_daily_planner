import 'package:flutter/material.dart';
import 'package:app_daily_planner/models/add_task.dart';
import 'package:app_daily_planner/services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TaskService _taskService = TaskService();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _locationController;
  late TextEditingController _organizerController;
  late TextEditingController _notesController;
  late TextEditingController _reviewerController;
  String _status = 'New';

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.task.content);
    _selectedDate = widget.task.date;
    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;
    _locationController = TextEditingController(text: widget.task.location);
    _organizerController = TextEditingController(text: widget.task.organizer);
    _notesController = TextEditingController(text: widget.task.notes);
    _reviewerController = TextEditingController(text: widget.task.reviewer);
    _status = widget.task.status;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      Task updatedTask = Task(
        id: widget.task.id,
        content: _contentController.text,
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        location: _locationController.text,
        organizer: _organizerController.text,
        notes: _notesController.text,
        status: _status,
        reviewer: _reviewerController.text,
      );

      _taskService.updateTask(updatedTask).then((_) {
        Navigator.pop(context, updatedTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10.0),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text("Date: ${_selectedDate.toLocal()}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text("Start Time: ${_startTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text("End Time: ${_endTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _organizerController,
                decoration: InputDecoration(
                    labelText: 'Organizer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _reviewerController,
                decoration: InputDecoration(
                    labelText: 'Reviewer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                items: ['New', 'In Progress', 'Completed'].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Save',
                      style: TextStyle(fontSize: 18, color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
