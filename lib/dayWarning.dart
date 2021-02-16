import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayWarning extends StatefulWidget
{
  @override
  _DayWarningState createState() => _DayWarningState();
  int numDays;
  DayWarning({this.numDays});
}

class _DayWarningState extends State<DayWarning> {
  Widget build(BuildContext context)
  {
    return Scaffold(appBar: AppBar(title:Text("Assign Prayer")),body: Card(child: Text("Please be advised, you have"+ widget.numDays.toString() +"days left to finish praying this juz",style: TextStyle(fontSize: 28)),),);
  }
}