import 'package:flutter/material.dart';
import 'package:my_expenses/utils/utils.dart';

class InstallmetsDropdown extends StatelessWidget {
  const InstallmetsDropdown({
    super.key,
    required this.transactionValue,
    required this.numberOfInstallments,
    required this.initialValue,
    required this.onChanged,
  });

  final double transactionValue;
  final int numberOfInstallments;
  final int initialValue;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final installments = List.generate(numberOfInstallments, (i) => i + 1);
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<int>(
        style: Theme.of(context).textTheme.labelSmall,
        isExpanded: true,
        value: initialValue,
        onChanged: (value) => onChanged(value!),
        items: installments.map((i) {
          return DropdownMenuItem(
            value: i,
            child: Text(mapIndexToLabel(i)),
          );
        }).toList(),
      ),
    );
  }

  String mapIndexToLabel(int i) {
    if (i == 1) {
      return 'À vista - R\$ ${formatValue(transactionValue)}';
    }
    return '$i parcelas de R\$ ${formatValue(transactionValue / i)}';
  }
}
