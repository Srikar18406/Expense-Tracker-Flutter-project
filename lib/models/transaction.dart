enum TransactionType { income, expense }

class ExpenseTransaction {
  const ExpenseTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note = '',
  });

  final int? id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String note;

  bool get isIncome => type == TransactionType.income;

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'type': type.name,
        'category': category,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory ExpenseTransaction.fromMap(Map<String, Object?> map) {
    return ExpenseTransaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (value) => value.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String? ?? '',
    );
  }

  ExpenseTransaction copyWith({int? id}) => ExpenseTransaction(
        id: id ?? this.id,
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date,
        note: note,
      );
}
