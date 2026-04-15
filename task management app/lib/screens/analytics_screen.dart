import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final stats = taskProvider.tasksByCategory;
    final totalTasks = taskProvider.tasks.length;

    return Scaffold(
      backgroundColor: Colors.transparent, // Background will be handled by the main Scaffold
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Productivity Overview',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              // Pie Chart Category Breakdown
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: stats.isEmpty
                    ? const Center(child: Text('No data recorded for stats yet.'))
                    : PieChart(
                        PieChartData(
                          sections: stats.entries.map((entry) {
                            final colorIndex = stats.keys.toList().indexOf(entry.key);
                            final color = Colors.primaries[colorIndex % Colors.primaries.length];
                            return PieChartSectionData(
                              color: color,
                              value: entry.value.toDouble(),
                              title: '${entry.key}\n${(entry.value / totalTasks * 100).toInt()}%',
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          centerSpaceRadius: 40,
                        ),
                      ),
              ),
              const SizedBox(height: 40),
              // Task Completion Info
              _buildStatsCard(
                title: 'Total Tasks',
                value: '$totalTasks',
                icon: Icons.list_alt,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                title: 'Completion Rate',
                value: '${(taskProvider.completionPercentage * 100).toInt()}%',
                icon: Icons.check_circle_outline,
                color: Colors.greenAccent.shade700,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
