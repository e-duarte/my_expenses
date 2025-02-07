import 'package:flutter/material.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:my_expenses/components/consume_chart_legend.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/utils/utils.dart';

class ConsumeChart extends StatelessWidget {
  const ConsumeChart({
    super.key,
    required this.value,
    required this.transactions,
  });

  final double value;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final consumePercent = value != 0.0 ? _totalSum / value : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: EasyPieChart(
            showValue: false,
            // shouldAnimate: false,
            centerText: '${formatValue(100 * consumePercent)}%',
            gap: consumePercent > 0 ? 0.05 : 0.0,
            centerStyle: TextStyle(
              fontSize: 36,
              color: consumePercent == 0.0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            size: 165,
            children: [
              PieData(
                value: 1 - consumePercent,
                color: Theme.of(context).colorScheme.primary,
              ),
              PieData(
                value: consumePercent,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
        GeneralChartLegend(
          freeValue: value * (1 - consumePercent),
          consumeValue: value * consumePercent,
          totalValue: value,
          otherValue: _otherValues,
        ),
      ],
    );
  }

  double get _totalSum {
    return transactions
        .where((tr) => tr.owner == Owner.me || tr.owner == Owner.divided)
        .fold(0.0, (sum, tr) {
      return tr.owner == Owner.divided
          ? (sum + ((tr.value / tr.installments) / 2))
          : sum + (tr.value / tr.installments);
    });
  }

  double get _otherValues => transactions
      .where((tr) => tr.owner == Owner.other)
      .fold(0, (sum, tr) => sum + tr.value / tr.installments);
}
