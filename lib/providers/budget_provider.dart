import 'package:flutter/foundation.dart';

import '../data/transaction_database.dart';
import '../models/budget.dart';
import '../utils/formatters.dart';

class BudgetProvider extends ChangeNotifier {
  BudgetProvider(this._database);
  final TransactionDatabase _database;
  List<CategoryBudget> _budgets = [];
  DateTime _month = DateTime.now();

  List<CategoryBudget> get budgets => _budgets;
  DateTime get month => _month;

  Future<void> load() async {
    _budgets = await _database.getBudgets(Formatters.monthKey(_month));
    notifyListeners();
  }

  Future<void> setMonth(DateTime value) async {
    _month = DateTime(value.year, value.month);
    await load();
  }

  Future<void> save(String category, double limit) async {
    await _database.saveBudget(CategoryBudget(
      category: category, month: Formatters.monthKey(_month), limit: limit,
    ));
    await load();
  }
}
