import 'package:flutter/material.dart';
import 'package:my_expenses/components/label_radio.dart';

class RadioList extends StatelessWidget {
  const RadioList({
    super.key,
    required this.data,
    required this.groupValue,
    required this.onChanged,
  });

  final List<Map<String, Object>> data;
  final Object groupValue;
  final void Function(Object) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data
            .map(
              (item) => LabelRadio<Object>(
                title: item['title'] as String,
                value: item['value']!,
                groupValue: groupValue,
                onChanged: (value) => onChanged(value),
              ),
            )
            .toList());
  }
}
