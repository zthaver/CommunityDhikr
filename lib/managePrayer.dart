import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pocketprayer2/deletePrayer.dart';
import 'package:pocketprayer2/updatePrayer.dart';
import 'package:share/share.dart';

class ManagePrayer extends StatefulWidget{
  @override
  _ManagePrayerState createState() => _ManagePrayerState();
  ManagePrayer({this.name,this.userID});
  String name;
  String userID;
  //gets passed in from main page to manage
}

class _ManagePrayerState extends State<ManagePrayer> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot doc, int index) {
    return ListTile(

      title: Card(child: Wrap(children: <Widget>[
        Text(doc["roomName"], style: TextStyle(fontSize: 28)),
        Text("Password", style: TextStyle(fontSize: 28)),
        Text(doc["password"].toString(), style: TextStyle(fontSize: 28)),
        RaisedButton(child: Text("Delete"), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DeletePrayer(prayerName: doc["roomName"],
                password: doc["password"],
                snap: doc,)));
        },),
        RaisedButton(child: Text("Edit"),
          onPressed: () async {
            String blurb;
            String prayerNames;
            await FirebaseFirestore.instance.collection("quranKhwani").where(
                "password", isEqualTo: doc['password']).get().then((value) {
              blurb = value.docs[0].data()['blurb'];
              prayerNames = value.docs[0].data()['prayerName'];
            }
            );
            ;
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                UpdatePrayer(snap: doc,
                  name: widget.name,
                  prayerBlurb: blurb,
                  roomName: prayerNames,)));
          },),
        RaisedButton(child: Text("Copy Password"), onPressed: () {
          Clipboard.setData(
              new ClipboardData(text: doc["password"].toString()));
        },)
      ], spacing: 90, // to apply margin in the main axis of the wrap
          runSpacing: 10)),
    );
  }

  Widget build(BuildContext context) {
    {
      return Scaffold(
          appBar: AppBar(title: Text("Admin Page")),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(
                  widget.name).collection("quranKhwani").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading..");
                return ListView.builder(
                  itemBuilder: (context, index) =>

                      _buildListItem(context, snapshot.data.docs[index], index),
                  itemCount: snapshot.data.docs.length,
                );
              }
          )
      );
    }
  }
}