import 'package:expense_tracker/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts and shows dashboard', (tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());
    await tester.pump();
    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}
