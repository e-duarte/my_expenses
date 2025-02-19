import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/utils/utils.dart';
import "dart:math";

class TagsChart extends StatelessWidget {
  const TagsChart({
    super.key,
    required this.tags,
    required this.transactions,
  });

  final List<Tag> tags;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    const linesGrideNum = 4;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: transactions.isNotEmpty
          ? BarChart(
              BarChartData(
                borderData: FlBorderData(
                  show: true,
                  border: const Border.symmetric(
                    horizontal: BorderSide(
                      width: 0.1,
                    ),
                  ),
                ),
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: _maxValue / linesGrideNum,
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: _getValuesTitle(linesGrideNum),
                  bottomTitles: _getIconTitle(),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipMargin: 7,
                  ),
                ),
                barGroups: List.generate(_groupedValues.length, (index) {
                  final barColor = Theme.of(context).colorScheme.outline;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: _groupedValues[index]['value'] as double,
                        color: barColor,
                      )
                    ],
                  );
                }),
              ),
            )
          : Center(
              child: Text(
                'No data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
    );
  }

  List<int> get _tagIndexs {
    return List.generate(tags.length, (index) => index);
  }

  Map<int, String> get _getTitles {
    return {for (var index in _tagIndexs) index: tags[index].iconPath};
  }

  AxisTitles _getValuesTitle(int linesGrideNum) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 45,
        interval: _maxValue / linesGrideNum,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: FittedBox(
              child: Text(
                'R\$${formatValue(value)}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          );
        },
      ),
    );
  }

  AxisTitles _getIconTitle() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Image.asset(
              _getTitles[value]!,
            ),
          );
        },
      ),
    );
  }

  List<Map<String, Object?>> get _groupedValues {
    return tags.map((tag) {
      var totalSum = 0.0;
      for (var tr in transactions) {
        if (tr.tag.tagName == tag.tagName) {
          totalSum += (tr.owner == Owner.divided)
              ? tr.value / 2
              : tr.value / tr.installments;
        }
      }

      return {'tag': tag.tagName, 'value': totalSum};
    }).toList();
  }

  double get _maxValue {
    return transactions.map((tr) => tr.value).reduce(max);
  }
}
