import 'package:app_daily_planner/models/add_task.dart';
import 'package:app_daily_planner/pages/task_detail_screen.dart';
import 'package:flutter/material.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, item);
    });

    // Lưu lại thứ tự mới của danh sách
    try {
      await _taskService.saveTasks(_tasks);
      print('Tasks reordered and saved');
    } catch (error) {
      print('Failed to save tasks order: $error');
      // Nếu lưu thất bại, cần khôi phục lại trạng thái ban đầu
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ReorderableListView(
        onReorder: _onReorder,
        children: _tasks
            .asMap()
            .map((index, task) => MapEntry(
                  index,
                  Dismissible(
                    key: ValueKey(
                        task.id), // Đảm bảo key là duy nhất cho mỗi task
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      final removedTask = _tasks[index];
                      setState(() {
                        _tasks.removeAt(index);
                      });

                      try {
                        await _taskService.deleteTask(removedTask.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('${removedTask.content} deleted')),
                        );
                      } catch (error) {
                        // Nếu chọn cancel, thì khôi phục lại task vừa xóa
                        setState(() {
                          _tasks.insert(index, removedTask);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to delete ${removedTask.content}')),
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(task.content,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      contentPadding: EdgeInsets.all(12.0),
                      subtitle: Text(
                          '${task.date.toLocal()} ${task.startTime.format(context)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        ).then((_) => _loadTasks());
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: 30.0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit_task',
                                  arguments: task)
                              .then((_) => _loadTasks());
                        },
                      ),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_task');
          _loadTasks();
        },
      ),
    );
  }
}
