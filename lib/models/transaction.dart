import 'package:intl/intl.dart';
import 'package:my_expenses/models/installment.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/utils/utils.dart';

enum Owner { me, divided, other }

enum Payment { pix, pixCredit, credit }

class Transaction {
  final int? id;
  final Tag tag;
  final String title;
  final double value;
  final String paymentDest;
  final Payment paymentType;
  final int numOfInstallments;
  final List<Installment> installments;
  final DateTime createAt;
  final Owner owner;
  final String ownerDesc;
  final String obs;
  final bool fixed;

  Transaction({
    this.id,
    required this.tag,
    required this.title,
    required this.value,
    required this.paymentDest,
    required this.paymentType,
    required this.numOfInstallments,
    this.installments = const [],
    required this.createAt,
    required this.owner,
    required this.ownerDesc,
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

    List<Map<String, Object?>> installments =
        data['installments'] as List<Map<String, Object?>>;

    return Transaction(
      id: data['id'] as int,
      tag: Tag.fromMap(data['tag'] as Map<String, Object?>),
      title: data['title'] as String,
      value: data['value'] as double,
      paymentDest: data['paymentDest'] as String,
      paymentType: paymentType,
      numOfInstallments: data['numOfInstallments'] as int,
      installments: installments.map((e) => Installment.fromMap(e)).toList(),
      createAt: DateFormat('dd/MM/yyyy').parse(data['createAt'] as String),
      owner: owner,
      ownerDesc: data['ownerDesc'] as String,
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

  double get installmentValue {
    return value / numOfInstallments;
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
      'numOfInstallments': numOfInstallments,
      'installments': installments.map((e) => e.toMap()).toList(),
      'createAt': DateFormat('dd/MM/yyyy').format(createAt),
      'owner': owner.index,
      'ownerDesc': ownerDesc,
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
    int? numOfInstallments,
    List<Installment>? installments,
    DateTime? createAt,
    Owner? owner,
    String? ownerDesc,
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
      numOfInstallments: numOfInstallments ?? this.numOfInstallments,
      installments: installments ?? this.installments,
      createAt: createAt ?? this.createAt,
      owner: owner ?? this.owner,
      ownerDesc: ownerDesc ?? this.ownerDesc,
      obs: obs ?? this.obs,
      fixed: fixed ?? this.fixed,
    );
  }

  List<String> toCsvRow() {
    final formatedDate = DateFormat('dd/MM/yyyy').format(createAt);
    final formatedValue = owner == Owner.divided
        ? formatValue((value / numOfInstallments) / 2)
        : formatValue(value / numOfInstallments);
    return [
      tag.tagName,
      title,
      ownerDesc,
      numOfInstallments.toString(),
      formatedDate,
      formatedValue,
    ];
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
