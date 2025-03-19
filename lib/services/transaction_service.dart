import 'package:my_expenses/models/installment.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/services/tag_service.dart';
import 'package:my_expenses/utils/db_utils.dart';

class TransactionService {
  static const _table = 'transactions';

  Future<Transaction> insertTransaction(Transaction transaction) async {
    final mapTransaction = transaction.toMap();
    mapTransaction['tag'] = transaction.tag.id;
    mapTransaction.remove('installments');

    final transactionId = await DbUtils.insertData(_table, mapTransaction);

    List<Installment> installmentWithId = [];
    for (var installment in transaction.installments) {
      final installmentMap = installment.toMap();
      installmentMap['transactionId'] = transactionId;
      final installmentId =
          await DbUtils.insertData('installments', installmentMap);
      installmentWithId.add(
        installment.copyWith(
          id: installmentId,
          transactionId: transactionId,
        ),
      );
    }

    return transaction.copyWith(
        id: transactionId, installments: installmentWithId);
  }

  Future<List<Transaction>> getTransactions() async {
    final transactionsMaps = await DbUtils.listData(_table);

    final List<Transaction> transactions = [];

    for (var tr in transactionsMaps) {
      final tag = await TagService().getTag(tr['tag']! as int);
      final Map<String, Object?> newMap = Map.from(tr);
      newMap['tag'] = tag.toMap();

      final installmentFromDb = await DbUtils.listData('installments');
      final installments = installmentFromDb
          .where((element) => element['transactionId'] == tr['id'])
          .toList();

      newMap['installments'] = installments;

      transactions.add(Transaction.fromMap(newMap));
    }
    return transactions;
  }

  Future<void> removeTransaction(Transaction transaction) async {
    await DbUtils.deleteData(_table, transaction.toMap());
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await DbUtils.updateData(_table, transaction.toMap());
  }
}
