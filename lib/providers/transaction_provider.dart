import 'package:flutter/foundation.dart';

import '../data/transaction_database.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider(this._database);
  final TransactionDatabase _database;
  List<ExpenseTransaction> _items = [];
  bool _loading = false;
  String _query = '';
  TransactionType? _filter;

  List<ExpenseTransaction> get transactions => _items;
  bool get isLoading => _loading;
  String get query => _query;
  TransactionType? get filter => _filter;

  List<ExpenseTransaction> get visibleTransactions => _items.where((item) {
    final matchesQuery = item.title.toLowerCase().contains(_query.toLowerCase()) ||
        item.category.toLowerCase().contains(_query.toLowerCase());
    return matchesQuery && (_filter == null || item.type == _filter);
  }).toList();

  double get income => _items.where((e) => e.isIncome).fold(0, (s, e) => s + e.amount);
  double get expenses => _items.where((e) => !e.isIncome).fold(0, (s, e) => s + e.amount);
  double get balance => income - expenses;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _items = await _database.getTransactions();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(ExpenseTransaction item) async {
    final id = await _database.insertTransaction(item);
    _items.insert(0, item.copyWith(id: id));
    notifyListeners();
  }

  Future<void> update(ExpenseTransaction item) async {
    await _database.updateTransaction(item);
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) _items[index] = item;
    notifyListeners();
  }

  Future<void> remove(int id) async {
    await _database.deleteTransaction(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void search(String value) { _query = value; notifyListeners(); }
  void setFilter(TransactionType? value) { _filter = value; notifyListeners(); }
}
