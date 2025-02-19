import 'package:my_expenses/models/transaction.dart';

class FiltersMapper {
  final Map<String, bool> data = {};

  FiltersMapper(List<Filter> filters) {
    for (var f in filters) {
      data.addAll({f.name: false});
    }
  }

  Map<String, bool> mapFiltersActive(List<Filter> filters) {
    final Map<String, bool> newData = Map.from(data);

    for (var f in filters) {
      newData[f.name] = true;
    }

    return newData;
  }
}

abstract class Filter<E> {
  final String name;
  final E value;

  Filter(this.name, this.value);

  List<Transaction> filter(List<Transaction> trs);

  @override
  String toString() => name;
}

class PaymentFilter extends Filter<Payment> {
  PaymentFilter(super.name, super.value);

  @override
  List<Transaction> filter(List<Transaction> trs) {
    return trs.where((tr) => tr.paymentType == value).toList();
  }
}

class OwnerFilter extends Filter<Owner> {
  OwnerFilter(super.name, super.value);

  @override
  List<Transaction> filter(List<Transaction> trs) {
    return trs.where((tr) => tr.owner == value).toList();
  }
}

class TagFilter extends Filter<String> {
  TagFilter(super.name, super.value);

  @override
  List<Transaction> filter(List<Transaction> trs) {
    return trs.where((tr) => tr.tag.tagName == value).toList();
  }
}

class FixedFilter extends Filter<bool> {
  FixedFilter(super.name, super.value);

  @override
  List<Transaction> filter(List<Transaction> trs) {
    return trs.where((tr) => tr.fixed == value).toList();
  }
}
