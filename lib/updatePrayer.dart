import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pocketprayer2/sharePrayer.dart';
import 'auth.dart';
import 'package:random_string/random_string.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";




class UpdatePrayer extends StatefulWidget {
  @override
  UpdatePrayer({this.name,this.snap,this.password,this.prayerBlurb,this.roomName});
  final String name;
  DocumentSnapshot snap;
  String prayerBlurb;
  String password;
  String roomName;
  int numDays;


  _UpdatePrayerState createState() => _UpdatePrayerState();
}

class _UpdatePrayerState extends State<UpdatePrayer> {
  @override


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Edit A Khatmul Quran (Admin)'),),
      body: MyCustomForm(name: widget.name,prayerBlurb: widget.prayerBlurb,roomName: widget.roomName,snap: widget.snap,),



    );



  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomForm({this.name,this.snap,this.password,this.prayerBlurb,this.roomName});
  String name;
  String password;
  DocumentSnapshot snap;
  String prayerBlurb;
  String roomName;


  MyCustomFormState createState() {
    return MyCustomFormState(name: name,password: password,snap: snap,prayerBlurb: prayerBlurb,roomName: roomName);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class MyCustomFormState extends State<MyCustomForm> {

  MyCustomFormState({this.name,this.snap,this.password,this.prayerBlurb,this.roomName});
  String name;
  String roomName;
  DocumentSnapshot snap;
  String password;
  String prayerBlurb;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String prayerName;
  String blurb;
  String accessCode;
  int newID =0;
  String passCode = "";
  String docID = "";
  bool _isInAsyncCall = false;
  int numDays = 3;

  BaseAuth auth;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ModalProgressHUD(inAsyncCall:_isInAsyncCall,progressIndicator:SpinKitCircle(color: Colors.white),child:Form(
        key: _formKey,
        child:SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[


            TextFormField(initialValue:widget.roomName,minLines:1,maxLength:50,maxLengthEnforced:true,decoration: const InputDecoration(icon: Icon(Icons.person),labelText: "Prayer Name",hintText: "The name you want to give your prayer"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the name of your prayer';
                  }
                  return null;
                },onSaved: (value) => prayerName = value


            ),


            TextFormField(minLines: 10,initialValue:widget.prayerBlurb,maxLength:350,maxLengthEnforced: true,decoration:const InputDecoration(icon: Icon(Icons.description),
                hintText: "A short description of your prayer"),maxLines: 12,validator: (value)
            {


              if(value.isEmpty)

              {
                return 'Please enter a description for your Khatmul Quran';
              }
              return null;
            },onSaved: (value) => blurb=value),
            Text("Choose the number of days to complete the quran below"),
            new DropdownButton<int>(

              hint: Text("Number of days for Khatmul Quran"),
              value: numDays,
              items: <int>[3,7,10,12,30,40].map((int value) {
                return new DropdownMenuItem<int>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (int value) { setState(() {
                numDays = value;
              });print(value);},
            ),



            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
               onPressed: () async {
                 _formKey.currentState.save();
                 if(widget.snap== null) {
                   print("you null mate");
                 }
                snap.reference.update({'roomName':prayerName});
    await FirebaseFirestore.instance.collection("quranKhwani").where("password",isEqualTo: widget.password).get().then((value) => value.docs[0].reference.update({'numDays':numDays,'blurb':blurb,'prayerName':prayerName}));Navigator.of(context).popUntil((route) => route.isFirst);},
               
               
                child: Text('Update your Khatmul Quran '),
            )
              ),

            

          ],
        )
        )

    ));

  }
}





