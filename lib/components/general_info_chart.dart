import 'package:flutter/material.dart';
import 'package:my_expenses/components/bar_general_chart.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/models/transaction.dart';

class GeneralInfoChart extends StatelessWidget {
  const GeneralInfoChart({
    super.key,
    required this.transactions,
    required this.monthValue,
    required this.sumInstallments,
    required this.availableHeight,
    required this.availableWidth,
    required this.tags,
  });

  final List<Transaction> transactions;
  final double sumInstallments;
  final double monthValue;
  final double availableHeight;
  final double availableWidth;
  final List<Tag> tags;

  int get totalInstallments {
    return transactions.length;
  }

  String get getMaxTag {
    final Map<String, int> tagCounting = {
      for (var tag in tags.map((t) => t.tagName)) tag: 0
    };

    for (var tag in tags.map((t) => t.tagName)) {
      for (var tr in transactions) {
        if (tr.tag.tagName == tag) {
          tagCounting[tag] = tagCounting[tag]! + 1;
        }
      }
    }

    final maxTag =
        tagCounting.entries.reduce((a, b) => a.value > b.value ? a : b);
    return maxTag.key;
  }

  @override
  Widget build(BuildContext context) {
    final noPaddingWidth = availableWidth;
    final spacing = noPaddingWidth * 0.01;
    final consumPercent =
        monthValue != 0 ? sumInstallments / monthValue : spacing;
    final availableAmountPercent = 1 - consumPercent;

    print(consumPercent);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Fatura atual',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'R\$${sumInstallments.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: sumInstallments == 0.0 && monthValue != 0
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          sumInstallments != 0.0 && monthValue != 0
              ? consumPercent >= 1
                  ? BarGeneralChart(
                      width: noPaddingWidth,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BarGeneralChart(
                          width: noPaddingWidth * (consumPercent) - spacing / 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: spacing),
                        BarGeneralChart(
                          width: noPaddingWidth * availableAmountPercent -
                              spacing / 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    )
              : BarGeneralChart(
                  width: noPaddingWidth,
                  color: Theme.of(context).colorScheme.surface,
                ),
          Row(
            children: [
              Text(
                'Valor disponível',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              Text(
                'R\$${(monthValue - sumInstallments).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: consumPercent >= 1
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Transações no mês',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              Text(
                '$totalInstallments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Compra mais realizada',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              Text(
                getMaxTag,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: Icon(Icons.share_rounded),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: Icon(Icons.file_upload_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }
}
