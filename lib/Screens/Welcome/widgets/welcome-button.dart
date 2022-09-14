import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
    required this.size,
    required this.text,
    required this.color,
    required this.onClick,
  }) : super(key: key);

  final Size size;
  final String text;
  final Color color;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: this.color,
      ),
      child: TextButton(
        onPressed: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(this.text, style: kTextLightXl),
        ),
      ),
    );
  }
}
