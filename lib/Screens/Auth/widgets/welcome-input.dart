import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class WelcomeInput extends StatelessWidget {
  const WelcomeInput({
    Key? key,
    required this.size,
    required this.icon,
    required this.hintText,
    this.isHidden = false,
    this.onEnter = TextInputAction.next,
    this.type = TextInputType.name,
    required this.controller,
  }) : super(key: key);

  final Size size;
  final Icon icon;
  final String hintText;
  final bool isHidden;
  final TextInputAction onEnter;
  final TextInputType type;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: TextFormField(
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }),
            controller: this.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: this.icon,
              ),
              hintText: this.hintText,
              hintStyle: kTextLightXl,
            ),
            obscureText: this.isHidden,
            style: kTextLightXl,
            keyboardType: this.type,
            textInputAction: this.onEnter,
          ),
        ),
      ),
    );
  }
}
