import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../utils/formatters.dart';
import '../widgets/monthly_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final data = context.watch<TransactionProvider>();
    final categories = <String,double>{};
    for (final item in data.transactions.where((t) => !t.isIncome)) {
      categories.update(item.category, (v) => v + item.amount, ifAbsent: () => item.amount);
    }
    final sorted = categories.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    return Scaffold(
      appBar: AppBar(title: const Text('Spending insights')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Expenses over the last 6 months', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: MonthlyChart(transactions: data.transactions))),
        const SizedBox(height: 24),
        Text('Spending by category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (sorted.isEmpty) const Text('Add expenses to see your category breakdown.'),
        ...sorted.map((entry) => Card(child: ListTile(
          title: Text(entry.key),
          subtitle: LinearProgressIndicator(value: data.expenses == 0 ? 0 : entry.value / data.expenses),
          trailing: Text(Formatters.money(entry.value)),
        ))),
      ]),
    );
  }
}
