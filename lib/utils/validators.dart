class Validators {
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  static String? positiveAmount(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null || !amount.isFinite || amount <= 0) {
      return 'Enter a valid amount greater than zero';
    }
    return null;
  }
}
