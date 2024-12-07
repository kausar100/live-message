import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Function(String input) onType;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.label, this.hint,
      required this.onType,
      required this.textInputAction,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: TextField(
        onChanged: onType,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            filled: true, fillColor: Colors.white, labelText: label, hintText: hint),
      ),
    );
  }
}
