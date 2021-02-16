import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatefulWidget
{
  @override
  final String name;
  AddUser({this.name});
  _AddUserState createState() => _AddUserState(name);
}

class _AddUserState extends State<AddUser> {
  @override
  _AddUserState (this.name);
  String name;
  Widget build(BuildContext context) {



    return null;
  }
}
