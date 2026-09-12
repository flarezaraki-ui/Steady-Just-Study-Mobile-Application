import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:steady_just_study/services/firebase_service.dart';

/// Bar chart of the signed-in user's points earned over the last 7 days.
/// Drop this in wherever the progress screen needs it — it fetches its
/// own data and handles loading/empty/error states.
class WeeklyPointsChart extends StatefulWidget {
  const WeeklyPointsChart({super.key});

  @override
  State<WeeklyPointsChart> createState() => _WeeklyPointsChartState();
}

class _WeeklyPointsChartState extends State<WeeklyPointsChart> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<Map<DateTime, int>> _weeklyPointsFuture;

  static const _weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    _weeklyPointsFuture = _firebaseService.getWeeklyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: FutureBuilder<Map<DateTime, int>>(
        future: _weeklyPointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Could not load points chart'));
          }

          final dailyTotals = snapshot.data ?? {};
          final days = dailyTotals.keys.toList()..sort();

          if (days.isEmpty) {
            return const Center(child: Text('No points logged this week'));
          }

          final maxPoints = dailyTotals.values.reduce((a, b) => a > b ? a : b);
          // Headroom above the tallest bar so it doesn't touch the top.
          final chartMaxY = (maxPoints == 0 ? 10 : maxPoints * 1.3).toDouble();

          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            child: BarChart(
              BarChartData(
                maxY: chartMaxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: chartMaxY / 4,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _weekdayLabels[days[index].weekday - 1],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (int i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (dailyTotals[days[i]] ?? 0).toDouble(),
                          color: const Color(0xff7BB1D2),
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
