import '../models/transaction.dart';

class Categories {
  static const expenses = [
    'Food', 'Transport', 'Shopping', 'Bills', 'Health',
    'Entertainment', 'Education', 'Travel', 'Other',
  ];

  static const incomes = [
    'Salary', 'Freelance', 'Business', 'Investment', 'Gift', 'Other',
  ];

  static List<String> forType(TransactionType type) =>
      type == TransactionType.income ? incomes : expenses;

  static String emoji(String category) {
    const icons = {
      'Food': '🍔', 'Transport': '🚗', 'Shopping': '🛍️',
      'Bills': '🧾', 'Health': '💊', 'Entertainment': '🎬',
      'Education': '📚', 'Travel': '✈️', 'Salary': '💼',
      'Freelance': '💻', 'Business': '🏪', 'Investment': '📈',
      'Gift': '🎁', 'Other': '📌',
    };
    return icons[category] ?? '📌';
  }
}
