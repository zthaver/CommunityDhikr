import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'roomLoginDetails.dart';
import 'addPrayer.dart';

class AdminOptions extends StatelessWidget
{
AdminOptions({this.id,this.password,this.userId});
String id;
String password;
String userId;

  Widget build(BuildContext context)
  {
    return Scaffold(
appBar: AppBar(title: Text("Admin Options"),),
      body:Column
        (
        children: <Widget>[
          RaisedButton(child: Text("Show Joining Information"), onPressed:()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomLoginDetail(roomID: id,password: password,)));
          }),
           RaisedButton(child: Text("Add A Prayer"),onPressed:   ()
           {Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPrayer(id:id ,)));
           })

        ],
      )

    );
  }
}