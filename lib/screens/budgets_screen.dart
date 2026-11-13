import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/categories.dart';
import '../utils/formatters.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  Future<void> _addBudget(BuildContext context) async {
    final category = ValueNotifier<String>(Categories.expenses.first);
    final amount = TextEditingController();
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Set monthly budget'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ValueListenableBuilder<String>(valueListenable: category, builder: (_, value, __) => DropdownButtonFormField<String>(
          value: value, items: Categories.expenses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => category.value = v!, decoration: const InputDecoration(labelText: 'Category'),
        )),
        const SizedBox(height: 12),
        TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monthly limit (₹)')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          final value = double.tryParse(amount.text);
          if (value == null || value <= 0) return;
          await context.read<BudgetProvider>().save(category.value, value);
          if (dialogContext.mounted) Navigator.pop(dialogContext);
        }, child: const Text('Save')),
      ],
    ));
    amount.dispose();
    category.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budgets = context.watch<BudgetProvider>();
    final transactions = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly budgets')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _addBudget(context), icon: const Icon(Icons.add), label: const Text('Set budget')),
      body: budgets.budgets.isEmpty
        ? const Center(child: Text('No budgets yet. Set a limit to get started.'))
        : ListView(padding: const EdgeInsets.all(16), children: budgets.budgets.map((budget) {
            final spent = transactions.transactions.where((t) => !t.isIncome && t.category == budget.category && Formatters.monthKey(t.date) == Formatters.monthKey(budgets.month)).fold<double>(0, (sum, t) => sum + t.amount);
            final progress = (spent / budget.limit).clamp(0.0, 1.0);
            return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(budget.category, style: Theme.of(context).textTheme.titleMedium), Text('${Formatters.money(spent)} / ${Formatters.money(budget.limit)}')]),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress, minHeight: 9, borderRadius: BorderRadius.circular(8), color: spent > budget.limit ? Colors.red : null),
              const SizedBox(height: 6),
              Text(spent > budget.limit ? 'Over budget by ${Formatters.money(spent - budget.limit)}' : '${Formatters.money(budget.limit - spent)} remaining'),
            ])));
          }).toList()),
    );
  }
}
