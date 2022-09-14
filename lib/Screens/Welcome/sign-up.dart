import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Welcome/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        WelcomeBackground(
          assetUrl: 'assets/images/backgrounds/welcome_bg3.png',
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
              'Request Account',
              style: kTextLightBoldXl,
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: size.width * 0.03,
                    backgroundColor: kColorsBlue,
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: kLightColor,
                      size: size.width * 0.03,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width * 0.5,
                    child: Text(
                      'Please send you account data, and we will confirm you account registration request as soon as possible.',
                      style: kTextLightXl,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  WelcomeInput(
                    size: size,
                    icon: Icon(
                      FontAwesomeIcons.user,
                      size: 26,
                      color: kLightColor,
                    ),
                    hintText: 'Username',
                  ),
                  WelcomeInput(
                    size: size,
                    icon: Icon(
                      FontAwesomeIcons.envelope,
                      size: 26,
                      color: kLightColor,
                    ),
                    hintText: 'Email',
                  ),
                  WelcomeInput(
                    size: size,
                    icon: Icon(
                      FontAwesomeIcons.lock,
                      size: 26,
                      color: kLightColor,
                    ),
                    hintText: 'Password',
                    isHidden: true,
                  ),
                  WelcomeInput(
                    size: size,
                    icon: Icon(
                      FontAwesomeIcons.lock,
                      size: 26,
                      color: kLightColor,
                    ),
                    hintText: 'Confirm Password',
                    isHidden: true,
                    onEnter: TextInputAction.done,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  WelcomeButton(
                    size: size,
                    text: 'Request',
                    color: kColorsBlue700,
                    onClick: () {},
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
