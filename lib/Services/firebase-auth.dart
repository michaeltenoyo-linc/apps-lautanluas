import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ltl_bulk/Models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //Create user object base on FirebaseUser
  ModelUser? _userFromFirebaseUser(User user) {
    return user != null ? ModelUser(uid: user.uid) : null;
  }

  // Sign In Anonymus
  Future signInAnonymus() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User? user = credential.user;

      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign In Email and Password

  //Register Email and Password

  //Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
