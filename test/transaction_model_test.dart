import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('transaction serializes and restores its fields', () {
    final original = ExpenseTransaction(
      id: 7, title: 'Lunch', amount: 125.5,
      type: TransactionType.expense, category: 'Food',
      date: DateTime(2026, 11, 13), note: 'Team lunch',
    );
    final restored = ExpenseTransaction.fromMap(original.toMap());
    expect(restored.id, 7);
    expect(restored.title, 'Lunch');
    expect(restored.amount, 125.5);
    expect(restored.type, TransactionType.expense);
    expect(restored.category, 'Food');
    expect(restored.note, 'Team lunch');
  });

  test('income is identified correctly', () {
    const income = ExpenseTransaction(
      title: 'Salary', amount: 1000, type: TransactionType.income,
      category: 'Salary', date: DateTime(2026, 1, 1),
    );
    expect(income.isIncome, isTrue);
  });
}
