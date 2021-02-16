import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeletePrayer extends StatefulWidget
{
  @override
  DeletePrayer({this.prayerName,this.password,this.snap});
  String prayerName;
  String password;
  DocumentSnapshot snap;
  _DeletePrayerState createState() => _DeletePrayerState();
}

class _DeletePrayerState extends State<DeletePrayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Delete Khatmul Quran"),),body: Column(children: <Widget>[
      Text("Are you sure you want to delete " + widget.prayerName,style: TextStyle(fontSize: 20), ),
      RaisedButton(child:Text("Delete"),onPressed: ()async{await widget.snap.reference.delete();
      await FirebaseFirestore.instance.collection("quranKhwani").where("password",isEqualTo: widget.password).get().then((value) => value.docs[0].reference.delete());Navigator.pop(context);},)
    ],),);

  }
}