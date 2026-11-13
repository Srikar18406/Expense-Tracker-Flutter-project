import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/categories.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.existing});
  final ExpenseTransaction? existing;
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late TransactionType _type;
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    _title = TextEditingController(text: item?.title ?? '');
    _amount = TextEditingController(text: item?.amount.toString() ?? '');
    _note = TextEditingController(text: item?.note ?? '');
    _type = item?.type ?? TransactionType.expense;
    _category = item?.category ?? Categories.expenses.first;
    _date = item?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _title.dispose(); _amount.dispose(); _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final item = ExpenseTransaction(
      id: widget.existing?.id,
      title: _title.text.trim(),
      amount: double.parse(_amount.text),
      type: _type, category: _category, date: _date, note: _note.text.trim(),
    );
    final provider = context.read<TransactionProvider>();
    if (widget.existing == null) { await provider.add(item); } else { await provider.update(item); }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = Categories.forType(_type);
    if (!categories.contains(_category)) _category = categories.first;
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Add transaction' : 'Edit transaction')),
      body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(20), children: [
        SegmentedButton<TransactionType>(
          segments: const [
            ButtonSegment(value: TransactionType.expense, label: Text('Expense'), icon: Icon(Icons.arrow_upward)),
            ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.arrow_downward)),
          ],
          selected: {_type},
          onSelectionChanged: (value) => setState(() { _type = value.first; _category = Categories.forType(_type).first; }),
        ),
        const SizedBox(height: 20),
        TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title', prefixIcon: Icon(Icons.edit)), validator: (v) => v == null || v.trim().isEmpty ? 'Enter a title' : null),
        const SizedBox(height: 14),
        TextFormField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)), validator: (v) { final n = double.tryParse(v ?? ''); return n == null || n <= 0 ? 'Enter an amount greater than zero' : null; }),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(value: _category, decoration: const InputDecoration(labelText: 'Category'), items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _category = v!)),
        const SizedBox(height: 14),
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('Date'), subtitle: Text('${_date.day}/${_date.month}/${_date.year}'), trailing: const Icon(Icons.calendar_month), onTap: () async { final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100)); if (d != null) setState(() => _date = d); }),
        const SizedBox(height: 14),
        TextFormField(controller: _note, maxLines: 3, decoration: const InputDecoration(labelText: 'Note (optional)', alignLabelWithHint: true)),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: const Text('Save transaction')),
      ])),
    );
  }
}
