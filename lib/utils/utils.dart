import 'package:intl/intl.dart';

String formatValue(double value) {
  final strValue = value.toStringAsFixed(2);
  return strValue;
}

String formatMonthToBr(DateTime date) {
  return DateFormat.MMMM('pt_BR').format(date);
}

String formatMonthAbbr(DateTime date) {
  return DateFormat.MMM('pt_BR').format(date).replaceAll('.', '').toUpperCase();
}
