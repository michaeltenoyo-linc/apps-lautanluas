import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class HomepageMenuBox extends StatelessWidget {
  const HomepageMenuBox({
    Key? key,
    required this.size,
    required this.text,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  final Size size;
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: kLightColor,
          borderRadius: BorderRadius.circular(
            20,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 20),
              blurRadius: 20,
              spreadRadius: -23,
              color: kDarkColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: this.onTap,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.04,
                  ),
                  child: SvgPicture.asset(
                    this.iconPath,
                    height: size.height * 0.25,
                  ),
                ),
                Text(
                  this.text,
                  style: kTextDarkBold5Xl,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
