import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/budget.dart';
import '../models/transaction.dart';

class TransactionDatabase {
  TransactionDatabase._();
  static final TransactionDatabase instance = TransactionDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'expense_tracker.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            note TEXT NOT NULL DEFAULT ''
          )
        ''');
        await db.execute('''
          CREATE TABLE budgets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            month TEXT NOT NULL,
            `limit` REAL NOT NULL,
            UNIQUE(category, month)
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<ExpenseTransaction>> getTransactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');
    return rows.map(ExpenseTransaction.fromMap).toList();
  }

  Future<int> insertTransaction(ExpenseTransaction transaction) async {
    final db = await database;
    return db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTransaction(ExpenseTransaction transaction) async {
    final db = await database;
    return db.update('transactions', transaction.toMap(),
        where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CategoryBudget>> getBudgets(String month) async {
    final db = await database;
    final rows = await db.query('budgets', where: 'month = ?', whereArgs: [month]);
    return rows.map(CategoryBudget.fromMap).toList();
  }

  Future<void> saveBudget(CategoryBudget budget) async {
    final db = await database;
    await db.insert('budgets', budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
