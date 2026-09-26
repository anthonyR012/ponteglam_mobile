import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _copFormatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String formatCOP(dynamic amount) {
    if (amount == null) return '\$0';
    
    num value;
    if (amount is String) {
      value = num.tryParse(amount) ?? 0;
    } else if (amount is num) {
      value = amount;
    } else {
      return '\$0';
    }

    return _copFormatter.format(value);
  }
}
