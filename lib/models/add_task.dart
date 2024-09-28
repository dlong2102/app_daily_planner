import 'package:flutter/material.dart';

class CalendarTask {
  DateTime date;
  String status;

  CalendarTask({required this.date, required this.status});

  factory CalendarTask.fromJson(Map<String, dynamic> json) {
    return CalendarTask(
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}

class Task {
  final String id;
  String content;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String location;
  String organizer;
  String notes;
  String status;
  String reviewer;

  Task({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.organizer,
    this.notes = '',
    this.status = 'New',
    this.reviewer = '',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Handle parsing of the TimeOfDay
    TimeOfDay _parseTime(String time) {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return Task(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
      location: json['location'] ?? '',
      organizer: json['organizer'] ?? '',
      notes: json['notes'] ?? '', // Provide default value if null
      status: json['status'] ?? 'New', // Default status is 'New'
      reviewer: json['reviewer'] ?? '', // Default reviewer is empty
    );
  }

  Map<String, dynamic> toJson() {
    // Standardize the time format to ensure consistency
    String _formatTime(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'startTime': _formatTime(startTime),
      'endTime': _formatTime(endTime),
      'location': location,
      'organizer': organizer,
      'notes': notes,
      'status': status,
      'reviewer': reviewer,
    };
  }
}
