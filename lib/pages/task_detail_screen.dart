import 'package:flutter/material.dart';
import 'package:app_daily_planner/models/add_task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Task Content',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(task.content, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.article),
            ),
            Divider(),
            ListTile(
              title: Text('Date',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text("${task.date.toLocal()}",
                  style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.calendar_today),
            ),
            Divider(),
            ListTile(
              title: Text('Start Time',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.startTime.format(context),
                  style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.access_time),
            ),
            Divider(),
            ListTile(
              title: Text('End Time',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.endTime.format(context),
                  style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.access_time),
            ),
            Divider(),
            ListTile(
              title: Text('Location',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.location, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.location_on),
            ),
            Divider(),
            ListTile(
              title: Text('Organizer',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.organizer, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.person),
            ),
            Divider(),
            ListTile(
              title: Text('Notes',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.notes, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.edit_note),
            ),
            Divider(),
            ListTile(
              title: Text('Reviewer',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.reviewer, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.person),
            ),
            Divider(),
            ListTile(
              title: Text('Status',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              subtitle: Text(task.status, style: TextStyle(fontSize: 18.0)),
              leading: Icon(Icons.info),
            ),
          ],
        ),
      ),
    );
  }
}
