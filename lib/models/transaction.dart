import 'package:intl/intl.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/utils/utils.dart';

enum Owner { me, divided, other }

enum Payment { pix, pixCredit, credit }

class Transaction {
  final int? id;
  final String title;
  final double value;
  final DateTime date;
  final bool fixed;
  final Tag tag;
  final int installments;
  final Owner owner;
  final String ownerDesc;
  final Payment payment;
  final String pixDest;

  Transaction({
    this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.fixed,
    required this.tag,
    required this.installments,
    required this.owner,
    required this.ownerDesc,
    required this.payment,
    required this.pixDest,
  });

  factory Transaction.fromMap(Map<String, Object?> data) {
    final owner = switch (data['owner']) {
      0 => Owner.me,
      1 => Owner.divided,
      2 => Owner.other,
      _ => throw const FormatException('Invalid')
    };

    final payment = switch (data['payment']) {
      0 => Payment.pix,
      1 => Payment.pixCredit,
      2 => Payment.credit,
      _ => throw const FormatException('Invalid')
    };
    return Transaction(
      id: data['id'] as int,
      title: data['title'] as String,
      value: data['value'] as double,
      date: DateFormat('dd/MM/yyyy').parse(data['date'] as String),
      fixed: data['fixed'] == 1,
      tag: Tag.fromMap(data['tag'] as Map<String, Object?>),
      installments: data['installments'] as int,
      owner: owner,
      ownerDesc: data['ownerDesc'] as String,
      payment: payment,
      pixDest: data['pixDest'] as String,
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
    return switch (payment) {
      Payment.pix => 'Pix',
      Payment.pixCredit => 'Pix-Crédito',
      Payment.credit => 'Crédito',
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
      'title': title,
      'value': value,
      'date': DateFormat('dd/MM/yyyy').format(date),
      'fixed': fixed ? 1 : 0,
      'tag': tag.id,
      'installments': installments,
      'owner': owner.index,
      'ownerDesc': ownerDesc,
      'payment': payment.index,
      'pixDest': pixDest,
    };
  }

  Transaction copyWith({
    int? id,
    String? title,
    double? value,
    DateTime? date,
    bool? fixed,
    Tag? tag,
    int? installments,
    Owner? owner,
    String? ownerDesc,
    Payment? payment,
    String? pixDest,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      date: date ?? this.date,
      fixed: fixed ?? this.fixed,
      tag: tag ?? this.tag,
      installments: installments ?? this.installments,
      owner: owner ?? this.owner,
      ownerDesc: ownerDesc ?? this.ownerDesc,
      payment: payment ?? this.payment,
      pixDest: pixDest ?? this.pixDest,
    );
  }

  List<String> toCsvRow() {
    final formatedDate = DateFormat('dd/MM/yyyy').format(date);
    final formatedValue = owner == Owner.divided
        ? formatValue((value / installments) / 2)
        : formatValue(value / installments);
    return [
      tag.tag,
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
