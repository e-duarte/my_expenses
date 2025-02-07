import 'package:flutter/material.dart';
import 'package:my_expenses/components/transaction_update_form.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/components/transaction_detail.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({
    super.key,
    required this.transaction,
    required this.onRemoveTransaction,
    required this.onUpdateTransation,
  });

  final Transaction transaction;
  final void Function(Transaction) onRemoveTransaction;
  final void Function(Transaction) onUpdateTransation;

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  bool isEdited = false;

  double percentHeight = 0.45;

  void _updateTranscation(Transaction transaction) {
    widget.onUpdateTransation(transaction);
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height * percentHeight;
    final topBarHeigth = totalHeight * 0.15;
    final availableHeight = totalHeight - topBarHeigth;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: totalHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: topBarHeigth,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEdited = !isEdited;
                          percentHeight = isEdited ? 0.8 : 0.45;
                        });
                      },
                      icon: Icon(
                        isEdited ? Icons.dataset_outlined : Icons.edit_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          widget.onRemoveTransaction(widget.transaction),
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                height: availableHeight,
                child: isEdited
                    ? TransactionUpdateForm(
                        widget.transaction,
                        _updateTranscation,
                      )
                    : TransactionDetail(transaction: widget.transaction),
              )
            ],
          ),
        ),
      ),
    );
  }
}
