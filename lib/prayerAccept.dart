import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PrayerAccept extends StatefulWidget
{
  @override
  _PrayerAcceptState createState() => _PrayerAcceptState();
  String name;
  String docID;
  DocumentSnapshot doc;
  int juzNumber;
  PrayerAccept({this.juzNumber,this.name,this.docID,this.doc});
}

class _PrayerAcceptState extends State<PrayerAccept> {
  Widget build (BuildContext context)
  {
    return Scaffold(body: Column(children:[Card(child: Text("You are about to agree to pray  juz ${widget.juzNumber}. If you do not complete it within 7 days it will be reassigned automatically to another user.",style: TextStyle(fontSize: 28)),),
      RaisedButton(child: Text("Assign prayer"),onPressed: () async{



       await FirebaseFirestore.instance.collection("tasks").add({
          'prayerId': widget.docID,
          'juzId': widget.doc.id,
          'status': "scheduled",
          'performAt': DateTime.now().add(Duration(minutes: 2))
        });
        await FirebaseFirestore.instance.collection("checkTime").add({
          'prayerId': widget.docID,
          'juzId': widget.doc.id,
          'status': "scheduled",
          'performAt': DateTime.now().add(Duration(minutes: 1))
        });

      print("daaaaaaaaaaaaaaaaaaaaate");
      print(      DateTime.now().toUtc());
      await widget.doc.reference.update({
        'assignedUserId': widget.name ,
        'Status': "In Progress",
        'assignedUser': "bar",
        'timeAssigned': FieldValue.serverTimestamp(),
        'numDays' : 700
      });Navigator.pop(context);},)]));

  }
}
