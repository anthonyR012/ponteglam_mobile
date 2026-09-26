import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatCurrencyUtil {
  // Function to format the price into a localized currency format based on the given price and BuildContext.
  String getPriceFormat(String price, BuildContext context) {
    double priceValue = double.parse(price);
    int priceInt = priceValue.toInt();
    Locale myLocale = Localizations.localeOf(context);
    final formatter = NumberFormat.currency(
        locale: myLocale.toLanguageTag(), symbol: "\$", decimalDigits: 0);
    String formattedPrice = formatter.format(priceInt);
    return formattedPrice;
  }
}
