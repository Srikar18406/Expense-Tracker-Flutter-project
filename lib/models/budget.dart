class CategoryBudget {
  const CategoryBudget({
    this.id,
    required this.category,
    required this.month,
    required this.limit,
  });

  final int? id;
  final String category;
  final String month;
  final double limit;

  Map<String, Object?> toMap() => {
        'id': id,
        'category': category,
        'month': month,
        'limit': limit,
      };

  factory CategoryBudget.fromMap(Map<String, Object?> map) => CategoryBudget(
        id: map['id'] as int?,
        category: map['category'] as String,
        month: map['month'] as String,
        limit: (map['limit'] as num).toDouble(),
      );
}
