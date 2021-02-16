import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomLoginDetail extends StatelessWidget
{
  RoomLoginDetail({this.roomID,this.password});
final roomID;
  final  password;
  Widget build(BuildContext context)
  {
    return Scaffold( appBar :AppBar(title: Text("Room Login Information"),),body: Card(child: Text("Username:$roomID\n Password $password"),));
  }
}