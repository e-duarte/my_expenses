import 'package:flutter/material.dart';
import 'package:my_expenses/components/custom_text_field.dart';
import 'package:my_expenses/components/date_picker.dart';
import 'package:my_expenses/components/installments_dropdown.dart';
import 'package:my_expenses/components/label_switch.dart';
import 'package:my_expenses/components/radio_list.dart';
import 'package:my_expenses/components/tags_radio_button.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/services/tag_service.dart';

class TransactionUpdateForm extends StatefulWidget {
  const TransactionUpdateForm(this.transaction, this.onSubmit, {super.key});

  final Transaction transaction;
  final void Function(Transaction) onSubmit;

  @override
  State<TransactionUpdateForm> createState() => _TransactionUpdateFormState();
}

class _TransactionUpdateFormState extends State<TransactionUpdateForm> {
  TextEditingController? _titleController;
  TextEditingController? _valueController;
  TextEditingController? _otherController;
  TextEditingController? _pixDestController;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  Payment? _payment;
  bool? _fixed = false;
  int? _selectedInstallments = 1;
  DateTime? _selectedDate = DateTime.now();
  Owner? _owner = Owner.me;
  String? _ownerDesc = Owner.me.name;
  final _numberOfInstallments = 10;

  Tag? _selectedTag;
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();

    TagService().getTags().then((value) {
      setState(() {
        _tags = value;
      });
    });

    _titleController = TextEditingController(
      text: widget.transaction.title,
    );
    _valueController = TextEditingController(
      text: widget.transaction.value.toString(),
    );
    _otherController = TextEditingController(
      text: widget.transaction.ownerDesc,
    );
    _pixDestController = TextEditingController(
      text: widget.transaction.pixDest,
    );

    _selectedTag = widget.transaction.tag;
    _payment = widget.transaction.payment;
    _fixed = widget.transaction.fixed;
    _selectedInstallments = widget.transaction.installments;
    _selectedDate = widget.transaction.date;
    _owner = widget.transaction.owner;
    _ownerDesc = widget.transaction.ownerDesc;
  }

  void _submitForm() {
    final title = _titleController!.text;
    final value = double.tryParse(_valueController!.text) ?? 0.0;
    final pixDest = _pixDestController!.text;

    _ownerDesc = switch (_owner) {
      Owner.me => _owner!.name,
      Owner.divided => _owner!.name,
      Owner.other => _otherController!.text,
      _ => '',
    };

    if (title.isEmpty ||
        value <= 0 ||
        (_owner == Owner.other && _ownerDesc!.isEmpty)) {
      return;
    }

    widget.onSubmit(
      Transaction(
        id: widget.transaction.id,
        title: title,
        value: value,
        date: _selectedDate!,
        fixed: _fixed!,
        tag: _selectedTag!,
        installments: _selectedInstallments!,
        owner: _owner!,
        ownerDesc: _ownerDesc!,
        payment: _payment!,
        pixDest: pixDest,
      ),
    );

    // Navigator.pop(context);
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TagsRadioButton(
          tags: _tags,
          initialTag: _selectedTag!,
          onChanged: (tag) {
            setState(() {
              _selectedTag = tag;
            });
          },
        ),
        CustomTextField(
          controller: _titleController,
          focusNode: _focusNode1,
          nextNode: _focusNode2,
          initValue: widget.transaction.title,
          labelText: 'Título',
        ),
        CustomTextField(
          controller: _valueController,
          focusNode: _focusNode2,
          nextNode: _focusNode3,
          labelText: 'Valor (R\$)',
          initValue: widget.transaction.value.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        RadioList(
          data: const [
            {'title': 'Pix', 'value': Payment.pix},
            {'title': 'Pix-Crédito', 'value': Payment.pixCredit},
            {'title': 'Crédito', 'value': Payment.credit},
          ],
          groupValue: _payment!,
          onChanged: (value) {
            setState(() {
              _payment = value as Payment;
            });
          },
        ),
        if (_payment == Payment.pix || _payment == Payment.pixCredit)
          CustomTextField(
            focusNode: _focusNode3,
            controller: _pixDestController,
            initValue: widget.transaction.ownerDesc,
            labelText: 'Enviado para',
            onSubmitted: (_) => _submitForm(),
          ),
        if (_payment == Payment.credit)
          InstallmetsDropdown(
            transactionValue: double.tryParse(_valueController!.text) ?? 0.0,
            numberOfInstallments: _numberOfInstallments,
            initialValue: _selectedInstallments!,
            onChanged: (value) {
              setState(() {
                _selectedInstallments = value;
              });
            },
          ),
        DatePicker(
          selectedDate: _selectedDate!,
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
          groupValue: _owner!,
          onChanged: (value) {
            setState(() {
              _owner = value as Owner;
            });
          },
        ),
        if (_owner == Owner.other)
          CustomTextField(
            controller: _otherController,
            initValue: widget.transaction.ownerDesc,
            labelText: 'Outro',
            onSubmitted: (_) => _submitForm(),
          ),
        LabelSwtich(
          label: 'Fixar compra para os meses seguintes?',
          value: _fixed!,
          onChanged: (value) {
            setState(() {
              _fixed = value;
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tags.isNotEmpty
        ? _buildForm(context)
        : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
  }
}
