import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPrayer extends StatelessWidget
{
  AddPrayer({this.id,this.userId});
  String id;
  String userId;
  int target;
  String prayerName;
  Widget build(BuildContext context)
  {
    final _addPrayerKey = GlobalKey<FormState>();
   return Scaffold(
     appBar: AppBar(title:Text("Add A Prayer") ,),
     body:  Form
         (
         key:_addPrayerKey,
         child:
             SingleChildScrollView(child:
         Column(
           children: <Widget>[
             TextFormField(decoration:const InputDecoration(icon: Icon(Icons.book),labelText: "Prayer Name",
               hintText: "Name for your prayer"),maxLines: 1,validator: (value) {
             if (value.isEmpty) {
               return 'Access Code is blank';
             }
             return null;
           }
           ,onSaved: (value)=> prayerName = value,
           ),
             TextFormField(decoration: const InputDecoration(labelText: "Target"),validator: (value)
             {
               if (!isNumeric(value)) {

                 return 'Target must be a number';
               }
               return null;
             },
             onSaved: (value)=> target = int.parse(value),),
             RaisedButton(child: Text("Add Prayer"),
               onPressed: ()async{
               if(_addPrayerKey.currentState.validate())
                 {
                   _addPrayerKey.currentState.save();
                   await FirebaseFirestore.instance.collection("prayerRooms").doc(id).collection("prayers").add({
'prayerName':prayerName,
                     'target':target,
                     'total':0,
                     'completed': false
                   });
                  // Scaffold.of( context).showSnackBar(SnackBar(content: Text("Added your prayer"),));
                   Navigator.pop(context);
                 }
               },
             )
           ],

     ),),
   )
   );



  }
}