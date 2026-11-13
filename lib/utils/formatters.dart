import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String money(num value) => _currency.format(value);
  static String date(DateTime value) => DateFormat('dd MMM yyyy').format(value);
  static String month(DateTime value) => DateFormat('MMMM yyyy').format(value);
  static String monthKey(DateTime value) => DateFormat('yyyy-MM').format(value);
}
