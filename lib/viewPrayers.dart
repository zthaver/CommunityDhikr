import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart";
import 'prayerAccept.dart';
import 'dayWarning.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'juzText.dart';


class ViewPrayers extends StatefulWidget
{



  @override
  ViewPrayers({this.name,this.docID,this.blurb,this.prayerName});
 final String name;
 final String docID;
 final String blurb;
 final String prayerName;

  _ViewPrayerState createState() =>  _ViewPrayerState(name);

}

class _ViewPrayerState extends State<ViewPrayers>
{
  _ViewPrayerState(this.name);
  String name;
  String username = "";
  String userID;

  bool pressedButtonActive = true;
  String foo = " dino";
  List<bool> startPressed = new List<bool>.filled(30, false);
  bool continuePressed = false;
  final databaseReference = FirebaseFirestore.instance;

Widget _buildListItem (BuildContext context,DocumentSnapshot doc,int index)
{

if(index ==0)
  {
    // If it is the first Index, show the title card
    return GridTile( child: Card(key:ValueKey(1),shape: new RoundedRectangleBorder(),child:Column(children:<Widget>[new Expanded(child:Text(widget.prayerName,style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold))),Expanded(child:Text(widget.blurb,style: TextStyle(fontSize: 28))),Spacer(flex: 2)])));

  }

else {


// Else it is a regular card with all the Prayer Information
  return RaisedButton(child: Text("a"),);




}
}
  Widget build(BuildContext context)
  {

return Container(child: Scaffold(backgroundColor: Colors.transparent,

    appBar: AppBar(title: Text("View Quran Room "),backgroundColor: Colors.blueAccent,),
body: Container(height: 900,child:StreamBuilder(

  stream: FirebaseFirestore.instance.collection('quranKhwani').doc(widget.docID).collection("juz").orderBy("juzNumber").snapshots(),
  builder: (context,snapshot)
    {


      if(!snapshot.hasData)return const Text("Loading..");
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=>


        _buildListItem(context,snapshot.data.documents[index],index),
        itemCount: snapshot.data.documents.length,
                              );
    }
))
));
  }

}