import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../utils/formatters.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final data = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker'), actions: [
        IconButton(tooltip: 'Add transaction', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())), icon: const Icon(Icons.add_circle_outline)),
      ]),
      body: RefreshIndicator(
        onRefresh: data.load,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
          Text('Your finances at a glance', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Total balance'),
            const SizedBox(height: 8),
            Text(Formatters.money(data.balance), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Income minus expenses'),
          ]))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: SummaryCard(title: 'Income', amount: Formatters.money(data.income), icon: Icons.trending_up, color: Colors.green)),
            const SizedBox(width: 10),
            Expanded(child: SummaryCard(title: 'Expenses', amount: Formatters.money(data.expenses), icon: Icons.trending_down, color: Colors.redAccent)),
          ]),
          const SizedBox(height: 22),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Latest')),
          ]),
          if (data.transactions.isEmpty)
            const Padding(padding: EdgeInsets.all(28), child: Column(children: [Icon(Icons.receipt_long, size: 44), SizedBox(height: 8), Text('No transactions yet'), Text('Tap + to record your first one.')]))
          else
            ...data.transactions.take(5).map((item) => TransactionTile(transaction: item)),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
        icon: const Icon(Icons.add), label: const Text('Add'),
      ),
    );
  }
}
