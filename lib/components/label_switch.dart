import 'package:flutter/material.dart';

class LabelSwtich extends StatelessWidget {
  const LabelSwtich({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Transform.scale(
          scale: 0.9,
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            onChanged: (value) => onChanged(value),
          ),
        ),
      ],
    );
  }
}
