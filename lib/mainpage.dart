import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketprayer2/readPrayer.dart';
import 'package:http/http.dart' as http;
import 'package:pocketprayer2/juz.dart';
import 'package:pocketprayer2/recitePrayer.dart';
import 'managePrayer.dart';
import 'dart:convert';


import 'createPrayer.dart';



class MainPage extends StatefulWidget
{
MainPage({this.name});
String name;

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  Widget build(BuildContext context) {
   return new Scaffold(
     floatingActionButton:  FloatingActionButton.extended(
       backgroundColor:  Color.fromRGBO(224,208,192,1),
       label: Text("Admin Only",style: TextStyle(color: Colors.black),),onPressed: ()async {
       String userName = " foo";
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => ManagePrayer(name: this.widget.name,userID: userName,)),
       );
     }
       ,

     ),
body: Container(decoration:BoxDecoration(image: DecorationImage(image: AssetImage("images/DV38ZaXMQmaOR1ng-dbXcQ.jpg"),fit: BoxFit.cover,)),child:Column(children: <Widget>[

  Center(
 child:Text("")
  ),
  SizedBox(height: 50),
    ButtonTheme(
    minWidth: 180.0,
    height: 180.0,
        padding: EdgeInsets.all(00),
 child: RaisedButton(
     shape: RoundedRectangleBorder(side: BorderSide(width:4,color: Color.fromRGBO(159, 93, 22,1))),
   color: Color.fromRGBO(224,208,192,1),
    child: Text(' Create a Khatmul Quran  \n          (admin only)',style: TextStyle(color: Colors.black,fontSize: 25)),
    onPressed:()async {





      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePrayer(name:widget.name)),
      );
    }

      )),
  SizedBox(height: 39),
      ButtonTheme(
      minWidth: 180.0,
      height: 180.0,
 child: RaisedButton(
   shape: RoundedRectangleBorder(side: BorderSide(width:4,color: Color.fromRGBO(159, 93, 22,1))),
   padding: EdgeInsets.all(00),
   color: Color.fromRGBO(224,208,192,1),
    child: Text('  Recite Khatmul Quran   \n            (reciters) ',style: TextStyle(color: Colors.black,fontSize: 25),),
    onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadPrayer(name:widget.name)),
      );
    },
  ),),








      ],)

      ));
      }
}
