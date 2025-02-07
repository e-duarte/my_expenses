import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/utils/utils.dart';

class MonthsDropDown extends StatelessWidget {
  const MonthsDropDown({
    super.key,
    required this.month,
    required this.onChanged,
  });

  final DateTime month;
  final void Function(DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DateTime>(
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 30,
      ),
      underline: Container(),
      style: Theme.of(context).textTheme.titleMedium,
      onChanged: (value) {
        onChanged(value!);
      },
      items: _months.map((m) {
        return DropdownMenuItem(
          value: m,
          child: Text(
            toBeginningOfSentenceCase(formatMonthToBr(m))!,
          ),
        );
      }).toList(),
      value: month,
    );
  }

  List<DateTime> get _months {
    return List.generate(12, (i) => i + 1).map((i) {
      return DateTime(DateTime.now().year, i);
    }).toList();
  }
}
