import 'package:expense_tracker/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required text rejects blank values', () {
    expect(Validators.requiredText('  '), isNotNull);
    expect(Validators.requiredText('Groceries'), isNull);
  });

  test('positive amount accepts only positive numbers', () {
    expect(Validators.positiveAmount('0'), isNotNull);
    expect(Validators.positiveAmount('-4'), isNotNull);
    expect(Validators.positiveAmount('abc'), isNotNull);
    expect(Validators.positiveAmount('45.50'), isNull);
  });
}
