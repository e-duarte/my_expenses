import 'package:flutter/material.dart';
import 'package:my_expenses/components/tag_leading.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/utils/utils.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TagLeading(transaction.tag),
        Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'R\$${formatValue(transaction.value)} (total)',
          textAlign: TextAlign.center,
          maxLines: 3,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (transaction.installments == 1 && transaction.isDivided)
          Text(
            'R\$${formatValue(transaction.installmentValue / 2)} (dividido)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        Text(
          '${transaction.date.day} de ${formatMonthToBr(transaction.date)} de ${transaction.date.year}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (transaction.installments > 1)
          Text(
            '${transaction.installments} parcelas de R\$${formatValue(transaction.installmentValue)}',
          ),
        if (transaction.installments > 1 && transaction.isDivided)
          Text(
            '${transaction.installments} parcelas de R\$${formatValue(transaction.installmentValue / 2)} (dividido)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (transaction.fixed)
              Row(
                children: [
                  Image.asset(
                    'assets/icons/pin_icon.png',
                    width: 18,
                    height: 18,
                  ),
                  const Text(
                    'Fixado - ',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            Text(
              transaction.paymentText,
              textAlign: TextAlign.center,
            )
          ],
        ),
        if (transaction.pixDest.isNotEmpty)
          Text(
            'Enviado para ${transaction.pixDest}',
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
