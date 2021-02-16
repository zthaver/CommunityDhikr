import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
  ResetPassword({this.auth});
  Auth auth;
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String foo;
  String resetPasswordError = "";
  String success = "";
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.mail),
                      labelText: "Email",
                      hintText: "Please enter your email"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => foo = value),
              Text("\n"),
              RaisedButton(
                  color: Color.fromRGBO(224, 208, 192, 1),
                  child: Text("Reset Password",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: foo)
                          .then((value) {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Please check your email'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    var count = 0;
                                    Navigator.popUntil(context, (route) {
                                      return count++ == 2;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }).catchError((onError) {
                        print(onError.message);
                        setState(() {
                          resetPasswordError = "Invalid Email Address";
                        });
                      });
                      //  Scaffold.of(context)
                      //.showSnackBar(SnackBar(content: Text('Password Reset instructions have been sent to your email')));
                    }
                  }),
              resetPasswordError == ""
                  ? Container()
                  : Text(resetPasswordError,
                      style: TextStyle(color: Colors.red)),
            ])));
  }
}
