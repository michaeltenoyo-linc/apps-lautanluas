import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/shared/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        WelcomeBackground(
          assetUrl: 'assets/images/backgrounds/welcome_bg2.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                //Pop Current Screen
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kLightColor,
              ),
            ),
            title: Text(
              'Forgot Password',
              style: kTextLightBoldXl,
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.5,
                  child: Text(
                    'Please enter your username/e-mail and we will inform IT team to confirm and reset your password.',
                    style: kTextLightXl,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                WelcomeInput(
                  controller: email,
                  size: size,
                  icon: Icon(
                    FontAwesomeIcons.envelope,
                    size: 26,
                    color: kLightColor,
                  ),
                  hintText: 'Email/Username',
                ),
                SizedBox(
                  height: 20,
                ),
                WelcomeButton(
                  size: size,
                  text: 'Send',
                  color: kColorsBlue700,
                  onClick: () {},
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
