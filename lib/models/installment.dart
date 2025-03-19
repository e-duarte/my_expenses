import 'package:intl/intl.dart';

enum PaymentStatus { paid, unpaid, partial }

class Installment {
  final int? id;
  final int? transactionId;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final double paidAmount;

  Installment({
    this.id,
    this.transactionId,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paidAmount = 0,
  });

  factory Installment.fromMap(Map<String, Object?> data) {
    final status = switch (data['status']) {
      0 => PaymentStatus.unpaid,
      1 => PaymentStatus.paid,
      2 => PaymentStatus.partial,
      _ => throw const FormatException('Invalid')
    };

    return Installment(
      id: data['id'] as int,
      transactionId: data['transactionId'] as int,
      amount: data['amount'] as double,
      dueDate: DateFormat('dd/MM/yyyy').parse(data['dueDate'] as String),
      status: status,
      paidAmount: data['paidAmount'] as double,
    );
  }

  Map<String, Object?> toMap() {
    final status = switch (this.status) {
      PaymentStatus.paid => 0,
      PaymentStatus.unpaid => 1,
      PaymentStatus.partial => 2,
    };

    return {
      'id': id,
      'transactionId': transactionId,
      'amount': amount,
      'dueDate': DateFormat('dd/MM/yyyy').format(dueDate),
      'status': status,
      'paidAmount': paidAmount,
    };
  }

  String get statusText {
    return switch (status) {
      PaymentStatus.paid => 'Pago',
      PaymentStatus.unpaid => 'A pagar',
      PaymentStatus.partial => 'Parcial',
    };
  }

  Installment copyWith({
    int? id,
    int? transactionId,
    double? amount,
    DateTime? dueDate,
    PaymentStatus? status,
    double? paidAmount,
    bool? isPaid,
  }) {
    return Installment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }
}
