import 'package:intl/intl.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/utils/utils.dart';

enum Owner { me, divided, other }

enum Payment { pix, pixCredit, credit }

enum TransactionStatus { paid, unpaid, partial }

class Transaction {
  final int? id;
  final Tag tag;
  final String title;
  final double value;
  final String paymentDest;
  final Payment paymentType;
  final int installments;
  final DateTime date;
  final Owner owner;
  final String ownerDesc;
  final TransactionStatus status;
  final double partialValue;
  final String obs;
  final bool fixed;

  Transaction({
    this.id,
    required this.tag,
    required this.title,
    required this.value,
    required this.paymentDest,
    required this.paymentType,
    required this.installments,
    required this.date,
    required this.owner,
    required this.ownerDesc,
    required this.status,
    required this.partialValue,
    required this.obs,
    required this.fixed,
  });

  factory Transaction.fromMap(Map<String, Object?> data) {
    final owner = switch (data['owner']) {
      0 => Owner.me,
      1 => Owner.divided,
      2 => Owner.other,
      _ => throw const FormatException('Invalid')
    };

    final paymentType = switch (data['payment']) {
      0 => Payment.pix,
      1 => Payment.pixCredit,
      2 => Payment.credit,
      _ => throw const FormatException('Invalid')
    };

    final status = switch (data['status']) {
      0 => TransactionStatus.unpaid,
      1 => TransactionStatus.paid,
      2 => TransactionStatus.partial,
      _ => throw const FormatException('Invalid')
    };

    return Transaction(
      id: data['id'] as int,
      tag: Tag.fromMap(data['tag'] as Map<String, Object?>),
      title: data['title'] as String,
      value: data['value'] as double,
      paymentDest: data['paymentDest'] as String,
      paymentType: paymentType,
      installments: data['installments'] as int,
      date: DateFormat('dd/MM/yyyy').parse(data['date'] as String),
      owner: owner,
      ownerDesc: data['ownerDesc'] as String,
      status: status,
      partialValue: data['partialValue'] as double,
      obs: data['obs'] as String,
      fixed: data['fixed'] == 1,
    );
  }

  String get ownerText {
    return switch (owner) {
      Owner.me => 'Eu',
      Owner.other => ownerDesc,
      Owner.divided => 'Dividido',
    };
  }

  String get paymentText {
    return switch (paymentType) {
      Payment.pix => 'Pix',
      Payment.pixCredit => 'Pix-Crédito',
      Payment.credit => 'Crédito',
    };
  }

  String get statusText {
    return switch (status) {
      TransactionStatus.paid => 'Pago',
      TransactionStatus.unpaid => 'A pagar',
      TransactionStatus.partial => 'Parcial',
    };
  }

  double get installmentValue {
    return value / installments;
  }

  bool get isDivided {
    return owner == Owner.divided;
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tag': tag.toMap(),
      'title': title,
      'value': value,
      'paymentDest': paymentDest,
      'payment': paymentType.index,
      'installments': installments,
      'date': DateFormat('dd/MM/yyyy').format(date),
      'owner': owner.index,
      'ownerDesc': ownerDesc,
      'status': status.index,
      'partialValue': partialValue,
      'obs': obs,
      'fixed': fixed ? 1 : 0,
    };
  }

  Transaction copyWith({
    int? id,
    Tag? tag,
    String? title,
    double? value,
    String? paymentDest,
    Payment? paymentType,
    int? installments,
    DateTime? date,
    Owner? owner,
    String? ownerDesc,
    TransactionStatus? status,
    double? partialValue,
    String? obs,
    bool? fixed,
  }) {
    return Transaction(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      title: title ?? this.title,
      value: value ?? this.value,
      paymentDest: paymentDest ?? this.paymentDest,
      paymentType: paymentType ?? this.paymentType,
      installments: installments ?? this.installments,
      date: date ?? this.date,
      owner: owner ?? this.owner,
      ownerDesc: ownerDesc ?? this.ownerDesc,
      status: status ?? this.status,
      partialValue: partialValue ?? this.partialValue,
      obs: obs ?? this.obs,
      fixed: fixed ?? this.fixed,
    );
  }

  List<String> toCsvRow() {
    final formatedDate = DateFormat('dd/MM/yyyy').format(date);
    final formatedValue = owner == Owner.divided
        ? formatValue((value / installments) / 2)
        : formatValue(value / installments);
    return [
      tag.tagName,
      title,
      ownerDesc,
      installments.toString(),
      formatedDate,
      formatedValue,
    ];
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
