import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pocketprayer2/sharePrayer.dart';
import 'auth.dart';
import 'package:random_string/random_string.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

class CreatePrayer extends StatefulWidget {
  @override
  CreatePrayer({this.name});

  final String name;

  _CreatePrayerState createState() => _CreatePrayerState();
}

class _CreatePrayerState extends State<CreatePrayer> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Create A Quran Khwani';

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Khatmul Quran (admin)'),
      ),
      body: MyCustomForm(name: widget.name),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomForm({this.name});

  String name;

  MyCustomFormState createState() {
    return MyCustomFormState(name: name);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class MyCustomFormState extends State<MyCustomForm> {
  MyCustomFormState({this.name});

  String name;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String prayerName;
  String blurb;
  String accessCode;
  int newID = 0;
  String passCode = "";
  String docID = "";
  bool _isInAsyncCall = false;
  String selectedDateText = " Select a date ";
  String dateSelectionError = "";
  Map monthToString = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'Aug',
    9: 'Sept',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  int numDays = 3;
  DateTime selectedDate = null;
  var _controller = TextEditingController(
      text:
      "Assalam alaykum (السلام عليكم)\n\nYou are requested to participate in the recitation (tilāwa) of a complete sipāra/juz' of the Holy Quran for Marhūm/Marhūma who passed away \n\nThe Holy Prophet (s) have instructed us to gift the deceased with good deeds. We are hopeful that our participation in the Quran tilāwa will attract Divine mercy unto the souls of our marhūmīm and get them a place in the Paradise.Jazakallah Khair");
  BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        progressIndicator: SpinKitCircle(color: Colors.white),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        initialValue: "Khatmul Quran For ",
                        minLines: 1,
                        maxLength: 50,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.edit),
                            labelText: "Khatmul Quran Name",
                            hintText: "The name you want to give your prayer"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the name of your prayer';
                          }
                          return null;
                        },
                        onSaved: (value) => prayerName = value),
                    Container(
                        child: Text(
                          "Personalize template below or create your own\n",
                          style: TextStyle(fontSize: 17),
                        )),
                    TextFormField(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        controller: _controller,
                        minLines: 10,
                        maxLength: 450,
                        maxLengthEnforced: true,
                        decoration: const InputDecoration(
                            labelText: "Template",
                            suffixIcon: Icon(Icons.edit),
                            hintText: "A short description ",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 208, 192, 1),
                                  width: 5),
                            )),
                        maxLines: 15,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description for your Khatmul Quran';
                          }
                          return null;
                        },
                        onSaved: (value) => blurb = value),
                    Row(
                      children: <Widget>[
                        Text(
                          "Complete the Quran by",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.help),
                          onPressed: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            'Date chosen will be added to the template/invitation.\n',
                                            style: TextStyle(fontSize: 20)),
                                        Text(
                                          'If needed, date can be edited in the “Admin” section on the homepage',
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light().copyWith(
                                        primary: Color.fromRGBO(
                                            224, 208, 192, 1),
                                      ),
                                    ),
                                    child: child,
                                  );
                                });
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                                selectedDateText = selectedDate.day.toString() +
                                    " " +
                                    monthToString[selectedDate.month] +
                                    " " +
                                    selectedDate.year.toString();
                              });
                              print(selectedDate.day);
                              print(selectedDate.month);
                              print(selectedDate.year);
                            }
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                selectedDateText,
                                style: TextStyle(fontSize: 18),
                              ),
                              Icon(Icons.calendar_today)
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        color: Color.fromRGBO(224, 208, 192, 1),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false
                          // otherwise.

                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isInAsyncCall = true;
                            });


                            if (selectedDateText == " Select a date ") {
                              setState(() {
                                dateSelectionError = "sadsa";
                                _isInAsyncCall = false;
                              });
                            } else {
                              _formKey.currentState.save();

                              if (prayerName=="Khatmul Quran For ") {
                                Fluttertoast.showToast(
                                    msg: "Please enter prayer name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                setState(() {
                                  _isInAsyncCall = false;
                                });
                                return;
                              }
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Creating Khatmul Quran')));

                              final databaseReference = FirebaseFirestore
                                  .instance;
                              final databaseReference2 = FirebaseFirestore
                                  .instance;

                              DocumentReference ref = await databaseReference
                                  .collection("quranKhwani")
                                  .add({
                                'prayerName': prayerName,
                                'admin': FieldValue.arrayUnion([name]),
                                'blurb': blurb,
                                'juz': [],
                                'password': '',
                                'numComplete': 0,
                                'numDays': numDays,
                                'timeCreated': DateTime.now(),
                                'finishTime':
                                DateTime.now().add(Duration(days: numDays)),
                              });

                              print("nammmmmmmmmmmmmmmeeeeeeeeeeeee");
                              print(widget.name);

                              for (int i = 0; i < 31; i++) {
                                if (i == 0) {
                                  await FirebaseFirestore.instance
                                      .collection("quranKhwani")
                                      .doc(ref.id)
                                      .collection("juz")
                                      .add({
                                    "juzNumber": 0,
                                    "assignedUser": "none",
                                    "Status": "none",
                                    'started': false,
                                    'currentPage': 0,
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection("quranKhwani")
                                      .doc(ref.id)
                                      .collection("juz")
                                      .add({
                                    "juzNumber": i,
                                    "assignedUser": "none",
                                    "Status": "Available",
                                    'started': false,
                                    'currentPage': 0,
                                    'numDays': numDays
                                  });
                                }
                              }
                              await databaseReference
                                  .collection("quranKhwani")
                                  .doc((ref.id))
                                  .collection("admin")
                                  .add({'adminId': name});
                              bool isUnique = false;

                              while (isUnique == false) {
                                print("password no exiter pas 1");
                                String randomString = randomAlphaNumeric(5);
                                if (await databaseReference
                                    .collection("idGenrator")
                                    .where("passcode", isEqualTo: randomString)
                                    .snapshots()
                                    .isEmpty ==
                                    false) {
                                  print("password no exiter pas 24");
                                  await databaseReference
                                      .collection("quranKhwani")
                                      .doc(ref.id)
                                      .update({'password': randomString});
                                  await databaseReference
                                      .collection("idGenerator")
                                      .add({'passCode:': randomString});

                                  await databaseReference
                                      .collection("users")
                                      .doc(name)
                                      .collection("quranKhwani")
                                      .add({
                                    'prayerRoomId': ref.id,
                                    'roomName': prayerName,
                                    'password': randomString,
                                  }).catchError((onError) {
                                    print(onError.code);
                                    _isInAsyncCall = false;
                                  }).then((val) {
                                    print(
                                        "aaaaaaaaaaaaaaaaaaasdadsafsjfnadskfmasd" +
                                            val.id);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content:
                                        Text("Prayer Successfully Created"),
                                        duration: Duration(seconds: 3)));
                                    print("blurbbbbb" + blurb);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SharePrayer(
                                                  passCode: randomString,
                                                  name: name,
                                                  blurb: blurb,
                                                  dateCompletion: selectedDateText,
                                                )));
                                  }).catchError((onError) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "There was an error creating your prayer"),
                                        duration: Duration(seconds: 4)));
                                    Navigator.pop(context);
                                  });
                                  isUnique = true;
                                  return null;
                                }
                              }
                            }
                            // If the form is valid, display a Snackbar.

                          }
                        },
                        child: Text(
                          'Create Khatmul Quran ',
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    dateSelectionError == ""
                        ? Container()
                        : Text("Must Select a date!!")
                  ],
                ))));
  }
}
