import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.nextNode,
    required this.initValue,
    required this.labelText,
    this.keyboardType,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final String initValue;
  final String labelText;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;

  void _nextField(BuildContext context) {
    focusNode!.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.zero,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 155, 155, 155),
          ),
        ),
      ),
      onSubmitted: onSubmitted ?? (_) => _nextField(context),
    );
  }
}
