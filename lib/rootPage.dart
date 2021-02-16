import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'loginPage.dart';
import 'auth.dart';
import 'homePage.dart';
import 'dart:async';

class RootPage extends StatefulWidget {
  @override
  RootPage({this.auth});

  final BaseAuth auth;

  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  @override
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String userId;

  void initState() {
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
      widget.auth.currentUser().then((onValue) async {
        if (onValue == null) {
          return;
          //no
        }
        FirebaseFirestore.instance
            .collection("users")
            .where('userID', isEqualTo: onValue.uid)
            .get()
            .then((value) {
          print("here is my document id");
          print(value.docs.first.id);

          setState(() {
            print("I set ur state m8");

            // I don't get this also
            print("value meal" + onValue.uid);

            userId = value.docs.first.id;

            print("name is " + userId);
          });
        });
      });
    });
  }

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  void _signedIn() async {
    widget.auth.currentUser().then((onValue) async {
      await FirebaseFirestore.instance
          .collection("users")
          .where('userID', isEqualTo: onValue.uid)
          .get()
          .then((value) {
        print("here is my document id");
        print(value.docs.first.id);
        userId = value.docs.first.id;
        setState(() {
          final FirebaseAuth _auth = FirebaseAuth.instance;

          authStatus = AuthStatus.signedIn;
        });
      });
    });
  }

  Future<String> getUserId() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser;
    return user.uid;
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  Widget build(BuildContext context) {
    if (authStatus == AuthStatus.notSignedIn) {
      LoginPage ll = new LoginPage(auth: widget.auth, onSignedIn: _signedIn);
      return ll;
    }
    if (authStatus == AuthStatus.signedIn) {
//print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"+userId);
      return new HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
        name: userId, //or name being weird
      );
    }
  }
}
