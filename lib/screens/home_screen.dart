import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/components/general_info_chart.dart';
import 'package:my_expenses/components/loading_widget.dart';
import 'package:my_expenses/components/months_list.dart';
import 'package:my_expenses/components/setting_form.dart';
import 'package:my_expenses/components/tags_chart.dart';
import 'package:my_expenses/components/filter_pop_menu.dart';
import 'package:my_expenses/components/transaction_list.dart';
import 'package:my_expenses/components/transaction_list_item.dart';
import 'package:my_expenses/models/installment.dart';
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

  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

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
      return (tr.createAt.isBefore(_selectedMonth!) ||
              tr.createAt.month == _selectedMonth!.month ||
              tr.fixed) &&
          tr.createAt.year == _selectedMonth!.year;
    }).where((tr) {
      final trMonth = tr.createAt.month;
      final currentMonth = _selectedMonth!.month;

      return ((trMonth + tr.numOfInstallments) > currentMonth) || tr.fixed;
    }).toList();

    filtred.sort(
      (a, b) => a.createAt.compareTo(b.createAt),
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

  List<Transaction> get _transactionsByInstallments {
    return _filtredTransactions.where((tr) {
      var isContains = false;
      for (var ins in tr.installments) {
        if (ins.dueDate.month == _selectedMonth!.month &&
            ins.dueDate.year == _selectedMonth!.year) {
          isContains = true;
          break;
        }
      }
      return isContains;
    }).toList();
  }

  List<double> get _sumInstallmentsByMonth {
    return List.generate(12, (i) {
      final month = DateTime(DateTime.now().year, i + 1);
      List<Installment> installments = [];
      for (var tr in _transactions!) {
        installments.addAll(tr.installments.where((ins) {
          return ins.dueDate.month == month.month &&
              ins.dueDate.year == month.year;
        }).toList());
      }

      return installments.fold(0.0, (sum, ins) => sum + ins.amount);
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
    print('${_sumInstallmentsByMonth}');

    final appBarHeight = mediaQuery.size.height * 0.05;
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: Text('Minhas Despesas'),
        actions: [
          ElevatedButton(
            onPressed: () => _openTransactionalForm(context),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(50, 33),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: _openSettingsModal,
            icon: const Icon(
              Icons.settings_outlined,
              size: 30,
            ),
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
        children: [
          Container(
            width: mediaQuery.size.width,
            height: availableHeight * 0.07,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MonthsList(
              amountedByMonths: _sumInstallmentsByMonth,
              selectedMonth: _selectedMonth!,
              onMonthSelected: (month) {
                setState(() {
                  _selectedMonth = month;
                });
              },
            ),
          ),
          Divider(),
          SizedBox(
            height: availableHeight * 0.91,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: availableHeight * 0.30,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final charts = [
                          GeneralInfoChart(
                            transactions: _transactionsByInstallments,
                            sumInstallments: _sumInstallmentsByMonth[
                                _selectedMonth!.month - 1],
                            monthValue: _settings!.monthValue,
                            availableHeight: availableHeight,
                            availableWidth: constraints.maxWidth,
                            tags: _tags,
                          ),
                          Center(
                            child: TagsChart(
                              transactions: _transactionByMonth,
                              tags: _tags,
                            ),
                          ),
                        ];

                        return Column(
                          children: [
                            Expanded(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: constraints.maxHeight * 0.94,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                  // enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                items: charts.map((chart) {
                                  return Container(
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: chart,
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: charts.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 12.0,
                                    height: 12.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
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
                          'Soma: R\$${formatValue(_sumInstallmentsByMonth[_selectedMonth!.month - 1])}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      Text(
                        'Filtrar',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      // FilterPopMenu(
                      //   data: FiltersMapper(_filters)
                      //       .mapFiltersActive(_activedFilters),
                      //   onFilterChanged: _filterTransactions,
                      // ),
                    ],
                  ),
                  ..._transactionByMonth.map((tr) {
                    return TransactionListItem(
                      transaction: tr,
                      currentDate: _selectedMonth!,
                      onRemove: (transaction) {
                        // onRemoveTransaction(transaction);
                        Navigator.pop(context);
                      },
                      onUpdate: (transaction) {
                        // onUpdateTransaction(transaction);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ],
              ),
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
