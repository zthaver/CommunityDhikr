import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'createPrayer.dart';
import 'mainpage.dart';
import 'prayerDetail.dart';
import 'viewPrayers.dart';
import 'testing.dart';

class JoinPrayer extends StatefulWidget {
  @override
  JoinPrayer(this.name);

  final String name;

  _JoinPrayerState createState() => _JoinPrayerState();
}

class _JoinPrayerState extends State<JoinPrayer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter the Prayer Code provided to you"),
      ),
      body: JoinForm(name: widget.name),
    );
  }
}

class JoinForm extends StatefulWidget {
  @override
  JoinForm({this.name});

  final String name;

  JoinFormState createState() {
    return JoinFormState(name: name);
  }
}

class JoinFormState extends State<JoinForm> {
  JoinFormState({this.name});

  String name;
  String password;
  String accessCode;
  bool _isInAsyncCall = false;
  bool _isInvalidPassword = false;
  bool _isInvalidCode = false;
  bool _hasLoggedIn = false;
  bool _isAcessingRoom = false;
  final _joinFormKey = GlobalKey<FormState>();

  @override
  String _validatePassword(String password) {
    if (password.length == 0) {
      return 'Password cannot be empty!';
    }
    if (_isInvalidPassword) {
      _isInvalidPassword = false;
    }
    return null;
  }

  String _validateAccessCode(String accessCode) {
    if (accessCode.length == 0) {
      return 'Access code cannot be empty';
    }
    if (_isInvalidCode) {
      return 'Invalid Access Code';
    }
  }

  void _submit() async {
    if (_joinFormKey.currentState.validate()) {
      _joinFormKey.currentState.save();

      FocusScope.of(context).requestFocus(new FocusNode());

      setState(() {
        _isInAsyncCall = true;
      });
      _hasLoggedIn = true;
      setState(() async {
        await FirebaseFirestore.instance
            .collection("prayerRooms")
            .where('password', isEqualTo: password)
            .get()
            .then((onValue) {
          if (onValue.docs.length == 0) {
            _isInvalidPassword = true;
            _isAcessingRoom = false;
            //invalid password
          } else {
            print(onValue.docs[0].data()['accessCode']);
            if (onValue.docs[0].data()['accessCode'] == accessCode) {
              _isInvalidPassword = false;
              _isAcessingRoom = true;
            } else {
              _isInvalidPassword = true;
              _isAcessingRoom = false;
            }
          }
        });
        if (_isAcessingRoom) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPrayers(
                        name: name,
                      )));
          String prayerName = "";
          var document = await FirebaseFirestore.instance
              .collection('prayerRooms')
              .doc(password);
          document.get().then((val) {
            prayerName = val['prayerName'];
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(name)
              .collection('prayers')
              .add({
            'prayerName': FieldValue.arrayUnion([prayerName]),
            'roomName': prayerName,
            'prayerRoomId': password,
            'totalCount': 0,
            'prayerCount': FieldValue.arrayUnion([0]),
            'targets': FieldValue.arrayUnion([0])
          });
          await FirebaseFirestore.instance
              .collection('prayerRooms')
              .doc(password)
              .collection('users')
              .add({
            'userId': name,
            'roomName': prayerName,
          });
        } else {
          setState(() {
            _isInAsyncCall = false;
          });
        }
      });
    }
  }

  Widget build(BuildContext context) {
    _joinFormKey.currentState?.validate();
    return Scaffold(
      body: ModalProgressHUD(
        child: Container(
          child: Form(
            key: _joinFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Room ID", icon: Icon(Icons.person)),
                  validator: (value) => _validatePassword(value),
                  onSaved: (value) => password = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Room Password", icon: Icon(Icons.lock)),
                  validator: (value) => _validateAccessCode(value),
                  onSaved: (value) => accessCode = value,
                ),
                RaisedButton(
                  onPressed: _submit,
                  child: Text("Join Room"),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _hasLoggedIn
                        ? (_isAcessingRoom
                            ? Text(
                                'Successfully accessed room',
                                key: Key("loggedIn"),
                              )
                            : Text(
                                "Invalid code",
                                key: Key("invalidCode"),
                              ))
                        : Text(" "))
              ],
            ),
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
