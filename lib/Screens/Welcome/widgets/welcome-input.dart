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
  }) : super(key: key);

  final Size size;
  final Icon icon;
  final String hintText;
  final bool isHidden;
  final TextInputAction onEnter;
  final TextInputType type;

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
          child: TextField(
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
