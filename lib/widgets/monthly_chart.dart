import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key, required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final values = List<double>.generate(6, (index) {
      final month = DateTime(now.year, now.month - 5 + index);
      return transactions.where((t) => !t.isIncome && t.date.year == month.year && t.date.month == month.month)
          .fold<double>(0, (sum, t) => sum + t.amount);
    });
    final maxValue = values.fold<double>(0, (a, b) => a > b ? a : b);
    return SizedBox(
      height: 190,
      child: BarChart(BarChartData(
        maxY: maxValue == 0 ? 100 : maxValue * 1.25,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final month = DateTime(now.year, now.month - 5 + value.toInt());
              const labels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
              return Padding(padding: const EdgeInsets.only(top: 8), child: Text(labels[month.month - 1], style: Theme.of(context).textTheme.labelSmall));
            },
          )),
        ),
        barGroups: values.asMap().entries.map((entry) => BarChartGroupData(
          x: entry.key,
          barRods: [BarChartRodData(toY: entry.value, width: 18, borderRadius: BorderRadius.circular(5), color: Theme.of(context).colorScheme.primary)],
        )).toList(),
      )),
    );
  }
}
