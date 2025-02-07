import 'package:flutter/material.dart';

class LabelRadio<E> extends StatelessWidget {
  const LabelRadio({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final E value;
  final E groupValue;
  final void Function(E) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<E>(
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          value: value,
          groupValue: groupValue,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
