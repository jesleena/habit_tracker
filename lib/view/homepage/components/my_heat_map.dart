import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter/material.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  MyHeatMap({super.key, required this.datasets, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.secondary,
        textColor: Colors.white,
        showColorTip: false,
        scrollable: true,
        size: 30,
        colorsets: {
      1: Colors.green.shade200,
      2: Colors.green.shade300,
      3: Colors.green.shade400,
      4: Colors.green.shade500,
      5: Colors.green.shade600
    });
  }
}
