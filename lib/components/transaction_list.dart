import 'package:flutter/material.dart';
import 'package:my_expenses/components/transaction_list_item.dart';
import 'package:my_expenses/models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.currentDate,
    required this.onRemoveTransaction,
    required this.onUpdateTransaction,
  });

  final DateTime currentDate;
  final List<Transaction> transactions;
  final void Function(Transaction) onRemoveTransaction;
  final void Function(Transaction) onUpdateTransaction;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Text(
              'Nenhuma Transação nesse mês',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        : ListView.separated(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tr = transactions[index];
              return TransactionListItem(
                transaction: tr,
                currentDate: currentDate,
                onRemove: (transaction) {
                  onRemoveTransaction(transaction);
                  Navigator.pop(context);
                },
                onUpdate: (transaction) {
                  onUpdateTransaction(transaction);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0.01),
          );
  }
}
