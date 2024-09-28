import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_daily_planner/models/add_task.dart';
import 'package:app_daily_planner/services/task_service.dart';
import 'package:app_daily_planner/theme/theme_provider.dart';
import 'pages/welcome_screen.dart';
import 'pages/login_screen.dart';
import 'pages/task_list_screen.dart';
import 'pages/add_task_screen.dart';
import 'pages/edit_task_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskService>(create: (context) => TaskService()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      child: DailyPlannerApp(),
    ),
  );
}

class DailyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Planner',
          themeMode: themeProvider.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          initialRoute: '/',
          routes: {
            '/': (context) => WelcomeScreen(),
            '/login': (context) => LoginScreen(),
            '/tasks': (context) => TaskListScreen(),
            '/add_task': (context) => AddTaskScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/edit_task') {
              final task = settings.arguments as Task;
              return MaterialPageRoute(
                builder: (context) {
                  return EditTaskScreen(task: task);
                },
              );
            }
            return null;
          },
        );
      },
    );
  }
}
