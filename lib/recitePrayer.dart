import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pocketprayer2/juzText.dart';
import 'package:pocketprayer2/prayerAccept.dart';

List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  const StaggeredTile.count(6, 3),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
];

List<Widget> _tiles = <Widget>[
  Container(
      height: 600,
      width: 300,
      child: Card(
          key: ValueKey(1),
          child: Column(children: <Widget>[
            Expanded(child: Text("bar", style: TextStyle(fontSize: 28))),
            Spacer(flex: 2)
          ]))),
  const _Example01Tile(Colors.lightBlue, Icons.wifi),
  const _Example01Tile(Colors.amber, Icons.panorama_wide_angle),
  const _Example01Tile(Colors.brown, Icons.map),
  const _Example01Tile(Colors.deepOrange, Icons.send),
  const _Example01Tile(Colors.indigo, Icons.airline_seat_flat),
  const _Example01Tile(Colors.red, Icons.bluetooth),
  const _Example01Tile(Colors.pink, Icons.battery_alert),
  const _Example01Tile(Colors.purple, Icons.desktop_windows),
  const _Example01Tile(Colors.blue, Icons.radio),
];

class Example01 extends StatefulWidget {
  @override
  _Example01State createState() => _Example01State();

  Example01({this.name, this.docID, this.blurb, this.prayerName});

  String name;
  String docID;
  String blurb;
  String prayerName;
  bool isPrayerClicked = false;
  int currentJuz = 0;
  String username = "";
  final ScrollController _homeController = ScrollController();
  int prayerNum = 0;
}

