import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ltl_bulk/Screens/Welcome/login.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/shared/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      ),
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black54, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage('assets/images/backgrounds/welcome_bg2.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  )),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(children: [
            Flexible(
              child: Center(
                child: Container(
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/ltl.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                Text(
                  'Forgot Password',
                  style: kTextLightXl,
                ),
                SizedBox(
                  height: 20,
                ),
                WelcomeButton(
                  size: size,
                  text: 'Login',
                  color: kColorsBlue700,
                ),
                SizedBox(
                  height: 10,
                ),
                WelcomeButton(
                  size: size,
                  text: 'Sign Up',
                  color: kColorsLightBlue600,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ]),
        )
      ],
    );
  }
}

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
    required this.size,
    required this.text,
    required this.color,
  }) : super(key: key);

  final Size size;
  final String text;
  final Color color;

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
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(this.text, style: kTextLightXl),
        ),
      ),
    );
  }
}

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
