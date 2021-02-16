import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketprayer2/recitePrayer.dart';
import 'viewPrayers.dart';

class ReadPrayer extends StatefulWidget {
  @override
  _ReadPrayerState createState() => _ReadPrayerState();
  String name;

  ReadPrayer({this.name});
}

class _ReadPrayerState extends State<ReadPrayer> {
  final _formKey = GlobalKey<FormState>();
  String password;

  Widget build(BuildContext context) {
    return Container(color: Colors.white70,child:Scaffold(
        appBar: AppBar(title: Text("Read Khatmul Quran")),
        body: Column(children: [Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "password",
                      hintText: "The password for the prayer"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password cannot be empty';
                    }

                    return null;
                  },
                  onSaved: (value) => password = value),
              RaisedButton(
                child: Text("Join"),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromRGBO(224, 123, 57, 1), width: 4),
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () async {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    QuerySnapshot numdocs = await FirebaseFirestore.instance
                        .collection("quranKhwani")
                        .where("password", isEqualTo: password)
                        .get();
                    int docLength = numdocs.docs.length;
                    String id = numdocs.docs.first.id;
                    Map<String,dynamic> quranKhwaniData = numdocs.docs.first.data();
                    String blurbs = quranKhwaniData["blurb"];
                    String prayerNames =
                        quranKhwaniData["prayerName"];
                    if (docLength == 0) {
                      _formKey.currentState.reset();
                    } else {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewPrayers(name:widget.name,docID: id,blurb: blurbs,prayerName:prayerNames ,)));
                      // have a streambuilder to listen for new
                      // get room with pass = pass


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Example01(
                                    name: widget.name,
                                    docID: id,
                                    blurb: blurbs,
                                    prayerName: prayerNames,
                                  )));
                    }
                  }
                },
              ),SingleChildScrollView(child:StreamBuilder(stream: FirebaseFirestore.instance.collection("users").doc(widget.name).collection("userJuz").snapshots(),builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
return GridView.builder(shrinkWrap:true,itemCount:snapshot.data.docs.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 10) ,itemBuilder:(BuildContext context,int index){return Container(height:200,width:200,child:Column(children: [RaisedButton(onPressed: null),Image.asset("images/DV38ZaXMQmaOR1ng-dbXcQ.jpg")]));},);
              } )
              )]))])));
  }
}
