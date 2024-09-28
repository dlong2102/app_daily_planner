import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = [
      TaskStatus('Completed', 1),
      TaskStatus('In Progress', 3),
      TaskStatus('New', 2),
    ];

    var series = [
      charts.Series(
        id: 'TaskStatus',
        data: data,
        domainFn: (TaskStatus status, _) => status.status,
        measureFn: (TaskStatus status, _) => status.count,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text('Statistics'),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }
}

class TaskStatus {
  final String status;
  final int count;

  TaskStatus(this.status, this.count);
}
