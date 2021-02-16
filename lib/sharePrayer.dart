import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'mainpage.dart';

class SharePrayer extends StatefulWidget {
  @override
  _SharePrayerState createState() => _SharePrayerState();

  SharePrayer({this.passCode, this.name, this.blurb, this.dateCompletion});

  String passCode;
  String name;
  String blurb;
  String dateCompletion;
//gets passed in from main page to manage
}

class _SharePrayerState extends State<SharePrayer> {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Share Khatmul Quran (admin)"),
            ),
            body: Column(children: <Widget>[
              Container(
                width: 10,
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(224, 208, 192, 1), width: 5)),
                  child: Column(children: <Widget>[
                    Text(widget.blurb + "\n",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                   Align( alignment:Alignment.centerLeft, child:Text("Khatmul dua will be recited by " + widget.dateCompletion + "\n",style: TextStyle(fontSize:20 ),)),
                    Text(
                      "Download app & create an account.\nClick “Recite Khatmul Quran” & add password   " +
                          widget.passCode +
                          "\n",
                      style: TextStyle(fontSize: 20),
                    )
                  ])),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\nAdmin:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              Text(
                  "You have successfully created the Khatmul Quran. Share below\n",
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              RaisedButton(
                  color:Color.fromRGBO(224,208,192,1),
                child: Text("      Share     ",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold )),
                onPressed: () {
                  FlutterShareMe().shareToSystem(
                      msg: widget.blurb +
                          "\n\nDownload app & create an account.Go to “Recite Khatmul Quran” & add password   " +
                          widget.passCode + "\nwww.google.com"
                          "\n",);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ;
                },
              )
            ])));
  }
}
