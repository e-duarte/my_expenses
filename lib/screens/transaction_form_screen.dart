import 'package:flutter/material.dart';
import 'package:my_expenses/components/date_picker.dart';
import 'package:my_expenses/components/installments_dropdown.dart';
import 'package:my_expenses/components/label_switch.dart';
import 'package:my_expenses/components/radio_list.dart';
import 'package:my_expenses/components/tags_radio_button.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/services/tag_service.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _otherController = TextEditingController();
  final _pixDestController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  final _numberOfInstallments = 12;

  Payment _payment = Payment.pix;
  bool _fixed = false;
  int _selectedInstallments = 1;
  DateTime _selectedDate = DateTime.now();
  Owner _owner = Owner.me;
  String _ownerDesc = Owner.me.name;
  Tag? _selectedTag;

  List<Tag> _tags = [];
  void Function(Transaction)? _onSubmit;

  @override
  void initState() {
    super.initState();

    TagService().getTags().then((value) {
      setState(() {
        _tags = value;
        _selectedTag = _tags.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    _onSubmit = ModalRoute.of(context)!.settings.arguments as void Function(
        Transaction);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: _tags.isNotEmpty
            ? _buildForm(context, availableHeight)
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, double availableHeigth) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: availableHeigth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Nova Transação',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              TextField(
                focusNode: _focusNode1,
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                onSubmitted: (_) {
                  _focusNode1.unfocus();
                  FocusScope.of(context).requestFocus(_focusNode2);
                },
              ),
              TextField(
                focusNode: _focusNode2,
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) {
                  _focusNode1.unfocus();
                  FocusScope.of(context).requestFocus(_focusNode3);
                },
              ),
              RadioList(
                data: const [
                  {'title': 'Pix', 'value': Payment.pix},
                  {'title': 'PixCredit', 'value': Payment.pixCredit},
                  {'title': 'Credit', 'value': Payment.credit},
                ],
                groupValue: _payment,
                onChanged: (value) {
                  setState(() {
                    _payment = value as Payment;
                  });
                },
              ),
              if (_payment == Payment.pix || _payment == Payment.pixCredit)
                TextField(
                  focusNode: _focusNode3,
                  controller: _pixDestController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Enviado para',
                  ),
                  onSubmitted: (_) => _submitForm(),
                ),
              if (_payment == Payment.credit)
                InstallmetsDropdown(
                  transactionValue:
                      double.tryParse(_valueController.text) ?? 0.0,
                  numberOfInstallments: _numberOfInstallments,
                  initialValue: _selectedInstallments,
                  onChanged: (value) {
                    setState(() {
                      _selectedInstallments = value;
                    });
                  },
                ),
              DatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              RadioList(
                data: const [
                  {'title': 'Eu', 'value': Owner.me},
                  {'title': 'Dividido', 'value': Owner.divided},
                  {'title': 'Outro', 'value': Owner.other},
                ],
                groupValue: _owner,
                onChanged: (value) {
                  setState(() {
                    _owner = value as Owner;
                  });
                },
              ),
              if (_owner == Owner.other)
                TextField(
                  controller: _otherController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Outro',
                  ),
                  onSubmitted: (_) => _submitForm(),
                ),
              LabelSwtich(
                label: 'Fixar Compra para os meses seguintes?',
                value: _fixed,
                onChanged: (value) {
                  setState(() {
                    _fixed = value;
                  });
                },
              ),
              TagsRadioButton(
                tags: _tags,
                initialTag: _selectedTag!,
                onChanged: (tag) {
                  setState(() {
                    _selectedTag = tag;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;
    final pixDest = _pixDestController.text;

    _ownerDesc = switch (_owner) {
      Owner.me => _owner.name,
      Owner.divided => _owner.name,
      Owner.other => _otherController.text,
    };

    if (title.isEmpty ||
        value <= 0 ||
        (_owner == Owner.other && _ownerDesc.isEmpty)) {
      return;
    }

    _onSubmit!(
      Transaction(
        title: title,
        value: value,
        date: _selectedDate,
        fixed: _fixed,
        tag: _selectedTag!,
        installments: _selectedInstallments,
        owner: _owner,
        ownerDesc: _ownerDesc,
        payment: _payment,
        pixDest: pixDest,
      ),
    );

    Navigator.pop(context);
  }
}
