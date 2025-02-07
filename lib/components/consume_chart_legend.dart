import 'package:flutter/material.dart';
import 'package:my_expenses/components/legend_item.dart';
import 'package:my_expenses/components/portion_icon.dart';
import 'package:my_expenses/utils/utils.dart';

class GeneralChartLegend extends StatelessWidget {
  const GeneralChartLegend({
    super.key,
    required this.consumeValue,
    required this.freeValue,
    required this.totalValue,
    required this.otherValue,
  });

  final double freeValue;
  final double consumeValue;
  final double totalValue;
  final double otherValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LegendItem(
          icon: PortionIcon(
            color: Theme.of(context).colorScheme.primary,
          ),
          label: 'R\$${formatValue(freeValue)}',
        ),
        LegendItem(
          icon: PortionIcon(
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'R\$${formatValue(consumeValue)}',
        ),
        LegendItem(
          icon: const FittedBox(child: Icon(Icons.monetization_on)),
          label: 'R\$${formatValue(totalValue)}',
        ),
        LegendItem(
          icon: const FittedBox(child: Icon(Icons.people_alt)),
          label: 'R\$${formatValue(otherValue)}',
        ),
      ],
    );
  }
}
