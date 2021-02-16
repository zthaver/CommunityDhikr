import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pocketprayer2/resetPassword.dart';
import 'auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _name;
  String _password;
  String loginError = "";
  String signUpError = "";
  FormType _formType = FormType.register;
  bool _isInAsyncCall = false;
  bool _isUserEmailVerified = false;
  Timer _timer;
  bool showPasswordSignUp = false;
  bool showPasswordLogIn = false;
  bool _wrongPassword = false;

  @override
  Future<void> listenUpdates() async {
    // ... any code here ...
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await widget.auth.currentUser()
          ..reload();
        bool test = await widget.auth.isEmailVerified();

        if (test) {
          setState(() {
            _isUserEmailVerified = test;

            widget.onSignedIn();
          });
          timer.cancel();
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> validatePassword() async {
    String userId =
        await widget.auth.signInWithEmailAndPassword(_email, _password, _name);
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isInAsyncCall = false;
      });

      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth
              .signInWithEmailAndPassword(_email, _password, _name)
              .catchError((error) {
            String loginError1 = "";
            print("erraaaaaaa" + error.code);
           /* setState(() {*/
             // loginError = error.toString();
              switch (error.code) {
                case "invalid-email":
                  loginError1 = "Invalid Email";
                  break;
                case "wrong-password":
                  loginError1 = "Wrong Password";
                  break;
                case "user-not-found":
                  loginError1 = "No user with this email address found";
                  break;
                case "firebase_auth":
                  loginError1 = "Please try again";
                  break;
              }
              showSignUpDialog("Community Dhikr", loginError1);
              return
              print("aaaaaaaaaa" + loginError1);
              _isInAsyncCall = false;
            });
         /* });*/

          if (userId == null) {
            return;
          }
          if(!_auth.currentUser.emailVerified){
            showSignUpDialog("Community Dhikr","A verification email has sent to your email address.Plz check your inbox & click on the link. We’ll wait!");
            return;
          }
          print(
              'Signed inaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: ${userId}');
          widget.onSignedIn();
        }
        if (_formType == FormType.register && formKey.currentState.validate()) {
          String user = await widget.auth
              .createUserWithEmailAndPassword(_email, _password, _name)
              .catchError((onError) {
            print("erorrroor" + onError.code);
            setState(() {
              switch (onError.code) {
                case "ERROR_INVALID_EMAIL":
                  signUpError = "Invalid Email";
                  break;
                case "email-already-in-use":
                  signUpError =
                      "This email is already registered. Please sign in or reset your password";
                  break;
              }
             return
             showSignUpDialog("Community Dhikr", signUpError);
              _isInAsyncCall = false;
            });
          }).then((value) async {
            DocumentReference ref = await FirebaseFirestore.instance
                .collection("users")
                .add({'userName': _name});

            User u = await _auth.currentUser;
            String id = u.uid;
            await FirebaseFirestore.instance
                .collection("users")
                .doc(ref.id)
                .update({'userID': id});
           // listenUpdates();
            showSignUpDialog("Community Dhikr","A verification email has sent to your email address.Plz check your inbox & click on the link. We’ll wait!");
          }).catchError((onError) {
            setState(() {});
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Community Dhikr'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: _formType == FormType.register
              ? Container(
                  child: new Stack(children: <Widget>[
                  new Container(
                      alignment: AlignmentDirectional.center,
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                      ),
                      child: new Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(10.0)),
                          width: 300.0,
                          height: 200.0,
                          alignment: AlignmentDirectional.center,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Center(
                                child: new SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: new CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(224, 208, 192, 1)),
                                    value: null,
                                    strokeWidth: 7.0,
                                  ),
                                ),
                              ),
                              new Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: new Center(
                                  child: new Text(
                                    "A verification email has sent to your email address.Plz check your inbox & click on the link. We’ll wait!",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )))
                ]))
              : SpinKitCircle(
                  color: Colors.white,
                ),
          child: new Container(
              child: new Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: new Column(
                        children: buildInputs() + buildSubmitButtons()),
                  ))),
        ));
  }
  Future<void> showSignUpDialog(String title , String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  List<Widget> buildInputs() {
    if (_formType == FormType.register) {
      return [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Create an account & participate in a Khatmul Quran.\n",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) {
            value.isEmpty ? 'Email cannot be empty' : null;
          },
          onSaved: (value) => _email = value.trim(),
        ),
        signUpError != ""
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  signUpError,
                  style: TextStyle(color: Colors.red),
                ))
            : Container(),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Name'),
          validator: (value) => value.isEmpty ? 'Name cannot be empty' : null,
          onSaved: (value) => _name = value,
        ), ///////
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password (8+ Characters)',
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  setState(() {
                    showPasswordSignUp = !showPasswordSignUp;
                  });
                },
              )),
          obscureText: showPasswordSignUp != true ? true : false,
          validator: (value) {
            if (value.length < 7) {
              return "The password must be 8 characters long";
            }

            return null;
          },
          onSaved: (value) => _password = value,
        ), ///////
      ];
    } else if (_formType == FormType.login) {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        loginError == "No user with this email address found" ||
                loginError == "Invalid Email"
            ? Align(
                child: Text(
                  loginError,
                  style: TextStyle(color: Colors.red),
                ),
                alignment: Alignment.centerLeft,
              )
            : Container(),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  setState(() {
                    showPasswordLogIn = !showPasswordLogIn;
                  });
                },
              )),
          obscureText: showPasswordLogIn ? false : true,
          validator: (value) {
            if (value.length == 0) {
              return "Password can't be empty";
            }

            return null;
          },
          onSaved: (value) => _password = value,
        ), ///////
        loginError == "Wrong Password"
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loginError,
                  style: TextStyle(color: Colors.red),
                ))
            : Container()
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
            color: Color.fromRGBO(224, 208, 192, 1),
            child: new Text('         Log in          ',
                style: new TextStyle(fontSize: 20.0)),
            onPressed: validateAndSubmit),
        new FlatButton(
            child: new Text('Forgot Password?',
                style: new TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPassword(
                            auth: widget.auth,
                          )));
            }),
        Text("\n\n"),
        new FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 4, color: Color.fromRGBO(159, 93, 22, 1))),
            child:
                new Text('Create account', style: new TextStyle(fontSize: 20)),
            onPressed: moveToRegister),
      ];
    } else {
      return [
        new FlatButton(
          shape: RoundedRectangleBorder(
              side:
                  BorderSide(width: 4, color: Color.fromRGBO(159, 93, 22, 1))),
          child:
              new Text('Create account', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        Text(
          "\nAlready have an account? Log in\n",
          style: TextStyle(fontSize: 18),
        ),
        new RaisedButton(
          color: Color.fromRGBO(224, 208, 192, 1),
          child: new Text('Log in  ', style: new TextStyle(fontSize: 20)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
