import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}Mlr';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)}rb';
    }
    return format(amount);
  }

  static double parse(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  static String formatAsPlainText(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final reversed = formatted.split('').reversed.join('');
    final withDots = reversed
        .replaceAllMapped(RegExp(r'.{1,3}'), (match) => '${match.group(0)}.')
        .split('')
        .reversed
        .join();
    return withDots.endsWith('.') ? withDots.substring(0, withDots.length - 1) : withDots;
  }
}
