import 'package:flutter/material.dart';
import 'auth.dart';
import 'mainpage.dart';
import "dart:math";

class HomePage extends StatelessWidget
{
  void _signOut()async
  {
    try{
await auth.signOut();
onSignedOut();
    }catch(e)
    {
      print(e);
    }
  }
  @override
  HomePage({this.auth,this.onSignedOut,this.name});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String name;

  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

      appBar: AppBar(
        title: Text("Community Dhikr"),
        // this is homepage, it's body is main page
        actions: <Widget>[
          new FlatButton( child: new Text('Logout',style:new TextStyle(fontSize: 17,color: Colors.black)),onPressed: _signOut)
        ],
      ),
      body:  MainPage(name: name)
    );
    
  }
}