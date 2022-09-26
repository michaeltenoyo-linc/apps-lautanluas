import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InputNumber extends StatelessWidget {
  const InputNumber({
    super.key,
    required this.controller,
    required this.icon,
    this.label = '',
    this.hintText = '',
    this.readOnly = false,
    this.inputAction = TextInputAction.done,
    this.initialValue = null,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final Icon icon;
  final bool readOnly;
  final TextInputAction inputAction;
  final dynamic initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      readOnly: readOnly,
      textInputAction: inputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        icon: icon,
      ),
      initialValue: initialValue,
    );
  }
}
