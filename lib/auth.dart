import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(
      String email, String password, String name);

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name);

  Future<User> currentUser();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendEmailVerification();

  Future<void> resetPassword(String emails);
//Future<String> getUserId(String id);

}

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance;

  Future<bool> isEmailVerified() async {
    User user = await _auth.currentUser;
    return user.emailVerified;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password, String name) async {
    UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User currentUsers = await _auth.currentUser;

    return currentUsers.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    print("heraaaaaaaaaaaaaaaaaaae");
    print(email);
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("heraaaaaaaaaaaaaaaaaaae");
    User user = await _auth.currentUser;
    try {
      await user.sendEmailVerification().catchError((onError) {
        print("errororororo" + onError.code);
      });

      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }

  Future<void> resetPassword(String emails) async {
    _auth.sendPasswordResetEmail(email: emails);

    //return AlertDialog(title: Text("Thanks"),content:Text("Please verify"),);
  }

  Future<void> sendEmailVerification() async {
    User user = await _auth.currentUser;
    user.sendEmailVerification();

    //return AlertDialog(title: Text("Thanks"),content:Text("Please verify"),);
  }

  Future<User> currentUser() async {
    User user = await _auth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
