import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    Key? key,
    required this.assetUrl,
  }) : super(key: key);

  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(assetUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            )),
      ),
    );
  }
}
