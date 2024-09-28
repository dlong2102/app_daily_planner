import 'package:app_daily_planner/pages/calendar_screen.dart';
import 'package:app_daily_planner/pages/settings_screen.dart';
import 'package:app_daily_planner/pages/task_list_screen.dart';
import 'package:app_daily_planner/pages/task_statistics_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TaskListScreen(),
    StatisticsPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            // Background container
            height: 70.0, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), // Adjust radius as needed
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
          BottomNavigationBar(
            // Your existing BottomNavigationBar configuration
            type: BottomNavigationBarType.fixed,
            iconSize: 30,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
