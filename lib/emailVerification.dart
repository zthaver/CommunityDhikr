import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'auth.dart';
import 'rootPage.dart';
class EmailVerification extends StatefulWidget
{
EmailVerification({this.auth,this.email});
final BaseAuth auth;
String email;


  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
FirebaseAuth auth;

bool _isUserEmailVerified = false;

Timer _timer;

@override
void initState() {
super.initState();
  // ... any code here ...
  Future(() async {
    //Checks every 5 seconds for email verification
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser..reload();
      var user = await FirebaseAuth.instance.currentUser;
      user.sendEmailVerification();
      if (user.emailVerified) {
        timer.cancel();
      Navigator.push(context, MaterialPageRoute(builder: (context) => RootPage(auth: widget.auth)));

      }
    });
  });
}

@override
void dispose() {
  super.dispose();
  if (_timer != null) {
    _timer.cancel();
  }
}

  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(children: [Center(child:Card(child: Text("An  Email Has been sent to your email account : ${widget.email}. ${_isUserEmailVerified} "),),),
        _isUserEmailVerified?Text("You have not verified your email"):Text("You have verified")
      ],)

    );

  }
}