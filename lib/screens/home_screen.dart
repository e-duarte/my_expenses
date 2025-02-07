import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/components/consume_chart.dart';
import 'package:my_expenses/components/loading_widget.dart';
import 'package:my_expenses/components/months_dropdown.dart';
import 'package:my_expenses/components/setting_form.dart';
import 'package:my_expenses/components/tags_chart.dart';
import 'package:my_expenses/components/filter_pop_menu.dart';
import 'package:my_expenses/components/transaction_list.dart';
import 'package:my_expenses/models/settings.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/services/settings_service.dart';
import 'package:my_expenses/services/tag_service.dart';
import 'package:my_expenses/services/transaction_service.dart';
import 'package:my_expenses/utils/app_routes.dart';
import 'package:my_expenses/utils/transactions_filter.dart';
import 'package:my_expenses/utils/utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedMonth;
  Settings? _settings;

  List<Tag> _tags = [];

  List<Transaction>? _transactions;

  final List<Filter> _filters = [
    OwnerFilter('Dividido', Owner.divided),
    FixedFilter('Fixado', true),
    PaymentFilter('Pix', Payment.pix),
    PaymentFilter('PixCredit', Payment.pixCredit),
    PaymentFilter('Credit', Payment.credit),
    TagFilter('Ninos', 'Ninos'),
    TagFilter('Compras', 'Compras'),
    TagFilter('Mercado', 'Mercado'),
    TagFilter('Merenda', 'Merenda'),
    TagFilter('Refeição', 'Refeição'),
    TagFilter('Despesas', 'Despesas'),
    TagFilter('Reserva', 'Reserva'),
    TagFilter('Geral', 'Geral'),
    TagFilter('Terceiros', 'Terceiros'),
  ];

  final List<Filter> _activedFilters = [];
  final SocialPlatform platform = SocialPlatform.whatsapp;

  List<Transaction> get _transactionByMonth {
    final filtred = _transactions!.where((tr) {
      return (tr.date.isBefore(_selectedMonth!) ||
              tr.date.month == _selectedMonth!.month ||
              tr.fixed) &&
          tr.date.year == _selectedMonth!.year;
    }).where((tr) {
      final trMonth = tr.date.month;
      final currentMonth = _selectedMonth!.month;

      return ((trMonth + tr.installments) > currentMonth) || tr.fixed;
    }).toList();

    filtred.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return filtred.reversed.toList();
  }

  List<Transaction> get _filtredTransactions {
    List<Transaction> filtered = [];

    for (var filter in _activedFilters) {
      filtered.addAll(filter.filter(_transactionByMonth));
    }

    return filtered.isEmpty ? _transactionByMonth : filtered;
  }

  double get _sumFiltredTransactions {
    return _filtredTransactions
        .where((tr) => tr.owner == Owner.me || tr.owner == Owner.divided)
        .fold(0.0, (sum, tr) {
      return sum +
          (tr.owner == Owner.divided
              ? tr.value / 2
              : tr.value / tr.installments);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

    SettingsService().getSettings().then((settings) {
      setState(() {
        _settings = settings;
      });
    });

    TagService().getTags().then((value) {
      setState(() {
        _tags = value;
      });
    });

    TransactionService().getTransactions().then((trs) {
      setState(() {
        _transactions = trs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _settings == null
        ? const LoadingWidget()
        : _tags.isNotEmpty
            ? _transactions != null
                ? _buildHome(context)
                : const LoadingWidget()
            : const LoadingWidget();
  }

  Widget _buildHome(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBarHeight = mediaQuery.size.height * 0.05;
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: MonthsDropDown(
          month: _selectedMonth!,
          onChanged: (newMonth) {
            setState(() {
              _selectedMonth = newMonth;
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _openTransactionalForm(context),
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: _shareWhatsapp,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: _shareTransactions,
            icon: const Icon(Icons.open_in_browser),
          ),
          IconButton(
            onPressed: _openSettingsModal,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );

    final availableHeight =
        mediaQuery.size.height - appBarHeight - mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: availableHeight * 0.36,
            width: mediaQuery.size.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final charts = [
                  ConsumeChart(
                    value: _settings!.monthValue,
                    transactions: _transactionByMonth,
                  ),
                  Center(
                    child: TagsChart(
                      transactions: _transactionByMonth,
                      tags: _tags,
                    ),
                  ),
                ];
                return CarouselSlider(
                  options: CarouselOptions(
                    height: constraints.maxHeight * 0.94,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.95,
                    enlargeCenterPage: true,
                  ),
                  items: charts.map((chart) {
                    return Container(
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: chart,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            height: availableHeight * 0.64,
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Transações',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (_activedFilters.isNotEmpty)
                      Text(
                        'Soma: R\$${formatValue(_sumFiltredTransactions)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    FilterPopMenu(
                      data: FiltersMapper(_filters)
                          .mapFiltersActive(_activedFilters),
                      onFilterChanged: _filterTransactions,
                    ),
                  ],
                ),
                Expanded(
                  child: TransactionList(
                    currentDate: _selectedMonth!,
                    transactions: _filtredTransactions,
                    onRemoveTransaction: _removeTransaction,
                    onUpdateTransaction: _updateTransaction,
                  ),
                ),
                Text(
                  '${_transactionByMonth.length} transações no mês',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openTransactionalForm(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.TRANSACTION_FORM_SCREEN,
      arguments: _addNewTransaction,
    );
  }

  void _openSettingsModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          child: SettingsForm(
            settings: _settings!,
            onSettingChanged: _updateSettings,
          ),
        );
      },
    );
  }

  String _toCsvFormat() {
    final List<List<String>> transactionRows = [];
    final header = [
      'Categoria',
      'Título',
      'Autor',
      'Parcelas',
      'Data',
      'Valor',
    ];

    transactionRows.add(header);

    for (var tr in _filtredTransactions) {
      transactionRows.add(tr.toCsvRow());
    }

    return const ListToCsvConverter().convert(transactionRows);
  }

  void _shareWhatsapp() async {
    final csv = _toCsvFormat();
    SocialSharingPlus.shareToSocialMedia(platform, csv);
  }

  void _shareTransactions() async {
    final csv = _toCsvFormat();
    final Directory? downloadsDir = await getDownloadsDirectory();

    final file = File(
        '${downloadsDir!.path}/despesas_${formatMonthToBr(_selectedMonth!)}.csv');

    await file.writeAsString(csv);
    OpenFilex.open(file.path);
  }

  void _updateSettings(Settings settings) async {
    const id = 1;
    final newSettings = await SettingsService().update(id, settings);
    setState(() {
      _settings = newSettings;
    });
  }

  void _addNewTransaction(Transaction transaction) async {
    final newTransaction =
        await TransactionService().insertTransaction(transaction);
    setState(() {
      _transactions!.add(newTransaction);
    });
  }

  void _removeTransaction(Transaction transaction) async {
    await TransactionService().removeTransaction(transaction);

    setState(() {
      _transactions!.removeWhere((tr) => tr.id == transaction.id);
    });
  }

  void _updateTransaction(Transaction transaction) async {
    await TransactionService().updateTransaction(transaction);
    setState(() {
      _transactions!.removeWhere((tr) => tr.id == transaction.id);
      _transactions!.add(transaction);
    });
  }

  void _filterTransactions(Map<String, bool> filterMap) {
    final filterName = filterMap.entries.first.key;
    final isActive = filterMap.entries.first.value;
    setState(() {
      if (isActive) {
        _activedFilters.add(
          _filters.firstWhere(
            (filter) => filter.name == filterName,
          ),
        );
      } else {
        _activedFilters.removeWhere(
          (filter) => filter.name == filterName,
        );
      }
    });
  }
}
