import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../utils/categories.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap, this.onDelete});
  final ExpenseTransaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? Colors.green : Colors.redAccent;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Text(Categories.emoji(transaction.category))),
      title: Text(transaction.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${transaction.category} • ${Formatters.date(transaction.date)}'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('${transaction.isIncome ? '+' : '-'}${Formatters.money(transaction.amount)}',
          style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
      ]),
    );
  }
}
