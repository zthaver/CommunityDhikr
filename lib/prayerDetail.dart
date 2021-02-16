

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'adminOptions.dart';

class PrayerDetail extends StatefulWidget
{
  @override
  PrayerDetail({this.name,this.blurb,this.prayerId,this.userId,this.password});
  String name;
  String blurb;
  String prayerId;
  String userId;
  String password;
  _PrayerDetailState createState() => _PrayerDetailState(name: name,blurb:blurb,prayerId: prayerId,userId: userId,password: password);
}

class _PrayerDetailState extends State<PrayerDetail> {
@override
_PrayerDetailState({this.name,this.blurb,this.prayerId,this.userId,this.password});
String name;
String blurb;
String prayerId;
String userId;
String password;

Future<Widget> adminScreen () async
{
  print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  print(name);
  QuerySnapshot test = await FirebaseFirestore.instance.collection("prayerRooms").doc(prayerId).collection("admin").where("adminId",isEqualTo: userId).get();
  print ("The length of the test is");
  print(test.docs.length);
  if(test.docs.length == 1)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminOptions(id: prayerId,password:password , userId: userId,) ));
    }
 return(Text("You are not an Admin!"));
}
Widget _buildListItem(BuildContext context,DocumentSnapshot doc)
{
  return ListTile(
      title: Row(children: <Widget>[
        Expanded(child: Text(doc['prayerName']),),

        Expanded(child: Text(doc['total'].toString()),),
        Expanded(child: Text(doc['target'].toString()),),
        Expanded(child: doc['completed']?Icon(Icons.event_busy):Icon(Icons.event_available)),

      ],) ,
      onTap: () async  {
        setState(() {
         if(doc['total'] <= doc['target'])
           {
             FirebaseFirestore.instance.collection("prayerRooms").doc(prayerId).collection("prayers").doc(doc.id).update({
               'total': FieldValue.increment(1)
             });
           }
         else
           {
             FirebaseFirestore.instance.collection("prayerRooms").doc(prayerId).collection("prayers").doc(doc.id).update({
               'completed' : true
             });

           }

        });


      }
  );
}
  Widget build(BuildContext context) {

    return Scaffold
      (
      appBar: AppBar(centerTitle: true,title: Text(name),),
      body: Column(children: <Widget>[
       Text("Prayer Description\n",style: TextStyle(fontSize: 20),),
        Card(child:Text(blurb)),
       RaisedButton(child: Text("Admin Options"),color: Colors.red,onPressed:adminScreen ,),
        Expanded(child:SizedBox(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('prayerRooms').doc(prayerId).collection("prayers").snapshots(),
            builder: (context,snapshot)
            {
              if(!snapshot.hasData)return const Text("Loading..");
              return ListView.builder(
                itemBuilder: (context,index)=>
                    _buildListItem(context,snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
        )
        )
        )
      ],),
    );
    // TODO: implement build

  }
}