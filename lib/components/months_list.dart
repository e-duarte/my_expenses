import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/utils/utils.dart';

class MonthsList extends StatelessWidget {
  const MonthsList({
    super.key,
    required this.amountedByMonths,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final List<double> amountedByMonths;
  final DateTime selectedMonth;
  final Function(DateTime) onMonthSelected;

  List<DateTime> get _months {
    return List.generate(12, (i) => i + 1).map((i) {
      return DateTime(DateTime.now().year, i);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _months.length,
      itemBuilder: (context, index) {
        final month = _months[index];
        return InkWell(
          onTap: () => onMonthSelected(month),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: month == selectedMonth
                      ? Theme.of(context).colorScheme.tertiary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  toBeginningOfSentenceCase(
                    formatMonthAbbr(month),
                  ),
                  style: TextStyle(
                    color: month == selectedMonth
                        ? Theme.of(context).colorScheme.tertiary
                        : Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'R\$${formatValue(amountedByMonths[index])}',
                  style: TextStyle(
                    color: month == selectedMonth
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 16),
    );
  }
}
