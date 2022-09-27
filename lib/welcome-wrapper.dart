import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ltl_bulk/Screens/Auth/welcome-screens.dart';
import 'package:ltl_bulk/Screens/Global/dashboard.dart';
import 'package:ltl_bulk/Services/firebase-auth.dart';

class WelcomeWrapper extends StatelessWidget {
  const WelcomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _auth.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return Dashboard();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
