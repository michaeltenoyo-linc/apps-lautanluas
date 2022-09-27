import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ltl_bulk/Services/firebase-auth.dart';

//Pallete
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/shared/colors.dart';

//Widgets
import 'package:ltl_bulk/Screens/Auth/widgets/widgets.dart';

//Screens
import 'package:ltl_bulk/Screens/Auth/welcome-screens.dart';
import 'package:ltl_bulk/Screens/Load/load-screens.dart';
import 'package:ltl_bulk/Screens/Global/global-screens.dart';
import 'package:ltl_bulk/welcome-wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
      title: 'Lautan Luas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeWrapper(),
        'Login': (context) => Login(),
        'ForgotPassword': (context) => ForgotPassword(),
        'SignUp': (context) => SignUp(),
        'home/dashboard': (context) => Dashboard(),
        'load/create': (context) => CreateLoad(),
      },
    );
  }
}