class _Example01State extends State<Example01> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/DV38ZaXMQmaOR1ng-dbXcQ.jpg"),
              fit: BoxFit.cover,
            )),
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text('Khatmul Quran'),
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('quranKhwani')
                    .doc(widget.docID)
                    .collection("juz")
                    .orderBy("juzNumber")
                    .snapshots(),
                builder: (context, snapshot) {
                  return new StaggeredGridView.countBuilder(
                    crossAxisCount: 5,
                    scrollDirection: Axis.vertical,
                    itemCount: 31,
                    controller: widget._homeController,
                    itemBuilder: (BuildContext context, int index) =>
                        new Container(
                      height: 1900,
                      width: 1000,
                      color: index == 0
                          ? Colors.white70
                          : snapshot.data.docs[index]["Status"] ==
                                      "Available" &&
                                  index != 0
                              ? Colors.white
                              : snapshot.data.docs[index]["Status"] ==
                                          "Complete" &&
                                      index != 0
                                  ? Colors.green
                                  : Colors.yellowAccent,
                      child: index != 0
                          ? new Center(
                              child: Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                      width: 300,
                                      height: 300,
                                      child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.prayerNum = index;
                                              widget.isPrayerClicked = true;
                                              //show alert dialog here
                                            });
                                            DocumentSnapshot doc = snapshot
                                                .data.docs[widget.prayerNum];

                                            if (doc["assignedUser"] == "none") {
                                              return showDialog<void>(
                                                context: context,
                                                barrierDismissible: false,
                                                // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Assign Sipara' +
                                                            widget.prayerNum
                                                                .toString()),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text('You are selecting to pray sipara ' +
                                                              widget.prayerNum
                                                                  .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      RaisedButton(
                                                        child: Text('OK'),
                                                        onPressed: () async {
                                                          int juzNumber =
                                                              widget.prayerNum;
                                                          String name =
                                                              widget.name;
                                                          DocumentSnapshot doc =
                                                              snapshot.data
                                                                      .docs[
                                                                  widget
                                                                      .prayerNum];
                                                          String docID =
                                                              widget.docID;
                                                          print("daaaaaaaaaaaaaaaaaaaaaays" +
                                                              doc["currentPage"]
                                                                  .toString());
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "tasks")
                                                              .add({
                                                            'prayerId':
                                                                widget.docID,
                                                            'juzId': doc.id,
                                                            'status':
                                                                "scheduled",
                                                            'performAt': DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 2))
                                                          });
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "checkTime")
                                                              .add({
                                                            'prayerId':
                                                                widget.docID,
                                                            'juzId': doc.id,
                                                            'status':
                                                                "scheduled",
                                                            'performAt': DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    minutes: 1))
                                                          });

                                                          print(
                                                              "daaaaaaaaaaaaaaaaaaaaate");
                                                          print(DateTime.now()
                                                              .toUtc());
                                                          await doc.reference
                                                              .update({
                                                            'assignedUserId':
                                                                widget.name,
                                                            'Status':
                                                                "In Progress",
                                                            'assignedUser':
                                                                widget.name,
                                                            'timeAssigned':
                                                                FieldValue
                                                                    .serverTimestamp(),
                                                            'numDays': 700
                                                          });
                                                          DocumentSnapshot
                                                          page =
                                                          snapshot
                                                              .data
                                                              .docs[widget.prayerNum];
                                                          FirebaseFirestore.instance.collection("users").doc(widget.name).collection("userJuz").add({
                                                           'juzNumber':juzNumber,
                                                            'page' : page.data()['currentPage'],
                                                            'totalPages': page.data()['totalPage'],
                                                            'prayerName': widget.prayerName


                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      RaisedButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Opacity(
                                              opacity: 1.0,
                                              child: new Text(
                                                snapshot.data
                                                    .docs[index]["juzNumber"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black),
                                              ))))),
                            )
                          : widget.prayerNum == 0 ||
                                  snapshot.data.docs[widget.prayerNum]
                                          ["assignedUser"] ==
                                      "none"
                              ? Column(
                                  children: [
                                    Text(
                                      widget.prayerName + "\n",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    Text(
                                      widget.blurb,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    Row(children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black)),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text("\n Available juz\n"),
                                      Text("   "),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            border: Border.all(
                                                color: Colors.black)),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text("\n Assigned juz \n"),
                                      Text("   "),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(
                                                color: Colors.black)),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text("\n Complete juz \n")
                                    ]),
                                  ],
                                )
                              : new Center(
                                  child: Container(
                                      height: 900,
                                      width: 300,
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data.docs[widget.prayerNum]
                                                        ['Status'] ==
                                                    'Complete'
                                                ? "\nJazakallah Khair for participating in this Khatmul Quran"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          widget.isPrayerClicked == false
                                              ? Text("foo")
                                              : Column(children: <Widget>[
                                                  snapshot.data.docs[index]["assignedUser"] ==
                                                          widget.name
                                                      ? RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          ),
                                                          child: Text("Continue",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      28)),
                                                          onPressed: () async {
                                                            DocumentSnapshot
                                                                doc = snapshot
                                                                        .data
                                                                        .docs[
                                                                    widget
                                                                        .prayerNum];
                                                            if (doc['assignedUser'] !=
                                                                widget.name) {
                                                              print("user is" +
                                                                  doc['assignedUser']);
                                                            }
                                                          })
                                                      : snapshot.data.docs[widget.prayerNum]
                                                                  ['Status'] ==
                                                              'Complete'
                                                          ? RaisedButton(
                                                              child: Text("OK"),
                                                              onPressed: () =>
                                                                  Navigator.of(context).popUntil(
                                                                      (route) =>
                                                                          route
                                                                              .isFirst),
                                                              color:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  side: BorderSide(color: Color.fromRGBO(224, 123, 57, 1), width: 4),
                                                                  borderRadius: BorderRadius.circular(18.0)))
                                                          : widget.name == snapshot.data.docs[widget.prayerNum]["assignedUser"]
                                                              ? Column(children: <Widget>[
                                                                  Text(
                                                                    "Press“Start”to read Quran on the app or read on your own Quran\n",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  RaisedButton(
                                                                    color: Colors
                                                                        .white,
                                                                    child: Text(
                                                                      "  Start  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              28),
                                                                    ),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Color.fromRGBO(
                                                                              224,
                                                                              123,
                                                                              57,
                                                                              1),
                                                                          width:
                                                                              4),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      DocumentSnapshot
                                                                          page =
                                                                          snapshot
                                                                              .data
                                                                              .docs[widget.prayerNum];
                                                                      DocumentReference khatmulQuran = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "quranKhwani")
                                                                          .doc(widget
                                                                              .docID);
                                                                      final currentDate =
                                                                          DateTime
                                                                              .now();
                                                                      var finishTime;
                                                                      final foo = await khatmulQuran
                                                                          .snapshots()
                                                                          .first
                                                                          .then((value) =>
                                                                              finishTime = value.data()['finishTime']);
                                                                      print(
                                                                          "dataaa");
                                                                      Duration
                                                                          diff =
                                                                          currentDate
                                                                              .difference(finishTime.toDate());
                                                                      print("timeeee" +
                                                                          diff.inDays
                                                                              .toString());
                                                                      page.reference
                                                                          .update({
                                                                        'assignedUser':
                                                                            widget.name,
                                                                        'started':
                                                                            true
                                                                      });
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => JuzText(juzNumber: widget.prayerNum, snap: snapshot.data.docs[widget.prayerNum], currentPage: page.data()["currentPage"])));
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                  ),
                                                                  snapshot.data.docs[widget.prayerNum]
                                                                              [
                                                                              'Status'] !=
                                                                          'Complete'
                                                                      ? Text(
                                                                          'Press"Complete" when juz is finished',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        )
                                                                      : Text(
                                                                          "",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                  SizedBox(
                                                                      height:
                                                                          30,
                                                                      width:
                                                                          30),
                                                                  snapshot.data.docs[widget
                                                                                  .prayerNum]
                                                                              [
                                                                              'Status'] ==
                                                                          'Complete'
                                                                      ? RaisedButton(
                                                                          onPressed:
                                                                              null,
                                                                          child: Text(
                                                                              "Prayer has been completed"),
                                                                          color: Color.fromRGBO(
                                                                              162,
                                                                              159,
                                                                              155,
                                                                              1),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20.0),
                                                                          ))
                                                                      : RaisedButton(
                                                                          color:
                                                                              Colors.green,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(color: Colors.transparent, width: 4),
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0),
                                                                          ),
                                                                          child: Text(
                                                                              "Complete",
                                                                              style: TextStyle(fontSize: 28)),
                                                                          onPressed:
                                                                              () {
                                                                                return showDialog<void>(
                                                                                  context: context,
                                                                                  barrierDismissible: false, // user must tap button!
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      content: SingleChildScrollView(
                                                                                        child: ListBody(
                                                                                          children: <Widget>[
                                                                                            Text('I confirm I have completed this juz'),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      actions: <Widget>[
                                                                                        TextButton(
                                                                                          child: Text('OK'),
                                                                                          onPressed: () {
                                                                                            DocumentSnapshot
                                                                                            foo =
                                                                                            snapshot.data.docs[widget.prayerNum];
                                                                                            foo.reference.update({
                                                                                              'Status': 'Complete',
                                                                                            });
                                                                                            Navigator.of(context).pop();
                                                                                          },


                                                                                        ),
                                                                                    TextButton(
                                                                                    child: Text('Cancel'),
                                                                                    onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                    },
                                                                                    )],
                                                                                    );
                                                                                  },
                                                                                );
                                                                          },
                                                                        ),
                                                                ])
                                                              : snapshot.data.docs[widget.prayerNum]["assignedUser"] == "none"
                                                                  ? Text("")
                                                                  : Text(
                                                                      "Sipara has been Assigned",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    )
                                                ])
                                        ],
                                      )),
                                ),
                    ),
                    staggeredTileBuilder: (int index) => index != 0
                        ? new StaggeredTile.count(1, 1)
                        : StaggeredTile.count(5, 5.7),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  );
                })));
  }
}

class _Example01Tile extends StatefulWidget {
  const _Example01Tile(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  __Example01TileState createState() => __Example01TileState();
}

class __Example01TileState extends State<_Example01Tile> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      color: widget.backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Icon(
              widget.iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
