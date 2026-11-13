import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final items = provider.visibleTransactions;
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(
          onChanged: provider.search,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search title or category'),
        )),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
          ChoiceChip(label: const Text('All'), selected: provider.filter == null, onSelected: (_) => provider.setFilter(null)),
          const SizedBox(width: 8),
          ChoiceChip(label: const Text('Income'), selected: provider.filter == TransactionType.income, onSelected: (_) => provider.setFilter(TransactionType.income)),
          const SizedBox(width: 8),
          ChoiceChip(label: const Text('Expenses'), selected: provider.filter == TransactionType.expense, onSelected: (_) => provider.setFilter(TransactionType.expense)),
        ])),
        Expanded(child: items.isEmpty
          ? const Center(child: Text('No matching transactions'))
          : ListView.builder(itemCount: items.length, itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                onDismissed: (_) => provider.remove(item.id!),
                child: TransactionTile(
                  transaction: item,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTransactionScreen(existing: item))),
                  onDelete: () => provider.remove(item.id!),
                ),
              );
            })),
      ]),
    );
  }
}
