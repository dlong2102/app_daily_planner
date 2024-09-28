import 'dart:convert';
import 'dart:io';
import 'package:app_daily_planner/models/add_task.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:path_provider/path_provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<CalendarTask> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasksFromFile();
  }

  // Hàm đọc file JSON và cập nhật danh sách các công việc
  Future<void> loadTasksFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/task.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);

        setState(() {
          tasks = jsonData.map((task) => CalendarTask.fromJson(task)).toList();
        });
      } else {
        print("File task.json không tồn tại.");
      }
    } catch (e) {
      print("Lỗi khi đọc file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: tasks.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Hiển thị khi chưa tải xong dữ liệu
          : TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarBuilders: CalendarBuilders(
                // Tùy chỉnh giao diện cho các ngày có nhiệm vụ
                defaultBuilder: (context, day, focusedDay) {
                  CalendarTask? taskForDay = tasks.firstWhere(
                      (task) => isSameDay(task.date, day),
                      orElse: () => CalendarTask(date: day, status: 'none'));

                  if (taskForDay.status != 'none') {
                    Color taskColor;

                    switch (taskForDay.status) {
                      case 'New':
                        taskColor = Colors.blue;
                        break;
                      case 'In Progress':
                        taskColor = Colors.green;
                        break;
                      case 'Completed':
                        taskColor = Colors.red;
                        break;
                      default:
                        taskColor = Colors.grey;
                    }

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: taskColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                        child: Text(
                            '${day.day}')); // Luôn trả về cho các ngày không có nhiệm vụ
                  }
                },
              ),
            ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<CalendarTask>('tasks', tasks));
  }
}
