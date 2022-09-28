import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/widgets.dart';
import 'package:ltl_bulk/Services/firebase-auth.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();

  //Form
  final _loginForm = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        WelcomeBackground(
          assetUrl: 'assets/images/backgrounds/welcome_bg.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(children: [
                Flexible(
                  child: Center(
                    child: Text(
                      'Lautan Luas',
                      style: kTextLight6Xl,
                    ),
                  ),
                ),
                Form(
                  key: _loginForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      WelcomeInput(
                        controller: email,
                        size: size,
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                          size: 26,
                          color: kLightColor,
                        ),
                        hintText: 'Email',
                      ),
                      WelcomeInput(
                        controller: password,
                        size: size,
                        icon: Icon(
                          FontAwesomeIcons.lock,
                          size: 26,
                          color: kLightColor,
                        ),
                        hintText: 'Password',
                        isHidden: true,
                        onEnter: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, 'ForgotPassword'),
                        child: Text(
                          'Forgot Password',
                          style: kTextLightXl,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      WelcomeButton(
                        size: size,
                        text: 'Login',
                        color: kColorsBlue700,
                        onClick: () async {
                          if (_loginForm.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please wait...')),
                            );

                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                                    email.text, password.text);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Wrong Email/Password!')),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      WelcomeButton(
                          size: size,
                          text: 'Login Anonymously',
                          color: kColorsGrey700,
                          onClick: () async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please wait...'),
                              duration: Duration(milliseconds: 2000),
                            ));
                            dynamic result = await _auth.signInAnonymus();
                            result == null
                                ? ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text('Error! Please try again...'),
                                    duration: Duration(milliseconds: 2000),
                                  ))
                                : print(result.uid);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      WelcomeButton(
                        size: size,
                        text: 'Request Account',
                        color: kColorsLightBlue600,
                        onClick: () => Navigator.pushNamed(
                          context,
                          'SignUp',
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }
}
